DROP TABLE IF EXISTS labs_statistics.distributed_ssp_statistics;
CREATE TABLE labs_statistics.distributed_ssp_statistics
(
    received_date Date DEFAULT CAST(now(), 'Date'),
    publisher_id UInt64 DEFAULT CAST(0, 'UInt64'),
    website_id UInt64 DEFAULT CAST(0, 'UInt64'),
    ssp_name String,
    placement_id UInt64 DEFAULT CAST(0, 'UInt64'),
    price Float64,
    partner_price Float64,
    shows UInt64,
    clicks UInt64
)
    ENGINE = SummingMergeTree()
    PARTITION BY toYYYYMM(received_date)
    ORDER BY (received_date, publisher_id, website_id, ssp_name, placement_id)
    SETTINGS index_granularity = 8192;

DROP TABLE IF EXISTS labs_statistics.materialized_ssp_statistics;
CREATE MATERIALIZED VIEW IF NOT EXISTS labs_statistics.materialized_ssp_statistics TO labs_statistics.distributed_ssp_statistics
AS
SELECT received_date,
       publisher_id,
       website_id,
       ssp_name,
       placement_id,
       sum(price)              AS price,
       sum(partner_price)      AS partner_price,
       countIf(type = 'show')  AS shows,
       countIf(type = 'click') AS clicks
FROM labs_statistics.distributed_ssp_events
WHERE type IN ('click', 'show') AND status IN ('', 'VALID')
GROUP BY received_date, publisher_id, website_id, ssp_name, placement_id;

INSERT INTO labs_statistics.distributed_ssp_statistics
SELECT received_date,
       publisher_id,
       website_id,
       ssp_name,
       placement_id,
       sum(price)              AS price,
       sum(partner_price)      AS partner_price,
       countIf(type = 'show')  AS shows,
       countIf(type = 'click') AS clicks
FROM labs_statistics.distributed_ssp_events
WHERE type IN ('click', 'show') AND status IN ('', 'VALID')
GROUP BY received_date, publisher_id, website_id, ssp_name, placement_id;


DROP TABLE IF EXISTS labs_statistics.distributed_ssp_external_request_statistics;
CREATE TABLE labs_statistics.distributed_ssp_external_request_statistics
(
    received_date Date DEFAULT CAST(now(), 'Date'),
    publisher_id UInt64 DEFAULT CAST(0, 'UInt64'),
    website_id UInt64 DEFAULT CAST(0, 'UInt64'),
    placement_id UInt64 DEFAULT CAST(0, 'UInt64'),
    requests UInt64
)
    ENGINE = SummingMergeTree()
    PARTITION BY toYYYYMM(received_date)
        ORDER BY (received_date, publisher_id, website_id, placement_id)
        SETTINGS index_granularity = 8192;

DROP TABLE IF EXISTS labs_statistics.materialized_ssp_external_request_statistics;
CREATE MATERIALIZED VIEW IF NOT EXISTS labs_statistics.materialized_ssp_external_request_statistics TO labs_statistics.distributed_ssp_external_request_statistics
AS
SELECT received_date,
       publisher_id,
       website_id,
       placement_id,
       count(reqid_hash) AS requests
FROM labs_statistics.distributed_ssp_external_request_details
GROUP BY received_date, publisher_id, website_id, placement_id;

INSERT INTO labs_statistics.distributed_ssp_external_request_statistics
SELECT received_date,
       publisher_id,
       website_id,
       placement_id,
       count(reqid_hash) AS requests
FROM labs_statistics.distributed_ssp_external_request_details
GROUP BY received_date, publisher_id, website_id, placement_id;
