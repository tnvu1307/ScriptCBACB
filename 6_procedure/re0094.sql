SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE re0094 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   GROUPID        IN       VARCHAR2,
   I_BRID         IN       VARCHAR2
 )
IS
--bao cao danh sach moi gioi
--created by Chaunh at 16/01/2012
--modified DieuNDA at 19/05/2015 them id nhom
    V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (60);            -- USED WHEN V_NUMOPTION > 0
    V_INBRID     VARCHAR2 (5);
    VF_DATE DATE;
    VT_DATE DATE;
    V_GROUPID varchar2(10);

    V_GROUPCUSTID varchar2(20);
    V_i_BRID varchar2(10);
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

   IF GROUPID <> 'ALL' THEN
      BEGIN
        V_GROUPID := GROUPID;
        --SELECT recflnk.brid INTO V_GROUPCUSTID FROM regrp g, recflnk WHERE  g.autoid LIKE  V_GROUPID||'%'  AND g.custid = recflnk.custid;
      END ;
   ELSE
      BEGIN
        V_GROUPID := '%';
        V_GROUPCUSTID := ' ';
      END;
   END IF;

   IF UPPER(I_BRID) <> 'ALL' THEN
        V_I_BRID:=I_BRID;
   ELSE
        V_I_BRID:='%';
   END IF;

   ------------------------
   VF_DATE := to_date(F_DATE,'DD/MM/RRRR');
   VT_DATE := to_date(T_DATE,'DD/MM/RRRR');



OPEN PV_REFCURSOR FOR
SELECT ten_moi_gioi, ma_moi_gioi, broker.custid , nvl(cf.tlname,'') custidmg , vi_tri, nhom, ma_nhom, ngay_vao_nhom,ngay_ra_nhom, cap, MOI_GIOI_CHA, MAPLEVEL, brid, brname, typename
    FROM
    (
    SELECT refrecflnkid ma_nhom, custid , reacctno ma_moi_gioi, frdate ngay_vao_nhom, nvl(clstxdate,todate) ngay_ra_nhom,
        to_char(allcode.cdcontent)||' - '||to_char(a2.cdcontent) vi_tri, retype.actype||' - '||typename typename
        FROM regrplnk, retype, allcode, allcode a2
        WHERE retype.actype = substr(regrplnk.reacctno,11,4)
        AND a2.cdtype = 'RE' AND a2.cdname = 'AFSTATUS' AND a2.cdval = retype.afstatus
        AND allcode.cdtype= 'RE' AND allcode.cdname = 'REROLE' AND allcode.cdval = retype.rerole
        AND nvl(clstxdate - 1,todate) >= VF_DATE AND frdate <= VT_DATE
    UNION
    SELECt gr.autoid ma_nhom, custid, custid||gr.actype ma_moi_gioi, nvl(gr.effdate,'30-Dec-1899') ngay_vao_nhom, nvl(gr.expdate,'30-Dec-1899') ngay_ra_nhom,
        'Truong phong' vi_tri, tp.actype||' - '||tp.typename typename
        FROM regrp gr, retype tp
        WHERE gr.actype=tp.actype and gr.effdate <= VT_DATE AND gr.expdate >= VF_DATE
    ) broker
    --ThangNV: Them code hien thi MOI_GIOI_CHA tuong ung (nhom cha)
    LEFT JOIN
    (SELECT AUTOID MA,PRNAME MOI_GIOI_CHA, MAPLEVEL, MAPCODE FROM
        (SELECT GRP.AUTOID, PRGRP.FULLNAME PRNAME, GRP.FULLNAME, A0.CDCONTENT DESC_STATUS,
            SP_FORMAT_REGRP_MAPCODE(GRP.AUTOID) MAPCODE, SP_FORMAT_REGRP_GRPLEVEL(GRP.AUTOID) MAPLEVEL
            FROM REGRP GRP, ALLCODE A0, REGRP PRGRP, RETYPE TYP, RECFLNK RF
            WHERE GRP.ACTYPE=TYP.ACTYPE  AND A0.CDTYPE='RE' AND A0.CDNAME='STATUS' AND A0.CDVAL=GRP.STATUS
            AND GRP.PRGRPID = PRGRP.AUTOID (+) AND GRP.CUSTID=RF.CUSTID AND SP_FORMAT_REGRP_GRPLEVEL(GRP.AUTOID) <> 1)) RE_DAD
    ON BROKER.MA_NHOM = RE_DAD.MA

    LEFT JOIN
    (SELECT autoid, fullname nhom, SP_FORMAT_REGRP_MAPCODE(autoid) cap FROM regrp) grp
    ON broker.ma_nhom = grp.autoid
    LEFT JOIN
    (SELECT cf.custid, cf.fullname ten_moi_gioi, re.brid, nvl(br.brname,'') brname, nvl(tl.tlname,' ') tlname
        FROM cfmast cf, recflnk re, brgrp br, tlprofiles tl
        where cf.custid=re.custid
            and nvl(re.brid,cf.brid)=br.brid
            and re.tlid=tl.tlid(+)
            and re.effdate <= VT_DATE and re.expdate >= VF_DATE

    ) cf
    ON broker.custid = cf.custid
WHERE cap LIKE (CASE WHEN V_GROUPID = '%' THEN '%' ELSE V_GROUPID END)
--AND (V_GROUPCUSTID LIKE V_STRBRID OR instr(V_STRBRID,V_GROUPCUSTID)<> 0)
    and brid like V_I_BRID
ORDER BY cap, vi_tri DESC
;
EXCEPTION
   WHEN OTHERS
   THEN
    --dbms_output.put_line(dbms_utility.format_error_backtrace);
      RETURN;
End;
 
 
/
