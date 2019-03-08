-- tx_in_out_distribution - Distributions of Monero transaction inputs and outputs
-- Author: Neptune Research 
-- Version: 2019-03-07

-- Create and load the view
-- Note: the FROM clause joins each block on its transactions, so rows will only appear for blocks with cardinality(tx) > 0:
--   thus this will not show cardinality(tx.vin)=0 for cardinality(tx)=0
CREATE MATERIALIZED VIEW tx_in_out_distribution AS (
    SELECT block.height, cardinality(tx.vin) as n_vin, cardinality(tx.vout) as n_vout
    FROM monero block, UNNEST(block.transactions) tx
	ORDER BY block.height ASC
) WITH NO DATA;

REFRESH MATERIALIZED VIEW tx_in_out_distribution;

-- Get current top height of blockchain
SELECT block."height" as height
FROM monero block
ORDER BY block."height" DESC
LIMIT 1;

-- Save the transaction list: tx_list_to_height_{TopHeight}.csv
SELECT *
FROM tx_in_out_distribution
ORDER BY height ASC;

-- RESULT 1 - Number of transactions per input size > 0: tx_distribution_in.csv
SELECT n_vin, COUNT(height)
FROM tx_in_out_distribution
GROUP BY n_vin
ORDER BY n_vin ASC;

-- RESULT 2 - Number of transactions per output size > 0: tx_distribution_out.csv
SELECT n_vout, COUNT(height)
FROM tx_in_out_distribution
GROUP BY n_vout
ORDER BY n_vout ASC;

-- Count blocks with no transactions: tx_distribution_in_zero.txt
-- This result is manually inserted into RESULT 1 for the n = 0 case
SELECT COUNT(*)
FROM monero block
WHERE cardinality(block.transactions) = 0;