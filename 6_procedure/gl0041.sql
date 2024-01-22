SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE gl0041 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_DATE         IN       VARCHAR2
  )
IS
--
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
-- BAO CAO CHI TIEU NGOAI BANG
-- MODIFICATION HISTORY
-- PERSON      DATE         COMMENTS
-- ANTB      15/03/2014     CREATED
-- ---------   ------       -------------------------------------------
--
   CUR            PKG_REPORT.REF_CURSOR;
   V_STROPT       VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (100);                   -- USED WHEN V_NUMOPTION > 0
   V_INBRID       VARCHAR2 (5);
   v_strIBRID     VARCHAR2 (4);
   vn_BRID        varchar2(50);
   vn_TRADEPLACE varchar2(50);
   v_strTRADEPLACE VARCHAR2 (4);
   v_OnDate date;
   v_CurrDate date;
   v_strsqlcmd varchar2(4000);

BEGIN

/*IF V_STROPTION = 'A' THEN
    V_STRBRID := '%';
ELSIF V_STROPTION = 'B' then
    V_STRBRID := BRID;
else
    V_STRBRID := BRID;
END IF;*/
    V_STROPT := upper(OPT);
    V_INBRID := BRID;



    v_OnDate:= to_date(I_DATE,'DD/MM/RRRR');

    delete from mis_item_results where groupid='GL0041' and busdate = v_OnDate;
    commit;

    For rec in(
       select * from mis_items_new where groupid = 'GL0041' order by serial
       )
       Loop
           v_strsqlcmd:= replace(upper(rec.sqlcmd),'@BUSDATE',v_ondate);
           if length(v_strsqlcmd) > 0 then
              Begin
                Execute immediate v_strsqlcmd;
                commit;
                EXCEPTION
              WHEN OTHERS
               THEN
               --dbms_output.put_line('GL0041 ERROR');
               plog.error('GL0041: - SQL: ' ||dbms_utility.format_error_backtrace);
              end;
           end if;
       End Loop;
       /*
    -- 6.1 chung khoan giao dich
        --6.1.1 Chung khoan giao dich thanh vien luu ky
        update mis_item_results
        set itemvalue = (select sum(to_number(itemvalue)) from mis_item_results where groupid='GL0041' and itemcd in ('008A','008B') and busdate = v_ondate)
        where groupid='GL0041' and itemcd = '008' and busdate = v_ondate;
        --6.1.2 Chung khoan giao dich KH TN
        update mis_item_results
        set itemvalue = (select sum(to_number(itemvalue)) from mis_item_results where groupid='GL0041' and itemcd in ('009A','009B') and busdate = v_ondate)
        where groupid='GL0041' and itemcd = '009' and busdate = v_ondate;
        --6.1.3 Chung khoan giao dich KH NN
        update mis_item_results
        set itemvalue = (select sum(to_number(itemvalue)) from mis_item_results where groupid='GL0041' and itemcd in ('010A','010B') and busdate = v_ondate)
        where groupid='GL0041' and itemcd = '010' and busdate = v_ondate;
    update mis_item_results
    set itemvalue = (select sum(to_number(itemvalue)) from mis_item_results where groupid='GL0041' and itemcd in ('008','009','010','011') and busdate = v_ondate)
    where groupid='GL0041' and itemcd = '007' and busdate = v_ondate;
    -- 6.2. Ch?ng kho?t?m ng?ng giao d?ch
    update mis_item_results
    set itemvalue = (select sum(to_number(itemvalue)) from mis_item_results where groupid='GL0041' and itemcd in ('013','014','015','016') and busdate = v_ondate)
    where groupid='GL0041' and itemcd = '012' and busdate = v_ondate;
    -- 6.3 Chung khoan cam co
    update mis_item_results
    set itemvalue = (select sum(to_number(itemvalue)) from mis_item_results where groupid='GL0041' and itemcd in ('018','019','020','021') and busdate = v_ondate)
    where groupid='GL0041' and itemcd = '017' and busdate = v_ondate;
    -- 6.4 Chung khoan tam giu
    update mis_item_results
    set itemvalue = (select sum(to_number(itemvalue)) from mis_item_results where groupid='GL0041' and itemcd in ('023','024','025','026') and busdate = v_ondate)
    where groupid='GL0041' and itemcd = '022' and busdate = v_ondate;
    -- 6.5 Chung khoan cho thanh toan
        --6.5.1 Chung khoan cho thanh toan thanh vien luu ky
        update mis_item_results
        set itemvalue = (select sum(to_number(itemvalue)) from mis_item_results where groupid='GL0041' and itemcd in ('028A') and busdate = v_ondate)
        where groupid='GL0041' and itemcd = '028' and busdate = v_ondate;
        --6.5.2 Chung khoan cho thanh toan KH TN
        update mis_item_results
        set itemvalue = (select sum(to_number(itemvalue)) from mis_item_results where groupid='GL0041' and itemcd in ('029A') and busdate = v_ondate)
        where groupid='GL0041' and itemcd = '029' and busdate = v_ondate;
        --6.5.3 Chung khoan cho thanh toan KH NN
        update mis_item_results
        set itemvalue = (select sum(to_number(itemvalue)) from mis_item_results where groupid='GL0041' and itemcd in ('030A') and busdate = v_ondate)
        where groupid='GL0041' and itemcd = '030' and busdate = v_ondate;
    -- 6.5 Chung khoan cho thanh toan
    update mis_item_results
    set itemvalue = (select sum(to_number(itemvalue)) from mis_item_results where groupid='GL0041' and itemcd in ('028','029','030','031') and busdate = v_ondate)
    where groupid='GL0041' and itemcd = '027' and busdate = v_ondate;
    -- 6.6 Chung khoan phong toa cho rut
    update mis_item_results
    set itemvalue = (select sum(to_number(itemvalue)) from mis_item_results where groupid='GL0041' and itemcd in ('033','034','035','036') and busdate = v_ondate)
    where groupid='GL0041' and itemcd = '032' and busdate = v_ondate;
    -- 6.7 Chung khoan cho giao dich
    update mis_item_results
    set itemvalue = (select sum(to_number(itemvalue)) from mis_item_results where groupid='GL0041' and itemcd in ('038','039','040','041') and busdate = v_ondate)
    where groupid='GL0041' and itemcd = '037' and busdate = v_ondate;
    -- 6.8 Chung khoan ky quy dam bao khoan vay
    update mis_item_results
    set itemvalue = (select sum(to_number(itemvalue)) from mis_item_results where groupid='GL0041' and itemcd in ('043','044','045','046') and busdate = v_ondate)
    where groupid='GL0041' and itemcd = '042' and busdate = v_ondate;
    -- 6 Chung khoan luu ky
    update mis_item_results
    set itemvalue = (select sum(to_number(itemvalue)) from mis_item_results where groupid='GL0041' and itemcd in ('007','012','017','022','027','032','037','042','047') and busdate = v_ondate)
    where groupid='GL0041' and itemcd = '006' and busdate = v_ondate;
    -- 7.1 chung khoan giao dich - DCCNY
        --7.1.1 Chung khoan giao dich thanh vien luu ky
        update mis_item_results
        set itemvalue = (select sum(to_number(itemvalue)) from mis_item_results where groupid='GL0041' and itemcd in ('052A','052B') and busdate = v_ondate)
        where groupid='GL0041' and itemcd = '052' and busdate = v_ondate;
        --7.1.2 Chung khoan giao dich KH TN
        update mis_item_results
        set itemvalue = (select sum(to_number(itemvalue)) from mis_item_results where groupid='GL0041' and itemcd in ('053A','053B') and busdate = v_ondate)
        where groupid='GL0041' and itemcd = '053' and busdate = v_ondate;
        --7.1.3 Chung khoan giao dich KH NN
        update mis_item_results
        set itemvalue = (select sum(to_number(itemvalue)) from mis_item_results where groupid='GL0041' and itemcd in ('054A','054B') and busdate = v_ondate)
        where groupid='GL0041' and itemcd = '054' and busdate = v_ondate;
    update mis_item_results
    set itemvalue = (select sum(to_number(itemvalue)) from mis_item_results where groupid='GL0041' and itemcd in ('052','053','054','055') and busdate = v_ondate)
    where groupid='GL0041' and itemcd = '051' and busdate = v_ondate;
    -- 7.2 chung khoan tam ngung giao dich - DCCNY
    update mis_item_results
    set itemvalue = (select sum(to_number(itemvalue)) from mis_item_results where groupid='GL0041' and itemcd in ('057','058','059','060') and busdate = v_ondate)
    where groupid='GL0041' and itemcd = '056' and busdate = v_ondate;
    -- 7.3 chung khoan cam co - DCCNY
    update mis_item_results
    set itemvalue = (select sum(to_number(itemvalue)) from mis_item_results where groupid='GL0041' and itemcd in ('062','063','064','065') and busdate = v_ondate)
    where groupid='GL0041' and itemcd = '061' and busdate = v_ondate;
    -- 7.4 chung khoan tam giu - DCCNY
    update mis_item_results
    set itemvalue = (select sum(to_number(itemvalue)) from mis_item_results where groupid='GL0041' and itemcd in ('067','068','069','070') and busdate = v_ondate)
    where groupid='GL0041' and itemcd = '066' and busdate = v_ondate;
    -- 7.5 chung khoan cho thanh toan - DCCNY
        --7.5.1 Chung khoan cho thanh toan thanh vien luu ky - DCCNY
        update mis_item_results
        set itemvalue = (select sum(to_number(itemvalue)) from mis_item_results where groupid='GL0041' and itemcd in ('072A') and busdate = v_ondate)
        where groupid='GL0041' and itemcd = '072' and busdate = v_ondate;
        --7.5.2 Chung khoan cho thanh toan KH TN - DCCNY
        update mis_item_results
        set itemvalue = (select sum(to_number(itemvalue)) from mis_item_results where groupid='GL0041' and itemcd in ('073A') and busdate = v_ondate)
        where groupid='GL0041' and itemcd = '073' and busdate = v_ondate;
        --7.5.3 Chung khoan cho thanh toan KH NN - DCCNY
        update mis_item_results
        set itemvalue = (select sum(to_number(itemvalue)) from mis_item_results where groupid='GL0041' and itemcd in ('074A') and busdate = v_ondate)
        where groupid='GL0041' and itemcd = '074' and busdate = v_ondate;
    -- 7.5 Chung khoan cho thanh toan - DCCNY
    update mis_item_results
    set itemvalue = (select sum(to_number(itemvalue)) from mis_item_results where groupid='GL0041' and itemcd in ('072','073','074','075') and busdate = v_ondate)
    where groupid='GL0041' and itemcd = '071' and busdate = v_ondate;
    -- 7.6 chung khoan phong toa cho rut - DCCNY
    update mis_item_results
    set itemvalue = (select sum(to_number(itemvalue)) from mis_item_results where groupid='GL0041' and itemcd in ('077','078','079','080') and busdate = v_ondate)
    where groupid='GL0041' and itemcd = '076' and busdate = v_ondate;
    -- 7 Chung khoan luu ky DCCNY
    update mis_item_results
    set itemvalue = (select sum(to_number(itemvalue)) from mis_item_results where groupid='GL0041' and itemcd in ('051','056','061','066','071','076','081') and busdate = v_ondate)
    where groupid='GL0041' and itemcd = '050' and busdate = v_ondate;
*/
    -- A. 8. Tai san tai chinh niem yet/dang ky giao dich tai VSD cua CTCK
    update mis_item_results
    set itemvalue = (select sum(to_number(r.itemvalue))
                        from mis_item_results r
                        where r.groupid='GL0041' and r.itemcd in ('A008A','A008B','A008C','A008D','A008E','A008F','A008G') and r.busdate = v_ondate
                    )
    where groupid='GL0041' and itemcd = 'A008';
    -- A. 9. Tai san tai chinh da luu ky tai VSD va chua giao dich CTCK
    update mis_item_results
    set itemvalue = (select sum(to_number(r.itemvalue))
                        from mis_item_results r
                        where r.groupid='GL0041' and r.itemcd in ('A009A','A009B','A009C','A009D') and r.busdate = v_ondate
                    )
    where groupid='GL0041' and itemcd = 'A009';
    -- B. 1. Tai san tai chinh niem yet/dang ky giao dich tai VSD cua Nha dau tu
    update mis_item_results
    set itemvalue = (select sum(to_number(r.itemvalue))
                        from mis_item_results r
                        where r.groupid='GL0041' and r.itemcd in ('B001A','B001B','B001C','B001D','B001E','B001F','B001G') and r.busdate = v_ondate
                    )
    where groupid='GL0041' and itemcd = 'B001';
    -- B. 2. Tai san tai chinh da luu ky tai VSD va chua giao dich Nha dau tu
    update mis_item_results
    set itemvalue = (select sum(to_number(r.itemvalue))
                        from mis_item_results r
                        where r.groupid='GL0041' and r.itemcd in ('B002A','B002B','B002C','B002D') and r.busdate = v_ondate
                    )
    where groupid='GL0041' and itemcd = 'B002';
    -- B. 6.1. Tien gui ve hoat dong luu ky CK
    update mis_item_results
    set itemvalue = (select sum(to_number(r.itemvalue))
                        from mis_item_results r
                        where r.groupid='GL0041' and r.itemcd in ('B0061A','B0061B') and r.busdate = v_ondate
                    )
    where groupid='GL0041' and itemcd = 'B0061';
    -- B. 6.3. Tien gui bu tru va thanh toan giao dich CK
    update mis_item_results
    set itemvalue = (select sum(to_number(r.itemvalue))
                        from mis_item_results r
                        where r.groupid='GL0041' and r.itemcd in ('B0063A','B0063B') and r.busdate = v_ondate
                    )
    where groupid='GL0041' and itemcd = 'B0063';
    -- B. 6. Tien gui cua khach hang
    update mis_item_results
    set itemvalue = (select sum(to_number(r.itemvalue))
                        from mis_item_results r
                        where r.groupid='GL0041' and r.itemcd in ('B0061','B0062','B0063','B0064') and r.busdate = v_ondate
                    )
    where groupid='GL0041' and itemcd = 'B006';
    -- B. 7. Phai tra Nha dau tu ve tien gui giao dich CK theo phuong thuc CTCK quan ly
    update mis_item_results
    set itemvalue = (select sum(to_number(r.itemvalue))
                        from mis_item_results r
                        where r.groupid='GL0041' and r.itemcd in ('B0071','B0072') and r.busdate = v_ondate
                    )
    where groupid='GL0041' and itemcd = 'B007';
    -- B. 8. Phai tra Nha dau tu ve tien gui giao dich CK theo phuong thuc Ngan hang thuong mai quan ly
    update mis_item_results
    set itemvalue = (select sum(to_number(r.itemvalue))
                        from mis_item_results r
                        where r.groupid='GL0041' and r.itemcd in ('B0081','B0082') and r.busdate = v_ondate
                    )
    where groupid='GL0041' and itemcd = 'B008';
-- Main report
OPEN PV_REFCURSOR FOR
    SELECT serial, item.itemcd, item.itemname, results.itemvalue, item.amttype, item.fonttype, results.busdate, item.shortname
    FROM mis_item_results results, mis_items_new item
    where results.groupid = item.groupid
        and results.itemcd = item.shortname
        and item.groupid = 'GL0041'
        and item.visible = 'Y'
        --and length(results.itemcd) = 3
        and results.busdate = v_OnDate
    order by serial
;

EXCEPTION
  WHEN OTHERS
   THEN
   dbms_output.put_line('GL0041 ERROR');
   plog.error('GL0041: - ' ||dbms_utility.format_error_backtrace);
      RETURN;
END;
/
