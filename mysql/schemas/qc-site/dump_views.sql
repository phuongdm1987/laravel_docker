DROP VIEW IF EXISTS UniCampaignFullView;
CREATE VIEW UniCampaignFullView AS
SELECT uc.*,
       CAST(uc.bit_flags AS UNSIGNED) bit_flags_int,
       ucmf.url                  shop_feed_url,
       ucmf.format               shop_feed_format,
       ucmf.checksum             shop_feed_checksum,
       ucmf.created_at           shop_feed_created_at,
       ucmf.feed_modified_at     shop_feed_feed_modified_at,
       ucmf.in_moderation        shop_feed_in_moderation,
       ucmf.in_sync              shop_feed_in_sync,
       ucmf.last_errors_count    shop_feed_last_errors_count,
       ucmf.synchronized_at      shop_feed_synchronized_at,
       ucmf.updated_at           shop_feed_updated_at,
       gt.data                   geo,
       (select count(*) from UniAdvert ua where ua.campaign_id = uc.id and ua.moderation_status != 'INIT')    count_ads_all,
       (select count(*) from UniAdvert ua where ua.campaign_id = uc.id and ua.moderation_status = 'DRAFT')    count_ads_draft,
       (select count(*) from UniAdvert ua where ua.campaign_id = uc.id and ua.moderation_status = 'PENDING')  count_ads_under_review,
       (select count(*) from UniAdvert ua where ua.campaign_id = uc.id and ua.moderation_status = 'NO')       count_ads_rejected
FROM UniCampaign uc
    LEFT JOIN UniCampaignMarketFeed ucmf ON ucmf.campaign_id = uc.id
    LEFT JOIN GeoTargeting gt ON gt.type = 'CAMPAIGN' AND gt.id = uc.id;

DROP VIEW IF EXISTS UniAdvertFullView;
CREATE VIEW UniAdvertFullView as
SELECT u.id                      user_id,
       uc.name                   campaign_name,
       uc.status                 campaign_status,
       uc.time_start             campaign_time_start,
       uc.time_end               campaign_time_end,
       uc.del_status             campaign_del_status,
       uc.ban_status             campaign_ban_status,
       ua.id,
       ua.campaign_id,
       ua.name,
       ua.type,
       ua.url,
       ua.url_destination,
       ua.title,
       ua.promotext,
       ua.img,
       ua.width,
       ua.height,
       ua.time_start,
       ua.time_end,
       ua.time_created,
       ua.time_updated,
       ua.time_updated_valuable,
       ua.time_queued,
       ua.time_targeting,
       ua.del_status,
       ua.show_status,
       ua.moderation_status,
       ua.ban_status,
       ua.ban_time,
       ua.ban_reason,
       ua.daily_show_limit,
       ua.daily_click_limit,
       ua.total_click_limit,
       ua.bit_flags,
       ua.poi_id,
       ua.charge_type_id,
       ct.name                   charge_type_name,
       ua_qc.placement_types     qc_placement_types,
       ua_qc.placement_positions qc_placement_positions,
       ua_qc.address             qc_address,
       ua_shop.original_price    shop_original_price,
       ua_shop.placement_types   shop_placement_types,
       ua_shop.sale_price        shop_sale_price,
       ua_shop.shop_name         shop_shop_name,
       ua_ntrbjs.code            ntrbjs_code,
       ua_ntrbvideo.json         ntrbvideo_json,
       ua_ntrbvideo.type         ntrbvideo_type,
       ua_ntrbvideo.video_file   ntrbvideo_video_file,
       ua_skin.json              skin_json,
       ua_masthead.json          masthead_json,
       ua_mhp.code               masthead_programatic_code,
       ua_zen.json               zen_json,
       ua_big_zen.json           big_zen_json,
       gt.data                   geo,
       cr.data                   content_retargeting,
       if(ua.moderation_status = 'NO',
          (
              select reason
              from ModeratorStat ms
              where ua.id = ms.advert_id
                and ms.action = 'REJECT'
              order by ms.id desc
              limit 1
          ),
          null) as               rejected_reasons
