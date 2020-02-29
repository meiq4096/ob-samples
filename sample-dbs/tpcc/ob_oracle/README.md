## 在集群中创建一个ORACLE租户

请参考OceanBase运维手册或者OCP产品帮助文档创建一个ORACLE租户。  
此处租户名称是 `t_oracle0_91`。 注意`0_91`是OCP自动附加的名字。

## 修改脚本中的`Zone`名称

首先需要确认OceanBase集群的`Zone`名称。可以在OCP里查看，也可以到OceanBase集群的`sys`租户下查询：

```sql
select distinct zone from __all_server order by zone;
```

如果`zone`名称是`zone_1 zone_2 zone_3`则不用修改脚本；否则需要将脚本`create_oracle_tables.sql`中`zone_`替换为实际`zone`名称的前缀。

## 执行示例数据库创建脚本

登录oracle租户的sys用户，执行脚本`create_oracle_sample.sql`。

示例如下：

```bash
$obclient -h192.168.1.101 -usys@t_oracle0_91#obdoc -P2883 -pabcABC123  sys
obclient> source create_oracle_sample.sql

```

执行成功后，会提示如下：

```bash
+------------+----------+
| TABLE_NAME | ROWS_CNT |
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

+-------+------------------------------+-----------------+--------+
| OWNER | OBJECT_NAME                  | OBJECT_TYPE     | STATUS |
+-------+------------------------------+-----------------+--------+
| TPCC  | __idx_1102810162709621_ICUST | INDEX           | VALID  |
| TPCC  | __idx_1102810162709626_IORDR | INDEX           | VALID  |
| TPCC  | DELIVERY                     | PROCEDURE       | VALID  |
| TPCC  | NEWORDER                     | PROCEDURE       | VALID  |
| TPCC  | ORDERSTATUS                  | PROCEDURE       | VALID  |
| TPCC  | PAYMENT                      | PROCEDURE       | VALID  |
| TPCC  | STOCKLEVEL                   | PROCEDURE       | VALID  |
| TPCC  | CUST                         | TABLE           | VALID  |
| TPCC  | DIST                         | TABLE           | VALID  |
| TPCC  | HIST                         | TABLE           | VALID  |
| TPCC  | ITEM                         | TABLE           | VALID  |
| TPCC  | LOAD_HIST                    | TABLE           | VALID  |
| TPCC  | LOAD_PROC                    | TABLE           | VALID  |
| TPCC  | NORD                         | TABLE           | VALID  |
| TPCC  | ORDL                         | TABLE           | VALID  |
| TPCC  | ORDR                         | TABLE           | VALID  |
| TPCC  | STOK                         | TABLE           | VALID  |
| TPCC  | WARE                         | TABLE           | VALID  |
| TPCC  | CUST                         | TABLE PARTITION | VALID  |
| TPCC  | DIST                         | TABLE PARTITION | VALID  |
| TPCC  | HIST                         | TABLE PARTITION | VALID  |
| TPCC  | NORD                         | TABLE PARTITION | VALID  |
| TPCC  | ORDL                         | TABLE PARTITION | VALID  |
| TPCC  | ORDR                         | TABLE PARTITION | VALID  |
| TPCC  | STOK                         | TABLE PARTITION | VALID  |
| TPCC  | WARE                         | TABLE PARTITION | VALID  |
+-------+------------------------------+-----------------+--------+
28 rows in set (0.04 sec)
```

脚本会创建一个业务用户：`tpcc`，密码是：`123456`。登陆方式如下：

```bash
$obclient -h192.168.1.101 -utpcc@t_oracle0_91#obdoc -P2883 -p123456 tpcc
```

## 删除示例数据库脚本(可选)

```bash
$obclient -h192.168.1.101 -usys@t_oracle0_91#obdoc -P2883 -pabcABC123  sys
obclient> source drop_oracle_sample.sql
```
成功后提示

```bash
obclient> source drop_oracle_sample.sql
Query OK, 0 rows affected (1.38 sec)

Query OK, 0 rows affected (0.01 sec)

Query OK, 0 rows affected (0.01 sec)

Empty set (0.03 sec)

obclient>
```

