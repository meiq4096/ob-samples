set autocommit=1;
set ob_query_timeout=4000000000;
set ob_trx_timeout=4000000000;

CREATE OR REPLACE TYPE intarray IS TABLE OF INTEGER;
CREATE OR REPLACE TYPE numarray IS TABLE OF NUMBER;
CREATE OR REPLACE TYPE distarray IS TABLE OF VARCHAR(24); 
CREATE OR REPLACE TYPE chararray IS TABLE OF VARCHAR(1); 
CREATE OR REPLACE TYPE datarray IS TABLE OF DATE; 


delimiter //

CREATE OR REPLACE PROCEDURE neworder (
  par_w_id INTEGER,
  par_d_id INTEGER,
  par_c_id INTEGER, 
  par_o_all_local INTEGER, 
  par_o_ol_cnt IN OUT BINARY_INTEGER, 
  par_w_tax OUT NUMBER, 
  par_d_tax OUT NUMBER, 
  par_o_id OUT INTEGER, 
  par_c_discount OUT NUMBER,
  par_c_credit OUT varchar2, 
  par_c_last OUT varchar2,
  par_retry IN OUT BINARY_INTEGER, 
  par_cr_date DATE,
  par_ol_i_id intarray, 
  par_ol_supply_w_id intarray, 
  par_i_price OUT numarray, 
  par_i_name OUT distarray, 
  par_s_quantity OUT intarray, 
  par_brand_generic OUT chararray, 
  par_ol_amount OUT numarray, 
  par_s_remote intarray, 
  par_ol_quantity intarray
) 
IS
  TYPE dist_array IS TABLE OF VARCHAR(24); 
  TYPE int_array IS TABLE OF BINARY_INTEGER; 
  s_dist dist_array := dist_array();
  idx1arr intarray := intarray();
  nulldate DATE;
  dummy_local BINARY_INTEGER;
  max_index BINARY_INTEGER;
  not_serializable EXCEPTION;
  PRAGMA EXCEPTION_INIT(not_serializable,-6235); 
