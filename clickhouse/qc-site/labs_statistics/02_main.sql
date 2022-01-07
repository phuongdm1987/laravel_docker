DROP table  if exists distributed_events;
CREATE TABLE distributed_events
(
    received_date Date DEFAULT toDate(received_time),
    user_id UInt64 DEFAULT 0,
    campaign_id UInt64,
    group_id UInt64 DEFAULT advert_id,
    advert_id UInt64,
    match_id UInt64,
    event_type String,
    aloshow UInt8 DEFAULT 0,
    status String,
    placement_position String,
    placement_type String,
    banner_type String DEFAULT '',
    payment_type String DEFAULT '',
    charge_type_id UInt32 DEFAULT 0,
    received_time DateTime,
    schedule_targeting_id UInt64 DEFAULT 0,
    position UInt8,
    gps_lat Float32 DEFAULT 0,
    gps_lon Float32 DEFAULT 0,
    gps_proximity UInt32 DEFAULT 0,
    location_targeting_id UInt64 DEFAULT 0,
    user_category UInt32 DEFAULT 0,
    fraud_state UInt8 DEFAULT 0,
    drop_state UInt8 DEFAULT 0,
    impressions_before UInt32 DEFAULT 0,
    query String DEFAULT '',
    phrase_has_query UInt8 DEFAULT 0,
    test_marker String DEFAULT '',
    price Float64 DEFAULT 0.0,
    bid Float64 DEFAULT 0.0,
    source_app String DEFAULT '',
    competitors UInt8 DEFAULT 0,
    retargeting UInt8 DEFAULT 0,
    fallback UInt8 DEFAULT 0,
    sub_categories Array(UInt32) DEFAULT emptyArrayUInt32(),
    version String DEFAULT '',
    event_id UInt64 DEFAULT 0,
    cnt_events Int32 DEFAULT 1,
    app_id String DEFAULT '',
    extension_ids Array(UInt64),
    ssp_name String DEFAULT ''
) ENGINE = MergeTree(received_date, campaign_id, (user_id, campaign_id, advert_id, match_id, event_type, status, banner_type, placement_position, position, ssp_name, received_time, gps_lat, gps_lon, bid, event_id), 8192);

DROP TABLE IF EXISTS distributed_events_details;
CREATE TABLE distributed_events_details
(
    received_date Date,
    ip UInt32 DEFAULT 0,
    cookie String,
    user_categories Array(UInt32) DEFAULT emptyArrayUInt32(),
    reqid String DEFAULT '',
    search_time DateTime,
    event_id UInt64
) ENGINE = MergeTree(received_date, event_id, (ip, cookie, user_categories, reqid, search_time, event_id), 8192);
