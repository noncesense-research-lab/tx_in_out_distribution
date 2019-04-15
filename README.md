# tx_in_out_distribution
Two distributions from the monero blockchain: 1) number of inputs per txn, 2) number of outputs.


## Versioned Distributions

Source file: ```tx_ringct_in_out_distribution.sql```

There are ```4105890``` transactions (version 1 and 2) up to height ```1800099```.

### RingCT (tx version 2) only (height range ```1220516 - 1800099```)

There are ```3191357``` RingCT (version 2) transactions up to height ```1800099```.

| File | Description |
| - | - |
| ```tx_ringct_distribution_in.csv``` | Number of RingCT transactions per transaction input size |
| ```tx_ringct_distribution_out.csv``` | Number of RingCT transactions per transaction output size |
| ```block_ringct_tx_count_zero.txt``` | Number of blocks with 0 transactions, height range ```1220516 - 1800099``` |

### Non-RingCT (tx version 1) only (height range ```0 - 1800099```)

There are ```914533``` Non-RingCT (version 1) transactions up to height ```1800099```.

| File | Description |
| - | - |
| ```tx_nonringct_distribution_in.csv``` | Number of non-RingCT transactions per transaction input size |
| ```tx_nonringct_distribution_out.csv``` | Number of non-RingCT transactions per transaction output size |
| ```block_preringct_tx_count_zero.txt``` | Number of blocks with 0 transactions, height range ```0 - 1220515``` |

## Unversioned Distribution

Source file: ```tx_in_out_distribution.sql```

There are ```4033981``` transactions (version 1 and 2) up to height ```1786599```.

### Entire blockchain to height ```1786599```

| File | Description |
| - | - |
| ```tx_distribution_in.csv``` | Number of transactions per transaction input size |
| ```tx_distribution_out.csv``` | Number of transactions per transaction output size |
| ```block_tx_count_zero.txt``` | Number of blocks with 0 transactions, up to ```1786599``` |
| ```tx_list_to_height_1786599.csv.gz``` | Transactions list, unversioned, up to ```1786599``` |

## Changelog

#### 4/14/2019 - RingCT 1-output
- ```tx_ringct_1_out```: Added transaction data for the ```2522``` RingCT transactions with 1 output, up to height ```1813199```.

#### 3/27/2019 - RingCT/Non-RingCT

- Added transaction version parameter: the distribution is now split between ```nonringct``` and ```ringct``` versioned sets.
- Updated to max height ```1800099```.

#### 3/7/2019 - Unversioned

- First release: unversioned distribution up to height ```1786599```.