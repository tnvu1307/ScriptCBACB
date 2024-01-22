SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf602601(
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   P_CUSTODYCD            IN       VARCHAR2, /*So TK Luu ky */
   P_CONTRACT             IN       VARCHAR2, /*So hop dong*/
   P_CFAUTH               IN       VARCHAR2, /*Nguoi nhan */
   P_SIGNTYPE             IN       VARCHAR2 /*Nguoi ky */
   )
IS
    -- Report on the day become/is no longer major shareholder, investors holding 5% or more of shares
    -- person      date                 comments
    -- ---------   ------               -------------------------------------------
    -- thoai.tran    07-11-2019           created
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0

      v_CustodyCD         varchar2(20);
BEGIN
      V_STROPTION := OPT;
     if v_stroption = 'A' then
        v_strbrid := '%';
     elsif v_stroption = 'B' then
        v_strbrid := substr(brid,1,2) || '__' ;
     else
        v_strbrid:=brid;
     end if;

    v_CustodyCD := REPLACE(P_CUSTODYCD,'.','');
OPEN PV_REFCURSOR FOR
        SELECT nvl(DOC.QTTY,CRP.QTTY) CRPEXCQTTY,
         SB.PARVALUE SBPARVALUE,
          nvl(DOC.QTTY*SB.PARVALUE,CRP.QTTY*SB.PARVALUE) CRPEXCVALUE,
           CRP.NO CRPNO
        FROM (SELECT A.* FROM DOCSTRANSFER A,(SELECT DISTINCT A.CRPHYSAGREEID
        FROM CRPHYSAGREE_LOG_ALL A, CRPHYSAGREE B
        WHERE A.TLTXCD='1405') MST
        WHERE A.CRPHYSAGREEID =MST.CRPHYSAGREEID (+) )DOC
            RIGHT JOIN CRPHYSAGREE CRP ON DOC.CRPHYSAGREEID=CRP.CRPHYSAGREEID
            LEFT JOIN SBSECURITIES SB ON CRP.CODEID = SB.CODEID
        WHERE CRP.CRPHYSAGREEID = P_CONTRACT AND CRP.CUSTODYCD = V_CUSTODYCD;
EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('CF602601: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;
End;
/