FROM User u
         INNER JOIN UniCampaign uc
                    ON uc.user_id = u.id
         INNER JOIN UniAdvert ua
                    ON ua.campaign_id = uc.id
         LEFT JOIN UniAdvertAttributesQC ua_qc
                   ON ua_qc.advert_id = ua.id
         LEFT JOIN UniAdvertAttributesMarket ua_shop
                   ON ua_shop.advert_id = ua.id
         LEFT JOIN UniAdvertAttributesNTRBJS ua_ntrbjs
                   ON ua_ntrbjs.advert_id = ua.id
         LEFT JOIN UniAdvertAttributesNTRBVideo ua_ntrbvideo
                   ON ua_ntrbvideo.advert_id = ua.id
         LEFT JOIN UniAdvertAttributesSkin ua_skin
                   ON ua_skin.advert_id = ua.id
         LEFT JOIN UniAdvertAttributesMasthead ua_masthead
                   ON ua_masthead.advert_id = ua.id
         LEFT JOIN UniAdvertAttributesMHProgrammatic ua_mhp
                   ON ua_mhp.advert_id = ua.id
         LEFT JOIN UniAdvertAttributesZen ua_zen
                   ON ua_zen.advert_id = ua.id
         LEFT JOIN UniAdvertAttributesBigZen ua_big_zen
                   ON ua_big_zen.advert_id = ua.id
         LEFT JOIN GeoTargeting gt
                   ON gt.type = 'ADVERT' AND gt.id = ua.id
         LEFT JOIN ChargeType ct
                   ON ct.id = ua.charge_type_id
         LEFT JOIN ContentRetargeting cr
                   ON cr.id = ua.id AND cr.type = 'ADVERT';

DROP VIEW IF EXISTS UniMatchCompactView;
CREATE VIEW UniMatchCompactView as
SELECT `um`.`id`                                                AS `id`,
       `um`.`advert_id`                                         AS `advert_id`,
       `um`.`bid`                                               AS `bid`,
       `um`.`show_status`                                       AS `show_status`,
       `um`.`moderation_status`                                 AS `moderation_status`,
       `um`.`time_created`                                      AS `time_created`,
       `um`.`time_updated`                                      AS `time_updated`,
       `um`.`type`                                              AS `type`,
       (IF(`type` = 'TOPIC', NULL, (
           if(`umk`.`status` != '', `umk`.`status`, `umc`.`status`)
           ))
           ) AS `status`,
       (IF(`type` = 'TOPIC', `umt`.`topic_id`, (
           if(`umk`.`phrase` != '', `umk`.`phrase`, `umc`.`value`)
           ))
           ) AS `value`
FROM UniMatch um
         LEFT JOIN UniMatchCategory umc ON umc.match_id = um.id
         LEFT JOIN UniMatchPhrase umk ON umk.match_id = um.id
         LEFT JOIN UniMatchTopic umt ON umt.match_id = um.id;

DROP VIEW IF EXISTS UniMatchFullView;
CREATE VIEW UniMatchFullView as
SELECT `umcv`.`id`                AS `id`,
       `umcv`.`advert_id`         AS `advert_id`,
       `umcv`.`bid`               AS `bid`,
       `umcv`.`show_status`       AS `show_status`,
       `umcv`.`moderation_status` AS `moderation_status`,
       `umcv`.`time_created`      AS `time_created`,
       `umcv`.`time_updated`      AS `time_updated`,
       `umcv`.`status`            AS `status`,
       `umcv`.`value`             AS `value`,
       `umcv`.`type`              AS `type`,
       `ua`.`name`                AS `advert_name`,
       `ua`.`time_start`          AS `advert_time_start`,
       `ua`.`time_end`            AS `advert_time_end`,
       `ua`.`show_status`         AS `advert_show_status`,
       `ua`.`moderation_status`   AS `advert_moderation_status`,
       `ua`.`ban_status`          AS `advert_ban_status`,
       `ua`.`del_status`          AS `advert_del_status`,
       `uc`.`id`                  AS `campaign_id`,
       `uc`.`name`                AS `campaign_name`,
       `uc`.`status`              AS `campaign_status`,
       `uc`.`time_start`          AS `campaign_time_start`,
       `uc`.`time_end`            AS `campaign_time_end`,
       `uc`.`del_status`          AS `campaign_del_status`,
       `uc`.`ban_status`          AS `campaign_ban_status`,
       `u`.`id`                   AS `user_id`,
       if(`umcv`.`status` = 'REJECTED',
          (select `msm`.`reason`
           from `ModeratorStatMatch` `msm`
           where ((`umcv`.`id` = `msm`.`match_id`) and (`msm`.`action` = 'REJECT'))
           order by `msm`.`id` desc
           limit 1),
          NULL)                   AS rejected_reasons

