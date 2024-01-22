SET DEFINE OFF;
CREATE OR REPLACE PACKAGE jbpks_auto
IS
    /*----------------------------------------------------------------------------------------------------
     ** Module   : COMMODITY SYSTEM
     ** and is copyrighted by FSS.
     **
     **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
     **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
     **    graphic, optic recording or otherwise, translated in any language or computer language,
     **    without the prior written permission of Financial Software Solutions. JSC.
     **
     **  MODIFICATION HISTORY
     **  Person      Date           Comments
     **  FSS      20-mar-2010    Created
     ** (c) 2008 by Financial Software Solutions. JSC.
     ----------------------------------------------------------------------------------------------------*/

  PROCEDURE pr_gen_dd_buffer;
  PROCEDURE pr_gen_od_buffer;
   PROCEDURE pr_process_od_bankaccount;
  PROCEDURE pr_trg_account_log (p_acctno in VARCHAR2, p_mod varchar2);
  procedure pr_gen_buf_dd_account(p_acctno varchar2 default null);

  PROCEDURE pr_gen_buf_od_account(p_acctno varchar2 default null);


END;
/


CREATE OR REPLACE PACKAGE BODY jbpks_auto
IS
   -- declare log context
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

procedure pr_gen_buf_dd_account(p_acctno varchar2 default null)
  IS
  v_acctno varchar2(50);

  v_margintype char(1);
  v_actype varchar2(4);
  v_groupleader varchar2(10);
  v_dd_arr txpks_check.ddmastcheck_arrtype;

