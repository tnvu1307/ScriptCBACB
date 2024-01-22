SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE sp_get_amtvat (pv_camastid in VARCHAR2,pv_custodycd in VARCHAR2 )
IS
/*==============================================
creater             createdate
thunt               06/01/2020
===============================================*/
    pkgctx plog.log_ctx;
    logrow tlogdebug%ROWTYPE;
    v_result  number;
    v_amt number;
    l_exerciseratio   number;
    l_catype          varchar2(20);
    l_codeid varchar2(10);
    l_camastid varchar2(50);
    l_vat varchar2(1);
    l_pitratemethod varchar2(50);
    l_pitrate number;
    l_intamt number;
    l_balance number;
    l_exprice number;
    l_amtdtl number;
    l_amt number;
    l_ddacctno varchar2(100);
    v_vat number;
BEGIN
/*============================================================*/
    select catype,codeid into l_catype,l_codeid from camast where camastid = replace(pv_camastid,'.','');
    select  to_number(SUBSTR(EXERCISERATIO,0,INSTR(EXERCISERATIO,'/') - 1))/to_number(SUBSTR(EXERCISERATIO,INSTR(EXERCISERATIO,'/')+1,LENGTH(EXERCISERATIO)))  into l_exerciseratio
    from sbsecurities
    where codeid = l_codeid;

    select acctno into l_ddacctno
    from DDMAST
    where custodycd=pv_custodycd and isdefault='Y' and status<>'C';

    SELECT CF.VAT,CAMAST.PITRATEMETHOD,CAMAST.CATYPE,CAMAST.PITRATE,CA.INTAMT,CA.BALANCE,CAMAST.EXPRICE,CA.AMTDTL,CA.AMT
    INTO l_vat,l_pitratemethod,l_catype,l_pitrate,l_intamt,l_balance,l_exprice,l_amtdtl,l_amt
    FROM SBSECURITIES SYM, SBSECURITIES EXSYM, CAMAST, AFMAST AF,
        CFMAST CF , AFTYPE TYP, SYSVAR SYS, SEMAST SE,
        (SELECT * FROM CAMASTDTL WHERE DELTD <> 'Y' AND STATUS ='P') CAD,
        (SELECT CA1.*,  NVL(CSD.FEEAMT,0) TRFEEAMT, CSD.AMT AMTDTL
            FROM CASCHD CA1, (SELECT CSD1.* FROM CASCHDDTL CSD1 WHERE CSD1.DELTD <> 'Y' AND CSD1.STATUS ='P') CSD
            WHERE CA1.DELTD <> 'Y'
                  AND CA1.AUTOID = CSD.autoid_caschd (+)
                  AND CA1.afacctno = CSD.afacctno (+)
        ) CA
    WHERE CA.CAMASTID = CAMAST.CAMASTID AND CAMAST.CODEID = SYM.CODEID
         AND CAMAST.CAMASTID = CAD.CAMASTID (+)
         AND NVL(CAMAST.EXCODEID,CAMAST.CODEID)  = EXSYM.CODEID
         AND CA.AFACCTNO = AF.ACCTNO AND AF.CUSTID = CF.CUSTID
         AND CA.DELTD = 'N' AND CA.STATUS IN ('S','H','W','K','I') AND CAMAST.STATUS  IN ('K','I','H')-- AND CA.ISCI ='N' --AND CA.ISSE='N'
         AND CA.AMT > 0 AND CA.ISEXEC='Y'
         AND SE.ACCTNO(+)= CA.AFACCTNO||CA.CODEID
         AND AF.ACTYPE = TYP.ACTYPE AND SYS.GRNAME='SYSTEM' AND SYS.VARNAME='CADUTY'
         AND replace(CAMAST.CAMASTID,'.','') = replace(pv_camastid,'.','');
/*============================================================*/
        IF l_vat='Y' THEN
            v_Result:=l_amt;
        else
            IF l_vat='Y' THEN
                IF  l_pitratemethod='NO' THEN
                    v_vat:=0;
                ELSIF l_catype IN ('016','023','033') THEN
                    v_vat:=round(l_pitrate*l_intamt/100);
                ELSIF l_CATYPE IN ('024') THEN
                    v_vat:=l_balance*l_exprice*l_pitrate/100/l_exerciseratio;
                ELSIF l_CATYPE IN ('010') THEN
                    v_vat:=  round(l_pitrate*l_amtdtl/100);
                ELSE
                    v_vat:=round(l_pitrate*l_amt/100);
                END IF;
            ELSE
                v_vat:=0;
            END IF;
            v_Result:=l_amt-v_vat;
        end if;
        UPDATE DDMAST
         SET
           LASTCHANGE = TO_DATE(getcurrdate(), systemnums.C_DATE_FORMAT),
           RECEIVING = RECEIVING - v_Result, LAST_CHANGE = SYSTIMESTAMP
        WHERE ACCTNO=l_ddacctno;
plog.error('sp_get_amtvat: '||l_ddacctno||'|pv_camastid:'||pv_camastid||'|v_Result: '||v_Result);
EXCEPTION
  WHEN OTHERS THEN
      PLOG.ERROR(SQLERRM || dbms_utility.format_error_backtrace);
END;
/
