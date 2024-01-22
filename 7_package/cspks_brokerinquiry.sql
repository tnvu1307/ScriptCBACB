SET DEFINE OFF;
CREATE OR REPLACE PACKAGE cspks_brokerinquiry
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
  procedure pr_ExecInternalRigthOffTranfer
    (
     p_afacctno  IN  VARCHAR2,
     p_afacctnogoal  IN  VARCHAR2,
     p_via IN VARCHAR2,
     p_autoid IN VARCHAR2,
     p_err_code  OUT varchar2,
     p_err_message out varchar2
    );
  procedure pr_getInternalRigthOffTranfer
    (p_refcursor in out pkg_report.ref_cursor,
     p_afacctno  IN  varchar2
    );

END;
/


CREATE OR REPLACE PACKAGE BODY cspks_brokerinquiry
IS
   -- declare log context
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;
procedure pr_ExecInternalRigthOffTranfer
    (
     p_afacctno  IN  VARCHAR2,
     p_afacctnogoal  IN  VARCHAR2,
     p_via IN VARCHAR2,
     p_autoid IN VARCHAR2,
     p_err_code  OUT varchar2,
     p_err_message out varchar2
    )
IS
l_txmsg         tx.msg_rectype;
l_err_param     varchar2(300);

v_afacctno VARCHAR2(100);
v_afacctnogoal VARCHAR2(100);
v_strCURRDATE varchar2(20);
v_count NUMBER;
--field gd
v_CODEID VARCHAR2(20);
v_AUTOID varchar2(30);
v_TRADE  NUMBER;
v_QTTY NUMBER;
v_AQTTY NUMBER;
v_PQTTY NUMBER;
v_AMT NUMBER;
v_CAMASTID VARCHAR2(50);
v_RQTTY NUMBER;
v_ISSE VARCHAR2(50);
v_ISCI VARCHAR2(50);
v_DESCRIPTION VARCHAR2(1000);
v_DESC VARCHAR2(1000);
v_CUSTODYCD  VARCHAR2(50);
v_CUSTNAME   VARCHAR2(100);
v_ADDRESS    VARCHAR2(500);
v_LICENSE VARCHAR2(50);