BEGIN
    plog.setBeginsection(pkgctx, 'pr_gen_buf_ci_account');
    PLOG.INFO(pkgctx,'Begin pr_gen_buf_ci_account');

    if p_acctno is null or p_acctno='ALL' then
        delete from buf_dd_account;
        --commit;
        For rec in (
                    SELECT *
                    from ddmast
                    order by acctno
        )
        loop
            V_ACCTNO:=rec.acctno;
         --   v_margintype:=rec.MRTYPE;
         --   v_actype:=rec.actype;
         --   v_groupleader:=rec.groupleader;

           -- v_dd_arr := txpks_check.fn_DDMASTcheck(V_ACCTNO,'DDMAST','ACCTNO');
            --PLOG.debug(pkgctx,'ppppppp: ' || v_ci_arr(0).pp);

            --if v_margintype in ('N','L') then
             --Tai khoan binh thuong khong Margin
             INSERT INTO buf_dd_account  SELECT
                    cf.CUSTODYCD, cf.fullname, mst.afacctno,mst.acctno, cd1.cdcontent desc_status,mst.lastchange lastdate,

                    NVL(CAS.AMT,0) CARECEIVING, --Tien co tuc cho ve
                    mst.netting,mst.receiving,
                    mst.balance balance,mst.holdbalance,
                    mst.pendinghold,mst.pendingunhold,mst.bankbalance,mst.bankholdbalance,
                    nvl(CASH_RECEIVING_T0,0) CASH_RECEIVING_T0,
                    nvl(CASH_RECEIVING_T1,0) CASH_RECEIVING_T1,
                    nvl(CASH_RECEIVING_T2,0) CASH_RECEIVING_T2,
                    nvl(CASH_RECEIVING_T3,0) CASH_RECEIVING_T3,
                    nvl(CASH_RECEIVING_TN,0) CASH_RECEIVING_TN,
                    nvl(CASH_SENDING_T0,0) CASH_SENDING_T0,
                    nvl(CASH_SENDING_T1,0) CASH_SENDING_T1,
                    nvl(CASH_SENDING_T2,0)  CASH_SENDING_T2,
                    nvl(CASH_SENDING_T3,0) CASH_SENDING_T3,
                    nvl(CASH_SENDING_TN,0) CASH_SENDING_TN,
                    af.careby,
                    mst.refcasaacct,mst.ccycd
               FROM ddmast mst inner join afmast af on af.acctno = mst.afacctno AND mst.acctno = V_ACCTNO
                    INNER JOIN cfmast cf ON cf.custid = af.custid
                    inner join (select * from allcode cd1  where cd1.cdtype = 'CI' AND cd1.cdname = 'STATUS') cd1 on mst.status = cd1.cdval
                    LEFT JOIN
                    (SELECT AFACCTNO,
                                SUM(NVL(CASE WHEN ST.DUETYPE='RM' AND ST.CLEARDAY-ST.TDAY=0 THEN ST.ST_AMT ELSE 0 END,0)) CASH_RECEIVING_T0,
                                SUM(NVL(CASE WHEN ST.DUETYPE='RM' AND ST.CLEARDAY-ST.TDAY=1 THEN ST.ST_AMT ELSE 0 END,0)) CASH_RECEIVING_T1,
                                SUM(NVL(CASE WHEN ST.DUETYPE='RM' AND ST.CLEARDAY-ST.TDAY=2 THEN ST.ST_AMT ELSE 0 END,0)) CASH_RECEIVING_T2,
                                SUM(NVL(CASE WHEN ST.DUETYPE='RM' AND ST.CLEARDAY-ST.TDAY=3 THEN ST.ST_AMT ELSE 0 END,0)) CASH_RECEIVING_T3,
                                SUM(NVL(CASE WHEN ST.DUETYPE='RM' AND ST.CLEARDAY-ST.TDAY>3 THEN ST.ST_AMT ELSE 0 END,0)) CASH_RECEIVING_TN,
                                SUM(NVL(CASE WHEN ST.DUETYPE='RS' AND ST.TRFDAY=0 THEN ST.ST_AMT ELSE 0 END,0)) CASH_SENDING_T0,
                                SUM(NVL(CASE WHEN ST.DUETYPE='RS' AND ST.TRFDAY=1 THEN ST.ST_AMT ELSE 0 END,0)) CASH_SENDING_T1,
                                SUM(NVL(CASE WHEN ST.DUETYPE='RS' AND ST.TRFDAY=2 THEN ST.ST_AMT ELSE 0 END,0)) CASH_SENDING_T2,
                                SUM(NVL(CASE WHEN ST.DUETYPE='RS' AND ST.TRFDAY=3 THEN ST.ST_AMT ELSE 0 END,0)) CASH_SENDING_T3,
                                SUM(NVL(CASE WHEN ST.DUETYPE='RS' AND ST.TRFDAY>3 THEN ST.ST_AMT ELSE 0 END,0)) CASH_SENDING_TN,
                                SUM(NVL(CASE WHEN ST.DUETYPE='RS' AND ST.TRFDAY>=1 AND ST.TRFDAY<=3 AND ST.TXDATE < ST.CURRDATE THEN ST.FEEACR ELSE 0 END,0)) BUY_FEEACR,
                                sum(NVL(CASE WHEN ST.DUETYPE='RS' AND ST.TRFDAY=1 THEN ST.EXECAMTINDAY ELSE 0 END,0)) EXECAMTINDAY
                        FROM
                            VW_BD_PENDING_SETTLEMENT ST WHERE (DUETYPE='RM' OR DUETYPE='SM' OR DUETYPE = 'RS') AND ST.AFACCTNO = V_ACCTNO
                        GROUP BY AFACCTNO) ST
                    on ST.AFACCTNO=MST.acctno


                     LEFT JOIN
                     (
                         SELECT CAS.AFACCTNO, SUM(ROUND((NVL(DTL.EXECRATE,0) + CAM.EXERATE)/100 * CAS.AMT
                                                   --- Thue
                                                   - (NVL(DTL.EXECRATE,0) + CAM.EXERATE)/100 * CAM.PITRATE/100
                                                   -- Phi CK, neu chua thuc hien 3390 cua dot phan bo --> phi =0
                                                   - NVL(DTL.FEEAMT,0)
                                                   )) AMT,
                                              SUM(GREATEST(ROUND(CASE WHEN  CAM.ACTIONDATE >= GETCURRDATE
                                                                      THEN (NVL(DTL.EXECRATE,0) + CAM.EXERATE)/100 * CAS.AMT
                                                                      ELSE 0 END)
                                                    -- Thue
                                                    - (NVL(DTL.EXECRATE,0) + CAM.EXERATE)/100 * CAM.PITRATE/100
                                                    -- Phi CK, neu chua thuc hien 3390 cua dot phan bo --> phi =0
                                                    - NVL(DTL.FEEAMT,0),0
                                                     ))  AVAIAMT,
                                SUM(0) DFAMT
                         FROM CAMAST CAM, CASCHD CAS,
                              (
                                SELECT CAD.CAMASTID, CAS.AFACCTNO, CAD.EXECRATE, CAS.AMT, CAS.FEEAMT, CAS.AUTOID_CASCHD
                                FROM CAMASTDTL CAD, CASCHDDTL CAS
                                WHERE CAD.DELTD <> 'Y' AND CAD.STATUS ='P' AND CAS.DELTD <> 'Y' AND CAS.STATUS ='P'
                                      AND CAD.CAMASTID = CAS.CAMASTID AND CAD.AUTOID = CAS.AUTOID_CAMASTDTL
                              )DTL
                         WHERE CAM.CAMASTID=CAS.CAMASTID AND CAS.AMT>0
                               AND CAS.STATUS IN ('S','I','K') AND CAS.DELTD<>'Y'
                               --AND CAS.CAMASTID = CAD2.CAMASTID (+)
                               AND CAS.CAMASTID = DTL.CAMASTID (+)
                               AND CAS.AUTOID = DTL.AUTOID_CASCHD (+)
                               AND CAS.ISCI <> 'Y' AND CAM.CATYPE = '010'
                         GROUP BY CAS.AFACCTNO
                     ) CAS ON mst.ACCTNO = CAS.AFACCTNO

                     ;




        end loop;
    else
        delete from buf_dd_account where acctno = p_acctno;

        V_ACCTNO:=p_acctno;
        --PLOG.debug(pkgctx,'p_acctno: ' || V_ACCTNO);


        --PLOG.debug(pkgctx,'ppppppp: ' || v_ci_arr(0).pp);

        --if v_margintype in ('N','L') then
             --Tai khoan binh thuong khong Margin
             INSERT INTO buf_dd_account  SELECT
                    cf.CUSTODYCD, cf.fullname, mst.afacctno,mst.acctno, cd1.cdcontent desc_status,mst.lastchange lastdate,

                    NVL(CAS.AMT,0) CARECEIVING, --Tien co tuc cho ve
                    mst.netting,mst.receiving,
                    mst.balance balance,mst.holdbalance,
                    mst.pendinghold,mst.pendingunhold,mst.bankbalance,mst.bankholdbalance,
                    nvl(CASH_RECEIVING_T0,0) CASH_RECEIVING_T0,
                    nvl(CASH_RECEIVING_T1,0) CASH_RECEIVING_T1,
                    nvl(CASH_RECEIVING_T2,0) CASH_RECEIVING_T2,
                    nvl(CASH_RECEIVING_T3,0) CASH_RECEIVING_T3,
                    nvl(CASH_RECEIVING_TN,0) CASH_RECEIVING_TN,
                    nvl(CASH_SENDING_T0,0) CASH_SENDING_T0,
                    nvl(CASH_SENDING_T1,0) CASH_SENDING_T1,
                    nvl(CASH_SENDING_T2,0)  CASH_SENDING_T2,
                    nvl(CASH_SENDING_T3,0) CASH_SENDING_T3,
                    nvl(CASH_SENDING_TN,0) CASH_SENDING_TN,
                    af.careby,
                    mst.refcasaacct,mst.ccycd
               FROM ddmast mst inner join afmast af on af.acctno = mst.afacctno AND mst.acctno = V_ACCTNO
                    INNER JOIN cfmast cf ON cf.custid = af.custid
                    inner join (select * from allcode cd1  where cd1.cdtype = 'CI' AND cd1.cdname = 'STATUS') cd1 on mst.status = cd1.cdval
                    LEFT JOIN
                    (SELECT AFACCTNO,
                                SUM(NVL(CASE WHEN ST.DUETYPE='RM' AND ST.CLEARDAY-ST.TDAY=0 THEN ST.ST_AMT ELSE 0 END,0)) CASH_RECEIVING_T0,
                                SUM(NVL(CASE WHEN ST.DUETYPE='RM' AND ST.CLEARDAY-ST.TDAY=1 THEN ST.ST_AMT ELSE 0 END,0)) CASH_RECEIVING_T1,
                                SUM(NVL(CASE WHEN ST.DUETYPE='RM' AND ST.CLEARDAY-ST.TDAY=2 THEN ST.ST_AMT ELSE 0 END,0)) CASH_RECEIVING_T2,
                                SUM(NVL(CASE WHEN ST.DUETYPE='RM' AND ST.CLEARDAY-ST.TDAY=3 THEN ST.ST_AMT ELSE 0 END,0)) CASH_RECEIVING_T3,
                                SUM(NVL(CASE WHEN ST.DUETYPE='RM' AND ST.CLEARDAY-ST.TDAY>3 THEN ST.ST_AMT ELSE 0 END,0)) CASH_RECEIVING_TN,
                                SUM(NVL(CASE WHEN ST.DUETYPE='RS' AND ST.TRFDAY=0 THEN ST.ST_AMT ELSE 0 END,0)) CASH_SENDING_T0,
                                SUM(NVL(CASE WHEN ST.DUETYPE='RS' AND ST.TRFDAY=1 THEN ST.ST_AMT ELSE 0 END,0)) CASH_SENDING_T1,
                                SUM(NVL(CASE WHEN ST.DUETYPE='RS' AND ST.TRFDAY=2 THEN ST.ST_AMT ELSE 0 END,0)) CASH_SENDING_T2,
                                SUM(NVL(CASE WHEN ST.DUETYPE='RS' AND ST.TRFDAY=3 THEN ST.ST_AMT ELSE 0 END,0)) CASH_SENDING_T3,
                                SUM(NVL(CASE WHEN ST.DUETYPE='RS' AND ST.TRFDAY>3 THEN ST.ST_AMT ELSE 0 END,0)) CASH_SENDING_TN,
                                SUM(NVL(CASE WHEN ST.DUETYPE='RS' AND ST.TRFDAY>=1 AND ST.TRFDAY<=3 AND ST.TXDATE < ST.CURRDATE THEN ST.FEEACR ELSE 0 END,0)) BUY_FEEACR,
                                sum(NVL(CASE WHEN ST.DUETYPE='RS' AND ST.TRFDAY=1 THEN ST.EXECAMTINDAY ELSE 0 END,0)) EXECAMTINDAY
                        FROM
                            VW_BD_PENDING_SETTLEMENT ST WHERE (DUETYPE='RM' OR DUETYPE='SM' OR DUETYPE = 'RS') AND ST.AFACCTNO = V_ACCTNO
                        GROUP BY AFACCTNO) ST
                    on ST.AFACCTNO=MST.acctno


                     LEFT JOIN
                     (
                         SELECT CAS.AFACCTNO, SUM(ROUND((NVL(DTL.EXECRATE,0) + CAM.EXERATE)/100 * CAS.AMT
                                                   --- Thue
                                                   - (NVL(DTL.EXECRATE,0) + CAM.EXERATE)/100 * CAM.PITRATE/100
                                                   -- Phi CK, neu chua thuc hien 3390 cua dot phan bo --> phi =0
                                                   - NVL(DTL.FEEAMT,0)
                                                   )) AMT,
                                              SUM(GREATEST(ROUND(CASE WHEN  CAM.ACTIONDATE >= GETCURRDATE
                                                                      THEN (NVL(DTL.EXECRATE,0) + CAM.EXERATE)/100 * CAS.AMT
                                                                      ELSE 0 END)
                                                    -- Thue
                                                    - (NVL(DTL.EXECRATE,0) + CAM.EXERATE)/100 * CAM.PITRATE/100
                                                    -- Phi CK, neu chua thuc hien 3390 cua dot phan bo --> phi =0
                                                    - NVL(DTL.FEEAMT,0),0
                                                     ))  AVAIAMT,
                                SUM(0) DFAMT
                         FROM CAMAST CAM, CASCHD CAS,
                              (
                                SELECT CAD.CAMASTID, CAS.AFACCTNO, CAD.EXECRATE, CAS.AMT, CAS.FEEAMT, CAS.AUTOID_CASCHD
                                FROM CAMASTDTL CAD, CASCHDDTL CAS
                                WHERE CAD.DELTD <> 'Y' AND CAD.STATUS ='P' AND CAS.DELTD <> 'Y' AND CAS.STATUS ='P'
                                      AND CAD.CAMASTID = CAS.CAMASTID AND CAD.AUTOID = CAS.AUTOID_CAMASTDTL
                              )DTL
                         WHERE CAM.CAMASTID=CAS.CAMASTID AND CAS.AMT>0
                               AND CAS.STATUS IN ('S','I','K') AND CAS.DELTD<>'Y'
                               --AND CAS.CAMASTID = CAD2.CAMASTID (+)
                               AND CAS.CAMASTID = DTL.CAMASTID (+)
                               AND CAS.AUTOID = DTL.AUTOID_CASCHD (+)
                               AND CAS.ISCI <> 'Y' AND CAM.CATYPE = '010'
                         GROUP BY CAS.AFACCTNO
                     ) CAS ON mst.ACCTNO = CAS.AFACCTNO

                     ;



    end if;

    --commit;
    PLOG.INFO(pkgctx,'End pr_gen_buf_ci_account');
    plog.setendsection(pkgctx, 'pr_gen_buf_ci_account');
