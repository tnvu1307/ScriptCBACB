SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE LN0030 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_MRALLOW     IN       VARCHAR2
 )
IS
-- Report Name: Danh sach khach hang duoc cap han muc bao lanh
-- Creator: HoangNX
-- Created Date: 17/12/2014

   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (40);
   V_TODATE           DATE;
   V_STRCUSTODYCD     VARCHAR2(30);
   V_MRALLOW          VARCHAR2(20);

BEGIN
   V_STROPTION := UPPER(OPT);
   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL') THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%';
   END IF;

   V_STRCUSTODYCD := UPPER(PV_CUSTODYCD);
   IF (V_STRCUSTODYCD = 'ALL') THEN
     V_STRCUSTODYCD := '%';
   END IF;

   V_MRALLOW := UPPER(PV_MRALLOW);
   IF (V_MRALLOW = 'ALL') THEN
     V_MRALLOW := '%';
   ELSIF V_MRALLOW = 'YES' THEN
     V_MRALLOW := 'Y';
   ELSE
     V_MRALLOW := 'N';
   END IF;

   V_TODATE := TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);

    OPEN PV_REFCURSOR
      FOR
          SELECT tran.txdate, cf.custodycd, cf.fullname, cf.marginallow, tran.toLoanLimit, lg.tlid, lg.offid,
                 tl.tlfullname tlname, ck.tlfullname ckname
          FROM cfmast cf,
          (SELECT t.tltxcd, t.acctno custid, Max(t.txdate) txdate, Max(t.txnum) txnum, SUM(t.namt) toLoanLimit
               FROM vw_aftran_all t, apptx ap
               WHERE t.txdate <= V_TODATE
                     AND t.txcd = ap.txcd
                     AND ap.apptype = 'CF'
                     AND ap.tblname = 'CFMAST'
                     AND ap.field = 'T0LOANLIMIT'
                     AND t.tltxcd = '1809'
              GROUP BY t.tltxcd, t.acctno
           ) tran, vw_tllog_all lg, tlprofiles tl, tlprofiles ck
          WHERE cf.custid = tran.custid
                AND tran.txdate = lg.txdate
                AND tran.txnum = lg.txnum
                AND tran.tltxcd = lg.tltxcd
                AND tl.tlid = lg.tlid
                AND ck.tlid = lg.offid
                AND cf.marginallow LIKE V_MRALLOW
                AND cf.custodycd LIKE V_STRCUSTODYCD
          ORDER BY tran.txdate;

EXCEPTION
   WHEN OTHERS THEN RETURN;

END LN0030;

 
 
 
/
