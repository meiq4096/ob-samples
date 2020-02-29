## 在集群中创建一个MySQL租户

请参考OceanBase运维手册或者OCP产品帮助文档创建一个MySQL租户。  
此处租户名称是 `t_mysql0_90`。 注意`0_90`是OCP自动附加的名字。

## 1. 修改脚本中的`Zone`名称

首先需要确认OceanBase集群的`Zone`名称。可以在OCP里查看，也可以到OceanBase集群的`sys`租户下查询：

```sql
select distinct zone from __all_server order by zone;
```

如果`zone`名称是`zone_1 zone_2 zone_3`则不用修改脚本；否则需要将脚本`create_mysql_tables.sql`中`zone_`替换为实际`zone`名称的前缀。

## 2. 执行示例数据库创建脚本

登录mysql租户的sys用户，执行脚本`create_mysql_sample.sql`。


示例如下：

```bash
$obclient -h192.168.1.101 -usys@t_mysql0_90#obdoc -P2883 -pabcABC123  oceanbase
obclient> source create_mysql_sample.sql

```

执行成功后，会提示如下：

```bash
+------------+----------+
| table_name | rows_cnt |
+------------+----------+
| WARE       |        2 |
| DIST       |       20 |
| NORD       |       40 |
| ORDR       |       60 |
| HIST       |      240 |
| ITEM       |      622 |
| ORDL       |      626 |
| CUST       |     1040 |
| STOK       |     1244 |
+------------+----------+
9 rows in set (0.08 sec)

Database changed
+------------------+
| Tables_in_tpccdb |
+------------------+
| cust             |
| dist             |
| hist             |
| item             |
| load_hist        |
| load_proc        |
| nord             |
| ordl             |
| ordr             |
| stock_item       |
| stok             |
| ware             |
+------------------+
12 rows in set (0.00 sec)
```

脚本会创建一个业务用户：`tpcc`，密码是：`123456`。登陆方式如下：

```bash
$obclient -h192.168.1.101 -utpcc@t_mysql0_90#obdoc -P2883 -p123456 -c -A tpccdb

```

## 3. 删除示例数据库脚本(可选)

```bash
$obclient -h192.168.1.101 -uroot@t_mysql0_90#obdoc -P2883 -pabcABC123 -A oceanbase
obclient> source drop_mysql_sample.sql
```
成功后提示

```bash
obclient> source drop_mysql_sample.sql
Query OK, 15 rows affected (0.04 sec)

Query OK, 0 rows affected (0.13 sec)

Query OK, 0 rows affected (0.04 sec)

Query OK, 0 rows affected (0.01 sec)
```

