CREATE DATABASE IF NOT EXISTS labs_external_mysql;
USE labs_external_mysql;

DROP TABLE IF EXISTS remote_CoccocAds_User;
CREATE TABLE remote_CoccocAds_User
(
	id UInt64,
	profile_id UInt8,
	lastname String,
	firstname String,
	email String,
	password String,
	register_time DateTime,
	status String,
	status_change_time DateTime,
	discount Float64,
	gender String,
	birthday Date,
	country String,
	city String,
	interface String,
	phone String,
	deleted_reason String,
	deleted_by_user UInt64,
	company_name String,
	address String,
	tax_code String,
	auto_add_utms String,
	marketing_source String,
	api_limit UInt64,
	locale String,
	budget_limit Float64
)
  ENGINE = MySQL('mysql', 'CoccocAds', 'User', 'root', 'secret');

DROP TABLE IF EXISTS remote_CoccocAds_UniCampaignFullView;
CREATE TABLE remote_CoccocAds_UniCampaignFullView
(
    id UInt64,
    type UInt8,
    user_id UInt64,
    payment_type UInt8,
    name String,
    time_start DateTime,
    time_end Nullable(DateTime),
    time_created DateTime,
    time_updated DateTime,
    status UInt8,
    ban_status String,
    del_status String,
    bit_flags_int UInt8,
    deactivation_reason UInt8 DEFAULT -1,
    deactivation_time DateTime,
    payment_limit_type UInt8 DEFAULT -1,
    payment_limit_value Nullable(UInt64) DEFAULT null,
    payment_limit_time DateTime,
    payment_limit_period UInt8 DEFAULT 7,
    auto_add_utms String,
    bid Int64 DEFAULT -1,
    bid_strategy String,
    shows_per_user UInt64 DEFAULT -1,
    shows_per_user_period UInt8,
    ad_delivery String,
    category_id UInt64,
    shop_feed_url String,
    shop_feed_format String,
    shop_feed_checksum String,
    shop_feed_created_at DateTime,
    shop_feed_feed_modified_at DateTime,
    shop_feed_in_moderation UInt8,
    shop_feed_in_sync UInt8,
    shop_feed_last_errors_count UInt32,
    shop_feed_synchronized_at DateTime,
    shop_feed_updated_at DateTime,
    count_ads_all UInt32,
    count_ads_draft UInt32,
    count_ads_under_review UInt32,
    count_ads_rejected UInt32
)
ENGINE = MySQL('mysql', 'CoccocAds', 'UniCampaignFullView', 'root', 'secret');

DROP TABLE IF EXISTS remote_CoccocAds_UniAdvertFullView;
CREATE TABLE remote_CoccocAds_UniAdvertFullView
(
	id UInt64,
	campaign_id UInt64,
    campaign_name String,
    campaign_del_status String,
    campaign_ban_status String,
    campaign_status UInt8,
    campaign_time_start DateTime,
    campaign_time_end Nullable(DateTime),
	user_id UInt64,
	type UInt8,
	url String,
	url_destination String,
	name String,
	title String,
	promotext String,
	img String,
	width UInt16,
	height UInt16,
	time_start DateTime,
	time_end Nullable(DateTime),
	time_created DateTime,
	time_updated DateTime,
	time_updated_valuable DateTime,
	time_queued DateTime,
	time_targeting String,
	del_status String,
	show_status String,
	moderation_status String,
	ban_status String,
	ban_time DateTime,
	ban_reason UInt8,
	daily_show_limit UInt64,
	daily_click_limit UInt64,
	total_click_limit UInt64,
	bit_flags String,
	poi_id UInt64,
	charge_type_id UInt64,
	qc_placement_types String,
	qc_placement_positions String,
	qc_address String,
	shop_original_price UInt64,
	shop_sale_price UInt64,
	shop_placement_types String,
	shop_shop_name String,
	ntrbjs_code String,
	ntrbvideo_json String,
	ntrbvideo_type String,
	ntrbvideo_video_file String,
	skin_json String,
    masthead_json String,
    masthead_programatic_code String,
    zen_json String,
    big_zen_json String,
	geo String,
	rejected_reasons String,
	charge_type_name String,
	content_retargeting String
)
ENGINE = MySQL('mysql', 'CoccocAds', 'UniAdvertFullView', 'root', 'secret');


