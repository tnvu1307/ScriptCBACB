SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE sp_gen_feeinvoice (p_txdate in VARCHAR2, p_txnum in varchar2, p_txdatebatch in VARCHAR2, p_txnumbatch in varchar2)
IS
/*==============================================
creater             createdate
thunt               06/01/2020
===============================================*/
    pkgctx plog.log_ctx;
    logrow tlogdebug%ROWTYPE;
    l_txdate date;
    l_txnum varchar2(20);
    l_rbankaccount varchar2(50);
    l_txnumtxdate  varchar2(100);
    l_feebookingid number;
    v_mcifid varchar2(250);
BEGIN
    l_txdate:=to_date(trim(p_txdate),systemnums.C_DATE_FORMAT);
    l_txnum:=trim(p_txnum);
    l_txnumtxdate:=trim(to_char(to_date(l_txdate,systemnums.C_DATE_FORMAT),'RRRRMMDD')||l_txnum);

    select bankacctno into l_rbankaccount
    from banknostro
    where banktrans='OUTTRFCACASH';
    BEGIN
        l_feebookingid := seq_fee_booking_result.nextval;

        INSERT INTO FEE_BOOKING_RESULT (AUTOID,GRAUTOID,BANKACCOUNT,CIFID,CURRENCY,REMARK,FEEAMOUNT,FXRATE,FXAMOUNT,NOSTROACCOUNT,STATUS,
                    BANKGLOBALID,TRANSDATE,SETTLEDATE,FEETYPE,FEECODE,FEETXDATE,FEETXNUM,TXDATE,TAXAMOUNT,FEENAME,REFCODE,SUBTYPE,MCIFID)
        SELECT  seq_fee_booking_result.nextval, l_feebookingid,
                (CASE WHEN NVL(CF.SETTLETYPE, '60') = '60' THEN NOSTRO.BANKACCTNO ELSE DD.REFCASAACCT END) BANKACCOUNT,
                cf.cifid,fee.ccycd,SUBSTR(fee.trdesc,1,200),fee.feeamt,1,fee.feeamt,
                l_rbankaccount, 'P',fn_getglobalid(l_txdate,l_txnum) BANKGLOBALID,null,null,
                fee.feecode feetype, fee.feecode,null FEETXDATE,null FEETXNUM, l_txdate,nvl(fee.vatamt,0) taxamount,
                fee.feename,fee.feetypes,fee.subtype,cf.mcifid --trung.luu: 28-04-2021 SHBVNEX-2161 khong co mastercif thi de null
        FROM CFMAST CF,
        (
            SELECT * FROM DDMAST WHERE PAYMENTFEE = 'Y' AND STATUS <> 'C'
        ) DD,
        (
            SELECT BANKACCTNO, 'VND' CCYCD FROM BANKNOSTRO WHERE BANKTRANS = 'OUTTRFMONFEESETTVND' AND ROWNUM = 1
            UNION ALL
            SELECT BANKACCTNO, 'USD' CCYCD FROM BANKNOSTRO WHERE BANKTRANS = 'OUTTRFMONFEESETTUSD' AND ROWNUM = 1
        ) NOSTRO,
        (
            select TRIM(TO_CHAR(TO_DATE(f.txdate,'DD/MM/RRRR'),'RRRRMMDD')||f.txnum) txdatenum,
            f.feecode,f.custodycd,f.ccycd,trunc(sum(f.feeamt),2) feeamt,round(sum(f.feerate),2) feerate,f.subtype,f.feetypes,
                round(sum(f.vatrate),2) vatrate,round(sum(f.vatamt),2) vatamt,f.trdesc,al.cdcontent feename
            from feetran f, allcode al
            where f.status ='N' and f.deltd <> 'Y' and (f.pautoid is not null or f.type='F')
            and f.feecode = al.cdval and al.cdname = 'FEECODES' and al.cdtype = 'SA'
            group by f.feecode,f.custodycd,f.ccycd,f.trdesc,al.cdcontent,f.subtype,f.feetypes
         ) fee
         WHERE fee.custodycd = cf.custodycd
         AND cf.custid = dd.custid(+)--trung.luu: 16-03-2021 SHBVNEX-1594 khong can tai khoan tien hoac tai khoan tien mac dinh
         AND fee.txdatenum = l_txnumtxdate
         AND FEE.CCYCD = NOSTRO.CCYCD(+);
    END;
    --Cap nhat trang thai ve dang xu ly ben ngan hang
    update feetran set status='S',glacctno = l_feebookingid
    where txdate||txnum = l_txdate||l_txnum;
EXCEPTION
  WHEN OTHERS THEN
      PLOG.ERROR(SQLERRM || dbms_utility.format_error_backtrace);
      RAISE ERRNUMS.E_SYSTEM_ERROR;
END;
/
