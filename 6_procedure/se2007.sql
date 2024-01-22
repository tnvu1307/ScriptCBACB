SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE SE2007 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2,
   SYMBOL         IN       VARCHAR2,
   TLTXCD         IN       VARCHAR2
 )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
--
-- MODIFICATION HISTORY
-- PERSON      DATE       COMMENTS
-- Diennt      30/09/2011 Create
-- ---------   ------     -------------------------------------------
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH

   -- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
   V_STRPV_CUSTODYCD VARCHAR2(20);
   V_STRPV_AFACCTNO VARCHAR2(20);
   V_INBRID        VARCHAR2(4);
   V_STRBRID      VARCHAR2 (50);
   V_SYMBOL        VARCHAR2 (50);
   V_TLTXCD        VARCHAR2 (50);

   v_fromdate   date;
   v_todate     date;

BEGIN
/*
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;*/

--   V_STRTLID:=TLID;


    V_STROPTION := upper(OPT);
    V_INBRID := BRID;
    if(V_STROPTION = 'A') then
        V_STRBRID := '%%';
    else
        if(V_STROPTION = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := V_INBRID;
        end if;
    end if;

   IF(PV_CUSTODYCD <> 'ALL')
   THEN
        V_STRPV_CUSTODYCD  := PV_CUSTODYCD;
   ELSE
        V_STRPV_CUSTODYCD  := '%%';
   END IF;

    IF(PV_AFACCTNO <> 'ALL')
   THEN
        V_STRPV_AFACCTNO  := PV_AFACCTNO;
   ELSE
        V_STRPV_AFACCTNO := '%%';
   END IF;

   IF(SYMBOL <> 'ALL')THEN
        V_SYMBOL  := SYMBOL;
   ELSE
        V_SYMBOL := '%%';
   END IF;

   IF(TLTXCD <> 'ALL')THEN
        V_TLTXCD  := TLTXCD;
   ELSE
        V_TLTXCD := '2202,2203,2251,2253';
   END IF;


   v_fromdate := to_date(F_DATE,'dd/mm/rrrr');
   v_todate   := to_date(T_DATE,'dd/mm/rrrr');

OPEN PV_REFCURSOR
  FOR

  SELECT SE.CUSTODYCD, SE.AFACCTNO, CF.FULLNAME,AFT.MNEMONIC, SE.TXDATE ,SE.SYMBOL, SE.NAMT, SE.TXDESC
  FROM vw_setran_gen SE, CFMAST CF, AFMAST AF, AFTYPE AFT
    where CF.CUSTID = AF.CUSTID AND SE.AFACCTNO = AF.ACCTNO
    AND AF.ACTYPE = AFT.ACTYPE
    AND CASE WHEN tltxcd in ('2202','2203','2251') AND field IN ('TRADE','DEPOSIT','MORTAGE') THEN 1
        WHEN TLTXCD IN ('2253') AND FIELD = 'TRADE' THEN 1
        ELSE 0 END > 0
    ---AND SE.TXDATE BETWEEN v_fromdate AND v_todate
    ---AND SE.CUSTODYCD LIKE V_STRPV_CUSTODYCD
    ---AND SE.AFACCTNO LIKE V_STRPV_AFACCTNO
    ---AND INSTR(V_TLTXCD,SE.tltxcd) > 0
    ---AND SE.SYMBOL LIKE V_SYMBOL
  order by se.txdate, se.txnum
;

EXCEPTION
   WHEN OTHERS
   THEN

      RETURN;
End;
/
