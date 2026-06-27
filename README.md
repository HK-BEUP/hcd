# Vexon Core

Vexon Core is the reference full node for Vexon (VEX), a Blake256r14
ASIC-mined chain designed for WhatsMiner D1-class hardware.

This repository is derived from the Hcash/Decred codebase and is being
converted into an independent Vexon network implementation.

## Current Status

Vexon Core is in private development. Do not run this code as a public mainnet
until the launch checklist in [docs/vexon-project-roadmap.md](docs/vexon-project-roadmap.md)
is complete.

Completed so far:

- Vexon mainnet and testnet port assignments.
- Vexon address prefixes beginning with `V`.
- 84,000,000 VEX supply plan.
- 8,400,000 VEX block-one premine ledger.
- PoW-only reward proportions for the first release.
- Local simnet development chain that mines block 1 and verifies the premine.
- Build scripts for `vexond` and `vexonctl`.

## Network Draft

| Item | Value |
| --- | --- |
| Coin | Vexon |
| Ticker | VEX |
| Website | vexonus.com |
| Algorithm | Blake256r14 |
| Block time | 150 seconds |
| Initial subsidy | 50 VEX |
| Halving interval | 420,000 blocks |
| Total supply target | 84,000,000 VEX |
| Premine | 8,400,000 VEX |
| Mainnet P2P/RPC | 18555 / 18556 |
| Testnet P2P/RPC | 28555 / 28556 |

See [VEXON.md](VEXON.md) for the current chain parameter snapshot.

## Build

The node uses Go modules. On this development machine the supported Go binary
is installed at `/tmp/go/bin/go`.

```sh
cd /Users/minxiangcai/Documents/HcashOrg/hcd
GO=/tmp/go/bin/go scripts/build-vexon-node.sh
```

The build writes:

```text
bin/vexond
bin/vexonctl
```

## Verify

Run the package tests for chain parameters and genesis snapshots:

```sh
/tmp/go/bin/go test ./chaincfg
```

Run the full local simnet premine verification:

```sh
GO=/tmp/go/bin/go scripts/verify-vexon-simnet.sh
```

Expected result:

```text
Vexon simnet verification passed
premine_addr:   VsbyU7TV7FeK54Jk5WkGHoYLfGu4fc78cQV
premine_value:  8400000
```

## Local Development

For local node and wallet startup commands, see:

- [docs/vexon-localnet.md](docs/vexon-localnet.md)

For project readiness work, see:

- [docs/vexon-project-roadmap.md](docs/vexon-project-roadmap.md)

## Security Notes

Never commit or publish:

- wallet seeds or wallet databases
- RPC passwords
- TLS private keys
- pool backup archives
- blockchain data directories

The current premine address is public:

```text
VsbyU7TV7FeK54Jk5WkGHoYLfGu4fc78cQV
```

The wallet seed controlling that address must remain offline and private.

## License

This code is derived from Hcash/Decred/btcd components and remains under the
ISC license used by the upstream project.
