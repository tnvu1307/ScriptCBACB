SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE CF6014 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   --F_DATE                 IN       VARCHAR2, /*Tu ngay */
   --T_DATE                 IN       VARCHAR2, /*den ngay */
   PV_CUSTODYCD           IN       VARCHAR2, /*So TK Luu ky */
   PV_LOCAL_CUSTODIAN_TP    IN VARCHAR2 /*Thay doi noi luu ky*/
   )
IS
    -- Giay dang ky ma so giao dich
    -- person      date                 comments
    -- ---------   ------               -------------------------------------------
    -- LAMGK    22-10-2019           created
    V_STROPTION    VARCHAR2 (5);
    V_STRBRID      VARCHAR2 (4);

    v_FromDate     date;
    v_ToDate       date;
    v_CurrDate     date;
    v_CustodyCD    varchar2(20);
    --v_HEADOFFICE   varchar2(500);
    v_Local_Custodian_Tp VARCHAR2(50);
BEGIN

    V_STROPTION := OPT;

    v_CurrDate   := getcurrdate;

    v_Local_Custodian_Tp := PV_LOCAL_CUSTODIAN_TP;

    if v_stroption = 'A' then
        v_strbrid := '%';
    elsif v_stroption = 'B' then
        v_strbrid := substr(brid,1,2) || '__' ;
    else
        v_strbrid:=brid;
    end if;

    v_CustodyCD := REPLACE(PV_CUSTODYCD,'.','');

    /*
    v_FromDate  :=     TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_ToDate    :=     TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    */

OPEN PV_REFCURSOR FOR
     SELECT MAX(CF.FULLNAME) FULLNAME, CF.CIFID, CF.TRADINGCODE
        --GIA TRI CU
        , MAX(DECODE(v_Local_Custodian_Tp, '001', DECODE(VARNAME, 'BRADDRESS', VARVALUE))) OLD_BRADDRESS
        , MAX(DECODE(v_Local_Custodian_Tp, '001', DECODE(VARNAME, 'BRADDRESS_EN', VARVALUE))) OLD_BRADDRESS_EN
        , MAX(DECODE(v_Local_Custodian_Tp, '001', DECODE(VARNAME, 'HEADOFFICE', VARVALUE))) OLD_HEADOFFICE
        , MAX(DECODE(v_Local_Custodian_Tp, '001', DECODE(VARNAME, 'HEADOFFICE_EN', VARVALUE))) OLD_HEADOFFICE_EN
        , MAX(DECODE(v_Local_Custodian_Tp, '001', DECODE(VARNAME, 'EMAIL', VARVALUE))) OLD_EMAIL
        , MAX(DECODE(v_Local_Custodian_Tp, '001', DECODE(VARNAME, 'PHONE', VARVALUE))) OLD_PHONE
        , MAX(DECODE(v_Local_Custodian_Tp, '001', DECODE(VARNAME, 'FAX', VARVALUE))) OLD_FAX
        --GIA TRI MOI
        , MAX(DECODE(v_Local_Custodian_Tp, '002', DECODE(VARNAME, 'BRADDRESS', VARVALUE))) NEW_BRADDRESS
        , MAX(DECODE(v_Local_Custodian_Tp, '002', DECODE(VARNAME, 'BRADDRESS_EN', VARVALUE))) NEW_BRADDRESS_EN
        , MAX(DECODE(v_Local_Custodian_Tp, '002', DECODE(VARNAME, 'HEADOFFICE', VARVALUE))) NEW_HEADOFFICE
        , MAX(DECODE(v_Local_Custodian_Tp, '002', DECODE(VARNAME, 'HEADOFFICE_EN', VARVALUE))) NEW_HEADOFFICE_EN
        , MAX(DECODE(v_Local_Custodian_Tp, '002', DECODE(VARNAME, 'EMAIL', VARVALUE))) NEW_EMAIL
        , MAX(DECODE(v_Local_Custodian_Tp, '002', DECODE(VARNAME, 'PHONE', VARVALUE))) NEW_PHONE
        , MAX(DECODE(v_Local_Custodian_Tp, '002', DECODE(VARNAME, 'FAX', VARVALUE))) NEW_FAX
    FROM CFMAST CF, SYSVAR
    WHERE VARNAME IN ('BRADDRESS','BRADDRESS_EN','HEADOFFICE','HEADOFFICE_EN','EMAIL','PHONE','FAX')
          AND CF.CUSTODYCD = v_CustodyCD
    GROUP BY CF.CIFID,CF.TRADINGCODE ;

EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('CF6014: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;
End;
/
