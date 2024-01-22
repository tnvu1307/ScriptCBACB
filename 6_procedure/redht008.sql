SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE redht008 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2
 )
IS
--bao cao gia tri giao dich truc tiep - nhom
--created by Chaunh at 18/01/2012
--14/03/2012 repair
   V_STROPTION      VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID        VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
   V_INBRID         VARCHAR2 (5);

   V_NDATE          number;
   VF_DATE          DATE;
   VT_DATE          DATE;
   V_CURRDATE       DATE;
   V_STRFDATE      VARCHAR2(20);
   V_STRTDATE      VARCHAR2(20);

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

   ------------------------

   VF_DATE := to_date(F_DATE,'dd/mm/rrrr');
   VT_DATE := to_date(T_DATE,'dd/mm/rrrr');


   ----VT_DATE := to_date(V_STRINDATE,'dd/mm/rrrr');

    select to_date(varvalue,'dd/mm/rrrr') into V_CURRDATE
    from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM';
    select VT_DATE - VF_DATE + 1 into V_NDATE
    from dual;
----, V_NDATE NDATE, I_DATE indate
OPEN PV_REFCURSOR FOR
----LAY THEO MIEN BAC
SELECT '1' VT , TEN_NHOM, EXECAMT, FEEACR, brid, brname,
    NDATE, indate
FROM
(
select TEN_NHOM, EXECAMT EXECAMT, FEEACR FEEACR, brid, brname,
    V_NDATE NDATE, F_DATE indate
from
(
SELECT REG.TEN_NHOM,
    SUM(MAIN.EXECAMT) EXECAMT, SUM(MAIN.FEEACR) FEEACR, reg.brid, reg.brname
FROM
(
    SELECT KH.REACCTNO SO_TK_MG, MG.CUSTID CUSTID_MG,
        OD.TXDATE, OD.EXECAMT, OD.FEEACR
    FROM REAFLNK KH, remast MG, AFMAST AF, RETYPE,
        (
            SELECT OD.AFACCTNO, OD.TXDATE, OD.EXECAMT EXECAMT, OD.FEEACR FEEACR
            FROM ODMAST OD
            WHERE DELTD <> 'Y' AND OD.EXECAMT <> 0
                and od.txdate <= VT_DATE and od.txdate >= VF_DATE
        ) OD
    WHERE KH.reacctno = MG.acctno
        AND OD.AFACCTNO = AF.ACCTNO
        AND (CASE WHEN VF_DATE >= KH.FRDATE THEN VF_DATE ELSE KH.FRDATE END) <= OD.TXDATE
        AND (CASE WHEN VT_DATE <= KH.TODATE THEN VT_DATE ELSE KH.TODATE END) >= OD.TXDATE
        AND KH.DELTD <> 'Y'
        AND OD.TXDATE < NVL(KH.CLSTXDATE ,'01-JAN-2222')
        AND AF.CUSTID = KH.AFACCTNO
        AND mg.actype = RETYPE.ACTYPE
        AND VF_DATE <= KH.TODATE
        AND VT_DATE >= KH.FRDATE
        and retype.rerole = 'RD'
    union all
    SELECT OD.REACCTNO || OD.reactype SO_TK_MG, od.reacctno CUSTID_MG,
        OD.TXDATE, OD.amt EXECAMT, OD.freeamt FEEACR
    FROM reaf_log OD, RETYPE
    WHERE OD.amt <> 0 AND OD.reactype = RETYPE.ACTYPE and retype.rerole = 'RD'
        and od.txdate <= VT_DATE and od.txdate >= VF_DATE
) MAIN
INNER JOIN
(
    SELECT TN.FULLNAME TEN_NHOM, NHOM.REACCTNO, rel.brid, br.brname
        FROM REGRPLNK NHOM, REGRP TN, cfmast cf, brgrp br, recflnk rel
        WHERE TN.AUTOID = NHOM.REFRECFLNKID AND NHOM.STATUS = 'A'
            and tn.custid = cf.custid and cf.brid = br.brid
            and tn.custid = rel.custid AND TN.AUTOID <> '17'
            AND rel.brid LIKE '00%' and tn.grptype = 'R'
) REG
ON MAIN.SO_TK_MG = REG.REACCTNO
GROUP BY  REG.TEN_NHOM, reg.brid, reg.brname
)
ORDER BY EXECAMT DESC
)
WHERE ROWNUM <= 5