EXCEPTION WHEN others THEN
    plog.error(pkgctx, 'Error when then Account p_acctno:=' || nvl(p_acctno,'NULL') );
    plog.error(pkgctx, sqlerrm || 'Loi tai dong:' || dbms_utility.format_error_backtrace || 'TK :' || V_ACCTNO);
    plog.setendsection(pkgctx, 'pr_gen_buf_ci_account');
END pr_gen_buf_dd_account;



PROCEDURE pr_gen_buf_od_account (p_acctno varchar2 default null)
  IS
BEGIN
    plog.setBeginsection(pkgctx, 'pr_gen_buf_od_account');
    if p_acctno is null or p_acctno='ALL' then
        PLOG.INFO(pkgctx,'Begin pr_gen_buf_od_account');

        delete from buf_od_account;
        /*
        --commit;
        INSERT INTO buf_od_account (PRICETYPE,DESC_EXECTYPE,SYMBOL,ORSTATUS,
               QUOTEPRICE,ORDERQTTY,REMAINQTTY,EXECQTTY,EXECAMT,
               CANCELQTTY,ADJUSTQTTY,AFACCTNO,CUSTODYCD,FEEDBACKMSG,
               EXECTYPE,CODEID,BRATIO,ORDERID,REFORDERID,TXDATE,TXTIME,SDTIME,
               TLNAME,CTCI_ORDER,TRADEPLACE,EDSTATUS,VIA,TIMETYPE,
               MATCHTYPE,CLEARDAY,EFFDATE,EXPDATE,CAREBY,ORSTATUSVALUE,HOSESESSION, USERNAME, ISCANCEL, ISADMEND,
               ROOTORDERID,TIMETYPEVALUE,MATCHTYPEVALUE,FOACCTNO,ISDISPOSAL,QUOTEQTTY ,LIMITPRICE , CONFIRMED)

          SELECT PRICETYPE, DESC_EXECTYPE, SYMBOL, DESC_STATUS ORSTATUS, --CANCELSTATUS,
                  orderprice/1000 QUOTEPRICE, QUANTITY ORDERQTTY, REMAINQTTY, EXECQTTY, EXECAMT, CANCELQTTY, ADJUSTQTTY,
                  AFACCTNO, CUSTODYCD, FEEDBACKMSG, EXECTYPE, CODEID, BRATIO, ACCTNO ORDERID, REFORDERID, TXDATE, '' TXTIME, SDTIME,
                  upper(tlname) tlname,CTCI_ORDER,tradeplace,'' edstatus,via,timetype,matchtype,clearday,effdate,expdate,CAREBY,status ORSTATUSVALUE,HOSESESSION,
                  USERNAME, ISCANCEL, ISADMEND, ROOTORDERID, TIMETYPEVALUE,MATCHTYPEVALUE,FOACCTNO,ISDISPOSAL,QUOTEQTTY ,LIMITPRICE/1000 , CONFIRMED
              FROM
              -- OD
              (SELECT CFMAST.CUSTODYCD, MST.TXDATE, MST.REFORDERID, MST.AFACCTNO, MST.orderid ACCTNO, '' ORGACCTNO, MST.EXECTYPE,MST.REFORDERID REFACCTNO,
                  MST.PRICETYPE, CD2.cdcontent DESC_EXECTYPE, TO_CHAR(sb.SYMBOL) SYMBOL, MST.orderqtty QUANTITY, MST.orderprice PRICE,   TO_CHAR(CD0.cdcontent) feedbackmsg,
                  MST.orderprice, 'Active' DESC_BOOK, MST.orstatus status,
                  --CD1.cdcontent DESC_STATUS,
                  case when  mst.cancelstatus ='N' then cd1.cdcontent else cd12.cdcontent end DESC_STATUS,
                  CD4.cdcontent DESC_TIMETYPE,
                  CD5.cdcontent DESC_MATCHTYPE, CD6.cdcontent DESC_NORK, CD7.cdcontent DESC_PRICETYPE, NVL(OOD.TXTIME,'') SDTIME,
                  MST.EXECQTTY, MST.EXECAMT, (CASE WHEN MST.EXECQTTY>0 THEN ROUND(MST.EXECAMT/1000/MST.EXECQTTY,2) ELSE 0 END) AVEXECPRICE, MST.REMAINQTTY,  0 CANCELQTTY,  0 ADJUSTQTTY,'A' BOOK,CD8.cdcontent VIA,mst.VIA VIACD,
                  ('') CANCELSTATUS,('') AMENDSTATUS,
                  SYS.SYSVALUE CURRSECSSION,'O' ODSECSSION, nvl(f.username,nvl(mk.tlname,'Auto')) maker, MST.CODEID, 0 BRATIO,
                  nvl(mk.tlname,mst.tlid) tlname,to_char(MAP.CTCI_ORDER) CTCI_ORDER,
                  cd10.cdcontent tradeplace,cd4.cdcontent timetype,cd5.cdcontent matchtype,mst.clearday,mst.txdate effdate, mst.txdate expdate,
                  cf.CAREBY, MST.orstatus,'O' HOSESESSION, case when mst.tlid = '6868' then f.username else MST.CUSTID end USERNAME, 'N' ISCANCEL, 'N' ISADMEND, MST.orderid ROOTORDERID,
                  MST.TIMETYPE TIMETYPEVALUE, MST.MATCHTYPE MATCHTYPEVALUE,
                  CASE WHEN MST.ORDERID = F.orgacctno THEN F.acctno ELSE MST.ORDERID END FOACCTNO,'N' ISDISPOSAL,0 quoteqtty , 0 limitprice , 'Y' confirmed
              FROM CFMAST, AFMAST CF, (select * from ood union select * from oodhist) OOD,
                (select * from odmast ) MST,sbsecurities sb,
                   --TLLOG TL,
                  ALLCODE CD0,ALLCODE CD1, ALLCODE CD2, ALLCODE CD4, ALLCODE CD5, ALLCODE CD6, ALLCODE CD7, ALLCODE CD8, ALLCODE CD10,ALLCODE CD12,
                  ORDERSYS SYS,tlprofiles mk,fomast f,ordermap MAP
              WHERE  CF.ACCTNO=MST.AFACCTNO
                  --AND MST.AFACCTNO=V_PARAFILTER
                  AND MST.orderid=OOD.ORGORDERID(+)
                  --AND MST.TXNUM=TL.TXNUM(+) AND MST.TXDATE=TL.TXDATE(+) AND NVL(TL.TXSTATUS,'1')='1'
                  AND CFMAST.CUSTID=CF.CUSTID and sb.codeid = mst.codeid
                  AND CD0.CDNAME = 'ORSTATUS' AND CD0.CDTYPE ='OD' AND CD0.CDVAL=(CASE WHEN OOD.oodstatus = 'B' AND MST.ORSTATUS = '8' THEN '11' ELSE MST.ORSTATUS END)--MST.ORSTATUS
                  AND CD1.cdtype ='OD' AND CD1.CDNAME='ORSTATUS'
                  AND CD1.CDVAL= (CASE WHEN OOD.oodstatus = 'B' AND MST.orstatus = '8' THEN '11' ELSE MST.orstatus END)--MST.ORSTATUSVALUE--(CASE WHEN MST.REMAINQTTY <> 0 AND MST.EDITSTATUS='C' THEN 'C' WHEN MST.REMAINQTTY <> 0 AND MST.EDITSTATUS='A' THEN 'A' WHEN MST.EDITSTATUS IS NULL AND MST.CANCELQTTY <> 0 THEN '5' WHEN MST.REMAINQTTY = 0 AND MST.CANCELQTTY <> 0 AND MST.EDITSTATUS='C' THEN '3' when MST.REMAINQTTY = 0 and MST.ADJUSTQTTY>0 then '10' ELSE MST.ORSTATUS END)
                  AND SYS.SYSNAME='CONTROLCODE'
                  AND MAP.ORGORDERID(+)=ood.orgorderid
                  AND CD2.cdtype ='OD' AND CD2.CDNAME='BUFEXECTYPE' AND CD2.CDVAL=MST.EXECTYPE||MST.MATCHTYPE
                  AND CD4.cdtype ='OD' AND CD4.CDNAME='TIMETYPE' AND CD4.CDVAL=MST.TIMETYPE
                  AND CD5.cdtype ='OD' AND CD5.CDNAME='MATCHTYPE' AND CD5.CDVAL=MST.MATCHTYPE
                  AND CD6.cdtype ='OD' AND CD6.CDNAME='NORK' AND CD6.CDVAL=MST.NORK
                  AND CD8.cdtype ='OD' AND CD8.CDNAME='VIA' AND CD8.CDVAL=MST.VIA
                  AND CD10.cdtype ='OD' AND CD10.CDNAME='TRADEPLACE' AND CD10.CDVAL=sb.TRADEPLACE
                  AND cd12.cdtype = 'OD' AND cd12.cdname = 'CANCELSTATUS' and cd12.cdval=MST.cancelstatus
                  --AND EXISTS (SELECT TO_DATE(VARVALUE,'DD/MM/YYYY') FROM SYSVAR WHERE GRNAME ='SYSTEM' AND VARNAME='CURRDATE' AND MST.TXDATE = TO_DATE(VARVALUE,'DD/MM/YYYY'))
                  AND CD7.cdtype ='OD' AND CD7.CDNAME='PRICETYPE' AND CD7.CDVAL=MST.PRICETYPE and mst.tlid =mk.tlid (+));
          PLOG.info(pkgctx,'End pr_gen_buf_od_account');
        */
    else
        PLOG.debug(pkgctx,'Begin pr_gen_buf_od_account' || p_acctno);

        delete from buf_od_account where orderid =p_acctno;
        /*
        --commit;
        INSERT INTO buf_od_account (PRICETYPE,DESC_EXECTYPE,SYMBOL,ORSTATUS,
               QUOTEPRICE,ORDERQTTY,REMAINQTTY,EXECQTTY,EXECAMT,
               CANCELQTTY,ADJUSTQTTY,AFACCTNO,CUSTODYCD,FEEDBACKMSG,
               EXECTYPE,CODEID,BRATIO,ORDERID,REFORDERID,TXDATE,TXTIME,SDTIME,
               TLNAME,CTCI_ORDER,TRADEPLACE,VIA,TIMETYPE,
               MATCHTYPE,CLEARDAY,EFFDATE,EXPDATE,CAREBY,ORSTATUSVALUE,HOSESESSION, USERNAME, ISCANCEL, ISADMEND,
               ROOTORDERID,TIMETYPEVALUE,MATCHTYPEVALUE,FOACCTNO,ISDISPOSAL,QUOTEQTTY ,LIMITPRICE , CONFIRMED)

          SELECT PRICETYPE, DESC_EXECTYPE, SYMBOL, DESC_STATUS ORSTATUS, --CANCELSTATUS,
                  orderprice/1000 QUOTEPRICE, QUANTITY ORDERQTTY, REMAINQTTY, EXECQTTY, EXECAMT, CANCELQTTY, ADJUSTQTTY,
                  AFACCTNO, CUSTODYCD, FEEDBACKMSG, EXECTYPE, CODEID, BRATIO, ACCTNO ORDERID, REFORDERID, TXDATE, '' TXTIME, SDTIME,
                  upper(tlname) tlname,CTCI_ORDER,tradeplace,via,timetype,matchtype,clearday,effdate,expdate,CAREBY,status ORSTATUSVALUE,HOSESESSION,
                  USERNAME, ISCANCEL, ISADMEND, ROOTORDERID, TIMETYPEVALUE,MATCHTYPEVALUE,FOACCTNO,ISDISPOSAL,QUOTEQTTY ,LIMITPRICE/1000 , CONFIRMED
              FROM
              -- OD
              (SELECT CFMAST.CUSTODYCD, MST.TXDATE, MST.REFORDERID, MST.AFACCTNO, MST.orderid ACCTNO, '' ORGACCTNO, MST.EXECTYPE,MST.REFORDERID REFACCTNO,
                  MST.PRICETYPE, CD2.cdcontent DESC_EXECTYPE, TO_CHAR(sb.SYMBOL) SYMBOL, MST.orderqtty QUANTITY, MST.orderprice PRICE,   TO_CHAR(CD0.cdcontent) feedbackmsg,
                  MST.orderprice, 'Active' DESC_BOOK, MST.orstatus status,
                  --CD1.cdcontent DESC_STATUS,
                  case when  mst.cancelstatus ='N' then cd1.cdcontent else cd12.cdcontent end DESC_STATUS,
                  CD4.cdcontent DESC_TIMETYPE,
                  CD5.cdcontent DESC_MATCHTYPE, CD6.cdcontent DESC_NORK, CD7.cdcontent DESC_PRICETYPE, NVL(OOD.TXTIME,'') SDTIME,
                  MST.EXECQTTY, MST.EXECAMT, (CASE WHEN MST.EXECQTTY>0 THEN ROUND(MST.EXECAMT/1000/MST.EXECQTTY,2) ELSE 0 END) AVEXECPRICE, MST.REMAINQTTY,  0 CANCELQTTY,  0 ADJUSTQTTY,'A' BOOK,CD8.cdcontent VIA,mst.VIA VIACD,
                  ('') CANCELSTATUS,('') AMENDSTATUS,
                  SYS.SYSVALUE CURRSECSSION,'O' ODSECSSION, nvl(f.username,nvl(mk.tlname,'Auto')) maker, MST.CODEID, 0 BRATIO,
                  nvl(mk.tlname,mst.tlid) tlname,to_char(MAP.CTCI_ORDER) CTCI_ORDER,
                  cd10.cdcontent tradeplace,cd4.cdcontent timetype,cd5.cdcontent matchtype,mst.clearday,mst.txdate effdate, mst.txdate expdate,
                  cf.CAREBY, MST.orstatus,'O' HOSESESSION, case when mst.tlid = '6868' then f.username else MST.CUSTID end USERNAME, 'N' ISCANCEL, 'N' ISADMEND, MST.orderid ROOTORDERID,
                  MST.TIMETYPE TIMETYPEVALUE, MST.MATCHTYPE MATCHTYPEVALUE,
                  CASE WHEN MST.ORDERID = F.orgacctno THEN F.acctno ELSE MST.ORDERID END FOACCTNO,'N' ISDISPOSAL,0 quoteqtty , 0 limitprice , 'Y' confirmed
              FROM CFMAST, AFMAST CF, (select * from ood union select * from oodhist) OOD,
                (select * from odmast ) MST,sbsecurities sb,
                   --TLLOG TL,
                  ALLCODE CD0,ALLCODE CD1, ALLCODE CD2, ALLCODE CD4, ALLCODE CD5, ALLCODE CD6, ALLCODE CD7, ALLCODE CD8, ALLCODE CD10,ALLCODE CD12,
                  ORDERSYS SYS,tlprofiles mk,fomast f,ordermap MAP
              WHERE  CF.ACCTNO=MST.AFACCTNO
                  --AND MST.AFACCTNO=V_PARAFILTER
                  AND MST.orderid=OOD.ORGORDERID(+)
                  --AND MST.TXNUM=TL.TXNUM(+) AND MST.TXDATE=TL.TXDATE(+) AND NVL(TL.TXSTATUS,'1')='1'
                  AND CFMAST.CUSTID=CF.CUSTID and sb.codeid = mst.codeid
                  AND CD0.CDNAME = 'ORSTATUS' AND CD0.CDTYPE ='OD' AND CD0.CDVAL=(CASE WHEN OOD.oodstatus = 'B' AND MST.ORSTATUS = '8' THEN '11' ELSE MST.ORSTATUS END)--MST.ORSTATUS
                  AND CD1.cdtype ='OD' AND CD1.CDNAME='ORSTATUS'
                  AND CD1.CDVAL= (CASE WHEN OOD.oodstatus = 'B' AND MST.orstatus = '8' THEN '11' ELSE MST.orstatus END)--MST.ORSTATUSVALUE--(CASE WHEN MST.REMAINQTTY <> 0 AND MST.EDITSTATUS='C' THEN 'C' WHEN MST.REMAINQTTY <> 0 AND MST.EDITSTATUS='A' THEN 'A' WHEN MST.EDITSTATUS IS NULL AND MST.CANCELQTTY <> 0 THEN '5' WHEN MST.REMAINQTTY = 0 AND MST.CANCELQTTY <> 0 AND MST.EDITSTATUS='C' THEN '3' when MST.REMAINQTTY = 0 and MST.ADJUSTQTTY>0 then '10' ELSE MST.ORSTATUS END)
                  AND SYS.SYSNAME='CONTROLCODE'
                  AND MAP.ORGORDERID(+)=ood.orgorderid
                  AND CD2.cdtype ='OD' AND CD2.CDNAME='BUFEXECTYPE' AND CD2.CDVAL=MST.EXECTYPE||MST.MATCHTYPE
                  AND CD4.cdtype ='OD' AND CD4.CDNAME='TIMETYPE' AND CD4.CDVAL=MST.TIMETYPE
                  AND CD5.cdtype ='OD' AND CD5.CDNAME='MATCHTYPE' AND CD5.CDVAL=MST.MATCHTYPE
                  AND CD6.cdtype ='OD' AND CD6.CDNAME='NORK' AND CD6.CDVAL=MST.NORK
                  AND CD8.cdtype ='OD' AND CD8.CDNAME='VIA' AND CD8.CDVAL=MST.VIA
                  AND CD10.cdtype ='OD' AND CD10.CDNAME='TRADEPLACE' AND CD10.CDVAL=sb.TRADEPLACE
                  AND cd12.cdtype = 'OD' AND cd12.cdname = 'CANCELSTATUS' and cd12.cdval=MST.cancelstatus
                  --AND EXISTS (SELECT TO_DATE(VARVALUE,'DD/MM/YYYY') FROM SYSVAR WHERE GRNAME ='SYSTEM' AND VARNAME='CURRDATE' AND MST.TXDATE = TO_DATE(VARVALUE,'DD/MM/YYYY'))
                  AND CD7.cdtype ='OD' AND CD7.CDNAME='PRICETYPE' AND CD7.CDVAL=MST.PRICETYPE and mst.tlid =mk.tlid (+));
          PLOG.debug(pkgctx,'End pr_gen_buf_od_account' || p_acctno);
        */
    end if;
    --commit;

    plog.setendsection(pkgctx, 'pr_gen_buf_od_account');
