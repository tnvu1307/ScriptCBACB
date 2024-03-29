SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE ba0011(
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   PV_SYMBOL              IN       VARCHAR2,
   I_DATE                 IN       VARCHAR2,
   PV_CUSTODYCD           IN       VARCHAR2
   )
IS
    -- BA0010: APPLICATION FOR REMITTANCE
    -- PERSON      DATE                 COMMENTS
    -- ---------   ------               -------------------------------------------
    -- THOAI.TRAN    20-11-2019           CREATED
    -- NAM.LY        07-05-2020           MODIFIED
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0

    V_PAYMENTDATE  DATE;
    V_CUSTODYCD    VARCHAR(20);
    V_TICKER       VARCHAR(20);
    V_OFFICE       VARCHAR(200);
    V_PHONE        VARCHAR(200);
    V_BUSSINESSID  VARCHAR(200);
    V_BANKACCTNO   VARCHAR(200);
    V_CURRDATE     DATE;
    v_BRADDRESS    VARCHAR(1000);
BEGIN
    V_STROPTION := OPT;
    IF V_STROPTION = 'A' THEN
       V_STRBRID := '%';
    ELSIF V_STROPTION = 'B' THEN
          V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
    ELSE
        V_STRBRID:=BRID;
    END IF;
    IF (PV_CUSTODYCD = 'ALL') THEN
       V_CUSTODYCD := '%';
    ELSE
       V_CUSTODYCD := PV_CUSTODYCD;
    END IF;
    --
    V_TICKER:=PV_SYMBOL;
    V_PAYMENTDATE  := TO_DATE(I_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    -- HEADOFFICE / PHONE / MST
    SELECT MAX(CASE WHEN  VARNAME='HEADOFFICE' THEN VARVALUE ELSE '' END),
           MAX(CASE WHEN  VARNAME='PHONE' THEN VARVALUE ELSE '' END),
           MAX(CASE WHEN  VARNAME='BUSSINESSID' THEN VARVALUE ELSE '' END),
           MAX(CASE WHEN  VARNAME='BRADDRESS' THEN VARVALUE ELSE '' END)
    INTO  V_OFFICE,V_PHONE,V_BUSSINESSID,v_BRADDRESS
    FROM SYSVAR
    WHERE GRNAME ='SYSTEM'
    AND VARNAME IN ('HEADOFFICE','PHONE','BUSSINESSID','BRADDRESS');
    --BANKACCTNO
    SELECT SUBSTR(BANKACCTNO,1,3)||'-'||SUBSTR(BANKACCTNO,4,3)||'-'||SUBSTR(BANKACCTNO,7,100)
    INTO V_BANKACCTNO
    FROM BANKNOSTRO BNO
    WHERE BNO.BANKTYPE = '001'
    AND BNO.BANKTRANS = 'INTRFBA'
    AND ROWNUM = 1;
    V_CURRDATE:=GETCURRDATE();

OPEN PV_REFCURSOR FOR
SELECT DISTINCT
    V_OFFICE            OFFICE
    ,V_PHONE            PHONE
    ,V_BUSSINESSID      BUSSINESSID
    ,v_BRADDRESS        BRADDRESS
    ,V_BANKACCTNO       BANKACCTNO
    ,TO_CHAR(MST.PAYMENTDATE)         CURRDATE
    ,MST.FUNDNAME
    ,'Lai trai phieu '||MST.SYMBOL ||' dinh ky '|| ABS(Round(MONTHS_BETWEEN(MST.BEGINDATE,V_PAYMENTDATE))) ||' thang tu '||TO_CHAR(MST.BEGINDATE,'DD/MM/YYYY')||'-'||TO_CHAR(V_PAYMENTDATE,'DD/MM/YYYY') STRPERIODINTEREST
    --,MST.SYMBOL
    --,TO_CHAR(MST.BEGINDATE,'DD/MM/YYYY') BEGINDATE
    --,TO_CHAR(MST.ACTUALPAYDATE,'DD/MM/YYYY') ACTUALPAYDATE
    --,MST.PERIODINTEREST
    ,'VND ' || TO_CHAR(NVL(UTILS.SO_THANH_CHU(MST.AMOUNT),0)) AMOUNT
    --,MST.CUSTATCOM
    ,(CASE WHEN  MST.CUSTATCOM ='Y' THEN DD.REFCASAACCT ELSE CFO.BANKACC END) ACCTNO
    --,DD.REFCASAACCT
    --,CFO.BANKACC
    ,(CASE WHEN  MST.CUSTATCOM ='Y' THEN V_OFFICE ELSE CFO.BANKNAME END) BANKNAME
    ,'A' STRAMOUNT
    ,MST.FUNDADDRESS
    ,TO_CHAR(MST.MOBILESMS) FUNDPHONE
    ,MST.FUNDBANKADDRESS
    ,MST.CUSTODYCD
    FROM
    (
        SELECT CF.CUSTID
            ,CF.CUSTODYCD
            ,CF.ADDRESS FUNDADDRESS
            ,CF.MOBILESMS
            ,CF.BANKATADDRESS FUNDBANKADDRESS
            ,BCA.FULLNAME FUNDNAME
            ,SUM(BCA.AMOUNT) AMOUNT
            ,BT.ACTUALPAYDATE
            ,BT.BEGINDATE
            ,AL.CDCONTENT PERIODINTEREST
            ,SB.SYMBOL
            ,CF.CUSTATCOM --LUU KY TAI SHV (Y/N)
            ,BT.PAYMENTDATE
        FROM CFMAST CF, BONDCASCHD BCA, SBSECURITIES SB,BONDTYPEPAY BT,ALLCODE AL,CAMAST CA
        WHERE CF.CUSTODYCD=BCA.CUSTODYCD
              --AND BCA.STATUS = 'A'
              AND BCA.CAMASTID = CA.CAMASTID
              AND CA.CODEID = SB.CODEID
              AND SB.CODEID=BT.BONDCODE
              AND AL.CDNAME = 'PERIODINTEREST'
              AND AL.CDVAL = '004'--SB.PERIODINTEREST
              AND SB.SYMBOL LIKE  V_TICKER
              AND BCA.CUSTODYCD LIKE V_CUSTODYCD
              AND BT.PAYMENTDATE = V_PAYMENTDATE -- LAY DU LIEU THEO PAYMENTDATE (KHI CUNG SYMBOL/CODEID KHAC DATE)
        GROUP BY CF.CUSTID
        ,CF.CUSTODYCD
        ,BCA.FULLNAME
        ,BT.ACTUALPAYDATE
        ,BT.BEGINDATE
        ,AL.CDCONTENT
        ,SB.SYMBOL
        ,CF.CUSTATCOM
        ,CF.ADDRESS
        ,CF.MOBILESMS
        ,CF.BANKATADDRESS
        ,BT.PAYMENTDATE
    )MST,
    (
        SELECT CUSTID,REFCASAACCT
        FROM DDMAST
        WHERE ISDEFAULT='Y'
    )DD,
    (
        SELECT CFCUSTID,BANKACC,BANKNAME FROM CFOTHERACC
    )CFO
    WHERE MST.CUSTID=DD.CUSTID(+)
    AND MST.CUSTID=CFO.CFCUSTID(+);
EXCEPTION
  WHEN OTHERS
   THEN
      PLOG.ERROR ('BA0011: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RETURN;
END;
/
