DROP TABLE IF EXISTS distributed_statistics ;

CREATE TABLE distributed_statistics (
  received_date Date   DEFAULT CAST(now(), 'Date'),
  user_id       UInt64 DEFAULT CAST(0, 'UInt64'),
  campaign_id   UInt64 DEFAULT CAST(0, 'UInt64'),
  advert_id     UInt64 DEFAULT CAST(0, 'UInt64'),
  match_id      UInt64 DEFAULT CAST(0, 'UInt64'),
  status String,
  event_type String,
  ssp_name String,
  app_id String,
  payment_type String DEFAULT '',
  placement_type String,
  position UInt8,
  placement_position String,
  price AggregateFunction(sum, Float64),
  bid AggregateFunction(sum, Float64),
  cnt_events AggregateFunction(sum, Int32)
) ENGINE = AggregatingMergeTree(received_date, (received_date, status, event_type, ssp_name, placement_type, position, placement_position, payment_type, user_id, campaign_id, advert_id, match_id), 8192);

DROP TABLE IF EXISTS materialized_statistics ;
CREATE MATERIALIZED VIEW materialized_statistics TO distributed_statistics
AS
SELECT received_date,
  user_id,
  campaign_id,
  advert_id,
  match_id,
  status,
  event_type,
  ssp_name,
  app_id,
  payment_type,
  placement_type,
  position,
  placement_position,
  sumState(price)        AS price,
  sumState(bid) AS bid,
  sumState(cnt_events) as cnt_events
FROM distributed_events
GROUP BY received_date, status, event_type, ssp_name, app_id, placement_type, position, placement_position, payment_type, user_id, campaign_id, advert_id, match_id;

INSERT INTO distributed_statistics
  SELECT received_date,
    user_id,
    campaign_id,
    advert_id,
    match_id,
    status,
    event_type,
    ssp_name,
    app_id,
    payment_type,
    placement_type,
    position,
    placement_position,
    sumState(price)        AS price,
    sumState(bid)        AS bid,
    sumState(cnt_events)   AS cnt_events
  FROM distributed_events
  GROUP BY received_date, status, event_type, ssp_name, app_id, placement_type, position, placement_position, payment_type, user_id, campaign_id, advert_id, match_id;

