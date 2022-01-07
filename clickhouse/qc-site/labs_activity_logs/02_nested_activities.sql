CREATE TABLE IF NOT EXISTS distributed_activities
(
    id                 String,
    context_user_id    UInt64,
    action_user_id     UInt64,
    action             LowCardinality(String),
    object_type        LowCardinality(String),
    object_count       UInt16 DEFAULT 0,
    summary_text       String DEFAULT '',
    parent_activity_id String DEFAULT '',
    object_id          UInt64 DEFAULT 0,
    status             LowCardinality(String) DEFAULT '',
    error_code         UInt32 DEFAULT 0,
    error_message      LowCardinality(String) DEFAULT '',
    ip_address         String DEFAULT '',
    action_time        DateTime,
    action_date        Date DEFAULT toDate(action_time),
    details            Nested
    (
        field          String,
        value          Nullable(String)
    )
) ENGINE  = MergeTree()
    ORDER BY (action_date, action, object_type, error_code, context_user_id, action_user_id, object_id, parent_activity_id, id)
    PARTITION BY toYYYYMM(action_date);

-- Consume to distributed_activities table
CREATE TABLE IF NOT EXISTS kafka_activity_consumer
(
    id                 String,
    context_user_id    UInt64,
    action_user_id     UInt64,
    action             LowCardinality(String),
    object_type        LowCardinality(String),
    object_count       UInt16 DEFAULT 0,
    summary_text       String DEFAULT '',
    parent_activity_id String DEFAULT '',
    object_id          UInt64 DEFAULT 0,
    status             LowCardinality(String) DEFAULT '',
    error_code         UInt32 DEFAULT 0,
    error_message      LowCardinality(String) DEFAULT '',
    ip_address         String DEFAULT '',
    action_time        DateTime,
    action_date        Date DEFAULT toDate(action_time),
    details            Nested
    (
        field          String,
        value          Nullable(String)
    )
) ENGINE = Kafka
    SETTINGS kafka_broker_list = 'kafka:9092',
        kafka_topic_list = 'CH_activity_logs_etl_activity',
        kafka_group_name = 'activity-logs-to-clickhouse',
        kafka_format = 'JSONEachRow',
        kafka_max_block_size = 1048576;

CREATE MATERIALIZED VIEW IF NOT EXISTS materialized_kafka_activity_consumer TO distributed_activities AS
SELECT * FROM kafka_activity_consumer;
