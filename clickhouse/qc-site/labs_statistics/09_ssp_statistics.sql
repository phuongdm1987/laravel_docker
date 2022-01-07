DROP TABLE IF EXISTS distributed_ssp_statistics;

CREATE TABLE distributed_ssp_statistics (
  received_date Date   DEFAULT CAST(now(), 'Date'),
  user_id       UInt64 DEFAULT CAST(0, 'UInt64'),
  campaign_id   UInt64 DEFAULT CAST(0, 'UInt64'),
  advert_id     UInt64 DEFAULT CAST(0, 'UInt64'),
  match_id      UInt64 DEFAULT CAST(0, 'UInt64'),
  status String,
  event_type String,
  ssp_name String,
  price AggregateFunction(sum, Float64),
  cnt_events AggregateFunction(sum, Int32)
) ENGINE = AggregatingMergeTree(received_date, (received_date, status, event_type, ssp_name, user_id, campaign_id, advert_id, match_id), 8192);

DROP TABLE IF EXISTS materialized_ssp_statistics ;
CREATE MATERIALIZED VIEW materialized_ssp_statistics TO distributed_ssp_statistics
AS
SELECT received_date,
  user_id,
  campaign_id,
  advert_id,
  match_id,
  status,
  event_type,
  ssp_name,
  sumState(price)        AS price,
  sumState(cnt_events) as cnt_events
FROM distributed_events
GROUP BY received_date, status, event_type, ssp_name, user_id, campaign_id, advert_id, match_id;

INSERT INTO distributed_ssp_statistics
  SELECT received_date,
    user_id,
    campaign_id,
    advert_id,
    match_id,
    status,
    event_type,
    ssp_name,
    sumState(price)        AS price,
    sumState(cnt_events)   AS cnt_events
  FROM distributed_events
  GROUP BY received_date, status, event_type, ssp_name, user_id, campaign_id, advert_id, match_id;

