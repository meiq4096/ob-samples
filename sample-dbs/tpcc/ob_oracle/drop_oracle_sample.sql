-- run as user 'sys' in the tenant of type oracle
drop user tpcc cascade;
purge recyclebin;
drop tablegroup tpcc_group;

select distinct owner,object_name,object_type,status from all_objects where owner in ('TPCC') order by object_type, object_name;

