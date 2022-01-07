DROP TABLE IF EXISTS distributed_spendings;

CREATE TABLE distributed_spendings
(
    `received_date` Date DEFAULT CAST(now(), 'Date'),
    `user_id` UInt64 DEFAULT CAST(0, 'UInt64'),
    `fraud_state` UInt8 DEFAULT 0,
    `drop_state` UInt8 DEFAULT 0,
    `status` String DEFAULT '',
    `price` AggregateFunction(sum, Float64)
) ENGINE = AggregatingMergeTree(received_date, (user_id, fraud_state, drop_state, status), 8192);

DROP TABLE IF EXISTS materialized_spendings;
CREATE MATERIALIZED VIEW materialized_spendings TO distributed_spendings
AS
SELECT received_date,
       user_id,
       fraud_state,
       drop_state,
       status,
       sumState(price) AS price
FROM `distributed_events`
GROUP BY received_date, user_id, fraud_state, drop_state, status;

INSERT INTO distributed_spendings
SELECT received_date,
       user_id,
       fraud_state,
       drop_state,
       status,
       sumState(price) AS price
FROM `distributed_events`
GROUP BY received_date, user_id, fraud_state, drop_state, status;
