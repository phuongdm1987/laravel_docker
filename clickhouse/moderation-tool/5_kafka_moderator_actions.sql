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
SELECT *
FROM kafka.moderation_moderator_actions;