FROM UniMatchCompactView umcv
         INNER JOIN UniAdvert ua on ua.id = umcv.advert_id
         INNER JOIN UniCampaign uc ON uc.id = ua.campaign_id
         INNER JOIN User u ON u.id = uc.user_id;

DROP VIEW IF EXISTS AgencyIdView;
CREATE VIEW AgencyIdView as
SELECT `manager_id` AS `agency_id`, `user_id` AS `client_id`
FROM `UserManager`
WHERE `manager_profile_id` = 8;

DROP VIEW IF EXISTS SupportIdView;
CREATE VIEW SupportIdView as
SELECT `manager_id` AS `support_id`, `user_id` AS `client_id`
FROM `UserManager`
WHERE `manager_profile_id` in (6, 21);

DROP VIEW IF EXISTS SaleIdView;
CREATE VIEW SaleIdView as
SELECT `manager_id` AS `sale_id`, `user_id` AS `client_id`
FROM `UserManager`
WHERE `manager_profile_id` in (17, 20);

DROP VIEW IF EXISTS MccIdView;
CREATE VIEW MccIdView as
SELECT `manager_id` AS `mcc_id`, `user_id` AS `client_id`
FROM `UserManager`
WHERE `manager_profile_id` = 32;

DROP TABLE IF EXISTS RecentActiveAdvertId;
create table RecentActiveAdvertId
(
    id int not null primary key
);

DROP TABLE IF EXISTS RecentActiveMatchId;
create table RecentActiveMatchId
(
    id int not null primary key
);

DROP TABLE IF EXISTS RecentActiveExtensionId;
create table RecentActiveExtensionId
(
    id int not null primary key
);

DROP VIEW IF EXISTS RecentActiveExtensionView;
create view RecentActiveExtensionView as
select `e`.*
from RecentActiveExtensionId `raei`
         left join `Extension` `e` on `e`.`id` = `raei`.`id`;

DROP VIEW IF EXISTS RecentActiveMatchView;
create view RecentActiveMatchView as
select `rami`.`id`                                                 AS `id`,
       `umcView`.`value`                                         AS `value`,
       `umcView`.`type`                                         AS `type`
from `RecentActiveMatchId` `rami`
         left join `UniMatchCompactView` `umcView` ON `rami`.`id` = `umcView`.`id`;

DROP VIEW IF EXISTS RecentActiveAdvertView;
create view RecentActiveAdvertView as
select `ua`.`id`,
       `ua`.`name`,
       `ua`.`url`,
       `ua`.`url_destination`,
       `ua`.`title`,
       `ua`.`promotext`
from RecentActiveAdvertId `raai`
         left join `UniAdvert` `ua` on `ua`.`id` = `raai`.`id`;

DROP VIEW IF EXISTS ExtensionRelationFullView;
create view ExtensionRelationFullView as
select `e`.`id`,
       `e`.`user_id`,
       `e`.`type`,
       `e`.`title`,
       `e`.`description1`,
       `e`.`description2`,
       `e`.`url`,
       `e`.`url_destination`,
       `e`.`url_destination_status`,
       `e`.`text`,
       `e`.`time_created`,
       `e`.`time_updated`,
       `e`.`del_status`,
       `e`.`show_status`,
       `e`.`moderation_status`,
       `e`.`last_rejected_reason`,
       `e`.`time_queued`,
       `e`.`time_start`,
       `e`.`time_end`,
       `e`.`occasion_id`,
       `e`.`promo_type`,
       `e`.`promo_value`,
       `e`.`promo_text`,
       `e`.`promo_start_date`,
       `e`.`promo_end_date`,
       `e`.`promo_start_time`,
       `e`.`promo_end_time`,
       `e`.`promo_condition_type`,
       `e`.`promo_condition_value`,
       `uc`.`id`                  AS `campaign_id`,
       `uc`.`name`                AS `campaign_name`,
       if (`uc`.`id` is null, `u`.`id`, `uc`.`id`) AS `object_id`,
       if (`uc`.`name` is null, 'USER', `uc`.`name`) AS `object_name`,
       if (`uc`.`id` is null, 'USER', 'CAMPAIGN') AS `object_type`

