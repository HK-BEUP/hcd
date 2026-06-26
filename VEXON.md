# Vexon chain notes

This branch starts the `hcd` fork work for Vexon (VEX), a Blake256r14 ASIC
chain intended to be mined by WhatsMiner D1 hardware.

## Current parameter draft

- Coin name: Vexon
- Ticker: VEX
- Website domain: vexonus.com
- PoW algorithm target: Blake256r14 / Decred-style work
- Block interval: 150 seconds
- Initial block subsidy: 50 VEX
- Subsidy reduction: 50% every 420,000 blocks
- Base unit: 1 VEX = 100,000,000 atoms
- Coinbase maturity: 100 blocks
- Mainnet P2P port: 18555
- Mainnet node RPC port: 18556
- Mainnet wallet RPC port: 18557
- Testnet P2P port: 28555
- Testnet node RPC port: 28556
- Testnet wallet RPC port: 28557
- Mainnet DNS seed: seed.vexonus.com
- Testnet DNS seed: testnet-seed.vexonus.com
- Mainnet address prefix: V
- Default data directory: vexond
- Default config file: vexond.conf
- Default control config file: vexonctl.conf

## Implementation notes

The upstream codebase is HC/Decred-derived and still contains staking,
ticketing, voting, and governance code paths. This first branch avoids a risky
large removal by:

- giving 100% of block subsidy to PoW miners (`Work/Stake/Tax = 10/0/0`);
- setting stake activation/validation heights far into the future;
- clearing the old HC block-one ledger addresses;
- replacing network magic values so Vexon nodes do not connect to HC nodes.

The final pure-PoW cleanup should be done after the first private testnet can
mine blocks reliably.

## Pending decisions

- Generate a real VEX premine address after the wallet fork is updated.
- Add the 8,400,000 VEX premine ledger entry to `chaincfg/premine.go`.
- Recalculate and freeze final genesis nonce/hash after mainnet parameters are
  final.
- Update wallet, RPC tool, explorer, and YiiMP stratum repos to use Vexon names,
  ports, units, and address prefixes.
- Decide whether testnet should keep 150-second spacing or use faster private
  testing parameters before public launch.

## Premine address workflow

The mainnet premine is planned as 8,400,000 VEX. Generate the premine address
only from a wallet seed that you control and have backed up offline.

1. Build the Vexon wallet from the matching `hcwallet` branch.
2. Create a fresh wallet and write down the seed before using it.
3. Start `vexond` and `vexonwallet` on localhost.
4. Run `vexonctl --wallet getnewaddress` and use the returned `Vs...` address
   as the premine destination.
5. Add that public address to `chaincfg/premine.go`. Do not commit wallet seed
   words, wallet databases, RPC passwords, TLS keys, or backup archives.

## Local verification

Install Go 1.13+ first. On macOS, one simple path is:

```sh
brew install go
```

Then run:

```sh
cd /Users/minxiangcai/Documents/HcashOrg/hcd
gofmt -w chaincfg/params.go chaincfg/genesis.go chaincfg/premine.go wire/protocol.go hcutil/amount.go config.go server.go mining.go log.go
go build .
go build ./cmd/hcctl
```

The repository still contains old helper commands that require incomplete
upstream dependencies, so verify Vexon node work with the main package and the
tools that are actively being forked.