DROP TABLE IF EXISTS remote_CoccocAds_UniMatchFullView;
CREATE TABLE remote_CoccocAds_UniMatchFullView
(
  id                       UInt64,
  bid                      UInt32,
  show_status              String,
  moderation_status        String,
  time_created             String,
  time_updated             String,
  type                     String,
  status                   String,
  value                    String,
  user_id                  UInt64,
  campaign_id              UInt64,
  campaign_name            String,
  campaign_del_status      String,
  campaign_ban_status      String,
  campaign_status          UInt8,
  campaign_time_start      DateTime,
  campaign_time_end        Nullable(DateTime),
  advert_name              String,
  advert_id                UInt64,
  advert_show_status       String,
  advert_moderation_status String,
  advert_del_status        String,
  advert_ban_status        String,
  advert_time_start        DateTime,
  advert_time_end          Nullable(DateTime),
  rejected_reasons         String
)
    ENGINE = MySQL('mysql', 'CoccocAds', 'UniMatchFullView', 'root', 'secret');


DROP TABLE IF EXISTS remote_CoccocAds_KeywordView;
CREATE TABLE remote_CoccocAds_KeywordView
(
    id                       UInt64,
    bid                      UInt32,
    show_status              String,
    moderation_status        String,
    last_rejected_reason     String,
    time_created             String,
    time_updated             String,
    phrase                   String,
    user_id                  UInt64,
    campaign_id              UInt64,
    campaign_name            String,
    campaign_type            String,
    campaign_del_status      String,
    campaign_ban_status      String,
    campaign_status          UInt8,
    campaign_time_start      DateTime,
    campaign_time_end        Nullable(DateTime),
    ad_group_id              UInt64,
    ad_group_name            String,
    ad_group_show_status     String,
    ad_group_del_status      String,
    ad_group_ban_status      String,
    ad_group_time_start      DateTime,
    ad_group_time_end        Nullable(DateTime)
)
ENGINE = MySQL('mysql', 'CoccocAds', 'KeywordView', 'root', 'secret');

DROP TABLE IF EXISTS remote_CoccocAds_DemographicView;
CREATE TABLE remote_CoccocAds_DemographicView
(
    id                       UInt64,
    bid                      UInt32,
    show_status              String,
    moderation_status        String,
    last_rejected_reason     String,
    time_created             String,
    time_updated             String,
    demographic              String,
    user_id                  UInt64,
    campaign_id              UInt64,
    campaign_name            String,
    campaign_type            String,
    campaign_del_status      String,
    campaign_ban_status      String,
    campaign_status          UInt8,
    campaign_time_start      DateTime,
    campaign_time_end        Nullable(DateTime),
    ad_group_id              UInt64,
    ad_group_name            String,
    ad_group_show_status     String,
    ad_group_del_status      String,
    ad_group_ban_status      String,
    ad_group_time_start      DateTime,
    ad_group_time_end        Nullable(DateTime)
)
    ENGINE = MySQL('mysql', 'CoccocAds', 'DemographicView', 'root', 'secret');

DROP TABLE IF EXISTS remote_CoccocAds_CategoryView;
CREATE TABLE remote_CoccocAds_CategoryView
(
    id                       UInt64,
    bid                      UInt32,
    show_status              String,
    moderation_status        String,
    last_rejected_reason     String,
    time_created             String,
    time_updated             String,
    category                 String,
    category_type            String,
    user_id                  UInt64,
    campaign_id              UInt64,
    campaign_name            String,
    campaign_type            String,
    campaign_del_status      String,
    campaign_ban_status      String,
    campaign_status          UInt8,
    campaign_time_start      DateTime,
    campaign_time_end        Nullable(DateTime),
    ad_group_id              UInt64,
    ad_group_name            String,
    ad_group_show_status     String,
    ad_group_del_status      String,
    ad_group_ban_status      String,
    ad_group_time_start      DateTime,
    ad_group_time_end        Nullable(DateTime)
)
    ENGINE = MySQL('mysql', 'CoccocAds', 'CategoryView', 'root', 'secret');