BEGIN
    plog.setendsection(pkgctx, 'pr_ExecInternalRigthOffTranfer');
    v_afacctno := p_afacctno;
    v_afacctnogoal := p_afacctnogoal;

    p_err_code := fopks_api.fn_CheckActiveSystem;
    IF p_err_code <> systemnums.C_SUCCESS THEN
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
         plog.setendsection(pkgctx, 'pr_ExecInternalRigthOffTranfer');
        return;
    END IF;
    --check khong duoc cung so tieu khoan
    IF trim(v_afacctno) = trim(v_afacctnogoal) THEN
        p_err_code:='-700501';
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
         plog.setendsection(pkgctx, 'pr_ExecInternalRigthOffTranfer');
        return;
    END IF;

    SELECT TO_DATE (varvalue, systemnums.c_date_format)
               INTO v_strCURRDATE
               FROM sysvar
               WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';

    IF p_via = 'O' THEN --Online
        l_txmsg.tlid        := systemnums.C_ONLINE_USERID;
        --Set txnum
        SELECT systemnums.C_OL_PREFIXED || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
        INTO l_txmsg.txnum
        FROM DUAL;
    ELSIF p_via = 'H' THEN --Home
        l_txmsg.tlid := systemnums.C_HOME_USERID;
        SELECT systemnums.C_HT_PREFIXED || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
        INTO l_txmsg.txnum
        FROM DUAL;
    ELSIF p_via = 'M' THEN --mobile
        l_txmsg.tlid        := systemnums.C_MOBILE_USERID;
        SELECT systemnums.C_MB_PREFIXED || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
        INTO l_txmsg.txnum
        FROM DUAL;
    END IF;
    SELECT count(1) INTO v_count
    FROM CASCHD CA, SBSECURITIES SYM, SBSECURITIES EXSYM, ALLCODE A0,
         ALLCODE A1, CAMAST, AFMAST, CFMAST,SBSECURITIES SYMTO
    WHERE A0.CDTYPE = 'CA' AND A0.CDNAME = 'CATYPE' AND A0.CDVAL = CAMAST.CATYPE
            AND A1.CDTYPE = 'CA' AND A1.CDNAME = 'CASTATUS' AND A1.CDVAL = CA.STATUS
            AND CA.CAMASTID = CAMAST.CAMASTID AND CAMAST.CODEID = SYM.CODEID
            AND CA.DELTD ='N'
            AND EXSYM.CODEID = (CASE WHEN CAMAST.EXCODEID IS NULL THEN CAMAST.CODEID ELSE CAMAST.EXCODEID END)
            AND CA.AFACCTNO = AFMAST.ACCTNO
            AND AFMAST.CUSTID = CFMAST.CUSTID
            -- 04/06/2015 - TruongLD add --> Neu su kien quyen mua --> chi cho chuyen neu con quyen
            and (case when CAMAST.catype in ('014') and ca.status not in ('J','C', 'F','S') then decode(CA.PQTTY,0, 0, 1) else 1 end) = 1
            -- Truong hop khach hang da dang ky 1 phan va user da lam GD 3369 --> khong cho khach hang lam
            and (case when CAMAST.catype in ('014') and CAMAST.status not in ('J','C', 'F','S') then 1 else 0 end) = 1
            -- End TruongLD
            and nvl(camast.tocodeid,camast.codeid)=symto.codeid
            and ca.status not in ('J','C')
    AND CA.AUTOID =p_autoid
    and ca.afacctno=v_afacctno;

    IF v_count =1 THEN
        SELECT CA.CODEID,CA.AUTOID,CA.TRADE,CA.QTTY, CA.AQTTY,CA.PQTTY, CA.AMT, CA.CAMASTID,CA.RQTTY,
           ISSE,CA.ISCI, CAMAST.DESCRIPTION,CFMAST.CUSTODYCD,CFMAST.FULLNAME,CFMAST.ADDRESS,cfmast.idcode
        INTO
             v_CODEID, v_AUTOID,v_TRADE, v_QTTY, v_AQTTY, v_PQTTY, v_AMT, v_CAMASTID, v_RQTTY,
             v_ISSE, v_ISCI, v_DESCRIPTION, v_CUSTODYCD, v_CUSTNAME, v_ADDRESS, v_LICENSE
        FROM CASCHD CA, SBSECURITIES SYM, SBSECURITIES EXSYM, ALLCODE A0,
             ALLCODE A1, CAMAST, AFMAST, CFMAST,SBSECURITIES SYMTO
        WHERE A0.CDTYPE = 'CA' AND A0.CDNAME = 'CATYPE' AND A0.CDVAL = CAMAST.CATYPE
            AND A1.CDTYPE = 'CA' AND A1.CDNAME = 'CASTATUS' AND A1.CDVAL = CA.STATUS
            AND CA.CAMASTID = CAMAST.CAMASTID AND CAMAST.CODEID = SYM.CODEID
            AND CA.DELTD ='N'
            AND EXSYM.CODEID = (CASE WHEN CAMAST.EXCODEID IS NULL THEN CAMAST.CODEID ELSE CAMAST.EXCODEID END)
            AND CA.AFACCTNO = AFMAST.ACCTNO
            AND AFMAST.CUSTID = CFMAST.CUSTID
            -- 04/06/2015 - TruongLD add --> Neu su kien quyen mua --> chi cho chuyen neu con quyen
            and (case when CAMAST.catype in ('014') and ca.status not in ('J','C', 'F','S') then decode(CA.PQTTY,0, 0, 1) else 1 end) = 1
            -- Truong hop khach hang da dang ky 1 phan va user da lam GD 3369 --> khong cho khach hang lam
            and (case when CAMAST.catype in ('014') and CAMAST.status not in ('J','C', 'F','S') then 1 else 0 end) = 1
            -- End TruongLD
            and nvl(camast.tocodeid,camast.codeid)=symto.codeid
            and ca.status not in ('J','C')
            AND CA.AUTOID =p_autoid
            and ca.afacctno=v_afacctno;
    END IF;

    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg.wsname, l_txmsg.ipaddress
    FROM DUAL;
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := 'DAY';
    l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.busdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.tltxcd:='3331';

    SELECT TXDESC INTO v_desc FROM TLTX WHERE TLTXCD = '3331';

    --Set cac field giao dich

    l_txmsg.txfields ('01').defname   := 'CODEID';
    l_txmsg.txfields ('01').TYPE      := 'C';
    l_txmsg.txfields ('01').VALUE     := v_CODEID;

    l_txmsg.txfields ('02').defname   := 'AFACCT';
    l_txmsg.txfields ('02').TYPE      := 'C';
    l_txmsg.txfields ('02').VALUE     := v_afacctno;

    l_txmsg.txfields ('04').defname   := 'AFACCT2';
    l_txmsg.txfields ('04').TYPE      := 'C';
    l_txmsg.txfields ('04').VALUE     := v_afacctnogoal;

    l_txmsg.txfields ('09').defname   := 'AUTOID';
    l_txmsg.txfields ('09').TYPE      := 'C';
    l_txmsg.txfields ('09').VALUE     := v_AUTOID;

    l_txmsg.txfields ('12').defname   := 'TRADE';
    l_txmsg.txfields ('12').TYPE      := 'N';
    l_txmsg.txfields ('12').VALUE     := v_TRADE;

    l_txmsg.txfields ('13').defname   := 'QTTY';
    l_txmsg.txfields ('13').TYPE      := 'N';
    l_txmsg.txfields ('13').VALUE     := v_QTTY;

    l_txmsg.txfields ('15').defname   := 'AQTTY';
    l_txmsg.txfields ('15').TYPE      := 'N';
    l_txmsg.txfields ('15').VALUE     := v_AQTTY;

    l_txmsg.txfields ('16').defname   := 'PQTTY';
    l_txmsg.txfields ('16').TYPE      := 'N';
    l_txmsg.txfields ('16').VALUE     := v_PQTTY;

    l_txmsg.txfields ('17').defname   := 'AMT';
    l_txmsg.txfields ('17').TYPE      := 'N';
    l_txmsg.txfields ('17').VALUE     := v_AMT;

    l_txmsg.txfields ('18').defname   := 'CAMASTID';
    l_txmsg.txfields ('18').TYPE      := 'C';
    l_txmsg.txfields ('18').VALUE     := v_CAMASTID;

    l_txmsg.txfields ('20').defname   := 'QTTY';
    l_txmsg.txfields ('20').TYPE      := 'N';
    l_txmsg.txfields ('20').VALUE     := v_QTTY;

    l_txmsg.txfields ('21').defname   := 'ISSE';
    l_txmsg.txfields ('21').TYPE      := 'C';
    l_txmsg.txfields ('21').VALUE     := v_ISSE;

    l_txmsg.txfields ('22').defname   := 'ISCI';
    l_txmsg.txfields ('22').TYPE      := 'C';
    l_txmsg.txfields ('22').VALUE     := v_ISCI;

    l_txmsg.txfields ('29').defname   := 'DESCRIPTION';
    l_txmsg.txfields ('29').TYPE      := 'C';
    l_txmsg.txfields ('29').VALUE     := v_DESCRIPTION;

    l_txmsg.txfields ('30').defname   := 'DESC';
    l_txmsg.txfields ('30').TYPE      := 'C';
    l_txmsg.txfields ('30').VALUE     := v_desc;

    l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
    l_txmsg.txfields ('88').TYPE      := 'C';
    l_txmsg.txfields ('88').VALUE     := v_CUSTODYCD;

    l_txmsg.txfields ('90').defname   := 'CUSTNAME';
    l_txmsg.txfields ('90').TYPE      := 'C';
    l_txmsg.txfields ('90').VALUE     := v_CUSTNAME;

    l_txmsg.txfields ('91').defname   := 'ADDRESS';
    l_txmsg.txfields ('91').TYPE      := 'C';
    l_txmsg.txfields ('91').VALUE     := v_ADDRESS;

    l_txmsg.txfields ('92').defname   := 'LICENSE';
    l_txmsg.txfields ('92').TYPE      := 'C';
    l_txmsg.txfields ('92').VALUE     := v_LICENSE;

    l_txmsg.brid        := substr(p_afacctno,1,4);


        BEGIN
        IF txpks_#3331.fn_autotxprocess (l_txmsg,
                                         p_err_code,
                                         l_err_param
           ) <> systemnums.c_success
        THEN
           plog.debug (pkgctx,
                       'got error 3331: ' || p_err_code
           );
           ROLLBACK;
           p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
            plog.setendsection(pkgctx, 'pr_ExecInternalRigthOffTranfer');
           RETURN;
        END IF;
    END;
    DBMS_OUTPUT.Put_Line( 'p_err_code '|| p_err_code);
    DBMS_OUTPUT.Put_Line( 'p_err_message '|| p_err_message);
    p_err_code:=0;
    DBMS_OUTPUT.Put_Line( 'p_err_code '|| p_err_code);
    plog.setendsection(pkgctx, 'pr_ExecInternalRigthOffTranfer');
