SET DEFINE OFF;
CREATE OR REPLACE PACKAGE cspks_seproc
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
FUNCTION fn_TransferDTOCLOSE(p_txmsg in tx.msg_rectype,p_err_code out varchar2) RETURN NUMBER;

FUNCTION fn_GetAvailableTrade(p_afacctno in VARCHAR2 , p_CodeID in varchar2) RETURN NUMBER;

FUNCTION fn_AdjustCostprice_Online(p_txmsg in tx.msg_rectype,p_err_code out varchar2) RETURN NUMBER; -- Cap nhat gia von online. TheNN, 19-Jan-2012

END;
/


CREATE OR REPLACE PACKAGE BODY cspks_seproc
IS
   -- declare log context
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   FUNCTION fn_TransferDTOCLOSE(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
   RETURN NUMBER
   IS
      l_txmsg               tx.msg_rectype;
      v_strCURRDATE varchar2(20);
      v_strPREVDATE varchar2(20);
      v_strNEXTDATE varchar2(20);
      l_err_param   varchar2(300);
      l_lngErrCode  number(20,0);
      v_blnREVERSAL boolean;
      l_count       number;
  BEGIN

    plog.setbeginsection (pkgctx, 'fn_TransferDTOCLOSE');
    plog.debug (pkgctx, '<<BEGIN OF fn_TransferDTOCLOSE');
    v_blnREVERSAL:=case when p_txmsg.deltd ='Y' then true else false end;

    l_lngErrCode:= errnums.C_BIZ_RULE_INVALID;
    p_err_code:=0;

    --</ Kiem tra co co trong chu ki thanh toan khong -- 'van con tien nhan tien
    Begin
        SELECT COUNT(*) INTO l_count  FROM STSCHD WHERE SUBSTR(AFACCTNO,1,10)= p_txmsg.txfields('02').value AND STATUS<>'C' AND DELTD<>'Y' AND DUETYPE ='RM';
    EXCEPTION
        WHEN OTHERS THEN  l_count := 0;
    END;
    IF l_count > 0 THEN
        
        p_err_code := -400024;
        return l_lngErrCode;
    END IF;
    -- />

    --</ Kiem tra co co trong chu ki thanh toan khong -- van con chung khoan cho ve
    BEGIN
        SELECT COUNT(*) INTO l_count FROM STSCHD WHERE SUBSTR(AFACCTNO,1,10)= p_txmsg.txfields('02').value AND STATUS<>'C' AND DELTD<>'Y' AND DUETYPE ='RS';
    EXCEPTION
        WHEN OTHERS THEN  l_count := 0;
    END;
    IF l_count > 0 THEN
        
        p_err_code := -400025;
        return l_lngErrCode;
    END IF;
    --/>

    --</ ERR_SE_TRADE_NOT_ENOUGHT
    IF p_txmsg.DELTD ='N' THEN
        BEGIN
            SELECT COUNT(*) INTO l_count FROM SEMAST WHERE AFACCTNO= p_txmsg.txfields('02').value AND ACCTNO= p_txmsg.txfields('02').value AND TRADE >= p_txmsg.txfields('10').value;
        EXCEPTION
            WHEN OTHERS THEN  l_count := 0;
        END;
        IF l_count > 0 THEN
            
            p_err_code := -900017;
            return l_lngErrCode;
        END IF;
      --  UPDATE semastdtl SET status='F' WHERE status='N' AND qttytype IN ('002','007','011') AND acctno = p_txmsg.txfields('03').value;
     ELSE
        BEGIN
            SELECT COUNT(*) INTO l_count FROM SEMAST WHERE AFACCTNO= p_txmsg.txfields('02').value AND ACCTNO= p_txmsg.txfields('02').value AND DTOCLOSE >= p_txmsg.txfields('10').value;
        EXCEPTION
            WHEN OTHERS THEN  l_count := 0;
        END;
        IF l_count > 0 THEN
            
            p_err_code := -900032;
            return l_lngErrCode;
        END IF;
      --   UPDATE semastdtl SET status='N' WHERE status='F' AND qttytype IN ('002','007','011') AND acctno = p_txmsg.txfields('03').value;
     END IF;
    --/>

    p_err_code:=0;
    plog.debug (pkgctx, '<<END OF fn_TransferDTOCLOSE');
    plog.setendsection (pkgctx, 'fn_TransferDTOCLOSE');
    RETURN systemnums.C_SUCCESS;

  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on release fn_TransferDTOCLOSE');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'fn_TransferDTOCLOSE');
      RAISE errnums.E_SYSTEM_ERROR;
  END fn_TransferDTOCLOSE;


    FUNCTION fn_GetAvailableTrade(p_afacctno in VARCHAR2 , p_CodeID in varchar2)
   RETURN NUMBER
   IS
      l_Trading       number;
      l_afacctno    VARCHAR2(10);
      l_CodeID      VARCHAR2(6);
  BEGIN

    plog.setbeginsection (pkgctx, 'fn_GetAvailableTrade');
    plog.debug (pkgctx, '<<BEGIN OF fn_GetAvailableTrade');
    l_afacctno := p_afacctno;
    l_CodeID   := p_CodeID;
    l_Trading  := 0;



    Begin
        Select greatest(semast.trade - nvl(b.secureamt,0) + nvl(b.sereceiving,0),0) into l_Trading
        From SEMAST , v_getsellorderinfo b, (select codeid, tradelot from securities_info) seinfo
        WHERE semast.afacctno = l_afacctno And semast.CodeID = l_CodeID
                AND semast.codeid = seinfo.codeid(+) AND ACCTNO = b.seacctno(+);

    EXCEPTION
      WHEN OTHERS THEN l_Trading := 0;
    END;

    plog.debug (pkgctx,'l_CodeID:' || l_CodeID);
    plog.debug (pkgctx,'l_Trading:' || l_Trading);

    Return l_Trading;

    plog.setendsection (pkgctx, 'fn_GetAvailableTrade');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on release fn_GetAvailableTrade');
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'fn_GetAvailableTrade');
      return 0;
  END fn_GetAvailableTrade;