BEGIN
  LOOP 
    BEGIN
      UPDATE dist SET d_next_o_id = d_next_o_id + 1
        WHERE d_w_id = par_w_id AND d_id = par_d_id
            RETURNING d_next_o_id-1, d_tax
              INTO par_o_id, par_d_tax;

      SELECT c_discount, c_credit, c_last
        INTO par_c_discount, par_c_credit, par_c_last
          FROM cust
            WHERE c_w_id = par_w_id AND c_d_id = par_d_id AND c_id = par_c_id;

      SELECT w_tax
        INTO par_w_tax
          FROM ware
            WHERE w_id = par_w_id;

      INSERT INTO nord
        VALUES (par_w_id, par_d_id, par_o_id);

      INSERT INTO ordr
        VALUES (par_w_id, par_d_id, par_o_id, par_c_id, null,
                par_o_ol_cnt, par_o_all_local, par_cr_date);

      CASE par_d_id 
        WHEN 1 THEN
          BEGIN
            FORALL idx IN 1 .. par_o_ol_cnt
              UPDATE stock_item
                  SET s_order_cnt = s_order_cnt + 1,
                      s_ytd = s_ytd + par_ol_quantity(idx),
                      s_remote_cnt = s_remote_cnt + par_s_remote(idx),
                      s_quantity = (CASE WHEN s_quantity < par_ol_quantity (idx) + 10
                                      THEN s_quantity +91
                                      ELSE s_quantity
                                  END) - par_ol_quantity(idx)
                  WHERE s_i_id = par_ol_i_id(idx)
                      AND s_w_id = par_ol_supply_w_id(idx) 
                    RETURNING i_price, i_name, s_quantity, s_dist_01,
                          i_price*par_ol_quantity(idx),
                          CASE WHEN i_data NOT LIKE '%ORIGINAL%'
                              THEN 'G'
                          ELSE (CASE WHEN s_data NOT LIKE '%ORIGINAL%'
                                  THEN 'G' ELSE 'B' END)
                          END
                  BULK COLLECT INTO par_i_price, par_i_name, par_s_quantity, s_dist,
                      par_ol_amount,par_brand_generic;
            END;
        WHEN 2 THEN 
          BEGIN
            FORALL idx IN 1 .. par_o_ol_cnt
              UPDATE stock_item
                  SET s_order_cnt = s_order_cnt + 1,
                      s_ytd = s_ytd + par_ol_quantity(idx),
                      s_remote_cnt = s_remote_cnt + par_s_remote(idx),
                      s_quantity = (CASE WHEN s_quantity < par_ol_quantity (idx) + 10
                                      THEN s_quantity +91
                                      ELSE s_quantity
                                  END) - par_ol_quantity(idx)
                  WHERE s_i_id = par_ol_i_id(idx)
                      AND s_w_id = par_ol_supply_w_id(idx) 
                    RETURNING i_price, i_name, s_quantity, s_dist_02,
                          i_price*par_ol_quantity(idx),
                          CASE WHEN i_data NOT LIKE '%ORIGINAL%'
                              THEN 'G'
                          ELSE (CASE WHEN s_data NOT LIKE '%ORIGINAL%'
                                  THEN 'G' ELSE 'B' END)
                          END
                  BULK COLLECT INTO par_i_price, par_i_name, par_s_quantity, s_dist,
                      par_ol_amount,par_brand_generic;
            END;
        WHEN 3 THEN 
          BEGIN
            FORALL idx IN 1 .. par_o_ol_cnt
              UPDATE stock_item
                  SET s_order_cnt = s_order_cnt + 1,
                      s_ytd = s_ytd + par_ol_quantity(idx),
                      s_remote_cnt = s_remote_cnt + par_s_remote(idx),
                      s_quantity = (CASE WHEN s_quantity < par_ol_quantity (idx) + 10
                                      THEN s_quantity +91
                                      ELSE s_quantity
                                  END) - par_ol_quantity(idx)
                  WHERE s_i_id = par_ol_i_id(idx)
                      AND s_w_id = par_ol_supply_w_id(idx) 
                    RETURNING i_price, i_name, s_quantity, s_dist_03,
                          i_price*par_ol_quantity(idx),
                          CASE WHEN i_data NOT LIKE '%ORIGINAL%'
                              THEN 'G'
                          ELSE (CASE WHEN s_data NOT LIKE '%ORIGINAL%'
                                  THEN 'G' ELSE 'B' END)
                          END
                  BULK COLLECT INTO par_i_price, par_i_name, par_s_quantity, s_dist,
                      par_ol_amount,par_brand_generic;
          END;
        WHEN 4 THEN 
          BEGIN
            FORALL idx IN 1 .. par_o_ol_cnt
              UPDATE stock_item
                  SET s_order_cnt = s_order_cnt + 1,
                      s_ytd = s_ytd + par_ol_quantity(idx),
                      s_remote_cnt = s_remote_cnt + par_s_remote(idx),
                      s_quantity = (CASE WHEN s_quantity < par_ol_quantity (idx) + 10
                                      THEN s_quantity +91
                                      ELSE s_quantity
                                  END) - par_ol_quantity(idx)
                  WHERE s_i_id = par_ol_i_id(idx)
                      AND s_w_id = par_ol_supply_w_id(idx) 
                    RETURNING i_price, i_name, s_quantity, s_dist_04,
                          i_price*par_ol_quantity(idx),
                          CASE WHEN i_data NOT LIKE '%ORIGINAL%'
                              THEN 'G'
                          ELSE (CASE WHEN s_data NOT LIKE '%ORIGINAL%'
                                  THEN 'G' ELSE 'B' END)
                          END
                  BULK COLLECT INTO par_i_price, par_i_name, par_s_quantity, s_dist,
                      par_ol_amount,par_brand_generic;
          END;
        WHEN 5 THEN 
          BEGIN
            FORALL idx IN 1 .. par_o_ol_cnt
              UPDATE stock_item
                  SET s_order_cnt = s_order_cnt + 1,
                      s_ytd = s_ytd + par_ol_quantity(idx),
                      s_remote_cnt = s_remote_cnt + par_s_remote(idx),
                      s_quantity = (CASE WHEN s_quantity < par_ol_quantity (idx) + 10
                                      THEN s_quantity +91
                                      ELSE s_quantity
                                  END) - par_ol_quantity(idx)
                  WHERE s_i_id = par_ol_i_id(idx)
                      AND s_w_id = par_ol_supply_w_id(idx) 
                    RETURNING i_price, i_name, s_quantity, s_dist_05,
                          i_price*par_ol_quantity(idx),
                          CASE WHEN i_data NOT LIKE '%ORIGINAL%'
                              THEN 'G'
                          ELSE (CASE WHEN s_data NOT LIKE '%ORIGINAL%'
                                  THEN 'G' ELSE 'B' END)
                          END
                  BULK COLLECT INTO par_i_price, par_i_name, par_s_quantity, s_dist,
                      par_ol_amount,par_brand_generic;
          END;
        WHEN 6 THEN 
          BEGIN
            FORALL idx IN 1 .. par_o_ol_cnt
              UPDATE stock_item
                  SET s_order_cnt = s_order_cnt + 1,
                      s_ytd = s_ytd + par_ol_quantity(idx),
                      s_remote_cnt = s_remote_cnt + par_s_remote(idx),
                      s_quantity = (CASE WHEN s_quantity < par_ol_quantity (idx) + 10
                                      THEN s_quantity +91
                                      ELSE s_quantity
                                  END) - par_ol_quantity(idx)
                  WHERE s_i_id = par_ol_i_id(idx)
                      AND s_w_id = par_ol_supply_w_id(idx) 
                    RETURNING i_price, i_name, s_quantity, s_dist_06,
                          i_price*par_ol_quantity(idx),
                          CASE WHEN i_data NOT LIKE '%ORIGINAL%'
                              THEN 'G'
                          ELSE (CASE WHEN s_data NOT LIKE '%ORIGINAL%'
                                  THEN 'G' ELSE 'B' END)
                          END
                  BULK COLLECT INTO par_i_price, par_i_name, par_s_quantity, s_dist,
                      par_ol_amount,par_brand_generic;
          END;
        WHEN 7 THEN 
          BEGIN
            FORALL idx IN 1 .. par_o_ol_cnt
              UPDATE stock_item
                  SET s_order_cnt = s_order_cnt + 1,
                      s_ytd = s_ytd + par_ol_quantity(idx),
                      s_remote_cnt = s_remote_cnt + par_s_remote(idx),
                      s_quantity = (CASE WHEN s_quantity < par_ol_quantity (idx) + 10
                                      THEN s_quantity +91
                                      ELSE s_quantity
                                  END) - par_ol_quantity(idx)
                  WHERE s_i_id = par_ol_i_id(idx)
                      AND s_w_id = par_ol_supply_w_id(idx) 
                    RETURNING i_price, i_name, s_quantity, s_dist_07,
                          i_price*par_ol_quantity(idx),
                          CASE WHEN i_data NOT LIKE '%ORIGINAL%'
                              THEN 'G'
                          ELSE (CASE WHEN s_data NOT LIKE '%ORIGINAL%'
                                  THEN 'G' ELSE 'B' END)
                          END
                  BULK COLLECT INTO par_i_price, par_i_name, par_s_quantity, s_dist,
                      par_ol_amount,par_brand_generic;
          END;
        WHEN 8 THEN 
          BEGIN
            FORALL idx IN 1 .. par_o_ol_cnt
              UPDATE stock_item
                  SET s_order_cnt = s_order_cnt + 1,
                      s_ytd = s_ytd + par_ol_quantity(idx),
                      s_remote_cnt = s_remote_cnt + par_s_remote(idx),
                      s_quantity = (CASE WHEN s_quantity < par_ol_quantity (idx) + 10
                                      THEN s_quantity +91
                                      ELSE s_quantity
                                  END) - par_ol_quantity(idx)
                  WHERE s_i_id = par_ol_i_id(idx)
                      AND s_w_id = par_ol_supply_w_id(idx) 
                    RETURNING i_price, i_name, s_quantity, s_dist_08,
                          i_price*par_ol_quantity(idx),
                          CASE WHEN i_data NOT LIKE '%ORIGINAL%'
                              THEN 'G'
                          ELSE (CASE WHEN s_data NOT LIKE '%ORIGINAL%'
                                  THEN 'G' ELSE 'B' END)
                          END
                  BULK COLLECT INTO par_i_price, par_i_name, par_s_quantity, s_dist,
                      par_ol_amount,par_brand_generic;
          END;
        WHEN 9 THEN 
          BEGIN
            FORALL idx IN 1 .. par_o_ol_cnt
              UPDATE stock_item
                  SET s_order_cnt = s_order_cnt + 1,
                      s_ytd = s_ytd + par_ol_quantity(idx),
                      s_remote_cnt = s_remote_cnt + par_s_remote(idx),
                      s_quantity = (CASE WHEN s_quantity < par_ol_quantity (idx) + 10
                                      THEN s_quantity +91
                                      ELSE s_quantity
                                  END) - par_ol_quantity(idx)
                  WHERE s_i_id = par_ol_i_id(idx)
                      AND s_w_id = par_ol_supply_w_id(idx) 
                    RETURNING i_price, i_name, s_quantity, s_dist_09,
                          i_price*par_ol_quantity(idx),
                          CASE WHEN i_data NOT LIKE '%ORIGINAL%'
                              THEN 'G'
                          ELSE (CASE WHEN s_data NOT LIKE '%ORIGINAL%'
                                  THEN 'G' ELSE 'B' END)
                          END
                  BULK COLLECT INTO par_i_price, par_i_name, par_s_quantity, s_dist,
                      par_ol_amount,par_brand_generic;
          END;
        WHEN 10 THEN 
          BEGIN
            FORALL idx IN 1 .. par_o_ol_cnt
              UPDATE stock_item
                  SET s_order_cnt = s_order_cnt + 1,
                      s_ytd = s_ytd + par_ol_quantity(idx),
                      s_remote_cnt = s_remote_cnt + par_s_remote(idx),
                      s_quantity = (CASE WHEN s_quantity < par_ol_quantity (idx) + 10
                                      THEN s_quantity +91
                                      ELSE s_quantity
                                  END) - par_ol_quantity(idx)
                  WHERE s_i_id = par_ol_i_id(idx)
                      AND s_w_id = par_ol_supply_w_id(idx) 
                    RETURNING i_price, i_name, s_quantity, s_dist_10,
                          i_price*par_ol_quantity(idx),
                          CASE WHEN i_data NOT LIKE '%ORIGINAL%'
                              THEN 'G'
                          ELSE (CASE WHEN s_data NOT LIKE '%ORIGINAL%'
                                  THEN 'G' ELSE 'B' END)
                          END
                  BULK COLLECT INTO par_i_price, par_i_name, par_s_quantity, s_dist,
                      par_ol_amount,par_brand_generic;
          END;
        ELSE 
          NULL; /* should never be here */
      END CASE;

      /* cache the no of rows processed */
      dummy_local := sql%rowcount;

      /* set rows with invalid item to NULL, par_i_price, par_i_name, par_ol_amount have been setted before */
      IF (dummy_local != par_o_ol_cnt) THEN
      max_index := par_o_ol_cnt - dummy_local;
        par_i_price.EXTEND(max_index);
        par_i_name.EXTEND(max_index);
        par_ol_amount.EXTEND(max_index);
        par_s_quantity.EXTEND(max_index);
        s_dist.EXTEND(max_index);
        par_brand_generic.EXTEND(max_index);

        max_index := sql%rowcount; 

        WHILE (max_index != par_o_ol_cnt) LOOP
        max_index := max_index + 1;
            par_i_price(max_index) := 0; 
            par_i_name(max_index) := 'NO ITEM'; 
            par_ol_amount(max_index) := 0; 
            par_s_quantity(max_index) := 0; 
            s_dist(max_index) := NULL; 
            par_brand_generic(max_index) := ' ';
        END LOOP; 
      END IF;

      IF (idx1arr.count = 0) THEN
        idx1arr.EXTEND(par_o_ol_cnt);
        FOR var_x IN 1..par_o_ol_cnt LOOP
          idx1arr(var_x) := var_x;
        END LOOP;
      END IF;

      /* insert all items including invalid */
      FORALL idx IN 1..par_o_ol_cnt
        INSERT INTO ordl
          VALUES (par_w_id, par_d_id, par_o_id, idx1arr(idx),
                  nulldate, par_ol_amount(idx), par_ol_i_id(idx), par_ol_supply_w_id(idx), par_ol_quantity(idx), s_dist(idx));

      /* If there are no errors, then COMMIT, else ROLLBACK */
      IF (dummy_local != par_o_ol_cnt) THEN 
        par_o_ol_cnt := dummy_local;
        ROLLBACK; 
      ELSE 
        COMMIT;    
      END IF;

      /* No exceptions, exit*/
      EXIT;

      EXCEPTION
        WHEN not_serializable THEN
          BEGIN
            ROLLBACK;
            par_retry := par_retry + 1; 
          END;
    END;      
  END LOOP; 

