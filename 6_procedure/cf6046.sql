SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE CF6046 (
    PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
    OPT                    IN       VARCHAR2,
    BRID                   IN       VARCHAR2,
    FROM_DATE IN VARCHAR2,
    T_DATE IN VARCHAR2,
    ACCOUNTNUMBER IN VARCHAR2
) IS
    v_result transactionhistory%ROWTYPE;
    v_fromDate VARCHAR2(20);
    v_toDate VARCHAR2(20);
    v_accountNumber VARCHAR2(20);
    AN VARCHAR2(20);
    
BEGIN
    -- Convert the input VARCHAR2 dates to DATE type
     v_fromdate  := TO_CHAR(TO_DATE(FROM_DATE, 'DD/MM/YYYY'), 'DD/MM/YYYY');
     v_todate    := TO_CHAR(TO_DATE(T_DATE, 'DD/MM/YYYY'), 'DD/MM/YYYY');
    v_accountNumber := ACCOUNTNUMBER;
SELECT ACCOUNTNUMBER INTO AN FROM MONEYACCOUNT WHERE autoid = v_accountNumber;
    -- Use an INTO clause to fetch the result into the variable
OPEN PV_REFCURSOR FOR 
   
   SELECT th.*,
               v_fromdate AS v_fromdate,
               v_todate AS v_todate
        FROM transactionhistory th
        WHERE th.txdate BETWEEN v_fromdate AND v_todate
          AND th.ACCOUNTNUMBER = AN;
EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('CF6013: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;
END CF6046;
/
