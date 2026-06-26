# Vexon local node runbook

This runbook starts a local Vexon node and wallet after the binaries have been
built from the Vexon branches.

## Build

```sh
cd /Users/minxiangcai/Documents/HcashOrg/hcd
GO=/tmp/go/bin/go scripts/build-vexon-node.sh

cd /Users/minxiangcai/Documents/HcashOrg/hcwallet
GO=/tmp/go117/bin/go scripts/build-vexon-wallet.sh
```

## Create local config files

Choose strong private RPC credentials. Do not commit these files.

```sh
mkdir -p "$HOME/.vexond" "$HOME/.vexonwallet" "$HOME/.vexonctl"

cat > "$HOME/.vexond/vexond.conf" <<'EOF'
rpcuser=CHANGE_ME_RPC_USER
rpcpass=CHANGE_ME_RPC_PASS
rpclisten=127.0.0.1:18556
listen=127.0.0.1:18555
txindex=1
addrindex=1
EOF

cat > "$HOME/.vexonwallet/vexonwallet.conf" <<'EOF'
username=CHANGE_ME_RPC_USER
password=CHANGE_ME_RPC_PASS
rpclisten=127.0.0.1:18557
rpccert=~/.vexond/rpc.cert
EOF

cat > "$HOME/.vexonctl/vexonctl.conf" <<'EOF'
rpcuser=CHANGE_ME_RPC_USER
rpcpass=CHANGE_ME_RPC_PASS
rpcserver=127.0.0.1
rpccert=~/.vexond/rpc.cert
walletrpcserver=127.0.0.1
EOF
```

## Create the premine wallet

Create a fresh wallet and write down the seed offline. The seed controls the
planned 8,400,000 VEX premine.

```sh
/Users/minxiangcai/Documents/HcashOrg/hcwallet/bin/vexonwallet \
  --create \
  --appdata "$HOME/.vexonwallet"
```

## Start node and wallet

Use separate terminals.

```sh
/Users/minxiangcai/Documents/HcashOrg/hcd/bin/vexond \
  --configfile "$HOME/.vexond/vexond.conf"
```

```sh
/Users/minxiangcai/Documents/HcashOrg/hcwallet/bin/vexonwallet \
  --configfile "$HOME/.vexonwallet/vexonwallet.conf" \
  --appdata "$HOME/.vexonwallet" \
  --rpcconnect 127.0.0.1:18556
```

## Get the public premine address

```sh
/Users/minxiangcai/Documents/HcashOrg/hcd/bin/vexonctl \
  --configfile "$HOME/.vexonctl/vexonctl.conf" \
  --wallet \
  getnewaddress
```

Only copy the returned public `Vs...` address into `chaincfg/premine.go`.
Never copy wallet seed words, wallet database files, TLS private keys, or RPC
passwords into Git.
