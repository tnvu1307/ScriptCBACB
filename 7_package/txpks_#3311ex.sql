SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#3311ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#3311EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      21/08/2010     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#3311ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_camastid         CONSTANT CHAR(2) := '03';
   c_symbol           CONSTANT CHAR(2) := '04';
   c_catype           CONSTANT CHAR(2) := '05';
   c_reportdate       CONSTANT CHAR(2) := '06';
   c_actiondate       CONSTANT CHAR(2) := '07';
   c_rate             CONSTANT CHAR(2) := '10';
   c_status           CONSTANT CHAR(2) := '20';
   c_desc             CONSTANT CHAR(2) := '30';
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
            begin
                SELECT catype INTO l_catype FROM camast WHERE camastid = l_camastid;
            exception when others then
                p_err_code := '-300043';
                plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end;
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
/*    IF to_date(p_txmsg.txdate,systemnums.C_DATE_FORMAT) <= l_reportdate THEN
            p_err_code := '-300018';
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;*/
    plog.debug (pkgctx, '<<END OF fn_txPreAppCheck');
    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
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
      plog.error (pkgctx, SQLERRM);
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
      plog.error (pkgctx, SQLERRM);
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

    l_optcodeid varchar2(6);

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
    l_excodeid varchar2(6);
    l_codeid varchar2(6);
    l_email varchar2(100);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    l_camastid:= p_txmsg.txfields('03').value;
    l_reportdate:= TO_DATE(p_txmsg.txfields('06').value,systemnums.C_DATE_FORMAT);
    l_actiondate:= TO_DATE(p_txmsg.txfields('07').value,systemnums.C_DATE_FORMAT);
    IF p_txmsg.deltd <> 'Y' THEN -- NORMAL TRANSACTION
        -- update parvalue trong camast
