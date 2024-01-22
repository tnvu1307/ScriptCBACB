SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#2257ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#2257EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      10/10/2014     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#2257ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_codeid           CONSTANT CHAR(2) := '01';
   c_afacctno         CONSTANT CHAR(2) := '02';
   c_acctno           CONSTANT CHAR(2) := '03';
   c_custodycd        CONSTANT CHAR(2) := '13';
   c_fullname         CONSTANT CHAR(2) := '12';
   c_qtty             CONSTANT CHAR(2) := '10';
   c_parvalue         CONSTANT CHAR(2) := '11';
   c_mortage          CONSTANT CHAR(2) := '19';
   c_standing         CONSTANT CHAR(2) := '20';
   c_depoblock        CONSTANT CHAR(2) := '06';
   c_rightoffqtty     CONSTANT CHAR(2) := '14';
   c_caqttyreceiv     CONSTANT CHAR(2) := '15';
   c_caqttydb         CONSTANT CHAR(2) := '16';
   c_caamtreceiv      CONSTANT CHAR(2) := '17';
   c_rightqtty        CONSTANT CHAR(2) := '18';
   c_total            CONSTANT CHAR(2) := '99';
   c_blkmtgstd_chk    CONSTANT CHAR(2) := '77';
   c_inward           CONSTANT CHAR(2) := '48';
   c_rcvcustodycd     CONSTANT CHAR(2) := '47';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    v_count number;
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

    IF p_txmsg.deltd <> 'Y' THEN

         select count(*) into v_count
         from SEFULLTRANSFER_LOG
         where deltd='N'
         and custodycd = NVL(p_txmsg.txfields('88').value, p_txmsg.txfields('13').value)
         and status = 'P'
         and (inward <> p_txmsg.txfields('48').value or p_txmsg.txfields('47').value <> rcvcustodycd);

         IF NOT v_count<=0 THEN
            p_err_code := '-150017'; -- Pre-defined in DEFERROR table
            plog.setendsection (pkgctx, 'fn_txAftAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
         END IF;

    end if;

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
l_RIGHTQTTY NUMBER;
l_RIGHTOFFQTTY NUMBER;
l_CAQTTYRECEIV NUMBER;
l_CAQTTYDB NUMBER;
l_CAAMTRECEIV NUMBER;
L_SEACCTNO VARCHAR2(20);
L_CODEIDWFT   VARCHAR2(6);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txPreAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txPreAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC PROCESS HERE. . DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    --locpt 2014 12 20 ghep tu PNS------------------------------------
       -- ghi jam so luong CA cho ve theo thu tu uu tien
    l_RIGHTQTTY :=to_number(p_txmsg.txfields('18').value);
    l_RIGHTOFFQTTY :=to_number(p_txmsg.txfields('14').value);-- sl quyen mua chua dk
    l_CAQTTYRECEIV :=to_number(p_txmsg.txfields('15').value);
    l_CAQTTYDB :=to_number(p_txmsg.txfields('16').value);
    l_CAAMTRECEIV :=to_number(p_txmsg.txfields('17').value);
    if(p_txmsg.deltd <>'Y') THEN
        FOR rec IN (

                      SELECT schd.status,autoid,camastid,reportdate,catype,
                      schd.codeid, schd.afacctno,(schd.afacctno||schd.codeid) seacctno,
                      (CASE WHEN (schd.catype='014' AND schd.castatus NOT IN ('A','P','N','C') AND schd.duedate >=GETCURRDATE )
                      THEN schd.pbalance ELSE 0 END) RIGHTOFFQTTY,
                      (CASE WHEN (schd.catype='014' AND schd.status IN ('M','S','I','G','O','W','F') AND isse='N') THEN schd.qtty
                      WHEN (schd.catype IN ('017','020','023') AND schd.status IN ('G','S','I','O','W','V')  AND isse='N' AND istocodeid='Y') THEN schd.qtty
                      WHEN (schd.catype IN ('011','021') AND schd.status  IN ('G','S','I','O','W') AND isse='N' ) THEN schd.qtty
                      ELSE 0 END) CAQTTYRECEIV,
                      (CASE WHEN (schd.catype IN ('016') AND schd.status  IN ('G','S','I','O','W') AND isse='N') THEN nvl(se.trade,0)
                            WHEN (schd.catype IN ('017','020','023','027') AND schd.status  IN ('G','S','I','O','W') AND isse='N') THEN schd.aqtty
                            ELSE 0 END) CAQTTYDB, -- CA Cho giam
                      (CASE  WHEN (schd.catype IN ('016') AND schd.status  IN ('G','S','I','O','W') AND isse='N' ) THEN 1 ELSE 0 END) ISDBSEALL,
                      (CASE WHEN  (schd.status  IN ('H','S','I','O','W','V') AND isci='N' AND schd.isexec='Y') THEN schd.amt ELSE 0 END) CAAMTRECEIV,
                      (CASE WHEN (schd.catype IN ('005','006','022') AND schd.status IN ('H','G','S','I','J','O','W')) THEN schd.rqtty ELSE 0 END) RIGHTQTTY,

                      ISWFT,optcodeid
                      FROM
                            (SELECT schd.rqtty,schd.autoid,schd.status,camast.catype,camast.duedate,camast.status castatus,schd.afacctno,camast.codeid,
                            camast.tocodeid, schd.camastid,schd.balance,schd.qtty,schd.aqtty,schd.amt,schd.aamt,schd.pbalance,schd.pqtty ,
                            schd.isci,schd.isexec,reportdate ,'N' istocodeid, NVL(ISWFT,'Y') ISWFT, camast.optcodeid, schd.isse
                            FROM caschd schd ,camast WHERE schd.camastid=camast.camastid AND schd.deltd='N' AND camast.deltd='N' AND camast.status <> 'C'
                            UNION ALL
                            SELECT schd.rqtty,schd.autoid,  schd.status,camast.catype,camast.duedate,camast.status castatus,schd.afacctno, camast.tocodeid codeid,
                            '',schd.camastid,0,schd.qtty,0,0,0,0,0,
                            schd.isci,schd.isexec ,reportdate ,'Y' istocodeid, NVL(ISWFT,'Y') ISWFT, camast.optcodeid, schd.isse
                            FROM caschd schd, camast
                            WHERE schd.camastid=camast.camastid AND camast.catype IN ('017','020','023')AND schd.deltd='N' AND camast.deltd='N' AND camast.status <> 'C'
                            ) SCHD, semast se
                       WHERE schd.codeid=p_txmsg.txfields('01').value
                       AND  schd.afacctno=p_txmsg.txfields('02').value
                       AND se.acctno(+)=(schd.afacctno||schd.codeid)

                      ORDER BY reportdate
                   )
        LOOP
                  /* -- check xem so luong co tron dong khong
                    if(l_RIGHTOFFQTTY <rec.RIGHTOFFQTTY) THEN
                    p_err_code:='-269009';
                    plog.setendsection(pkgctx, 'fn_txPreAppCheck');
                    RETURN errnums.C_BIZ_RULE_INVALID;

                    END IF;
                    if(l_CAQTTYRECEIV <rec.CAQTTYRECEIV) THEN
                    p_err_code:='-269010';
                    plog.setendsection(pkgctx, 'fn_txPreAppCheck');
                    RETURN errnums.C_BIZ_RULE_INVALID;

                    END IF;
                    if(l_CAQTTYDB <rec.CAQTTYDB) THEN
                    p_err_code:='-269011';
                    plog.setendsection(pkgctx, 'fn_txPreAppCheck');
                    RETURN errnums.C_BIZ_RULE_INVALID;

                    END IF;
                    if(l_CAAMTRECEIV <rec.CAAMTRECEIV) THEN
                    p_err_code:='-269012';
                    plog.setendsection(pkgctx, 'fn_txPreAppCheck');
                    RETURN errnums.C_BIZ_RULE_INVALID;

                    END IF;
                    if(l_RIGHTQTTY <rec.RIGHTQTTY) THEN
                    p_err_code:='-269013';
                    plog.setendsection(pkgctx, 'fn_txPreAppCheck');
                    RETURN errnums.C_BIZ_RULE_INVALID;

                    END IF;   */
                 IF ( LEAST(rec.RIGHTQTTY,l_RIGHTQTTY)+LEAST(rec.RIGHTOFFQTTY,l_RIGHTOFFQTTY)+
                      LEAST(rec.CAQTTYRECEIV,l_CAQTTYRECEIV)+LEAST(rec.CAQTTYDB,l_CAQTTYDB)+
                      LEAST(rec.CAAMTRECEIV,l_CAAMTRECEIV)> 0) THEN

                      insert into caclstransfer(caschdid, camastid, catype, pbalance, balance, amt,
                               aamt, qtty, aqtty, rqtty,
                               txnum, txdate, deltd)
                      values (rec.autoid, rec.camastid, rec.catype, least(rec.RIGHTOFFQTTY,l_RIGHTOFFQTTY), 0, least(rec.CAAMTRECEIV,l_CAAMTRECEIV),
                                0, least(rec.CAQTTYRECEIV,l_CAQTTYRECEIV), decode(rec.catype,'016',0,least(rec.CAQTTYDB,l_CAQTTYDB)), least(rec.RIGHTQTTY,l_RIGHTQTTY),
                                p_txmsg.txnum, p_txmsg.txdate, 'N');

                    if(rec.catype <> '016') THEN
                         if(rec.status <> 'O' ) THEN
                             UPDATE caschd SET status='O',pbalance=pbalance-least(rec.RIGHTOFFQTTY,l_RIGHTOFFQTTY),
                                               qtty=qtty-least(rec.CAQTTYRECEIV,l_CAQTTYRECEIV),
                                               rqtty=rqtty-least(rec.RIGHTQTTY,l_RIGHTQTTY),
                                               aqtty=aqtty-least(rec.CAQTTYDB,l_CAQTTYDB),
                                               amt=amt-least(rec.CAAMTRECEIV,l_CAAMTRECEIV),
                                               SENDPBALANCE=SENDPBALANCE+least(rec.RIGHTOFFQTTY,l_RIGHTOFFQTTY),
                                               SENDQTTY=SENDQTTY+least(rec.CAQTTYRECEIV,l_CAQTTYRECEIV)
                                               +least(rec.RIGHTQTTY,l_RIGHTQTTY),
                                               SENDAQTTY=SENDAQTTY+least(rec.CAQTTYDB,l_CAQTTYDB),
                                               SENDAMT=SENDAMT+least(rec.CAAMTRECEIV,l_CAAMTRECEIV),
                                               pstatus= pstatus||status

                              WHERE autoid=rec.autoid;
                          ELSE
                              UPDATE caschd SET pbalance=pbalance-least(rec.RIGHTOFFQTTY,l_RIGHTOFFQTTY),
                                               qtty=qtty-least(rec.CAQTTYRECEIV,l_CAQTTYRECEIV),
                                               rqtty=rqtty-least(rec.RIGHTQTTY,l_RIGHTQTTY),
                                               aqtty=aqtty-least(rec.CAQTTYDB,l_CAQTTYDB),
                                               amt=amt-least(rec.CAAMTRECEIV,l_CAAMTRECEIV),
                                               SENDPBALANCE=SENDPBALANCE+least(rec.RIGHTOFFQTTY,l_RIGHTOFFQTTY),
                                               SENDQTTY=SENDQTTY+least(rec.CAQTTYRECEIV,l_CAQTTYRECEIV)
                                               +least(rec.RIGHTQTTY,l_RIGHTQTTY),
                                               SENDAQTTY=SENDAQTTY+least(rec.CAQTTYDB,l_CAQTTYDB),
                                               SENDAMT=SENDAMT+least(rec.CAAMTRECEIV,l_CAAMTRECEIV)


                              WHERE autoid=rec.autoid;
                          END IF;
                    ELSE -- su kien tra goc lai trai phieu: khong tru o aqtty
                        if(rec.status <> 'O' ) THEN
                             UPDATE caschd SET status='O',pbalance=pbalance-least(rec.RIGHTOFFQTTY,l_RIGHTOFFQTTY),
                                               qtty=qtty-least(rec.CAQTTYRECEIV,l_CAQTTYRECEIV),
                                               rqtty=rqtty-least(rec.RIGHTQTTY,l_RIGHTQTTY),
                                               amt=amt-least(rec.CAAMTRECEIV,l_CAAMTRECEIV),
                                               SENDPBALANCE=SENDPBALANCE+least(rec.RIGHTOFFQTTY,l_RIGHTOFFQTTY),
                                               SENDQTTY=SENDQTTY+least(rec.CAQTTYRECEIV,l_CAQTTYRECEIV)
                                               +least(rec.RIGHTQTTY,l_RIGHTQTTY),
                                               SENDAQTTY=SENDAQTTY+least(rec.CAQTTYDB,l_CAQTTYDB),
                                               SENDAMT=SENDAMT+least(rec.CAAMTRECEIV,l_CAAMTRECEIV),
                                               pstatus= pstatus||status

                              WHERE autoid=rec.autoid;
                          ELSE
                              UPDATE caschd SET pbalance=pbalance-least(rec.RIGHTOFFQTTY,l_RIGHTOFFQTTY),
                                               qtty=qtty-least(rec.CAQTTYRECEIV,l_CAQTTYRECEIV),
                                               rqtty=rqtty-least(rec.RIGHTQTTY,l_RIGHTQTTY),
                                               amt=amt-least(rec.CAAMTRECEIV,l_CAAMTRECEIV),
                                               SENDPBALANCE=SENDPBALANCE+least(rec.RIGHTOFFQTTY,l_RIGHTOFFQTTY),
                                               SENDQTTY=SENDQTTY+least(rec.CAQTTYRECEIV,l_CAQTTYRECEIV)
                                               +least(rec.RIGHTQTTY,l_RIGHTQTTY),
                                               SENDAQTTY=SENDAQTTY+least(rec.CAQTTYDB,l_CAQTTYDB),
                                               SENDAMT=SENDAMT+least(rec.CAAMTRECEIV,l_CAAMTRECEIV)


                              WHERE autoid=rec.autoid;
                          END IF;
                    END IF;
                     -- CAT RECEIVING TRONG SEMAST
                    IF(LEAST(rec.CAQTTYRECEIV,l_CAQTTYRECEIV) >0) THEN
                        IF(REC.ISWFT='Y') THEN
                           SELECT CODEID INTO L_CODEIDWFT FROM SBSECURITIES WHERE REFCODEID=REC.CODEID;
                           l_SEACCTNO:=REC.AFACCTNO||L_CODEIDWFT;
                        ELSE
                           l_SEACCTNO:=REC.AFACCTNO||REC.CODEID;
                        END IF;

                        UPDATE SEMAST SET RECEIVING=RECEIVING-LEAST(rec.CAQTTYRECEIV,l_CAQTTYRECEIV)
                        WHERE ACCTNO=l_SEACCTNO;

                         INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                         VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),l_SEACCTNO,
                         '0015',LEAST(rec.CAQTTYRECEIV,l_CAQTTYRECEIV),NULL,NULL,p_txmsg.deltd,NULL,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

                    END IF;
                    -- neu la sk quyen mua: tru o semast cua ck quyen
                    if(rec.catype='014') THEN
                      UPDATE semast SET trade=trade-least(rec.RIGHTOFFQTTY,l_RIGHTOFFQTTY)
                      WHERE acctno=rec.afacctno||rec.optcodeid;
                    END IF;

                    l_RIGHTQTTY :=l_RIGHTQTTY-LEAST(rec.RIGHTQTTY,l_RIGHTQTTY);
                    l_RIGHTOFFQTTY :=l_RIGHTOFFQTTY-LEAST(rec.RIGHTOFFQTTY,l_RIGHTOFFQTTY);
                    l_CAQTTYRECEIV :=l_CAQTTYRECEIV-LEAST(rec.CAQTTYRECEIV,l_CAQTTYRECEIV);
                    l_CAQTTYDB :=l_CAQTTYDB-LEAST(rec.CAQTTYDB,l_CAQTTYDB);
                    l_CAAMTRECEIV :=l_CAAMTRECEIV-LEAST(rec.CAAMTRECEIV,l_CAAMTRECEIV);
                    EXIT WHEN (l_RIGHTQTTY+l_RIGHTOFFQTTY+l_CAQTTYRECEIV+l_CAQTTYDB+l_CAAMTRECEIV=0);

        END IF;

        END LOOP;
    ELSE -- xoa jao dich
        update caclstransfer set deltd = 'Y' where txnum = p_txmsg.txnum and txdate = p_txmsg.txdate;
            FOR rec IN (
                 SELECT schd.autoid, schd.codeid, schd.afacctno,(schd.afacctno||schd.codeid) seacctno,
                 schd.SENDPBALANCE  RIGHTOFFQTTY,
                 schd.SENDAMT CAAMTRECEIV,
                 schd.SENDAQTTY CAQTTYDB,
                 (CASE WHEN (ca.catype IN ('005','006','022')) THEN schd.SENDQTTY ELSE 0 END) RIGHTQTTY,
                 (CASE WHEN (ca.catype NOT IN ('005','006','022'))THEN schd.SENDQTTY ELSE 0 END) CAQTTYRECEIV,
                 ca.catype,ISWFT,optcodeid
                FROM (
                SELECT schd.autoid,schd.status,camast.catype,camast.duedate,camast.status castatus,schd.afacctno,camast.codeid,
                camast.tocodeid, schd.camastid,schd.balance,schd.qtty,schd.aqtty,schd.amt,schd.aamt,schd.pbalance,schd.pqtty ,
                schd.isci,schd.isse ,SENDPBALANCE,SENDAMT,SENDAQTTY,
                (CASE WHEN (catype IN ('017','020','023')) THEN 0 ELSE SENDQTTY END )SENDQTTY

                FROM caschd schd ,camast WHERE schd.status='O' AND schd.camastid=camast.camastid AND schd.deltd='N' AND camast.deltd='N' AND camast.status <> 'C'
                UNION ALL
                SELECT schd.autoid,  schd.status,camast.catype,camast.duedate,camast.status castatus,schd.afacctno, camast.tocodeid codeid,
                '',schd.camastid,0,schd.qtty,0,0,0,0,0,
                schd.isci,schd.isse  ,0,0,0,  SENDQTTY

                FROM caschd schd, camast
                WHERE schd.status='O' AND schd.camastid=camast.camastid AND camast.catype IN ('017','020','023')AND schd.deltd='N' AND camast.deltd='N' AND camast.status <> 'C'

                 ) schd, camast ca
                  WHERE schd.camastid=ca.camastid
                  ORDER BY reportdate
               )
            LOOP

            if(rec.catype <> '016') THEN
                  UPDATE caschd SET  status=SUBSTR(pstatus,LENGTH(pstatus)),
                                     pbalance=pbalance+least(rec.RIGHTOFFQTTY,l_RIGHTOFFQTTY),
                                     qtty=qtty+least(rec.CAQTTYRECEIV,l_CAQTTYRECEIV),
                                     rqtty=rqtty+ least(rec.RIGHTQTTY,l_RIGHTQTTY),
                                     aqtty=aqtty+least(rec.CAQTTYDB,l_CAQTTYDB),
                                     amt=amt+least(rec.CAAMTRECEIV,l_CAAMTRECEIV),
                                     SENDPBALANCE=SENDPBALANCE-least(rec.RIGHTOFFQTTY,l_RIGHTOFFQTTY),
                                     SENDQTTY=SENDQTTY-least(rec.CAQTTYRECEIV,l_CAQTTYRECEIV)
                                     -least(rec.RIGHTQTTY,l_RIGHTQTTY),
                                     SENDAQTTY=SENDAQTTY-least(rec.CAQTTYDB,l_CAQTTYDB),
                                     SENDAMT=SENDAMT-least(rec.CAAMTRECEIV,l_CAAMTRECEIV),
                                     pstatus=pstatus||status

                    WHERE autoid=rec.autoid;
              ELSE -- su kien tra goc lai trai phieu ko update o AQTTY
                     UPDATE caschd SET  status=SUBSTR(pstatus,LENGTH(pstatus)),
                                     pbalance=pbalance+least(rec.RIGHTOFFQTTY,l_RIGHTOFFQTTY),
                                     qtty=qtty+least(rec.CAQTTYRECEIV,l_CAQTTYRECEIV),
                                     rqtty=rqtty+ least(rec.RIGHTQTTY,l_RIGHTQTTY),
                                     amt=amt+least(rec.CAAMTRECEIV,l_CAAMTRECEIV),
                                     SENDPBALANCE=SENDPBALANCE-least(rec.RIGHTOFFQTTY,l_RIGHTOFFQTTY),
                                     SENDQTTY=SENDQTTY-least(rec.CAQTTYRECEIV,l_CAQTTYRECEIV)
                                     -least(rec.RIGHTQTTY,l_RIGHTQTTY),
                                     SENDAQTTY=SENDAQTTY-least(rec.CAQTTYDB,l_CAQTTYDB),
                                     SENDAMT=SENDAMT-least(rec.CAAMTRECEIV,l_CAAMTRECEIV),
                                     pstatus=pstatus||status
                    WHERE autoid=rec.autoid;
              END IF;

               -- CONG RECEIVING TRONG SEMAST
                    IF(LEAST(rec.CAQTTYRECEIV,l_CAQTTYRECEIV) >0) THEN
                        IF(REC.ISWFT='Y') THEN
                           SELECT CODEID INTO L_CODEIDWFT FROM SBSECURITIES WHERE REFCODEID=REC.CODEID;
                           l_SEACCTNO:=REC.AFACCTNO||L_CODEIDWFT;
                        ELSE
                           l_SEACCTNO:=REC.AFACCTNO||REC.CODEID;
                        END IF;

                        UPDATE SEMAST SET RECEIVING=RECEIVING+LEAST(rec.CAQTTYRECEIV,l_CAQTTYRECEIV)
                        WHERE ACCTNO=l_SEACCTNO;

                    END IF;
                    if(rec.catype='014') THEN
                      UPDATE semast SET trade=trade+least(rec.RIGHTOFFQTTY,l_RIGHTOFFQTTY)
                      WHERE acctno=rec.afacctno+rec.optcodeid;
                    END IF;

                l_RIGHTQTTY :=l_RIGHTQTTY-LEAST(rec.RIGHTQTTY,l_RIGHTQTTY);
                l_RIGHTOFFQTTY :=l_RIGHTOFFQTTY-LEAST(rec.RIGHTOFFQTTY,l_RIGHTOFFQTTY);
                l_CAQTTYRECEIV :=l_CAQTTYRECEIV-LEAST(rec.CAQTTYRECEIV,l_CAQTTYRECEIV);
                l_CAQTTYDB :=l_CAQTTYDB-LEAST(rec.CAQTTYDB,l_CAQTTYDB);
                l_CAAMTRECEIV :=l_CAAMTRECEIV-LEAST(rec.CAAMTRECEIV,l_CAAMTRECEIV);
                EXIT WHEN (l_RIGHTQTTY+l_RIGHTOFFQTTY+l_CAQTTYRECEIV+l_CAQTTYDB+l_CAAMTRECEIV=0);
            END LOOP;
    END IF;


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
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
     IF p_txmsg.deltd <> 'Y' THEN -- Normal transaction
        IF CSPKS_SEPROC.fn_TransferDTOCLOSE(p_txmsg,p_err_code) <> systemnums.C_SUCCESS THEN
           RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;
         --T07/2017 STP
        insert into sefulltransfer_log(autoid, txdate, txnum, codeid, custodycd, afacctno, acctno, inward, rcvcustodycd, trade, blocked, mortage, status, deltd)
        SELECT seq_SEFullTransfer_log.NEXTVAL autoid, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT) txdate, p_txmsg.txnum txnum,
        p_txmsg.txfields('01').value codeid, NVL(p_txmsg.txfields('88').value, p_txmsg.txfields('13').value) custodycd, p_txmsg.txfields('02').value afacctno, p_txmsg.txfields('03').value acctno,
        p_txmsg.txfields('48').value inward, p_txmsg.txfields('47').value rcvcustodycd, to_number(p_txmsg.txfields('10').value) trade,
        to_number(p_txmsg.txfields('06').value) blocked, to_number(p_txmsg.txfields('19').value) mortage, 'P' status, 'N' deltd
        FROM dual ;
    else
        update sefulltransfer_log
        set deltd = 'Y'
        where txdate = TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT) and txnum = p_txmsg.txnum;
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
         plog.init ('TXPKS_#2257EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#2257EX;
/
