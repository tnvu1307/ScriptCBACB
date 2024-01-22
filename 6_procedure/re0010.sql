SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE re0010 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   GROUPID        IN       VARCHAR2,
   RECUSTODYCD    IN       VARCHAR2,
   REROLE         IN       VARCHAR2,
   TLID           in       VARCHAR2 default null
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
   V_STRCUSTODYCD   VARCHAR2(20);
   V_STRREROLE      VARCHAR2(20);
   v_TLID varchar2(4);
   v_TenMG varchar2(150);
   v_TenPhong varchar2(150);
   v_TenTP varchar2(150);
   v_currdate   date;

BEGIN

   V_STROPTION := upper(OPT);
   V_INBRID := BRID;
   v_currdate := getcurrdate;
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
    v_TenPhong:= 'ALL';
    v_TenTP:= 'ALL';
   ELSE
    V_GROUPID := UPPER(GROUPID);
    select gr.fullname, cf.fullname into v_TenPhong, v_TenTP
    from regrp gr, cfmast cf
    where gr.custid = cf.custid
        and SP_FORMAT_REGRP_MAPCODE(gr.autoid) = GROUPID
        and rownum<=1;
   END IF;

   IF (upper(RECUSTODYCD) = 'ALL' or RECUSTODYCD is null)  THEN
    V_STRCUSTODYCD := '%';
    v_TenMG:='ALL';
   ELSE
    V_STRCUSTODYCD := UPPER(RECUSTODYCD);
    select upper(fullname) into v_TenMG from cfmast where custid = RECUSTODYCD and rownum <= 1;
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
        cf.activedate activedate, retype.typename retype,
        sum(tl.amt) execamt, sum(tl.FREEAMT) feeacr,
        retype.typename || ' _ ' || allcode.cdcontent BIEU_HH,
        max(mst.recommision) THUONG_HHDK,
        substr(fn_getallbrokergrplnk(tl.reacctno,tl.txdate),-10,10) ql_mg
    from (

                select reacctno,reactype,afacctno,txdate,amt,freeamt
                from  (
                        select re.reacctno,re.reactype,af.custid afacctno,re.txdate,re.amt,re.freeamt
                        from reaf_log re,afmast af
                        where  re.afacctno = af.acctno and '20-Sep-2015' >= re.txdate
                              union ALL
                        select * from reaf_log
                        where  '20-Sep-2015' < txdate

                      ) tl
                /*where (   substr(reacctno,1,10) LIKE V_STRCUSTODYCD
                            or fn_getallcusbybroker(substr(reacctno,1,10),VT_DATE)=V_STRCUSTODYCD
                        )*/
                       -- case when V_STRCUSTODYCD='%' then 1 else instr(fn_getallbrokergrplnk(substr(reacctno,1,10),txdate),V_STRCUSTODYCD) end > 0
                    UNION
                select substr(re.reacctno,1,10) reacctno,substr(re.reacctno,11,4) reactype,af.custid afacctno,
                v_currdate txdate,nvl(od.execamt,0) amt,nvl(od.feeacr,0) freeamt from reaflnk re,afmast af,
                    (select afacctno,sum(execamt) execamt,sum(round(execamt * odt.deffeerate/100,2)) feeacr
                        from odmast od,odtype odt
                        where execamt >0
                        and odt.actype=od.actype
                        and txdate=v_currdate
                        group by afacctno) od
                where re.status='A' --and substr(re.reacctno,1,10) LIKE V_STRCUSTODYCD
                    and /*(   substr(re.reacctno,1,10) LIKE V_STRCUSTODYCD
                            or fn_getallcusbybroker(substr(re.reacctno,1,10),VT_DATE)=V_STRCUSTODYCD
                        )*/
                        --case when V_STRCUSTODYCD='%' then 1 else instr(fn_getallbrokergrplnk(substr(reacctno,1,10),getcurrdate),V_STRCUSTODYCD) end > 0 and
                    re.afacctno=af.custid
                    and re.frdate<=v_currdate and re.todate > v_currdate
                    and od.afacctno(+)=af.acctno

        ) tl

        ,
    REMAST mst, cfmast cf,  cfmast cf2,
        retype, allcode
    where tl.reacctno = mst.custid and tl.reactype = mst.actype
        and tl.afacctno =  cf.custid
        and mst.custid = cf2.custid
        and mst.actype = retype.actype
        and allcode.cdtype = 'RE' and allcode.cdname = 'REROLE' and allcode.cdval = retype.rerole
        AND retype.rerole LIKE V_STRREROLE
        and exists (select gu.grpid from tlgrpusers gu where cf.careby = gu.grpid and gu.tlid like v_TLID )
        and case when tl.reacctno like V_STRCUSTODYCD then 1 else instr(fn_getallbrokergrplnk(tl.reacctno,tl.txdate),V_STRCUSTODYCD) end > 0
        and VF_DATE <= tl.txdate
        AND VT_DATE >= tl.txdate
    group by cf.custid ,mst.custid, mst.custid , mst.acctno , cf.fullname ,
        cf2.fullname , retype.afstatus, retype.rerole, cf.custodycd ,
        cf.activedate , retype.typename ,
        retype.typename || ' _ ' || allcode.cdcontent,
        substr(fn_getallbrokergrplnk(tl.reacctno,tl.txdate),-10,10)
)
SELECT * FROM
(
SELECT  GROUPID IN_GROUPID, RECUSTODYCD IN_RECUSTODYCD, REROLE IN_REROLE,
    to_char(VT_DATE,'DD/MM/RRRR') DEN_NGAY, v_TenMG i_TenMG, v_TenPhong i_TenPhong, v_TenTP i_TenTP,
    main.so_tk_kh, main.custid, main.so_tk_MG,
    main.ten_kh, main.ten_mg, main.rerole,
    main.cust_kh, main.custid_mg, main.retype, main.BIEU_HH,main.ql_mg,
    sum(main.execamt) execamt, suM(main.feeacr) feeacr,
    MAX(TMG.THUONG)thuong_mg,
    reg.ten_truong_nhom, reg.ten_nhom || '_' || reg.ten_truong_nhom ten_nhom,
    reg.reacctno ma_nhom, NVL(reg.autoid,0) autoid,
    MAX(TMG.THUONG)thuong_nhom

FROM
    MAIN
    LEFT JOIN
    (

    SELECT cfmast.fullname ten_truong_nhom, tn.fullname ten_nhom, nhom.CUSTID, SP_FORMAT_REGRP_MAPCODE(tn.autoid) AUTOID,nhom.CUSTID reacctno
        FROM (
                select refrecflnkid AUTOID,REACCTNO CUSTID
                from regrplnk
                where status='A'
                    and case when REACCTNO like V_STRCUSTODYCD then 1 else instr(fn_getallbrokergrplnk(custid,VT_DATE),V_STRCUSTODYCD) end > 0
                GROUP BY refrecflnkid,REACCTNO
                    UNION
                SELECT AUTOID,CUSTID||ACTYPE CUSTID FROM REGRP WHERE STATUS='A' and CUSTID like V_STRCUSTODYCD
            ) nhom, regrp tn, cfmast
        WHERE tn.autoid = nhom.autoid
            AND tn.custid = cfmast.custid
            group by cfmast.fullname,tn.fullname,tn.autoid,nhom.CUSTID
    ) reg
    ON MAIN.so_tk_MG = reg.CUSTID
    ,(
        select main.so_tk_MG , fn_re_icrate(main.so_tk_MG,suM(main.feeacr),sum(main.execamt))/100 *suM(main.feeacr) thuong
        from main
        group by main.so_tk_MG
    )tmg
where main.so_tk_MG=tmg.so_tk_MG
GROUP BY main.so_tk_kh, main.custid, main.so_tk_MG,
    main.ten_kh, main.ten_mg, main.rerole,
    main.cust_kh, main.custid_mg, main.retype, main.BIEU_HH, reg.ten_truong_nhom, reg.ten_nhom, reg.reacctno, reg.AUTOID,main.ql_mg
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
