-- Create moderation_queues table
DROP TABLE IF EXISTS moderation.distributed_moderation_queues;
CREATE TABLE IF NOT EXISTS moderation.distributed_moderation_queues
(
    user_id         UInt64,
    campaign_id Array(UInt64),
    advert_group_id UInt64 DEFAULT 0,
    advert_id       UInt64 DEFAULT 0,
    object_id       UInt64,
    kind_of_object  String,
    object_type     String,
    queue_type      String,
    industry_id Array(UInt64),
    category_id Array(UInt64),
    queue_time      DateTime,
    queue_date      Date   DEFAULT toDate(queue_time)
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
                queue_type,
                queue_time
          )
      SETTINGS index_granularity = 8192;
