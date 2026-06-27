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

- Recalculate and freeze final genesis nonce/hash after mainnet parameters are
  final.
- Update wallet, RPC tool, explorer, and YiiMP stratum repos to use Vexon names,
  ports, units, and address prefixes.
- Decide whether testnet should keep 150-second spacing or use faster private
  testing parameters before public launch.

## Completed local validation

- Premine address:
  `VsbyU7TV7FeK54Jk5WkGHoYLfGu4fc78cQV`
- Mainnet and simnet block-one ledgers include 8,400,000 VEX to that address.
- Simnet is aligned with Vexon address prefixes and PoW-only reward proportions
  for local development.
- CPU `generate 1` on simnet has been verified to mine block 1 and place the
  premine output in the block-one transaction.
- `go test ./chaincfg` passes with Vexon genesis snapshots.

## Current genesis snapshot

These values identify the current Vexon chain parameters and should change only
when the chain is intentionally reset.

| Network | Genesis hash | Merkle root | Bits | Timestamp |
| --- | --- | --- | --- | --- |
| mainnet | `bfc6a2f825d38f4973b90778b4a7ec9a9b36e368c471f5177181eb71a878603b` | `208b9a19a2d44f197a62bac7dc511b49a43a1e62222b740dfa67f6097fdf94e8` | `1e00ffff` | `1782518400` |
| testnet2 | `c8a883d1f85ba48a46fd004297261c3132055e48c95767922357ee93ea69ca2c` | `a216ea043f0d481a072424af646787794c32bcefd3ed181a090319bbf8a37105` | `1e00ffff` | `1782518400` |
| simnet | `a088d3a739e107f016a01e46e60c644c97ed0d4fb5336f8784a4a042a2d5baf0` | `208b9a19a2d44f197a62bac7dc511b49a43a1e62222b740dfa67f6097fdf94e8` | `207fffff` | `1401292357` |

## Premine address workflow

The mainnet premine is planned as 8,400,000 VEX. Generate the premine address
only from a wallet seed that you control and have backed up offline.

1. Build the Vexon wallet from the matching `hcwallet` branch.
2. Create a fresh wallet and write down the seed before using it.
3. Start `vexond` and `vexonwallet` on localhost.
4. Run `vexonctl --wallet getnewaddress` and use the returned `Vs...` address
   as the premine destination.
5. Add that public address to `chaincfg/premine.go`:

   ```sh
   scripts/set-vexon-premine.sh VsYourPremineAddressHere
   ```

   Do not commit wallet seed words, wallet databases, RPC passwords, TLS keys,
   or backup archives.

## Local verification

Install Go 1.13+ first. On macOS, one simple path is:

```sh
brew install go
```

Then run:

```sh
cd /Users/minxiangcai/Documents/HcashOrg/hcd
chmod +x scripts/build-vexon-node.sh
GO=/tmp/go/bin/go scripts/build-vexon-node.sh
```

The repository still contains old helper commands that require incomplete
upstream dependencies, so verify Vexon node work with the main package and the
tools that are actively being forked.

The script writes:

```text
bin/vexond
bin/vexonctl
```

Run the local simnet verification:

```sh
scripts/verify-vexon-simnet.sh
```
