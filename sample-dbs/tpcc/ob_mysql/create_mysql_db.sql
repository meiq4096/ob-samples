create database tpccdb;
grant all privileges on tpccdb.* to tpcc identified by '123456';
grant select on oceanbase.* to tpcc;
create tablegroup tpcc_group partition by hash partitions 6;
show tablegroups;
show grants for tpcc;
