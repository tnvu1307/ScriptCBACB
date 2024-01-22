SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE re0087 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   GROUPID        IN       VARCHAR2,
   RECUSTODYCD    IN        VARCHAR2,
   REROLE         IN        VARCHAR2,
   I_BRID         IN        VARCHAR2
 )
IS
--bao cao danh sach moi gioi
--created by Chaunh at 16/01/2012
    V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID          VARCHAR2 (60);    -- USED WHEN V_NUMOPTION > 0
    V_INBRID     VARCHAR2 (5);
    VF_DATE DATE;
    VT_DATE DATE;
    V_GROUPID varchar2(10);
    V_CUSTID VARCHAR2(10);

    V_i_BRID VARCHAR2(15);
    V_REROLE VARCHAR2(15);
    V_RECUSTODYCD VARCHAR2(15);

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

   IF UPPER(GROUPID) <> 'ALL' THEN
        V_GROUPID := GROUPID;
   ELSE V_GROUPID := '%';
   END IF;

   IF UPPER(i_BRID) <> 'ALL' THEN
        V_i_BRID := i_BRID;
   ELSE V_i_BRID := '%';
   END IF;

   IF UPPER(RECUSTODYCD) <> 'ALL' THEN
        V_RECUSTODYCD := RECUSTODYCD;
   ELSE V_RECUSTODYCD := '%';
   END IF;

   IF UPPER(REROLE) <> 'ALL' THEN
        V_REROLE := REROLE;
   ELSE V_REROLE := '%';
   END IF;

   ------------------------
   VF_DATE := to_date(F_DATE,'DD/MM/RRRR');
   VT_DATE := to_date(T_DATE,'DD/MM/RRRR');

   --SELECT nvl(custid,' ') INTO V_CUSTID FROM regrp  WHERE regrp.autoid = V_GROUPID ;
OPEN PV_REFCURSOR FOR

SELECT cf.fullname ten_moi_gioi, nvl(tl.tlname,'') id_mg, tran.acctno ma_moi_gioi ,
        --CASE WHEN tran.inttype = 'IBR' THEN  'Truong phong'
        --     ELSE 'Moi gioi' END  vi_tri ,
        grp.vi_tri vi_tri,
        --CASE WHEN tran.inttype = 'IBR' THEN  'Truong phong'
        CASE WHEN cf.custid = regrp.custid THEN  'Truong phong'
             WHEN retype.rerole = 'BM' THEN to_char(allcode.cdcontent)||' - '||to_char(a2.cdcontent)
             ELSE allcode.cdcontent || ' - ' || to_char(retype.actype) END chuc_vu,
        regrp.fullname nhom, grp.ma_nhom ma_nhom, grp.frdate ngay_vao_nhom, grp.todate ngay_ra_nhom,
        SP_FORMAT_REGRP_MAPCODE(grp.ma_nhom) cap,
        sum(--CASE WHEN tran.frdate <> tran.todate AND VF_DATE > tran.frdate THEN round(tran.intbal /(tran.todate- tran.frdate)* (tran.todate - VF_DATE + 1),2)
            --     WHEN tran.frdate <> tran.todate AND VT_DATE < tran.todate THEN round(tran.intbal /(tran.todate - tran.frdate)* (VT_DATE - tran.frdate),2)
            --    ELSE tran.intbal
            --     END
                tran.intbal ) doanh_so,
        sum(--CASE WHEN tran.frdate <> tran.todate AND VF_DATE > tran.frdate THEN round(tran.intamt /(tran.todate- tran.frdate)* (tran.todate - VF_DATE + 1),2)
            --     WHEN tran.frdate <> tran.todate AND VT_DATE < tran.todate THEN round(tran.intamt /(tran.todate - tran.frdate)* (VT_DATE - tran.frdate),2)
            --     ELSE tran.intamt
            --     END
                 tran.intamt ) phi_thuc_thu,
        sum( tran.rfmatchamt + tran.rffeeacr ) phi_giam_tru,
        sum(tran.intamt-( tran.rfmatchamt + tran.rffeeacr )) doanh_thu_thuan,
        CASE WHEN retype.rerole = 'BM' THEN 01
             WHEN retype.rerole = 'RM' THEN 02
             WHEN retype.rerole = 'AE' THEN 03
             WHEN retype.rerole = 'RD' THEN 04
             ELSE 05
        END orderid, recflnk.brid, nvl(br.brname,'') brname, retype.actype||' - '||retype.typename typename,
        fn_re_icrate(tran.acctno,suM(tran.intamt-(tran.rfmatchamt + tran.rffeeacr)),sum(tran.intbal))/100 *suM(tran.intamt-(tran.rfmatchamt + tran.rffeeacr)) hoahong
