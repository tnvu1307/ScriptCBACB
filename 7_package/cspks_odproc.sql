SET DEFINE OFF;
CREATE OR REPLACE PACKAGE cspks_odproc
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

    FUNCTION fn_checkTradingAllow(p_afacctno varchar2, p_codeid varchar2, p_bors varchar2, p_err_code in out varchar2)
    RETURN boolean;
    PROCEDURE pr_ConfirmOrder(p_Orderid varchar2,p_userId VARCHAR2,p_custid VARCHAR2,p_Ipadrress VARCHAR2,pv_strErrorCode in out varchar2);

    PROCEDURE PR_AUTO_8894(P_FILEID IN VARCHAR2,P_TLID VARCHAR2, p_VIA VARCHAR2, P_ERR_CODE OUT VARCHAR2) ;

END;
/


CREATE OR REPLACE PACKAGE BODY cspks_odproc
IS
   -- declare log context
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

---------------------------------pr_OpenLoanAccount------------------------------------------------
  FUNCTION fn_checkTradingAllow(p_afacctno varchar2, p_codeid varchar2, p_bors varchar2, p_err_code in out varchar2)
  RETURN boolean
  IS
  l_cfmarginallow varchar2(1);
  l_chksysctrl varchar2(1);
  l_policycd varchar2(1);
  l_actype varchar2(4);
  l_foa varchar2(20);
  l_bors varchar2(20);
  l_count number(10);
  l_isMarginAccount varchar2(1);
  l_busdate date;
  v_ALLOWSESSION varchar2(20);
  v_tradeplace varchar2(20);
  v_CONTROLCODE varchar2(20);
  BEGIN
    plog.setbeginsection(pkgctx, 'fn_checkTradingAllow');
    /*
    --Kiem tra xem chung khoan co bi chan boi phien giao dich hay khong
    begin
        select nvl(ALLOWSESSION,'AL'), tradeplace into v_ALLOWSESSION,v_tradeplace from sbsecurities where codeid =p_codeid;
        if v_tradeplace = '001' and v_ALLOWSESSION <> 'AL' then
            select sysvalue into v_CONTROLCODE from ordersys where sysname ='CONTROLCODE';
            if v_ALLOWSESSION ='OP' and v_CONTROLCODE<>'P' then --Chung khoan chi duoc dat lenh phien mo cua
                p_err_code:= '-700071';
                plog.setendsection(pkgctx, 'fn_checkTradingAllow');
                return false;
            end if;
            if v_ALLOWSESSION ='CO' and v_CONTROLCODE<>'O' then --Chung khoan chi duoc dat lenh phien lien tuc
                p_err_code:= '-700072';
                plog.setendsection(pkgctx, 'fn_checkTradingAllow');
                return false;
            end if;
            if v_ALLOWSESSION ='CL' and v_CONTROLCODE<>'A' then --Chung khoan chi duoc dat lenh phien dong cua
                p_err_code:= '-700073';
                plog.setendsection(pkgctx, 'fn_checkTradingAllow');
                return false;
            end if;
        end if;
    exception when others then
        plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
    end;
    select to_date(varvalue,'DD/MM/RRRR') into l_busdate from sysvar where varname = 'CURRDATE';
    -- Day co phai tieu khoan margin hay khong?

    -- He thong co chan khong.
    if cspks_system.fn_get_sysvar('MARGIN', 'MARGINALLOW') = 'N' AND l_isMarginAccount = 'Y'  then
        p_err_code:= '-700062';
        plog.setendsection(pkgctx, 'fn_checkTradingAllow');
        return false;
    end if;

    if l_isMarginAccount = 'Y' and trim(l_cfmarginallow) = 'N' and l_chksysctrl = 'Y' then
        p_err_code:= '-700063';
        plog.setendsection(pkgctx, 'fn_checkTradingAllow');
        return false;
    end if;

    -- Kiem tra tren tang loai hinh. Khai bao chan giao dich.
    if l_policycd = 'L' then
        --Tuan theo AFSERULE. Neu cho phep moi thuc hien. Ko thi thoi.
        select count(1) into l_count
        from afserule
        where ((typormst = 'M' and refid = p_afacctno) or (typormst = 'T' and refid = l_actype)) and codeid = p_codeid
        and l_busdate between effdate and expdate
        and (bors = p_bors or bors = 'A');

        if not l_count > 0 then
            p_err_code:= '-700069';
            plog.setendsection(pkgctx, 'fn_checkTradingAllow');
            return false;
        end if;
    elsif l_policycd = 'E' then
        --Neu ko nam trong AFSERULE--> Binh thuong. Nguoc lai--> theo AFSERULE.
        select count(1) into l_count
        from afserule where ((typormst = 'M' and refid = p_afacctno) or (typormst = 'T' and refid = l_actype)) and codeid = p_codeid
        and l_busdate between effdate and expdate
        and (bors = p_bors or bors = 'A');

        if l_count > 0 then
            p_err_code:= '-700069';
            plog.setendsection(pkgctx, 'fn_checkTradingAllow');
            return false;
        end if;
    end if;
    */
    plog.setendsection(pkgctx, 'fn_checkTradingAllow');
    return true;
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'fn_checkTradingAllow');
      RAISE errnums.E_SYSTEM_ERROR;
      return false;
  END fn_checkTradingAllow;



 Procedure pr_ConfirmOrder(p_Orderid varchar2,p_userId VARCHAR2,p_custid VARCHAR2,p_Ipadrress VARCHAR2,pv_strErrorCode in out varchar2)
  IS
  l_reforderid VARCHAR2(20);
  l_count      NUMBER;
  l_confirmed  char(1);
  l_suborderid VARCHAR2(20);
  v_confirmdate DATE;
  BEGIN
    plog.setendsection(pkgctx, 'fn_ConfirmOrder');
    pv_strErrorCode:='0';
    -- check xem lenh da dc xac nhan chua
    SELECT COUNT(*) INTO l_count FROM confirmodrsts
    WHERE orderid=p_Orderid;
    IF l_count=1 THEN
        SELECT nvl(confirmed,'N' ) INTO l_confirmed
        FROM confirmodrsts
        WHERE orderid=p_Orderid;

        IF l_confirmed = 'Y' THEN
            pv_strErrorCode:= '-700085';
            plog.setendsection(pkgctx, 'fn_checkTradingAllow');
            RETURN;
        END IF;
    END IF;

    SELECT to_date(to_char(getcurrdate,'DD/MM/YYYY') ||' '|| to_char(SYSTIMESTAMP,'HH24:MI:SS'),'DD/MM/YYYY HH24:MI:SS') INTO v_confirmdate FROM dual;
    -- insert dong xac nhan cho lenh
    Select Count(1) into l_count from confirmodrsts where ORDERID = p_Orderid and CONFIRMED='Y';
    If  l_count = 0 Then
        insert into confirmodrsts (ORDERID, CONFIRMED, USERID, custid, CFMTIME, IPADRRESS)
        select p_Orderid, 'Y', p_userId, p_custid,v_confirmdate, p_Ipadrress from dual;
    ELSE
        Update  confirmodrsts set  confirmed='Y' where  ORDERID=p_Orderid;
    End If;

    SELECT nvl(reforderid,'A') INTO l_reforderid
    FROM vw_odmast_all
    where orderid=p_Orderid;


    insert into confirmodrsts (ORDERID, CONFIRMED, USERID, custid, CFMTIME, IPADRRESS)
    select ORDERID, 'Y', p_userId, p_custid,v_confirmdate, p_Ipadrress
    from vw_odmast_all od
    where reforderid = l_reforderid AND orderid <> p_Orderid
          and not EXISTS (select * from confirmodrsts mst where od.orderid = mst.orderid);

    -- xac nhan cho lenh con
    /*SELECT COUNT(*) INTO l_count
    FROM
       (SELECT * FROM odmast UNION ALL SELECT * FROM odmasthist) OD
    WHERE reforderid=l_reforderid AND orderid <> p_Orderid;*/
    /*
    IF l_reforderid <> 'A' THEN
        SELECT orderid INTO l_suborderid
          FROM vw_odmast_all OD
        WHERE reforderid = l_reforderid AND orderid <> p_Orderid;

        -- check xem lenh con da duoc confirm chua
        SELECT COUNT(*)
            INTO l_count
        FROM confirmodrsts
        WHERE confirmed='Y' AND orderid= l_suborderid;
        -- insert dong xac nhan cho lenh con
        IF l_count = 0  THEN
            insert into confirmodrsts (ORDERID, CONFIRMED, USERID, custid, CFMTIME, IPADRRESS)
            values (l_suborderid, 'Y', p_userId, p_custid,v_confirmdate, p_Ipadrress );
        Else
            Update  confirmodrsts set  confirmed='Y' where  ORDERID=l_suborderid;
        END IF;
    END IF;
    */
    pv_strErrorCode := systemnums.C_SUCCESS;
    plog.setendsection(pkgctx, 'fn_ConfirmOrder');

  EXCEPTION
  WHEN OTHERS
   THEN
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'fn_ConfirmOrder');
      pv_strErrorCode:= '-1';
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_ConfirmOrder;

  PROCEDURE insertodmastetf(p_codeid varchar2,p_symbol varchar2,p_custodycd varchar2, p_exectype varchar2,
                        p_etfquantity number,p_feeamt number

)

