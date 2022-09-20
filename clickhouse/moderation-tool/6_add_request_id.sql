-- Drop kafka tables
DROP TABLE IF EXISTS kafka.moderation_moderation_queues;
DROP TABLE IF EXISTS kafka.moderation_moderator_actions;

-- Drop triggers tables
DROP TABLE IF EXISTS triggers.moderation_moderation_queues;
DROP TABLE IF EXISTS triggers.moderation_moderator_actions;

-- Alter replicated tables
ALTER TABLE moderation.distributed_moderation_queues
    ADD COLUMN IF NOT EXISTS request_id UUID DEFAULT generateUUIDv4() FIRST;
ALTER TABLE moderation.distributed_moderator_actions
    ADD COLUMN IF NOT EXISTS request_id UUID FIRST;

-- Create kafka tables
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

-- Create triggers tables
CREATE
MATERIALIZED VIEW triggers.moderation_moderation_queues TO moderation.distributed_moderation_queues AS
SELECT *
FROM kafka.moderation_moderation_queues;

CREATE
MATERIALIZED VIEW triggers.moderation_moderator_actions TO moderation.distributed_moderator_actions AS
SELECT *
FROM kafka.moderation_moderator_actions;