EXCEPTION WHEN others THEN
    plog.error(pkgctx, 'Error when then Account p_acctno:=' || nvl(p_acctno,'NULL'));
    plog.error(pkgctx, sqlerrm || 'Loi tai dong:' || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'pr_gen_buf_od_account');
END pr_gen_buf_od_account;

PROCEDURE pr_trg_account_log (p_acctno in VARCHAR2, p_mod varchar2)
IS
v_acctno varchar2(50);
BEGIN
    plog.setbeginsection (pkgctx, 'pr_trg_account_log');
    if p_acctno is not null then
        if length(trim(p_acctno))>0 then
            if p_mod = 'SE' THEN
                plog.debug (pkgctx, 'log_se_account: ' || p_acctno);
                insert into log_se_account (autoid,acctno,status, logtime, applytime)
                values (seq_log_se_account.nextval,p_acctno,'P', SYSTIMESTAMP,NULL);
             elsif p_mod = 'DD' THEN
                plog.debug (pkgctx, 'log_dd_account: ' || p_acctno);
                insert into log_dd_account (autoid,acctno,status, logtime, applytime)
                values (seq_log_dd_account.nextval,p_acctno,'P', SYSTIMESTAMP,NULL);
            elsif p_mod = 'OD' THEN
                plog.debug (pkgctx, 'log_of_account: ' || p_acctno);
                insert into log_od_account (autoid,acctno,status, logtime, applytime)
                values (seq_log_od_account.nextval,p_acctno,'P', SYSTIMESTAMP,NULL);
            end if;
        end if;
    end if;
    plog.setendsection (pkgctx, 'pr_trg_account_log');