is


L_orderid VARCHAR2(20);
l_prefix  VARCHAR2(20);
v_ddacctno varchar2(50);
v_custid varchar2(50);
v_seacctno varchar2(50);
v_afacctno varchar2(50);
v_txdate DATE;

begin
    --lay orderid
    L_PREFIX:=TO_CHAR (GETCURRDATE(), 'YYMMDD');
    L_orderid:=L_PREFIX|| LPAD(seq_odmast.NEXTVAL,8,'0');

    select acctno into v_ddacctno from ddmast where custodycd = p_custodycd and isdefault = 'Y';
    select afacctno into v_afacctno from ddmast where custodycd = p_custodycd and acctno = v_ddacctno;
    select v_afacctno ||p_codeid into v_seacctno from dual ;
    select custid into v_custid from cfmast where custodycd = p_custodycd;
    SELECT to_date(VARVALUE,'dd/mm/yyyy') INTO v_txdate FROM sysvar WHERE VARNAME='CURRDATE';

    INSERT INTO odmast (ORDERID,CODEID,SYMBOL,CUSTID,AFACCTNO,DDACCTNO,SEACCTNO,CUSTODYCD,TXNUM,TXDATE,TIMETYPE,EXECTYPE,NORK,MATCHTYPE,VIA,CLEARDAY,CLEARDATE,ORSTATUS,PRICETYPE,ORDERPRICE,ORDERQTTY,EXECQTTY,EXECAMT,FEEAMT,FEEACR,DELTD,TLID,LASTCHANGE,actype,grporder)
        VALUES         (L_orderid,p_codeid,p_symbol,v_custid,v_afacctno ,v_ddacctno,v_seacctno,p_custodycd,NULL,v_txdate,NULL,p_exectype,NULL,NULL,NULL,NULL,v_txdate,'A',NULL,0,0,p_etfquantity,0 ,p_feeamt,0,'N','0000',SYSDATE,'0000','N');

