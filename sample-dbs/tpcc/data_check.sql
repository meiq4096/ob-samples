
SELECT * FROM (
select 'DIST' table_name , count(*) rows_cnt FROM DIST union
select 'CUST' table_name , count(*) rows_cnt FROM CUST union
select 'HIST' table_name , count(*) rows_cnt FROM HIST union
select 'NORD' table_name , count(*) rows_cnt FROM NORD union
select 'ORDR' table_name , count(*) rows_cnt FROM ORDR union
select 'ORDL' table_name , count(*) rows_cnt FROM ORDL union
select 'ITEM' table_name , count(*) rows_cnt FROM ITEM union
select 'STOK' table_name , count(*) rows_cnt FROM STOK union
select 'WARE' table_name , count(*) rows_cnt FROM WARE
) t ORDER BY rows_cnt;

SELECT /*+ no_use_px parallel(8) */ * FROM(
    SELECT w.w_id, w.w_ytd, d.sum_d_ytd
    FROM ware w,
    (SELECT /*+ no_use_px parallel(8) */ d_w_id, sum(d_ytd) sum_d_ytd FROM dist GROUP BY d_w_id) d
    WHERE w.w_id= d.d_w_id
) x
WHERE w_ytd != sum_d_ytd;

SELECT /*+ no_use_px parallel(8) */ * FROM(
    SELECT d.d_w_id, d.d_id, d.d_next_o_id, o.max_o_id, no.max_no_o_id
    FROM dist d,
        (SELECT /*+ no_use_px parallel(8) */ o_w_id, o_d_id, MAX(o_id) max_o_id FROM ordr GROUP BY o_w_id, o_d_id) o,
        (SELECT /*+ no_use_px parallel(8) */ no_w_id, no_d_id, MAX(no_o_id) max_no_o_id FROM nord GROUP BY no_w_id, no_d_id) no
    WHERE d.d_w_id= o.o_w_id AND d.d_w_id= no.no_w_id AND d.d_id= o.o_d_id AND d.d_id= no.no_d_id
) x
WHERE d_next_o_id - 1!= max_o_id OR d_next_o_id - 1!= max_no_o_id;


SELECT /*+ no_use_px paratLel(8) */ * FROM(
    SELECT /*+ no_use_px parallel(8) */ no_w_id, no_d_id, MAX(no_o_id) max_no_o_id, MIN(no_o_id) min_no_o_id, COUNT(*) count_no
    FROM nord
    GROUP BY no_w_id, no_d_Id
) x
WHERE max_no_o_id - min_no_o_id+ 1!= count_no;



SELECT /*+ no_use_px parallel(8) */ * FROM (
    SELECT o.o_w_id, o.o_d_id, o.sum_o_ol_cnt, ol.count_ol
        FROM (SELECT /*+ no_use_px parallel(8) */ o_w_id, o_d_id, SUM(o_ol_cnt) sum_o_ol_cnt FROM ordr GROUP BY o_w_id, o_d_id) o,
             (SELECT /*+ no_use_px parallel(8) */ ol_w_id, ol_d_id, COUNT(*) count_ol FROM ordl GROUP BY ol_w_id, ol_d_id) ol
        WHERE o.o_w_id = ol.ol_w_id AND o.o_d_id = ol.ol_d_id
) x
WHERE sum_o_ol_cnt != count_ol;

SELECT /*+ no_use_px parallel(8) */ * FROM (
    SELECT o.o_w_id, o.o_d_id, o.o_id, o.o_carrier_id, no.count_no
        FROM ordr o,
            (SELECT /*+ no_use_px parallels) */ no_w_id, no_d_id, no_o_id, COUNT(*) count_no FROM nord GROUP BY no_w_id, no_d_id, no_o_id) no
        WHERE o.o_w_id = no.no_w_id AND o.o_d_id = no.no_d_id AND o.o_id = no.no_o_id
) x
WHERE (o_carrier_id IS NULL AND count_no = 0) OR (o_carrier_id IS NOT NULL AND count_no != 0);

SELECT /*+ no_use_px parallel(8) */ * FROM (
    SELECT o.o_w_id, o.o_d_id, o.o_id, o.o_ol_cnt, ol.count_ol
        FROM ordr o,
             (SELECT /*+ no_use_px parallel(8) */ ol_w_id, ol_d_id, ol_o_id, COUNT(*) count_ol FROM ordl GROUP BY ol_w_id, ol_d_id, ol_o_id) ol
         WHERE o.o_w_id = ol.ol_w_id AND o.o_d_id = ol.ol_d_id AND o.o_id = ol.ol_o_id
) x
WHERE o_ol_cnt != count_ol;

SELECT /*+ no_use_px parallel(8) */ * FROM (
    SELECT /*+ no_use_px parallel(8) */ ol.ol_w_id, ol.ol_d_id, ol.ol_o_id, ol.ol_delivery_d, o.o_carrier_id
        FROM ordl ol, ordr o
            WHERE ol.ol_w_id = o.o_w_id AND
                  ol.ol_d_id = o.o_d_id AND
                  ol.ol_o_id = o.o_id
) x
WHERE (ol_delivery_d IS NULL AND o_carrier_id IS NOT NULL) OR
       (ol_delivery_d IS NOT NULL AND o_carrier_id IS NULL);
       
SELECT /*+ no_use_px parallel(8) */ * FROM (
    SELECT w.w_id, w.w_ytd, h.sum_h_amount
        FROM ware w,
             (SELECT /*+ no_use_px parallel(8) */ h_w_id, SUM(h_amount) sum_h_amount FROM hist GROUP BY h_w_id) h
        WHERE w.w_id = h.h_w_id) x
WHERE w_ytd != sum_h_amount;

SELECT /*+ no_use_px parallel(8) */ * FROM (
    SELECT d.d_w_id, d.d_id, d.d_ytd, h.sum_h_amount
        FROM dist d,
             (SELECT /*+ no_use_px parallel(8) */ h_w_id, h_d_id, SUM(h_amount) sum_h_amount FROM hist GROUP BY h_w_id, h_d_id) h
        WHERE d.d_w_id = h.h_w_id AND d.d_id = h.h_d_id
) x
WHERE d_ytd != sum_h_amount;