UNION ALL
----LAY THEO MIEN NAM
SELECT '2' VT , TEN_NHOM, EXECAMT, FEEACR, brid, brname,
    NDATE, indate
FROM
(
select TEN_NHOM, EXECAMT EXECAMT, FEEACR FEEACR, brid, brname,
    V_NDATE NDATE, F_DATE indate
from
(
SELECT REG.TEN_NHOM,
    SUM(MAIN.EXECAMT) EXECAMT, SUM(MAIN.FEEACR) FEEACR, reg.brid, reg.brname
FROM
(
    SELECT KH.REACCTNO SO_TK_MG, MG.CUSTID CUSTID_MG,
        OD.TXDATE, OD.EXECAMT, OD.FEEACR
    FROM REAFLNK KH, remast MG, AFMAST AF, RETYPE,
        (
            SELECT OD.AFACCTNO, OD.TXDATE, OD.EXECAMT EXECAMT, OD.FEEACR FEEACR
            FROM ODMAST OD
            WHERE DELTD <> 'Y' AND OD.EXECAMT <> 0
                and od.txdate <= VT_DATE and od.txdate >= VF_DATE
        ) OD
    WHERE KH.reacctno = MG.acctno
        AND OD.AFACCTNO = AF.ACCTNO
        AND (CASE WHEN VF_DATE >= KH.FRDATE THEN VF_DATE ELSE KH.FRDATE END) <= OD.TXDATE
        AND (CASE WHEN VT_DATE <= KH.TODATE THEN VT_DATE ELSE KH.TODATE END) >= OD.TXDATE
        AND KH.DELTD <> 'Y'
        AND OD.TXDATE < NVL(KH.CLSTXDATE ,'01-JAN-2222')
        AND AF.CUSTID = KH.AFACCTNO
        AND mg.actype = RETYPE.ACTYPE
        AND VF_DATE <= KH.TODATE
        AND VT_DATE >= KH.FRDATE
        and retype.rerole = 'RD'
    union all
    SELECT OD.REACCTNO || OD.reactype SO_TK_MG, od.reacctno CUSTID_MG,
        OD.TXDATE, OD.amt EXECAMT, OD.freeamt FEEACR
    FROM reaf_log OD, RETYPE
    WHERE OD.amt <> 0 AND OD.reactype = RETYPE.ACTYPE and retype.rerole = 'RD'
        and od.txdate <= VT_DATE and od.txdate >= VF_DATE
) MAIN
INNER JOIN
(
    SELECT TN.FULLNAME TEN_NHOM, NHOM.REACCTNO, rel.brid, br.brname
        FROM REGRPLNK NHOM, REGRP TN, cfmast cf, brgrp br, recflnk rel
        WHERE TN.AUTOID = NHOM.REFRECFLNKID AND NHOM.STATUS = 'A'
            and tn.custid = cf.custid and cf.brid = br.brid
            and tn.custid = rel.custid AND TN.AUTOID <> '17'
            AND rel.brid LIKE '01%' and tn.grptype = 'R'
) REG
ON MAIN.SO_TK_MG = REG.REACCTNO
GROUP BY  REG.TEN_NHOM, reg.brid, reg.brname
)
ORDER BY EXECAMT DESC
)
WHERE ROWNUM <= 5
;
EXCEPTION
   WHEN OTHERS
   THEN
    --dbms_output.put_line(dbms_utility.format_error_backtrace);
      RETURN;
End;
 
 
 
 
 
/