from ExtensionRelation er
         left join UniCampaign uc on uc.id = `er`.`id` and `er`.`type` = 'CAMPAIGN'
         left join User u on u.id = `er`.`id` and `er`.`type` = 'USER'
         inner join Extension `e`  on e.id = er.extension_id;

DROP VIEW IF EXISTS ExtensionFullView;
create view ExtensionFullView as
select id,
       user_id,
       type,
       title,
       description1,
       description2,
       url,
       url_destination,
       url_destination_status,
       text,
       time_created,
       time_updated,
       del_status,
       show_status,
       moderation_status,
       last_rejected_reason,
       time_queued,
       time_start,
       time_end,
       occasion_id,
       promo_type,
       promo_value,
       promo_text,
       promo_start_date,
       promo_end_date,
       promo_start_time,
       promo_end_time,
       promo_time_text,
       promo_condition_type,
       promo_condition_value,
       promo_condition_text,
       (select count(*) from `ExtensionRelation` `er` where `er`.extension_id = `e`.id) counts_campaign_all
from `Extension` `e`;

DROP VIEW IF EXISTS DeviceCampaignView;
create view DeviceCampaignView as
select c.user_id,
       c.id as campaign_id,
       c.name as campaign_name,
       c.type as campaign_type,
       d.device,
       d.priority,
       b.bid_adjustment,
       b.time_created as time_created_bid,
       b.time_updated as time_updated_bid
from UniCampaign as c
         inner join Device as d
         left join BidAdjustmentDevice as b on b.object_id = c.id and b.object_type = 'CAMPAIGN' and b.device = d.device;

DROP VIEW IF EXISTS KeywordView;
CREATE VIEW KeywordView as
SELECT `um`.`id`                                                AS `id`,
       `um`.`user_id`                                           AS `user_id`,
       `um`.`bid`                                               AS `bid`,
       `um`.`show_status`                                       AS `show_status`,
       `um`.`moderation_status`                                 AS `moderation_status`,
       `um`.`last_rejected_reason`                              AS `last_rejected_reason`,
       `um`.`time_created`                                      AS `time_created`,
       `um`.`time_updated`                                      AS `time_updated`,
       `ump`.phrase                                             AS `phrase`,
       `um`.`ad_group_id`                                       AS `ad_group_id`,
       `ag`.`name`                                              as `ad_group_name`,
       `ag`.`time_start`                                        AS `ad_group_time_start`,
       `ag`.`time_end`                                          AS `ad_group_time_end`,
       `ag`.`show_status`                                       AS `ad_group_show_status`,
       `ag`.`ban_status`                                        AS `ad_group_ban_status`,
       `ag`.`del_status`                                        AS `ad_group_del_status`,
       `uc`.`id`                                                AS `campaign_id`,
       `uc`.`name`                                              AS `campaign_name`,
       `uc`.`type`                                              AS `campaign_type`,
       `uc`.`status`                                            AS `campaign_status`,
       `uc`.`time_start`                                        AS `campaign_time_start`,
       `uc`.`time_end`                                          AS `campaign_time_end`,
       `uc`.`del_status`                                        AS `campaign_del_status`,
       `uc`.`ban_status`                                        AS `campaign_ban_status`
FROM UniMatch um
    inner JOIN UniMatchPhrase ump ON ump.match_id = um.id
    inner join AdGroup ag on ag.id = um.ad_group_id
    inner join UniCampaign uc on um.campaign_id = uc.id;