DROP TABLE IF EXISTS remote_CoccocAds_ExtensionRelationFullView;
CREATE TABLE remote_CoccocAds_ExtensionRelationFullView
(
    id UInt64,
    user_id UInt64,
    type String,
    title  String,
    description1 String,
    description2 String,
    url String,
    text String,
    time_created DateTime,
    time_updated DateTime,
    time_start DateTime,
    time_end Nullable(DateTime),
    del_status String,
    show_status String,
    moderation_status String,
    last_rejected_reason String,
    time_queued DateTime,
    occasion_id UInt64,
    promo_type String,
    promo_value String,
    promo_text String,
    promo_start_date Nullable(Date),
    promo_end_date Nullable(Date),
    promo_start_time String,
    promo_end_time String,
    promo_condition_type String,
    promo_condition_value String,
    campaign_id UInt64,
    campaign_name String,
    object_id UInt64,
    object_name String,
    object_type String

)
    ENGINE = MySQL('mysql', 'CoccocAds', 'ExtensionRelationFullView', 'root', 'secret');

DROP TABLE IF EXISTS remote_CoccocAds_ExtensionFullView;
CREATE TABLE remote_CoccocAds_ExtensionFullView
(
    id UInt64,
    user_id UInt64,
    type String,
    title  String,
    description1 String,
    description2 String,
    url String,
    text String,
    time_created DateTime,
    time_updated DateTime,
    time_start DateTime,
    time_end Nullable(DateTime),
    del_status String,
    show_status String,
    moderation_status String,
    last_rejected_reason String,
    time_queued DateTime,
    occasion_id UInt64,
    promo_type String,
    promo_value String,
    promo_text String,
    promo_start_date Nullable(Date),
    promo_end_date Nullable(Date),
    promo_start_time String,
    promo_end_time String,
    promo_condition_type String,
    promo_condition_value String,
    counts_campaign_all UInt64
)
    ENGINE = MySQL('mysql', 'CoccocAds', 'ExtensionFullView', 'root', 'secret');

DROP TABLE IF EXISTS remote_CoccocAds_DeviceCampaignView;
CREATE TABLE remote_CoccocAds_DeviceCampaignView
(
    user_id UInt64,
    campaign_id UInt64,
    campaign_name String,
    campaign_type UInt8,
    device String,
    priority UInt8,
    bid_adjustment Nullable(Int16),
    time_created_bid Nullable(DateTime),
    time_updated_bid Nullable(DateTime)
)
    ENGINE = MySQL('mysql', 'CoccocAds', 'DeviceCampaignView', 'root', 'secret');


DROP TABLE IF EXISTS remote_CoccocAds_AdGroupView;
CREATE TABLE remote_CoccocAds_AdGroupView
(
    id UInt64,
    name String,
    show_status String,
    ban_status String,
    del_status String,
    user_id UInt64,
    campaign_id UInt64,
    campaign_name String,
    campaign_status UInt8,
    campaign_ban_status String
)
    ENGINE = MySQL('mysql', 'CoccocAds', 'AdGroupView', 'root', 'secret');


DROP TABLE IF EXISTS remote_CoccocAds_ScheduleTargetingView;
CREATE TABLE remote_CoccocAds_ScheduleTargetingView
(
    id                              UInt64,
    object_id                       UInt64,
    object_type                     String,
    day_of_week                     UInt8,
    start_hour                      UInt8,
    end_hour                        UInt8,
    bid_adjustment                  UInt16,
    del_status                      String,
    user_id                         UInt64,
    campaign_id                     UInt64,
    campaign_name                   String,
    campaign_type                   UInt8,
    campaign_status                 UInt8,
    campaign_ban_status             String,
    time_created                    DateTime,
    time_updated                    DateTime
)
ENGINE = MySQL('mysql', 'CoccocAds', 'ScheduleTargetingView', 'root', 'secret');


DROP TABLE IF EXISTS remote_CoccocAds_LocationTargetingView;
CREATE TABLE remote_CoccocAds_LocationTargetingView
(
    id                              UInt64,
    object_id                       UInt64,
    object_type                     String,
    location_type                   String,
    location_name                   String,
    region_id                       Nullable(UInt32) default null,
    custom_data                     Nullable(String) default null,
    del_status                      String,
    user_id                         UInt64,
    campaign_id                     UInt64,
    campaign_name                   String,
    campaign_type                   UInt8,
    campaign_status                 UInt8,
    campaign_ban_status             String,
    time_created                    DateTime,
    time_updated                    DateTime
)
ENGINE = MySQL('mysql', 'CoccocAds', 'LocationTargetingView', 'root', 'secret');