END neworder ;
// 

CREATE OR REPLACE PROCEDURE orderstatus (
  ware_id INTEGER,
  dist_id INTEGER,
  cust_id IN OUT INTEGER,
  bylastname BINARY_INTEGER,
  cust_last IN OUT VARCHAR2,
  cust_first OUT VARCHAR2,
  cust_middle OUT VARCHAR2,
  cust_balance OUT NUMBER,
  ord_id IN OUT INTEGER,
  ord_entry_d OUT VARCHAR2,
  ord_carrier_id OUT INTEGER,
  ord_ol_cnt OUT INTEGER,
  oline_supply_w_id OUT intarray,
  oline_i_id OUT intarray,
  oline_quantity OUT intarray,
  oline_amount OUT numarray,
  oline_delivery_d OUT datarray
)
IS
  TYPE number_array IS TABLE OF number(38);
  rowArr number_array := number_array();

  read_nothing EXCEPTION;
  PRAGMA EXCEPTION_INIT(read_nothing,-4026);
BEGIN
    IF bylastname != 0 THEN
      SELECT c_id BULK COLLECT INTO rowArr
        FROM cust
          WHERE c_last = cust_last AND c_d_id = dist_id AND c_w_id = ware_id
              ORDER BY c_first;
      IF 0 = rowArr.COUNT THEN
        RAISE read_nothing;
      END IF;
      cust_id := rowArr((rowArr.COUNT + 1) / 2);
    END IF;

    SELECT c_last, c_first, c_middle, c_balance
      INTO cust_last, cust_first, cust_middle, cust_balance
          FROM cust
              WHERE c_w_id = ware_id AND c_d_id = dist_id AND c_id = cust_id;

    /* Select the last ORDER for this customer. */
    SELECT o_id, o_entry_d_c, o_carrier_id_n, o_ol_cnt
      INTO ord_id, ord_entry_d, ord_carrier_id, ord_ol_cnt
          FROM (
      SELECT o_id, to_char(o_entry_d, 'DD-MM-YYYY.HH24:MI:SS') as o_entry_d_c, nvl(o_carrier_id,0) as o_carrier_id_n, o_ol_cnt
      FROM ordr
              WHERE o_w_id = ware_id AND o_d_id = dist_id AND o_c_id = cust_id
              ORDER BY o_w_id, o_d_id, o_c_id, o_id DESC
      ) tmp
        WHERE rownum <= 1;

    SELECT nvl(ol_delivery_d, DATE'1911-09-15') del_date, ol_amount, ol_i_id, ol_supply_w_id, ol_quantity
            BULK COLLECT INTO oline_delivery_d, oline_amount, oline_i_id, oline_supply_w_id, oline_quantity
      FROM ordl
        WHERE ol_w_id = ware_id AND ol_d_id = dist_id AND ol_o_id = ord_id;
    COMMIT;
