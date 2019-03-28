-- tx_ringct_in_out_distribution.sql
-- Neptune Research 2019-03-25

-- tx_version_in_out_count: list {version, input count, output count} for all transactions in all blocks
--   Create and load the view
--   Note: the FROM clause joins each block on its transactions, so rows will only appear for blocks with cardinality(block.transactions) > 0
CREATE MATERIALIZED VIEW tx_version_in_out_count AS (
    SELECT block.height, tx.version as tx_version, cardinality(tx.vin) as n_vin, cardinality(tx.vout) as n_vout
    FROM monero block, UNNEST(block.transactions) tx
	ORDER BY block.height ASC
) WITH NO DATA;

REFRESH MATERIALIZED VIEW tx_version_in_out_count;

-- Get top height in table for reference
--  The bottom height for RingCT only is: 1220516
SELECT block."height" as height
FROM monero block
ORDER BY block."height" DESC
LIMIT 1;

-- Save the full transaction list: tx_version_in_out_count_maxheight{TopHeight}.csv
SELECT *
FROM tx_version_in_out_count
ORDER BY height ASC;

-- Results:
--   NON-RINGCT-IN - Number of Version 1 transactions per input size > 0: tx_nonringct_count_in.csv
SELECT n_vin, COUNT(height)
FROM tx_version_in_out_count
WHERE tx_version = 1
GROUP BY n_vin
ORDER BY n_vin ASC;

--   NON-RINGCT-OUT - Number of Version 1 transactions per output size > 0: tx_nonringct_count_out.csv
SELECT n_vout, COUNT(height)
FROM tx_version_in_out_count
WHERE tx_version = 1
GROUP BY n_vout
ORDER BY n_vout ASC;

--   RINGCT-IN - Number of Version 2 transactions per input size > 0: tx_ringct_count_in.csv
SELECT n_vin, COUNT(height)
FROM tx_version_in_out_count
WHERE tx_version = 2
GROUP BY n_vin
ORDER BY n_vin ASC;

--   RINGCT-OUT - Number of Version 2 transactions per output size > 0: tx_ringct_count_out.csv
SELECT n_vout, COUNT(height)
FROM tx_version_in_out_count
WHERE tx_version = 2
GROUP BY n_vout
ORDER BY n_vout ASC;

-- Count blocks with no transactions
--   Since there are no transaction, there is no transaction version,
--   so use the RingCT height 1220516 to divide the chain between Pre-RingCT and RingCT.

--   Number of Pre-RingCT blocks with no transactions: block_preringct_tx_count_zero.txt
SELECT COUNT(*)
FROM monero block
WHERE cardinality(block.transactions) = 0
AND block.height < 1220516

--   Number of RingCT blocks with no transactions: block_ringct_tx_count_zero.txt
SELECT COUNT(*)
FROM monero block
WHERE cardinality(block.transactions) = 0
AND block.height >= 1220516

-- Count transactions per version
--   Non-RingCT
SELECT COUNT(*)
FROM tx_version_in_out_count
WHERE tx_version = 1;

--   RingCT
SELECT COUNT(*)
FROM tx_version_in_out_count
WHERE tx_version = 2;

--   Both versions
SELECT COUNT(*)
FROM tx_version_in_out_count;