EXCEPTION WHEN OTHERS THEN
    plog.error(SQLERRM);
    plog.debug (pkgctx,'got error on release pr_trg_account_log');
    plog.setbeginsection(pkgctx, 'pr_trg_account_log');
END pr_trg_account_log;

--SONLT 20141024: tao gen df buffer


PROCEDURE pr_gen_dd_buffer
IS
CURSOR logRecords IS
    select distinct acctno  from log_dd_account where status = 'P' ;--order by autoid;
    log_rec logRecords%ROWTYPE;
BEGIN
    plog.setbeginsection (pkgctx, 'pr_gen_ci_buffer');
    --plog.debug (pkgctx, '<<BEGIN OF pr_gen_ci_buffer');
    OPEN logRecords;
    loop
        FETCH logRecords INTO log_rec;
        EXIT WHEN logRecords%NOTFOUND;

        update log_dd_account
        set status = 'A', applytime= SYSTIMESTAMP
        where acctno = log_rec.acctno;
        --Xu ly cap nhat lai buffer theo account
        pr_gen_buf_dd_account(log_rec.acctno);
        COMMIT;
        /*update log_ci_account
        set status = 'A', applytime= SYSTIMESTAMP
        where autoid = log_rec.autoid;*/
    end loop;
    commit;
    plog.setendsection (pkgctx, 'pr_gen_ci_buffer');
