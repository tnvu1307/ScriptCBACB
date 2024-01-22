SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE redht001 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   GROUPID        IN       VARCHAR2,
   XACNHAN        IN       VARCHAR2
 )
IS
--bao cao gia tri giao dich truc tiep - nhom
--created by Chaunh at 18/01/2012
--14/03/2012 repair
   V_STROPTION      VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID        VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
   V_INBRID         VARCHAR2 (5);

   VF_DATE          DATE;
   VT_DATE          DATE;
   V_GROUPID        VARCHAR2(10);
   V_STRXACNHAN     VARCHAR2(100);

BEGIN

   V_STROPTION := upper(OPT);
   V_INBRID := BRID;

   if(V_STROPTION = 'A') then
        V_STRBRID := '%';
    else
        if(V_STROPTION = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := BRID;
        end if;
    end if;
    V_GROUPID := UPPER(GROUPID);
   ------------------------
   VF_DATE := to_date(F_DATE,'DD/MM/RRRR');
   VT_DATE := to_date(T_DATE,'DD/MM/RRRR');
   V_STRXACNHAN := XACNHAN;

OPEN PV_REFCURSOR FOR
SELECT V_STRXACNHAN STRXACNHAN, MAIN.TXDATE, REG.TEN_NHOM, REG.REACCTNO MA_NHOM,
    SUM(MAIN.EXECAMT) EXECAMT, SUM(MAIN.FEEACR) FEEACR
FROM
(
    SELECT KH.REACCTNO SO_TK_MG, substr(KH.REACCTNO,1,10)CUSTID_MG,
        OD.TXDATE, OD.EXECAMT, OD.FEEACR
    FROM REAFLNK KH, /*RECFLNK MG,*/
        AFMAST AF,/*CFMAST CF1, CFMAST CF2, RETYPE,*/
        (
            SELECT OD.AFACCTNO, OD.TXDATE, OD.EXECAMT EXECAMT,
                (CASE WHEN OD.EXECAMT >0 AND OD.FEEACR = 0 --AND OD.STSSTATUS = 'N'
                THEN ROUND(ODT.DEFFEERATE/100,5)*OD.EXECAMT
                ELSE OD.FEEACR END) FEEACR
            FROM ODMAST OD, ODTYPE ODT
            WHERE DELTD <> 'Y' AND ODT.ACTYPE = OD.ACTYPE AND OD.EXECAMT <> 0
                and od.txdate <= VT_DATE and od.txdate >= VF_DATE
            UNION ALL
            SELECT OD.AFACCTNO, OD.TXDATE, OD.EXECAMT EXECAMT,
                OD.FEEACR FEEACR
            FROM ODMASTHIST OD
            WHERE DELTD <> 'Y' AND OD.EXECAMT <> 0
                and od.txdate <= VT_DATE and od.txdate >= VF_DATE
        ) OD
    WHERE /*KH.REFRECFLNKID = MG.AUTOID
        AND*/ OD.AFACCTNO = AF.ACCTNO
        AND VF_DATE <= OD.TXDATE
        AND VT_DATE >= OD.TXDATE
        AND KH.DELTD <> 'Y'
        AND OD.TXDATE < NVL(KH.CLSTXDATE ,'01-JAN-2222')
        --AND CF1.CUSTID = AF.CUSTID
        AND AF.CUSTID = KH.AFACCTNO
        ---AND CF2.CUSTID = MG.CUSTID
        --AND SUBSTR(KH.REACCTNO, 11,4) = RETYPE.ACTYPE
        AND VF_DATE <= KH.TODATE
        AND VT_DATE >= KH.FRDATE
) MAIN
INNER JOIN
(
    SELECT TN.FULLNAME TEN_NHOM, NHOM.REACCTNO
    FROM REGRPLNK NHOM, REGRP TN
    WHERE TN.AUTOID = NHOM.REFRECFLNKID AND NHOM.STATUS = 'A'
        and TN.autoid = V_GROUPID
        and TN.autoid <> '17'
        and tn.grptype = 'R'
) REG
ON MAIN.SO_TK_MG = REG.REACCTNO
GROUP BY  MAIN.TXDATE, REG.TEN_NHOM, REG.REACCTNO
;
EXCEPTION
   WHEN OTHERS
   THEN
    --dbms_output.put_line(dbms_utility.format_error_backtrace);
      RETURN;
End;
/
