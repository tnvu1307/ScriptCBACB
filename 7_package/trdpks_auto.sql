SET DEFINE OFF;
CREATE OR REPLACE PACKAGE trdpks_auto
IS
     PROCEDURE pr_init (p_level number);

END;
/


CREATE OR REPLACE PACKAGE BODY trdpks_auto
-- Refactored procedure pr_autotxprocess

IS
   pkgctx   plog.log_ctx:= plog.init ('txpks_trdpks_auto',
                 plevel => 30,
                 plogtable => true,
                 palert => false,
                 ptrace => false);
   logrow   tlogdebug%ROWTYPE;

CURSOR curs_build_msg
   IS
      SELECT --'' fld09,                                    --custodycd   fld09,
            a.codeid fld01,
             a.symbol fld07,
             DECODE (a.exectype, 'MS', '1', '0') fld60, --ismortage   fld60, -- FOR 8885
             a.actype fld02,
             a.afacctno || a.codeid fld06,                --seacctno    fld06,
             a.afacctno fld03,
             --'' fld50,                            --a.CUSTNAME        fld50,
             a.timetype fld20,
             a.effdate fld19,
             a.expdate fld21,
             a.exectype fld22,
             a.outpriceallow fld34,
             a.nork fld23,
             a.matchtype fld24,
             a.via fld25,
             a.clearday fld10,
             a.clearcd fld26,
             'O' fld72,                                       --puttype fld72,
             a.pricetype fld27,
             a.quantity fld12,                      --a.ORDERQTTY       fld12,
             a.quoteprice fld11,
             0 fld18,                               --a.ADVSCRAMT       fld18,
             0 fld17,                               --a.ORGQUOTEPRICE   fld17,
             0 fld16,                               --a.ORGORDERQTTY    fld16,
             0 fld31,                               --a.ORGSTOPPRICE    fld31,
             a.bratio fld13,
             0 fld14,                               --a.LIMITPRICE      fld14,
             0 fld40,                                                -- FEEAMT
             --'' fld28,                           --a.VOUCHER         fld28,
             --'' fld29,                           --a.CONSULTANT      fld29,
             --'' fld04,                           --a.ORDERID         fld04,
             a.reforderid fld08,
             b.parvalue fld15,
             a.dfacctno fld95,
             100 fld99,                             --a.HUNDRED         fld99,
             c.tradeunit fld98,
             1 fld96,                                                   -- GTC
             '' fld97,                                                  --mode
             '' fld33,                                              --clientid
             '' fld73,                                            --contrafirm
             '' fld32,                                              --traderid
             '' fld71,                                             --contracus
             a.acctno,                              -- only for test mktstatus
             '' fld30,                              --a.DESC            fld30,
             a.refacctno,
             a.orgacctno,
             a.refprice,
             a.refquantity,
             c.ceilingprice,
             c.floorprice,
             c.marginprice,
             b.tradeplace,
             b.sectype,
             c.tradelot,
             c.securedratiomin,
             c.securedratiomax
      FROM fomast a, sbsecurities b, securities_info c
      WHERE     a.book = 'A'
            AND a.timetype <> 'G'
            AND a.status = 'P'
            AND a.codeid = b.codeid
            AND a.codeid = c.codeid;

   PROCEDURE pr_init (p_level number)
   IS
   BEGIN
   FOR i IN (SELECT *
             FROM tlogdebug)
   LOOP
      logrow.loglevel    := i.loglevel;
      logrow.log4table   := i.log4table;
      logrow.log4alert   := i.log4alert;
      logrow.log4trace   := i.log4trace;
   END LOOP;

   -- 
   pkgctx    :=
      plog.init ('txpks_trdpks_auto',
                 plevel => NVL (logrow.loglevel, 30),
                 plogtable => (NVL (logrow.log4table, 'N') = 'Y'),
                 palert => (NVL (logrow.log4alert, 'N') = 'Y'),
                 ptrace => (NVL (logrow.log4trace, 'N') = 'Y')
      );
   -- 
   END;

BEGIN
   FOR i IN (SELECT *
             FROM tlogdebug)
   LOOP
      logrow.loglevel    := i.loglevel;
      logrow.log4table   := i.log4table;
      logrow.log4alert   := i.log4alert;
      logrow.log4trace   := i.log4trace;
   END LOOP;

   -- 
   pkgctx    :=
      plog.init ('txpks_trdpks_auto',
                 plevel => NVL (logrow.loglevel, 30),
                 plogtable => (NVL (logrow.log4table, 'N') = 'Y'),
                 palert => (NVL (logrow.log4alert, 'N') = 'Y'),
                 ptrace => (NVL (logrow.log4trace, 'N') = 'Y')
      );
   -- 

END trdpks_auto;
/
