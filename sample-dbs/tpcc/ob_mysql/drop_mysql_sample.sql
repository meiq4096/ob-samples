-- run as user 'root' in the tenant of type mysql
drop database tpccdb;
purge recyclebin;
drop tablegroup tpcc_group;
drop user tpcc;
