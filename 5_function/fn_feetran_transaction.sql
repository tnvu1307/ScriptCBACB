SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_feetran_transaction(p_txmsg in tx.msg_rectype, p_amt number, p_fee_ccycd varchar2, p_tax_ccycd varchar2, p_custodycd varchar2)
return number
is
v_feeamt number;
v_ccycd varchar2(10);
v_feerate number;
v_feecd varchar2(10);
v_vatrate number;
v_vatamt number;
begin
    SELECT FER.FEECD, FER.FEERATE, FER.VATRATE INTO V_FEECD, V_FEERATE, v_vatrate  FROM FEEMAP FEP, FEEMASTER FER WHERE FEP.FEECD=FER.FEECD AND TLTXCD =p_txmsg.tltxcd;
    -- Tinh phi
    if p_fee_ccycd is not null then
        select substr(p_fee_ccycd,1,instr(p_fee_ccycd,'_')-1),substr(p_fee_ccycd,instr(p_fee_ccycd,'_')+1)
        into v_feeamt, v_ccycd  from dual;

        INSERT INTO FEETRAN(TXDATE, TXNUM, DELTD, FEECD, GLACCTNO, TXAMT, FEEAMT, FEERATE, VATRATE, VATAMT, AUTOID, TRDESC, CCYCD, ORDERID, TYPE, DEDUCTEDPLACE, STATUS,PAIDDATE,PSTATUS,SUBTYPE,FEETYPES,CUSTODYCD)
        VALUES (p_txmsg.busdate,p_txmsg.txnum,'N',v_feecd,NULL,p_amt,v_feeamt,v_feerate,NULL,NULL,SEQ_FEETRAN.NEXTVAL,'Fee of transaction',v_ccycd,NULL,'F', NULL, 'N', NULL, NULL,'014','OTHER',p_custodycd);
    end if;
    --Tinh thue
    if p_tax_ccycd is not null then
        select substr(p_tax_ccycd,1,instr(p_tax_ccycd,'_')-1),substr(p_tax_ccycd,instr(p_tax_ccycd,'_')+1)
        into v_vatamt, v_ccycd from dual;
        INSERT INTO FEETRAN(TXDATE, TXNUM, DELTD, FEECD, GLACCTNO, TXAMT, FEEAMT, FEERATE, VATRATE, VATAMT, AUTOID, TRDESC, CCYCD, ORDERID, TYPE, DEDUCTEDPLACE, STATUS,PAIDDATE,PSTATUS,SUBTYPE,FEETYPES,CUSTODYCD)
        VALUES (p_txmsg.busdate,p_txmsg.txnum,'N',v_feecd,NULL,p_amt,NULL,NULL,v_vatrate,v_vatamt,SEQ_FEETRAN.NEXTVAL,'Tax of transaction',v_ccycd,NULL,'T', NULL, 'N',NULL, NULL,NULL,NULL,p_custodycd);
    end if;

    return 0;
    EXCEPTION
     WHEN OTHERS THEN
      RETURN NULL;
end;
/