END orderstatus;
//

CREATE OR REPLACE PROCEDURE delivery (
  ware_id IN INTEGER,
  dist_id OUT intarray,
  order_id OUT intarray,
  ordcnt OUT INTEGER,
  sums OUT numarray,
  del_date IN DATE,
  carrier_id IN INTEGER,
  order_c_id OUT intarray,
  retry IN OUT BINARY_INTEGER
)
IS
  TYPE int_array IS TABLE OF BINARY_INTEGER;
  var_dist int_array := int_array();

  not_serializable EXCEPTION;
  PRAGMA EXCEPTION_INIT(not_serializable,-6235); 

  read_nothing EXCEPTION;
  PRAGMA EXCEPTION_INIT(read_nothing,-4026);
BEGIN

  var_dist.EXTEND(10);
  FOR var_x IN 1..10 LOOP
    var_dist(var_x) := var_x;
  END LOOP;

  LOOP
    BEGIN
      ordcnt := 0;
      IF dist_id.count != 0 THEN
        dist_id.delete;
        order_id.delete;
      END IF;

      FORALL IDX IN 1..10
        DELETE FROM nord
          WHERE no_w_id = ware_id AND no_d_id = var_dist(IDX) AND no_o_id =
            (SELECT no_o_id FROM nord
              WHERE no_d_id = var_dist(IDX) AND no_w_id = ware_id AND rownum <= 1)
          RETURNING no_d_id, no_o_id BULK COLLECT INTO dist_id, order_id;
  
      ordcnt := SQL%ROWCOUNT;
      IF 0 = ordcnt THEN
        RAISE read_nothing;
      END IF;

      FORALL o in 1.. ordcnt
        UPDATE ordr SET o_carrier_id = carrier_id WHERE o_w_id = ware_id 
            AND o_d_id = dist_id(o)
            AND o_id = order_id(o)
            RETURNING o_c_id BULK COLLECT INTO order_c_id;

      FORALL o in 1.. ordcnt
        UPDATE ordl SET ol_delivery_d = del_date WHERE ol_w_id = ware_id
            AND ol_d_id = dist_id(o)
            AND ol_o_id = order_id(o)
            RETURNING sum(ol_amount) BULK COLLECT INTO sums;

      FORALL c IN 1.. ordcnt
        UPDATE cust
            SET c_balance = c_balance + sums(c), c_delivery_cnt = c_delivery_cnt + 1
            WHERE c_w_id = ware_id AND c_d_id = dist_id(c) AND c_id = order_c_id(c);

      COMMIT;

      /* No exceptions, exit*/
      EXIT;

      EXCEPTION
        WHEN not_serializable THEN
          BEGIN
            ROLLBACK;
            retry := retry + 1;
          END;
    END;      
  END LOOP; 