DROP VIEW IF EXISTS CategoryView;
CREATE VIEW CategoryView as
SELECT `um`.`id`                                                AS `id`,
       `um`.`user_id`                                           AS `user_id`,
       `um`.`bid`                                               AS `bid`,
       `um`.`show_status`                                       AS `show_status`,
       `um`.`moderation_status`                                 AS `moderation_status`,
       `um`.`last_rejected_reason`                              AS `last_rejected_reason`,
       `um`.`time_created`                                      AS `time_created`,
       `um`.`time_updated`                                      AS `time_updated`,
       `umc`.`value`                                            AS `category`,
       `um`.`type`                                              AS `category_type`,
       `um`.`ad_group_id`                                       AS `ad_group_id`,
       `ag`.`name`                                              as `ad_group_name`,
       `ag`.`time_start`                                        AS `ad_group_time_start`,
       `ag`.`time_end`                                          AS `ad_group_time_end`,
       `ag`.`show_status`                                       AS `ad_group_show_status`,
       `ag`.`ban_status`                                        AS `ad_group_ban_status`,
       `ag`.`del_status`                                        AS `ad_group_del_status`,
       `uc`.`id`                                                AS `campaign_id`,
       `uc`.`name`                                              AS `campaign_name`,
       `uc`.`type`                                              AS `campaign_type`,
       `uc`.`status`                                            AS `campaign_status`,
       `uc`.`time_start`                                        AS `campaign_time_start`,
       `uc`.`time_end`                                          AS `campaign_time_end`,
       `uc`.`del_status`                                        AS `campaign_del_status`,
       `uc`.`ban_status`                                        AS `campaign_ban_status`
FROM UniMatch um
    inner JOIN UniMatchCategory umc ON umc.match_id = um.id
    inner join AdGroup ag on ag.id = um.ad_group_id
    inner join UniCampaign uc on um.campaign_id = uc.id
where um.type = 'CATEGORY' or um.type = 'CUSTOM_CATEGORY';


DROP VIEW IF EXISTS DemographicView;
CREATE VIEW DemographicView as
SELECT `um`.`id`                                                AS `id`,
       `um`.`user_id`                                           AS `user_id`,
       `um`.`bid`                                               AS `bid`,
       `um`.`show_status`                                       AS `show_status`,
       `um`.`moderation_status`                                 AS `moderation_status`,
       `um`.`last_rejected_reason`                              AS `last_rejected_reason`,
       `um`.`time_created`                                      AS `time_created`,
       `um`.`time_updated`                                      AS `time_updated`,
       `umc`.`value`                                            AS `demographic`,
       `um`.`ad_group_id`                                       AS `ad_group_id`,
       `ag`.`name`                                              as `ad_group_name`,
       `ag`.`time_start`                                        AS `ad_group_time_start`,
       `ag`.`time_end`                                          AS `ad_group_time_end`,
       `ag`.`show_status`                                       AS `ad_group_show_status`,
       `ag`.`ban_status`                                        AS `ad_group_ban_status`,
       `ag`.`del_status`                                        AS `ad_group_del_status`,
       `uc`.`id`                                                AS `campaign_id`,
       `uc`.`name`                                              AS `campaign_name`,
       `uc`.`type`                                              AS `campaign_type`,
       `uc`.`status`                                            AS `campaign_status`,
       `uc`.`time_start`                                        AS `campaign_time_start`,
       `uc`.`time_end`                                          AS `campaign_time_end`,
       `uc`.`del_status`                                        AS `campaign_del_status`,
       `uc`.`ban_status`                                        AS `campaign_ban_status`
FROM UniMatch um
         inner JOIN UniMatchCategory umc ON umc.match_id = um.id
         inner join AdGroup ag on ag.id = um.ad_group_id
         inner join UniCampaign uc on um.campaign_id = uc.id
where  um.type = 'DEMOGRAPHIC';

drop view if exists AdView;
create view AdView as
SELECT
    Ad.id,
    Ad.user_id,

    Ad.campaign_id,
    UniCampaign.name       as campaign_name,
    UniCampaign.status     as campaign_status,
    UniCampaign.ban_status as campaign_ban_status,

    Ad.ad_group_id,
    AdGroup.name           as ad_group_name,
    AdGroup.show_status    as ad_group_show_status,
    AdGroup.ban_status     as ad_group_ban_status,
    AdGroup.del_status     as ad_group_del_status,

    Ad.type,
    Ad.show_status,
    Ad.moderation_status,
    Ad.del_status,
    Ad.ban_status,
    Ad.bit_flags,
    Ad.last_rejected_reason,
    Ad.time_created,
    Ad.time_updated,
    Ad.time_queued,
    AdAddress.address,
    AdCode.code,
    AdCustom.is_custom,
    AdDescription.description,
    AdFields.cache,
    AdFields.json,
    AdMedia.media_src,
    AdMedia.media_type,
    AdShopping.original_price,
    AdShopping.sale_price,
    AdShopping.shop_name,
    AdSize.width,
    AdSize.height,
    AdSubType.sub_type,
    AdTitle.title,
    AdUrl.url,
    AdUrl.url_utm,
    AdUrl.url_destination,
    AdUrl.url_destination_status,
    AdVideoFormat.video_format,
    AdApiVersion.api_version