/*        UPDATE camast SET parvalue=
          (SELECT se.parvalue FROM sbsecurities se, camast ca WHERE  camastid=l_camastid AND se.codeid=ca.codeid)
         WHERE camastid=l_camastid;*/
        -- xoa du lieu cu cua bang tam.
        DELETE FROM  caschdtemp_list;
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
                l_tocodeid:= camast_rec.TOCODEID;
                l_roundtype:= nvl(camast_rec.ROUNDTYPE,0);
                l_ciroundtype:= nvl(camast_rec.CIROUNDTYPE,0);
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


                IF l_catype = '014' THEN
                    SELECT '9' || lpad(MAX (nvl(odr,0)) + 1,5,'0') INTO l_optcodeid
                    FROM     (SELECT   ROWNUM odr, invacct
                                FROM   (  SELECT   invacct
                                            FROM   (  SELECT   codeid invacct
                                                        FROM sbsecurities
                                                        WHERE substr(codeid,1,1)=9
                                                        UNION ALL
                                                      SELECT '900001'
                                                        FROM dual)
                                        ORDER BY   invacct) dat
                    WHERE   substr(invacct,2,5) = ROWNUM) invtab;
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

            -- Tinh gia tri chung khoan cho quyen ve.
                IF l_catype = '009' THEN --gc_CA_CATYPE_KIND_DIVIDEND  'Kind dividend
                    l_qttyexp := 'FLOOR(((SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE  + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*' || l_right_devidentshares || ')/' || l_left_devidentshares || ')';
                    l_amtexp := '(' || l_exprice || '*MOD((SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.MORTAGE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE +MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*' || l_right_devidentshares || ' ,' || l_left_devidentshares || '))/' || l_left_devidentshares;
                     L_ROUND:= ' (CASE WHEN ( MOD((SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.MORTAGE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*' || l_right_devidentshares || ' ,' || l_left_devidentshares || '))> 0 THEN 1 ELSE 0 END) ';
                     ELSIF l_catype = '010' THEN --gc_CA_CATYPE_CASH_DIVIDEND 'Cash dividend(+QTTY,AMT)
                      if(l_TYPERATE= 'R') THEN
                    l_amtexp := '(SUM(MST.TRADE + MST.MARGIN + MST.WTRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*MAX(SYM.PARVALUE)/100*' || l_devidentrate;
                    ELSE
                      l_amtexp := '(SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.MORTAGE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*' || l_devidentvalue;
                      END IF;
                    l_roundtype :=0;
                      L_ROUND:= ' (CASE WHEN (FLOOR( '|| l_amtexp  || ' ) <> '|| l_amtexp || ' ) THEN 1 ELSE 0 END)';
                ELSIF l_catype = '024' THEN --gc_CA_CATYPE_PAYING_INTERREST_BOND
                    l_amtexp := '(SUM(MST.TRADE + MST.MARGIN + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.WTRADE  + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*MAX(SYM.PARVALUE)/100*' || l_devidentrate;
                    l_roundtype := 0;

               ELSIF l_catype = '011' THEN --gc_CA_CATYPE_STOCK_DIVIDEND 'Stock dividend (+QTTY,AMT)
                    --26/06/2018 DieuNDA: Tam thoi thay doi rule lam tron(chuyen tu TRUNC --> ROUND) do khai bao quyen dac biet
                    l_qttyexp:= 'FLOOR(((SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.MORTAGE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*' || l_right_devidentshares || ')/' || l_left_devidentshares || ')';
                    --l_qttyexp:= 'ROUND(((SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.MORTAGE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*' || l_right_devidentshares || ')/' || l_left_devidentshares || ')';
                    --End 26/06/2018 DieuNDA
                    --26/06/2018 DieuNDA: Tam thoi thay doi rule lam tron(chuyen tu TRUNC --> ROUND) do khai bao quyen dac biet
                    l_amtexp:= '(' || l_exprice || '* TRUNC( MOD((SUM(MST.TRADE + MST.MARGIN + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.WTRADE  + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*' || l_right_devidentshares || ' ,' || l_left_devidentshares || ')/' || l_left_devidentshares||',' || l_ciroundtype|| '))';
                    --l_amtexp:= '(' || l_exprice || '* ROUND( MOD((SUM(MST.TRADE + MST.MARGIN + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.WTRADE  + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*' || l_right_devidentshares || ' ,' || l_left_devidentshares || ')/' || l_left_devidentshares||',' || l_ciroundtype|| '))';
                    --End 26/06/2018 DieuNDA
                      L_ROUND:= ' (CASE WHEN (((SUM(MST.TRADE + MST.MARGIN + MST.WTRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*' || l_right_devidentshares || ' / ' || l_left_devidentshares || ')- '
                      --26/06/2018 DieuNDA: Tam thoi thay doi rule lam tron(chuyen tu TRUNC --> ROUND) do khai bao quyen dac biet
                                || ' TRUNC((SUM(MST.TRADE + MST.MARGIN + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.WTRADE  + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*' || l_right_devidentshares || ' / ' || l_left_devidentshares || ', '||L_ROUNDTYPE ||' ))> 0 THEN 1 ELSE 0 END) ';
                                --|| ' ROUND((SUM(MST.TRADE + MST.MARGIN + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.WTRADE  + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*' || l_right_devidentshares || ' / ' || l_left_devidentshares || ', '||L_ROUNDTYPE ||' ))> 0 THEN 1 ELSE 0 END) ';
                    --End 26/06/2018 DieuNDA


               ELSIF l_catype = '025' THEN --gc_CA_CATYPE_PRINCIPLE_BOND
                    l_amtexp:='(SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*' || l_exprice;
                    l_aamtexp:='(SUM(MST.TRADE + MST.MARGIN + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.WTRADE  + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))';

            ELSIF l_catype = '021' THEN --gc_CA_CATYPE_KIND_STOCK

                    l_qttyexp:= 'FLOOR(((SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.MORTAGE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*' || l_right_exrate || ')/' || l_left_exrate || ')';
                    l_amtexp:= '(' || l_exprice || ' * TRUNC( MOD((SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE  + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*' || l_right_exrate || ' ,' || l_left_exrate || ')/' || l_left_exrate||', '|| l_ciroundtype ||'))';
                       L_ROUND:= ' (CASE WHEN (((SUM(MST.TRADE + MST.MARGIN + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.WTRADE  + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*' || l_right_exrate || ' / ' || l_left_exrate || ')- '
                                || ' TRUNC((SUM(MST.TRADE + MST.MARGIN + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.WTRADE  + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*' || l_right_exrate || ' / ' || l_left_exrate || ', '||L_ROUNDTYPE ||' ))> 0 THEN 1 ELSE 0 END) ';

              ELSIF l_catype = '020' THEN --gc_CA_CATYPE_CONVERT_STOCK
                    l_qttyexp:= 'FLOOR(((SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.MORTAGE + MST.BLOCKED + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.SECURED + MST.REPO + MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*' || l_right_devidentshares || ')/' || l_left_devidentshares || ')';
                    l_aqttyexp:='(SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))';
                    l_amtexp:= '(' || l_exprice || '* TRUNC( MOD((SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*' || l_right_devidentshares || ' ,' || l_left_devidentshares || ')/' || l_left_devidentshares||',' || l_ciroundtype|| '))';
                     L_ROUND:= ' (CASE WHEN (((SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.MORTAGE + MST.BLOCKED + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*' || l_right_devidentshares || ' / ' || l_left_devidentshares || ')- '
                                || ' TRUNC((SUM(MST.TRADE + MST.MARGIN + MST.WTRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*' || l_right_devidentshares || ' / ' || l_left_devidentshares || ', '||L_ROUNDTYPE ||' ))> 0 THEN 1 ELSE 0 END) ';

                    ELSIF l_catype = '022' THEN --gc_CA_CATYPE_CASH_DIVIDEND 'Cash dividend(+QTTY,AMT)
                    l_qttyexp := '(SUM(MST.TRADE + MST.MARGIN + MST.WTRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))';
                    L_ROUND:= ' (CASE WHEN ( MOD((SUM(MST.TRADE + MST.MARGIN + MST.WTRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*' || l_right_devidentshares || ' ,' || l_left_devidentshares || '))> 0 THEN 1 ELSE 0 END) ';

                l_rqttyexp:= 'FLOOR(((SUM(MST.TRADE + MST.MARGIN + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.WTRADE  + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*' || l_right_devidentshares || ')/' || l_left_devidentshares || ')';
                ELSIF l_catype = '012' THEN --gc_CA_CATYPE_STOCK_SPLIT 'Stock Split(+ QTTY,AMT)
                    l_qttyexp:= 'TRUNC((SUM(MST.TRADE + MST.MARGIN + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.WTRADE  + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT)) / (' || l_splitrate || ') - '
                                   || '(SUM(MST.TRADE + MST.MARGIN + MST.WTRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT)), ' || l_roundtype || ')';
                    l_amtexp:= l_exprice || '*((SUM(MST.TRADE + MST.MARGIN + MST.WTRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT)) / (' || l_splitrate || ') - '
                                             || '(SUM(MST.TRADE + MST.MARGIN + MST.WTRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT)) - '
                                             || l_qttyexp || ')';

                ELSIF l_catype = '013' THEN --gc_CA_CATYPE_STOCK_MERGE 'Stock Merge(-AQTTY,+AMT)
                    l_aqttyexp:='((SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.MORTAGE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT)) - '
                                    || 'TRUNC((SUM(MST.TRADE + MST.MARGIN + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.WTRADE  + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT)) / (' || l_splitrate || '), ' || l_roundtype || '))';
                    l_aamtexp:= l_exprice || '*( ' || l_aqttyexp || ' - ((SUM(MST.TRADE + MST.MARGIN + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.WTRADE  + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT)) - '
                                    || '(SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.REPO + MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT)) / (' || l_splitrate || ')))';

                   -- PhuongHT edit
                    l_amtexp:= l_exprice || '*( ' || l_aqttyexp || ' - ((SUM(MST.TRADE + MST.MARGIN + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.WTRADE  + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT)) - '
                                    || '(SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.MORTAGE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT)) / (' || l_splitrate || ')))';

                   -- end of PhuongHT edit
                ELSIF l_catype = '014' THEN --gc_CA_CATYPE_STOCK_RIGHTOFF 'Stock Rightoff(+QTTY,-AAMT)
                    l_qttyexp:='FLOOR(((SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.MORTAGE + MST.BLOCKED + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*' || l_right_rightoffrate ||'*'|| l_right_exrate || ')/(' || l_left_rightoffrate || '*'|| l_left_exrate ||'))';
                    l_aamtexp:= l_exprice || ' * TRUNC( FLOOR((( SUM(MST.TRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MARGIN + MST.WTRADE  + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*' || l_right_rightoffrate ||'*'|| l_right_exrate|| ')/(' || l_left_rightoffrate || '*'|| l_left_exrate ||')), ' || l_roundtype || ')';
                    L_ROUND:= ' (CASE WHEN (((SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*' || l_right_exrate || ' / ' || l_left_exrate || ')- '
                                || ' TRUNC((SUM(MST.TRADE + MST.MARGIN + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.WTRADE  + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*' || l_right_exrate || ' / ' || l_left_exrate ||', '||L_ROUNDTYPE ||' ))> 0 THEN 1 ELSE 0 END) ';
               ELSIF l_catype = '023' THEN -- chuyen doi TP-CP dk nhan tien
                     -- sl CP dc nhan= dk nhan max: PQTTY
                    l_qttyexp:= 'FLOOR(((SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*' || l_right_exrate || ')/' || l_left_exrate || ')';
                    -- sl trai phieu bi cat o tk goc
                    l_aqttyexp:= '(SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.MORTAGE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))';
                    -- sl tien du tinh nhan
                    l_amtexp:= '(' || l_parvalue || '* (1+ ' || l_interestrate||'/100) * (SUM(MST.TRADE + MST.MARGIN + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.WTRADE  + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))) ';
                    -- co lam tron khong
                     L_ROUND:= ' (CASE WHEN (((SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*' || l_right_exrate || ' / ' || l_left_exrate || ')- '
                                || ' TRUNC((SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.MORTAGE + MST.BLOCKED + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*' || l_right_exrate || ' / ' || l_left_exrate || ', '||L_ROUNDTYPE ||' ))> 0 THEN 1 ELSE 0 END) ';

                      -- PhuongHT: ghi nhan rieng phan lai
                      l_intamtexp:='(SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.MORTAGE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*MAX(SYM.PARVALUE)/(100)*' || l_interestrate ;

                ELSIF l_catype = '015' THEN --gc_CA_CATYPE_BOND_PAY_INTEREST 'Bond pay interest, Lai suat theo thang, chu ky theo nam (+AMT)
                    l_amtexp:='(SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.MORTAGE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*MAX(SYM.PARVALUE)/(100)*' || l_interestrate ;
                    l_roundtype := 0;
                     L_ROUND:= ' (CASE WHEN (FLOOR( '|| l_amtexp  || ') ) <> '|| l_amtexp || ' THEN 1 ELSE 0 END)';
                    -- amt=intamt
                    l_intamtexp:='(SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.MORTAGE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*MAX(SYM.PARVALUE)/(100)*' || l_interestrate ;
                ELSIF l_catype = '016' THEN -- gc_CA_CATYPE_BOND_PAY_INTEREST_PRINCIPAL 'Bond pay interest || prin, Lai suat theo thang, chu ky theo nam (+AMT)
                    l_amtexp:='(SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.MORTAGE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*MAX(SYM.PARVALUE) + '
                                    || '(SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*MAX(SYM.PARVALUE)/(100*12)*' || l_interestrate || '*' || l_interestperiod;

                    l_amtexp:='(SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.MORTAGE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*MAX(SYM.PARVALUE) * (1+ ' || l_interestrate || ' /100 ) ';
                     -- PhuongHT: ghi nhan rieng phan lai
                      l_intamtexp:='(SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.MORTAGE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*MAX(SYM.PARVALUE)/(100)*' || l_interestrate ;

                        L_ROUND:= ' (CASE WHEN (FLOOR( '|| l_amtexp  || ') ) <> '|| l_amtexp || ' THEN 1 ELSE 0 END)';
                    l_roundtype:= 0 ;
                ELSIF l_catype = '017' THEN -- gc_CA_CATYPE_CONVERT_BOND_TO_SHARE 'Convert bond to share (+QTTY Share,-AQTTY Bound)
                     l_qttyexp:= 'FLOOR(((SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*' || l_right_exrate || ')/' || l_left_exrate || ')';
                    l_aqttyexp:= '(SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.MORTAGE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))';

                    l_amtexp:= '(' || l_exprice || '* TRUNC( MOD((SUM(MST.TRADE + MST.MARGIN + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.WTRADE  + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*' || l_right_exrate || ' ,' || l_left_exrate || ')/' || l_left_exrate||',' || l_ciroundtype|| '))';
                      L_ROUND:= ' (CASE WHEN (((SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*' || l_right_exrate || ' / ' || l_left_exrate || ')- '
                                || ' TRUNC((SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*' || l_right_exrate || ' / ' || l_left_exrate || ', '||L_ROUNDTYPE ||' ))> 0 THEN 1 ELSE 0 END) ';


                ELSIF l_catype = '018' THEN -- gc_CA_CATYPE_CONVERT_RIGHT_TO_SHARE 'Convert Right to share (+QTTY Share, -AQTTY Right)
                    l_qttyexp:= '(SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))';
                    l_aqttyexp:= '(SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))';
                    l_roundtype:= 0 ;
                ELSIF l_catype = '019' THEN -- gc_CA_CATYPE_CHANGE_TRADING_PLACE_STOCK 'Change trading place (+QTTY )
                    l_qttyexp:= '0';
                    l_amtexp:='0';
                ELSIF  l_catype IN ( '005' , '006','022', '028') THEN
                       l_rqttyexp:= 'FLOOR(((SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*' || l_right_devidentshares || ')/' || l_left_devidentshares || ')';
                 /*Add by TruongLD, them su kien giai the to chuc */
                ELSIF l_catype = '027' THEN --gc_CA_CATYPE_CASH_DIVIDEND 'Cash dividend(+QTTY,AMT)
                    IF(l_TYPERATE= 'R') THEN
                        l_amtexp := '(SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*MAX(SYM.PARVALUE)/100*' || l_devidentrate;
                    ELSE
                        l_amtexp := '(SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*' || l_devidentvalue;
                    END IF;
                    IF l_cancelshare = 'Y' THEN
                       l_aqttyexp := '(SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))';
                    ELSE
                       l_aqttyexp := 0;
                    END IF;
                    l_roundtype :=0;
                    L_ROUND:= ' (CASE WHEN (FLOOR( '|| l_amtexp  || ' ) <> '|| l_amtexp || ' ) THEN 1 ELSE 0 END)';
                --T9/2019 CW_PhaseII
                ELSIF l_catype = '024' THEN --gc_CA_CATYPE_CASH_CW 'Chi tra loi tuc CW bang tien
                      if(l_TYPERATE= 'R') THEN
                    l_amtexp := '(SUM(MST.TRADE + MST.MARGIN + MST.WTRADE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*'||l_exprice||'/100*' || l_devidentrate;
                    ELSE
                      l_amtexp := '(SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.MORTAGE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.BLOCKED + MST.SECURED + MST.REPO + MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW)-SUM(TR.AMOUNT))*' || l_devidentvalue;
                      END IF;
                    --l_roundtype :=0;
                      L_ROUND:= ' (CASE WHEN ('|| l_amtexp || ' - TRUNC( '|| l_amtexp  || ','||l_roundtype||' ) > 0  ) THEN 1 ELSE 0 END)';
                      l_amtexp:= 'TRUNC( '|| l_amtexp  || ','||l_roundtype||' )';
                --End T9/2019 CW_PhaseII

                END IF;

                -- So chung khoan le.
                l_reqttyexp:= '(' || l_qttyexp || ' - TRUNC(' || l_qttyexp || ',' || l_roundtype || '))';
                IF l_catype = '017' OR l_catype = '020' OR l_catype='023' THEN
                    l_reaqttyexp:= '(' || l_aqttyexp || ' - TRUNC(' || l_aqttyexp || ' ,' || 0 || ' ))';
                ELSE
                    l_reaqttyexp:= '(' || l_aqttyexp || ' - TRUNC(' || l_aqttyexp || ' ,' || l_roundtype || ' ))';
                END IF;
                -- So chung khoan da lam tron.
                --26/06/2018 DieuNDA: Tam thoi thay doi rule lam tron(chuyen tu TRUNC --> ROUND) do khai bao quyen dac biet
                l_qttyexp:= 'TRUNC(' || l_qttyexp || ',' || l_roundtype || ')';
                --l_qttyexp:= 'ROUND(' || l_qttyexp || ',' || l_roundtype || ')';
                --End 26/06/2018 DieuNDA
                IF l_catype = '017' OR l_catype = '020' OR l_catype='023' THEN
                    l_aqttyexp:= 'TRUNC(' || l_aqttyexp || ',' || 0 || ')';
                ELSE
                    l_aqttyexp:= 'TRUNC(' || l_aqttyexp || ',' || l_roundtype || ')';
                END IF;
                IF l_catype = '011' AND l_catype = '009' THEN
                    l_amtexp:= 'ROUND(' || l_amtexp || ' + ' || l_reqttyexp || ' * ' || l_exprice || ')';
                ELSIF l_catype='023' THEN
                    l_amtexp:='ROUND(' ||l_amtexp|| ')';
                ELSE
                    l_amtexp:= l_amtexp || ' + ' || l_reqttyexp || ' * ' || l_exprice;
                END IF;
                l_aamtexp:=l_aamtexp || ' + ' || l_reaqttyexp || '*' || l_exprice;

                l_reaqttyexp :=0;
                l_reqttyexp :=0;
                -- dung truong ROUND trong CASHDTEMP de phan biet tieu khoan do co bi chot le khong


                DELETE  FROM   CASCHDTEMP_LIST;

                IF l_catype = '014' THEN
                    l_sql := 'INSERT INTO caschdtemp_list (AUTOID, CAMASTID, AFACCTNO, CODEID, EXCODEID, BALANCE, QTTY, AMT, AQTTY, AAMT, STATUS,REQTTY,REAQTTY,RETAILBAL,PBALANCE, PQTTY,PAAMT,TRADE,ROUND)  '
                              || ' SELECT SEQ_CASCHD.NEXTVAL,DAT.* '
                              || ' FROM(SELECT MAX(CA.CAMASTID) CAMASTID, MST.AFACCTNO, ''' || l_codeid || ''' CODEID, ''' || nvl(l_optcodeid,'''''') || ''' EXCODEID, '
                              || ' 0 BALANCE, 0  QTTY, 0 AMT, 0 AQTTY, 0 AAMT, ''A'' STATUS,' || nvl(l_reqttyexp,'''''') || '  REQTTY,' || nvl(l_reaqttyexp,'''''') || '  REAQTTY '
                              || ' ,TRUNC((SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.MORTAGE +MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW) - SUM(TR.AMOUNT))*'||l_right_exrate||'/'|| l_left_exrate||') RETAILBAL,'
                              || ' TRUNC((SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.MORTAGE +MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW) - SUM(TR.AMOUNT))*'||l_right_exrate||'/'||l_left_exrate||') PBALANCE, '
                              || nvl(l_qttyexp,'''''') || '  PQTTY,  ROUND(' || nvl(l_aamtexp,'''''') || ',0) PAAMT,'
                              || ' TRUNC((SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.MORTAGE +  MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW) - SUM(TR.AMOUNT))) TRADE, '|| l_round ||' ROUND'
                              || ' FROM SBSECURITIES SYM, CAMAST CA, SEMAST MST,  '
                              || ' ( SELECT MST.ACCTNO, NVL(DTL.AMT,0) AMOUNT FROM SEMAST MST LEFT JOIN '
                              || ' (select DTL.ACCTNO, sum(DTL.AMT) amt From '
                              || ' (SELECT TR.ACCTNO, SUM((CASE WHEN TX.TXTYPE=''D'' THEN -TR.NAMT WHEN TX.TXTYPE=''C'' THEN TR.NAMT ELSE 0 END)) AMT  '
                              || ' FROM APPTX TX, SETRAN TR ,TLLOG TL '
                              || ' WHERE TX.APPTYPE=''SE'' AND TRIM(TX.FIELD) IN (''TRADE'',''MARGIN'',''BLOCKWITHDRAW'',''EMKQTTY'',''BLOCKDTOCLOSE'',''WTRADE'',''MORTAGE'',''BLOCKED'',''SECURED'',''REPO'',''RECEIVING'',''DTOCLOSE'',''WITHDRAW'')  '
                              || ' AND TR.TXDATE=TL.TXDATE AND TR.TXNUM=TL.TXNUM AND TX.TXTYPE IN (''C'', ''D'') AND TL.DELTD <> ''Y'' '
                              || ' AND TX.TXCD=TR.TXCD AND TL.BUSDATE > TO_DATE(''' || to_char(l_reportdate,systemnums.c_date_format) || ''', ''DD/MM/RRRR'') GROUP BY TR.ACCTNO  '
                              || ' UNION ALL'
                              || ' SELECT TR.ACCTNO, SUM((CASE WHEN TX.TXTYPE=''D'' THEN -TR.NAMT WHEN TX.TXTYPE=''C'' THEN TR.NAMT ELSE 0 END)) AMT  '
                              || ' FROM APPTX TX, SETRANA TR ,TLLOGALL TL  '
                              || ' WHERE TX.APPTYPE=''SE'' AND TRIM(TX.FIELD) IN (''TRADE'',''MARGIN'',''BLOCKWITHDRAW'',''EMKQTTY'',''BLOCKDTOCLOSE'',''WTRADE'',''MORTAGE'',''BLOCKED'',''SECURED'',''REPO'',''RECEIVING'',''DTOCLOSE'',''WITHDRAW'')  '
                              || ' AND TR.TXDATE=TL.TXDATE AND TR.TXNUM=TL.TXNUM AND TX.TXTYPE IN (''C'', ''D'') AND TL.DELTD <> ''Y'' '
                              || ' AND TX.TXCD=TR.TXCD AND TL.BUSDATE > TO_DATE(''' || to_char(l_reportdate,systemnums.c_date_format) || ''', ''DD/MM/RRRR'') GROUP BY TR.ACCTNO)DTL group by DTL.acctno) DTL ON MST.ACCTNO=DTL.ACCTNO) TR '
                              || ' WHERE MST.CODEID=SYM.CODEID AND  CA.CODEID IN( SYM.CODEID , SYM.REFCODEID) AND ( SYM.CODEID = ''' || l_codeid || ''' OR  SYM.REFCODEID =''' || l_codeid || ''' ) AND MST.ACCTNO = TR.ACCTNO  AND CA.CAMASTID =''' || l_camastid || ''''
                              || ' GROUP BY MST.AFACCTNO) DAT WHERE DAT.PBALANCE>0';

                ELSIF l_catype = '022' THEN
                    l_sql := 'INSERT INTO caschdtemp_list (AUTOID, CAMASTID, AFACCTNO, CODEID, EXCODEID, BALANCE, QTTY, AMT, AQTTY, AAMT, STATUS,REQTTY,REAQTTY,RETAILBAL,TRADE,RQTTY,round)  '
                             || ' SELECT SEQ_CASCHD.NEXTVAL,DAT.* '
                             || ' FROM(SELECT MAX(CA.CAMASTID) CAMASTID, MST.AFACCTNO, ''' || l_codeid || ''' CODEID, MAX(CA.EXCODEID) EXCODEID, '
                             || ' (SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.MORTAGE + MST.BLOCKED +MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW) - SUM(TR.AMOUNT)) BALANCE, '
                             ||  ' 0  QTTY, ROUND(' || nvl(l_amtexp,'''''') || ',0) AMT, 0 AQTTY, ROUND(' || nvl(l_aamtexp,'''''') || ',0) AAMT, ''A'' STATUS,' || nvl(l_reqttyexp,'''''') || '  REQTTY,' || nvl(l_reaqttyexp,'''''') || '  REAQTTY '
                             || ' , 0  RETAILBAL,  '
                              || ' TRUNC((SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.MORTAGE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW) - SUM(TR.AMOUNT))) TRADE, ROUND(' || nvl(l_rqttyexp,'''''') || ',0) RQTTY, '|| l_round ||' ROUND'
                             || ' FROM SBSECURITIES SYM, CAMAST CA, SEMAST MST,  '
                             || ' (SELECT MST.ACCTNO, NVL(DTL.AMT,0) AMOUNT FROM SEMAST MST LEFT JOIN '
                             || ' (select DTL.ACCTNO, sum(DTL.AMT) amt From '
                             || ' (SELECT TR.ACCTNO, SUM((CASE WHEN TX.TXTYPE=''D'' THEN -TR.NAMT WHEN TX.TXTYPE=''C'' THEN TR.NAMT ELSE 0 END)) AMT  '
                             || ' FROM APPTX TX, SETRAN TR ,TLLOG TL '
                             || ' WHERE TX.APPTYPE=''SE'' AND TRIM(TX.FIELD) IN (''TRADE'',''BLOCKWITHDRAW'',''EMKQTTY'',''BLOCKDTOCLOSE'',''MARGIN'',''WTRADE'',''MORTAGE'',''BLOCKED'',''SECURED'',''REPO'',''RECEIVING'',''DTOCLOSE'',''WITHDRAW'')  '
                             || ' AND TR.TXDATE=TL.TXDATE AND TR.TXNUM=TL.TXNUM AND TX.TXTYPE IN (''C'', ''D'') AND TL.DELTD <> ''Y'' '
                             || ' AND TX.TXCD=TR.TXCD AND TL.BUSDATE > TO_DATE(''' || to_char(l_reportdate,systemnums.c_date_format) || ''', ''DD/MM/RRRR'') GROUP BY TR.ACCTNO  '
                             || ' UNION ALL  '
                             || ' SELECT TR.ACCTNO, SUM((CASE WHEN TX.TXTYPE=''D'' THEN -TR.NAMT WHEN TX.TXTYPE=''C'' THEN TR.NAMT ELSE 0 END)) AMT  '
                             || ' FROM APPTX TX, SETRANA TR ,TLLOGALL TL  '
                             || ' WHERE TX.APPTYPE=''SE'' AND TRIM(TX.FIELD) IN (''TRADE'',''BLOCKWITHDRAW'',''EMKQTTY'',''BLOCKDTOCLOSE'',''MARGIN'',''WTRADE'',''MORTAGE'',''BLOCKED'',''SECURED'',''REPO'',''RECEIVING'',''DTOCLOSE'',''WITHDRAW'')  '
                             || ' AND TR.TXDATE=TL.TXDATE AND TR.TXNUM=TL.TXNUM AND TX.TXTYPE IN (''C'', ''D'') AND TL.DELTD <> ''Y'' '
                             || ' AND TX.TXCD=TR.TXCD AND TL.BUSDATE > TO_DATE(''' || to_char(l_reportdate,systemnums.c_date_format) || ''', ''DD/MM/RRRR'') GROUP BY TR.ACCTNO) DTL group by DTL.acctno) DTL ON MST.ACCTNO=DTL.ACCTNO) TR '
                             || ' WHERE  MST.CODEID=SYM.CODEID AND CA.CODEID IN( SYM.CODEID , SYM.REFCODEID) AND ( SYM.CODEID = ''' || l_codeid || ''' OR  SYM.REFCODEID =''' || l_codeid || ''' ) AND MST.ACCTNO = TR.ACCTNO  AND CA.CAMASTID  =''' || l_camastid || ''''
                             || ' GROUP BY MST.AFACCTNO) DAT WHERE DAT.BALANCE>0';
                ELSIF l_catype = '020' THEN
                    l_sql := 'INSERT INTO caschdtemp_list (AUTOID, CAMASTID, AFACCTNO, CODEID, EXCODEID, BALANCE, QTTY, AMT, AQTTY, AAMT, STATUS,REQTTY,REAQTTY,RETAILBAL,TRADE,ROUND)  '
                             || ' SELECT SEQ_CASCHD.NEXTVAL,DAT.* '
                             || ' FROM(SELECT MAX(CA.CAMASTID) CAMASTID, MST.AFACCTNO, ''' || l_codeid || ''' CODEID, MAX(CA.CODEID) EXCODEID, '
                             || ' (SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.MORTAGE +MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW) - SUM(TR.AMOUNT)) BALANCE, '
                             || nvl(l_qttyexp,'''''') || '  QTTY, ROUND(' || nvl(l_amtexp,'''''') || ',0) AMT, ' || nvl(l_aqttyexp,'''''') || ' AQTTY, ROUND(' || nvl(l_aamtexp,'''''') || ',0) AAMT, ''A'' STATUS,' || nvl(l_reqttyexp,'''''') || '  REQTTY,' || nvl(l_reaqttyexp,'''''') || '  REAQTTY '
                             || ' , 0  RETAILBAL,  '
                              || ' TRUNC((SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW) - SUM(TR.AMOUNT))) TRADE, '|| l_round ||' ROUND'
                             || ' FROM SBSECURITIES SYM, CAMAST CA, SEMAST MST,  '
                             || ' (SELECT MST.ACCTNO, NVL(DTL.AMT,0) AMOUNT FROM SEMAST MST LEFT JOIN '
                             || ' (select DTL.ACCTNO, sum(DTL.AMT) amt From '
                             || ' (SELECT TR.ACCTNO, SUM((CASE WHEN TX.TXTYPE=''D'' THEN -TR.NAMT WHEN TX.TXTYPE=''C'' THEN TR.NAMT ELSE 0 END)) AMT  '
                             || ' FROM APPTX TX, SETRAN TR ,TLLOG TL '
                             || ' WHERE TX.APPTYPE=''SE'' AND TRIM(TX.FIELD) IN (''TRADE'',''BLOCKWITHDRAW'',''EMKQTTY'',''BLOCKDTOCLOSE'',''MARGIN'',''WTRADE'',''MORTAGE'',''BLOCKED'',''SECURED'',''REPO'',''RECEIVING'',''DTOCLOSE'',''WITHDRAW'')  '
                             || ' AND TR.TXDATE=TL.TXDATE AND TR.TXNUM=TL.TXNUM AND TX.TXTYPE IN (''C'', ''D'') AND TL.DELTD <> ''Y'' '
                             || ' AND TX.TXCD=TR.TXCD AND TL.BUSDATE > TO_DATE(''' || to_char(l_reportdate,systemnums.c_date_format) || ''', ''DD/MM/RRRR'') GROUP BY TR.ACCTNO  '
                             || ' UNION ALL  '
                             || ' SELECT TR.ACCTNO, SUM((CASE WHEN TX.TXTYPE=''D'' THEN -TR.NAMT WHEN TX.TXTYPE=''C'' THEN TR.NAMT ELSE 0 END)) AMT  '
                             || ' FROM APPTX TX, SETRANA TR ,TLLOGALL TL  '
                             || ' WHERE TX.APPTYPE=''SE'' AND TRIM(TX.FIELD) IN (''TRADE'',''BLOCKWITHDRAW'',''EMKQTTY'',''BLOCKDTOCLOSE'',''MARGIN'',''WTRADE'',''MORTAGE'',''BLOCKED'',''SECURED'',''REPO'',''RECEIVING'',''DTOCLOSE'',''WITHDRAW'')  '
                             || ' AND TR.TXDATE=TL.TXDATE AND TR.TXNUM=TL.TXNUM AND TX.TXTYPE IN (''C'', ''D'') AND TL.DELTD <> ''Y'' '
                             || ' AND TX.TXCD=TR.TXCD AND TL.BUSDATE > TO_DATE(''' || to_char(l_reportdate,systemnums.c_date_format) || ''', ''DD/MM/RRRR'') GROUP BY TR.ACCTNO) DTL group by DTL.acctno) DTL ON MST.ACCTNO=DTL.ACCTNO) TR '
                             || ' WHERE  MST.CODEID=SYM.CODEID AND CA.CODEID IN( SYM.CODEID , SYM.REFCODEID) AND ( SYM.CODEID = ''' || l_codeid || ''' OR  SYM.REFCODEID =''' || l_codeid || ''' ) AND MST.ACCTNO = TR.ACCTNO  AND CA.CAMASTID  =''' || l_camastid || ''''
                             || ' GROUP BY MST.AFACCTNO) DAT WHERE DAT.BALANCE>0';
                ELSIF l_catype = '017' THEN
                    l_sql := 'INSERT INTO caschdtemp_list (AUTOID, CAMASTID, AFACCTNO, CODEID, EXCODEID, BALANCE, QTTY, AMT, AQTTY, AAMT, STATUS,REQTTY,REAQTTY,RETAILBAL,TRADE,ROUND)  '
                             || ' SELECT SEQ_CASCHD.NEXTVAL,DAT.* '
                             || ' FROM(SELECT MAX(CA.CAMASTID) CAMASTID, MST.AFACCTNO, ''' || l_codeid || ''' CODEID, MAX(CA.CODEID) EXCODEID, '
                             || ' (SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.MORTAGE + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW) - SUM(TR.AMOUNT)) BALANCE, '
                             || nvl(l_qttyexp,'''''') || '  QTTY, ROUND(' || nvl(l_amtexp,'''''') || ',0) AMT, ' || nvl(l_aqttyexp,'''''') || ' AQTTY, ROUND(' || nvl(l_aamtexp,'''''') || ',0) AAMT, ''A'' STATUS,' || nvl(l_reqttyexp,'''''') || '  REQTTY,' || nvl(l_reaqttyexp,'''''') || '  REAQTTY '
                             || ' , 0  RETAILBAL , '
                              || ' TRUNC((SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  +MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW) - SUM(TR.AMOUNT))) TRADE, '|| l_round ||' ROUND'
                             || ' FROM SBSECURITIES SYM, CAMAST CA, SEMAST MST,  '
                             || ' (SELECT MST.ACCTNO, NVL(DTL.AMT,0) AMOUNT FROM SEMAST MST LEFT JOIN '
                             || ' (select DTL.ACCTNO, sum(DTL.AMT) amt From '
                             || ' (SELECT TR.ACCTNO, SUM((CASE WHEN TX.TXTYPE=''D'' THEN -TR.NAMT WHEN TX.TXTYPE=''C'' THEN TR.NAMT ELSE 0 END)) AMT  '
                             || ' FROM APPTX TX, SETRAN TR ,TLLOG TL '
                             || ' WHERE TX.APPTYPE=''SE'' AND TRIM(TX.FIELD) IN (''TRADE'',''MARGIN'',''WTRADE'',''BLOCKWITHDRAW'',''EMKQTTY'',''BLOCKDTOCLOSE'',''MORTAGE'',''BLOCKED'',''SECURED'',''REPO'',''RECEIVING'',''DTOCLOSE'',''WITHDRAW'')  '
                             || ' AND TR.TXDATE=TL.TXDATE AND TR.TXNUM=TL.TXNUM AND TX.TXTYPE IN (''C'', ''D'') AND TL.DELTD <> ''Y'' '
                             || ' AND TX.TXCD=TR.TXCD AND TL.BUSDATE > TO_DATE(''' || to_char(l_reportdate,systemnums.c_date_format) || ''', ''DD/MM/RRRR'') GROUP BY TR.ACCTNO  '
                             || ' UNION ALL  '
                             || ' SELECT TR.ACCTNO, SUM((CASE WHEN TX.TXTYPE=''D'' THEN -TR.NAMT WHEN TX.TXTYPE=''C'' THEN TR.NAMT ELSE 0 END)) AMT  '
                             || ' FROM APPTX TX, SETRANA TR ,TLLOGALL TL  '
                             || ' WHERE TX.APPTYPE=''SE'' AND TRIM(TX.FIELD) IN (''TRADE'',''MARGIN'',''WTRADE'',''BLOCKWITHDRAW'',''EMKQTTY'',''BLOCKDTOCLOSE'',''MORTAGE'',''BLOCKED'',''SECURED'',''REPO'',''RECEIVING'',''DTOCLOSE'',''WITHDRAW'')  '
                             || ' AND TR.TXDATE=TL.TXDATE AND TR.TXNUM=TL.TXNUM AND TX.TXTYPE IN (''C'', ''D'') AND TL.DELTD <> ''Y'' '
                             || ' AND TX.TXCD=TR.TXCD AND TL.BUSDATE > TO_DATE(''' || to_char(l_reportdate,systemnums.c_date_format) || ''', ''DD/MM/RRRR'') GROUP BY TR.ACCTNO) DTL group by DTL.acctno) DTL ON MST.ACCTNO=DTL.ACCTNO) TR '
                             || ' WHERE  MST.CODEID=SYM.CODEID AND  CA.CODEID IN( SYM.CODEID , SYM.REFCODEID) AND ( SYM.CODEID = ''' || l_codeid || ''' OR  SYM.REFCODEID =''' || l_codeid || ''' ) AND MST.ACCTNO = TR.ACCTNO  AND CA.CAMASTID  =''' || l_camastid || ''''
                             || ' GROUP BY MST.AFACCTNO) DAT WHERE DAT.BALANCE>0';
                  ELSIF l_catype = '023' THEN
                    l_sql := 'INSERT INTO caschdtemp_list (AUTOID, CAMASTID, AFACCTNO, CODEID, EXCODEID, BALANCE, QTTY, AMT, AQTTY, AAMT, STATUS,REQTTY,REAQTTY,RETAILBAL,TRADE,ROUND,PQTTY,INTAMT)  '
                             || ' SELECT SEQ_CASCHD.NEXTVAL,DAT.* '
                             || ' FROM(SELECT MAX(CA.CAMASTID) CAMASTID, MST.AFACCTNO, ''' || l_codeid || ''' CODEID, MAX(CA.CODEID) EXCODEID, '
                             || ' (SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.MORTAGE + MST.BLOCKED +MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW) - SUM(TR.AMOUNT)) BALANCE,
                              0  QTTY, ROUND(' || nvl(l_amtexp,'''''') || ',0) AMT, ' || nvl(l_aqttyexp,'''''') || ' AQTTY, ROUND(' || nvl(l_aamtexp,'''''') || ',0) AAMT, ''A'' STATUS,' || nvl(l_reqttyexp,'''''') || '  REQTTY,' || nvl(l_reaqttyexp,'''''') || '  REAQTTY '
                             || ' , 0  RETAILBAL , '
                             || ' TRUNC((SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW) - SUM(TR.AMOUNT))) TRADE, '|| l_round ||' ROUND, ' || nvl(l_qttyexp,'''''') || ' PQTTY , '
                             || ' ROUND(' || nvl(l_intamtexp,'''''') || ',0) INTAMT '
                             || ' FROM SBSECURITIES SYM, CAMAST CA, SEMAST MST,  '
                             || ' (SELECT MST.ACCTNO, NVL(DTL.AMT,0) AMOUNT FROM SEMAST MST LEFT JOIN '
                             || ' (select DTL.ACCTNO, sum(DTL.AMT) amt From '
                             || ' (SELECT TR.ACCTNO, SUM((CASE WHEN TX.TXTYPE=''D'' THEN -TR.NAMT WHEN TX.TXTYPE=''C'' THEN TR.NAMT ELSE 0 END)) AMT  '
                             || ' FROM APPTX TX, SETRAN TR ,TLLOG TL '
                             || ' WHERE TX.APPTYPE=''SE'' AND TRIM(TX.FIELD) IN (''TRADE'',''MARGIN'',''WTRADE'',''MORTAGE'',''BLOCKWITHDRAW'',''EMKQTTY'',''BLOCKDTOCLOSE'',''BLOCKED'',''SECURED'',''REPO'',''RECEIVING'',''DTOCLOSE'',''WITHDRAW'')  '
                             || ' AND TR.TXDATE=TL.TXDATE AND TR.TXNUM=TL.TXNUM AND TX.TXTYPE IN (''C'', ''D'') AND TL.DELTD <> ''Y'' '
                             || ' AND TX.TXCD=TR.TXCD AND TL.BUSDATE > TO_DATE(''' || to_char(l_reportdate,systemnums.c_date_format) || ''', ''DD/MM/RRRR'') GROUP BY TR.ACCTNO  '
                             || ' UNION ALL  '
                             || ' SELECT TR.ACCTNO, SUM((CASE WHEN TX.TXTYPE=''D'' THEN -TR.NAMT WHEN TX.TXTYPE=''C'' THEN TR.NAMT ELSE 0 END)) AMT  '
                             || ' FROM APPTX TX, SETRANA TR ,TLLOGALL TL  '
                             || ' WHERE TX.APPTYPE=''SE'' AND TRIM(TX.FIELD) IN (''TRADE'',''MARGIN'',''BLOCKWITHDRAW'',''EMKQTTY'',''BLOCKDTOCLOSE'',''WTRADE'',''MORTAGE'',''BLOCKED'',''SECURED'',''REPO'',''RECEIVING'',''DTOCLOSE'',''WITHDRAW'')  '
                             || ' AND TR.TXDATE=TL.TXDATE AND TR.TXNUM=TL.TXNUM AND TX.TXTYPE IN (''C'', ''D'') AND TL.DELTD <> ''Y'' '
                             || ' AND TX.TXCD=TR.TXCD AND TL.BUSDATE > TO_DATE(''' || to_char(l_reportdate,systemnums.c_date_format) || ''', ''DD/MM/RRRR'') GROUP BY TR.ACCTNO) DTL group by DTL.acctno) DTL ON MST.ACCTNO=DTL.ACCTNO) TR '
                             || ' WHERE  MST.CODEID=SYM.CODEID AND  CA.CODEID IN( SYM.CODEID , SYM.REFCODEID) AND ( SYM.CODEID = ''' || l_codeid || ''' OR  SYM.REFCODEID =''' || l_codeid || ''' ) AND MST.ACCTNO = TR.ACCTNO  AND CA.CAMASTID  =''' || l_camastid || ''''
                             || ' GROUP BY MST.AFACCTNO) DAT WHERE DAT.BALANCE>0';

                ELSE
                    l_sql := 'INSERT INTO caschdtemp_list (AUTOID, CAMASTID, AFACCTNO, CODEID, EXCODEID, BALANCE, QTTY, AMT, AQTTY, AAMT, STATUS,REQTTY,REAQTTY,RETAILBAL,TRADE,INTAMT,RQTTY,ROUND)  '
                             || ' SELECT SEQ_CASCHD.NEXTVAL,DAT.* '
                             || ' FROM(SELECT MAX(CA.CAMASTID) CAMASTID, MST.AFACCTNO,''' || l_codeid || ''' CODEID, MAX(CA.EXCODEID) EXCODEID, '
                             || ' (SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.MORTAGE + MST.BLOCKED + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW) - SUM(TR.AMOUNT)) BALANCE, '
                             || nvl(l_qttyexp,'''''') || '  QTTY, ROUND(' || nvl(l_amtexp,'''''') || ',0) AMT, ' || nvl(l_aqttyexp,'''''') || ' AQTTY, ROUND(' || nvl(l_aamtexp,'''''') || ',0) AAMT, ''A'' STATUS,' || nvl(l_reqttyexp,'''''') || '  REQTTY,' || nvl(l_reaqttyexp,'''''') || '  REAQTTY '
                             || ' , 0  RETAILBAL,  '
                              || ' TRUNC((SUM(MST.TRADE + MST.MARGIN + MST.WTRADE  + MST.MORTAGE + MST.BLOCKED + MST.SECURED +MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW) - SUM(TR.AMOUNT))) TRADE, ROUND(' || nvl(l_intamtexp,'''''') || ',0) INTAMT, ROUND(' || nvl(l_rqttyexp,'''''') || ',0) RQTTY, '|| l_round ||' ROUND'
                             || ' FROM SBSECURITIES SYM, CAMAST CA, SEMAST MST,  '
                             || ' (SELECT MST.ACCTNO, NVL(DTL.AMT,0) AMOUNT FROM SEMAST MST LEFT JOIN '
                             || ' (select DTL.ACCTNO, sum(DTL.AMT) amt From '
                             || ' (SELECT TR.ACCTNO, SUM((CASE WHEN TX.TXTYPE=''D'' THEN -TR.NAMT WHEN TX.TXTYPE=''C'' THEN TR.NAMT ELSE 0 END)) AMT  '
                             || ' FROM APPTX TX, SETRAN TR ,TLLOG TL '
                             || ' WHERE TX.APPTYPE=''SE'' AND TRIM(TX.FIELD) IN (''TRADE'',''MARGIN'',''BLOCKWITHDRAW'',''EMKQTTY'',''BLOCKDTOCLOSE'',''WTRADE'',''MORTAGE'',''BLOCKED'',''SECURED'',''REPO'',''RECEIVING'',''DTOCLOSE'',''WITHDRAW'')  '
                             || ' AND TR.TXDATE=TL.TXDATE AND TR.TXNUM=TL.TXNUM AND TX.TXTYPE IN (''C'', ''D'') AND TL.DELTD <> ''Y'' '
                             || ' AND TX.TXCD=TR.TXCD AND TL.BUSDATE > TO_DATE(''' || to_char(l_reportdate,systemnums.c_date_format) || ''', ''DD/MM/RRRR'') GROUP BY TR.ACCTNO  '
                             || ' UNION ALL  '
                             || ' SELECT TR.ACCTNO, SUM((CASE WHEN TX.TXTYPE=''D'' THEN -TR.NAMT WHEN TX.TXTYPE=''C'' THEN TR.NAMT ELSE 0 END)) AMT  '
                             || ' FROM APPTX TX, SETRANA TR ,TLLOGALL TL  '
                             || ' WHERE TX.APPTYPE=''SE'' AND TRIM(TX.FIELD) IN (''TRADE'',''MARGIN'',''BLOCKWITHDRAW'',''EMKQTTY'',''BLOCKDTOCLOSE'',''WTRADE'',''MORTAGE'',''BLOCKED'',''SECURED'',''REPO'',''RECEIVING'',''DTOCLOSE'',''WITHDRAW'')  '
                             || ' AND TR.TXDATE=TL.TXDATE AND TR.TXNUM=TL.TXNUM AND TX.TXTYPE IN (''C'', ''D'') AND TL.DELTD <> ''Y'' '
                             || ' AND TX.TXCD=TR.TXCD AND TL.BUSDATE > TO_DATE(''' || to_char(l_reportdate,systemnums.c_date_format) || ''', ''DD/MM/RRRR'') GROUP BY TR.ACCTNO) DTL group by DTL.acctno) DTL ON MST.ACCTNO=DTL.ACCTNO) TR '
                             || ' WHERE  MST.CODEID=SYM.CODEID AND  CA.CODEID IN( SYM.CODEID , SYM.REFCODEID) AND ( SYM.CODEID = ''' || l_codeid || ''' OR  SYM.REFCODEID =''' || l_codeid || ''' ) AND MST.ACCTNO = TR.ACCTNO  AND CA.CAMASTID  =''' || l_camastid || ''''
                             || ' GROUP BY MST.AFACCTNO) DAT WHERE DAT.BALANCE>0';
                END IF;
                --Tao du lieu cho caschd
                
                
                
                EXECUTE IMMEDIATE l_sql;
                pr_error ('Gianhvg 3312ex','Insert vao caschdtemp');
                --Insert nhung khach hang co mot tieu khoan
      FOR rec_list IN (
                select tmp.AUTOID, tmp.CAMASTID, tmp.AFACCTNO, tmp.CODEID, tmp.EXCODEID, tmp.BALANCE, tmp.QTTY, tmp.AMT,
                       tmp.AQTTY, tmp.AAMT, tmp.STATUS,tmp.REQTTY,tmp.REAQTTY,tmp.RETAILBAL,tmp.TRADE,tmp.PBALANCE,
                       tmp.PQTTY,tmp.PAAMT,tmp.INTAMT,tmp.RQTTY
                from caschdtemp_list tmp,
                    (select cf.custid, max(af.acctno) afacctno from afmast af, cfmast cf
                        where af.custid = cf.custid
                            AND cf.custatcom='Y'
                            AND cf.status <> 'C'
                        group by cf.custid
                        having count(af.acctno)<=1
                    ) af
                where tmp.afacctno = af.afacctno
                AND tmp.camastid=l_camastid
    )loop
    update caschd_list set BALANCE=rec_list.BALANCE,
     CODEID=rec_list.CODEID,
     EXCODEID=rec_list.EXCODEID,
     AFACCTNO=rec_list.AFACCTNO,
     QTTY= rec_list.QTTY,
     AMT= rec_list.AMT,
     AQTTY=rec_list.AQTTY,
     AAMT=rec_list.AAMT,
     STATUS='A',
     REQTTY=rec_list.REQTTY,
     REAQTTY=rec_list.REAQTTY,
     RETAILBAL=rec_list.RETAILBAL,
     TRADE=rec_list.TRADE,
     PBALANCE=rec_list.PBALANCE,
     PQTTY=rec_list.PQTTY,
     PAAMT=rec_list.PAAMT,
     INTAMT=rec_list.INTAMT,
     RQTTY=rec_list.RQTTY
    where camastid=l_camastid ;
    end loop;
--sau khi s?a xong update l?i tr?ng th?l?

  --T07/2017 STP
                --insert log de phan biet ck thuong va ck hccn
                if l_catype = '014' then
                    insert into CASCHD_LOG(AUTOID,CAMASTID,CODEID,AFACCTNO,TRADE,PTRADE,BLOCKED,PBLOCKED)
                    SELECT seq_caschd_log.nextval , MST.*
                    FROM (
                        SELECT  DAT.CAMASTID, DAT.CODEID,/*AF1.AFACCTNO,*/ AF.ACCTNO AFACCTNO,
                            trunc(SUM(DAT.TRADEQTTY*l_right_exrate/ l_left_exrate)) TRADE,
                            trunc(SUM(DAT.TRADEQTTY*l_right_rightoffrate / l_left_rightoffrate)) PTRADE,
                            trunc(SUM(DAT.BLOCKEDQTTY+DAT.TRADEQTTY)*l_right_exrate/ l_left_exrate-trunc(SUM(DAT.TRADEQTTY)*l_right_exrate/ l_left_exrate) ) BLOCKED,
                            trunc(SUM(DAT.BLOCKEDQTTY+DAT.TRADEQTTY)*l_right_rightoffrate / l_left_rightoffrate -trunc(SUM(DAT.TRADEQTTY)*l_right_rightoffrate / l_left_rightoffrate,l_roundtype) ,l_roundtype) PBLOCKED
                         FROM(
                             SELECT CA.CAMASTID CAMASTID,L_CODEID CODEID, MST.AFACCTNO,
                             --TRUNC((SUM(MST.TRADE + MST.MARGIN + MST.EMKQTTY + MST.WTRADE  + MST.MORTAGE + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW) - SUM(TR.NTRADE))*(l_right_exrate/ l_left_exrate)) TRADE,
                             --TRUNC((SUM(MST.TRADE + MST.MARGIN + MST.EMKQTTY + MST.WTRADE  + MST.MORTAGE + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW) - SUM(TR.NTRADE))*(l_right_rightoffrate / l_left_rightoffrate)) PTRADE,

                             --TRUNC((SUM(MST.BLOCKED + BLOCKWITHDRAW + BLOCKDTOCLOSE) - SUM(TR.NBLOCKED))*(l_right_exrate/ l_left_exrate)) BLOCKED,
                             --TRUNC((SUM(MST.BLOCKED + BLOCKWITHDRAW + BLOCKDTOCLOSE) - SUM(TR.NBLOCKED))*(l_right_rightoffrate / l_left_rightoffrate)) PBLOCKED
                             SUM(MST.TRADE + MST.MARGIN + MST.EMKQTTY + MST.WTRADE  + MST.MORTAGE + MST.SECURED + MST.REPO+ MST.RECEIVING+ MST.DTOCLOSE+MST.WITHDRAW) - SUM(TR.NTRADE) TRADEQTTY,
                             SUM(MST.BLOCKED + BLOCKWITHDRAW + BLOCKDTOCLOSE) - SUM(TR.NBLOCKED) BLOCKEDQTTY

                             FROM SBSECURITIES SYM, CAMAST CA, SEMAST MST,
                             (
                                 SELECT MST.ACCTNO, NVL(DTL.AMT,0) NTRADE , NVL(DTL.BLO,0) NBLOCKED
                                 FROM SEMAST MST LEFT JOIN
                                 (
                                     SELECT DTL.ACCTNO, SUM(DTL.AMT) AMT, SUM(DTL.BLO) BLO FROM
                                     (
                                         SELECT A1.ACCTNO,A1.AMT,A1.BLO FROM
                                         (
                                             SELECT TR.ACCTNO,
                                             SUM((CASE WHEN TRIM(TX.FIELD) IN ('TRADE','MARGIN','EMKQTTY','WTRADE','MORTAGE','SECURED','REPO','RECEIVING','DTOCLOSE','WITHDRAW')
                                                    THEN DECODE(TX.TXTYPE,'D',-TR.NAMT,'C',TR.NAMT)
                                                    ELSE 0 END)) AMT,
                                             SUM((CASE WHEN TRIM(TX.FIELD) IN ('BLOCKED','BLOCKWITHDRAW','BLOCKDTOCLOSE')
                                                    THEN DECODE(TX.TXTYPE,'D',-TR.NAMT,'C',TR.NAMT)
                                                    ELSE 0 END)) BLO
                                             FROM APPTX TX, SETRAN TR ,VW_TLLOG_ALL TL
                                             WHERE TX.APPTYPE='SE' AND TRIM(TX.FIELD) IN ('TRADE','MARGIN','WTRADE','MORTAGE','SECURED','REPO','RECEIVING','DTOCLOSE','WITHDRAW','BLOCKED')
                                             AND TR.TXDATE=TL.TXDATE AND TR.TXNUM=TL.TXNUM AND TX.TXTYPE IN ('C', 'D') AND TL.DELTD <> 'Y'
                                             AND TX.TXCD=TR.TXCD AND TL.BUSDATE > TO_DATE(L_REPORTDATE,SYSTEMNUMS.C_DATE_FORMAT)
                                             GROUP BY TR.ACCTNO
                                         )A1
                                     )DTL GROUP BY DTL.ACCTNO
                                 ) DTL ON MST.ACCTNO=DTL.ACCTNO
                             ) TR
                             WHERE MST.CODEID=SYM.CODEID
                             AND CA.CODEID IN( SYM.CODEID,SYM.REFCODEID)
                             AND ( SYM.CODEID = L_CODEID OR  SYM.REFCODEID = L_CODEID )
                             AND MST.ACCTNO = TR.ACCTNO  AND CA.CAMASTID = l_camastid
                             GROUP BY CA.CAMASTID, MST.AFACCTNO
                         ) DAT, AFMAST AF --,
                         --(SELECT MAX(ACCTNO) AFACCTNO, CUSTID FROM   AFMAST  AF,AFTYPE AFT, MRTYPE MR WHERE AF.ACTYPE = AFT.ACTYPE AND AFT.MRTYPE = MR.ACTYPE AND MR.MRTYPE ='N' AND CUSTID <>'0001540677' GROUP BY CUSTID) AF1
                          WHERE DAT.TRADEQTTY + DAT.BLOCKEDQTTY > 0
                          AND DAT.AFACCTNO = AF.ACCTNO
                          --AND AF.CUSTID = AF1.CUSTID
                          GROUP BY DAT.CAMASTID, DAT.CODEID, /*AF1.AFACCTNO,*/ AF.ACCTNO
                      ) MST;
                end if;
                --end ADD VuTN
                --End T07/2017 STP


                plog.debug (pkgctx,'after insert caschdtemp: ' );
                -- Tinh ra CK tong theo so luu ky
                FOR rec_trade IN (
                   select mst.* from
                        (SELECT sum(dat.trade) tradesum, af.custid ,MAX(DAT.PARVALUE) PARVALUE
                       FROM   (SELECT SUM(MST.TRADE + MST.MARGIN + MST.WTRADE + MST.MORTAGE +
                                MST.BLOCKWITHDRAW + MST.EMKQTTY + MST.BLOCKDTOCLOSE +
                                  MST.BLOCKED + MST.SECURED + MST.REPO + MST.RECEIVING +
                                  MST.DTOCLOSE + MST.WITHDRAW) - SUM(TR.AMOUNT) trade,
                                  mst.afacctno,MAX(sym.parvalue) parvalue
                                  FROM semast mst,  camast ca,sbsecurities sym,
                                  (SELECT MST.ACCTNO, NVL(DTL.AMT, 0) AMOUNT
                                FROM SEMAST MST
                                LEFT JOIN (SELECT DTL.ACCTNO, SUM(DTL.AMT) amt
                                            FROM (SELECT TR.ACCTNO,
                                                          SUM((CASE
                                                                WHEN TX.TXTYPE = 'D' THEN
                                                                 -TR.NAMT
                                                                WHEN TX.TXTYPE = 'C' THEN
                                                                 TR.NAMT
                                                                ELSE
                                                                 0
                                                              END)) AMT
                                                     FROM APPTX TX, SETRAN TR, TLLOG TL
                                                    WHERE TX.APPTYPE = 'SE'
                                                      AND TRIM(TX.FIELD) IN
                                                          ('TRADE',
                                                           'MARGIN',
                                                           'WTRADE',
                                                           'MORTAGE',
                                                           'BLOCKED',
                                                           'SECURED',
                                                           'REPO',
                                                           'RECEIVING',
                                                           'DTOCLOSE',
                                                           'BLOCKWITHDRAW',
                                                           'EMKQTTY',
                                                           'BLOCKDTOCLOSE',
                                                           'WITHDRAW')
                                                      AND TR.TXDATE = TL.TXDATE
                                                      AND TR.TXNUM = TL.TXNUM
                                                      AND TX.TXTYPE IN ('C', 'D')
                                                      AND TL.DELTD <> 'Y'
                                                      AND TX.TXCD = TR.TXCD
                                                      AND TL.BUSDATE >
                                                         TO_DATE(l_reportdate,systemnums.c_date_format)
                                                    GROUP BY TR.ACCTNO
                                                   UNION ALL
                                                   SELECT TR.ACCTNO,
                                                          SUM((CASE
                                                                WHEN TX.TXTYPE = 'D' THEN
                                                                 -TR.NAMT
                                                                WHEN TX.TXTYPE = 'C' THEN
                                                                 TR.NAMT
                                                                ELSE
                                                                 0
                                                              END)) AMT
                                                     FROM APPTX TX, SETRANA TR, TLLOGALL TL
                                                    WHERE TX.APPTYPE = 'SE'
                                                      AND TRIM(TX.FIELD) IN
                                                          ('TRADE',
                                                           'MARGIN',
                                                           'WTRADE',
                                                           'MORTAGE',
                                                           'BLOCKED',
                                                           'SECURED',
                                                           'REPO',
                                                           'RECEIVING',
                                                           'DTOCLOSE',
                                                           'BLOCKWITHDRAW',
                                                           'EMKQTTY',
                                                           'BLOCKDTOCLOSE',
                                                           'WITHDRAW')
                                                      AND TR.TXDATE = TL.TXDATE
                                                      AND TR.TXNUM = TL.TXNUM
                                                      AND TX.TXTYPE IN ('C', 'D')
                                                      AND TL.DELTD <> 'Y'
                                                      AND TX.TXCD = TR.TXCD
                                                      AND TL.BUSDATE >
                                                          TO_DATE(l_reportdate,systemnums.c_date_format)
                                                    GROUP BY TR.ACCTNO) DTL
                                           GROUP BY DTL.acctno) DTL
                                  ON MST.ACCTNO = DTL.ACCTNO) TR
                                      WHERE MST.CODEID = SYM.CODEID
                                              AND CA.CODEID IN (SYM.CODEID, SYM.REFCODEID)
                                              AND (SYM.CODEID = l_codeid OR SYM.REFCODEID = l_codeid)
                                              AND MST.ACCTNO = TR.ACCTNO
                                              AND CA.CAMASTID = l_camastid
                                            GROUP BY MST.AFACCTNO) DAT, afmast af,cfmast cf
                                            WHERE dat.afacctno=af.acctno
                                             AND dat.trade>0
                                             AND af.custid=cf.custid
                                             AND cf.custatcom='Y'
                                             AND cf.status <> 'C'
                                            GROUP BY af.custid
                       ) mst,
                       (select cf.custid from afmast af, cfmast cf
                            where af.custid = cf.custid
                            group by cf.custid
                            having count(af.acctno)>1
                        ) cf
                       where mst.custid = cf.custid
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
                                          if(l_TYPERATE= 'R') THEN
                                        l_dbl_amtexp :=trunc( l_tradeSumByCustCD * l_parvalue /100* to_number(l_devidentrate),0);
                                        ELSE
                                          l_dbl_amtexp := trunc( l_tradeSumByCustCD*to_number(l_devidentvalue),0);
                                          END IF;
                                        l_roundtype :=0;
                                    ELSIF l_catype = '024' THEN --gc_CA_CATYPE_PAYING_INTERREST_BOND
                                        l_dbl_amtexp := trunc(l_tradeSumByCustCD * l_parvalue /100 *  to_number(l_devidentrate),0);
                                        l_roundtype := 0;
                                    ELSIF l_catype = '011' THEN --gc_CA_CATYPE_STOCK_DIVIDEND 'Stock dividend (+QTTY,AMT)
                                   -- plog.debug (pkgctx,'in case 011.2.1: '||  rec_trade.custid );

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
                                          l_dbl_intamtexp:= round(l_tradeSumByCustCD * l_parvalue /100 *  to_number(l_interestrate),0) ;

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

                                 
                              SELECT COUNT(*) INTO l_count_temp FROM CASCHDTEMP_LIST,afmast af
                                               WHERE CASCHDTEMP_LIST.camastid = l_camastid and CASCHDTEMP_LIST.afacctno=af.acctno
                                               and af.custid=rec_trade.custid ;

                                  -- dua vao du lieu trong bang caschdtemp de phan bo  co tuc  theo thu tu uu tien cho Kh,
                                  -- bot lai tieu khoan  cuoi cung
                                  
                                  if(l_count_temp>0  )    THEN
                                        INSERT INTO CASCHD_LIST (AUTOID, CAMASTID, AFACCTNO, CODEID, EXCODEID, BALANCE, QTTY, AMT, AQTTY, AAMT, STATUS,REQTTY,REAQTTY,RETAILBAL,TRADE,PBALANCE,PQTTY,PAAMT,INTAMT,RQTTY,ORGPBALANCE)
                                      select * from  ( SELECT autoid,camastid,temp.afacctno afacctno,codeid,excodeid,balance,
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
                                                  FROM CASCHDTEMP_LIST temp, afmast af
                                                  WHERE temp.afacctno=af.acctno AND af.custid =rec_trade.custid
                                                  AND temp.camastid=l_camastid

                                                  ORDER BY round,trade,afacctno) where ROWNUM < l_count_temp;
                                             
                                                  -- KH cuoi cung: insert gia tri con lai

                                                  INSERT INTO CASCHD_LIST (AUTOID, CAMASTID, AFACCTNO, CODEID, EXCODEID, BALANCE, QTTY, AMT, AQTTY, AAMT, STATUS,REQTTY,REAQTTY,RETAILBAL,TRADE,PBALANCE,PQTTY,PAAMT,INTAMT,RQTTY,ORGPBALANCE)
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
                                                  FROM (select * from (SELECT temp.* FROM CASCHDTEMP_LIST temp,afmast
                                                        WHERE temp.afacctno=afmast.acctno AND afmast.custid=rec_trade.custid
                                                        ORDER BY round desc,trade desc,afacctno  desc) where  rownum=1 ) temp,
                                                        (SELECT SUM(QTTY) QTTY, SUM(amt) amt,SUM(AQTTY) AQTTY,SUM(AAMT) AAMT,
                                                                SUM(RETAILBAL) RETAILBAL,SUM(PBALANCE) PBALANCE, SUM(PQTTY) PQTTY,
                                                                SUM(PAAMT) PAAMT,SUM(INTAMT) INTAMT, SUM(RQTTY) RQTTY, camastid
                                                        FROM CASCHD_LIST, afmast
                                                        WHERE camastid=l_camastid AND afmast.acctno=CASCHD_LIST.afacctno
                                                        AND afmast.custid=rec_trade.custid AND DELTD='N'
                                                        GROUP BY camastid ) schdsum
                                                 WHERE      temp.camastid= schdsum.camastid(+);

                                  END IF ;

                            END IF; -- end of tradesumbycustcd >0
                  END LOOP;

                pr_error ('Gianhvg 3312ex','Phan bo xong tu CASCHDTEMP_LIST vao caschd');


            END LOOP;
        END IF;

    for rec in(
        select cf.custid, cf.custodycd, ca.afacctno, ca.actiondate, ca.camastid, ca.codeid, ca.tmpl, cf.fullname, cf.email, sb.symbol, iss.fullname symname,iss.en_fullname en_symname,
            a3.cdcontent tradeplace, se.trade,ca.qtty,cf.cifid,ca.catype,ca.rate, ca.devidentshares,ca.frdatetransfer,ca.advdesc,ca.canceldate,ca.description,
            nvl(a1.cdcontent,'') FRTRADEPLACE, nvl(a2.cdcontent,'') TOTRADEPLACE,ca.exprice,ca.optsymbol,ca.caisincode,ca.debitdate,ca.meetingplace, --chuyen san
            nvl(a4.symbol,'') symbol2, nvl(a4.fullname,'') symname2, nvl(a4.en_fullname,'') en_symname2, nvl(a4.tradeplace,'') TRADEPLACE2, ca.EXRATE, --chuyen doi CP thanh CP
            a4.isincode, ltrim(to_char(sb.parvalue, '9,999,999,999,999')) parvalue, iss.officename, iss.en_officename, iss.address, iss.en_address, iss.phone,
            iss.fax, a5.cdcontent sectype, a5.en_cdcontent en_sectype, ca.duedate, ca.reportdate, ca.devidentvalue,ca.transfertimes, ca.insdeadline ,ca.balance--Giai the to chuc phat hanh
            ,a6.en_cdcontent encdcontent, ca.deltd    --thangpv SHBVNEX-2672
        from
            (--chi gui cho moi gioi
                select af.custid,sch.afacctno,ca.actiondate,ca.camastid,sch.qtty+decode(ca.catype,'027',sch.aqtty,0) qtty,sch.codeid,
                        case when ca.catype='019' and ca.totradeplace not in ('009','003') then '116E'
                          when ca.catype='027' and (DEVIDENTRATE+DEVIDENTVALUE = 0) then '117E'
                          when ca.catype='027' and (DEVIDENTRATE+DEVIDENTVALUE > 0) then '118E'
                          when ca.catype in ('017') then '119E'
                          when ca.catype='019' and ca.totradeplace in ('009','003') then '120E'
                          when ca.catype in ('010','015') then '250E'
                          when ca.catype in ('021','011') then '251E'
                          when ca.catype in ('026','020') then '252E'
                          when ca.catype in ('023') then '253E'
                          when ca.catype in ('022') then '254E'
                          when ca.catype in ('006') then '255E'
                          when ca.catype in ('016') then '256E'
                          when ca.catype in ('003','031') then '257E'
                          else '' end tmpl,
                       ca.FRTRADEPLACE, ca.TOTRADEPLACE, --chuyen san
                       ca.TOCODEID, ca.EXRATE, --chuyen doi CP thanh CP
                       ca.isincode caisincode, ca.duedate, ca.reportdate, ca.devidentvalue, sch.afacctno||sch.codeid seacctno,--giai the to chuc PH
                       ca.rate, ca.catype,ca.devidentshares,ca.frdatetransfer, ca.advdesc, ca.canceldate,ca.description,ca.exprice,
                       ca.optsymbol,ca.transfertimes, ca.insdeadline, ca.debitdate, ca.meetingplace, sch.balance, ca.deltd
                from CASCHD_LIST sch, camast ca, afmast af --, cfmast cf
                where ca.camastid=sch.camastid
                    --and ca.catype in ('019','027','017')
                    and sch.afacctno=af.acctno
                    and ca.camastid = l_camastid
            )ca, /*aftemplates atp,*/ cfmast cf, sbsecurities sb, issuers iss,
            (
                select cdval, cdcontent,en_cdcontent from allcode where cdname='TRADEPLACE' and cdtype='OD'
            ) a1,
            (
                select cdval, cdcontent,en_cdcontent from allcode where cdname='TRADEPLACE' and cdtype='OD'
            ) a2,
            (
                select cdval, cdcontent,en_cdcontent from allcode where cdname='TRADEPLACE' and cdtype='OD'
            ) a3,
            (
                select sb.codeid, sb.symbol, iss.fullname,iss.en_fullname, a0.cdcontent tradeplace,sb.isincode
                from sbsecurities sb, issuers iss, allcode a0
                where sb.issuerid=iss.issuerid
                    and a0.cdname='TRADEPLACE' and a0.cdtype='OD' and sb.tradeplace=a0.cdval
            ) a4,
            (
                select cdval, cdcontent,en_cdcontent from allcode where cdname='SECTYPE' and cdtype='SA'
            ) a5,
            (
                select cdval, cdcontent,en_cdcontent from allcode where cdname='CATYPE' and cduser='Y'
            ) a6
            , templates t, (
                select nvl(sb.refcodeid,sb.codeid) codeid, se.afacctno||nvl(sb.refcodeid,sb.codeid) acctno, sum(trade+mortage+blocked+emkqtty) trade
                from semast se, sbsecurities sb where se.codeid=sb.codeid and sb.sectype <> '004'
                group by nvl(sb.refcodeid,sb.codeid), se.afacctno
            ) se
        where --ca.custid=atp.custid
          --and atp.template_code in ('116E','117E','118E','119E','120E')
          --and ca.tmpl=atp.template_code and
          ca.custid=cf.custid
          and ca.tmpl=t.code and t.isactive='Y'
          and sb.codeid=ca.codeid
          and sb.issuerid=iss.issuerid
          and nvl(ca.FRTRADEPLACE,' ')=a1.cdval(+)
          and nvl(ca.TOTRADEPLACE,' ')=a2.cdval(+)
          and sb.tradeplace=a3.cdval
          and nvl(ca.TOCODEID,' ')=a4.codeid(+)
          and sb.sectype=a5.cdval
          and ca.seacctno=se.acctno
          and ca.catype =a6.cdval(+)


    ) loop

if rec.deltd = 'N' then     --thangpv SHBVNEX-2764
    if l_catype in ('010','015') then--For Cash dividend, Bond (Interest) coupon, Fund liquidation
            l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''||rec.isincode||''' p_isincode, '''||rec.catype||''' p_eventtype, '''||rec.rate||''' p_cashpersharebond, '''
                            || rec.fullname ||''' p_portfolioname, '''|| rec.camastid ||''' p_eventrefno, '''|| rec.afacctno ||''' acctno, '
                            ||rec.balance||' p_currentholding, '''||rec.cifid||''' p_portfoliono, '''
                            ||to_char(rec.reportdate,'DD/MM/RRRR')||''' p_recorddate, '''||to_char(rec.actiondate,'DD/MM/RRRR')||''' p_paymentdate,'''||rec.encdcontent||''' p_event_type from dual';       --thangpv SHBVNEX-2672
         ELSIF l_catype in ('021','009','011') then
            l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''||rec.isincode||''' p_isincode, '''||rec.catype||''' p_eventtype, '''||rec.rate||''' p_paymentratio, '''
                            || rec.fullname ||''' FULLNAME, '''|| rec.camastid ||''' p_eventrefno, '''|| rec.afacctno ||''' acctno, '
                            ||rec.qtty||' QTTY, '''
                            ||to_char(rec.reportdate,'DD/MM/RRRR')||''' p_recorddate, '''
                            ||to_char(rec.actiondate,'DD/MM/RRRR')||''' ACTIONDATE,'''||rec.encdcontent||''' p_event_type from dual ';              --thangpv SHBVNEX-2672
         ELSIF l_catype in ('026','020','017','018') then
            l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''||rec.isincode||''' p_isincode, '''||rec.symbol2||''' p_newsecuritiesid, '''
            || rec.fullname ||''' p_portfolioname, '''|| rec.custodycd ||''' p_new_securitiesisincode, '''|| rec.cifid ||''' p_portfoliono, '''
            ||rec.catype||''' p_eventtype, '||rec.devidentvalue||' p_conversionratio, '''
            ||to_char(getcurrdate,'DD/MM/YYYY')||''' p_lasttradingdateonstockexchange, '''||rec.camastid||''' p_eventrefno, '||rec.balance||' p_currentholding, '''
            ||to_char(rec.reportdate,'DD/MM/RRRR')||''' p_recorddate, '''||to_char(rec.actiondate,'DD/MM/RRRR')||''' p_effectivedelistingdate,'''||rec.encdcontent||''' p_event_type from dual ';       --thangpv SHBVNEX-2672
         ELSIF l_catype='023' then
            l_data_source:='select '''|| rec.fullname ||''' p_portfolioname, '''|| rec.symbol ||''' p_securitiesid, '''|| rec.isincode ||''' p_isincode, '''
            ||rec.symbol||''' SYMBOL, '''||rec.symbol2||''' p_newsecuritiesid, '''||rec.en_symname||''' p_newsecuritiesisin_code, '''||rec.cifid||''' p_portfoliono, '''
            ||rec.catype||''' p_eventtype, '''||rec.camastid||''' p_eventrefno, '''||rec.devidentvalue||''' p_conversionprice, '''||rec.devidentshares||''' p_conversionratio, '''
            ||to_char(rec.reportdate,'DD/MM/RRRR')||''' p_conversionregistrationperiod, '''||to_char(rec.duedate,'DD/MM/RRRR')||''' p_conversionregistrationdeadline, '''
            ||to_char(rec.canceldate,'DD/MM/RRRR')||''' p_cashamountperbond, '''||to_char(rec.duedate,'DD/MM/RRRR')||''' p_paymentdate, '''
            ||to_char(rec.reportdate,'DD/MM/RRRR')||''' p_recorddate, '''||to_char(rec.actiondate,'DD/MM/RRRR')||''' p_conversiondate, '||rec.balance||' p_currentholding,'''||rec.encdcontent||''' p_event_type from dual ';       --thangpv SHBVNEX-2672
         ELSIF l_catype='022' then--For Proxy voting (AGM, EGM)
            l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''||rec.isincode||''' p_isincode, '''||rec.catype||''' p_eventtype, '''||rec.camastid||''' p_eventrefno, '''
                            || rec.fullname ||''' p_portfolioname, '''|| rec.custodycd ||''' CUSTODYCD, '''|| rec.rate ||''' p_exerciseratio, '||rec.balance||' p_currentholding, '''
                            || rec.meetingplace ||''' p_meetingplace, '''|| to_char(rec.canceldate,'DD/MM/RRRR') ||''' p_votinginstructiondeadline, '''|| rec.description ||''' p_meetingcontent, '||rec.cifid||' p_portfoliono, '''
                            ||to_char(rec.reportdate,'DD/MM/RRRR')||''' p_recorddate, '''||to_char(rec.actiondate,'DD/MM/RRRR')||''' p_meetingdate,'''||rec.encdcontent||''' p_event_type from dual ';       --thangpv SHBVNEX-2672
         ELSIF l_catype='006' then--For Proxy voting (Postal ballot)
            l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''||rec.isincode||''' p_isincode, '''||rec.catype||''' p_eventtype, '''||rec.camastid||''' p_eventrefno, '''
                            || rec.fullname ||''' p_portfolioname, '''|| rec.custodycd ||''' CUSTODYCD, '''|| rec.rate ||''' p_exerciseratio, '||rec.balance||' p_currentholding, '''
                            || rec.advdesc ||''' p_meetingplace, '''|| to_char(rec.canceldate,'DD/MM/RRRR') ||''' p_submissiondeadline, '''|| rec.description ||''' p_ballotcontent, '||rec.cifid||' p_portfoliono, '''
                            ||to_char(rec.reportdate,'DD/MM/RRRR')||''' p_recorddate, '''||to_char(rec.actiondate,'DD/MM/RRRR')||''' p_meeting_date,'''||rec.encdcontent||''' p_event_type from dual ';                 --thangpv SHBVNEX-2672
         ELSIF l_catype='016' then
            l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''||rec.isincode||''' p_isincode, '''||rec.en_symname||''' EN_SYMBOLNAME, '''||rec.exprice||''' p_redemptionvalue, '''
                            || rec.fullname ||''' p_portfolioname, '''|| rec.catype ||''' p_eventtype, '''|| rec.camastid ||''' p_eventrefno, '||rec.balance||' p_currentholding, '''
                            || to_char(rec.duedate,'DD/MM/RRRR') ||''' p_maturitydate, '''|| rec.catype ||''' p_eventtype, '''|| rec.camastid ||''' p_eventrefno, '||rec.cifid||' p_portfoliono, '''
                            ||to_char(rec.reportdate,'DD/MM/RRRR')||''' p_recorddate, '''||to_char(rec.actiondate,'DD/MM/RRRR')||''' p_actualpaymentdate,'''||rec.encdcontent||''' p_event_type from dual ';                 --thangpv SHBVNEX-2672
         ELSIF l_catype='014' then
            l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''||rec.isincode||''' p_isincode, '''||rec.optsymbol||''' p_rightcode, '''||rec.caisincode||''' p_rightisincode, '''
                            || rec.fullname ||''' p_portfolioname, '''|| rec.symbol ||''' p_subscriptionsecuritiesid, '''|| rec.catype ||''' p_eventtype, '||rec.balance||' p_currentholding, '''
                            || rec.camastid ||''' p_eventrefno, '''|| rec.rate ||''' p_rightdistributionratio, '''|| rec.devidentshares ||''' p_rightexerciseratio, '||rec.transfertimes||' p_righttransferperiod, '''
                            ||to_char(rec.insdeadline,'DD/MM/RRRR')||''' p_deadlineforrighttransfer, '''||to_char(rec.reportdate,'DD/MM/RRRR')||''' prightsubscriptionperiod, '''
                            ||to_char(rec.canceldate,'DD/MM/RRRR')||''' p_deadlineforrightsubscription, '''||to_char(rec.debitdate,'DD/MM/RRRR')||''' p_debitdate, '''
                            ||to_char(rec.canceldate,'DD/MM/RRRR')||''' p_portfoliono, '''
                            ||to_char(rec.reportdate,'DD/MM/RRRR')||''' p_recorddate, '''||to_char(rec.actiondate,'DD/MM/RRRR')||''' ACTIONDATE from dual ';
         ELSIF l_catype in ('003','029','031','032') then
            l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''||rec.isincode||''' p_isincode, '''||rec.catype||''' p_eventtype, '''||rec.FRTRADEPLACE||''' FRTRADEPLACE, '''
                            || rec.fullname ||''' p_portfolioname, '''|| rec.cifid ||''' p_portfoliono, '''|| rec.camastid ||''' p_eventrefno, '||rec.balance||' p_currentholding, '''
                            ||to_char(rec.reportdate,'DD/MM/RRRR')||''' p_recorddate, '''||to_char(rec.actiondate,'DD/MM/RRRR')||''' p_effectivedate,'''||rec.encdcontent||''' p_event_type from dual ';                 --thangpv SHBVNEX-2672
         ELSE
           l_data_source:='select '''||rec.symbol||''' SYMBOL, '''||rec.symname||''' SYMBOLNAME, '''||rec.en_symname||''' EN_SYMBOLNAME, '''||rec.advdesc||''' p_additionaltext, '''
              || rec.fullname ||''' FULLNAME, '''|| rec.custodycd ||''' CUSTODYCD, '''|| rec.afacctno ||''' acctno, '||rec.trade||' QTTY, '''
              ||to_char(rec.reportdate,'DD/MM/RRRR')||''' REPORTDATE, '''||to_char(rec.actiondate,'DD/MM/RRRR')||''' p_effective_date from dual ';
        end if;
        
end if;


        --------
        /*l_email := '';
        For rec1 in
        (
            select tl.email
            from tlprofiles tl , templateslnk lnk, camast ca
            where lnk.tlid = tl.tlid
                and ca.makerid = tl.tlid
                and ca.camastid = l_camastid
                and lnk.templateid= rec.tmpl
        )loop
            If LENGTH (l_email) = 0 then
                l_email := rec1.email;
            else
                l_email :=  l_email || ',' || rec1.email;
            end if;

        End loop;
        nmpks_ems.InsertEmailLog(l_email, rec.tmpl, l_data_source, rec.afacctno);*/
        nmpks_ems.pr_sendInternalEmail(l_data_source, rec.tmpl, rec.afacctno);
    end loop;


    ELSE -- deltd TRANSACTION
        SELECT COUNT(1) INTO l_count FROM CASCHD_LIST WHERE CAMASTID= l_camastid AND STATUS IN ('S','C') AND DELTD = 'N';
        IF l_count > 0 THEN
            p_err_code := '-300005';
            plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
            RETURN errnums.C_BIZ_RULE_INVALID;
        ELSE --xoa quyen.
            UPDATE CASCHD_LIST SET deltd = 'Y' WHERE camastid = l_camastid;
            --UPDATE camast SET status='N' WHERE camastid =l_camastid;

            IF l_catype = '014' THEN
                FOR camast_rec IN
                (
                    SELECT * from camast WHERE camastid = l_camastid
                )
                LOOP
                    -- Lay truong thong tin dot thuc hien quyen ve.
                    l_catype:= camast_rec.catype;
                    l_optsymbol:= camast_rec.OPTSYMBOL;
                    l_codeid:= camast_rec.codeid;
                    SELECT codeid INTO l_optcodeid FROM sbsecurities WHERE symbol = l_optsymbol;

                END LOOP;
                DELETE sbsecurities WHERE codeid = l_optcodeid;
                DELETE securities_info WHERE codeid = l_optcodeid;
                DELETE securities_ticksize WHERE codeid = l_optcodeid;
                DELETE semast WHERE codeid = l_optcodeid;
            END IF;
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
         plog.init ('TXPKS_#3311EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#3311EX;
/
