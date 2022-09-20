DROP TABLE IF EXISTS moderation.distributed_moderator_actions;
CREATE TABLE IF NOT EXISTS moderation.distributed_moderator_actions
(
    moderator_id    UInt64,
    user_id         UInt64,
    campaign_id Array(UInt64),
    advert_group_id UInt64 DEFAULT 0,
    advert_id       UInt64 DEFAULT 0,
    object_id       UInt64,
    kind_of_object  String,
    object_type     String,
    action          String,
    rejected_reason Array(UInt64),
    industry_id Array(UInt64),
    category_id Array(UInt64),
    action_time     DateTime,
    action_date     Date   DEFAULT toDate(action_time)
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
                  object_type,
                  action_time
            )
        SETTINGS index_granularity = 8192;
