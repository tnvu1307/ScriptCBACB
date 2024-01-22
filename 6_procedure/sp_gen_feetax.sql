SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE sp_gen_feetax (p_txdate in VARCHAR2,p_custodycd in VARCHAR2, p_feecode in varchar2, p_txdatebatch in VARCHAR2, p_txnumbatch in varchar2)
IS
/*==============================================
creater             createdate
thunt               06/01/2020
===============================================*/
    pkgctx plog.log_ctx;
    logrow tlogdebug%ROWTYPE;
    l_txdate date;
    l_txdatebatch date;
    l_txdatebatchtran date;
    l_txnumbatch varchar2(20);
    l_rbankaccount varchar2(50);
    l_custodycdfeecode  varchar2(100);
    l_monthdate date;
    l_feebookingid number;
BEGIN
    l_txdate:=to_date(trim(p_txdate),systemnums.C_DATE_FORMAT);
    l_txdatebatch:=to_date(trim(p_txdatebatch),systemnums.C_DATE_FORMAT);
    l_txnumbatch:=trim(p_txnumbatch);
    l_custodycdfeecode:=trim(p_custodycd||p_feecode);



    SELECT GET_SYS_PREWORKINGDATE(TO_DATE(l_txdate,'DD/MM/RRRR')) INTO l_monthdate FROM DUAL;
    SELECT GET_SYS_PREWORKINGDATE(LAST_DAY(TO_DATE(l_monthdate,'DD/MM/RRRR')))INTO l_txdatebatchtran FROM DUAL;
    --
    select bankacctno into l_rbankaccount
    from banknostro
    where banktrans='OUTTRFCACASH';
    --

    BEGIN
        l_feebookingid:=seq_fee_booking_result.nextval;
        INSERT INTO FEE_BOOKING_RESULT (AUTOID,GRAUTOID,BANKACCOUNT,CIFID,CURRENCY,REMARK,FEEAMOUNT,FXRATE,FXAMOUNT,NOSTROACCOUNT,STATUS,
            BANKGLOBALID,TRANSDATE,SETTLEDATE,FEETYPE,FEECODE,FEETXDATE,FEETXNUM,TXDATE,TAXAMOUNT,FEENAME,MCIFID)
        SELECT seq_fee_booking_result.nextval, l_feebookingid,
               (CASE WHEN NVL(CF.SETTLETYPE, '60') = '60' THEN NOSTRO.BANKACCTNO ELSE DD.REFCASAACCT END) BANKACCOUNT,
               cf.cifid CIFID,fee.ccycd CURRENCY,
               'Fee of ' || to_char(l_txdatebatchtran,'MM/RRRR') || (CASE WHEN NVL(FA.SHORTNAME, 'xxx') = 'xxx' THEN '' ELSE ' - ' || FA.SHORTNAME END) || ' - ' || cf.custodycd REMARK,
               fee.feeamt FEEAMOUNT,
               1 FXRATE,
               fee.feeamt FXAMOUNT,
               l_rbankaccount NOSTROACCOUNT, 'P' STATUS,
               fn_getglobalid(l_txdatebatch,l_txnumbatch) BANKGLOBALID,
               null TRANSDATE,
               null SETTLEDATE,
               fee.feecode FEETYPE,
               fee.feecode FEECODE, null FEETXDATE, null FEETXNUM,
               l_txdate TXDATE,fee.vatamt TAXAMOUNT,al.cdcontent FEENAME,cf.mcifid --trung.luu: 28-04-2021 SHBVNEX-2161 khong co mastercif thi de null
        FROM  cfmast cf, allcode al,
        (
            SELECT * FROM DDMAST WHERE PAYMENTFEE = 'Y' AND STATUS <> 'C'
        ) DD,
        (
            SELECT BANKACCTNO, 'VND' CCYCD FROM BANKNOSTRO WHERE BANKTRANS = 'OUTTRFMONFEESETTVND' AND ROWNUM = 1
            UNION ALL
            SELECT BANKACCTNO, 'USD' CCYCD FROM BANKNOSTRO WHERE BANKTRANS = 'OUTTRFMONFEESETTUSD' AND ROWNUM = 1
        ) NOSTRO,
        (
            SELECT * FROM FAMEMBERS WHERE ROLES = 'AMC' AND ACTIVESTATUS = 'Y'
        ) FA,
        (
            select f.feecode,f.custodycd,f.ccycd,round(sum(f.feeamt),2) feeamt,round(sum(f.feerate),2) feerate,
                round(sum(f.vatrate),2) vatrate,round(sum(f.vatamt),2) vatamt
            from feetran f
            where f.status ='N' and f.deltd <>'Y' and (f.pautoid is not null or f.type='F')
            group by f.feecode,f.custodycd,f.ccycd
        ) fee
         WHERE fee.custodycd||fee.feecode= l_custodycdfeecode
            and cf.custodycd=dd.custodycd(+) --trung.luu: 16-03-2021 SHBVNEX-1594 khong can tai khoan tien hoac tai khoan tien mac dinh
            and cf.amcid = fa.autoid(+)  --trung.luu: 22/06/2021  SHBVNEX-2081 thay doi remark(lay them name cua amc)
            and al.cdname ='FEECODES' and al.cdtype='SA'
            and fee.feecode=al.cdval(+)
            and fee.custodycd=cf.custodycd (+)
            AND FEE.CCYCD = NOSTRO.CCYCD(+);
    END;
    --Cap nhat trang thai ve dang xu ly ben ngan hang
    update feetran set status='S',glacctno = l_feebookingid
    where custodycd||feecode = l_custodycdfeecode
    AND STATUS = 'N' AND DELTD <>'Y' AND (PAUTOID IS NOT NULL OR TYPE = 'F');
EXCEPTION
  WHEN OTHERS THEN
      PLOG.ERROR(SQLERRM || dbms_utility.format_error_backtrace);
      RAISE ERRNUMS.E_SYSTEM_ERROR;
END;
/
