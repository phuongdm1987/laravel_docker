DROP TABLE IF EXISTS distributed_campaign_statistics;

CREATE TABLE distributed_campaign_statistics
(
    `received_date`      Date   DEFAULT CAST(now(), 'Date'),
    `received_hour`      UInt8  DEFAULT CAST(0, 'UInt8'),
    `user_id`            UInt64 DEFAULT CAST(0, 'UInt64'),
    `campaign_id`        UInt64 DEFAULT CAST(0, 'UInt64'),
    `location_targeting_id`    UInt64 DEFAULT CAST(0, 'UInt64'),
    `schedule_targeting_id`    UInt64 DEFAULT CAST(0, 'UInt64'),
    `area_id`            Int8 default CAST(-1, 'Int8'),
    `province_id`        Int32 default CAST(-1, 'Int32'),
    `status`             String,
    `event_type`         String,
    `placement_type`     String,
    `position`           UInt8,
    `price`              AggregateFunction( sum, Float64),
    `bid`                AggregateFunction( sum, Float64),
    `cnt_events`         AggregateFunction( sum, Int32)
) ENGINE = AggregatingMergeTree(received_date, (received_date, status, event_type, received_hour, area_id, province_id, placement_type, position, user_id, campaign_id, location_targeting_id, schedule_targeting_id), 8192);

DROP TABLE IF EXISTS materialized_campaign_statistics;
CREATE MATERIALIZED VIEW materialized_campaign_statistics TO distributed_campaign_statistics AS
SELECT received_date,
       toHour(received_time)      AS `received_hour`,
       user_id,
       campaign_id,
       location_targeting_id,
       schedule_targeting_id,
       1 AS `area_id`,
       1027000000 AS `province_id`,
       status,
       event_type,
       placement_type,
       position,
       sumState(price)            AS `price`,
       sumState(bid)              AS `bid`,
       sumState(cnt_events)       as `cnt_events`
FROM distributed_events
GROUP BY received_date, status, event_type, received_hour, placement_type, position, user_id, campaign_id, location_targeting_id, schedule_targeting_id;

INSERT INTO distributed_campaign_statistics
SELECT received_date,
       toHour(received_time)      AS `received_hour`,
       user_id,
       campaign_id,
       location_targeting_id,
       schedule_targeting_id,
       1 AS `area_id`,
       1027000000 AS `province_id`,
       status,
       event_type,
       placement_type,
       position,
       sumState(price)            AS `price`,
       sumState(bid)              AS `bid`,
       sumState(cnt_events)       AS `cnt_events`
FROM distributed_events
GROUP BY received_date, status, event_type, received_hour, placement_type, position, user_id, campaign_id, location_targeting_id, schedule_targeting_id;

