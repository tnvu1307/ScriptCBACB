SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE re0100 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   GROUPID        IN       VARCHAR2,
   RECUSTODYCD    IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   I_BRID         IN       VARCHAR2,
   REROLE         IN       VARCHAR2,
   TLID           in       VARCHAR2 default null
 )
IS
--BAO CAO DOANH THU NHA DAU TU
--created by DieuNDA at 21/05/2015
----------------------------------
   V_STROPTION      VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID        VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
   V_INBRID         VARCHAR2 (5);

   VF_DATE          DATE;
   VT_DATE          DATE;
   V_GROUPID        VARCHAR2(10);
   V_STRCUSTODYCD   VARCHAR2(20);
   V_STRREROLE      VARCHAR2(20);
   v_TLID varchar2(4);
   V_CUSTODYCD_KH   VARCHAR2(10);
   V_I_BRID         VARCHAR2(10);

BEGIN

   V_STROPTION := upper(OPT);
   V_INBRID := BRID;
   --v_TLID:=TLID;

   if(V_STROPTION = 'A') then
        V_STRBRID := '%';
    else
        if(V_STROPTION = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := BRID;
        end if;
    end if;

   IF (upper(TLID) = 'ALL' or TLID is null)  THEN
    v_TLID := '%';
   ELSE
    v_TLID := UPPER(TLID);
   END IF;

   IF (upper(GROUPID) = 'ALL' or GROUPID is null)  THEN
    V_GROUPID := '%';
   ELSE
    V_GROUPID := UPPER(GROUPID);
   END IF;

   IF (upper(RECUSTODYCD) = 'ALL' or RECUSTODYCD is null)  THEN
    V_STRCUSTODYCD := '%';
   ELSE
    V_STRCUSTODYCD := UPPER(RECUSTODYCD);
   END IF;

   IF (upper(PV_CUSTODYCD) = 'ALL' or PV_CUSTODYCD is null)  THEN
    V_CUSTODYCD_KH := '%';
   ELSE
    V_CUSTODYCD_KH := UPPER(PV_CUSTODYCD);
   END IF;

   IF (upper(I_BRID) = 'ALL' or I_BRID is null)  THEN
    V_I_BRID := '%';
   ELSE
    V_I_BRID := UPPER(I_BRID);
   END IF;

   IF (upper(REROLE) = 'ALL') or REROLE is null  THEN
    V_STRREROLE := '%';
   ELSE
    V_STRREROLE := REROLE;
   END IF;
   ------------------------
   VF_DATE := to_date(F_DATE,'DD/MM/RRRR');
   VT_DATE := to_date(T_DATE,'DD/MM/RRRR'); -- Fix truoc mot ngay lam viec

OPEN PV_REFCURSOR FOR
WITH MAIN AS (
    select cf.custid so_tk_kh,mst.custid, mst.custid custid_mg, mst.acctno so_tk_MG, cf.fullname ten_kh,
        cf2.fullname ten_mg, retype.afstatus, retype.rerole, cf.custodycd cust_kh,
        cf.activedate activedate, retype.typename retype, rcl.brid, br.brname,
        sum(tl.amt) execamt, sum(tl.FREEAMT) feeacr,
        --sum(case when mrt.mrtype <> 'T' then tl.amt else 0 end)
        0 execamt_N, 0 feeacr_N, --sum(case when mrt.mrtype <> 'T' then tl.FREEAMT else 0 end) feeacr_N,
        --sum(case when mrt.mrtype = 'T' then tl.amt else 0 end)
        0 execamt_T, 0 feeacr_T, --sum(case when mrt.mrtype = 'T' then tl.FREEAMT else 0 end) feeacr_T,
        retype.typename || ' _ ' || allcode.cdcontent BIEU_HH,
        max(mst.recommision) THUONG_HHDK
    from (
                select reacctno,reactype,afacctno,txdate,amt,freeamt
                from reaf_log
                where (   substr(reacctno,1,10) LIKE V_STRCUSTODYCD
                            or fn_getallcusbybroker(substr(reacctno,1,10),VT_DATE)=V_STRCUSTODYCD
                        )
                    UNION
                select substr(re.reacctno,1,10) reacctno,substr(re.reacctno,11,4) reactype,af.acctno afacctno,
                GETCURRDATE txdate,nvl(od.execamt,0) amt,nvl(od.feeacr,0) freeamt from reaflnk re,afmast af,
                    (select afacctno,sum(execamt) execamt,sum(round(execamt * odt.deffeerate/100,2)) feeacr
                        from odmast od,odtype odt
                        where execamt >0
                        and odt.actype=od.actype
                        and txdate=getcurrdate
                        group by afacctno) od
                where re.status='A'
                    and (   substr(re.reacctno,1,10) LIKE V_STRCUSTODYCD
                            or fn_getallcusbybroker(substr(re.reacctno,1,10),VT_DATE)=V_STRCUSTODYCD
                        )
                    and re.afacctno=af.custid
                    and re.frdate<=getcurrdate and re.todate > getcurrdate
                    and od.afacctno(+)=af.acctno
        ) tl,
    REMAST mst, cfmast cf, afmast af, cfmast cf2,
        retype, allcode, recflnk rcl, brgrp br, aftype aft--, mrtype mrt
    where tl.reacctno = mst.custid and tl.reactype = mst.actype
        and tl.afacctno = af.acctno and cf.custid = af.custid
        and mst.custid = cf2.custid
        and mst.actype = retype.actype
        and af.actype=aft.actype
        --and aft.mrtype=mrt.actype
        and rcl.custid=cf2.custid
        and rcl.brid=br.brid
        and rcl.effdate < tl.txdate and  rcl.expdate >= tl.txdate
        and allcode.cdtype = 'RE' and allcode.cdname = 'REROLE' and allcode.cdval = retype.rerole
        AND retype.rerole LIKE V_STRREROLE
        and exists (select gu.grpid from tlgrpusers gu where cf.careby = gu.grpid and gu.tlid like v_TLID )
        and VF_DATE <= tl.txdate
        AND VT_DATE >= tl.txdate
        and cf.custodycd like V_CUSTODYCD_KH
        and rcl.brid like V_I_BRID
    group by cf.custid ,mst.custid, mst.custid , mst.acctno , cf.fullname ,
        cf2.fullname , retype.afstatus, retype.rerole, cf.custodycd ,
        cf.activedate , retype.typename , rcl.brid, br.brname,
        retype.typename || ' _ ' || allcode.cdcontent
)
SELECT * FROM
(
SELECT  GROUPID IN_GROUPID, RECUSTODYCD IN_RECUSTODYCD, REROLE IN_REROLE,to_char(VF_DATE,'DD/MM/RRRR') TU_NGAY, to_char(VT_DATE,'DD/MM/RRRR') DEN_NGAY,
    main.so_tk_kh, main.custid, main.so_tk_MG,
    main.ten_kh, main.ten_mg, main.rerole,main.brid, main.brname,
    main.cust_kh, main.custid_mg, main.retype, main.BIEU_HH,
    sum(main.execamt_N) execamt_N, suM(main.feeacr_N) feeacr_N,
    sum(main.execamt_T) execamt_T, suM(main.feeacr_T) feeacr_T,
    sum(main.execamt) execamt, suM(main.feeacr) feeacr,
    reg.ten_truong_nhom, reg.ten_nhom || '_' || reg.ten_truong_nhom ten_nhom,
    reg.reacctno ma_nhom, NVL(reg.autoid,0) autoid
FROM
    MAIN
    LEFT JOIN
    (

    SELECT cfmast.fullname ten_truong_nhom, tn.fullname ten_nhom, nhom.CUSTID, SP_FORMAT_REGRP_MAPCODE(tn.autoid) AUTOID,nhom.CUSTID reacctno
        FROM (

                select refrecflnkid AUTOID,REACCTNO CUSTID
                from regrplnk
                where status='A' and ( substr(REACCTNO,1,10) like V_STRCUSTODYCD or fn_getallcusbybroker(substr(REACCTNO,1,10),VT_DATE) like V_STRCUSTODYCD )
                GROUP BY refrecflnkid,REACCTNO
                    UNION
                SELECT AUTOID,CUSTID||ACTYPE CUSTID FROM REGRP WHERE STATUS='A' and CUSTID like V_STRCUSTODYCD
            ) nhom, regrp tn, cfmast
        WHERE tn.autoid = nhom.autoid
            AND tn.custid = cfmast.custid
            group by cfmast.fullname,tn.fullname,tn.autoid,nhom.CUSTID
    ) reg
    ON MAIN.so_tk_MG = reg.CUSTID
GROUP BY main.so_tk_kh, main.custid, main.so_tk_MG,
    main.ten_kh, main.ten_mg, main.rerole,main.brid, main.brname,
    main.cust_kh, main.custid_mg, main.retype, main.BIEU_HH, reg.ten_truong_nhom, reg.ten_nhom, reg.reacctno, reg.AUTOID
having sum(main.execamt)>0
)
WHERE autoid LIKE V_GROUPID
;
EXCEPTION
   WHEN OTHERS
   THEN
    --dbms_output.put_line(dbms_utility.format_error_backtrace);
      RETURN;
End;
/
