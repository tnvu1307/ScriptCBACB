SET DEFINE OFF;
CREATE OR REPLACE function fn_fee_tax_tran(p_txmsg in tx.msg_rectype, amt number, fee_ccycd varchar2)
return number 
is
v_feeamt number;
v_ccycd varchar2(10);
v_feerate number;
v_feecd varchar2(10);
begin   
    SELECT FER.FEECD, FER.FEERATE INTO V_FEECD, V_FEERATE  FROM FEEMAP FEP, FEEMASTER FER WHERE FEP.FEECD=FER.FEECD AND TLTXCD =p_txmsg.tltxcd;
    
    select substr(fee_ccycd,1,instr(fee_ccycd,'_')-1),substr(fee_ccycd,instr(fee_ccycd,'_')+1)
    into v_feeamt, v_ccycd  from dual;  
    
    INSERT INTO FEETRAN(TXDATE, TXNUM, DELTD, FEECD, GLACCTNO, TXAMT, FEEAMT, FEERATE, VATRATE, VATAMT, AUTOID, TRDESC, CCYCD, ORDERID)
    VALUES (p_txmsg.txdate,p_txmsg.txnum,'N',v_feecd,NULL,amt,v_feeamt,v_feerate,NULL,NULL,SEQ_FEETRAN.NEXTVAL,'Fee of transaction',v_ccycd,NULL);
    
    return 0;
    EXCEPTION
     WHEN OTHERS THEN
      RETURN -1;
end;

/