EXCEPTION
WHEN OTHERS
THEN
  plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
  plog.setendsection (pkgctx, 'pr_ExecInternalRigthOffTranfer');
  return;
END pr_ExecInternalRigthOffTranfer;

procedure pr_getInternalRigthOffTranfer
    (p_refcursor in out pkg_report.ref_cursor,
     p_afacctno  IN  varchar2
    )
IS

BEGIN
    plog.setendsection(pkgctx, 'pr_getInternalRigthOffTranfer');
    Open p_refcursor for

         SELECT CA.AUTOID, CA.BALANCE, CA.CAMASTID, CA.AFACCTNO,A0.CDCONTENT CATYPE, CA.CODEID, CA.EXCODEID, CA.QTTY, CA.AMT, CA.AQTTY,
               CA.AAMT, SYM.SYMBOL, A1.CDCONTENT STATUS,
               CA.AFACCTNO ||(case when camast.iswft='Y' then (select codeid from sbsecurities where refcodeid=symto.codeid) else symto.codeid end) SEACCTNO,
               CA.AFACCTNO || (CASE WHEN CAMAST.EXCODEID IS NULL THEN CAMAST.CODEID ELSE CAMAST.EXCODEID END) EXSEACCTNO,
               SYM.PARVALUE PARVALUE, EXSYM.PARVALUE EXPARVALUE, CAMAST.REPORTDATE REPORTDATE, CAMAST.ACTIONDATE,
               CFMAST.FULLNAME,CFMAST.ADDRESS, CFMAST.IDCODE, CFMAST.CUSTODYCD,
               CASE WHEN AFMAST.COREBANK='Y' THEN 1 ELSE 0 END COREBANK,
               CASE WHEN AFMAST.COREBANK='Y' THEN 'Yes' ELSE 'No' END ISCOREBANK
               ,decode(priceaccounting,0,exsym.parvalue,priceaccounting) priceaccounting, a0.cdval CATYPEVALUE,
               CA.ISCI,ISSE,CA.PBALANCE, CA.RQTTY, CA.TRADE,CAMAST.DESCRIPTION,CA.PQTTY, camast.isincode
        FROM CASCHD CA, SBSECURITIES SYM, SBSECURITIES EXSYM, ALLCODE A0, ALLCODE A1, CAMAST, AFMAST, CFMAST,
             SBSECURITIES SYMTO
        WHERE A0.CDTYPE = 'CA' AND A0.CDNAME = 'CATYPE' AND A0.CDVAL = CAMAST.CATYPE
            AND A1.CDTYPE = 'CA' AND A1.CDNAME = 'CASTATUS' AND A1.CDVAL = CA.STATUS
            AND CA.CAMASTID = CAMAST.CAMASTID AND CAMAST.CODEID = SYM.CODEID
            AND CA.DELTD ='N'
            AND EXSYM.CODEID = (CASE WHEN CAMAST.EXCODEID IS NULL THEN CAMAST.CODEID ELSE CAMAST.EXCODEID END)
            AND CA.AFACCTNO = AFMAST.ACCTNO
            AND AFMAST.CUSTID = CFMAST.CUSTID
            -- 04/06/2015 - TruongLD add --> Neu su kien quyen mua --> chi cho chuyen neu con quyen
            and (case when CAMAST.catype in ('014') and ca.status not in ('J','C', 'F','S') then decode(CA.PQTTY,0, 0, 1) else 1 end) = 1
            -- Truong hop khach hang da dang ky 1 phan va user da lam GD 3369 --> khong cho khach hang lam
            and (case when CAMAST.catype in ('014') and CAMAST.status not in ('J','C', 'F','S') then 1 else 0 end) = 1
            -- End TruongLD
            and nvl(camast.tocodeid,camast.codeid)=symto.codeid
            and ca.status not in ('J','C')
            AND CAMAST.catype ='014'
            and camast.todatetransfer >= getcurrdate --toannds chan SKQM het han
            and ca.afacctno LIKE p_afacctno;

    plog.setendsection(pkgctx, 'pr_getInternalRigthOffTranfer');
