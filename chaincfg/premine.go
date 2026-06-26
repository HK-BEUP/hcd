// Copyright (c) 2014 The btcsuite developers
// Copyright (c) 2015-2017 The Decred developers
// Copyright (c) 2018-2020 The Hc developers
// Use of this source code is governed by an ISC
// license that can be found in the LICENSE file.

package chaincfg

// BlockOneLedgerMainNet is the block one output ledger for the main
// network.
var BlockOneLedgerMainNet = []*TokenPayout{
	{Address: "VsbyU7TV7FeK54Jk5WkGHoYLfGu4fc78cQV", Amount: 840000000000000},
}

// BlockOneLedgerTestNet is the block one output ledger for the test
// network.
var BlockOneLedgerTestNet = []*TokenPayout{}

// BlockOneLedgerTestNet2 is the block one output ledger for the 2nd test
// network.
var BlockOneLedgerTestNet2 = []*TokenPayout{}

// BlockOneLedgerSimNet is the block one output ledger for the simulation
// network. See under "Hcd organization related parameters" in params.go
// for information on how to spend these outputs.
var BlockOneLedgerSimNet = []*TokenPayout{}
