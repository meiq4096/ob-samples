-- run as user 'sys' in the tenant of type oracle
create user tpcc identified by 123456;
grant all privileges on tpcc.* to tpcc;
grant select on sys.* to tpcc;
create tablegroup tpcc_group partition by hash partitions 6;
