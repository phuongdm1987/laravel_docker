-- Create moderator_actions table
DROP TABLE IF EXISTS moderation_tool.moderator_actions;
CREATE TABLE IF NOT EXISTS moderation_tool.moderator_actions
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
ORDER BY (action_date, action_time, action, object_type, kind_of_object, object_id, advert_id, advert_group_id, campaign_id, user_id, moderator_id)
PARTITION BY toYYYYMM(action_date)
SETTINGS index_granularity = 8192;

-- Consume to moderator_actions table
DROP TABLE IF EXISTS moderation_tool.rabbitmq_moderator_action_consumer;
CREATE TABLE IF NOT EXISTS moderation_tool.rabbitmq_moderator_action_consumer
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
) ENGINE = RabbitMQ SETTINGS
    rabbitmq_host_port = 'rabbitmq:5672',
    rabbitmq_exchange_name = 'CH_moderator_actions',
    rabbitmq_format = 'JSONEachRow',
    rabbitmq_max_block_size = 1048576;

CREATE MATERIALIZED VIEW IF NOT EXISTS moderation_tool.materialized_rabbitmq_moderator_action_consumer TO moderation_tool.moderator_actions AS
SELECT * FROM moderation_tool.rabbitmq_moderator_action_consumer;

-- Create moderation_queues table
DROP TABLE IF EXISTS moderation_tool.moderation_queues;
CREATE TABLE IF NOT EXISTS moderation_tool.moderation_queues
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
    queue_time         DateTime,
    queue_date         Date DEFAULT toDate(queue_time)
) ENGINE = MergeTree()
ORDER BY (queue_date, queue_time, queue_type, object_type, kind_of_object, object_id, advert_id, advert_group_id, campaign_id, user_id)
PARTITION BY toYYYYMM(queue_date)
SETTINGS index_granularity = 8192;
