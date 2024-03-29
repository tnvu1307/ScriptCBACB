SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_crb_getbankcodebytrfcode (v_trfcode in varchar2, v_refvalue in varchar2) RETURN VARCHAR2 IS
  v_return   VARCHAR2(50);
BEGIN
v_return:='';
IF v_trfcode='SESENDDEPOSIT' or v_trfcode='SEREJECTDEPOSIT' or v_trfcode='SESENDWITHDRAW' or v_trfcode='SEREJECTWITHDRAW' THEN
  SELECT SYMBOL INTO v_return FROM SBSECURITIES WHERE CODEID=v_refvalue;
ELSIF v_trfcode='TRFADV2BANK' THEN
    SELECT SHORTNAME INTO v_return FROM CFMAST WHERE CUSTID=v_refvalue;
ELSIF v_trfcode='TRFADPAID' THEN
    SELECT BANKNAME INTO v_return FROM AFMAST  WHERE ACCTNO=v_refvalue;
/*ELSIF v_trfcode='DFDRAWNDOWN' THEN
    SELECT LN.CUSTBANK INTO v_return FROM DFTYPE DF, LNTYPE LN
    WHERE DF.LNTYPE=LN.ACTYPE AND DF.ACTYPE=v_refvalue;
ELSIF v_trfcode='DFPAYMENT' THEN
    SELECT DF.CUSTBANK INTO v_return FROM DFGROUP DF
    WHERE  DF.GROUPID = v_refvalue;
ELSIF v_trfcode='LOANDRAWNDOWN' THEN
    SELECT LNT.CUSTBANK INTO v_return FROM LNMAST LN, LNTYPE LNT
    WHERE LN.ACTYPE = LNT.ACTYPE
    AND LN.ACCTNO = v_refvalue;
ELSIF v_trfcode='LOANPAYMENT' THEN
    SELECT LNT.CUSTBANK INTO v_return FROM LNMAST LN, LNTYPE LNT
    WHERE LN.ACTYPE = LNT.ACTYPE
    AND LN.ACCTNO = v_refvalue;*/
END IF;
RETURN v_return;
END;
/
