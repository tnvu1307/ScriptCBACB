SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE redht006 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   GROUPID        IN       VARCHAR2
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
   V_GROUPID        VARCHAR2(10);

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

    if(UPPER(GROUPID) = 'ALL' or GROUPID is null) then
        V_GROUPID := '%';
    else
        V_GROUPID := UPPER(GROUPID);
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
select TEN_NHOM, ROUND(sum(EXECAMT),0) EXECAMT, ROUND(sum(FEEACR),0) FEEACR, ROUND(sum(MRAMT),0) MRAMT, brid, brname,
    V_NDATE NDATE, F_DATE indate
from
(
SELECT TEN_NHOM, 0 EXECAMT, 0 FEEACR, AVG(MRAMT) MRAMT, brid, brname
FROM
(
SELECT MAIN.TXDATE, REG.TEN_NHOM, REG.REACCTNO MA_NHOM,
    SUM(MAIN.MRAMT) MRAMT, reg.brid, reg.brname
FROM
(
    SELECT KH.REACCTNO SO_TK_MG, MG.CUSTID CUSTID_MG,
        OD.TXDATE, OD.MRAMT
    FROM REAFLNK KH, RECFLNK MG,
        AFMAST AF,CFMAST CF1, CFMAST CF2, RETYPE,
        (
            SELECT TXDATE, AFACCTNO, max(MRAMT-NVL(INTMRAMT,0)) MRAMT
            FROM TBL_MR3007_LOG
            WHERE MRAMT <> 0
            GROUP BY TXDATE, AFACCTNO
/*            UNION ALL
            SELECT V_CURRDATE TXDATE, TRFACCTNO AFACCTNO,
                SUM(NVL((CASE WHEN FTYPE = 'AF' THEN PRINNML+PRINOVD ELSE 0 END),0)) MRAMT
            FROM LNMAST
            GROUP BY TRFACCTNO
            HAVING SUM(NVL((CASE WHEN FTYPE = 'AF' THEN PRINNML+PRINOVD ELSE 0 END),0)) <> 0*/
        ) OD
    WHERE KH.REFRECFLNKID = MG.AUTOID
        AND OD.AFACCTNO = AF.ACCTNO
        AND (CASE WHEN VF_DATE >= KH.FRDATE THEN VF_DATE ELSE KH.FRDATE END) <= OD.TXDATE
        AND (CASE WHEN VT_DATE <= KH.TODATE THEN VT_DATE ELSE KH.TODATE END) >= OD.TXDATE
        AND KH.DELTD <> 'Y'
        AND OD.TXDATE < NVL(KH.CLSTXDATE ,'01-JAN-2222')
        AND CF1.CUSTID = AF.CUSTID AND AF.CUSTID = KH.AFACCTNO
        AND CF2.CUSTID = MG.CUSTID
        AND SUBSTR(KH.REACCTNO, 11,4) = RETYPE.ACTYPE
        AND VF_DATE <= KH.TODATE
        AND VT_DATE >= KH.FRDATE
) MAIN
INNER JOIN
(
    SELECT TN.FULLNAME TEN_NHOM, NHOM.REACCTNO, cf.brid, br.brname
        FROM REGRPLNK NHOM, REGRP TN, cfmast cf, brgrp br
        WHERE TN.AUTOID = NHOM.REFRECFLNKID AND NHOM.STATUS = 'A'
            and tn.custid = cf.custid and cf.brid = br.brid
            AND SP_FORMAT_REGRP_MAPCODE(TN.AUTOID) LIKE
            (case when UPPER(GROUPID) = 'ALL' or GROUPID is null then '%' else SP_FORMAT_REGRP_MAPCODE(V_GROUPID) end) || '%'
            and tn.grptype = 'R' AND TN.AUTOID <> '17'
) REG
ON MAIN.SO_TK_MG = REG.REACCTNO
GROUP BY  MAIN.TXDATE, REG.TEN_NHOM, REG.REACCTNO, reg.brid, reg.brname
)
GROUP BY TEN_NHOM, brid, brname
union all
SELECT REG.TEN_NHOM,
    SUM(MAIN.EXECAMT) EXECAMT, SUM(MAIN.FEEACR) FEEACR, 0 MRAMT, reg.brid, reg.brname
FROM
(
    SELECT KH.REACCTNO SO_TK_MG, substr(kh.reacctno,1,10) CUSTID_MG,
        OD.TXDATE, OD.EXECAMT, OD.FEEACR
    FROM REAFLNK KH, AFMAST AF,
        (
            SELECT OD.AFACCTNO, OD.TXDATE, OD.EXECAMT EXECAMT,
                (CASE WHEN OD.EXECAMT >0 AND OD.FEEACR = 0 --AND OD.STSSTATUS = 'N'
                THEN ROUND(ODT.DEFFEERATE/100,5)*OD.EXECAMT
                ELSE OD.FEEACR END) FEEACR
            FROM ODMAST OD, ODTYPE ODT
            WHERE DELTD <> 'Y' AND ODT.ACTYPE = OD.ACTYPE AND OD.EXECAMT <> 0
                and od.txdate = V_CURRDATE
        ) OD
    WHERE OD.AFACCTNO = AF.ACCTNO
        AND KH.FRDATE <= OD.TXDATE
        AND KH.TODATE >= OD.TXDATE
        AND KH.DELTD <> 'Y'
        AND OD.TXDATE < NVL(KH.CLSTXDATE ,'01-JAN-2222')
        AND AF.CUSTID = KH.AFACCTNO
        AND VF_DATE <= OD.TXDATE
        AND VT_DATE >= OD.TXDATE
        AND VF_DATE <= KH.TODATE
        AND VT_DATE >= KH.FRDATE
) MAIN
INNER JOIN
(
    SELECT TN.FULLNAME TEN_NHOM, NHOM.REACCTNO, cf.brid, br.brname
        FROM REGRPLNK NHOM, REGRP TN, cfmast cf, brgrp br
        WHERE TN.AUTOID = NHOM.REFRECFLNKID AND NHOM.STATUS = 'A'
            and tn.custid = cf.custid and cf.brid = br.brid
            AND SP_FORMAT_REGRP_MAPCODE(TN.AUTOID) LIKE
            (case when UPPER(GROUPID) = 'ALL' or GROUPID is null then '%' else SP_FORMAT_REGRP_MAPCODE(V_GROUPID) end) || '%'
            and tn.grptype = 'R' AND TN.AUTOID <> '17'
) REG
ON MAIN.SO_TK_MG = REG.REACCTNO
GROUP BY  REG.TEN_NHOM, reg.brid, reg.brname
union
SELECT REG.TEN_NHOM,
    SUM(MAIN.EXECAMT) EXECAMT, SUM(MAIN.FEEACR) FEEACR, 0 MRAMT, reg.brid, reg.brname
FROM
(
    SELECT REACCTNO||reactype SO_TK_MG, REACCTNO CUSTID_MG,
        sum(amt) EXECAMT, sum(Freeamt) FEEACR
    from reaf_log
    where txdate >= VF_DATE
        AND txdate <= VT_DATE
    group by REACCTNO||reactype , REACCTNO
) MAIN
INNER JOIN
(
    SELECT TN.FULLNAME TEN_NHOM, NHOM.REACCTNO, cf.brid, br.brname
        FROM REGRPLNK NHOM, REGRP TN, cfmast cf, brgrp br
        WHERE TN.AUTOID = NHOM.REFRECFLNKID AND NHOM.STATUS = 'A'
            and tn.custid = cf.custid and cf.brid = br.brid
            AND SP_FORMAT_REGRP_MAPCODE(TN.AUTOID) LIKE
            (case when UPPER(GROUPID) = 'ALL' or GROUPID is null then '%' else SP_FORMAT_REGRP_MAPCODE(V_GROUPID) end) || '%'
            and tn.grptype = 'R' AND TN.AUTOID <> '17'
) REG
ON MAIN.SO_TK_MG = REG.REACCTNO
GROUP BY  REG.TEN_NHOM, reg.brid, reg.brname
)
group by TEN_NHOM, brid, brname

;
EXCEPTION
   WHEN OTHERS
   THEN
    --dbms_output.put_line(dbms_utility.format_error_backtrace);
      RETURN;
End;
/
