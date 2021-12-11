DROP TABLE IF EXISTS labs_statistics.distributed_ssp_events;
CREATE TABLE IF NOT EXISTS labs_statistics.distributed_ssp_events
(
    received_date   Date    default toDate(received_time),
    type            String,
    publisher_id UInt64 DEFAULT 0,
    website_id UInt64,
    placement_id UInt64,
    received_time   DateTime,
    time            DateTime,
    price           Float64 default CAST(0, 'Float64'),
    partner_price   Float64 default CAST(0, 'Float64'),
    ssp_name        String  default '',
    status          LowCardinality(String) default ''
)
ENGINE = MergeTree()
PARTITION BY received_date
ORDER BY (received_date, type, ssp_name, publisher_id, website_id, placement_id, price, partner_price)
SETTINGS index_granularity = 8192;

DROP TABLE IF EXISTS labs_statistics.distributed_ssp_external_request_details;
CREATE TABLE IF NOT EXISTS labs_statistics.distributed_ssp_external_request_details
(
    received_date Date     default toDate(received_time),
    received_time DateTime default now(),
    reqid         String   default '',
    reqid_hash    UInt64   default cityHash64(reqid),
    publisher_id  UInt64   default 0,
    website_id       UInt64   default 0,
    placement_id  UInt64   default 0,
    app_id        String   default ''
)
    ENGINE = MergeTree()
    PARTITION BY received_date
    ORDER BY (received_date, publisher_id, website_id, placement_id, app_id)
    SETTINGS index_granularity = 8192;

