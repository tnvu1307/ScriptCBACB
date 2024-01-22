SET DEFINE OFF;
CREATE OR REPLACE PACKAGE cspks_ciproc
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
    FUNCTION fn_FeeDepoMaturityBackdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
    RETURN NUMBER;
    FUNCTION fn_FeeDepoDebit(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
    RETURN NUMBER;

    FUNCTION fn_cidatedepofeeacr(strCLOSETYPE in varchar2,strCUSTODYCD IN varchar2, strAFACCTNO in varchar2, strNumDATE IN  NUMBER)
    RETURN  number;

    FUNCTION fn_CIGetDePoFeeToClose(strACCTNO IN varchar2, strDays IN NUMBER)
    RETURN  number;

    FUNCTION fn_GetDaysToAddFee(strDate IN varchar2, Days IN number) RETURN number;
    PROCEDURE Pr_FeebookingResultAuto(p_bchmdl varchar,p_err_code  OUT varchar2,p_FromRow number,p_ToRow number, p_lastRun OUT varchar2);

END;
/


CREATE OR REPLACE PACKAGE BODY cspks_ciproc
IS
   -- declare log context
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

 ---------------------------------fn_GenRemittanceTrans------------------------------------------------
FUNCTION fn_GenRemittanceTrans(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
v_blnREVERSAL boolean;
l_lngErrCode    number(20,0);
v_count number(20,0);
v_dblFEEAMT number(20,4);
v_dblTRFAMT number(20,4);
v_strREFAUTOID  number;
v_strBANKCODE varchar2(100);
v_TRANSFERLIMIT number;
v_checkIsBIDV number;
v_checkIsNotList number;
v_CIREMITTANCE_RMSTATUS varchar(1);
v_Bankcode varchar(15);
v_bridBIDVHN varchar(60);

v_CRBTXREQ_STATUS varchar(1);

BEGIN
    plog.setbeginsection (pkgctx, 'fn_GenRemittanceTrans');
    plog.debug (pkgctx, '<<BEGIN OF fn_GenRemittanceTrans');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    v_blnREVERSAL:=case when p_txmsg.deltd ='Y' then true else false end;
    l_lngErrCode:= errnums.C_BIZ_RULE_INVALID;
    p_err_code:=0;

    if not v_blnREVERSAL then
        --CHieu lam thuan giao dich
/*        if p_txmsg.tltxcd in ('1108') THEN
            v_dblFEEAMT:=p_txmsg.txfields('11').value+p_txmsg.txfields('12').value;
            INSERT INTO CIREMITTANCE (TXDATE, TXNUM, ACCTNO,BANKID, BENEFBANK, BENEFACCT, BENEFCUSTNAME, BENEFLICENSE, AMT, FEEAMT, DELTD, BENEFIDDATE, BENEFIDPLACE,FEETYPE,CITYEF, CITYBANK)
              VALUES (TO_DATE(p_txmsg.txdate,systemnums.c_date_format), p_txmsg.txnum,p_txmsg.txfields('03').value,
              p_txmsg.txfields('05').value,p_txmsg.txfields('80').value,p_txmsg.txfields('81').value,
              p_txmsg.txfields('82').value,p_txmsg.txfields('83').value,
              p_txmsg.txfields('10').value,p_txmsg.txfields('11').value, 'N',
              --TO_DATE(p_txmsg.txfields('95').value,systemnums.c_date_format),p_txmsg.txfields('96').value,to_char(p_txmsg.txfields('09').value),
              TO_DATE(p_txmsg.txfields('97').value,systemnums.c_date_format),p_txmsg.txfields('96').value,to_char(p_txmsg.txfields('09').value),
              to_char(p_txmsg.txfields('85').value),to_char(p_txmsg.txfields('84').value));
        ELS*/
        IF p_txmsg.tltxcd in ('1133') THEN
            --v_dblFEEAMT:=p_txmsg.txfields('11').value+p_txmsg.txfields('12').value;
            --81  1133    BENEFBANK
            --84  1133    CITYBANK
            v_dblFEEAMT:=0;
            /*INSERT INTO CIREMITTANCE (TXDATE, TXNUM, ACCTNO,BANKID, BENEFBANK, BENEFACCT, BENEFCUSTNAME, BENEFLICENSE, AMT, FEEAMT, DELTD, BENEFIDDATE, BENEFIDPLACE,FEETYPE,CITYEF, CITYBANK)
                VALUES (TO_DATE(p_txmsg.txdate,systemnums.c_date_format), p_txmsg.txnum,p_txmsg.txfields('03').value,
                p_txmsg.txfields('05').value,p_txmsg.txfields('81').value,'',
                p_txmsg.txfields('82').value,p_txmsg.txfields('83').value,
                p_txmsg.txfields('10').value,0, 'N',
                TO_DATE(p_txmsg.txfields('95').value,systemnums.c_date_format),p_txmsg.txfields('96').value,'0',
                to_char(p_txmsg.txfields('85').value),to_char(p_txmsg.txfields('84').value));*/
        elsiF p_txmsg.tltxcd in ('1113') THEN

            v_dblFEEAMT:=p_txmsg.txfields('11').value+p_txmsg.txfields('12').value;

            INSERT INTO CIREMITTANCE (TXDATE, TXNUM, ACCTNO,BANKID, BENEFBANK, BENEFACCT, BENEFCUSTNAME, BENEFLICENSE, AMT, FEEAMT, DELTD, BENEFIDDATE, BENEFIDPLACE,FEETYPE,CITYEF, CITYBANK,VAT)
                VALUES (TO_DATE(p_txmsg.txdate,systemnums.c_date_format), p_txmsg.txnum,p_txmsg.txfields('03').value,
                p_txmsg.txfields('05').value,p_txmsg.txfields('81').value,'',
                p_txmsg.txfields('82').value,p_txmsg.txfields('83').value,
                p_txmsg.txfields('10').value,p_txmsg.txfields('11').value, 'N',
                TO_DATE(p_txmsg.txfields('95').value,systemnums.c_date_format),p_txmsg.txfields('96').value,to_char(p_txmsg.txfields('09').value),
                to_char(p_txmsg.txfields('85').value),to_char(p_txmsg.txfields('84').value),p_txmsg.txfields('12').value);

        ELSIF p_txmsg.tltxcd in ('1120','1134','1133') THEN -- GD CHUYEN KHOAN NOI BO, TRANG THAI = C
            INSERT INTO CIREMITTANCE (TXDATE, TXNUM, ACCTNO,BANKID, BENEFBANK, BENEFACCT, BENEFCUSTNAME, BENEFLICENSE,
                                        AMT, FEEAMT, DELTD, BENEFIDDATE, BENEFIDPLACE,FEETYPE,CITYEF, CITYBANK,RMSTATUS)
               VALUES (TO_DATE(p_txmsg.txdate,systemnums.c_date_format), p_txmsg.txnum,p_txmsg.txfields('03').value,
               p_txmsg.txfields('03').value,p_txmsg.txfields('89').value,p_txmsg.txfields('05').value,
               p_txmsg.txfields('93').value,p_txmsg.txfields('95').value,
               p_txmsg.txfields('10').value,0, 'N',
               TO_DATE(p_txmsg.txfields('98').value,systemnums.c_date_format),p_txmsg.txfields('99').value,'0','','','C');
        elsif p_txmsg.tltxcd in ('1135') THEN

            INSERT INTO CIREMITTANCE (TXDATE, TXNUM, ACCTNO,BENEFBANK, BENEFACCT, BENEFCUSTNAME,  AMT, FEEAMT, DELTD, CITYEF, CITYBANK,FEETYPE,VAT)
                      VALUES (TO_DATE(p_txmsg.txdate,systemnums.c_date_format), p_txmsg.txnum,p_txmsg.txfields('01').value,
                      p_txmsg.txfields('80').value,p_txmsg.txfields('81').value,
                      p_txmsg.txfields('82').value,
                      p_txmsg.txfields('10').value,p_txmsg.txfields('11').value, 'N',
                      to_char(p_txmsg.txfields('85').value),to_char(p_txmsg.txfields('84').value),to_char(p_txmsg.txfields('09').value),p_txmsg.txfields('12').value);
        ELSE
            v_dblFEEAMT:=p_txmsg.txfields('11').value+p_txmsg.txfields('12').value;

            --16/09/2015 DieuNDA: neu chuyen tien vuot han muc duyet hoac tai khoan ngan hang chuyen khong thuoc ngan hang BIDV thi day qua man hinh duyet rui ro
            select to_number(nvl(varvalue,'0')) into v_TRANSFERLIMIT from sysvar where grname='TCDT' and varname='BIDVLIMIT';

            if(p_txmsg.txfields('05').value is not null) then
                select count(*) into v_checkIsBIDV
                from CRBBANKLIST bkl, crbdefbank db
                where bkl.bankname like '%'||nvl(db.shortname,'xxxx')||'%' and db.bankcode in ('TCDTHCM','TCDTHN') and bkl.bankcode=p_txmsg.txfields('05').value; --18/03/2016 DieuNDA Them TCDTHN

                select count(*) into v_checkIsNotList
                from CRBBANKLIST bkl
                where  not exists (select * from crbdefbank db where bkl.bankname like '%'||nvl(db.shortname,'xxxx')||'%' and db.bankcode in ('TCDTHCM','TCDTHN')) --18/03/2016 DieuNDA Them TCDTHN
                and bkl.bankcode=p_txmsg.txfields('05').value;

                v_Bankcode:= p_txmsg.txfields('05').value;
            else
                select count(*) into v_checkIsBIDV
                from crbbankmap m, CRBBANKLIST bkl, crbdefbank db
                where m.bankcode=bkl.bankcode and bkl.bankname like '%'||nvl(db.shortname,'xxxx')||'%'
                    and db.bankcode in ('TCDTHCM','TCDTHN') and m.bankid=substr(p_txmsg.txfields('81').value,1,3);

                select count(*) into v_checkIsNotList
                from crbbankmap m, CRBBANKLIST bkl
                where m.bankcode=bkl.bankcode and m.bankid=substr(p_txmsg.txfields('81').value,1,3)
                    and not exists (select * from crbdefbank db where bkl.bankname like '%'||nvl(db.shortname,'xxxx')||'%' and db.bankcode in ('TCDTHCM','TCDTHN'));

                select  max(m.bankcode) into v_Bankcode
                from crbbankmap m, CRBBANKLIST bkl
                where m.bankcode=bkl.bankcode and m.bankid=substr(p_txmsg.txfields('81').value,1,3);
            end if;

            if (v_checkIsBIDV > 0  and p_txmsg.txfields('10').value >= v_TRANSFERLIMIT) or (v_checkIsNotList > 0) then
                v_CIREMITTANCE_RMSTATUS:='A';
                v_CRBTXREQ_STATUS := 'A';
            else
                v_CIREMITTANCE_RMSTATUS:='P';
                v_CRBTXREQ_STATUS :='P';
            end if;
            --End 16/09/2015 DieuNDA
            INSERT INTO CIREMITTANCE (TXDATE, TXNUM, ACCTNO,BANKID, BENEFBANK, BENEFACCT, BENEFCUSTNAME, BENEFLICENSE, AMT, FEEAMT, DELTD, BENEFIDDATE, BENEFIDPLACE,FEETYPE,CITYEF, CITYBANK,VAT,RMSTATUS)
                      VALUES (TO_DATE(p_txmsg.txdate,systemnums.c_date_format), p_txmsg.txnum,p_txmsg.txfields('03').value,
                      v_Bankcode,p_txmsg.txfields('80').value,p_txmsg.txfields('81').value,
                      p_txmsg.txfields('82').value,p_txmsg.txfields('83').value,
                      p_txmsg.txfields('10').value,p_txmsg.txfields('11').value, 'N',
                      TO_DATE(p_txmsg.txfields('95').value,systemnums.c_date_format),p_txmsg.txfields('96').value,to_char(p_txmsg.txfields('09').value),
                      to_char(p_txmsg.txfields('85').value),to_char(p_txmsg.txfields('84').value),p_txmsg.txfields('12').value,v_CIREMITTANCE_RMSTATUS);


            --Kiem tra neu Bankid ton tai trong bang CRBBANKTRFLIST thi gen
            if v_checkIsBIDV+v_checkIsNotList > 0 then
                for rec in (
                    select * from crbbanklist
                    where (case when BANKCODE='NULL' then BANKNAME else BANKCODE END) = v_Bankcode
                           and rownum <= 1
                )
                loop
                    select seq_CRBTXREQ.nextval into v_strREFAUTOID from dual;
                    if p_txmsg.tltxcd in ('1101','1111','1179') then
                        v_dblTRFAMT:= TO_NUMBER(p_txmsg.txfields('13').value) - TO_NUMBER(p_txmsg.txfields('11').value) - TO_NUMBER(p_txmsg.txfields('12').value);
                    else
                        v_dblTRFAMT:= TO_NUMBER(p_txmsg.txfields('13').value);
                    end if;

                    --TruongLD Add 22/08/2015 - PHS khong phan biet chi nhanh mac dinh la TCDT
                    /*if substr(p_txmsg.txfields('03').value,1,4) ='0101' then
                        v_strBANKCODE:='TCDTHN';
                    elsif substr(p_txmsg.txfields('03').value,1,4) ='0001'   then
                        v_strBANKCODE:='TCDTHCM';
                    else
                        v_strBANKCODE:='TCDT';
                    end if;*/

                    --v_strBANKCODE:='TCDTHCM';
                    select varvalue into v_bridBIDVHN from sysvar where grname='TCDT' and varname='BIDVBRGRPLIST' and rownum <= 1 ;

                    if instr(v_bridBIDVHN,substr(p_txmsg.txfields('03').value,1,4)) > 0 then
                        v_strBANKCODE:='TCDTHN';
                    else
                        v_strBANKCODE:='TCDTHCM';
                    end if;
                    --End TruongLD

                   /* INSERT INTO CRBTXREQ (REQID, OBJTYPE, OBJNAME, OBJKEY, TRFCODE, REFCODE, TXDATE, AFFECTDATE, AFACCTNO, TXAMT, BANKCODE, BANKACCT, STATUS, REFVAL, NOTES, VIA,DIRBANKCODE,DIRBANKNAME,DIRBANKCITY,DIRACCNAME)
                       VALUES (v_strREFAUTOID, 'T', p_txmsg.tltxcd,p_txmsg.txnum, 'TCDT', to_char(p_txmsg.txdate,'DD/MM/RRRR') || p_txmsg.txnum, TO_DATE(p_txmsg.txdate, 'dd/mm/rrrr'), TO_DATE(p_txmsg.txdate , 'dd/mm/rrrr'),
                               p_txmsg.txfields('03').value , v_dblTRFAMT , v_strBANKCODE,p_txmsg.txfields('81').value,
                               --'P',
                               v_CRBTXREQ_STATUS,
                               NULL,p_txmsg.txfields('30').value,'DIR',v_Bankcode,p_txmsg.txfields('80').value,p_txmsg.txfields('85').value,p_txmsg.txfields('82').value);*/
                    --16/09/2015 DieuNDA: khong cap nhat lai trang thai o doan nay
                    /*UPDATE CIREMITTANCE
                      SET RMSTATUS='P'
                      WHERE TXDATE=TO_DATE(p_txmsg.txdate,systemnums.c_date_format) AND TXNUM=p_txmsg.txnum and ACCTNO=p_txmsg.txfields('03').value;
                      */
                    --End 16/09/2015 DieuNDA
                    EXIT;
                    EXIT;
                end loop;
            end if;
        END IF;
    else
        SELECT count(1) into v_count FROM CIREMITTANCE WHERE TXDATE=TO_DATE(p_txmsg.txdate,systemnums.c_date_format) AND TXNUM=p_txmsg.txnum AND RMSTATUS not in ('C','R') and deltd <> 'Y';
        if not v_count>0 then
            
            p_err_code :=errnums.C_CI_REMITTANCE_CLOSE;
            return l_lngErrCode;
        else
            UPDATE CIREMITTANCE SET DELTD='Y' WHERE TXDATE=TO_DATE(p_txmsg.txdate,systemnums.c_date_format) AND TXNUM=p_txmsg.txnum;
            UPDATE CRBTXREQ SET STATUS = 'R', ERRORDESC = 'Xoa giao dich'  WHERE TXDATE=TO_DATE(p_txmsg.txdate,systemnums.c_date_format) AND objkey=p_txmsg.txnum;
        end if;
    end if;
    plog.debug (pkgctx, '<<END OF fn_GenRemittanceTrans');
    plog.setendsection (pkgctx, 'fn_GenRemittanceTrans');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
       plog.setendsection (pkgctx, 'fn_GenRemittanceTrans');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_GenRemittanceTrans;



---------------------------------fn_FeeDepositoryMaturityBackdate------------------------------------------------
FUNCTION fn_FeeDepoMaturityBackdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
v_blnREVERSAL boolean;
l_lngErrCode    number(20,0);
v_count number(20,0);
v_afacctno VARCHAR2(10);
v_Safacctno VARCHAR2(10); --tieu khoan send
V_Sseacctno VARCHAR2(20); --tieu khoan chung khoan send
v_dblAMT NUMBER;
v_todate DATE;
v_frdatetemp DATE;
v_todatetemp DATE;
v_dblamttemp NUMBER;
v_dblamtacr NUMBER;
v_dateEOMtemp DATE;
v_EOMtemp varchar2(5);
v_DOMtemp varchar2(5);
v_TBALDT DATE;
v_lastDP varchar(5);
v_datelastDP DATE;
v_count_days NUMBER;
V_txdate DATE;
l_txnum VARCHAR2(30);
V_seacctno VARCHAR2(20);
L_QTTY NUMBER(20,0);
v_EOMtemp2 DATE;
v_frdate DATE;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_FeeDepositoryMaturityBackdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_FeeDepositoryMaturityBackdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    v_blnREVERSAL:=case when p_txmsg.deltd ='Y' then true else false end;
    l_lngErrCode:= errnums.C_BIZ_RULE_INVALID;
    p_err_code:=0;
    -- case cac truong cho cac jao dich
    if( p_txmsg.tltxcd='2246') THEN
     v_afacctno:=p_txmsg.txfields('02').VALUE;
     v_seacctno:=p_txmsg.txfields('03').VALUE;
     L_QTTY:=TO_NUMBER(p_txmsg.txfields('12').VALUE);
     ELSIF(p_txmsg.tltxcd='8879') THEN
        v_afacctno:=p_txmsg.txfields('07').VALUE;
        v_seacctno:=p_txmsg.txfields('08').VALUE;
        L_QTTY:=TO_NUMBER(p_txmsg.txfields('10').VALUE);
     ELSIF(p_txmsg.tltxcd='2205') THEN
        v_afacctno := p_txmsg.txfields('04').VALUE;
        v_seacctno := p_txmsg.txfields('03').VALUE;
        L_QTTY     := TO_NUMBER(p_txmsg.txfields('10').VALUE);
     ELSIF( p_txmsg.tltxcd IN ('3351')) THEN
        v_afacctno := p_txmsg.txfields('03').VALUE;
        V_seacctno := p_txmsg.txfields('08').VALUE;
        L_QTTY     := TO_NUMBER(p_txmsg.txfields('11').VALUE);
    ELSE
    v_afacctno:=p_txmsg.txfields('04').VALUE;
     v_seacctno:=p_txmsg.txfields('05').VALUE;
     L_QTTY:=TO_NUMBER(p_txmsg.txfields('10').VALUE);
    END IF;
    IF (p_txmsg.tltxcd='8879') THEN
       v_dblAMT:=p_txmsg.txfields('17').VALUE;
    ELSIF (p_txmsg.tltxcd IN ('3351')) THEN
       v_dblAMT:=p_txmsg.txfields('25').VALUE;
      ELSE
       v_dblAMT:=p_txmsg.txfields('15').VALUE;
    END IF;

    IF LENGTH(v_afacctno)IS NULL OR LENGTH(v_afacctno) <= 1 THEN
        
        SELECT DEPOLASTDT, TO_CHAR(DEPOLASTDT,'DD') INTO v_todate,v_lastDP  FROM DDMAST WHERE AFACCTNO = v_Safacctno AND ROWNUM = 1;
    ELSE
        
        SELECT DEPOLASTDT, TO_CHAR(DEPOLASTDT,'DD') INTO v_todate,v_lastDP  FROM DDMAST WHERE AFACCTNO =v_afacctno AND ROWNUM = 1;
    END IF;
    v_frdatetemp:=to_date( p_txmsg.busdate,'DD/MM/RRRR');
    v_frdate:=to_date( p_txmsg.busdate,'DD/MM/RRRR');
    v_dblamtacr:=0;

    SELECT VARVALUE INTO  v_DOMtemp
    FROM SYSVAR
    WHERE VARNAME IN ('DAYFEEDEPOSIT');

    SELECT VARVALUE INTO  v_EOMtemp
    FROM SYSVAR
    WHERE VARNAME IN ('EOMFEEDEPOSIT');
    -- khai cac bien de log vao sedepobal
    --v_TBALDT:= Greatest(to_date ( p_txmsg.txfields('32').value,'DD/MM/RRRR')+1, p_txmsg.busdate);
    V_txdate:=TO_DATE(p_txmsg.txdate,'DD/MM/RRRR');
    l_txnum:=p_txmsg.txnum;
    if not v_blnREVERSAL THEN
      --CHieu  thuan giao dich
      -- select ra cac moc thu phi lk den han
      plog.debug(pkgctx,'busdate ' || to_date(p_txmsg.busdate,'DD/MM/RRRR') || ' todate '||to_date(v_todate,'DD/MM/RRRR'));
      FOR rec IN
      (SELECT   DISTINCT TO_CHAR(TO_DATE (SBDATE, 'DD/MM/RRRR'),'MM/RRRR') SBDATE
         FROM   SBCLDR
        WHERE   SBDATE >= TO_DATE (v_frdate, 'DD/MM/RRRR')
            AND SBDATE <= TO_DATE (v_todate, 'DD/MM/RRRR')
            AND CLDRTYPE = '000'
        ORDER BY   SBDATE)
      LOOP
         plog.debug(pkgctx,'first' || rec.sbdate || ' busdate ' || to_date(p_txmsg.busdate,'DD/MM/RRRR') ||' to_Date' ||  to_date(v_todate,'DD/MM/RRRR'));
        v_EOMtemp2 := ADD_MONTHS(TRUNC(to_date(rec.sbdate,'MM/RRRR'), 'MM'), 1)-1;
        IF to_number(v_lastDP) > to_number(to_char(v_EOMtemp2,'DD')) THEN
            v_lastDP := to_char(v_EOMtemp2,'DD');
        END IF;
        v_datelastDP := TO_DATE(v_lastDP||'/'||rec.sbdate,'DD/MM/RRRR');

        
        --SONLT 20140423 LAY NGAY TINH PHI LUU KY
        IF  v_EOMtemp = 'Y' THEN
            -- lay ra ngay cuoi cung cua thang
            SELECT ADD_MONTHS(TRUNC(v_datelastDP, 'MM'), 1) -1 INTO v_dateEOMtemp FROM DUAL;
        ELSE
            -- lay ra ngay thu phi luu ky
            v_dateEOMtemp := v_datelastDP;
        END IF;
        --sua lai ghi nhan phi den ngay cuoi thang thay vi den ngay lam viec cuoi thang
        --SELECT GET_SYS_PREWORKINGDATE(v_dateEOMtemp) INTO v_dateEOMtemp FROM DUAL;
        --END SONLT 20140423 LAY NGAY TINH PHI LUU KY
        v_todatetemp:= least(to_Date(v_dateEOMtemp,'DD/MM/RRRR'),v_todate);

        if(v_todatetemp <> v_todate) THEN
            v_dblamttemp:=round( (v_todatetemp-v_frdatetemp+1)/(v_todate-p_txmsg.busdate+1)* v_dblAMT,0);
            v_dblamtacr:=v_dblamtacr+v_dblamttemp;
        ELSE -- neu la thang backdate gan nhat: lay tong- cac thang truoc: tranh sai so
            v_dblamttemp:=round (v_dblAMT-v_dblamtacr,0);
        END IF;

        --if(v_todatetemp <> v_frdatetemp) then
        INSERT INTO CIFEESCHD (AUTOID, AFACCTNO, FEETYPE, TXNUM, TXDATE, NMLAMT, PAIDAMT, FLOATAMT, FRDATE, TODATE, REFACCTNO, DELTD)
         VALUES (SEQ_CIFEESCHD.nextval,v_afacctno,'VSDDEP',p_txmsg.txnum,to_date(p_txmsg.txdate,'DD/MM/RRRR'),v_dblamttemp,0,0,v_frdatetemp,v_todatetemp,'','N');
        -- log them mot dong SEDEPOBAL

        INSERT INTO SEDEPOBAL (AUTOID, ACCTNO, TXDATE, DAYS, QTTY, DELTD,ID,AMT)
         VALUES (SEQ_SEDEPOBAL.NEXTVAL, v_seacctno,v_frdatetemp,v_todatetemp-v_frdatetemp+1,L_QTTY, 'N',to_char(v_txdate)||l_txnum,v_dblamttemp);
        v_frdatetemp:=to_Date(v_todatetemp,'DD/MM/RRRR')+1;
        END LOOP;
    else
       -- xoa giao dich
       UPDATE cifeeschd SET deltd='Y'  WHERE TXNUM = p_txmsg.txnum AND TXDATE = to_date(p_txmsg.txdate,'DD/MM/RRRR');
       UPDATE sedepobal SET deltd='Y' WHERE id=to_char(V_txdate)||l_txnum ;
    end if;
    plog.debug (pkgctx, '<<END OF fn_FeeDepositoryMaturityBackdate');
    plog.setendsection (pkgctx, 'fn_FeeDepositoryMaturityBackdate');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
       plog.setendsection (pkgctx, 'fn_FeeDepositoryMaturityBackdate');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_FeeDepoMaturityBackdate;

FUNCTION fn_FeeDepoDebit(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
v_blnREVERSAL boolean;
l_lngErrCode    number(20,0);
v_count number(20,0);
v_afacctno VARCHAR2(10);
v_dblAMT NUMBER;

V_txdate DATE;
l_txnum VARCHAR2(30);
V_seacctno VARCHAR2(20);

BEGIN
    plog.setbeginsection (pkgctx, 'fn_FeeDepoDebit');
    plog.debug (pkgctx, '<<BEGIN OF fn_FeeDepoDebit');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    l_lngErrCode:= errnums.C_BIZ_RULE_INVALID;
    p_err_code:=0;
    v_dblAMT:=0;
    -- case cac truong cho cac jao dich
    v_afacctno:=p_txmsg.txfields('04').VALUE;
    v_seacctno:=p_txmsg.txfields('05').VALUE;

    V_txdate:=TO_DATE(p_txmsg.txdate,'DD/MM/RRRR');
    l_txnum:=p_txmsg.txnum;
    v_dblAMT:=p_txmsg.txfields('45').VALUE; --+p_txmsg.txfields('55').VALUE;

  IF  P_TXMSG.DELTD <> 'Y' THEN

   INSERT INTO CIFEESCHD (AUTOID, AFACCTNO, FEETYPE, TXNUM, TXDATE, NMLAMT, PAIDAMT, FLOATAMT,  REFACCTNO, DELTD)
   VALUES (SEQ_CIFEESCHD.nextval,v_afacctno,'FEEDR',p_txmsg.txnum,to_date(p_txmsg.txdate,'DD/MM/RRRR'),v_dblAMT,0,0,'','N');

  ELSE
       -- xoa giao dich
       UPDATE cifeeschd SET deltd='Y'  WHERE TXNUM = p_txmsg.txnum AND TXDATE = to_date(p_txmsg.txdate,'DD/MM/RRRR');

 END IF;
    plog.debug (pkgctx, '<<END OF fn_FeeDepositoryMaturityBackdate');
    plog.setendsection (pkgctx, 'fn_FeeDepositoryMaturityBackdate');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
       plog.setendsection (pkgctx, 'fn_FeeDepositoryMaturityBackdate');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_FeeDepoDebit;

FUNCTION fn_cidatedepofeeacr(strCLOSETYPE in varchar2,strCUSTODYCD IN varchar2, strAFACCTNO in varchar2, strNumDATE IN  NUMBER)
  RETURN  number
  IS

  v_Result  number(20);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_cidatedepofeeacr');
    plog.debug (pkgctx, '<<BEGIN OF fn_cidatedepofeeacr');
    if strCLOSETYPE = '001' then
        SELECT nvl(sum(nvl(FEEACR,0)),0)
        INTO v_Result
        FROM CFMAST CF, AFMAST AF,
            (SELECT A2.AFACCTNO,
                SUM(DECODE(A2.FORP,'P',A2.FEEAMT/100,A2.FEEAMT)*A2.SEBAL*strNumDATE/(A2.LOTDAY*A2.LOTVAL)) FEEACR
                FROM (SELECT T.ACCTNO, MIN(T.ODRNUM) RFNUM FROM VW_SEMAST_VSDDEP_FEETERM T GROUP BY T.ACCTNO) A1,
                VW_SEMAST_VSDDEP_FEETERM A2 WHERE A1.ACCTNO=A2.ACCTNO AND A1.RFNUM=A2.ODRNUM GROUP BY A2.AFACCTNO) T2
        WHERE CF.custid = af.custid and af.acctno = T2.AFACCTNO AND CF.CUSTODYCD = strCUSTODYCD;
    else
        SELECT nvl(sum(nvl(FEEACR,0)),0)
        INTO v_Result
        FROM (SELECT A2.AFACCTNO,
                SUM(DECODE(A2.FORP,'P',A2.FEEAMT/100,A2.FEEAMT)*A2.SEBAL*strNumDATE/(A2.LOTDAY*A2.LOTVAL)) FEEACR
                FROM (SELECT T.ACCTNO, MIN(T.ODRNUM) RFNUM FROM VW_SEMAST_VSDDEP_FEETERM T GROUP BY T.ACCTNO) A1,
                VW_SEMAST_VSDDEP_FEETERM A2 WHERE A1.ACCTNO=A2.ACCTNO AND A1.RFNUM=A2.ODRNUM GROUP BY A2.AFACCTNO) T2
        WHERE T2.AFACCTNO = strAFACCTNO;
    end if;
    plog.debug (pkgctx, '<<END OF fn_cidatedepofeeacr');
    plog.setendsection (pkgctx, 'fn_cidatedepofeeacr');
    RETURN v_result;
EXCEPTION
WHEN OTHERS
   THEN
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'fn_cidatedepofeeacr');
      RETURN 0;
END fn_cidatedepofeeacr;

FUNCTION fn_CIGetDePoFeeToClose(strACCTNO IN varchar2, strDays IN NUMBER)
  RETURN  number
  IS
  l_Days  number(20,0);
  l_strAFACCTNO VARCHAR2(10);
  v_Result      number(20,3);
BEGIN

    l_strAFACCTNO := strACCTNO;
    l_Days        := strDays;

   Begin

       SELECT SUM(round((DECODE(SE.FORP,'P',SE.FEEAMT/100,SE.FEEAMT)*SE.SEBAL*l_Days/(SE.LOTDAY*SE.LOTVAL)),3)) into v_Result
       FROM VW_SEMAST_VSDDEP_FEETERM SE
       WHERE EXISTS
             (
                 SELECT T.AFACCTNO, MIN(T.ODRNUM) RFNUM
                 FROM VW_SEMAST_VSDDEP_FEETERM T
                 WHERE T.ACCTNO = SE.ACCTNO
                 GROUP BY T.AFACCTNO
                 HAVING MIN(T.ODRNUM) = SE.ODRNUM
             )
             AND SE.AFACCTNO = l_strAFACCTNO AND SE.SEBAL > 0;
   EXCEPTION
        WHEN OTHERS THEN  v_Result:= 0;
   end;

   RETURN nvl(v_Result,0);

EXCEPTION
   WHEN OTHERS THEN
    plog.debug (pkgctx,'got error on line:' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
    plog.setendsection (pkgctx, 'fn_CIGetDePoFeeToClose');
    RETURN 0;
END fn_CIGetDePoFeeToClose;

FUNCTION fn_GetDaysToAddFee(strDate IN varchar2, Days IN number) RETURN number
 IS
  l_strDate VARCHAR2(10);
  l_Days    number(10);
  v_TODATE  VARCHAR2(10);
  v_Result      number(10);
 BEGIN
    l_strDate        := strDate;
    l_Days           := Days;

    begin

       SELECT COUNT(1) into v_Result
       FROM sbcldr S1,
       (
         SELECT To_Date(min(sbdate),'DD/MM/RRRR') MINDATE
         FROM sbcldr
         WHERE sbdate >= to_date(l_strDate,'DD/MM/RRRR') + l_Days - 1
                 AND holiday = 'N' AND cldrtype = '000' ORDER BY sbdate
       ) S2
       WHERE S1.sbdate BETWEEN to_date(l_strDate,'DD/MM/RRRR') AND S2.MINDATE
            AND holiday = 'Y' AND cldrtype = '000' ;

       v_Result := v_Result + l_Days;

    EXCEPTION
        WHEN OTHERS THEN  v_Result:= 0;
    end;

    RETURN v_Result;
 EXCEPTION
   WHEN OTHERS THEN
    plog.debug (pkgctx,'got error on line:' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
    plog.setendsection (pkgctx, 'fn_GetDaysToAddFee');
    RETURN 0;
END fn_GetDaysToAddFee;

PROCEDURE Pr_FeebookingResultAuto(p_bchmdl varchar,p_err_code  OUT varchar2,p_FromRow number,p_ToRow number, p_lastRun OUT varchar2)
IS
V_TXDATE DATE;
V_LASTMONTH DATE;
V_FIRSTMONTH DATE;
l_txmsg tx.msg_rectype;
p_batchname varchar2(20);
l_err_param   varchar2(1000);
l_FromRow   varchar2(20);
l_ToRow   varchar2(20);
l_MaxRow NUMBER(20,0);
V_MONTHDATE DATE;
BEGIN
    plog.setbeginsection (pkgctx, 'Pr_FeebookingResultAuto');
    plog.debug (pkgctx, '<<BEGIN OF Pr_FeebookingResultAuto');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    p_err_code:=0;
    --SELECT COUNT(*) MAXROW into l_MaxRow FROM  VW_FEETRAN_ALL WHERE STATUS = 'N' AND DELTD <> 'Y' AND FEETYPES NOT IN ('SETRAN','ASSETMNG','BONDMNG','PAYAGENCY','BONDOTHER');
    SELECT COUNT(*) MAXROW into l_MaxRow FROM  VW_FEETRAN_ALL;
    IF l_MaxRow > p_ToRow THEN
        p_lastRun:='N';
    ELSE
        p_lastRun:='Y';
    END IF;
    p_batchname:='BATCHFEEAUTO';
    V_TXDATE:= getcurrdate;
    SELECT GET_SYS_PREWORKINGDATE(TO_DATE(V_TXDATE,'DD/MM/RRRR')) INTO V_MONTHDATE FROM DUAL;
    SELECT GET_SYS_PREWORKINGDATE(LAST_DAY(TO_DATE(V_MONTHDATE,'DD/MM/RRRR')))INTO V_LASTMONTH FROM DUAL;
    SELECT trunc(TO_DATE(V_LASTMONTH,'DD/MM/RRRR'),'MONTH') INTO V_FIRSTMONTH FROM DUAL;
    IF V_MONTHDATE=V_LASTMONTH THEN

        FOR REC IN
        (
            SELECT MST.FEECODE,MST.TXDATE POSTDATE, TO_CHAR(MST.TXDATE,'MM/YYYY') BILLINGMONTH, MST.TXNUM, MST.FEETYPES FEETYPE,MST.SUBTYPE,
                MST.CUSTODYCD,CF.CIFID PROFOLIOCD,CF.FULLNAME CUSTNAME,MST.FEEAMT,MST.CCYCD, SUBSTR(MST.TRDESC,1,200) DESCRIPTION
            FROM (SELECT * FROM (SELECT A.*, ROWNUM ID FROM VW_FEETRAN_ALL A) WHERE ID BETWEEN p_FromRow AND p_ToRow) MST, CFMAST CF
            WHERE MST.STATUS = 'N'
            AND MST.DELTD <> 'Y'
            AND MST.CUSTODYCD=CF.CUSTODYCD(+)
            and cf.bondagent <> 'Y' --trung.luu: 08/06/2020 SHBVNEX-1073 Kh?ng ti?nh d??i vo?i kha?ch ha`ng Bondagent = Yes
            AND MST.FEETYPES NOT IN ('SETRAN','ASSETMNG','BONDMNG','PAYAGENCY','BONDOTHER')
            AND MST.TXDATE >= V_FIRSTMONTH AND MST.TXDATE <= V_LASTMONTH
        ) loop

                    l_txmsg.tltxcd := '1296';
                    l_txmsg.msgtype := 'T';
                    l_txmsg.local   := 'N';
                    l_txmsg.tlid    := systemnums.c_system_userid;
                    select sys_context('USERENV', 'HOST'),
                         sys_context('USERENV', 'IP_ADDRESS', 15)
                    into l_txmsg.wsname, l_txmsg.ipaddress
                    from dual;
                    l_txmsg.off_line  := 'N';
                    l_txmsg.deltd     := txnums.c_deltd_txnormal;
                    l_txmsg.txstatus  := txstatusnums.c_txcompleted;
                    l_txmsg.msgsts    := '0';
                    l_txmsg.ovrsts    := '0';
                    l_txmsg.batchname := p_batchname;
                    l_txmsg.busdate   := V_TXDATE;
                    l_txmsg.txdate    := V_TXDATE;
                    select systemnums.c_batch_prefixed || lpad(seq_batchtxnum.nextval, 8, '0')
                    into l_txmsg.txnum
                    from dual;
                    select to_char(sysdate, 'hh24:mi:ss') into l_txmsg.txtime from dual;
                    --trung.luu: 29-03-2021 log lai khi auto booking phi qua aither
                    insert into auto_fee_booking_batch_log(autoid, feetran_txdate, feetran_txnum, txnum_1296, busdate_1296, custodycd, feecode, batch_date)
                    values(seq_auto_fee_booking_batch_log.NEXTVAL,rec.POSTDATE,rec.TXNUM,l_txmsg.txnum,V_TXDATE,rec.CUSTODYCD,rec.FEECODE,getcurrdate);

                    --20 POSTDATE
                         l_txmsg.txfields ('20').defname   := 'POSTDATE';
                         l_txmsg.txfields ('20').TYPE      := 'D';
                         l_txmsg.txfields ('20').value      := rec.POSTDATE;
                    --87 TXNUM
                         l_txmsg.txfields ('87').defname   := 'TXNUM';
                         l_txmsg.txfields ('87').TYPE      := 'C';
                         l_txmsg.txfields ('87').value      := rec.TXNUM;
                    --30 DESC
                         l_txmsg.txfields ('30').defname   := 'DESC';
                         l_txmsg.txfields ('30').TYPE      := 'C';
                         l_txmsg.txfields ('30').value      := rec.DESCRIPTION;
                    --88 DESC
                         l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                         l_txmsg.txfields ('88').TYPE      := 'C';
                         l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
                    --22 FEECODE
                         l_txmsg.txfields ('22').defname   := 'FEECODE';
                         l_txmsg.txfields ('22').TYPE      := 'C';
                         l_txmsg.txfields ('22').value      := rec.FEECODE;
                    begin
                      if txpks_#1296.fn_batchtxprocess(l_txmsg, p_err_code, l_err_param) <> systemnums.c_success then
                        rollback;
                        
                      else
                        commit;
                      end if;
                    end;
        end loop;
    END IF;
    plog.debug (pkgctx, '<<END OF Pr_FeebookingResultAuto');
    plog.setendsection (pkgctx, 'Pr_FeebookingResultAuto');
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
       plog.setendsection (pkgctx, 'Pr_FeebookingResultAuto');
      RAISE errnums.E_SYSTEM_ERROR;
END Pr_FeebookingResultAuto;

-- initial LOG
BEGIN
   SELECT *
   INTO logrow
   FROM tlogdebug
   WHERE ROWNUM <= 1;

   pkgctx    :=
      plog.init ('cspks_ciproc',
                 plevel => logrow.loglevel,
                 plogtable => (logrow.log4table = 'Y'),
                 palert => (logrow.log4alert = 'Y'),
                 ptrace => (logrow.log4trace = 'Y')
      );
END;
/