FROM
(SELECT * FROM reinttrana union ALL SELECT * FROM reinttran /*where inttype <> 'IBR'*/) tran,
(--SELECT autoid ma_nhom, custid||actype acctno, custid, effdate frdate, expdate todate, 'Truong phong' vi_tri FROM regrp
--UNION all
--SELECT autoid ma_nhom, custid||actype acctno, custid, effdate frdate, expdate todate, 'Truong phong' vi_tri FROM regrphist
--UNION all
SELECT refrecflnkid ma_nhom, reacctno acctno, custid, frdate, nvl(clstxdate - 1,todate) todate, 'Nhan vien' vi_tri  FROM regrplnk
) grp,
cfmast cf, retype, allcode, allcode a2, regrp, recflnk, brgrp br, tlprofiles tl
where  grp.acctno = tran.acctno
AND tran.todate >= VF_DATE AND tran.todate <= VT_DATE
AND grp.frdate <= tran.todate AND grp.todate >= tran.todate
AND cf.custid = recflnk.custid
and recflnk.effdate<= VT_DATE and recflnk.expdate >= VF_DATE
AND cf.custid = grp.custid AND retype.actype = substr(grp.acctno,11,4)
AND a2.cdtype = 'RE' AND a2.cdname = 'AFSTATUS' AND a2.cdval = retype.afstatus
AND allcode.cdtype= 'RE' AND allcode.cdname = 'REROLE' AND allcode.cdval = retype.rerole
AND regrp.autoid = grp.ma_nhom
--AND (recflnk.brid LIKE V_STRBRID OR instr(V_STRBRID,recflnk.brid)<> 0)
AND SP_FORMAT_REGRP_MAPCODE(grp.ma_nhom) LIKE (case when UPPER(GROUPID)<> 'ALL' then SP_FORMAT_REGRP_MAPCODE(V_GROUPID)||'%' else '%' end)
AND retype.rerole LIKE V_REROLE
AND CF.CUSTODYCD LIKE V_RECUSTODYCD
AND recflnk.brid LIKE V_i_BRID
and recflnk.brid=br.brid(+)
and recflnk.tlid=tl.tlid(+)
GROUP BY cf.fullname, nvl(tl.tlname,''), tran.acctno ,
        grp.vi_tri,
        retype.rerole,
        regrp.fullname , grp.ma_nhom , grp.frdate , grp.todate,
        --CASE WHEN tran.inttype = 'IBR' THEN  'Truong phong'
        CASE WHEN cf.custid = regrp.custid THEN  'Truong phong'
             WHEN retype.rerole = 'BM' THEN to_char(allcode.cdcontent)||' - '||to_char(a2.cdcontent)
             ELSE allcode.cdcontent || ' - ' || to_char(retype.actype) END,
        recflnk.brid, nvl(br.brname,''), retype.actype||' - '||retype.typename --, SP_FORMAT_REGRP_MAPCODE(grp.ma_nhom)

ORDER BY SP_FORMAT_REGRP_MAPCODE(grp.ma_nhom), grp.vi_tri,
        CASE WHEN retype.rerole = 'BM' THEN 01
             WHEN retype.rerole = 'RM' THEN 02
             WHEN retype.rerole = 'AE' THEN 03
             WHEN retype.rerole = 'RD' THEN 04
             ELSE 05
        END
;
EXCEPTION
   WHEN OTHERS
   THEN
    --dbms_output.put_line(dbms_utility.format_error_backtrace);
      RETURN;
End;
 
 
/
