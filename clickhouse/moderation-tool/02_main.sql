-- Create moderation_queues table
DROP TABLE IF EXISTS moderation.distributed_moderation_queues;
CREATE TABLE IF NOT EXISTS moderation.distributed_moderation_queues
(
    user_id             UInt64,
    campaign_id         Array(UInt64),
    advert_group_id     UInt64 DEFAULT 0,
    advert_id           UInt64 DEFAULT 0,
    object_id           UInt64,
    kind_of_object      String,
    object_type         String,
    queue_type          String,
    industry_id         Array(UInt64),
    category_id         Array(UInt64),
    queue_time          DateTime,
    queue_date          Date DEFAULT toDate(queue_time)
) ENGINE = MergeTree()
PARTITION BY toYYYYMM(queue_date)
ORDER BY (
    queue_date,
    kind_of_object,
    user_id,
    advert_group_id,
    advert_id,
    object_id,
    object_type,
    queue_type
)
SETTINGS index_granularity = 8192;

-- Consume to moderation_queues table
DROP TABLE IF EXISTS kafka.moderation_moderation_queues;
CREATE TABLE IF NOT EXISTS kafka.moderation_moderation_queues
AS moderation.distributed_moderation_queues
ENGINE = Kafka
SETTINGS kafka_broker_list = 'kafka',
    kafka_topic_list = 'local_CH_moderation_etl_moderation_queues',
    kafka_group_name = 'local-moderation-to-clickhouse',
    kafka_format = 'JSONEachRow',
    kafka_row_delimiter = '\n',
    kafka_skip_broken_messages = 1,
    kafka_max_block_size = 1048576;

DROP TABLE IF EXISTS triggers.moderation_moderation_queues;
CREATE MATERIALIZED VIEW triggers.moderation_moderation_queues TO moderation.distributed_moderation_queues AS
SELECT * FROM kafka.moderation_moderation_queues;

-- Create moderator_actions table
DROP TABLE IF EXISTS moderation.distributed_moderator_actions;
CREATE TABLE IF NOT EXISTS moderation.distributed_moderator_actions
(
    moderator_id        UInt64,
    user_id             UInt64,
    campaign_id         Array(UInt64),
    advert_group_id     UInt64 DEFAULT 0,
    advert_id           UInt64 DEFAULT 0,
    object_id           UInt64,
    kind_of_object      String,
    object_type         String,
    action              String,
    rejected_reason     Array(UInt64),
    industry_id         Array(UInt64),
    category_id         Array(UInt64),
    action_time         DateTime,
    action_date         Date DEFAULT toDate(action_time)
)
ENGINE = MergeTree()
PARTITION BY toYYYYMM(action_date)
ORDER BY (
    action_date,
    kind_of_object,
    action,
    moderator_id,
    user_id,
    advert_group_id,
    advert_id,
    object_id,
    object_type
)
SETTINGS index_granularity = 8192;

-- Consume to moderator_actions table
DROP TABLE IF EXISTS kafka.moderation_moderator_actions;
CREATE TABLE IF NOT EXISTS kafka.moderation_moderator_actions
AS moderation.distributed_moderator_actions
ENGINE = Kafka
SETTINGS kafka_broker_list = 'kafka',
    kafka_topic_list = 'local_CH_moderation_etl_moderator_actions',
    kafka_group_name = 'local-moderation-to-clickhouse',
    kafka_format = 'JSONEachRow',
    kafka_row_delimiter = '\n',
    kafka_skip_broken_messages = 1,
    kafka_max_block_size = 1048576;

DROP TABLE IF EXISTS triggers.moderation_moderator_actions;
CREATE MATERIALIZED VIEW triggers.moderation_moderator_actions TO moderation.distributed_moderator_actions AS
SELECT * FROM kafka.moderation_moderator_actions;
