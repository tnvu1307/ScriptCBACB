SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf6007(
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   F_DATE                 IN       VARCHAR2, /*TU NGAY */
   PV_AMC           IN       VARCHAR2, /*SO TK LUU KY */
   P_LCB                IN       VARCHAR2, /*GCM ID */
   P_SYMBOL                IN       VARCHAR2, /*GCM ID */
   P_OPTION                IN       VARCHAR2, /*GCM ID */
   PV_TXNUM                 IN       VARCHAR2
   )
IS
   -- GIAY DANG KY MA SO GIAO DICH
    -- PERSON      DATE                 COMMENTS
    -- ---------   ------               -------------------------------------------
    -- TRUONGLD    18-10-2019           CREATED
    -- NAM.LY      10-04-2020           MODIFIED
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0

    V_FROMDATE     DATE;
    V_TODATE       DATE;
    V_CURRDATE     DATE;
    V_NEXTDATE     DATE;
    V_PREV_FDATE   DATE;
    V_SYMBOL       VARCHAR2(20);
    V_CUSTODYCD    VARCHAR2(20);
    V_BRADDRESS         VARCHAR2(200);
    V_BRADDRESS_EN      VARCHAR2(200);
    V_HEADOFFICE        VARCHAR2(200);
    V_HEADOFFICE_EN     VARCHAR2(200);
    V_EMAIL             VARCHAR2(200);
    V_PHONE             VARCHAR2(200);
    V_FAX               VARCHAR2(200);
    V_1IDCODE           VARCHAR2(200);
    V_1OFFICE           VARCHAR2(200);
    V_1REFNAME          VARCHAR2(200);
    V_2IDCODE           VARCHAR2(200);
    V_2OFFICE           VARCHAR2(200);
    V_2REFNAME          VARCHAR2(200);
    V_BUSSINESSID       VARCHAR2(200);
    V_AMCID             VARCHAR2(20);
    -- TY LE SO HUU CO DONG LON
    V_MAJORSHAREHOLDER  NUMBER(20,4);
    V_CLEARDAY          NUMBER;
    V_REPORTNO          VARCHAR2(100);
BEGIN
    V_STROPTION := OPT;
    V_CURRDATE   := GETCURRDATE;
    IF V_STROPTION = 'A' THEN
       V_STRBRID := '%';
    ELSIF V_STROPTION = 'B' THEN
          V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
    ELSE
        V_STRBRID:=BRID;
    END IF;
    --P_SYMBOL
    V_SYMBOL:= P_SYMBOL;
    IF (P_SYMBOL = 'ALL') THEN
       V_SYMBOL := '%%';
    ELSE
        V_SYMBOL := '%' || P_SYMBOL || '%';
    END IF;
    --
    V_REPORTNO := PV_TXNUM;
    SELECT VARVALUE INTO V_HEADOFFICE FROM SYSVAR WHERE VARNAME='HEADOFFICE';

    SELECT MAX(CASE WHEN  VARNAME='BRADDRESS' THEN VARVALUE ELSE '' END),
       MAX(CASE WHEN  VARNAME='BRADDRESS_EN' THEN VARVALUE ELSE '' END),
       MAX(CASE WHEN  VARNAME='HEADOFFICE' THEN VARVALUE ELSE '' END),
       MAX(CASE WHEN  VARNAME='HEADOFFICE_EN' THEN VARVALUE ELSE '' END),
       MAX(CASE WHEN  VARNAME='EMAIL' THEN VARVALUE ELSE '' END),
       MAX(CASE WHEN  VARNAME='PHONE' THEN VARVALUE ELSE '' END),
       MAX(CASE WHEN  VARNAME='FAX' THEN VARVALUE ELSE '' END),
       MAX(CASE WHEN  VARNAME='MAJORSHAREHOLDER' THEN VARVALUE ELSE '' END),
       MAX(CASE WHEN  VARNAME='CLEARDAY' THEN VARVALUE ELSE '' END)
    INTO V_BRADDRESS,V_BRADDRESS_EN,V_HEADOFFICE,V_HEADOFFICE_EN,V_EMAIL,V_PHONE,V_FAX, V_MAJORSHAREHOLDER, V_CLEARDAY
    FROM SYSVAR WHERE VARNAME IN ('BRADDRESS','BRADDRESS_EN','HEADOFFICE','HEADOFFICE_EN','EMAIL','PHONE','FAX', 'MAJORSHAREHOLDER', 'CLEARDAY');

    SELECT MAX(CASE WHEN  VARNAME='1IDCODE' THEN VARVALUE ELSE '' END),
       MAX(CASE WHEN  VARNAME='1OFFICE' THEN VARVALUE ELSE '' END),
       MAX(CASE WHEN  VARNAME='1REFNAME' THEN VARVALUE ELSE '' END),
       MAX(CASE WHEN  VARNAME='2IDCODE' THEN VARVALUE ELSE '' END),
       MAX(CASE WHEN  VARNAME='2OFFICE' THEN VARVALUE ELSE '' END),
       MAX(CASE WHEN  VARNAME='2REFNAME' THEN VARVALUE ELSE '' END),
       MAX(CASE WHEN  VARNAME='BUSSINESSID' THEN VARVALUE ELSE '' END)
    INTO V_1IDCODE, V_1OFFICE, V_1REFNAME, V_2IDCODE, V_2OFFICE, V_2REFNAME, V_BUSSINESSID
    FROM SYSVAR WHERE VARNAME IN ('1IDCODE','1OFFICE','1REFNAME','2IDCODE','2OFFICE','2REFNAME','BUSSINESSID');
OPEN PV_REFCURSOR FOR
    SELECT (CASE WHEN V_REPORTNO IS NULL THEN '...../' ELSE V_REPORTNO||'/' END)||TO_CHAR(V_CURRDATE,'YYYY')||'/SSD-SHBVN' REPORTING_NO
                 FROM DUAL;

EXCEPTION
  WHEN OTHERS
   THEN
      PLOG.ERROR ('CF6007: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RETURN;
END;
/