EXCEPTION
   WHEN OTHERS THEN
        BEGIN

            rollback;

            return;
        END;
end;
------------------------------PROCESS ETF---------------------------------------
PROCEDURE PR_AUTO_8894(P_FILEID IN VARCHAR2,P_TLID VARCHAR2, p_VIA VARCHAR2, P_ERR_CODE OUT VARCHAR2) IS
  L_TXMSG       TX.MSG_RECTYPE;
  V_CURRDATE    date;
  V_STRDESC     VARCHAR2(1000);
  V_STREN_DESC  VARCHAR2(1000);
  V_TLTXCD      VARCHAR2(10);
  P_XMLMSG      VARCHAR2(4000);
  V_PARAM       VARCHAR2(1000);
  V_ETFNAME       VARCHAR2(1000);
  V_DC          NUMBER;
  V_FUNDCODEID   VARCHAR2(50);
  V_AMT         NUMBER;
  V_ERR_CODE    VARCHAR2(10);
  P_ERR_MESSAGE VARCHAR2(500);
  L_TXNUM         VARCHAR2(20);
  V_AUTOID  VARCHAR2(10);
  V_COUNT  NUMBER;
  V_TXNUM_8800 VARCHAR2(20);
BEGIN
    ------------------------
    V_ERR_CODE    := SYSTEMNUMS.C_SUCCESS;
    P_ERR_CODE:=V_ERR_CODE;
    P_ERR_MESSAGE := 'SUCCESS';
    PLOG.SETBEGINSECTION (PKGCTX, 'pr_auto_8894');
    V_TLTXCD := '8894';
    ------------------------
    BEGIN
    SELECT TXDESC, EN_TXDESC
    INTO V_STRDESC, V_STREN_DESC
    FROM TLTX
    WHERE TLTXCD = V_TLTXCD;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            V_STRDESC:= null;
            V_STREN_DESC:= null;
    END;
    V_CURRDATE := getcurrdate;
    BEGIN
        SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD (SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
        INTO L_TXNUM
        FROM DUAL;
    EXCEPTION
          WHEN NO_DATA_FOUND THEN
            L_TXNUM:= null;
    END;
    ------------------------
    L_TXMSG.MSGTYPE     :='T';
    L_TXMSG.LOCAL       :='N';
    L_TXMSG.TLID        := P_TLID;
    ------------------------
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
    INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS
    FROM DUAL;
    ------------------------
    BEGIN
        SELECT BRID
        INTO L_TXMSG.BRID
        FROM TLPROFILES WHERE TLID=L_TXMSG.TLID;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           L_TXMSG.BRID:= null;
    END;
    ------------------------

    BEGIN
        SELECT txnum
        INTO V_TXNUM_8800
        FROM tllog WHERE msgacct=P_FILEID;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           V_TXNUM_8800:= null;
    END;

    ------------------------
    L_TXMSG.OFF_LINE    := 'N';
    L_TXMSG.DELTD       := TXNUMS.C_DELTD_TXNORMAL;
    L_TXMSG.TXSTATUS    := TXSTATUSNUMS.C_TXCOMPLETED;
    L_TXMSG.MSGSTS      := '0';
    L_TXMSG.OVRSTS      := '0';
    L_TXMSG.BATCHNAME   := 'DAY';
    L_TXMSG.REFTXNUM    := NVL(V_TXNUM_8800, L_TXNUM);
    L_TXMSG.TXDATE      := V_CURRDATE;
    L_TXMSG.BUSDATE     := V_CURRDATE;
    L_TXMSG.TLTXCD      := V_TLTXCD;

    FOR V_REC IN (
                SELECT * FROM  (
                                SELECT
                                       CUSTODYCD,
                                       TRANSDATE,
                                       FUNDCODEID,
                                       TRADINGID,
                                       TYPE,
                                       AP,
                                       NAV/100000 NAV,
                                       CALC_IMPORT_ETF(TT.LISTAUTOID,'QUANTITY',TT.PLACE) QUANTITY,
                                       CALC_IMPORT_ETF(TT.LISTAUTOID,'VALUE',TT.PLACE) VALUE,
                                       CALC_IMPORT_ETF(TT.LISTAUTOID,'DIFFERENCE',TT.PLACE) DIFFERENCE,
                                       CALC_IMPORT_ETF(TT.LISTAUTOID,'TRADINGFEE',TT.PLACE) TRADINGFEE,
                                       CALC_IMPORT_ETF(TT.LISTAUTOID,'TAX',TT.PLACE) TAX,
                                       CLEARDATE,
                                       DETAIL,
                                       ACCTNO,
                                      -- BROKER,
                                       FULLNAME
                                FROM (
                                         SELECT * FROM VW_IMPORT_ETF V WHERE V.FILEID = P_FILEID
                                      ) TT
                               )
     )
   LOOP
    --------------------------SET CAC FIELD GIAO DICH-------------------------------
    ----SET TXNUM
    BEGIN
        SELECT L_TXMSG.BRID || LPAD(seq_txnum.NEXTVAL, 6, '0')
            INTO L_TXMSG.TXNUM
        FROM DUAL;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           L_TXMSG.TXNUM:= null;
    END;
    ----TXDATE
    ----------------ETFID--------------------
    BEGIN
        SELECT D.CODEID INTO V_FUNDCODEID
        FROM SBSECURITIES D
        WHERE D.SYMBOL = V_REC.FUNDCODEID AND D.SECTYPE = '008' AND D.STATUS = 'Y';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           V_FUNDCODEID:= null;
    END;

    ---------------ETFNAME------------------
    BEGIN
        SELECT ISS.FULLNAME
        INTO V_ETFNAME
        FROM SBSECURITIES SB, ISSUERS ISS
        WHERE SB.ISSUERID = ISS.ISSUERID  AND SB.CODEID=V_FUNDCODEID;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           V_ETFNAME:= null;
    END;
    ---------------AP------------------

    --CHECK AP OF CUSTODYCD
    SELECT COUNT(*)
    INTO V_COUNT
    FROM CFMAST CF,VW_CUSTODYCD_MEMBERAP_CF VC,FAMEMBERS FA
    WHERE CF.CUSTID = VC.FILTERCD
            AND VC.VALUE=FA.AUTOID
            AND FA.ROLES ='AP'
            AND CF.CUSTODYCD=V_REC.CUSTODYCD;
    --PROCESSING
    IF V_COUNT =0 THEN -- TK KHÔNG CÓ AP
        IF V_REC.AP IS NOT NULL THEN -- IMP CÓ AP
                P_ERR_CODE    := -930020; --MA AP KHÔNG HOP LE
                P_ERR_MESSAGE := 'System error. AP code is invalid';
                RETURN;
        END IF;
    ELSE -- TK CÓ AP
        IF V_REC.AP IS NOT NULL THEN -- IMP AP
            BEGIN
                SELECT FA.AUTOID
                INTO V_AUTOID
                FROM CFMAST CF,VW_CUSTODYCD_MEMBERAP_CF VC,FAMEMBERS FA
                WHERE CF.CUSTID = VC.FILTERCD
                        AND VC.VALUE=FA.AUTOID
                        AND FA.ROLES ='AP'
                        AND CF.CUSTODYCD=V_REC.CUSTODYCD
                        AND FA.DEPOSITMEMBER =
                            (CASE
                                WHEN LENGTH( V_REC.AP)>2 THEN  V_REC.AP
                                WHEN LENGTH( V_REC.AP)=1 THEN  '0'|| '0'|| V_REC.AP
                                ELSE '0'|| V_REC.AP
                            END)
                        AND ROWNUM=1 ;
             EXCEPTION
                WHEN NO_DATA_FOUND THEN  V_AUTOID:= NULL;
             END;
            --AP SAI
            IF V_AUTOID IS NULL THEN
                P_ERR_CODE    := -930020; --MA AP KHÔNG HOP LE
                P_ERR_MESSAGE := 'System error. AP code is invalid';
                RETURN;
            END IF;
        END IF;
    END IF;
    ----FUNDCODEID OK----------------------
    l_txmsg.txfields('03').defname := 'ETFID';
    l_txmsg.txfields('03').TYPE := 'C';
    l_txmsg.txfields('03').VALUE := V_FUNDCODEID;
     ----CTCK  OK
    L_TXMSG.TXFIELDS('04').DEFNAME := 'DDACCTNO';
    L_TXMSG.TXFIELDS('04').TYPE := 'C';
    L_TXMSG.TXFIELDS('04').VALUE := NULL;
    ----CTCK  OK
    L_TXMSG.TXFIELDS('05').DEFNAME := 'CTCK';
    L_TXMSG.TXFIELDS('05').TYPE := 'C';
    L_TXMSG.TXFIELDS('05').VALUE := NULL;--V_REC.BROKER;
     ----QTTY  OK
    L_TXMSG.TXFIELDS('06').DEFNAME := 'ETFQTTY';
    L_TXMSG.TXFIELDS('06').TYPE := 'N';
    L_TXMSG.TXFIELDS('06').VALUE := V_REC.QUANTITY ;
     ----FULLNAME OK
    L_TXMSG.TXFIELDS('07').DEFNAME := 'FULLNAME';
    L_TXMSG.TXFIELDS('07').TYPE := 'C';
    L_TXMSG.TXFIELDS('07').VALUE := V_REC.FULLNAME;
    ----NAV OK
    L_TXMSG.TXFIELDS('08').DEFNAME := 'NAV';
    L_TXMSG.TXFIELDS('08').TYPE := 'N';
    L_TXMSG.TXFIELDS('08').VALUE := V_REC.NAV;
    ----AMT OK
    L_TXMSG.TXFIELDS('09').DEFNAME := 'AMOUNT';
    L_TXMSG.TXFIELDS('09').TYPE := 'N';
    L_TXMSG.TXFIELDS('09').VALUE := V_REC.VALUE;
     ----FEE OK
    L_TXMSG.TXFIELDS('10').DEFNAME := 'FEE';
    L_TXMSG.TXFIELDS('10').TYPE := 'N';
    L_TXMSG.TXFIELDS('10').VALUE := V_REC.TRADINGFEE;
    ----TAX OK
    L_TXMSG.TXFIELDS('11').DEFNAME := 'TAX';
    L_TXMSG.TXFIELDS('11').TYPE := 'N';
    L_TXMSG.TXFIELDS('11').VALUE := V_REC.TAX;
    ----TYPE OK
    L_TXMSG.TXFIELDS('12').DEFNAME := 'TYPE';
    L_TXMSG.TXFIELDS('12').TYPE := 'C';
    L_TXMSG.TXFIELDS('12').VALUE :=  --V_REC.TYPE;
    CASE
         WHEN (UPPER(V_REC.TYPE) = 'NB' OR V_REC.TYPE = 'B') THEN 'NB'
         WHEN (UPPER(V_REC.TYPE) = 'NS' OR V_REC.TYPE = 'S') THEN 'NS'
         ELSE  UPPER(V_REC.TYPE)
    END;
    ----SET TXDATE
    BEGIN
    L_TXMSG.TXFIELDS('20').DEFNAME := 'TXDATE';
    L_TXMSG.TXFIELDS('20').TYPE := 'D';
    L_TXMSG.TXFIELDS('20').VALUE := TO_CHAR(TO_DATE(V_REC.TRANSDATE,'DD/MM/RRRR'),'DD/MM/RRRR');
    EXCEPTION WHEN OTHERS
        THEN
        L_TXMSG.TXFIELDS('20').DEFNAME := 'TXDATE';
        L_TXMSG.TXFIELDS('20').TYPE := 'D';
        L_TXMSG.TXFIELDS('20').VALUE := TO_CHAR(TO_DATE(V_REC.TRANSDATE,'MM/DD/RRRR'),'DD/MM/RRRR');
    END;
    ----CLEARDAY OK
    L_TXMSG.TXFIELDS('21').DEFNAME := 'CLEARDAY';
    L_TXMSG.TXFIELDS('21').TYPE := 'C';
    L_TXMSG.TXFIELDS('21').VALUE := null;
    ----DESC OK
    L_TXMSG.TXFIELDS('30').DEFNAME := 'DESC';
    L_TXMSG.TXFIELDS('30').TYPE := 'C';
    L_TXMSG.TXFIELDS('30').VALUE := V_STREN_DESC;
      ----CLEARDATE
    BEGIN
    L_TXMSG.TXFIELDS('40').DEFNAME := 'STDATE';
    L_TXMSG.TXFIELDS('40').TYPE := 'D';
    L_TXMSG.TXFIELDS('40').VALUE := TO_CHAR(TO_DATE(V_REC.CLEARDATE,'DD/MM/RRRR'),'DD/MM/RRRR');
    EXCEPTION WHEN OTHERS
        THEN
        L_TXMSG.TXFIELDS('40').DEFNAME := 'STDATE';
        L_TXMSG.TXFIELDS('40').TYPE := 'D';
        L_TXMSG.TXFIELDS('40').VALUE := TO_CHAR(TO_DATE(V_REC.CLEARDATE,'MM/DD/RRRR'),'DD/MM/RRRR');
    END;
     ----STRINGDATA OK
    L_TXMSG.TXFIELDS('50').DEFNAME := 'STRINGVALUE';
    L_TXMSG.TXFIELDS('50').TYPE := 'C';
    L_TXMSG.TXFIELDS('50').VALUE := V_REC.DETAIL;
      ----ACCTNO OK
    L_TXMSG.TXFIELDS('51').DEFNAME := 'ACCTNO';
    L_TXMSG.TXFIELDS('51').TYPE := 'C';
    L_TXMSG.TXFIELDS('51').VALUE := V_REC.ACCTNO;
     ----AP  NO
    L_TXMSG.TXFIELDS('83').DEFNAME := 'TVLQ';
    L_TXMSG.TXFIELDS('83').TYPE := 'C';
    L_TXMSG.TXFIELDS('83').VALUE := V_AUTOID    ;
       ---- ETFNAME
    L_TXMSG.TXFIELDS('82').DEFNAME := 'ETFNAME';
    L_TXMSG.TXFIELDS('82').TYPE := 'C';
    L_TXMSG.TXFIELDS('82').VALUE := V_ETFNAME;
    ----CUSTODYCD OK
    L_TXMSG.TXFIELDS('88').DEFNAME := 'CUSTODYCD';
    L_TXMSG.TXFIELDS('88').TYPE := 'C';
    L_TXMSG.TXFIELDS('88').VALUE := V_REC.CUSTODYCD;

    ----SET BUSDATE
    begin
        L_TXMSG.BUSDATE := TO_DATE(V_REC.TRANSDATE, SYSTEMNUMS.C_DATE_FORMAT);
    exception when OTHERS
        then
        L_TXMSG.BUSDATE := TO_DATE(V_REC.TRANSDATE, 'MM/dd/RRRR');
    end;

    ----DIFF KHONG CAN
    L_TXMSG.TXFIELDS('41').DEFNAME := 'DIFF';
    L_TXMSG.TXFIELDS('41').TYPE := 'N';
    L_TXMSG.TXFIELDS('41').VALUE := V_REC.DIFFERENCE;

--------------------------------------------------------------------------------
  IF TXPKS_#8894.FN_BATCHTXPROCESS(L_TXMSG, V_ERR_CODE, P_ERR_MESSAGE) <>
    SYSTEMNUMS.C_SUCCESS THEN

    P_ERR_CODE:=V_ERR_CODE;
    ROLLBACK;
    PLOG.SETENDSECTION(PKGCTX, 'pr_auto_8894');
    RETURN;
  END IF;
--------------------------------------------------------------------------------

 END LOOP;

 EXCEPTION
    WHEN OTHERS THEN
        V_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.ERROR(PKGCTX,
                   ' Err: ' || SQLERRM || ' Trace: ' ||
                   DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.ERROR(PKGCTX, ' Exception: ' || v_param);
        PLOG.SETENDSECTION(PKGCTX, 'pr_auto_8894');
        P_ERR_CODE   := V_ERR_CODE;
END;
---------------------------------END--------------------------------------------
-- initial LOG
BEGIN
   SELECT *
   INTO logrow
   FROM tlogdebug
   WHERE ROWNUM <= 1;

   pkgctx    :=
      plog.init ('cspks_odproc',
                 plevel => logrow.loglevel,
                 plogtable => (logrow.log4table = 'Y'),
                 palert => (logrow.log4alert = 'Y'),
                 ptrace => (logrow.log4trace = 'Y')
      );
END;
/
