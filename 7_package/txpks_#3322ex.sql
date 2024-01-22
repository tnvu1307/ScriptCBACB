SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#3322ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#3322EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      26/03/2020     Created
 **
 ** (c) 2008 by Financial Software Solutions. JSC.
 ** ----------------------------------------------------------------------------------------------------*/
IS
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txAftAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txPreAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txAftAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
END;
/


CREATE OR REPLACE PACKAGE BODY txpks_#3322ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_camastid         CONSTANT CHAR(2) := '03';
   c_codeid           CONSTANT CHAR(2) := '16';
   c_symbol           CONSTANT CHAR(2) := '04';
   c_catype           CONSTANT CHAR(2) := '05';
   c_tocodeid         CONSTANT CHAR(2) := '40';
   c_catypeval        CONSTANT CHAR(2) := '09';
   c_reportdate       CONSTANT CHAR(2) := '06';
   c_duedate          CONSTANT CHAR(2) := '01';
   c_begindate        CONSTANT CHAR(2) := '02';
   c_frdatetransfer   CONSTANT CHAR(2) := '12';
   c_todatetransfer   CONSTANT CHAR(2) := '13';
   c_actiondate       CONSTANT CHAR(2) := '07';
   c_meetingdatetime  CONSTANT CHAR(2) := '17';
   c_meetingplace     CONSTANT CHAR(2) := '18';
   c_advdesc          CONSTANT CHAR(2) := '19';
   c_rate             CONSTANT CHAR(2) := '10';
   c_rightoffrate     CONSTANT CHAR(2) := '11';
   c_trade            CONSTANT CHAR(2) := '23';
   c_tvprice          CONSTANT CHAR(2) := '15';
   c_roprice          CONSTANT CHAR(2) := '14';
   c_status           CONSTANT CHAR(2) := '20';
   c_desc             CONSTANT CHAR(2) := '30';
   c_ltype            CONSTANT CHAR(2) := '21';
   c_formofpayment    CONSTANT CHAR(2) := '08';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    l_camastid varchar2(30);
    l_catype varchar2(30);
    l_count NUMBER;
    l_reportdate DATE;
BEGIN
   plog.setbeginsection (pkgctx, 'fn_txPreAppCheck');
   plog.debug(pkgctx,'BEGIN OF fn_txPreAppCheck');
   /***************************************************************************************************
    * PUT YOUR SPECIFIC RULE HERE, FOR EXAMPLE:
    * IF NOT <<YOUR BIZ CONDITION>> THEN
    *    p_err_code := '<<ERRNUM>>'; -- Pre-defined in DEFERROR table
    *    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
    *    RETURN errnums.C_BIZ_RULE_INVALID;
    * END IF;
    ***************************************************************************************************/
    l_camastid:= p_txmsg.txfields('03').value;
    l_reportdate:= TO_DATE(p_txmsg.txfields('06').value,systemnums.C_DATE_FORMAT);

    IF p_txmsg.deltd <> 'Y' THEN -- Normal TRANSACTION
        If length(l_camastid) > 0 THEN
        --  LAY THONG TIN DOT THUC HIEN QUYEN
    /*
    begin
        SELECT catype INTO l_catype FROM camast WHERE camastid = l_camastid;
    exception when others then
        p_err_code := '-300043';
        plog.setendsection (pkgctx, 'fn_txPreAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
    end;
    */
            IF l_catype = '025' THEN
               SELECT count(1) INTO l_count FROM camast WHERE status = 'N' AND catype IN ('015');
                IF l_count > 0 THEN
                   p_err_code := '-300028';
                   plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                   RETURN errnums.C_BIZ_RULE_INVALID;
                END IF;
            END IF;
        END IF;
    END IF;

    --Kiem tra ngay thuc hien GD phai nam trong khoang tu ngay REPORTDATE den ngay ACTIONDATE
    /*
    IF to_date(p_txmsg.txdate,systemnums.C_DATE_FORMAT) <= l_reportdate THEN
            p_err_code := '-300018';
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;
    */
    plog.debug (pkgctx, '<<END OF fn_txPreAppCheck');
    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'fn_txPreAppCheck');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txPreAppCheck;

FUNCTION fn_txAftAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
BEGIN
   plog.setbeginsection (pkgctx, 'fn_txAftAppCheck');
   plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppCheck>>');
   /***************************************************************************************************
    * PUT YOUR SPECIFIC RULE HERE, FOR EXAMPLE:
    * IF NOT <<YOUR BIZ CONDITION>> THEN
    *    p_err_code := '<<ERRNUM>>'; -- Pre-defined in DEFERROR table
    *    plog.setendsection (pkgctx, 'fn_txAftAppCheck');
    *    RETURN errnums.C_BIZ_RULE_INVALID;
    * END IF;
    ***************************************************************************************************/
   plog.debug (pkgctx, '<<END OF fn_txAftAppCheck>>');
   plog.setendsection (pkgctx, 'fn_txAftAppCheck');
   RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'fn_txAftAppCheck');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txAftAppCheck;

FUNCTION fn_txPreAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txPreAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txPreAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC PROCESS HERE. . DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    plog.debug (pkgctx, '<<END OF fn_txPreAppUpdate');
    plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
       plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txPreAppUpdate;