EXCEPTION
WHEN OTHERS
THEN
  plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
  plog.setendsection (pkgctx, 'pr_getInternalRigthOffTranfer');
  return;
END pr_getInternalRigthOffTranfer;
---------------------------------pr_getSubAccountInfo------------------------------------------------

procedure pr_getSEAccountInfo
    (p_refcursor in out pkg_report.ref_cursor,
        p_afacctno  IN  varchar2,
        p_getfullrectype IN varchar2 default '0',
        P_TLID IN varchar2 default 'ALL',
        P_SYMBOL IN varchar2 default 'ALL',
        P_CUSTODYCD IN varchar2 default 'ALL'
        )
IS
    l_marginrate number;
    l_afacctno varchar2(20);
    L_STRTLID   VARCHAR2(10);
    L_SYMBOL    VARCHAR2(50);
    L_CUSTODYCD VARCHAR2(50);
BEGIN
    plog.setendsection(pkgctx, 'pr_getSEAccountInfo');

    if(p_afacctno is null or upper(p_afacctno) = 'ALL') then
        l_afacctno := '%';
    else
        l_afacctno := p_afacctno;
    end if;

    IF(P_TLID IS NULL OR UPPER(P_TLID) = 'ALL') THEN
        L_STRTLID := '%';
    ELSE
        L_STRTLID := P_TLID;
    END IF;

    IF(P_SYMBOL IS NULL OR UPPER(P_SYMBOL) = 'ALL') THEN
        L_SYMBOL := '%';
    ELSE
        L_SYMBOL := P_SYMBOL;
    END IF;

     IF(P_CUSTODYCD IS NULL OR UPPER(P_CUSTODYCD) = 'ALL') THEN
        L_CUSTODYCD := '%';
    ELSE
        L_CUSTODYCD := P_CUSTODYCD;
    END IF;


    IF p_getfullrectype = '0' THEN
        Open p_refcursor for
            select custodycd, afacctno ,symbol,
                   /*
                   --05/11/2015, TruongLD modified, dieu chinh lai cong thuc tinh KL khop,
                   -- Thay + MATCHINGAMT - buyingqtty bang (secured - execsellqtty)
                   */
                   --(TRADE + DFTRADING + ABSTANDING + RESTRICTQTTY + BLOCKED + CARECEIVING + ODRECEIVING + MATCHINGAMT - - buyingqtty) totalqtty
                   (TRADE + DFTRADING + ABSTANDING + RESTRICTQTTY + BLOCKED + CARECEIVING + ODRECEIVING + (secured - execsellqtty)) totalqtty,
                   TRADE, WFTTRADE, WFTBLOCK, DFTRADING,ABSTANDING,RESTRICTQTTY,BLOCKED,CARECEIVING,
                   SECURITIES_RECEIVING_T0, SECURITIES_RECEIVING_T1, SECURITIES_RECEIVING_T2,securities_receiving_t3,
                   MATCHINGAMT, COSTPRICE FIFOCOSTPRICE,
                   --11. Gia tri
                   (TRADE + DFTRADING + ABSTANDING + RESTRICTQTTY + BLOCKED + CARECEIVING + ODRECEIVING /*+ MATCHINGAMT- buyingqtty*/+ (secured - execsellqtty)) * COSTPRICE FIFOAMT,--FIFOCOSTPRICE FIFOAMT,
                   --13. Gia tri thi truong
                   BASICPRICE, (TRADE + DFTRADING + ABSTANDING + RESTRICTQTTY + BLOCKED + CARECEIVING + ODRECEIVING /*+ MATCHINGAMT- buyingqtty*/ + (secured - execsellqtty)) * BASICPRICE MKTAMT,
                   --14. Lai lo du tinh
                   CASE WHEN COSTPRICE =0 THEN 0 ELSE (TRADE + DFTRADING + ABSTANDING + RESTRICTQTTY + BLOCKED + CARECEIVING + ODRECEIVING /*+ MATCHINGAMT - BUYINGQTTY*/ + (secured - execsellqtty)) * (BASICPRICE-COSTPRICE) END  PNLAMT,
                    --15. % Lai lo du tinh
                   case when COSTPRICE = 0 then '----' else  to_char(round((BASICPRICE-COSTPRICE)/COSTPRICE,4) * 100,'999,999,999,990.99')||'%' end PNLRATE,
                   (case when TRADE > 0 and instr(symbol,'_WFT') <= 0 then 'Y' else 'N' end) ISSELL,
                   SECURERATIO,SESECURED,SEMARGIN,
                   -- Tong KL mua Trong ngay
                   buyqtty,
                   -- Tong KL Khop MUA
                   execbuyqtty,
                   -- Tong KL dat ban
                   sellqtty,
                     -- Tong KL cho khop ban
                   execsellqtty,
                   mortage, --cam co dc ban
                   dfblocktrading, --cam co khong dc ban

                   --02/08/2016, TruongLD Add, Gia tinh TS, Gia tri TS
                   -- KL tinh = Trade (TRADE + SECURED) + Cho ve + Mua khop trong ngay - Ban khop
                   marginpriceloan PHS_loaning_price,--Gia PHS cho vay
                   NVL(((TRADE + SECURED) + SECURITIES_RECEIVING_T0
                                     + SECURITIES_RECEIVING_T1
                                     + SECURITIES_RECEIVING_T2
                                     + BUYINGQTTY  --KL MUA cho khop
                                     - EXECSELLQTTY -- KL BAN khop
                                     ) * marginpriceloan
                                     ,0) Asset_value_loaning_price --Gia tri tai san vay
                   --End TruongLD
            from
            (
                select se.custodycd, se.afacctno,
                    --1. Ma chung khoan
                    SE.symbol,
                    --3.Kha dung
                    nvl(se.trade,0) TRADE,
                    --CK cho giao dich
                    -----Co the giao dich
                    nvl(b.trade,0) WFTTRADE,
                    -----Han che giao dich
                    nvl(b.restrictqtty,0) WFTBLOCK,
                    --4.1 Cam co
                    nvl(dftrading,0) DFTRADING,
                    --4.2.Chung khoan CC VSD
                    nvl(abstanding,0) ABSTANDING,
                    --5.Chung khoan HCCN
                    nvl(se.restrictqtty,0) RESTRICTQTTY,
                    --6.Khoi luong phong toa
                    nvl(blocked,0) BLOCKED,
                    /*--7. Chung khoan quyen cho ve
                    se.receiving -( nvl(securities_receiving_t1,0)+nvl(securities_receiving_t2,0)+nvl(securities_receiving_t3,0)
                        --PhuNh Comment T0 chua vao receiving trong semast
                        --+nvl(securities_receiving_t0,0)
                        ) CARECEIVING,*/
                    --7. Chung khoan quyen cho ve
                    (buyqtty - buyingqtty) + se.receiving -( nvl(securities_receiving_t1,0)+nvl(securities_receiving_t2,0)+nvl(securities_receiving_t3,0)
                        --PhuNh Comment T0 chua vao receiving trong semast
                        +nvl(securities_receiving_t0,0)
                        ) CARECEIVING,
                    --8. Chung khoan cho ve
                    nvl(securities_receiving_t0,0) + nvl(securities_receiving_t1,0) +
                    nvl(securities_receiving_t2,0) odreceiving,
                        --8.1 Cho ve T0
                        nvl(securities_receiving_t0,0) SECURITIES_RECEIVING_T0,
                        --8.1 Cho ve T1
                        nvl(securities_receiving_t1,0) SECURITIES_RECEIVING_T1,
                        --8.1 Cho ve T2
                        nvl(securities_receiving_t2,0)SECURITIES_RECEIVING_T2,
                    nvl(securities_receiving_t3,0) securities_receiving_t3,
                    --9. Chung khoan cho khop
                    --PhuNh securities_sending_t0 -> securities_sending_t3
                    --05/11/2015, TruongLD modified, TTBT T+2 doi tu 3 ve 2 --> thay securities_sending_t3 = securities_sending_t2
                    greatest(se.buyingqtty + se.secured - securities_sending_t2,0) MATCHINGAMT,
                    --10. Gia von trung binh
                    --se.fifocostprice,
                    se.AVGCOSTPRICE COSTPRICE,
                    --12. Gia thi truong
                    se.basicprice,
                    se.deposit + se.senddeposit DEPOSIT,
                    se.MRRATIOLOAN,
                    --12. BUYINGQTTY -- KL Mua cho khop
                    se.buyingqtty,
                    (100-MRRATIOLOAN) SECURERATIO,
                   (se.trade + secured + securities_receiving_t0 + securities_receiving_t1 +
                     securities_receiving_t2 + securities_receiving_t3 + securities_receiving_tn +
                     buyingqtty - securities_sending_t3) * (1-mrratioloan/100) * BASICPRICE  SESECURED,
                   (se.trade + secured + securities_receiving_t0 + securities_receiving_t1 +
                     securities_receiving_t2 + securities_receiving_t3 + securities_receiving_tn +
                     buyingqtty - securities_sending_t3) * (mrratioloan/100) * BASICPRICE  SEMARGIN,
                     -- Tong KL mua Trong ngay
                     nvl(se.buyqtty,0) buyqtty,
                     -- Tong KL Khop MUA
                     nvl(se.buyqtty - se.buyingqtty,0) execbuyqtty,
                     -- Tong KL dat ban
                     nvl(se.secured,0) sellqtty,
                     -- Tong KL cho khop ban
                     nvl(se.secured - se.remainqtty,0) execsellqtty,
                     nvl(se.remainqtty,0)  sellingqtty,
                     mortage, --cam co dc ban
                     dfblocktrading,  --cam co khong dc ban
                     secured, -- CK ky quy ban
                     --02/08/2016, TruongLD Add, Gia tinh TS
                     NVL(SE.MARGINPRICERATE,0) MARGINPRICERATE, -- Gia tinh Rtt
                     NVL(SE.MARGINPRICELOAN,0) MARGINPRICELOAN -- Gia tinh PP
                     --End TruongLD
                from buf_se_account se
                LEFT JOIN
                (
                    SELECT se.custodycd, se.symbol, se.afacctno, se.trade, se.restrictqtty, se.receiving caqtty, sb.refcodeid
                    FROM buf_se_account se, sbsecurities sb
                    WHERE /*se.custodycd = L_CUSTODYCD
                    AND*/ se.afacctno LIKE l_afacctno
                    AND se.codeid =sb.codeid
                    AND se.symbol LIKE L_SYMBOL
                    AND instr(se.symbol, '_WFT') > 0
                ) b
                ON se.custodycd=b.custodycd  AND se.codeid=b.refcodeid
                where se.afacctno like l_afacctno
                    AND SE.SYMBOL LIKE L_SYMBOL
                    --AND SE.custodycd LIKE L_CUSTODYCD
                    AND EXISTS(
                            SELECT *
                            FROM tlgrpusers tl, tlgroups gr
                            WHERE SE.careby = tl.grpid AND tl.grpid= gr.grpid and gr.grptype='2' and tl.tlid LIKE L_STRTLID
                            )
                )
            where (TRADE + DFTRADING + ABSTANDING + RESTRICTQTTY + BLOCKED + CARECEIVING + ODRECEIVING + MATCHINGAMT - buyingqtty) > 0
            order by afacctno,symbol;
        ELSE
            Open p_refcursor for
            select custodycd, afacctno ,symbol,
                   /*
                   --05/11/2015, TruongLD modified, dieu chinh lai cong thuc tinh KL khop,
                   -- Thay + MATCHINGAMT - buyingqtty bang (secured - execsellqtty)
                   */
                   -- (TRADE + WFTTRADE + DFTRADING + ABSTANDING + RESTRICTQTTY + BLOCKED + CARECEIVING + ODRECEIVING + MATCHINGAMT - buyingqtty) totalqtty,
                   (TRADE + WFTTRADE + DFTRADING + ABSTANDING + RESTRICTQTTY + BLOCKED + CARECEIVING + ODRECEIVING + (secured - execsellqtty)) totalqtty,
                   TRADE, WFTTRADE, WFTBLOCK, DFTRADING,ABSTANDING,RESTRICTQTTY,BLOCKED,CARECEIVING,
                   SECURITIES_RECEIVING_T0, SECURITIES_RECEIVING_T1, SECURITIES_RECEIVING_T2,SECURITIES_RECEIVING_T3,
                   MATCHINGAMT,COSTPRICE FIFOCOSTPRICE,
                   --11. Gia tri
                   (TRADE + DFTRADING + ABSTANDING + RESTRICTQTTY + BLOCKED + CARECEIVING + ODRECEIVING /*+ MATCHINGAMT- BUYINGQTTY*/+ (secured - execsellqtty)) * COSTPRICE FIFOAMT,
                   --13. Gia tri thi truong
                   BASICPRICE, (TRADE + DFTRADING + ABSTANDING + RESTRICTQTTY + BLOCKED + CARECEIVING + ODRECEIVING /*+ MATCHINGAMT- BUYINGQTTY*/ + (secured - execsellqtty)) * BASICPRICE MKTAMT,
                   --14. Lai lo du tinh
                   (TRADE + DFTRADING + ABSTANDING + RESTRICTQTTY + BLOCKED + CARECEIVING + ODRECEIVING /*+ MATCHINGAMT- BUYINGQTTY*/ + (secured - execsellqtty)) * (BASICPRICE-COSTPRICE) PNLAMT,
                    --15. % Lai lo du tinh
                   case when COSTPRICE = 0 then '0' else  to_char(round((BASICPRICE-COSTPRICE)/COSTPRICE,4) * 100,'999,999,999,990.99')||'' end PNLRATE,
                   (case when TRADE > 0 and instr(WFTTRADE,'_WFT') <= 0 then 'Y' else 'N' end) ISSELL,
                     -- Tong KL mua Trong ngay
                     buyqtty,
                     -- Tong KL Khop MUA
                     execbuyqtty,
                     -- Tong KL dat ban
                     sellqtty,
                     -- Tong KL cho khop ban
                     execsellqtty,
                     mortage, --cam co dc ban
                     dfblocktrading, --cam co khong dc ban
                     --02/08/2016, TruongLD Add, Gia tinh TS, Gia tri TS
                   -- KL tinh = Trade (TRADE + SECURED) + Cho ve + Mua khop trong ngay - Ban khop
                   MARGINPRICELOAN PHS_loaning_price,--Gia PHS cho vay
                   NVL(((TRADE + SECURED) + SECURITIES_RECEIVING_T0
                                     + SECURITIES_RECEIVING_T1
                                     + SECURITIES_RECEIVING_T2
                                     + BUYINGQTTY --KL MUA cho khop
                                     - EXECSELLQTTY --KL BAN khop
                                     ) * MARGINPRICELOAN
                                     ,0) Asset_value_loaning_price --Gia tri tai san vay
                   --End TruongLD
            from
            (
                select se.custodycd, se.afacctno,
                    --1. Ma chung khoan
                    SE.symbol,
                    --3.Kha dung
                    nvl(se.trade,0) TRADE,
                    --CK cho giao dich
                    -----Co the giao dich
                    nvl(b.trade,0) WFTTRADE,
                    -----Han che giao dich
                    nvl(se.restrictqtty,0) WFTBLOCK,
                    --4.1 Cam co
                    nvl(se.dftrading,0) DFTRADING,
                    --4.2.Chung khoan CC VSD
                    nvl(se.abstanding,0) ABSTANDING,
                    --5.Chung khoan HCCN
                    nvl(se.restrictqtty,0) RESTRICTQTTY,
                    --6.Khoi luong phong toa
                    nvl(se.blocked,0) BLOCKED,
                    --7. Chung khoan quyen cho ve
                    (se.buyqtty - se.buyingqtty) + se.receiving -( nvl(se.securities_receiving_t1,0)+nvl(se.securities_receiving_t2,0)+nvl(se.securities_receiving_t3,0)
                        --PhuNh Comment T0 chua vao receiving trong semast
                        + nvl(se.securities_receiving_t0,0)
                        ) + (CASE WHEN se.codeid= b.refcodeid THEN b.caqtty ELSE 0 END) CARECEIVING,
                    /*--7. Chung khoan quyen cho ve
                    se.receiving -( nvl(securities_receiving_t1,0)+nvl(securities_receiving_t2,0)+nvl(securities_receiving_t3,0)
                        --PhuNh Comment T0 chua vao receiving trong semast
                        --+nvl(securities_receiving_t0,0)
                        ) CARECEIVING,*/
                    --8. Chung khoan cho ve
                    nvl(se.securities_receiving_t0,0) + nvl(se.securities_receiving_t1,0) +
                    nvl(se.securities_receiving_t2,0) odreceiving,
                        --8.1 Cho ve T0
                        nvl(se.securities_receiving_t0,0) SECURITIES_RECEIVING_T0,
                        --8.1 Cho ve T1
                        nvl(se.securities_receiving_t1,0) SECURITIES_RECEIVING_T1,
                        --8.1 Cho ve T2
                        nvl(se.securities_receiving_t2,0)SECURITIES_RECEIVING_T2,
                    nvl(se.securities_receiving_t3,0) securities_receiving_t3,
                    --9. Chung khoan cho khop
                    --PhuNh securities_sending_t0 -> securities_sending_t3
                    --05/11/2015, TruongLD modified, TTBT T+2 doi tu 3 ve 2 --> thay securities_sending_t3 = securities_sending_t2
                    greatest(se.buyingqtty + se.secured - se.securities_sending_t2,0) MATCHINGAMT,
                    --10. Gia von trung binh
                    --se.fifocostprice,
                    se.AVGCOSTPRICE COSTPRICE,
                    --12. Gia thi truong
                    se.basicprice,
                    se.deposit + se.senddeposit DEPOSIT,
                    se.MRRATIOLOAN,
                    --12. BUYINGQTTY
                    se.buyingqtty,
                    -- Tong KL mua Trong ngay
                     nvl(se.buyqtty,0) buyqtty,
                     -- Tong KL Khop MUA
                     nvl(se.buyqtty - se.buyingqtty,0) execbuyqtty,
                     -- Tong KL dat ban
                     nvl(se.secured,0) sellqtty,
                     -- Tong KL cho khop ban
                     nvl(se.secured - se.remainqtty,0) execsellqtty,
                     nvl(se.remainqtty,0)  sellingqtty,
                     se.mortage, --cam co dc ban
                     se.dfblocktrading,  --cam co khong dc ban
                     se.secured,
                     --02/08/2016, TruongLD Add, Gia tinh TS
                     NVL(SE.MARGINPRICERATE,0) MARGINPRICERATE, -- Gia tinh Rtt
                     NVL(SE.MARGINPRICELOAN,0) MARGINPRICELOAN -- Gia tinh PP
                     --End TruongLD
                from buf_se_account se
                LEFT JOIN
                (
                    SELECT se.custodycd, se.symbol, se.afacctno, se.trade, se.restrictqtty, se.receiving caqtty, sb.refcodeid
                    FROM buf_se_account se, sbsecurities sb
                    WHERE se.custodycd = L_CUSTODYCD
                    AND se.afacctno LIKE l_afacctno
                    AND se.codeid =sb.codeid
                    AND se.symbol LIKE L_SYMBOL
                    AND instr(se.symbol, '_WFT') > 0
                ) b
                ON se.custodycd=b.custodycd  AND se.codeid=b.refcodeid /*, tlgrpusers tl, tlgroups gr*/
                where se.afacctno like l_afacctno
                    AND SE.SYMBOL LIKE L_SYMBOL
                    AND SE.custodycd LIKE L_CUSTODYCD
                    /*AND SE.careby = tl.grpid and tl.grpid= gr.grpid and gr.grptype='2' and tl.tlid LIKE L_STRTLID*/
                    AND EXISTS(
                            SELECT *
                            FROM tlgrpusers tl, tlgroups gr
                            WHERE SE.careby = tl.grpid AND tl.grpid= gr.grpid and gr.grptype='2' and tl.tlid LIKE L_STRTLID
                            )
                      AND NOT EXISTS(SELECT * FROM sbsecurities sec
                                        WHERE se.codeid = sec.codeid
                                              AND (sec.sectype IN ('004','009','006')
                                                    OR sec.tradeplace NOT IN ('001','002','005'))
                                        )
                )
            where (TRADE + DFTRADING + ABSTANDING + RESTRICTQTTY + BLOCKED + CARECEIVING + ODRECEIVING + MATCHINGAMT - buyingqtty) > 0
            order by afacctno,symbol;
        END IF;

    plog.setendsection(pkgctx, 'pr_getSEAccountInfo');
EXCEPTION
WHEN OTHERS
THEN

  plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
  plog.setendsection (pkgctx, 'pr_getSEAccountInfo');
  return;
END pr_getSEAccountInfo;

-- initial LOG
BEGIN
   SELECT *
   INTO logrow
   FROM tlogdebug
   WHERE ROWNUM <= 1;

   pkgctx    :=
      plog.init ('cspks_brokerinquiry',
                 plevel => logrow.loglevel,
                 plogtable => (logrow.log4table = 'Y'),
                 palert => (logrow.log4alert = 'Y'),
                 ptrace => (logrow.log4trace = 'Y')
      );
END;
/
