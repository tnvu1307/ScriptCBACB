SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE sp_gen_taxinvoice (p_txdate in VARCHAR2,p_txnum in VARCHAR2)
IS
/*==============================================
creater             createdate
NamTv               14/01/2020
===============================================*/
l_txdate date;
l_txnum varchar2(20);
l_rbankaccount varchar2(50);
l_tltxcd varchar2(10);
BEGIN
l_txdate:=to_date(trim(p_txdate),systemnums.C_DATE_FORMAT);
l_txnum:=trim(p_txnum);
    BEGIN --NAM.LY 10/03/2020: NEU TLTXCD IN (1401,1402) -> TAX_BOOKING_RESULT.SETTLETYPE = '50'(BY DIEM.NGUYEN)
        SELECT DISTINCT TLA.TLTXCD INTO L_TLTXCD
        FROM TLLOG TLA
        WHERE TLA.TXNUM = L_TXNUM AND TLA.TXDATE = L_TXDATE;
        EXCEPTION WHEN OTHERS THEN L_TLTXCD := '';
    END;
    select bankacctno into l_rbankaccount
    from banknostro
    where banktype='001' and banktrans='INTRFRETAXCASH';
    BEGIN
        INSERT INTO TAX_BOOKING_RESULT(AUTOID,CURRENCY,VATAMOUNT,CIFID,PAYMENTDATE,BANKACCOUNT,REMARK,STATUS,BANKGLOBALID,TRANSDATE,NOSTROACCOUNT,SETTLETYPE)
        SELECT SEQ_TAX_BOOKING_RESULT.NEXTVAL,DD.CCYCD,MST.RATEAMT,CF.CIFID,L_TXDATE,
        --CASE WHEN SB.TRADEPLACE= '003' THEN DD.REFCASAACCT ELSE l_rbankaccount END REFCASAACCT,
        CASE WHEN L_TLTXCD IN ('1401','1402') THEN DD.REFCASAACCT ELSE --NAM.LY 17/03/2020: NEU TLTXCD IN (1400,1401) -> TAX_BOOKING_RESULT.BANKACCOUNT = DD.REFCASAACCT (BY DIEM.NGUYEN)
        (CASE WHEN (SB.TRADEPLACE= '003' AND DEPOSITORY <> '001') THEN DD.REFCASAACCT ELSE l_rbankaccount END) END REFCASAACCT,
            FEE.TRDESC,'N' STATUS, fn_getglobalid(l_txdate,l_txnum) BANKGLOBALID,L_TXDATE,L_RBANKACCOUNT,
        --CASE WHEN SB.TRADEPLACE= '003' THEN '50' ELSE '60' END SETTLETYPE
        CASE WHEN L_TLTXCD IN ('1401','1402') THEN '50' ELSE --NAM.LY 10/03/2020: NEU TLTXCD IN (1400,1401) -> TAX_BOOKING_RESULT.SETTLETYPE = '50'(BY DIEM.NGUYEN)
        (CASE WHEN (SB.TRADEPLACE= '003' AND DEPOSITORY <> '001') THEN '50' ELSE '60' END) END SETTLETYPE
        FROM FEETRANDETAIL MST, CFMAST CF, (select *from DDMAST where status <> 'C' and ISDEFAULT='Y') DD, (select *from FEETRAN where deltd <> 'Y') FEE, SBSECURITIES SB
        WHERE MST.FORP='T' AND MST.CUSTODYCD=CF.CUSTODYCD AND CF.CUSTID=DD.CUSTID(+)-- AND DD.ISDEFAULT='Y' AND DD.STATUS <> 'C' --trung.luu: 16-03-2021 SHBVNEX-1594 khong can tai khoan tien hoac tai khoan tien mac dinh
        AND MST.TXNUM=FEE.TXNUM(+) AND MST.TXDATE=FEE.TXDATE(+)
        AND MST.CUSTODYCD =FEE.CUSTODYCD(+) --NAM.LY 17/03/2020: XU LY THUE CHO NHIEU CUSTODYCD TRONG 1 GIAO DICH
        AND MST.CODEID=SB.CODEID(+)
        AND MST.RATEAMT>0
        AND (FEE.pautoid is null and FEE.type='T')
        AND MST.TXDATE=L_TXDATE AND MST.TXNUM=L_TXNUM;
    END;
    pck_bankflms.sp_auto_gen_tax_invoice();
    --Cap nhat trang thai ve dang xu ly ben ngan hang
    update feetran set pstatus=pstatus||status,status='S'
    where txdate||txnum = l_txdate||l_txnum ;
EXCEPTION
  WHEN OTHERS THEN
      PLOG.ERROR(SQLERRM || dbms_utility.format_error_backtrace);
      RAISE ERRNUMS.E_SYSTEM_ERROR;
END;
/
