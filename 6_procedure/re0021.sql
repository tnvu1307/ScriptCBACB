SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE re0021 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   RECUSTODYCD    IN       VARCHAR2,
   I_BRID         IN       VARCHAR2,
   PVRATE         in       VARCHAR2
 )
IS
--bao cao gia tri giao dich truc tiep - nhom
--created by DieuNDA at 09/06/2015
----------------------------------

   V_STROPTION      VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID        VARCHAR2 (60);            -- USED WHEN V_NUMOPTION > 0
   V_INBRID         VARCHAR2 (5);

   VF_DATE          DATE;
   VT_DATE          DATE;
   V_STRCUSTODYCD   VARCHAR2(20);
   V_I_BRID      VARCHAR2(20);
   v_currdate   date;
   v_Rate number;

BEGIN

   V_STROPTION := upper(OPT);
   V_INBRID := BRID;
   v_currdate := getcurrdate;
   --v_TLID:=TLID;
   v_rate := TO_NUMBER(PVRATE)/100;
   if(V_STROPTION = 'A') then
        V_STRBRID := '%';
    else
        if(V_STROPTION = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := BRID;
        end if;
    end if;


   IF (upper(RECUSTODYCD) = 'ALL' or RECUSTODYCD is null)  THEN
    V_STRCUSTODYCD := '%';
    --v_TenMG:='ALL';
   ELSE
    V_STRCUSTODYCD := UPPER(RECUSTODYCD);
   --select upper(fullname) into v_TenMG from cfmast where custid = RECUSTODYCD and rownum <= 1;
   END IF;

   IF (upper(I_BRID) = 'ALL') or I_BRID is null  THEN
    V_I_BRID := '%';
   ELSE
    V_I_BRID := I_BRID;
   END IF;
   ------------------------
   VF_DATE := to_date(F_DATE,'DD/MM/RRRR');
   VT_DATE := to_date(T_DATE,'DD/MM/RRRR'); -- Fix truoc mot ngay lam viec



OPEN PV_REFCURSOR FOR

    select VF_DATE FRDATE,VT_DATE TODATE, rcf.custid, nvl(tl.tlname,'') tlname, cf.fullname, rcf.brid, nvl(br.brname,'') brname,
       sum(od.bondtypetp) execamt, sum(od.feebondtypetp) feeacr, v_Rate cRate, sum(od.feebondtypetp)*v_Rate commission
    from
        (
            select od.txdate, af.custid,sum(od.execamt) bondtypetp,sum(round(od.execamt * odt.deffeerate/100,2)) feebondtypetp
            from vw_odmast_all od, odtype odt, sbsecurities sb, afmast af
            where odt.actype=od.actype
                and od.execamt > 0
                and od.deltd <> 'Y'
                --and sb.bondtype = '001'
                and sb.tradeplace='010'
                and sb.codeid = od.codeid
                and af.acctno = od.afacctno
                and txdate between VF_DATE and VT_DATE
            group by od.txdate, af.custid


        ) od, reaflnk raf,
        /*(
            select substr(acctno,1,10) custid, todate txdate, sum(rbondtypetp) rbondtypetp,sum(rfeebondtypetp) rfeebondtypetp
            from vw_reintran_all tran
            where rbondtypetp+rfeebondtypetp>0
                and todate between VF_DATE and VT_DATE
            group by substr(acctno,1,10), todate
        ) tr,*/ recflnk rcf, brgrp br, tlprofiles tl, cfmast cf
    where --rcf.custid = tr.custid
        raf.afacctno=od.custid
        and substr(raf.reacctno,1,10) = rcf.custid
        and raf.frdate <= od.txdate and nvl(raf.clstxdate,raf.todate) > od.txdate
        and rcf.effdate <= od.txdate and rcf.expdate > od.txdate
        and rcf.brid = br.brid(+)
        and rcf.tlid = tl.tlid(+)
        and cf.custid = rcf.custid
        and rcf.custid like V_STRCUSTODYCD
        and rcf.brid like V_I_BRID
    group by rcf.custid, nvl(tl.tlname,''), cf.fullname, rcf.brid, nvl(br.brname,'')
    ;
EXCEPTION
   WHEN OTHERS
   THEN
    --dbms_output.put_line(dbms_utility.format_error_backtrace);
      RETURN;
End;
 
 
/
