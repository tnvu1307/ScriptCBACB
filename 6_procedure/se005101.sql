SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE SE005101(
    PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   P_CUSTODYCD            IN       VARCHAR2, /*SO TK LUU KY */
   P_CONTRACT             IN       VARCHAR2, /*SO HOP DONG*/
   P_CFAUTH               IN       VARCHAR2, /*NGUOI NHAN */
   P_SIGNTYPE             IN       VARCHAR2 /*NGUOI KY */
   )
IS
    -- REPORT ON THE DAY BECOME/IS NO LONGER MAJOR SHAREHOLDER, INVESTORS HOLDING 5% OR MORE OF SHARES
    -- PERSON      DATE                 COMMENTS
    -- ---------   ------               -------------------------------------------
    -- DU.PHAN    23-10-2019           CREATED
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0

      V_CUSTODYCD         VARCHAR2(20);
BEGIN
     V_STROPTION := OPT;
     IF V_STROPTION = 'A' THEN
        V_STRBRID := '%';
     ELSIF V_STROPTION = 'B' THEN
        V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
     ELSE
        V_STRBRID:=BRID;
     END IF;

    V_CUSTODYCD := REPLACE(P_CUSTODYCD,'.','');
    OPEN PV_REFCURSOR FOR

        SELECT DOC.QTTY CRPEXCQTTY,
         SB.PARVALUE SBPARVALUE,
          DOC.QTTY*SB.PARVALUE CRPEXCVALUE,
           CRP.NO CRPNO
        FROM DOCSTRANSFER DOC
            LEFT JOIN CRPHYSAGREE CRP ON DOC.CRPHYSAGREEID = CRP.CRPHYSAGREEID
            LEFT JOIN SBSECURITIES SB ON CRP.CODEID = SB.CODEID
        WHERE CRP.CRPHYSAGREEID = P_CONTRACT AND CRP.CUSTODYCD = V_CUSTODYCD;

EXCEPTION
  WHEN OTHERS
   THEN
      PLOG.ERROR ('CF602501: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RETURN;
END;
/