EXCEPTION WHEN OTHERS THEN
    plog.error(SQLERRM);
    ROLLBACK;
    plog.debug (pkgctx,'got error on release pr_gen_ci_buffer');
    plog.setbeginsection(pkgctx, 'pr_gen_ci_buffer');
END pr_gen_dd_buffer;



PROCEDURE pr_gen_od_buffer
IS
CURSOR logRecords IS
    select * from log_od_account where status = 'P' order by autoid;
    log_rec logRecords%ROWTYPE;
BEGIN
    plog.setbeginsection (pkgctx, 'pr_gen_od_buffer');
    plog.debug (pkgctx, '<<BEGIN OF pr_gen_od_buffer');
    OPEN logRecords;
    loop
        FETCH logRecords INTO log_rec;
        EXIT WHEN logRecords%NOTFOUND;
        --Xu ly cap nhat lai buffer theo account
        pr_gen_buf_od_account(log_rec.acctno);
        COMMIT;
        update log_od_account
        set status = 'A', applytime= SYSTIMESTAMP
        where autoid = log_rec.autoid;
    end loop;
    commit;
    plog.setendsection (pkgctx, 'pr_gen_od_buffer');
EXCEPTION WHEN OTHERS THEN
    plog.error(SQLERRM);
    ROLLBACK;
    plog.debug (pkgctx,'got error on release pr_gen_od_buffer');
    plog.setbeginsection(pkgctx, 'pr_gen_od_buffer');
