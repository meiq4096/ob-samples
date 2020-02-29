set autocommit=1;
set ob_query_timeout=4000000000;
set ob_trx_timeout=4000000000;
create table load_proc(l_part int, w_id int, primary key(l_part, w_id));
create table ware(w_id int
, w_ytd decimal(12,2)
, w_tax decimal(4,4)
, w_name varchar(10)
, w_street_1 varchar(20)
, w_street_2 varchar(20)
, w_city varchar(20)
, w_state char(2)
, w_zip char(9)
, primary key(w_id)
)tablegroup tpcc_group NOCOMPRESS pctfree=0 BLOCK_SIZE=8192 partition by hash(w_id) partitions 6;
create table dist (d_w_id int
, d_id int
, d_next_o_id int
, d_tax decimal(4,4)
, d_ytd decimal(12,2)
, d_name varchar(10)
, d_street_1 varchar(20)
, d_street_2 varchar(20)
, d_city varchar(20)
, d_state char(2)
, d_zip char(9)
, primary key(d_w_id, d_id)
)tablegroup tpcc_group NOCOMPRESS pctfree=0 BLOCK_SIZE=8192 partition by hash(d_w_id) partitions 6;
create table cust (c_w_id int
, c_d_id int
, c_id int
, c_discount decimal(4, 4)
, c_credit char(2)
, c_last varchar(16)
, c_first varchar(16)
, c_middle char(2)
, c_balance decimal(12, 2)
, c_ytd_payment decimal(12, 2)
, c_payment_cnt int
, c_credit_lim decimal(12, 2)
, c_street_1 varchar(20)
, c_street_2 varchar(20)
, c_city varchar(20)
, c_state char(2)
, c_zip char(9)
, c_phone char(16)
, c_since date
, c_delivery_cnt int
, c_data varchar(500)
, index icust(c_last, c_d_id, c_w_id, c_first, c_id) local BLOCK_SIZE=8192
, primary key (c_w_id, c_d_id, c_id) 
)tablegroup tpcc_group COMPRESS FOR QUERY pctfree=0 BLOCK_SIZE=8192 USE_BLOOM_FILTER = TRUE 
partition by hash(c_w_id) partitions 6 
partition by column((c_w_id, c_d_id, c_id, c_discount, c_credit, c_last, c_first, c_middle, c_balance, c_ytd_payment, c_payment_cnt, c_credit_lim, c_street_1, c_street_2, c_city, c_state, c_zip, c_phone, c_since, c_delivery_cnt));
create table hist (h_c_id int
, h_c_d_id int
, h_c_w_id int
, h_d_id int
, h_w_id int
, h_date date
, h_amount decimal(6, 2)
, h_data varchar(24)
)tablegroup tpcc_group COMPRESS FOR QUERY pctfree=0 BLOCK_SIZE=8192 partition by hash(h_w_id) partitions 6;
create table nord (no_w_id int
, no_d_id int
, no_o_id int
, primary key ( no_w_id, no_d_id, no_o_id )
)tablegroup tpcc_group TABLE_MODE ='QUEUING' COMPRESS FOR QUERY pctfree=0 BLOCK_SIZE=8192 USE_BLOOM_FILTER = TRUE partition by hash(no_w_id) partitions 6;
create table ordr (o_w_id int
, o_d_id int
, o_id int
, o_c_id int
, o_carrier_id int
, o_ol_cnt int
, o_all_local int
, o_entry_d date
, index iordr(o_w_id, o_d_id, o_c_id, o_id) storing (o_entry_d,o_carrier_id,o_ol_cnt ) local
BLOCK_SIZE=8192
, primary key ( o_w_id, o_d_id, o_id ))tablegroup tpcc_group COMPRESS FOR QUERY pctfree=0
BLOCK_SIZE=8192 progressive_merge_num=1 USE_BLOOM_FILTER = TRUE partition by
hash(o_w_id) partitions 6;
create table ordl (ol_w_id int
, ol_d_id int
, ol_o_id int
, ol_number int
, ol_delivery_d date
, ol_amount decimal(6, 2)
, ol_i_id int
, ol_supply_w_id int
, ol_quantity int
, ol_dist_info char(24)
, primary key (ol_w_id, ol_d_id, ol_o_id, ol_number )
)tablegroup tpcc_group COMPRESS FOR QUERY pctfree=0 BLOCK_SIZE=8192 partition by hash(ol_w_id) partitions 6;
create table item (i_id int
, i_name varchar(24)
, i_price decimal(5,2)
, i_data varchar(50)
, i_im_id int
, primary key(i_id)) COMPRESS FOR QUERY pctfree=0 BLOCK_SIZE=16384
duplicate_scope='cluster' locality='F,R{all_server}@zone_1, F,R{all_server}@zone_2,F,R{all_server}@zone_3' primary_zone='zone_1';
create table stok (s_i_id int
, s_w_id int
, s_order_cnt int
, s_ytd decimal(8)
, s_remote_cnt int
, s_quantity int
, s_data varchar(50)
, s_dist_01 char(24)
, s_dist_02 char(24)
, s_dist_03 char(24)
, s_dist_04 char(24)
, s_dist_05 char(24)
, s_dist_06 char(24)
, s_dist_07 char(24)
, s_dist_08 char(24)
, s_dist_09 char(24)
, s_dist_10 char(24)
, primary key (s_i_id, s_w_id))tablegroup tpcc_group COMPRESS FOR QUERY pctfree=0 BLOCK_SIZE=8192 USE_BLOOM_FILTER = TRUE 
partition by hash(s_w_id) partitions 6 
partition by column((s_i_id, s_w_id, s_order_cnt, s_ytd, s_remote_cnt, s_quantity));
create table load_hist(
total_w_cnt int,
min_w_id int,
max_w_id int,
thread_num int,
dsn varchar(64),
load_begin varchar(30),
load_end varchar(30),
seed_val int,
c_val int,
mem_ratio int,
status int);

CREATE OR REPLACE VIEW stock_item AS
  SELECT /*+ leading(s) use_merge(i) */
         i_price,
         i_name,
         i_data,
         s_i_id,
         s_w_id,         
         s_order_cnt,
         s_ytd,
         s_remote_cnt,
         s_quantity,
         s_data,
         s_dist_01,
         s_dist_02,
         s_dist_03,
         s_dist_04,
         s_dist_05,
         s_dist_06,
         s_dist_07,
         s_dist_08,
         s_dist_09,
         s_dist_10
  FROM stok s, item i WHERE s.s_i_id = i.i_id;

select sysdate, table_name, partitioned, temporary from user_tables order by table_name;
