#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
bin_dir="${BIN_DIR:-"$repo_root/bin"}"
vexond="$bin_dir/vexond"
vexonctl="$bin_dir/vexonctl"
premine_address="${VEXON_PREMINE_ADDRESS:-VsbyU7TV7FeK54Jk5WkGHoYLfGu4fc78cQV}"
premine_value="${VEXON_PREMINE_VALUE:-8400000}"
rpc_user="${VEXON_RPC_USER:-vexonrpc}"
rpc_pass="${VEXON_RPC_PASS:-vexonrpcpass_change_later}"
rpc_port="${VEXON_SIMNET_RPC_PORT:-$((23000 + ($$ % 1000)))}"
p2p_port="${VEXON_SIMNET_P2P_PORT:-$((24000 + ($$ % 1000)))}"
appdata="$(mktemp -d "${TMPDIR:-/tmp}/vexon-simnet.XXXXXX")"
node_pid=""

cleanup() {
	if [ -n "$node_pid" ] && kill -0 "$node_pid" >/dev/null 2>&1; then
		kill "$node_pid" >/dev/null 2>&1 || true
		wait "$node_pid" >/dev/null 2>&1 || true
	fi
	rm -rf "$appdata"
}
trap cleanup EXIT

if [ ! -x "$vexond" ] || [ ! -x "$vexonctl" ]; then
	GO="${GO:-go}" "$repo_root/scripts/build-vexon-node.sh" "$bin_dir"
fi

"$vexond" \
	--simnet \
	--appdata "$appdata" \
	-u "$rpc_user" \
	-P "$rpc_pass" \
	--rpclisten "127.0.0.1:$rpc_port" \
	--listen "127.0.0.1:$p2p_port" \
	--miningaddr "$premine_address" \
	--debuglevel info \
	> "$appdata/vexond.log" 2>&1 &
node_pid="$!"

for _ in $(seq 1 80); do
	if [ -f "$appdata/rpc.cert" ] && "$vexonctl" \
		--simnet \
		--rpcserver "127.0.0.1:$rpc_port" \
		--rpccert "$appdata/rpc.cert" \
		-u "$rpc_user" \
		-P "$rpc_pass" \
		getblockcount >/dev/null 2>&1; then
		break
	fi
	sleep 0.25
done

"$vexonctl" \
	--simnet \
	--rpcserver "127.0.0.1:$rpc_port" \
	--rpccert "$appdata/rpc.cert" \
	-u "$rpc_user" \
	-P "$rpc_pass" \
	getblockcount >/dev/null

generated="$("$vexonctl" \
	--simnet \
	--rpcserver "127.0.0.1:$rpc_port" \
	--rpccert "$appdata/rpc.cert" \
	-u "$rpc_user" \
	-P "$rpc_pass" \
	generate 1)"

block_hash="$(printf '%s\n' "$generated" | grep -Eo '[0-9a-f]{64}' | head -1)"
if [ -z "$block_hash" ]; then
	echo "failed to parse generated block hash" >&2
	echo "$generated" >&2
	exit 1
fi

height="$("$vexonctl" \
	--simnet \
	--rpcserver "127.0.0.1:$rpc_port" \
	--rpccert "$appdata/rpc.cert" \
	-u "$rpc_user" \
	-P "$rpc_pass" \
	getblockcount)"

block_json="$("$vexonctl" \
	--simnet \
	--rpcserver "127.0.0.1:$rpc_port" \
	--rpccert "$appdata/rpc.cert" \
	-u "$rpc_user" \
	-P "$rpc_pass" \
	getblock "$block_hash")"

txid="$(printf '%s\n' "$block_json" | awk '/"tx":/{getline; gsub(/[", ]/, ""); print; exit}')"
raw_json="$("$vexonctl" \
	--simnet \
	--rpcserver "127.0.0.1:$rpc_port" \
	--rpccert "$appdata/rpc.cert" \
	-u "$rpc_user" \
	-P "$rpc_pass" \
	getrawtransaction "$txid" 1)"

if ! printf '%s\n' "$raw_json" | grep -q "\"$premine_address\""; then
	echo "premine address not found in block-one transaction" >&2
	exit 1
fi

if ! printf '%s\n' "$raw_json" | grep -q "\"value\": $premine_value"; then
	echo "premine value $premine_value not found in block-one transaction" >&2
	exit 1
fi

echo "Vexon simnet verification passed"
echo "height:         $height"
echo "block_hash:     $block_hash"
echo "premine_addr:   $premine_address"
echo "premine_value:  $premine_value"
