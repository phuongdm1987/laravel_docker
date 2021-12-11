USE operation;

CREATE OR REPLACE VIEW placement_placement_group
AS
select pg.id                    as placement_group_id,
       pg.type                  as placement_group_type,
       tr.ad_condition_group_id as ad_condition_group_id,
       p.id                     as placement_id
from placement_groups pg
         inner join target_rule_placement_group trpg
                    on pg.id = trpg.placement_group_id and pg.status = 'ACTIVE'
         inner join target_rules tr
                    on trpg.target_rule_id = tr.id and tr.status = 'ACTIVE'
         left join placement_group_industries pgi
                   on trpg.placement_group_id = pgi.placement_group_id
         left join placement_group_tiers pgt
                   on trpg.placement_group_id = pgt.placement_group_id
         left join placement_group_labels pgl
                   on trpg.placement_group_id = pgl.placement_group_id
         left join placement_group_websites pgw
                   on trpg.placement_group_id = pgw.placement_group_id
         left join placement_group_inventory_types pgit
                   on trpg.placement_group_id = pgit.placement_group_id
         left join placement_group_ad_sizes pgas
                   on trpg.placement_group_id = pgas.placement_group_id
         inner join adnetwork.websites w
                    on (w.industry_id = pgi.industry_id or pgi.industry_id is null)
                        and (w.tier_id = pgt.tier_id or pgt.tier_id is null)
                        and (w.id = pgw.website_id or pgw.website_id is null)
                        and w.show_status = 'ACTIVE'
                        and w.moderation_status = 'ACCEPTED'
         left join adnetwork.label_website lw
                   on lw.website_id = w.id
         inner join adnetwork.placements p
                    on w.id = p.website_id and p.status = 'ACTIVE'
         inner join adnetwork.formats f
                    on p.id = f.placement_id
                        and (f.inventory_type_id = pgit.inventory_type_id or pgit.inventory_type_id is null)
                        and (f.ad_size_id = pgas.ad_size_id or pgas.ad_size_id is null)
where (pgl.label_id = lw.label_id or pgl.label_id is null)
group by pg.id, pg.type, tr.ad_condition_group_id, p.id;
