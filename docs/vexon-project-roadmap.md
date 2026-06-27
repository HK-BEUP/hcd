# Vexon project roadmap

This checklist tracks the work required to turn the current Vexon fork into a
launchable project.

## Phase 1: Core Chain Foundation

Status: in progress.

- [x] Define coin name, ticker, ports, supply, block time, and reward schedule.
- [x] Set Vexon address prefixes beginning with `V`.
- [x] Add 8,400,000 VEX premine ledger.
- [x] Build `vexond` and `vexonctl`.
- [x] Verify simnet block-one premine output.
- [x] Add repeatable simnet verification script.
- [x] Refresh genesis snapshot tests.
- [ ] Decide whether current mainnet genesis hash is final.
- [ ] Mine/freeze final mainnet genesis nonce if a stricter launch difficulty is required.
- [ ] Decide whether testnet uses public 150-second spacing or faster staging parameters.

## Phase 2: Wallet

Status: in progress.

- [x] Build `vexonwallet`.
- [x] Disable Omni by default for development builds.
- [x] Sync Vexon chain parameters into the wallet vendor tree.
- [x] Verify V address generation.
- [x] Create the premine wallet and public premine address.
- [ ] Replace remaining user-facing `hcwallet`/`hcd` text with Vexon names.
- [ ] Add wallet release instructions.
- [ ] Add wallet backup and restore runbook.

## Phase 3: Mining Pool

Status: pending.

- [ ] Fork/update YiiMP stratum branding for VEX.
- [ ] Add VEX coin config and ports.
- [ ] Confirm Blake256r14 share validation against Vexon block templates.
- [ ] Confirm WhatsMiner D1 connects and submits shares.
- [ ] Confirm pool accepts found blocks on simnet/testnet.
- [ ] Add production deployment script for the pool.

Known stable HC pool settings from the previous pool work:

```ini
difficulty = 256
decred_relaxed_extranonce = 1
decred_block_submit_diff = 5123055
include = HC
```

These are historical HC/YiiMP notes and must be adapted for VEX chain
difficulty and coin config before production use.

## Phase 4: Network Launch Infrastructure

Status: pending.

- [ ] Prepare at least two seed nodes.
- [ ] Configure `seed.vexonus.com`.
- [ ] Configure `testnet-seed.vexonus.com`.
- [ ] Prepare firewall and process supervision for `vexond`.
- [ ] Create release binaries and checksums.
- [ ] Tag the first private testnet release.
- [ ] Publish launch notes.

## Phase 5: Explorer and Operations

Status: pending.

- [ ] Fork/update explorer branding and chain params.
- [ ] Add VEX units and address prefixes.
- [ ] Index simnet/testnet blocks.
- [ ] Add supply and premine transparency page.
- [ ] Add operational backup procedures.
- [ ] Add monitoring for node height, peers, and pool block submission.

## Mainnet Freeze Requirements

Before public mainnet, all of these must be true:

- `go test ./chaincfg` passes.
- `scripts/verify-vexon-simnet.sh` passes.
- Premine address is confirmed and backed up offline.
- Mainnet genesis hash is intentionally frozen.
- Wallet can sync to a fresh node and display balances.
- Pool can mine on testnet/simnet without rejected valid blocks.
- Seed DNS records resolve to stable nodes.
- Release binaries are reproducible enough for private audit.