FUNCTION fn_txAftAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    l_camastid varchar2(30);
    l_reportdate DATE;
    l_actiondate DATE;
    l_catype varchar2(30);
    l_qttyexp varchar2(2000);
    l_aqttyexp varchar2(2000);
    l_amtexp VARCHAR2 (2000);
    l_aamtexp varchar2(2000);
    l_reqttyexp varchar2(2000);
    l_reaqttyexp varchar2(2000);
    l_reamtexp VARCHAR2 (2000);
    l_reaamtexp varchar2(2000);
    l_devidentshares varchar2(50);
    l_left_devidentshares varchar2(50);
    l_right_devidentshares varchar2(50);
    l_exprice NUMBER;
    l_roundtype NUMBER;
    l_sql varchar2(9000);
    l_count NUMBER;
    l_devidentrate varchar2(50);
    l_splitrate varchar2(50);
    l_rightoffrate varchar2(50);
    l_left_rightoffrate varchar2(50);
    l_right_rightoffrate varchar2(50);
    l_left_exrate varchar2(50);
    l_right_exrate varchar2(50);
    l_interestrate varchar2(50);
    l_interestperiod varchar2(50);
    l_codeid varchar2(6);
    l_optcodeid varchar2(6);
    l_excodeid varchar2(6);
    l_exrate varchar2(50);
    l_optsymbol varchar2(50);
    l_tocodeid varchar2(6);
    l_intamtexp VARCHAR2 (2000);

    L_ISREFCODEID varchar2(6);
    l_iswft varchar2(6);
    v_strcodeid varchar2(6);
    l_devidentvalue NUMBER;
    l_rqttyexp VARCHAR2(2000);
    l_TYPERATE CHAR(1);

    l_ciroundtype NUMBER ;
    l_tradeSumByCustCD NUMBER;
    l_dbl_qttyexp NUMBER;
    l_dbl_aqttyexp NUMBER;
    l_dbl_amtexp NUMBER;
    l_dbl_aamtexp NUMBER;
    l_dbl_reqttyexp NUMBER;
    l_dbl_reaqttyexp NUMBER;
    l_dbl_reamtexp NUMBER;
    l_dbl_reaamtexp NUMBER;
    l_dbl_left_rightoffrate  NUMBER;
    l_dbl_right_rightoffrate NUMBER;
    l_dbl_left_devidentshares  NUMBER;
    l_dbl_right_devidentshares NUMBER;
    l_dbl_left_exrate NUMBER;
    l_dbl_right_exrate NUMBER;
    l_dbl_intamtexp NUMBER;
    l_dbl_rqttyexp NUMBER;
    l_parvalue NUMBER;
    l_round Varchar2(2000);
    l_count_temp NUMBER;
    l_dbl_retailbalexp NUMBER;
    l_afacctno VARCHAR2(10);
    l_balance NUMBER;
    l_pqtty NUMBER;
    l_cancelshare char(1);
    l_data_source varchar2(3000);
    l_email varchar2(100);
    l_currdate  date;
    l_formofpayment varchar2(3);
    l_voting varchar2(4000);
    l_qttyround number; --Ngay 06/08/2018 NamTv lam tron khoi luong duoc huong iss FSUPPHCM-220
    v_qttyround varchar2(50); --Ngay 06/08/2018 NamTv lam tron khoi luong duoc huong iss FSUPPHCM-220
    ----- Insert isincode to sbsec -------
    l_countisincode number;
    l_optisincode   varchar2(20);
    l_tr_amt varchar2(3000);
    --
    l_fractionalshare number;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    --NAM.LY CREATE + EDIT FROM GD3312. SHBVNEX-761. 26/03/2020
    l_camastid:= p_txmsg.txfields('03').value;
    l_reportdate:= TO_DATE(p_txmsg.txfields('06').value,systemnums.C_DATE_FORMAT);
    l_actiondate:= TO_DATE(p_txmsg.txfields('07').value,systemnums.C_DATE_FORMAT);
    l_currdate := getcurrdate;
    IF p_txmsg.deltd <> 'Y' THEN -- NORMAL TRANSACTION

        UPDATE camast SET parvalue=
          (SELECT se.parvalue FROM sbsecurities se, camast ca WHERE  camastid=l_camastid AND se.codeid=ca.codeid)
         WHERE camastid=l_camastid;

        -- Xoa du lieu cu.
        Delete from caschd_list_fa where camastid = l_camastid;
        Delete from caschdtemp_list_fa where camastid = l_camastid;

        -- Tao du lieu moi.
        IF length(l_camastid) > 0 THEN
            -- Lay thong tin dot thuc hien quyen.
            FOR camast_rec IN
            (
                SELECT * from camast WHERE camastid = l_camastid
            )
            LOOP
                -- Lay truong thong tin dot thuc hien quyen ve.

                l_catype:= camast_rec.catype;
                l_devidentshares:= camast_rec.DEVIDENTSHARES;
                l_left_devidentshares:= nvl(substr(l_devidentshares,0,instr(l_devidentshares,'/') - 1),0);
                l_right_devidentshares:= nvl(substr(l_devidentshares,instr(l_devidentshares,'/') + 1,length(l_devidentshares)),0);
                l_exprice:=camast_rec.EXPRICE;
                l_devidentrate:= camast_rec.DEVIDENTRATE;
                l_splitrate:= camast_rec.SPLITRATE;
                l_rightoffrate := camast_rec.RIGHTOFFRATE;
                l_left_rightoffrate := nvl(substr(l_rightoffrate,0,instr(l_rightoffrate,'/') - 1),0);
                l_right_rightoffrate := nvl(substr(l_rightoffrate,instr(l_rightoffrate,'/') + 1,length(l_rightoffrate)),0);
                l_exrate := camast_rec.EXRATE;
                l_left_exrate := nvl(substr(l_exrate,0,instr(l_exrate,'/') - 1),0);
                l_right_exrate := nvl(substr(l_exrate,instr(l_exrate,'/') + 1,length(l_exrate)),0);
                l_interestrate:= camast_rec.INTERESTRATE;
                l_interestperiod:= camast_rec.INTERESTPERIOD;
                l_codeid:= camast_rec.codeid;
                l_excodeid:= camast_rec.excodeid;
                l_optsymbol:= camast_rec.OPTSYMBOL;
                l_optisincode:=camast_rec.OPTISINCODE;
                l_tocodeid:= camast_rec.TOCODEID;
                l_roundtype:= nvl(camast_rec.ROUNDTYPE,0);
                l_ciroundtype:= nvl(camast_rec.CIROUNDTYPE,0);
                l_qttyround:= nvl(camast_rec.ROUNDMETHOD,0); --Ngay 06/08/2018 NamTv lam tron khoi luong duoc huong iss FSUPPHCM-220
                l_devidentvalue:= camast_rec.devidentvalue; -- PhuongHT add for the case in devident by value of ct bang tien
                l_TYPERATE:=camast_rec.typerate;
                l_dbl_left_devidentshares:= to_number(l_left_devidentshares);
                l_dbl_right_devidentshares:= to_number(l_right_devidentshares);
                l_dbl_left_rightoffrate:= to_number(l_left_rightoffrate);
                l_dbl_right_rightoffrate:= to_number(l_right_rightoffrate);
                l_dbl_left_exrate:= to_number(l_left_exrate);
                l_dbl_right_exrate:= to_number(l_right_exrate);
                l_parvalue:=camast_rec.parvalue;
                l_cancelshare :=camast_rec.cancelshare;
                l_formofpayment:= camast_rec.FORMOFPAYMENT;
                l_fractionalshare:=camast_rec.fractionalshare;
                --
                IF l_catype = '014' THEN
                  SELECT optcodeid INTO l_optcodeid FROM camast WHERE camastid = camast_rec.camastid;
                  IF NVL(l_optcodeid,'x') = 'x' THEN
                    SELECT '9' || lpad(MAX (nvl(odr,0)) + 1,5,'0') INTO l_optcodeid
                    FROM     (SELECT   ROWNUM odr, invacct
                                FROM   (  SELECT   invacct
                                            FROM   (  SELECT   codeid invacct
                                                        FROM sbsecurities
                                                        WHERE substr(codeid,1,1)=9
                                                        union all
                                                        SELECT   codeid invacct
                                                        FROM securities_info
                                                        WHERE substr(codeid,1,1)=9
                                                        UNION ALL
                                                      SELECT '900001'
                                                        FROM dual)
                                        ORDER BY   invacct) dat
                    WHERE   substr(invacct,2,5) = ROWNUM) invtab;
                  END IF;
                END IF;

                l_qttyexp:= '0';
                l_amtexp := '0';
                l_aqttyexp := '0';
                l_aamtexp := '0';
                l_reqttyexp := '0';
                l_reaqttyexp := '0';
                l_intamtexp := '0';
                l_rqttyexp:='0';
                L_ROUND:='0';

                l_dbl_qttyexp:= 0;
                l_dbl_amtexp := 0;
                l_dbl_aqttyexp := 0;
                l_dbl_aamtexp := 0;
                l_dbl_reqttyexp := 0;
                l_dbl_reaqttyexp := 0;
                l_dbl_intamtexp := 0;
                l_dbl_rqttyexp:= 0;
                l_dbl_retailbalexp:=0;
                --Ngay 06/08/2018 NamTv lam tron khoi luong duoc huong iss FSUPPHCM-220
                IF l_qttyround=0 then
                    v_qttyround:= 'ROUND';
                ELSIF l_qttyround=1 then
                    v_qttyround:= 'TRUNC';
                ELSE
                    v_qttyround:= 'TRUNC';
                END IF;
                --Ngay 06/08/2018 NamTv End

            -- TINH GIA TRI CHUNG KHOAN CHO QUYEN VE.
                IF L_CATYPE = '009' THEN --GC_CA_CATYPE_KIND_DIVIDEND  'KIND DIVIDEND
                    L_QTTYEXP := 'FLOOR(((SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))*' || L_RIGHT_DEVIDENTSHARES || ')/' || L_LEFT_DEVIDENTSHARES || ')';
                    L_AMTEXP := '(' || L_EXPRICE || '*MOD((SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))*' || L_RIGHT_DEVIDENTSHARES || ' ,' || L_LEFT_DEVIDENTSHARES || '))/' || L_LEFT_DEVIDENTSHARES;
                    L_ROUND:= ' (CASE WHEN ( MOD((SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))*' || L_RIGHT_DEVIDENTSHARES || ' ,' || L_LEFT_DEVIDENTSHARES || '))> 0 THEN 1 ELSE 0 END) ';
                ELSIF L_CATYPE = '010' THEN --GC_CA_CATYPE_CASH_DIVIDEND 'CASH DIVIDEND(+QTTY,AMT)
                    IF(L_TYPERATE= 'R') THEN
                        L_AMTEXP := '(SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))*MAX(SYM.PARVALUE)/100*' || L_DEVIDENTRATE;
                    ELSE
                      L_AMTEXP := '(SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))*' || L_DEVIDENTVALUE;
                    END IF;
                    L_ROUNDTYPE :=0;
                    L_ROUND:= ' (CASE WHEN (FLOOR( '|| L_AMTEXP  || ' ) <> '|| L_AMTEXP || ' ) THEN 1 ELSE 0 END)';
                /*ELSIF L_CATYPE = '024' THEN --GC_CA_CATYPE_PAYING_INTERREST_BOND
                    L_AMTEXP := '(SUM(MST.TRADE + MST.MARGIN + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.WTRADE  + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(NVL(TR.AMOUNT,0)))*MAX(SYM.PARVALUE)/100*' || L_DEVIDENTRATE;
                    L_ROUNDTYPE := 0;*/

                ELSIF L_CATYPE = '011' THEN --GC_CA_CATYPE_STOCK_DIVIDEND 'STOCK DIVIDEND (+QTTY,AMT)
                    l_qttyexp:= '(((SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))*' || l_right_devidentshares || ')/' || l_left_devidentshares || ')';
                    l_amtexp:= '(' || l_exprice || '* TRUNC( MOD((SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))*' || l_right_devidentshares || ' ,' || l_left_devidentshares || ')/' || l_left_devidentshares||',' || l_ciroundtype|| '))';
                    L_ROUND:= ' (CASE WHEN (((SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))*' || l_right_devidentshares || ' / ' || l_left_devidentshares || ')- '
                                || ' TRUNC((SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))*' || l_right_devidentshares || ' / ' || l_left_devidentshares || ', '||L_ROUNDTYPE ||' ))> 0 THEN 1 ELSE 0 END) ';
                ELSIF L_CATYPE = '025' THEN --GC_CA_CATYPE_PRINCIPLE_BOND
                    L_AMTEXP:='(SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))*' || L_EXPRICE;
                    L_AAMTEXP:='(SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))';

                ELSIF L_CATYPE = '021' THEN --GC_CA_CATYPE_KIND_STOCK
                    l_qttyexp:= '(((SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))*' || l_right_exrate || ')/' || l_left_exrate || ')';
                    l_amtexp:= '(' || l_exprice || ' * TRUNC( MOD((SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))*' || l_right_exrate || ' ,' || l_left_exrate || ')/' || l_left_exrate||', '|| l_ciroundtype ||'))';
                    L_ROUND:= ' (CASE WHEN (((SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))*' || l_right_exrate || ' / ' || l_left_exrate || ')- '
                                || ' TRUNC((SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))*' || l_right_exrate || ' / ' || l_left_exrate || ', '||L_ROUNDTYPE ||' ))> 0 THEN 1 ELSE 0 END) ';

                ELSIF L_CATYPE = '020' THEN --GC_CA_CATYPE_CONVERT_STOCK
                  --if v_qttyround = 'ROUND' then
                    --    l_qttyexp:= v_qttyround || '(((SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.MORTAGE + MST.BLOCKED + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.SECURED + MST.REPO + MST.NETTING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(NVL(TR.AMOUNT,0)))*' || l_right_devidentshares || ')/' || l_left_devidentshares || ',' || l_ciroundtype || ')';
                    --else
                        l_qttyexp:= '(((SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))*' || l_right_devidentshares || ')/' || l_left_devidentshares ||  ')';
                    --end if;
                    l_aqttyexp:='(SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))';
                    l_amtexp:= '(' || l_exprice || '* TRUNC( MOD((SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))*' || l_right_devidentshares || ' ,' || l_left_devidentshares || ')/' || l_left_devidentshares||',' || l_ciroundtype|| '))';
                    L_ROUND:= ' (CASE WHEN (((SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))*' || l_right_devidentshares || ' / ' || l_left_devidentshares || ')- '
                                || ' TRUNC((SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))*' || l_right_devidentshares || ' / ' || l_left_devidentshares || ', '||L_ROUNDTYPE ||' ))> 0 THEN 1 ELSE 0 END) ';

                ELSIF L_CATYPE = '022' THEN --GC_CA_CATYPE_CASH_DIVIDEND 'CASH DIVIDEND(+QTTY,AMT)
                    L_QTTYEXP := '(SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))';
                    L_ROUND:= ' (CASE WHEN ( MOD((SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))*' || L_RIGHT_DEVIDENTSHARES || ' ,' || L_LEFT_DEVIDENTSHARES || '))> 0 THEN 1 ELSE 0 END) ';

                    L_RQTTYEXP:= 'FLOOR(((SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))*' || L_RIGHT_DEVIDENTSHARES || ')/' || L_LEFT_DEVIDENTSHARES || ')';
                ELSIF L_CATYPE = '012' THEN --GC_CA_CATYPE_STOCK_SPLIT 'STOCK SPLIT(+ QTTY,AMT)
                    L_QTTYEXP:= 'TRUNC((SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0))) / (' || L_SPLITRATE || ') - '
                                   || '(SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0))), ' || L_ROUNDTYPE || ')';
                    L_AMTEXP:= L_EXPRICE || '*((SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0))) / (' || L_SPLITRATE || ') - '
                                             || '(SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0))) - '
                                             || L_QTTYEXP || ')';

                ELSIF L_CATYPE = '013' THEN --GC_CA_CATYPE_STOCK_MERGE 'STOCK MERGE(-AQTTY,+AMT)
                    L_AQTTYEXP:='((SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0))) - '
                                    || 'TRUNC((SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0))) / (' || L_SPLITRATE || '), ' || L_ROUNDTYPE || '))';
                    L_AAMTEXP:= L_EXPRICE || '*( ' || L_AQTTYEXP || ' - ((SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0))) - '
                                    || '(SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0))) / (' || L_SPLITRATE || ')))';

                   -- PHUONGHT EDIT
                    L_AMTEXP:= L_EXPRICE || '*( ' || L_AQTTYEXP || ' - ((SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0))) - '
                                    || '(SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0))) / (' || L_SPLITRATE || ')))';

                   -- END OF PHUONGHT EDIT
                ELSIF L_CATYPE = '014' THEN --GC_CA_CATYPE_STOCK_RIGHTOFF 'STOCK RIGHTOFF(+QTTY,-AAMT)
                    L_QTTYEXP:=V_QTTYROUND || '(((SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))*' || L_RIGHT_RIGHTOFFRATE ||'*'|| L_RIGHT_EXRATE || ')/(' || L_LEFT_RIGHTOFFRATE || '*'|| L_LEFT_EXRATE ||'))';
                    L_AAMTEXP:= L_EXPRICE || ' * TRUNC( FLOOR((( SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))*' || L_RIGHT_RIGHTOFFRATE ||'*'|| L_RIGHT_EXRATE|| ')/(' || L_LEFT_RIGHTOFFRATE || '*'|| L_LEFT_EXRATE ||')), ' || L_ROUNDTYPE || ')';
                    L_ROUND:= ' (CASE WHEN (((SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))*' || L_RIGHT_EXRATE || ' / ' || L_LEFT_EXRATE || ')- '
                                || ' TRUNC((SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))*' || L_RIGHT_EXRATE || ' / ' || L_LEFT_EXRATE ||', '||L_ROUNDTYPE ||' ))> 0 THEN 1 ELSE 0 END) ';
                ELSIF L_CATYPE = '023' THEN -- CHUYEN DOI TP-CP DK NHAN TIEN
                     -- sl CP dc nhan= dk nhan max: --thunt:09/02/2020- them phan le cp
                    l_qttyexp:=  'FLOOR(((SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(TR.AMOUNT))*' || l_right_exrate || ')/' || l_left_exrate || ')';

                    -- sl trai phieu bi cat o tk goc
                    l_aqttyexp:= '(SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(TR.AMOUNT))';
                    -- sl tien du tinh nhan
                    if l_formofpayment ='001' then--lai
                        l_amtexp:= '(' || l_parvalue || '* (' || l_interestrate||'/100) * (SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(TR.AMOUNT))) ';
                        l_intamtexp := l_amtexp;
                    else
                        l_amtexp:= '(' || l_parvalue || '* (1 + ' || l_interestrate||'/100) * (SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(TR.AMOUNT))) ';
                        l_intamtexp:= '(' || l_parvalue || '* (' || l_interestrate||'/100) * (SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(TR.AMOUNT))) ';
                    end if;

                    -- co lam tron khong
                    L_ROUND:= ' (CASE WHEN (((SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(TR.AMOUNT))*' || l_right_exrate || ' / ' || l_left_exrate || ')- '
                                || ' TRUNC((SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(TR.AMOUNT))*' || l_right_exrate || ' / ' || l_left_exrate || ', '||L_ROUNDTYPE ||' ))> 0 THEN 1 ELSE 0 END) ';

                      -- PhuongHT: ghi nhan rieng phan lai
                    --l_intamtexp:='(SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(TR.AMOUNT))*MAX(SYM.PARVALUE)/(100)*' || l_interestrate ;

                ELSIF L_CATYPE = '015' THEN --GC_CA_CATYPE_BOND_PAY_INTEREST 'BOND PAY INTEREST, LAI SUAT THEO THANG, CHU KY THEO NAM (+AMT)
                    L_AMTEXP:='(SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))*MAX(SYM.PARVALUE)/(100)*' || L_INTERESTRATE ;
                    L_ROUNDTYPE := 0;
                    L_ROUND:= ' (CASE WHEN (FLOOR( '|| L_AMTEXP  || ') ) <> '|| L_AMTEXP || ' THEN 1 ELSE 0 END)';
                    -- AMT=INTAMT
                    L_INTAMTEXP:='(SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))*MAX(SYM.PARVALUE)/(100)*' || L_INTERESTRATE ;
                ELSIF L_CATYPE = '016' THEN -- GC_CA_CATYPE_BOND_PAY_INTEREST_PRINCIPAL 'BOND PAY INTEREST || PRIN, LAI SUAT THEO THANG, CHU KY THEO NAM (+AMT)
                    L_AMTEXP:='(SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))*MAX(SYM.PARVALUE) + '
                                    || '(SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))*MAX(SYM.PARVALUE)/(100*12)*' || L_INTERESTRATE || '*' || L_INTERESTPERIOD;

                    L_AMTEXP:='(SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))*MAX(SYM.PARVALUE) * (1+ ' || L_INTERESTRATE || ' /100 ) ';
                     -- PHUONGHT: GHI NHAN RIENG PHAN LAI
                    L_INTAMTEXP:='(SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))*MAX(SYM.PARVALUE)/(100)*' || L_INTERESTRATE ;

                    L_ROUND:= ' (CASE WHEN (FLOOR( '|| L_AMTEXP  || ') ) <> '|| L_AMTEXP || ' THEN 1 ELSE 0 END)';
                    L_ROUNDTYPE:= 0 ;
               --NGAY 04/02/2020 NAMTV THEM SU KIEN 033 TUONG TU 016
                ELSIF L_CATYPE = '033' THEN -- GC_CA_CATYPE_BOND_PAY_INTEREST_PRINCIPAL 'BOND PAY INTEREST || PRIN, LAI SUAT THEO THANG, CHU KY THEO NAM (+AMT)
                    /*L_AMTEXP:='(SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.MORTAGE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.NETTING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(NVL(TR.AMOUNT,0)))*MAX(SYM.PARVALUE) + '
                                    || '(SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.NETTING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(NVL(TR.AMOUNT,0)))*MAX(SYM.PARVALUE)/(100*12)*' || L_INTERESTRATE || '*' || L_INTERESTPERIOD;*/
                    L_AMTEXP:='(SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))*MAX(SYM.PARVALUE) * (1+ ' || L_SPLITRATE || ' /100 ) ';
                     -- PHUONGHT: GHI NHAN RIENG PHAN LAI
                    L_INTAMTEXP:='(SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))* (' || L_SPLITRATE ||'/100*MAX(SYM.PARVALUE))';
                    L_ROUND:= ' (CASE WHEN (FLOOR( '|| L_AMTEXP  || ') ) <> '|| L_AMTEXP || ' THEN 1 ELSE 0 END)';
                    L_ROUNDTYPE:= 0 ;
                ELSIF L_CATYPE = '017' THEN -- GC_CA_CATYPE_CONVERT_BOND_TO_SHARE 'CONVERT BOND TO SHARE (+QTTY SHARE,-AQTTY BOUND)
                    l_qttyexp:= '(((SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))*' || l_right_exrate || ')/' || l_left_exrate || ')';
                    l_aqttyexp:= '(SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))';

                    l_amtexp:= '(' || l_exprice || '* TRUNC( MOD((SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))*' || l_right_exrate || ' ,' || l_left_exrate || ')/' || l_left_exrate||',' || l_ciroundtype|| '))';
                    L_ROUND:= ' (CASE WHEN (((SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))*' || l_right_exrate || ' / ' || l_left_exrate || ')- '
                                || ' TRUNC((SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))*' || l_right_exrate || ' / ' || l_left_exrate || ', '||L_ROUNDTYPE ||' ))> 0 THEN 1 ELSE 0 END) ';
                ELSIF L_CATYPE = '018' THEN -- GC_CA_CATYPE_CONVERT_RIGHT_TO_SHARE 'CONVERT RIGHT TO SHARE (+QTTY SHARE, -AQTTY RIGHT)
                    L_QTTYEXP:= '(SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))';
                    L_AQTTYEXP:= '(SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))';
                    L_ROUNDTYPE:= 0 ;
                ELSIF L_CATYPE = '019' THEN -- GC_CA_CATYPE_CHANGE_TRADING_PLACE_STOCK 'CHANGE TRADING PLACE (+QTTY )
                    L_QTTYEXP:= '0';
                    L_AMTEXP:='0';
                ELSIF  L_CATYPE IN ( '005' , '006','022', '028') THEN
                       L_RQTTYEXP:= 'FLOOR(((SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))*' || L_RIGHT_DEVIDENTSHARES || ')/' || L_LEFT_DEVIDENTSHARES || ')';
                 /*ADD BY TRUONGLD, THEM SU KIEN GIAI THE TO CHUC */
                ELSIF L_CATYPE = '027' THEN --GC_CA_CATYPE_CASH_DIVIDEND 'CASH DIVIDEND(+QTTY,AMT)
                    IF(L_TYPERATE= 'R') THEN
                        L_AMTEXP := '(SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))*MAX(SYM.PARVALUE)/100*' || L_DEVIDENTRATE;
                    ELSE
                        L_AMTEXP := '(SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))*' || L_DEVIDENTVALUE;
                    END IF;
                    IF L_CANCELSHARE = 'Y' THEN
                       L_AQTTYEXP := '(SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))';
                    ELSE
                       L_AQTTYEXP := 0;
                    END IF;
                    L_ROUNDTYPE :=0;
                    L_ROUND:= ' (CASE WHEN (FLOOR( '|| L_AMTEXP  || ' ) <> '|| L_AMTEXP || ' ) THEN 1 ELSE 0 END)';
                --T9/2019 CW_PHASEII
                ELSIF L_CATYPE = '024' THEN --GC_CA_CATYPE_CASH_CW 'CHI TRA LOI TUC CW BANG TIEN
                    
                    IF(L_TYPERATE= 'R') THEN
                        L_AMTEXP := '(SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))*'||L_EXPRICE||'/100*' || L_DEVIDENTRATE;
                    ELSE
                        L_AMTEXP := '(SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(NVL(TR.AMOUNT,0)))*' || L_DEVIDENTVALUE;
                    END IF;
                    --L_ROUNDTYPE :=0;
                      L_ROUND:= ' (CASE WHEN ('|| L_AMTEXP || ' - TRUNC( '|| L_AMTEXP  || ','||L_ROUNDTYPE||' ) > 0  ) THEN 1 ELSE 0 END)';
                      L_AMTEXP:= 'TRUNC( '|| L_AMTEXP  || ','||L_ROUNDTYPE||' )';
                --END T9/2019 CW_PHASEII

                ELSIF l_catype = '040' THEN
                    -- sl trai phieu bi cat o tk goc
                    --l_aqttyexp:= '(SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(TR.AMOUNT))';
                    l_qttyexp := 'FLOOR(((SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(TR.AMOUNT))*' || l_right_exrate || ')/' || l_left_exrate || ')';
                    -- co lam tron khong
                    L_ROUND:= ' (CASE WHEN (((SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(TR.AMOUNT))*' || l_right_exrate || ' / ' || l_left_exrate || ')- '
                                || ' TRUNC((SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD)-SUM(TR.AMOUNT))*' || l_right_exrate || ' / ' || l_left_exrate || ', '||L_ROUNDTYPE ||' ))> 0 THEN 1 ELSE 0 END) ';
                END IF;

                -- SO CHUNG KHOAN LE.
                --THUNT-09/02/2020-TINH SO CK LE THEO 023
                if l_catype in ('011','017','020','021') then
                    l_reqttyexp:= 'FN_ROUND_AMTQTTY(' || l_qttyexp || ' - TRUNC(' || l_qttyexp || '),' || l_qttyround ||','|| l_ciroundtype ||')';
                ELSE
                    L_REQTTYEXP:= '(' || L_QTTYEXP || ' - TRUNC(' || L_QTTYEXP || ',' || L_ROUNDTYPE || '))';
                END IF;

                -- SO CHUNG KHOAN DA LAM TRON.
                --26/06/2018 DIEUNDA: TAM THOI THAY DOI RULE LAM TRON(CHUYEN TU TRUNC --> ROUND) DO KHAI BAO QUYEN DAC BIET
                L_QTTYEXP:= 'TRUNC(' || L_QTTYEXP || ',' || L_ROUNDTYPE || ')';
                --L_QTTYEXP:= 'ROUND(' || L_QTTYEXP || ',' || L_ROUNDTYPE || ')';
                --END 26/06/2018 DIEUNDA
                --THUNT-08/02/2020:THEM SO THAP PHAN CHO CK LE QUY DOI
                IF l_catype = '017' OR l_catype = '020' OR l_catype='023' THEN
                    l_aqttyexp:= 'TRUNC(' || l_aqttyexp || ',' || 0 || ')';
                ELSE
                    l_aqttyexp:= 'TRUNC(' || l_aqttyexp || ',' || l_roundtype || ')';
                END IF;

                IF l_catype = '009' THEN
                    l_amtexp:= 'ROUND(' || l_amtexp || ' + (' || l_reqttyexp || ' * ' || l_exprice || '))';
                ELSIF l_catype <> '023' THEN
                    if l_catype in ('011','017','020','021') then--skq nhan co phieu chi tinh tien tren co phieu le
                        l_amtexp:=0;
                    end if;
                    l_amtexp:= l_amtexp || ' + (' || l_reqttyexp || ' * ' || l_exprice||')';
                END IF;

                l_aamtexp:=l_aamtexp || ' + ' || l_reaqttyexp || '*' || l_exprice;

                l_reaqttyexp :=0;
                l_reqttyexp :=0;
                -- dung truong ROUND trong CASHDTEMP de phan biet tieu khoan do co bi chot le khong

                l_tr_amt :=    ' ( '
                            || ' SELECT (CASE WHEN TR_SELL.ACCTNO IS NOT NULL THEN TR_SELL.ACCTNO ELSE TR_BUY.ACCTNO END) ACCTNO, '
                            || '        (NVL(TR_SELL.AMT,0) - NVL(TR_BUY.AMT,0)) AMOUNT '
                            || ' FROM '
                            || '    ( '
                            || '        SELECT TMP.SEACCTNO ACCTNO, SUM(TMP.QTTY) AMT '
                            || '        FROM ( '
                            || '               SELECT ETF.ORDERID, ETF.QTTY, (ETF.AFACCTNO||ETF.CODEID) SEACCTNO, ST.STATUS, ST.DUETYPE, ST.CLEARDATE '
                            || '               FROM ETFWSAP ETF, STSCHD ST '
                            || '               WHERE ETF.ORDERID = ST.ORDERID '
                            || '               UNION ALL '
                            || '               SELECT NG.ORDERID, NG.QTTY, NG.SEACCTNO, NG.STATUS, NG.DUETYPE, NG.CLEARDATE '
                            || '               FROM STSCHD NG '
                            || '               WHERE NOT EXISTS (SELECT 1 FROM ETFWSAP WHERE ORDERID = NG.ORDERID) '
                            || '              ) TMP '
                            || '        WHERE TMP.STATUS <> ''C'' '
                            || '              AND TMP.CLEARDATE <= TO_DATE(''' || TO_CHAR(l_reportdate,SYSTEMNUMS.C_DATE_FORMAT) || ''', ''DD/MM/RRRR'')' --L_REPORTDATE: NGAY CHOT
                            || '              AND TMP.DUETYPE = ''RS'' ' -- MUA
                            || '        GROUP BY TMP.SEACCTNO '
                            || '    ) TR_BUY '
                            || '    FULL JOIN '
                            || '    ( '
                            || '        SELECT TMP.SEACCTNO ACCTNO, SUM(TMP.QTTY) AMT '
                            || '        FROM ( '
                            || '               SELECT ETF.ORDERID, ETF.QTTY, (ETF.AFACCTNO||ETF.CODEID) SEACCTNO, ST.STATUS, ST.DUETYPE, ST.CLEARDATE '
                            || '               FROM ETFWSAP ETF, STSCHD ST '
                            || '               WHERE ETF.ORDERID = ST.ORDERID '
                            || '               UNION ALL '
                            || '               SELECT NG.ORDERID, NG.QTTY, NG.SEACCTNO, NG.STATUS, NG.DUETYPE, NG.CLEARDATE '
                            || '               FROM STSCHD NG '
                            || '               WHERE NOT EXISTS (SELECT 1 FROM ETFWSAP WHERE ORDERID = NG.ORDERID) '
                            || '              ) TMP '
                            || '        WHERE TMP.STATUS <> ''C'' '
                            || '              AND TMP.CLEARDATE <= TO_DATE(''' || TO_CHAR(l_reportdate,SYSTEMNUMS.C_DATE_FORMAT) || ''', ''DD/MM/RRRR'')' --L_REPORTDATE: NGAY CHOT
                            || '              AND TMP.DUETYPE = ''SS'' ' -- BAN
                            || '        GROUP BY TMP.SEACCTNO '
                            || '    ) TR_SELL '
                            || '    ON TR_BUY.ACCTNO = TR_SELL.ACCTNO '
                            || ' ) TR ';
                -------------------------------------------------------------
                -------------------------------------------------------------
                IF l_catype = '014' THEN
                    l_sql := 'INSERT INTO caschdtemp_list_fa (AUTOID, CAMASTID, AFACCTNO, CODEID, EXCODEID, BALANCE, QTTY, AMT, AQTTY, AAMT, STATUS,REQTTY,REAQTTY,RETAILBAL,PBALANCE, PQTTY,PAAMT,TRADE,ROUND)  '
                              || ' SELECT SEQ_CASCHDTEMP_LIST_FA.NEXTVAL,DAT.* '
                              || ' FROM(SELECT MAX(CA.CAMASTID) CAMASTID, MST.AFACCTNO, ''' || l_codeid || ''' CODEID, ''' || nvl(l_optcodeid,'''''') || ''' EXCODEID, '
                              || ' 0 BALANCE, 0  QTTY, 0 AMT, 0 AQTTY, 0 AAMT, ''A'' STATUS,' || nvl(l_reqttyexp,'''''') || '  REQTTY,' || nvl(l_reaqttyexp,'''''') || '  REAQTTY '
                              || ' ,TRUNC((SUM(MST.TRADE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.DTOCLOSE + MST.WITHDRAW + MST.NETTING + MST.HOLD) - SUM(NVL(TR.AMOUNT,0)))*'||l_right_exrate||'/'|| greatest(nvl(l_left_exrate,1),1)||') RETAILBAL,'
                              || ' TRUNC((SUM(MST.TRADE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.DTOCLOSE + MST.WITHDRAW + MST.NETTING + MST.HOLD) - SUM(NVL(TR.AMOUNT,0)))*'||l_right_exrate||'/'||greatest(nvl(l_left_exrate,1),1)||') PBALANCE, '
                              || nvl(l_qttyexp,'''''') || '  PQTTY,  ROUND(' || nvl(l_aamtexp,'''''') || ',0) PAAMT,'
                              || ' TRUNC((SUM(MST.TRADE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.DTOCLOSE + MST.WITHDRAW + MST.NETTING + MST.HOLD) - SUM(NVL(TR.AMOUNT,0)))) TRADE, '|| l_round ||' ROUND'
                              || ' FROM SBSECURITIES SYM, CAMAST CA, SEMAST MST,  '
                              || l_tr_amt --TR
                              || ' WHERE MST.CODEID=SYM.CODEID AND  CA.CODEID IN( SYM.CODEID , SYM.REFCODEID) AND ( SYM.CODEID = ''' || l_codeid || ''' OR  SYM.REFCODEID =''' || l_codeid || ''' ) AND MST.ACCTNO = TR.ACCTNO (+)  AND CA.CAMASTID =''' || l_camastid || ''''
                              || ' GROUP BY MST.AFACCTNO) DAT WHERE DAT.PBALANCE>0';

                ELSIF l_catype = '022' THEN
                    l_sql := 'INSERT INTO caschdtemp_list_fa (AUTOID, CAMASTID, AFACCTNO, CODEID, EXCODEID, BALANCE, QTTY, AMT, AQTTY, AAMT, STATUS,REQTTY,REAQTTY,RETAILBAL,TRADE,RQTTY,round)  '
                             || ' SELECT SEQ_CASCHDTEMP_LIST_FA.NEXTVAL,DAT.* '
                             || ' FROM(SELECT MAX(CA.CAMASTID) CAMASTID, MST.AFACCTNO, ''' || l_codeid || ''' CODEID, MAX(CA.EXCODEID) EXCODEID, '
                             || ' (SUM(MST.TRADE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.DTOCLOSE + MST.WITHDRAW + MST.NETTING + MST.HOLD) - SUM(NVL(TR.AMOUNT,0))) BALANCE, '
                             ||  ' 0  QTTY, ROUND(' || nvl(l_amtexp,'''''') || ',0) AMT, 0 AQTTY, ROUND(' || nvl(l_aamtexp,'''''') || ',0) AAMT, ''A'' STATUS,' || nvl(l_reqttyexp,'''''') || '  REQTTY,' || nvl(l_reaqttyexp,'''''') || '  REAQTTY '
                             || ' , 0  RETAILBAL,  '
                             || ' TRUNC((SUM(MST.TRADE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.DTOCLOSE + MST.WITHDRAW + MST.NETTING + MST.HOLD) - SUM(NVL(TR.AMOUNT,0)))) TRADE, ROUND(' || nvl(l_rqttyexp,'''''') || ',0) RQTTY, '|| l_round ||' ROUND'
                             || ' FROM SBSECURITIES SYM, CAMAST CA, SEMAST MST,  '
                             || l_tr_amt --TR
                             || ' WHERE  MST.CODEID=SYM.CODEID AND CA.CODEID IN( SYM.CODEID , SYM.REFCODEID) AND ( SYM.CODEID = ''' || l_codeid || ''' OR  SYM.REFCODEID =''' || l_codeid || ''' ) AND MST.ACCTNO = TR.ACCTNO (+)  AND CA.CAMASTID  =''' || l_camastid || ''''
                             || ' GROUP BY MST.AFACCTNO) DAT WHERE DAT.BALANCE>0';
                ELSIF l_catype = '020' THEN
                    l_sql := 'INSERT INTO caschdtemp_list_fa (AUTOID, CAMASTID, AFACCTNO, CODEID, EXCODEID, BALANCE, QTTY, AMT, AQTTY, AAMT, STATUS,REQTTY,REAQTTY,RETAILBAL,TRADE,ROUND)  '
                             || ' SELECT SEQ_CASCHDTEMP_LIST_FA.NEXTVAL,DAT.* '
                             || ' FROM(SELECT MAX(CA.CAMASTID) CAMASTID, MST.AFACCTNO, ''' || l_codeid || ''' CODEID, MAX(CA.CODEID) EXCODEID, '
                             || ' (SUM(MST.TRADE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.DTOCLOSE + MST.WITHDRAW + MST.NETTING + MST.HOLD)  - SUM(NVL(TR.AMOUNT,0))) BALANCE, '
                             || nvl(l_qttyexp,'''''') || '  QTTY, ROUND(' || nvl(l_amtexp,'''''') || ',0) AMT, ' || nvl(l_aqttyexp,'''''') || ' AQTTY, ROUND(' || nvl(l_aamtexp,'''''') || ',0) AAMT, ''A'' STATUS,' || nvl(l_reqttyexp,'''''') || '  REQTTY,' || nvl(l_reaqttyexp,'''''') || '  REAQTTY '
                             || ' , 0  RETAILBAL,  '
                             || ' TRUNC((SUM(MST.TRADE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.DTOCLOSE + MST.WITHDRAW + MST.NETTING + MST.HOLD)  - SUM(NVL(TR.AMOUNT,0)))) TRADE, '|| l_round ||' ROUND'
                             || ' FROM SBSECURITIES SYM, CAMAST CA, SEMAST MST,  '
                             || l_tr_amt --TR
                             || ' WHERE  MST.CODEID=SYM.CODEID AND CA.CODEID IN( SYM.CODEID , SYM.REFCODEID) AND ( SYM.CODEID = ''' || l_codeid || ''' OR  SYM.REFCODEID =''' || l_codeid || ''' ) AND MST.ACCTNO = TR.ACCTNO (+)  AND CA.CAMASTID  =''' || l_camastid || ''''
                             || ' GROUP BY MST.AFACCTNO) DAT WHERE DAT.BALANCE>0';
                ELSIF l_catype = '017' THEN
                    l_sql := 'INSERT INTO caschdtemp_list_fa (AUTOID, CAMASTID, AFACCTNO, CODEID, EXCODEID, BALANCE, QTTY, AMT, AQTTY, AAMT, STATUS,REQTTY,REAQTTY,RETAILBAL,TRADE,ROUND)  '
                             || ' SELECT SEQ_CASCHDTEMP_LIST_FA.NEXTVAL,DAT.* '
                             || ' FROM(SELECT MAX(CA.CAMASTID) CAMASTID, MST.AFACCTNO, ''' || l_codeid || ''' CODEID, MAX(CA.CODEID) EXCODEID, '
                             || ' (SUM(MST.TRADE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.DTOCLOSE + MST.WITHDRAW + MST.NETTING + MST.HOLD)  - SUM(NVL(TR.AMOUNT,0))) BALANCE, '
                             || nvl(l_qttyexp,'''''') || '  QTTY, ROUND(' || nvl(l_amtexp,'''''') || ',0) AMT, ' || nvl(l_aqttyexp,'''''') || ' AQTTY, ROUND(' || nvl(l_aamtexp,'''''') || ',0) AAMT, ''A'' STATUS,' || nvl(l_reqttyexp,'''''') || '  REQTTY,' || nvl(l_reaqttyexp,'''''') || '  REAQTTY '
                             || ' , 0  RETAILBAL , '
                             || ' TRUNC((SUM(MST.TRADE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.DTOCLOSE + MST.WITHDRAW + MST.NETTING + MST.HOLD)  - SUM(NVL(TR.AMOUNT,0)))) TRADE, '|| l_round ||' ROUND'
                             || ' FROM SBSECURITIES SYM, CAMAST CA, SEMAST MST,  '
                             || l_tr_amt --TR
                             || ' WHERE  MST.CODEID=SYM.CODEID AND  CA.CODEID IN( SYM.CODEID , SYM.REFCODEID) AND ( SYM.CODEID = ''' || l_codeid || ''' OR  SYM.REFCODEID =''' || l_codeid || ''' ) AND MST.ACCTNO = TR.ACCTNO (+)  AND CA.CAMASTID  =''' || l_camastid || ''''
                             || ' GROUP BY MST.AFACCTNO) DAT WHERE DAT.BALANCE>0';
                  ELSIF l_catype = '023' THEN
                    l_sql := 'INSERT INTO caschdtemp_list_fa (AUTOID, CAMASTID, AFACCTNO, CODEID, EXCODEID, BALANCE, QTTY, AMT, AQTTY, AAMT, STATUS,REQTTY,REAQTTY,RETAILBAL,TRADE,ROUND,PQTTY,INTAMT)  '
                             || ' SELECT SEQ_CASCHDTEMP_LIST_FA.NEXTVAL,DAT.* '
                             || ' FROM(SELECT MAX(CA.CAMASTID) CAMASTID, MST.AFACCTNO, ''' || l_codeid || ''' CODEID, MAX(CA.CODEID) EXCODEID, '
                             || ' (SUM(MST.TRADE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.DTOCLOSE + MST.WITHDRAW + MST.NETTING + MST.HOLD)  - SUM(NVL(TR.AMOUNT,0))) BALANCE, '
                             || ' 0  QTTY, ROUND(' || nvl(l_amtexp,'''''') || ',0) AMT, ' || nvl(l_aqttyexp,'''''') || ' AQTTY, ROUND(' || nvl(l_aamtexp,'''''') || ',0) AAMT, ''A'' STATUS,' || nvl(l_reqttyexp,'''''') || '  REQTTY,' || nvl(l_reaqttyexp,'''''') || '  REAQTTY '
                             || ' , 0  RETAILBAL , '
                             || ' TRUNC((SUM(MST.TRADE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.DTOCLOSE + MST.WITHDRAW + MST.NETTING + MST.HOLD) - SUM(NVL(TR.AMOUNT,0)))) TRADE, '|| l_round ||' ROUND, ' || nvl(l_qttyexp,'''''') || ' PQTTY , '
                             || ' ROUND(' || nvl(l_intamtexp,'''''') || ',0) INTAMT '
                             || ' FROM SBSECURITIES SYM, CAMAST CA, SEMAST MST,  '
                             || l_tr_amt --TR
                             || ' WHERE  MST.CODEID=SYM.CODEID AND  CA.CODEID IN( SYM.CODEID , SYM.REFCODEID) AND ( SYM.CODEID = ''' || l_codeid || ''' OR  SYM.REFCODEID =''' || l_codeid || ''' ) AND MST.ACCTNO = TR.ACCTNO (+)  AND CA.CAMASTID  =''' || l_camastid || ''''
                             || ' GROUP BY MST.AFACCTNO) DAT WHERE DAT.BALANCE>0';

                ELSIF l_catype = '040' THEN
                       l_sql := 'INSERT INTO caschdtemp_list_fa (AUTOID, CAMASTID, AFACCTNO, CODEID, EXCODEID, BALANCE, QTTY, AMT, AQTTY, AAMT, STATUS,REQTTY,REAQTTY,RETAILBAL,TRADE,ROUND,PQTTY,INTAMT)  '
                             || ' SELECT SEQ_CASCHD.NEXTVAL,DAT.* '
                             || ' FROM(SELECT MAX(CA.CAMASTID) CAMASTID, MST.AFACCTNO, ''' || l_codeid || ''' CODEID, MAX(CA.CODEID) EXCODEID, '
                             || ' 0 BALANCE, 0 QTTY, 0 AMT, ' || nvl(l_qttyexp,'''''') || ' AQTTY, ROUND(' || nvl(l_aamtexp,'''''') || ',0) AAMT, ''A'' STATUS,' || nvl(l_reqttyexp,'''''') || ' REQTTY,' || nvl(l_reaqttyexp,'''''') || ' REAQTTY '
                             || ' , 0  RETAILBAL , '
                             || ' TRUNC((SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.NETTING + MST.DTOCLOSE + MST.WITHDRAW + MST.HOLD) - SUM(TR.AMOUNT))) TRADE, '|| l_round ||' ROUND, ' || nvl(l_qttyexp,'''''') || ' PQTTY , '
                             || ' ROUND(' || nvl(l_intamtexp,'''''') || ',0) INTAMT '
                             || ' FROM SBSECURITIES SYM, CAMAST CA, SEMAST MST,  '
                             || ' (SELECT MST.ACCTNO, NVL(DTL.AMT,0) AMOUNT FROM SEMAST MST LEFT JOIN '
                             || ' (select DTL.ACCTNO, sum(DTL.AMT) amt From '
                             || ' (SELECT TR.ACCTNO, SUM((CASE WHEN TX.TXTYPE=''D'' THEN -TR.NAMT WHEN TX.TXTYPE=''C'' THEN TR.NAMT ELSE 0 END)) AMT  '
                             || ' FROM APPTX TX, SETRAN TR ,TLLOG TL '
                             || ' WHERE TX.APPTYPE=''SE'' AND TRIM(TX.FIELD) IN (''TRADE'',''MARGIN'',''WTRADE'',''MORTAGE'',''BLOCKWITHDRAW'',''EMKQTTY'',''BLOCKDTOCLOSE'',''BLOCKED'',''SECURED'',''REPO'',''NETTING'',''DTOCLOSE'',''WITHDRAW'',''HOLD'')  '
                             || ' AND TR.TXDATE=TL.TXDATE AND TR.TXNUM=TL.TXNUM AND TX.TXTYPE IN (''C'', ''D'') AND TL.DELTD <> ''Y'' '
                             || ' AND TX.TXCD=TR.TXCD AND TL.BUSDATE > TO_DATE(''' || to_char(l_reportdate,systemnums.c_date_format) || ''', ''DD/MM/RRRR'') GROUP BY TR.ACCTNO  '
                             || ' UNION ALL  '
                             || ' SELECT TR.ACCTNO, SUM((CASE WHEN TX.TXTYPE=''D'' THEN -TR.NAMT WHEN TX.TXTYPE=''C'' THEN TR.NAMT ELSE 0 END)) AMT  '
                             || ' FROM APPTX TX, SETRANA TR ,TLLOGALL TL  '
                             || ' WHERE TX.APPTYPE=''SE'' AND TRIM(TX.FIELD) IN (''TRADE'',''MARGIN'',''BLOCKWITHDRAW'',''EMKQTTY'',''BLOCKDTOCLOSE'',''WTRADE'',''MORTAGE'',''BLOCKED'',''SECURED'',''REPO'',''NETTING'',''DTOCLOSE'',''WITHDRAW'',''HOLD'')  '
                             || ' AND TR.TXDATE=TL.TXDATE AND TR.TXNUM=TL.TXNUM AND TX.TXTYPE IN (''C'', ''D'') AND TL.DELTD <> ''Y'' '
                             || ' AND TX.TXCD=TR.TXCD AND TL.BUSDATE > TO_DATE(''' || to_char(l_reportdate,systemnums.c_date_format) || ''', ''DD/MM/RRRR'') GROUP BY TR.ACCTNO) DTL group by DTL.acctno) DTL ON MST.ACCTNO=DTL.ACCTNO) TR '
                             || ' WHERE  MST.CODEID=SYM.CODEID AND  CA.CODEID IN( SYM.CODEID , SYM.REFCODEID) AND ( SYM.CODEID = ''' || l_codeid || ''' OR  SYM.REFCODEID =''' || l_codeid || ''' ) AND MST.ACCTNO = TR.ACCTNO  AND CA.CAMASTID  =''' || l_camastid || ''''
                             || ' GROUP BY MST.AFACCTNO) DAT WHERE DAT.AQTTY>0';

                ELSE
                    l_sql := 'INSERT INTO caschdtemp_list_fa (AUTOID, CAMASTID, AFACCTNO, CODEID, EXCODEID, BALANCE, QTTY, AMT, AQTTY, AAMT, STATUS,REQTTY,REAQTTY,RETAILBAL,TRADE,INTAMT,RQTTY,ROUND)  '
                             || ' SELECT SEQ_CASCHDTEMP_LIST_FA.NEXTVAL,DAT.* '
                             || ' FROM(SELECT MAX(CA.CAMASTID) CAMASTID, MST.AFACCTNO,''' || l_codeid || ''' CODEID, MAX(CA.EXCODEID) EXCODEID, '
                             || ' (SUM(MST.TRADE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.DTOCLOSE + MST.WITHDRAW + MST.NETTING + MST.HOLD)  - SUM(NVL(TR.AMOUNT,0))) BALANCE, '
                             || nvl(l_qttyexp,'''''') || '  QTTY, ROUND(' || nvl(l_amtexp,'''''') || ',0) AMT, ' || nvl(l_aqttyexp,'''''') || ' AQTTY, ROUND(' || nvl(l_aamtexp,'''''') || ',0) AAMT, ''A'' STATUS,' || nvl(l_reqttyexp,'''''') || '  REQTTY,' || nvl(l_reaqttyexp,'''''') || '  REAQTTY '
                             || ' , 0  RETAILBAL,  '
                             || ' TRUNC((SUM(MST.TRADE + MST.MARGIN + MST.WTRADE + MST.MORTAGE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.DTOCLOSE + MST.WITHDRAW + MST.NETTING + MST.HOLD) - SUM(NVL(TR.AMOUNT,0)))) TRADE, ROUND(' || nvl(l_intamtexp,'''''') || ',0) INTAMT, ROUND(' || nvl(l_rqttyexp,'''''') || ',0) RQTTY, '|| l_round ||' ROUND'
                             || ' FROM SBSECURITIES SYM, CAMAST CA, SEMAST MST,  '
                             || l_tr_amt --TR
                             || ' WHERE  MST.CODEID=SYM.CODEID AND  CA.CODEID IN( SYM.CODEID , SYM.REFCODEID) AND ( SYM.CODEID = ''' || l_codeid || ''' OR  SYM.REFCODEID =''' || l_codeid || ''' ) AND MST.ACCTNO = TR.ACCTNO (+)  AND CA.CAMASTID  =''' || l_camastid || ''''
                             || ' GROUP BY MST.AFACCTNO) DAT WHERE DAT.BALANCE>0';
                END IF;
                --Tao du lieu cho caschd
                
                
                
                EXECUTE IMMEDIATE l_sql;

                --Insert nhung khach hang co mot tieu khoan
                INSERT INTO CASCHD_LIST_FA (AUTOID, CAMASTID, AFACCTNO, CODEID, EXCODEID, BALANCE, QTTY, AMT, AQTTY, AAMT, STATUS,REQTTY,REAQTTY,RETAILBAL,TRADE,PBALANCE,PQTTY,PAAMT,INTAMT,RQTTY,TXDATE,LASTCHANGE)
                SELECT TMP.AUTOID, TMP.CAMASTID, TMP.AFACCTNO, TMP.CODEID, TMP.EXCODEID, TMP.BALANCE, TMP.QTTY, TMP.AMT,
                       TMP.AQTTY, TMP.AAMT, TMP.STATUS,TMP.REQTTY,TMP.REAQTTY,TMP.RETAILBAL,TMP.TRADE,TMP.PBALANCE,
                       TMP.PQTTY,TMP.PAAMT,TMP.INTAMT,TMP.RQTTY,p_txmsg.txdate,SYSDATE
                FROM CASCHDTEMP_LIST_FA TMP,
                    (SELECT CF.CUSTID, MAX(AF.ACCTNO) AFACCTNO FROM AFMAST AF, CFMAST CF
                        WHERE AF.CUSTID = CF.CUSTID
                            AND CF.CUSTATCOM='Y'
                            AND CF.STATUS <> 'C'
                            AND CF.SUPEBANK ='Y'
                        GROUP BY CF.CUSTID
                        HAVING COUNT(AF.ACCTNO)<=1
                    ) AF
                WHERE TMP.AFACCTNO = AF.AFACCTNO
                AND TMP.CAMASTID=l_camastid;


                -- Tinh ra CK tong theo so luu ky
                FOR rec_trade IN (
                        SELECT MST.*
                          FROM (SELECT SUM (DAT.TRADE) TRADESUM,
                                       AF.CUSTID,
                                       MAX (DAT.PARVALUE) PARVALUE
                                  FROM ( SELECT SUM (
                                                     MST.TRADE
                                                   + MST.MARGIN
                                                   + MST.WTRADE
                                                   + MST.MORTAGE
                                                   + MST.BLOCKWITHDRAW
                                                   + MST.EMKQTTY
                                                   + MST.BLOCKDTOCLOSE
                                                   + MST.BLOCKED
                                                   + MST.SECURED
                                                   + MST.REPO
                                                   + MST.DTOCLOSE
                                                   + MST.WITHDRAW
                                                   + MST.NETTING
                                                   + MST.HOLD)
                                               - SUM (NVL(TR.AMOUNT,0))
                                                   TRADE,
                                               MST.AFACCTNO,
                                               MAX (SYM.PARVALUE) PARVALUE
                                          FROM SEMAST MST,
                                               SBSECURITIES SYM,
                                               CAMAST CA,
                                               --PHAT SINH-------------------------------------------------------------------------------------------------------------
                                               (
                                                SELECT (CASE WHEN TR_SELL.ACCTNO IS NOT NULL THEN TR_SELL.ACCTNO ELSE TR_BUY.ACCTNO END) ACCTNO,
                                                       (SUM (NVL (TR_SELL.AMT, 0)) - SUM (NVL (TR_BUY.AMT, 0))) AMOUNT
                                                FROM --LENH MUA---------------------------------------
                                                     (
                                                       SELECT TMP.SEACCTNO ACCTNO,
                                                              SUM (TMP.QTTY) AMT
                                                       FROM (
                                                               --ETF CA
                                                               SELECT ETF.ORDERID, ETF.QTTY, (ETF.AFACCTNO||ETF.CODEID) SEACCTNO, ST.STATUS, ST.DUETYPE, ST.CLEARDATE
                                                               FROM ETFWSAP ETF, STSCHD ST
                                                               WHERE ETF.ORDERID = ST.ORDERID
                                                               UNION ALL
                                                               --NORMAL CA 
                                                               SELECT NG.ORDERID, NG.QTTY, NG.SEACCTNO, NG.STATUS, NG.DUETYPE, NG.CLEARDATE
                                                               FROM STSCHD NG
                                                               WHERE NOT EXISTS (SELECT 1 FROM ETFWSAP WHERE ORDERID = NG.ORDERID)
                                                             ) TMP
                                                       WHERE TMP.STATUS <> 'C'
                                                             AND TMP.CLEARDATE <= TO_DATE(TO_CHAR(L_REPORTDATE,SYSTEMNUMS.C_DATE_FORMAT), 'DD/MM/RRRR')  --L_REPORTDATE: NGAY CHOT
                                                             AND TMP.DUETYPE = 'RS'
                                                       GROUP BY TMP.SEACCTNO
                                                     ) TR_BUY
                                                     --------------------------------------------------
                                                     FULL JOIN
                                                     --LENH BAN----------------------------------------
                                                     (
                                                       SELECT TMP.SEACCTNO ACCTNO,
                                                              SUM (TMP.QTTY) AMT
                                                       FROM (
                                                               --ETF CA
                                                               SELECT ETF.ORDERID, ETF.QTTY, (ETF.AFACCTNO||ETF.CODEID) SEACCTNO, ST.STATUS, ST.DUETYPE, ST.CLEARDATE
                                                               FROM ETFWSAP ETF, STSCHD ST
                                                               WHERE ETF.ORDERID = ST.ORDERID
                                                               UNION ALL
                                                               --NORMAL CA 
                                                               SELECT NG.ORDERID, NG.QTTY, NG.SEACCTNO, NG.STATUS, NG.DUETYPE, NG.CLEARDATE
                                                               FROM STSCHD NG
                                                               WHERE NOT EXISTS (SELECT 1 FROM ETFWSAP WHERE ORDERID = NG.ORDERID)
                                                             ) TMP
                                                       WHERE TMP.STATUS <> 'C'
                                                             AND TMP.CLEARDATE <= TO_DATE(TO_CHAR(L_REPORTDATE,SYSTEMNUMS.C_DATE_FORMAT), 'DD/MM/RRRR')  --L_REPORTDATE:  NGAY CHOT
                                                             AND TMP.DUETYPE = 'SS'
                                                       GROUP BY TMP.SEACCTNO
                                                     ) TR_SELL
                                                     -------------------------------------------------
                                                     ON TR_BUY.ACCTNO = TR_SELL.ACCTNO
                                                GROUP BY TR_BUY.ACCTNO, TR_SELL.ACCTNO) TR
                                         WHERE MST.CODEID = SYM.CODEID
                                               AND CA.CODEID IN (SYM.CODEID, SYM.REFCODEID)
                                               AND (SYM.CODEID = L_CODEID OR SYM.REFCODEID = L_CODEID)
                                               AND MST.ACCTNO = TR.ACCTNO (+)
                                               AND CA.CAMASTID = L_CAMASTID
                                        GROUP BY MST.AFACCTNO) DAT,
                                       AFMAST AF,
                                       CFMAST CF
                                 WHERE     DAT.AFACCTNO = AF.ACCTNO
                                       AND DAT.TRADE > 0
                                       AND AF.CUSTID = CF.CUSTID
                                       AND CF.CUSTATCOM = 'Y'
                                       AND CF.SUPEBANK = 'Y'
                                       AND CF.STATUS <> 'C'
                                GROUP BY AF.CUSTID) MST,
                               (SELECT CF.CUSTID
                                  FROM AFMAST AF, CFMAST CF
                                 WHERE AF.CUSTID = CF.CUSTID AND CF.SUPEBANK = 'Y'
                                GROUP BY CF.CUSTID
                                HAVING COUNT (AF.ACCTNO) > 1) CF
                         WHERE MST.CUSTID = CF.CUSTID
                    )
                    LOOP
                      l_tradeSumByCustCD:=rec_trade.tradesum;
                      l_parvalue:=rec_trade.parvalue;
                      IF(l_tradeSumByCustCD >0) THEN
                      -- Tinh gia tri chung khoan cho quyen ve.
                            IF l_catype = '009' THEN --gc_CA_CATYPE_KIND_DIVIDEND  'Kind dividend
                               l_dbl_qttyexp := round(l_tradeSumByCustCD * l_dbl_right_devidentshares / l_dbl_left_devidentshares,0 );
                               l_dbl_amtexp := trunc(l_exprice * MOD(l_tradeSumByCustCD *l_dbl_right_devidentshares  , l_dbl_left_devidentshares )/ l_left_devidentshares);

                            ELSIF l_catype = '010' THEN --gc_CA_CATYPE_CASH_DIVIDEND 'Cash dividend(+QTTY,AMT)
                                IF (l_TYPERATE= 'R') THEN
                                   l_dbl_amtexp :=trunc( l_tradeSumByCustCD * l_parvalue /100* to_number(l_devidentrate),0);
                                ELSE
                                  l_dbl_amtexp := trunc( l_tradeSumByCustCD*to_number(l_devidentvalue),0);
                                END IF;
                                l_roundtype :=0;

                            ELSIF l_catype = '024' THEN --gc_CA_CATYPE_PAYING_INTERREST_BOND
                                l_dbl_amtexp := trunc(l_tradeSumByCustCD * l_parvalue /100 *  to_number(l_devidentrate),0);
                                l_roundtype := 0;

                            ELSIF l_catype = '011' THEN --gc_CA_CATYPE_STOCK_DIVIDEND 'Stock dividend (+QTTY,AMT)
                                l_dbl_qttyexp:=trunc (FLOOR( l_tradeSumByCustCD * l_dbl_right_devidentshares / l_dbl_left_devidentshares ),l_roundtype);
                                l_dbl_amtexp:= trunc( l_exprice * trunc(l_tradeSumByCustCD * l_dbl_right_devidentshares / l_dbl_left_devidentshares -l_dbl_qttyexp,l_ciroundtype),0);
                                

                            ELSIF l_catype = '025' THEN --gc_CA_CATYPE_PRINCIPLE_BOND
                                l_dbl_amtexp:= round (l_tradeSumByCustCD*l_exprice,0);
                                l_dbl_aamtexp:= l_tradeSumByCustCD;

                            ELSIF l_catype = '021' THEN --gc_CA_CATYPE_KIND_STOCK
                                  l_dbl_qttyexp:=trunc (FLOOR( l_tradeSumByCustCD * l_dbl_right_exrate / l_dbl_left_exrate ),l_roundtype);
                                  plog.debug(pkgctx,rec_trade.custid||' 021so chuan: ' ||l_tradeSumByCustCD * l_dbl_right_exrate / l_dbl_left_exrate|| ' so chia ' || l_dbl_qttyexp || ' round ' || l_ciroundtype);
                                  l_dbl_amtexp:= trunc (l_exprice * trunc(l_tradeSumByCustCD * l_dbl_right_exrate / l_dbl_left_exrate -l_dbl_qttyexp,l_ciroundtype),0);
                                  plog.debug(pkgctx,rec_trade.custid||' 021amt: ' || l_dbl_amtexp );

                            ELSIF l_catype = '020' THEN --gc_CA_CATYPE_CONVERT_STOCK
                                  l_dbl_aqttyexp:= l_tradeSumByCustCD;
                                  l_dbl_qttyexp:=trunc (FLOOR( l_tradeSumByCustCD * l_dbl_right_devidentshares / l_dbl_left_devidentshares ),l_roundtype);
                                  l_dbl_amtexp:= trunc( l_exprice * trunc(l_tradeSumByCustCD * l_dbl_right_devidentshares / l_dbl_left_devidentshares -l_dbl_qttyexp,l_ciroundtype),0);

                            ELSIF l_catype = '012' THEN --gc_CA_CATYPE_STOCK_SPLIT 'Stock Split(+ QTTY,AMT)
                                  l_dbl_qttyexp:= TRUNC( l_tradeSumByCustCD/  to_number(l_splitrate)  - l_tradeSumByCustCD, l_roundtype );
                                  l_dbl_amtexp:= trunc(l_exprice*( l_tradeSumByCustCD / to_number( l_splitrate) - l_tradeSumByCustCD -  l_dbl_qttyexp ),0);
                            ELSIF l_catype = '013' THEN --gc_CA_CATYPE_STOCK_MERGE 'Stock Merge(-AQTTY,+AMT)
                                  l_dbl_aqttyexp:= l_tradeSumByCustCD - TRUNC( l_tradeSumByCustCD/ to_number(l_splitrate) ,  l_roundtype) ;

                                  -- PhuongHT edit
                                  l_dbl_amtexp:= trunc(l_exprice *( l_aqttyexp  - (l_tradeSumByCustCD - l_tradeSumByCustCD / to_number( l_splitrate ))));

                                  -- end of PhuongHT edit
                            ELSIF l_catype = '014' THEN --gc_CA_CATYPE_STOCK_RIGHTOFF 'Stock Rightoff(+QTTY,-AAMT)
                                  l_dbl_qttyexp:=FLOOR((l_tradeSumByCustCD *l_dbl_right_rightoffrate * l_dbl_right_exrate )/( l_dbl_left_rightoffrate * l_dbl_left_exrate ));
                                  l_dbl_aamtexp:= round(l_exprice  * TRUNC( FLOOR((l_tradeSumByCustCD * l_dbl_right_rightoffrate * l_dbl_right_exrate)/( l_dbl_left_rightoffrate * l_dbl_left_exrate )),  l_roundtype ),0);
                                  l_dbl_RETAILBALEXP:= TRUNC(l_tradeSumByCustCD * l_dbl_right_exrate / l_dbl_left_exrate);

                            ELSIF l_catype = '015' THEN --gc_CA_CATYPE_BOND_PAY_INTEREST 'Bond pay interest, Lai suat theo thang, chu ky theo nam (+AMT)
                                  l_dbl_amtexp:=round(l_tradeSumByCustCD * l_parvalue /100 * to_number(l_interestrate),0) ;
                                  l_dbl_intamtexp:=round(l_tradeSumByCustCD * l_parvalue /100 * to_number(l_interestrate),0) ;
                                  l_roundtype := 0;

                            ELSIF l_catype = '016' THEN -- gc_CA_CATYPE_BOND_PAY_INTEREST_PRINCIPAL 'Bond pay interest || prin, Lai suat theo thang, chu ky theo nam (+AMT)
                                  l_dbl_amtexp:=round ( l_tradeSumByCustCD *l_parvalue * (1+  to_number(l_interestrate)  /100 ),0) ;
                                  -- PhuongHT: ghi nhan rieng phan lai
                                  l_dbl_intamtexp:= round(l_tradeSumByCustCD * l_parvalue /100 *  to_number(l_interestrate),0) ;
                                  l_roundtype:= 0 ;

                            ELSIF l_catype = '017' THEN -- gc_CA_CATYPE_CONVERT_BOND_TO_SHARE 'Convert bond to share (+QTTY Share,-AQTTY Bound)
                                  l_dbl_aqttyexp:= l_tradeSumByCustCD;
                                  l_dbl_qttyexp:=trunc (FLOOR( l_tradeSumByCustCD * l_dbl_right_exrate / l_dbl_left_exrate ),l_roundtype);
                                  l_dbl_amtexp:= trunc( l_exprice * trunc(l_tradeSumByCustCD * l_dbl_right_exrate / l_dbl_left_exrate -l_dbl_qttyexp,l_ciroundtype),0);

                            ELSIF l_catype = '023' THEN -- gc_CA_CATYPE_CONVERT_BOND_TO_SHARE 'Convert bond to share (+QTTY Share,-AQTTY Bound)
                                  l_dbl_aqttyexp:= l_tradeSumByCustCD;
                                  l_dbl_qttyexp:=trunc (FLOOR( l_tradeSumByCustCD * l_dbl_right_exrate / l_dbl_left_exrate ),l_roundtype);
                                  l_dbl_amtexp:= trunc( l_parvalue *(1+l_interestrate/100)* l_tradeSumByCustCD,0);
                                  -- PhuongHT: ghi nhan rieng phan lai
                                    --thunt-17/01/2020-khai bao hinh thuc chi tra doi voi skq 023
                                 if l_formofpayment = '001' then
                                    l_dbl_intamtexp:= round(l_tradeSumByCustCD *  to_number(l_interestrate),0) ;
                                 else
                                     l_dbl_intamtexp:= round(l_tradeSumByCustCD * l_parvalue /100 *  to_number(l_interestrate),0) ;
                                 end if;
                            ELSIF l_catype = '018' THEN -- gc_CA_CATYPE_CONVERT_RIGHT_TO_SHARE 'Convert Right to share (+QTTY Share, -AQTTY Right)
                                  l_dbl_qttyexp:= l_tradeSumByCustCD;
                                  l_dbl_aqttyexp:= l_tradeSumByCustCD;
                                  l_roundtype:= 0 ;
                            ELSIF l_catype = '019' THEN -- gc_CA_CATYPE_CHANGE_TRADING_PLACE_STOCK 'Change trading place (+QTTY )
                                  l_dbl_qttyexp:= 0;
                                  l_dbl_amtexp:=0;
                            ELSIF  l_catype IN ( '005' , '006','022','028') THEN
                                   l_dbl_rqttyexp:= FLOOR((l_tradeSumByCustCD* l_dbl_right_devidentshares )/ l_dbl_left_devidentshares );
                            /*Add By TruongLD them su kien quyen giai the to chuc*/
                            ELSIF l_catype = '027' THEN --gc_CA_CATYPE_CASH_DIVIDEND 'Cash dividend(+QTTY,AMT)
                                IF(l_TYPERATE= 'R') THEN
                                    l_dbl_amtexp :=trunc( l_tradeSumByCustCD * l_parvalue /100* to_number(l_devidentrate),0);
                                ELSE
                                    l_dbl_amtexp := trunc( l_tradeSumByCustCD*to_number(l_devidentvalue),0);
                                END IF;
                                IF  l_cancelshare = 'Y' THEN
                                    l_dbl_aqttyexp:= l_tradeSumByCustCD;
                                ELSE
                                    l_dbl_aqttyexp:= 0;
                                END IF;
                                l_roundtype :=0;
                            --T9/2019 CW_PhaseII
                            ELSIF l_catype = '024' THEN --gc_CA_CATYPE_CASH_CW 'Chi tra loi tuc CW bang tien
                                if(l_TYPERATE= 'R') THEN
                                    l_dbl_amtexp :=trunc( l_tradeSumByCustCD * l_EXPRICE /100* to_number(l_devidentrate),l_roundtype);
                                ELSE
                                  l_dbl_amtexp := trunc( l_tradeSumByCustCD*to_number(l_devidentvalue),l_roundtype);
                                  END IF;
                                --l_roundtype :=0;
                            -- End T9/2019 CW_PhaseII
                            END IF;

                            -- So chung khoan le.
                               l_dbl_reqttyexp:=  l_dbl_qttyexp - TRUNC( l_dbl_qttyexp , l_roundtype );

                            IF l_catype = '017' OR l_catype = '020' THEN
                               l_dbl_reaqttyexp:=(l_dbl_aqttyexp  - TRUNC( l_dbl_aqttyexp  , 0  ));

                            ELSE
                               l_dbl_reaqttyexp:=  l_dbl_aqttyexp  - TRUNC( l_dbl_aqttyexp  , l_roundtype );
                            END IF;
                            -- So chung khoan da lam tron.
                               l_dbl_qttyexp:= TRUNC( l_dbl_qttyexp , l_roundtype );
                            -- so CK jam
                            IF l_catype = '017' OR l_catype = '020' OR l_catype='023' THEN
                               l_dbl_aqttyexp:= TRUNC( l_dbl_aqttyexp , 0 );
                            ELSE
                               l_dbl_aqttyexp:= TRUNC( l_dbl_aqttyexp , l_roundtype );
                            END IF;
                            -- so tien dc nhan
                            IF l_catype = '011' AND l_catype = '009' THEN
                                l_dbl_amtexp:= ROUND( l_dbl_amtexp  +  l_dbl_reqttyexp  *  l_exprice );
                            ELSIF l_catype='023' THEN
                                l_dbl_amtexp:=l_dbl_amtexp;
                            ELSE
                                l_dbl_amtexp:= l_dbl_amtexp  +  l_dbl_reqttyexp  *  l_exprice;
                            END IF;
                            IF (l_catype <> '023') THEN
                               l_dbl_aamtexp:=l_dbl_aamtexp  +  l_dbl_reaqttyexp * l_exprice;
                            ELSE
                                l_dbl_aamtexp:=l_dbl_aamtexp  +  l_dbl_reaqttyexp * l_parvalue;
                            END IF;

                            l_dbl_reaqttyexp :=0;
                            l_dbl_reqttyexp :=0;

                            SELECT COUNT(*) INTO l_count_temp
                            FROM caschdtemp_list_fa,afmast af
                            WHERE caschdtemp_list_fa.camastid = l_camastid and caschdtemp_list_fa.afacctno=af.acctno
                            and af.custid=rec_trade.custid ;

                            -- dua vao du lieu trong bang caschdtemp de phan bo  co tuc  theo thu tu uu tien cho Kh,
                            -- bot lai tieu khoan  cuoi cung
                            
                            IF (l_count_temp>0  ) THEN
                                INSERT INTO caschd_list_fa (AUTOID, CAMASTID, AFACCTNO, CODEID, EXCODEID, BALANCE, QTTY, AMT, AQTTY, AAMT, STATUS,REQTTY,REAQTTY,RETAILBAL,TRADE,PBALANCE,PQTTY,PAAMT,INTAMT,RQTTY,ORGPBALANCE)
                                SELECT *
                                FROM  (
                                      SELECT autoid,camastid,temp.afacctno afacctno,codeid,excodeid,balance,
                                             (CASE WHEN (round= 0 OR qtty=0 /*OR l_dbl_qttyexp=0*/ or l_catype in ('014','023')) THEN qtty ELSE trunc(l_dbl_qttyexp*trade/l_tradeSumByCustCD,l_roundtype)END) QTTY,
                                             (CASE WHEN (round= 0 OR amt=0 /*OR l_dbl_amtexp =0*/ ) THEN amt ELSE round(l_dbl_amtexp*trade/l_tradeSumByCustCD,0)END) AMT,
                                             (CASE WHEN (round= 0 OR aqtty=0 /*OR l_dbl_aqttyexp =0*/ ) THEN aqtty ELSE round(l_dbl_aqttyexp*trade/l_tradeSumByCustCD,0)END) AQTTY,
                                             (CASE WHEN (round= 0 OR AAMT=0 /*OR l_dbl_AAMTexp =0*/ ) THEN AAMT ELSE round(l_dbl_AAMTexp*trade/l_tradeSumByCustCD,0)END) AAMT,
                                             temp.STATUS,REQTTY,REAQTTY,
                                             (CASE WHEN (round= 0 OR RETAILBAL=0 /*OR l_dbl_RETAILBALexp =0*/ ) THEN RETAILBAL ELSE round(l_dbl_RETAILBALexp*trade/l_tradeSumByCustCD,0)END) RETAILBAL,
                                             trade,
                                             (CASE WHEN (round= 0 OR RETAILBAL=0 /* OR l_dbl_RETAILBALexp =0*/) THEN RETAILBAL ELSE round(l_dbl_RETAILBALexp*trade/l_tradeSumByCustCD,0)END) PBALANCE,
                                             (CASE WHEN (round= 0 OR PQTTY=0 /*OR l_dbl_qttyexp=0*/) THEN PQTTY ELSE round(l_dbl_qttyexp*trade/l_tradeSumByCustCD,0)END) PQTTY,
                                             (CASE WHEN (round= 0 OR PAAMT=0 /*OR l_dbl_aamtexp=0*/ ) THEN PAAMT ELSE round(l_dbl_aamtexp*trade/l_tradeSumByCustCD,0)END) PAAMT,
                                             (CASE WHEN (round= 0 OR INTAMT=0  /*OR  l_dbl_INTAMTexp =0*/) THEN INTAMT ELSE round(l_dbl_INTAMTexp*trade/l_tradeSumByCustCD,0)END) INTAMT,
                                             (CASE WHEN (round= 0 OR RQTTY=0 /*OR l_dbl_RQTTYexp  =0*/) THEN RQTTY ELSE round(l_dbl_RQTTYexp*trade/l_tradeSumByCustCD,0)END) RQTTY,
                                             (CASE WHEN (round= 0 OR RETAILBAL=0 /*OR l_dbl_RETAILBALexp =0 */) THEN RETAILBAL ELSE round(l_dbl_RETAILBALexp*trade/l_tradeSumByCustCD,0)END) ORGPBALANCE
                                      FROM caschdtemp_list_fa temp, afmast af
                                      WHERE temp.afacctno=af.acctno
                                            AND af.custid =rec_trade.custid
                                            AND temp.camastid=l_camastid
                                      ORDER BY round,trade,afacctno)
                                  WHERE ROWNUM < l_count_temp;
                                
                                -- KH cuoi cung: insert gia tri con lai

                                INSERT INTO caschd_list_fa (AUTOID, CAMASTID, AFACCTNO, CODEID, EXCODEID, BALANCE, QTTY, AMT, AQTTY, AAMT, STATUS,REQTTY,REAQTTY,RETAILBAL,TRADE,PBALANCE,PQTTY,PAAMT,INTAMT,RQTTY,ORGPBALANCE)
                                SELECT autoid,temp.camastid, afacctno,codeid,excodeid,balance,
                                       --31/05/2018 DieuNDA: Bo case WHEN (temp.qtty=0 ) THEN temp.qtty chi lay nhanh ELSE (l_dbl_qttyexp-nvl(schdsum.qtty,0))
                                       --Ly do: Co TH tai khoan co 2 tieu khoan, neu tinh ler do lam tron thi tung tieu khoan = 0, nhung neu tinh tren tai khoan thi = 1.
                                       (case when l_catype in ('014','023') then 0 else (l_dbl_qttyexp-nvl(schdsum.qtty,0)) end) QTTY, --(CASE WHEN (temp.qtty=0 ) THEN temp.qtty ELSE (l_dbl_qttyexp-nvl(schdsum.qtty,0))END) QTTY,
                                       (l_dbl_amtexp- nvl(schdsum.amt,0)) AMT, --(CASE WHEN ( temp.amt=0 ) THEN temp.amt ELSE (l_dbl_amtexp- nvl(schdsum.amt,0))END) AMT,
                                       (l_dbl_aqttyexp-nvl(schdsum.aqtty,0)) AQTTY, --(CASE WHEN ( temp.aqtty=0 ) THEN temp.aqtty ELSE (l_dbl_aqttyexp-nvl(schdsum.aqtty,0))END) AQTTY,
                                       (l_dbl_AAMTexp -nvl(schdsum.aamt,0)) AAMT, --(CASE WHEN ( temp.AAMT=0 ) THEN temp.AAMT ELSE (l_dbl_AAMTexp -nvl(schdsum.aamt,0))END) AAMT,
                                       STATUS,REQTTY,REAQTTY,
                                       round(l_dbl_RETAILBALexp-nvl(schdsum.RETAILBAL,0)) RETAILBAL, --(CASE WHEN ( temp.RETAILBAL=0 ) THEN temp.RETAILBAL ELSE round(l_dbl_RETAILBALexp-nvl(schdsum.RETAILBAL,0))END) RETAILBAL,
                                       trade,
                                       round(l_dbl_RETAILBALexp-nvl(schdsum.RETAILBAL,0)) RETAILBAL, --(CASE WHEN ( temp.RETAILBAL=0 ) THEN temp.RETAILBAL ELSE round(l_dbl_RETAILBALexp-nvl(schdsum.RETAILBAL,0))END) PBALANCE,
                                       (l_dbl_qttyexp-nvl(schdsum.pqtty,0)) PQTTY,--(CASE WHEN ( temp.PQTTY=0 ) THEN temp.PQTTY ELSE (l_dbl_qttyexp-nvl(schdsum.pqtty,0))END) PQTTY,
                                       (l_dbl_aamtexp-nvl(schdsum.PAAMT,0)) PAAMT, --(CASE WHEN ( temp.PAAMT=0 ) THEN temp.PAAMT ELSE (l_dbl_aamtexp-nvl(schdsum.PAAMT,0))END) PAAMT,
                                       (l_dbl_INTAMTexp-nvl(schdsum.INTAMT,0)) INTAMT, --(CASE WHEN (temp.INTAMT=0 ) THEN temp.INTAMT ELSE (l_dbl_INTAMTexp-nvl(schdsum.INTAMT,0))END) INTAMT,
                                       (l_dbl_RQTTYexp-nvl(schdsum.RQTTY,0)) RQTTY, --(CASE WHEN ( temp.RQTTY=0 ) THEN temp.RQTTY ELSE (l_dbl_RQTTYexp-nvl(schdsum.RQTTY,0))END) RQTTY,
                                       round(l_dbl_RETAILBALexp-nvl(schdsum.RETAILBAL,0)) RETAILBAL--(CASE WHEN ( temp.RETAILBAL=0 ) THEN temp.RETAILBAL ELSE round(l_dbl_RETAILBALexp-nvl(schdsum.RETAILBAL,0))END) ORGPBALANCE
                                       --End 31/05/2018 DieuNDA: Bo case WHEN (temp.qtty=0 ) THEN temp.qtty chi lay nhanh ELSE (l_dbl_qttyexp-nvl(schdsum.qtty,0))
                                FROM (
                                     SELECT *
                                     FROM (
                                          SELECT TEMP.*
                                          FROM CASCHDTEMP_LIST_FA TEMP,AFMAST
                                          WHERE TEMP.AFACCTNO=AFMAST.ACCTNO AND AFMAST.CUSTID=REC_TRADE.CUSTID
                                          ORDER BY ROUND DESC,TRADE DESC,AFACCTNO  DESC
                                          )
                                      WHERE  ROWNUM=1
                                      ) TEMP,
                                     (
                                     SELECT SUM(QTTY) QTTY, SUM(AMT) AMT,SUM(AQTTY) AQTTY,SUM(AAMT) AAMT,
                                            SUM(RETAILBAL) RETAILBAL,SUM(PBALANCE) PBALANCE, SUM(PQTTY) PQTTY,
                                            SUM(PAAMT) PAAMT,SUM(INTAMT) INTAMT, SUM(RQTTY) RQTTY, CAMASTID
                                      FROM CASCHD_LIST_FA , AFMAST
                                      WHERE CAMASTID=L_CAMASTID
                                            AND AFMAST.ACCTNO=CASCHD_LIST_FA.AFACCTNO
                                            AND AFMAST.CUSTID=REC_TRADE.CUSTID AND DELTD='N'
                                      GROUP BY CAMASTID
                                      ) SCHDSUM
                                WHERE TEMP.CAMASTID= SCHDSUM.CAMASTID(+);
                              END IF ;
                            END IF; -- end of tradesumbycustcd >0
                  END LOOP;
            END LOOP;
        END IF;
        /*
    Begin

         IF l_catype = '014' THEN
            ------------Insert isincode -----------------
             UPDATE camast SET optcodeid = l_optcodeid
                            WHERE camastid = l_camastid;
             
            Select Count(1) INTO l_countisincode from sbsecurities where CODEID= l_optcodeid  and SYMBOL= l_optsymbol ;
            IF l_countisincode = 0 THEN
               INSERT INTO sbsecurities (CODEID,ISINCODE,ISSUERID,SYMBOL,SECTYPE,INVESTMENTTYPE,RISKTYPE,PARVALUE,FOREIGNRATE,STATUS,TRADEPLACE,DEPOSITORY,SECUREDRATIO,MORTAGERATIO,REPORATIO,ISSUEDATE,EXPDATE,INTPERIOD,INTRATE)
               SELECT  l_optcodeid ,l_optisincode,ISSUERID, l_optsymbol ,'004' SECTYPE,INVESTMENTTYPE,RISKTYPE,PARVALUE,FOREIGNRATE,STATUS,TRADEPLACE,DEPOSITORY,SECUREDRATIO,MORTAGERATIO,REPORATIO,ISSUEDATE,EXPDATE,INTPERIOD,INTRATE
               FROM SBSECURITIES WHERE CODEID= l_codeid;
               
               INSERT INTO SECURITIES_INFO (AUTOID,CODEID,SYMBOL,TXDATE,LISTINGQTTY,TRADEUNIT,LISTINGSTATUS,ADJUSTQTTY,LISTTINGDATE,REFERENCESTATUS,ADJUSTRATE,REFERENCERATE,REFERENCEDATE,STATUS,BASICPRICE,OPENPRICE,PREVCLOSEPRICE,CURRPRICE)
               SELECT SEQ_SECURITIES_INFO.NEXTVAL, l_optcodeid,l_optsymbol,TXDATE,LISTINGQTTY,TRADEUNIT,LISTINGSTATUS,ADJUSTQTTY,LISTTINGDATE,REFERENCESTATUS,ADJUSTRATE,REFERENCERATE,REFERENCEDATE,STATUS,BASICPRICE,OPENPRICE,PREVCLOSEPRICE,CURRPRICE
               FROM SECURITIES_INFO WHERE CODEID= l_codeid;
               INSERT INTO SECURITIES_TICKSIZE (AUTOID,CODEID,SYMBOL,TICKSIZE,FROMPRICE,TOPRICE,STATUS)
               SELECT SEQ_SECURITIES_TICKSIZE.NEXTVAL, l_optcodeid , l_optsymbol,TICKSIZE,FROMPRICE,TOPRICE,STATUS
               FROM SECURITIES_TICKSIZE  WHERE CODEID= l_codeid ;
            ELSE
               UPDATE SBSECURITIES SET ISINCODE=L_OPTISINCODE WHERE CODEID= L_CODEID and SYMBOL= l_optsymbol;
            END IF;
        end if;
        ---------------------------------------------

    End;
    */

     ---2
    --TruongLD add 19/02/2020, Chuyen code send email tu day xuong API.
    --sendmailafter3312(l_camastid, p_err_code);
    --If p_err_code <> systemnums.C_SUCCESS then
    --    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
    --    RETURN errnums.C_BIZ_RULE_INVALID;
    --End If;
    --End TruongLD
    ELSE -- deltd TRANSACTION
        SELECT COUNT(1) INTO l_count FROM caschd_list_fa WHERE CAMASTID= l_camastid AND STATUS IN ('S','C') AND DELTD = 'N';
        IF l_count > 0 THEN
            p_err_code := '-300005';
            plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
            RETURN errnums.C_BIZ_RULE_INVALID;
        ELSE --xoa quyen.
            UPDATE caschd_list_fa SET deltd = 'Y' WHERE camastid = l_camastid;

        END IF;
    END IF;
    plog.debug (pkgctx, '<<END OF fn_txAftAppUpdate');
    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
       plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txAftAppUpdate;

BEGIN
      FOR i IN (SELECT *
                FROM tlogdebug)
      LOOP
         logrow.loglevel    := i.loglevel;
         logrow.log4table   := i.log4table;
         logrow.log4alert   := i.log4alert;
         logrow.log4trace   := i.log4trace;
      END LOOP;
      pkgctx    :=
         plog.init ('TXPKS_#3322EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#3322EX;
/
