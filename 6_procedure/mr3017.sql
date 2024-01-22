SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE mr3017 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   pv_OPT            IN       VARCHAR2,
   pv_BRID           IN       VARCHAR2,
   pv_CUSTDYCD       IN       VARCHAR2,
   pv_AFACCTNO       IN       VARCHAR2,
   I_DATE         IN       VARCHAR2,
   TLID            IN       VARCHAR2
)
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
--
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- LINHLNB   11-Apr-2012  CREATED

-- ---------   ------  -------------------------------------------
   l_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   l_STRBRID          VARCHAR2 (4);
   l_AFACCTNO         VARCHAR2 (20);
   v_IDATE           DATE; --ngay lam viec gan ngay idate nhat
   v_CurrDate        DATE;
   V_INBRID        VARCHAR2(4);
   V_STRBRID      VARCHAR2 (50);
   V_STROPTION VARCHAR2(10);
   V_STRTLID           VARCHAR2(6);
   v_CUSTDYCD 		VARCHAR2 (20);

-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN




   V_STRTLID:= TLID;
   V_STROPTION := upper(pv_OPT);
   V_INBRID := pv_BRID;
    if(V_STROPTION = 'A') then
        V_STRBRID := '%%';
    else
        if(V_STROPTION = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := V_INBRID;
        end if;
    end if;
   l_AFACCTNO  := replace(pv_AFACCTNO,'.','');


   IF (pv_AFACCTNO <> 'ALL')
   THEN
      l_AFACCTNO := pv_AFACCTNO;
   ELSE
      l_AFACCTNO := '%%';
   END IF;

   IF (Pv_CUSTDYCD <> 'ALL')
   THEN
      v_CUSTDYCD := Pv_CUSTDYCD;
   ELSE
      v_CUSTDYCD := '%%';
   END IF;
 -- END OF GETTING REPORT'S PARAMETERS

   SELECT max(sbdate) INTO v_IDATE  FROM sbcurrdate WHERE sbtype ='B' AND sbdate <= to_date(I_DATE,'DD/MM/RRRR');
   select to_date(varvalue,'DD/MM/RRRR') into v_CurrDate from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM';



  -- GET REPORT'S DATA
    OPEN PV_REFCURSOR
        for
    select v.*,CF.FULLNAME
    from tbl_mr3007_log v, afmast af,cfmast cf
    where txdate = v_idate AND v.afacctno like l_AFACCTNO
    and v.trade + v.mortage + v.receiving + v.EXECQTTY + v.buyqtty > 0
    AND af.acctno like v.afacctno
    and af.custid = cf.custid
	and cf.custodycd like v_CUSTDYCD
    AND V.seass>0
    AND (af.brid LIKE V_STRBRID or instr(V_STRBRID,af.brid) <> 0 )
    and exists (select gu.grpid from tlgrpusers gu where af.careby = gu.grpid and gu.tlid = V_STRTLID )
    order by v.symbol;




 EXCEPTION
   WHEN OTHERS
   THEN
        RETURN;
END;
 
 
/