-- Cap nhat gia von ONLINE
-- TheNN, 19-Jan-2012
FUNCTION fn_AdjustCostprice_Online(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
    RETURN NUMBER
    IS
        l_err_param   varchar2(300);
        l_lngErrCode  number(20,0);
        v_blnREVERSAL boolean;
    BEGIN

        plog.setbeginsection (pkgctx, 'fn_AdjustCostprice_Online');
        plog.debug (pkgctx, '<<BEGIN OF fn_AdjustCostprice_Online');
        v_blnREVERSAL:=case when p_txmsg.deltd ='Y' then true else false end;

        if not v_blnREVERSAL THEN
            -- Ghi nhan vao bang thong tin gia von
            -- Cap nhat gia von online chi cho phep khi gia von = 0
            INSERT INTO SECOSTPRICE (AUTOID, ACCTNO, TXDATE, COSTPRICE, PREVCOSTPRICE, DCRAMT, DCRQTTY, DELTD)
            SELECT SEQ_SECOSTPRICE.NEXTVAL, p_txmsg.txfields('03').value, getcurrdate,
                    round(p_txmsg.txfields('10').value,4), 0, round(p_txmsg.txfields('10').value,4), p_txmsg.txfields('11').value, 'N'
            FROM dual;

            -- Cap nhat vao SEMAST
            UPDATE SEMAST SET COSTPRICE = round(p_txmsg.txfields('10').value,4) WHERE ACCTNO= p_txmsg.txfields('03').value;
        ELSE
            -- Reversal
            -- update SEMAST
            UPDATE SEMAST SET COSTPRICE = 0 WHERE ACCTNO= p_txmsg.txfields('03').value;
            -- Update SECOSTPRICE
            UPDATE SECOSTPRICE SET DELTD = 'Y' WHERE ACCTNO = p_txmsg.txfields('03').value AND TXDATE = GETCURRDATE;
        END IF;

        p_err_code:=0;
        plog.debug (pkgctx, '<<END OF fn_AdjustCostprice_Online');
        plog.setendsection (pkgctx, 'fn_AdjustCostprice_Online');
        RETURN systemnums.C_SUCCESS;

    EXCEPTION
        WHEN OTHERS
        THEN
            plog.debug (pkgctx,'got error on release fn_AdjustCostprice_Online');
            ROLLBACK;
            p_err_code := errnums.C_SYSTEM_ERROR;
            plog.error (pkgctx, SQLERRM);
            plog.setendsection (pkgctx, 'fn_AdjustCostprice_Online');
            RAISE errnums.E_SYSTEM_ERROR;
    END fn_AdjustCostprice_Online;



-- initial LOG
BEGIN
   SELECT *
   INTO logrow
   FROM tlogdebug
   WHERE ROWNUM <= 1;

   pkgctx    :=
      plog.init ('cspks_seproc',
                 plevel => logrow.loglevel,
                 plogtable => (logrow.log4table = 'Y'),
                 palert => (logrow.log4alert = 'Y'),
                 ptrace => (logrow.log4trace = 'Y')
      );
END;
/