from UniCampaign
         join AdGroup on UniCampaign.id = AdGroup.campaign_id
         join Ad on Ad.ad_group_id = AdGroup.id
         left join AdAddress on AdAddress.ad_id = Ad.id
         left join AdCode on AdCode.ad_id = Ad.id
         left join AdCustom on AdCustom.ad_id = Ad.id
         left join AdDescription on AdDescription.ad_id = Ad.id
         left join AdFields on AdFields.ad_id = Ad.id
         left join AdMedia on AdMedia.ad_id = Ad.id
         left join AdShopping on AdShopping.ad_id = Ad.id
         left join AdSize on AdSize.ad_id = Ad.id
         left join AdSubType on AdSubType.ad_id = Ad.id
         left join AdTitle on AdTitle.ad_id = Ad.id
         left join AdUrl on AdUrl.ad_id = Ad.id
         left join AdVideoFormat on AdVideoFormat.ad_id = Ad.id
         left join AdApiVersion on AdApiVersion.ad_id = Ad.id;

drop view if exists AdGroupView;
create view AdGroupView as
SELECT
    AdGroup.id,
    AdGroup.name           as name,
    AdGroup.show_status    as show_status,
    AdGroup.ban_status     as ban_status,
    AdGroup.del_status     as del_status,

    UniCampaign.user_id    as user_id,
    UniCampaign.id         as campaign_id,
    UniCampaign.name       as campaign_name,
    UniCampaign.status     as campaign_status,
    UniCampaign.ban_status as campaign_ban_status
from UniCampaign
         join AdGroup on UniCampaign.id = AdGroup.campaign_id;


DROP VIEW IF EXISTS ScheduleTargetingView;
CREATE VIEW ScheduleTargetingView AS
SELECT
    ScheduleTargeting.id,
    ScheduleTargeting.object_id,
    ScheduleTargeting.object_type,
    ScheduleTargeting.day_of_week,
    ScheduleTargeting.start_hour,
    ScheduleTargeting.end_hour,
    ScheduleTargeting.bid_adjustment,
    ScheduleTargeting.del_status,

    UniCampaign.user_id    as user_id,
    UniCampaign.id         as campaign_id,
    UniCampaign.name       as campaign_name,
    UniCampaign.type       as campaign_type,
    UniCampaign.status     as campaign_status,
    UniCampaign.ban_status as campaign_ban_status,

    ScheduleTargeting.time_created,
    ScheduleTargeting.time_updated
FROM ScheduleTargeting
JOIN UniCampaign ON UniCampaign.id = ScheduleTargeting.object_id AND ScheduleTargeting.object_type = 'CAMPAIGN';


DROP VIEW IF EXISTS LocationTargetingView;
CREATE VIEW LocationTargetingView AS
SELECT
    LocationTargeting.id,
    LocationTargeting.object_id,
    LocationTargeting.object_type,
    LocationTargeting.location_type,
    LocationTargeting.location_name,
    LocationTargeting.region_id,
    LocationTargeting.custom_data,
    LocationTargeting.del_status,

    UniCampaign.user_id    as user_id,
    UniCampaign.id         as campaign_id,
    UniCampaign.name       as campaign_name,
    UniCampaign.type       as campaign_type,
    UniCampaign.status     as campaign_status,
    UniCampaign.ban_status as campaign_ban_status,

    LocationTargeting.time_created,
    LocationTargeting.time_updated
FROM LocationTargeting
JOIN UniCampaign ON UniCampaign.id = LocationTargeting.object_id AND LocationTargeting.object_type = 'CAMPAIGN';
