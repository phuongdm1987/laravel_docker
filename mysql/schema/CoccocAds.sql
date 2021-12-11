DROP DATABASE IF EXISTS CoccocAds;
CREATE DATABASE IF NOT EXISTS CoccocAds;
use CoccocAds;

create table User
(
    id int(20) unsigned auto_increment primary key
) charset = utf8;

insert into User
(id)
values
    (1),(2),(3),(4),(5),(6);
