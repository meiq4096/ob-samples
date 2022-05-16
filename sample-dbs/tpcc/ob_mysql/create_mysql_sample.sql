-- run as user 'root' in the tenant of type mysql
source create_mysql_db.sql

use tpccdb
source create_mysql_tables.sql
source init_data.sql

use tpccdb;
show tables;