END delivery;
//

CREATE OR REPLACE PROCEDURE payment (
    ware_id INTEGER, 
    dist_id INTEGER,
    cust_w_id INTEGER,
    cust_d_id INTEGER,
    cust_id IN OUT INTEGER,
    bylastname BINARY_INTEGER,
    hist_amount NUMBER,
    cust_last IN OUT VARCHAR2,
    ware_street_1 OUT VARCHAR2,
    ware_street_2 OUT VARCHAR2,
    ware_city OUT VARCHAR2,
    ware_state OUT VARCHAR2,
    ware_zip OUT VARCHAR2,
    dist_street_1 OUT VARCHAR2,
    dist_street_2 OUT VARCHAR2,
    dist_city OUT VARCHAR2,
    dist_state OUT VARCHAR2,
    dist_zip OUT VARCHAR2,
    cust_first OUT VARCHAR2,
    cust_middle OUT VARCHAR2,
    cust_street_1 OUT VARCHAR2,
    cust_street_2 OUT VARCHAR2,
    cust_city OUT VARCHAR2,
    cust_state OUT VARCHAR2,
    cust_zip OUT VARCHAR2,
    cust_phone OUT VARCHAR2,
    cust_since OUT DATE,
    cust_credit OUT VARCHAR2,
    cust_credit_lim OUT NUMBER,
    cust_discount OUT NUMBER,
    cust_balance OUT NUMBER,
    cust_data OUT VARCHAR2,
    cr_date IN DATE,
    retry IN OUT BINARY_INTEGER
)
IS

  dist_name VARCHAR2(10);
  ware_name VARCHAR2(10);

  TYPE number_array IS TABLE OF number(38);
  rowArr number_array := number_array();

  not_serializable EXCEPTION;
  PRAGMA EXCEPTION_INIT(not_serializable,-6235);

  read_nothing EXCEPTION;
  PRAGMA EXCEPTION_INIT(read_nothing,-4026);
