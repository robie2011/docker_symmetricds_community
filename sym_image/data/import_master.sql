use sym;

set @master_group='server';
set @slave_group='client';
set @master_node_id='000';
set @node_password = '5d1c92bbacbe2edb9e1ca5dbb0e481';

/*
------------------------------------------------------------------------------
-- Symmetric Configuration
------------------------------------------------------------------------------
*/
start transaction;
/*--- removing old sym tables*/

delete from sym_trigger_router;
delete from sym_trigger;
delete from sym_router;
delete from sym_node_group_link;
delete from sym_node_group;
delete from sym_node_host;
delete from sym_node_identity;
delete from sym_node_security;
delete from sym_node;

insert into sym_node_group (node_group_id) values (@master_group);
insert into sym_node_group (node_group_id) values (@slave_group);

/*-- masters should [w]ait for push from remotes because of firewalls*/
insert into sym_node_group_link (source_node_group_id, target_node_group_id, data_event_action) values (@master_group, @slave_group, 'W');
insert into sym_node_group_link (source_node_group_id, target_node_group_id, data_event_action) values (@slave_group, @master_group, 'P');

/*-- register master node*/
insert into sym_node (node_id,node_group_id,external_id,sync_enabled,sync_url,schema_version,symmetric_version,database_type,database_version,heartbeat_time,timezone_offset,batch_to_send_count,batch_in_error_count,created_at_node_id) 
 values (@master_node_id,@master_group,@master_node_id,1,null,null,null,null,null,current_timestamp,null,0,0,@master_node_id);

insert into sym_node_security (node_id,node_password,registration_enabled,registration_time,initial_load_enabled,initial_load_time,created_at_node_id) 
 values (@master_node_id,@node_password,0,current_timestamp,0,current_timestamp,@master_node_id);

insert into sym_node_identity values (@master_node_id);

commit;

/*
------------------------------------------------------------------------------
-- Data Sync Configuration
------------------------------------------------------------------------------
*/
start transaction;
/*
-- TODO: Syn config for real data
-- sync data specific trigger configuration
-- test sync config
*/

/*--- configuration for car table*/
set @car_trigger_id = 'produkt_trigger';
set @car_router_id = 'clients2master';
set @car_catalog = '';

insert into sym_trigger 
(trigger_id,source_catalog_name,source_table_name,channel_id,last_update_time,create_time)
values(@car_trigger_id, @car_catalog, 'Produkt','default',current_timestamp,current_timestamp);

insert into sym_router 
(router_id,source_node_group_id,target_node_group_id, router_type,create_time,last_update_time)
values(@car_router_id, @slave_group, @master_group, 'default', current_timestamp, current_timestamp);

insert into sym_trigger_router 
(trigger_id,router_id,initial_load_order,last_update_time,create_time)
values(@car_trigger_id,@car_router_id, 100, current_timestamp, current_timestamp);

commit;
