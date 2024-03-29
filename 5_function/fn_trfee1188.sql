SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_trfee1188(PV_AFACCTNO IN VARCHAR2,P_FEETYPE IN VARCHAR2)
    RETURN NUMBER IS
-- PURPOSE: PHI CHUYEN KHOAN CHUNG KHOAN
-- MODIFICATION HISTORY
-- PERSON      DATE         COMMENTS
-- ---------   ------       -------------------------------------------
-- THANHNM   03/02/2012     CREATED
-- ANTB      16/05/2015     MODIFIED check phi min
-- TRUONGLD  05/06/2015     SUA LAI THEO Y/C, PHI MAX (1M)/MA CK, PHI MIN (200K) / LAN CHUYEN
    V_RESULT NUMBER;
    V_FEERATE NUMBER;
    V_FEEMAX NUMBER;
    V_FEEMIN NUMBER;
    V_ACCNUM NUMBER;

BEGIN
V_FEERATE :=0;
V_FEEMAX :=0;
V_FEEMIN :=0;
V_RESULT :=0;
V_ACCNUM :=0;
/*
KIEM TRA XEM CO PHAI TIEU KHOAN CUOI CUNG KHONG
DUNG: RETURN FEE
SAI: RETURN 0
*/
-- Check theo p_CLOSETYPE
/* SELECT COUNT(ACCTNO) INTO V_ACCNUM  FROM AFMAST WHERE
 CUSTID = (SELECT CUSTID FROM AFMAST WHERE  ACCTNO=PV_AFACCTNO )
 AND STATUS NOT IN ( 'N','C') AND ACCTNO <> PV_AFACCTNO;

 IF V_ACCNUM >0 THEN
    RETURN 0;
 END IF;*/

SELECT FEEAMT INTO  V_FEERATE
FROM FEEMASTER WHERE FEECD = P_FEETYPE AND STATUS ='Y';

SELECT MAXVAL INTO  V_FEEMAX
FROM FEEMASTER WHERE FEECD = P_FEETYPE AND STATUS ='Y';

SELECT MINVAL INTO  V_FEEMIN
FROM FEEMASTER WHERE FEECD = P_FEETYPE AND STATUS ='Y';


SELECT SUM(NVL(SE.AMT,0)) INTO V_RESULT
FROM
    (SELECT SE.CUSTID, SE.CODEID,
            --LEAST(SUM(V_FEERATE*NVL((SE.TRADE + SE.MORTAGE + SE.BLOCKED + SE.WITHDRAW + SE.DEPOSIT  + SE.SENDDEPOSIT),0)), V_FEEMAX)  AMT
            SUM(LEAST(V_FEERATE*NVL((SE.TRADE + SE.MORTAGE + SE.BLOCKED + SE.WITHDRAW + SE.DEPOSIT  + SE.SENDDEPOSIT),0), V_FEEMAX))  AMT
        FROM SEMAST SE, SBSECURITIES SYM
        WHERE SE.CODEID=SYM.CODEID AND SYM.SECTYPE <> '004'
        GROUP BY SE.CUSTID, SE.CODEID
    ) SE
WHERE SE.CUSTID IN (SELECT CUSTID FROM SEMAST WHERE AFACCTNO=  PV_AFACCTNO);

IF V_RESULT < V_FEEMIN THEN
    V_RESULT := V_FEEMIN;
END IF;

RETURN V_RESULT;
EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
 
 
/