BEGIN

  LOOP
    BEGIN
      UPDATE dist
        SET d_ytd = d_ytd + hist_amount
        WHERE d_w_id = ware_id AND d_id = dist_id
        RETURNING d_name, d_street_1, d_street_2, d_city,d_state, d_zip
        INTO dist_name,dist_street_1,dist_street_2,dist_city, dist_state, dist_zip;

      IF 0 = SQL%ROWCOUNT THEN
        RAISE read_nothing;
      END IF;
      
      UPDATE ware
        SET w_ytd = w_ytd + hist_amount
        WHERE w_id = ware_id
        RETURNING w_name, w_street_1, w_street_2, w_city, w_state, w_zip
        INTO ware_name, ware_street_1, ware_street_2, ware_city, ware_state, ware_zip;

      IF bylastname != 0 THEN
        SELECT c_id BULK COLLECT INTO rowArr
          FROM cust
            WHERE c_last = cust_last AND c_d_id = cust_d_id AND c_w_id = cust_w_id
                ORDER BY c_first;
        IF 0 = SQL%ROWCOUNT THEN
          RAISE read_nothing;
        END IF;
        cust_id := rowArr((rowArr.COUNT + 1) / 2);
      END IF;

      UPDATE cust
        SET c_balance = c_balance - hist_amount,
            c_ytd_payment = c_ytd_payment + hist_amount,
            c_payment_cnt = c_payment_cnt + 1
        WHERE c_w_id = cust_w_id AND c_d_id = cust_d_id AND c_id = cust_id
        RETURNING c_discount, c_credit, c_last, c_first, c_middle, c_balance, 
                  c_credit_lim, c_street_1, c_street_2, c_city, c_state, c_zip, c_phone, c_since
        INTO cust_discount, cust_credit, cust_last, cust_first, cust_middle, cust_balance,
             cust_credit_lim, cust_street_1, cust_street_2, cust_city,
             cust_state, cust_zip, cust_phone, cust_since;
      
      IF 0 = SQL%ROWCOUNT THEN
        RAISE read_nothing;
      END IF;

      /* Customer with bad credit, need to do the C_DATA work */
      IF cust_credit = 'BC' THEN
          UPDATE cust
              SET c_data = substr ((to_char (cust_id) || ' ' ||
                                    to_char (cust_d_id) || ' ' ||
                                    to_char (cust_w_id) || ' ' ||
                                    to_char (dist_id) || ' ' ||
                                    to_char (ware_id) || ' ' ||
                                    to_char (hist_amount, '9999.99') || ' | ')
                                    || c_data, 1, 500) 
              WHERE c_w_id = cust_w_id AND c_d_id = cust_d_id AND c_id = cust_id
              RETURNING substr (c_data, 1, 200) 
              INTO cust_data;
      ELSE
          cust_data := ' ';
      END IF;

      INSERT INTO hist
          (h_c_id, h_c_d_id, h_c_w_id, h_d_id, h_w_id, h_date,
          h_amount,h_data)
        VALUES
            (cust_id, cust_d_id, cust_w_id, dist_id, ware_id, cr_date,
          hist_amount, ware_name || ' ' || dist_name);

      COMMIT; 

      /* No exceptions, exit*/
      EXIT;

      EXCEPTION
        WHEN not_serializable THEN
          BEGIN
            ROLLBACK;
            retry := retry + 1;
          END;
    END;    
  END LOOP; 

END payment;
//

CREATE OR REPLACE PROCEDURE stocklevel (
  ware_id INTEGER,
  dist_id INTEGER,
  threshold INTEGER,
  low_stock OUT INTEGER
) 
IS
BEGIN
  SELECT count (DISTINCT s_i_id)
    INTO low_stock
      FROM ordl, stok, dist
        WHERE ol_w_id = ware_id AND d_id = dist_id AND d_w_id = ware_id AND
              d_id = ol_d_id AND d_w_id = ol_w_id AND
              ol_i_id = s_i_id AND ol_w_id = s_w_id AND
              s_quantity < threshold AND
              ol_o_id BETWEEN (d_next_o_id - 20) AND (d_next_o_id - 1);

  COMMIT;  
END stocklevel;
//
delimiter ;
SELECT object_name, object_type, last_ddl_time, status FROM user_objects WHERE object_type IN ('TYPE','VIEW','PROCEDURE');