END pr_gen_od_buffer;

PROCEDURE pr_process_od_bankaccount
IS
CURSOR logRecords IS
    select * from log_od_account where status = 'P' order by autoid;
    log_rec logRecords%ROWTYPE;
BEGIN
    plog.setbeginsection (pkgctx, 'pr_process_od_bankaccount');
   -- plog.debug (pkgctx, '<<BEGIN OF pr_process_od_bankaccount');
    OPEN logRecords;
    loop
        FETCH logRecords INTO log_rec;
        EXIT WHEN logRecords%NOTFOUND;
        --Xu ly cap nhat lai buffer theo account
        pr_gen_buf_od_account(log_rec.acctno);
        COMMIT;
        update log_od_account
        set status = 'A', applytime= SYSTIMESTAMP
        where autoid = log_rec.autoid;
    end loop;
    commit;
    plog.setendsection (pkgctx, 'pr_process_od_bankaccount');
EXCEPTION WHEN OTHERS THEN
    plog.error(SQLERRM);
    ROLLBACK;
    plog.debug (pkgctx,'got error on release pr_process_od_bankaccount');
    plog.setbeginsection(pkgctx, 'pr_process_od_bankaccount');
END pr_process_od_bankaccount;

PROCEDURE pr_gen_rm_transfer
IS
CURSOR logRecords IS
    select * from log_trf_transact where status = 'P' order by autoid;
    log_rec logRecords%ROWTYPE;
    l_err_code varchar2(100);
    l_alternateacct char(1);
    l_autotrf  char(1);
    l_tltxcd varchar2(4);
    l_txdesc varchar(600);
