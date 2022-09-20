-- Drop kafka tables
DROP TABLE IF EXISTS kafka.moderation_moderation_queues;
DROP TABLE IF EXISTS kafka.moderation_moderator_actions;

-- Drop triggers tables
DROP TABLE IF EXISTS triggers.moderation_moderation_queues;
DROP TABLE IF EXISTS triggers.moderation_moderator_actions;

-- Create kafka tables
CREATE TABLE IF NOT EXISTS kafka.moderation_moderation_queues
    AS moderation.distributed_moderation_queues
        ENGINE = Kafka
            SETTINGS kafka_broker_list = 'kafka',
                kafka_topic_list = 'local_CH_moderation_etl_moderation_queues',
                kafka_group_name = 'local-moderation-to-clickhouse',
                kafka_format = 'JSONEachRow',
                kafka_row_delimiter = '\n',
                kafka_handle_error_mode = 'stream',
                kafka_max_block_size = 1048576;

CREATE TABLE IF NOT EXISTS kafka.moderation_moderator_actions
    AS moderation.distributed_moderator_actions
        ENGINE = Kafka
            SETTINGS kafka_broker_list = 'kafka',
                kafka_topic_list = 'local_CH_moderation_etl_moderator_actions',
                kafka_group_name = 'local-moderation-to-clickhouse',
                kafka_format = 'JSONEachRow',
                kafka_row_delimiter = '\n',
                kafka_handle_error_mode = 'stream',
                kafka_max_block_size = 1048576;

-- Create triggers tables
CREATE MATERIALIZED VIEW triggers.moderation_moderation_queues TO moderation.distributed_moderation_queues AS
SELECT *
FROM kafka.moderation_moderation_queues
WHERE length(_error) = 0;

CREATE MATERIALIZED VIEW triggers.moderation_moderator_actions TO moderation.distributed_moderator_actions AS
SELECT *
FROM kafka.moderation_moderator_actions
WHERE length(_error) = 0;

-- Create kafka errors table
CREATE MATERIALIZED VIEW moderation.moderation_queues_kafka_errors
            (
             `topic` String,
             `partition` Int64,
             `offset` Int64,
             `raw` String,
             `error` String
                )
            ENGINE = MergeTree
                ORDER BY (topic, partition, offset)
                SETTINGS index_granularity = 8192
AS
SELECT _topic       AS topic,
       _partition   AS partition,
       _offset      AS offset,
       _raw_message AS raw,
       _error       AS error
FROM kafka.moderation_moderation_queues
WHERE length(_error) > 0;

CREATE MATERIALIZED VIEW moderation.moderator_actions_kafka_errors
            (
             `topic` String,
             `partition` Int64,
             `offset` Int64,
             `raw` String,
             `error` String
                )
            ENGINE = MergeTree
                ORDER BY (topic, partition, offset)
                SETTINGS index_granularity = 8192
AS
SELECT _topic       AS topic,
       _partition   AS partition,
       _offset      AS offset,
       _raw_message AS raw,
       _error       AS error
FROM kafka.moderation_moderator_actions
WHERE length(_error) > 0;
