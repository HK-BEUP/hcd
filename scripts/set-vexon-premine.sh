#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
	echo "usage: $0 VsPremineAddress [amount_atoms]" >&2
	echo "default amount_atoms: 840000000000000 (8,400,000 VEX)" >&2
	exit 2
fi

address="$1"
amount="${2:-840000000000000}"

if [[ ! "$address" =~ ^Vs[123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz]{20,}$ ]]; then
	echo "premine address must look like a Vexon P2PKH address beginning with Vs" >&2
	exit 2
fi

if [[ ! "$amount" =~ ^[0-9]+$ ]]; then
	echo "amount_atoms must be an integer" >&2
	exit 2
fi

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
premine_file="$repo_root/chaincfg/premine.go"

python3 - "$premine_file" "$address" "$amount" <<'PY'
import re
import sys
from pathlib import Path

path = Path(sys.argv[1])
address = sys.argv[2]
amount = sys.argv[3]

text = path.read_text()
replacement = (
    "var BlockOneLedgerMainNet = []*TokenPayout{\n"
    f'\t{{Address: "{address}", Amount: {amount}}},\n'
    "}"
)

text, count = re.subn(
    r"var BlockOneLedgerMainNet = \[\]\*TokenPayout\{(?:.|\n)*?\}",
    replacement,
    text,
    count=1,
)

if count != 1:
    raise SystemExit("could not find BlockOneLedgerMainNet in chaincfg/premine.go")

path.write_text(text)
PY

gofmt_bin="${GOFMT:-gofmt}"
if ! command -v "$gofmt_bin" >/dev/null 2>&1 && [ -x /tmp/go/bin/gofmt ]; then
	gofmt_bin=/tmp/go/bin/gofmt
fi

"$gofmt_bin" -w "$premine_file"

echo "Updated $premine_file"
echo "Premine address: $address"
echo "Premine atoms:   $amount"
