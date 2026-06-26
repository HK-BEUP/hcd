#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
out_dir="${1:-"$repo_root/bin"}"

mkdir -p "$out_dir"

go_bin="${GO:-go}"
gocache="${GOCACHE:-/tmp/vexon-gocache}"
gopath="${GOPATH:-/tmp/vexon-gopath-mod}"

echo "Building vexond and vexonctl into $out_dir"
(
	cd "$repo_root"
	GOCACHE="$gocache" GOPATH="$gopath" "$go_bin" build -o "$out_dir/vexond" .
	GOCACHE="$gocache" GOPATH="$gopath" "$go_bin" build -o "$out_dir/vexonctl" ./cmd/hcctl
)

"$out_dir/vexond" --version || true
"$out_dir/vexonctl" --version || true

echo "Done."
