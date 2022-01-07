DROP TABLE IF EXISTS distributed_extension_statistics;

CREATE TABLE distributed_extension_statistics (
  received_date Date   DEFAULT CAST(now(), 'Date'),
  user_id       UInt64 DEFAULT CAST(0, 'UInt64'),
  campaign_id   UInt64 DEFAULT CAST(0, 'UInt64'),
  advert_id     UInt64 DEFAULT CAST(0, 'UInt64'),
  extension_id      UInt64 DEFAULT CAST(0, 'UInt64'),
  status String,
  event_type String,
  app_id String,
  payment_type String DEFAULT '',
  placement_type String,
  position UInt8,
  placement_position String,
  price AggregateFunction(sum, Float64),
  bid AggregateFunction(sum, Float64),
  cnt_events AggregateFunction(sum, Int32)
) ENGINE = AggregatingMergeTree(received_date, (received_date, status, event_type, app_id, placement_type, position, placement_position, payment_type, user_id, campaign_id, advert_id, extension_id), 8192);

DROP TABLE IF EXISTS materialized_extension_statistics;
CREATE MATERIALIZED VIEW materialized_extension_statistics TO distributed_extension_statistics
AS
SELECT received_date,
  user_id,
  campaign_id,
  advert_id,
  extension_id,
  status,
  event_type,
  app_id,
  payment_type,
  placement_type,
  position,
  placement_position,
  sumState(price)    AS price,
  sumState(bid)      AS bid,
  sumState(cnt_events) AS cnt_events
FROM distributed_events
    ARRAY JOIN extension_ids AS extension_id
GROUP BY received_date, status, event_type, app_id, placement_type, position, placement_position, payment_type, user_id, campaign_id, advert_id, extension_id;

INSERT INTO distributed_extension_statistics
  SELECT received_date,
    user_id,
    campaign_id,
    advert_id,
    extension_id,
    status,
    event_type,
    app_id,
    payment_type,
    placement_type,
    position,
    placement_position,
    sumState(price)        AS price,
    sumState(bid)          AS bid,
    sumState(cnt_events)   AS cnt_events
  FROM distributed_events
    ARRAY JOIN extension_ids AS extension_id
  GROUP BY received_date, status, event_type, app_id, placement_type, position, placement_position, payment_type, user_id, campaign_id, advert_id, extension_id;

