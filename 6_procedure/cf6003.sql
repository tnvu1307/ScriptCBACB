SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf6003 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   --F_DATE                 IN       VARCHAR2, /*Tu ngay */
   --T_DATE                 IN       VARCHAR2, /*den ngay */
   PV_CUSTODYCD           IN       VARCHAR2, /*So TK Luu ky */
   P_CFAUTH               IN       VARCHAR2, /*NGUOI NHAN */
   REPORT_NO              IN       VARCHAR2 -- So chung tu
   )
IS
    -- Giay dang ky ma so giao dich
    -- person      date                 comments
    -- ---------   ------               -------------------------------------------
    -- truongld    18-10-2019           created
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0

    v_FromDate     date;
    v_ToDate       date;
    v_CurrDate     date;
    v_CustodyCD    varchar2(20);
    v_HEADOFFICE   varchar2(500);

    V_FULLNAME      VARCHAR2(200);
    V_ADDRESS   VARCHAR2(500);
    V_MAIL   VARCHAR2(100);
    V_TELEPHONE   VARCHAR2(100);

BEGIN

   V_STROPTION := OPT;

   v_CurrDate   := getcurrdate;

    if v_stroption = 'A' then
        v_strbrid := '%';
    elsif v_stroption = 'B' then
        v_strbrid := substr(brid,1,2) || '__' ;
    else
        v_strbrid:=brid;
    end if;

    v_CustodyCD := REPLACE(PV_CUSTODYCD,'.','');
    --------------------LAY TEN NGUOI UY QUYEN------------------
    BEGIN
        SELECT
                -- NVL(AU.CUSTID, AU.LICENSENO) CUSTID
                 AU.FULLNAME
                ,AU.ADDRESS
                ,CF1.EMAIL
                ,AU.TELEPHONE
        INTO V_FULLNAME,V_ADDRESS,V_MAIL,V_TELEPHONE
        FROM CFAUTH AU, CFMAST CF, AFMAST AF, SYSVAR SYS,CFMAST CF1,ALLCODE CD1
        WHERE CF.CUSTID = AU.CFCUSTID
              AND AF.CUSTID = CF.CUSTID
              AND NVL(AU.CUSTID, AU.LICENSENO) = CF1.CUSTID(+)
              AND CD1.CDVAL = AU.DELTD AND cd1.cdname = 'CANCELED'
              AND SYS.VARNAME = 'CURRDATE'
              AND TO_DATE(VARVALUE,'DD/MM/RRRR') BETWEEN AU.VALDATE AND AU.EXPDATE
              AND AU.FULLNAME IS NOT NULL
              AND CF.CUSTODYCD=v_CustodyCD
              AND NVL(AU.CUSTID, AU.LICENSENO) =P_CFAUTH;
    EXCEPTION
        WHEN NO_DATA_FOUND  THEN
            V_FULLNAME := '';
            V_ADDRESS := '';
            V_MAIL := '';
            V_TELEPHONE := '';
    END;
    /*
    v_FromDate  :=     TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_ToDate    :=     TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    */

OPEN PV_REFCURSOR FOR
    select
            V_FULLNAME AS RE_FULLNAME,
            V_ADDRESS AS RE_ADDRESS,
            V_MAIL AS RE_MAIL,
            V_TELEPHONE AS RE_TELEPHONE,
            REPORT_NO AS REPORT_NO,

           cf.custodycd, -- so tk luu ky
           cf.fullname, -- ten kh
           cf.idcode,   -- So DKSH
           cf.iddate,   -- Ngay cap
           cf.idplace, -- Noi cap
           cf.idtype,   -- Loai
           cf.address,  -- Dia chi
           cf.phone, -- So DT
           cf.mobile, -- So DT
           cf.email, -- Email
           cf.tradingcode, -- Ma so GD CK
           cf.tradingcodedt,  -- Ngay cap ma so
           dd.refcasaacct FIICAccount, -- So TK dau tu gian tiep
           cf.CIFID SECAccount, -- So TK chung khoan
           to_char(sysdate,'Mon dd, yyyy') CURRDATE
    from cfmast cf, ddmast dd
    where cf.custid = dd.custid
          and dd.accounttype='IICA'
          and cf.custodycd = v_CustodyCD;

EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('CF6003: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;
End;
/
