SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE OD6001 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   F_DATE                 IN       VARCHAR2, /*Tu ngay */
   T_DATE                 IN       VARCHAR2, /*den ngay */
   P_CHECKER              IN       VARCHAR2, /*Ten thanh vien kiem soat */
   P_OFFICER              IN       VARCHAR2, /*Ten dai dien co tham quyen cua thanh vien */
   P_TLID                 IN       VARCHAR2,  /*Nguoi lap bieu*/
   PV_TXNUM               IN       VARCHAR2 /*SO CHUNG TU*/
   )
IS
    -- Bao cao thong ke danh muc luu ky cua nha dau tu nuoc ngoai
    -- person      date                 comments
    -- ---------   ------               -------------------------------------------
    -- NAM.LY      24-10-2019           created
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0

    v_FromDate          DATE;
    v_ToDate            DATE;
    v_TLIdChecker       VARCHAR2(50);
    v_TLIdOfficer       VARCHAR2(50);
    v_TXNUM             VARCHAR2(10);
    
BEGIN
    V_STROPTION := OPT;
    if V_STROPTION = 'A' then
        V_STRBRID := '%';
    elsif V_STROPTION = 'B' then
        V_STRBRID := substr(BRID,1,2) || '__' ;
    else
        V_STRBRID:= BRID;
    end if;

    v_FromDate      :=     TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_ToDate        :=     TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_TLIdChecker   :=     P_CHECKER;
    v_TLIdOfficer   :=     P_OFFICER;
    v_TXNUM         :=     PV_TXNUM;

OPEN PV_REFCURSOR FOR
    SELECT tl1.TLFULLNAME CHECKER_NAME,
       tl1.TLTITLE CHECKER_TITLE,
       tl2.TLFULLNAME OFFICER_NAME,
       tl2.TLTITLE OFFICE_TITLE,
       tl3.TLTITLE CREATED_TITLE,
       v_TXNUM TXNUM
FROM tlprofiles tl1, tlprofiles tl2, tlprofiles tl3
WHERE tl1.TLID = v_TLIdChecker
      AND tl2.TLID = v_TLIdOfficer
      AND tl3.TLID = P_TLID;

EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('OD6001: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;
End;
/