BEGIN
    plog.setbeginsection (pkgctx, 'pr_process_od_bankaccount');

    OPEN logRecords;
    loop
        FETCH logRecords INTO log_rec;
        EXIT WHEN logRecords%NOTFOUND;
            --Xu ly cap nhat lai buffer theo account
            --Kiem tra neu la tai khoan phu co AUTOTRF='Y' la tu dong chuyen tien sang ngan hang thi sinh giao dich chuyen
            select tltxcd,txdesc  into l_tltxcd,l_txdesc from tllog where txnum =log_rec.txnum and txdate =log_rec.txdate;
            select alternateacct, autotrf into l_alternateacct, l_autotrf from afmast where acctno = log_rec.acctno;
            if l_alternateacct='Y' and l_autotrf='Y' then
                cspks_rmproc.pr_rmSUBReleaseBalance(log_rec.acctno,log_rec.amt,l_tltxcd||'@@'||l_txdesc,l_err_code);
                if l_err_code<> '0' then
                    --Co loi xay ra
                    update log_trf_transact set status ='E' where autoid = log_rec.autoid;

                end if;
            end if;
            update log_trf_transact set status ='C' where autoid = log_rec.autoid;
        COMMIT;
        update log_od_account
        set status = 'A', applytime= SYSTIMESTAMP
        where autoid = log_rec.autoid;
    end loop;
    commit;
    plog.setendsection (pkgctx, 'pr_gen_rm_transfer');
EXCEPTION WHEN OTHERS THEN
    plog.error(SQLERRM || dbms_utility.format_error_backtrace);
    ROLLBACK;
    plog.debug (pkgctx,'got error on release pr_gen_rm_transfer');
    plog.setbeginsection(pkgctx, 'pr_gen_rm_transfer');
END pr_gen_rm_transfer;

-- initial LOG
BEGIN
   SELECT *
   INTO logrow
   FROM tlogdebug
   WHERE ROWNUM <= 1;

   pkgctx    :=
      plog.init ('jbpks_auto',
                 plevel => logrow.loglevel,
                 plogtable => (logrow.log4table = 'Y'),
                 palert => (logrow.log4alert = 'Y'),
                 ptrace => (logrow.log4trace = 'Y')
      );
END;
/
