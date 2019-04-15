-- tx_ringct_1_out.sql
-- Neptune Research 2019-04-12

-- tx_ringct_1_out: list {height, miner-reported timestamp, transaction index, transaction hash} for all RingCT transactions with 1 output
--   Note: the fact that tx.version = 2 only occurs after height 1220516 is used for extra speed
--   Create and load the view
CREATE MATERIALIZED VIEW tx_ringct_1_out
AS
  SELECT block.height,
    block.timestamp as mrt,
    row_number() over (partition by block) as tx_index,
    encode(tx.hash, 'hex') as tx_hash
  FROM monero block,
    LATERAL unnest(block.transactions) tx(hash, version, unlock_time, vin, vout, extra, fee)
  WHERE block.height >= 1220516 AND tx.version = 2 AND cardinality(tx.vout) = 1
  ORDER BY height ASC
WITH NO DATA;

REFRESH MATERIALIZED VIEW tx_ringct_1_out;

-- Get top height in table for reference
--  The bottom height for RingCT only is: 1220516
SELECT block."height" as height
FROM monero block
ORDER BY block."height" DESC
LIMIT 1;

-- Result: read view with readable MRT column "mrt_friendly"
SELECT 
  height, 
  mrt, 
  to_timestamp(mrt) AT TIME ZONE 'UTC' as mrt_friendly,
  tx_index,
  tx_hash
FROM tx_ringct_1_out;