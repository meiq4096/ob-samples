-- run as user 'sys' in the tenant of type oracle
source create_oracle_schema.sql

-- change user to 'tpcc'
conn tpcc

source create_oracle_tables.sql
source create_oracle_procedures.sql

source init_data.sql

select distinct owner,object_name,object_type,status from all_objects where owner in ('TPCC') order by object_type, object_name;
