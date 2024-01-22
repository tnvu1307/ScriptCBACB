SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE re0089 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   SEARCHDATE         IN       VARCHAR2,
   RE_CUSTODYCD         IN       VARCHAR2,
   PV_CUSTODYCD     IN     VARCHAR2,
   REROLE         IN       VARCHAR2,
   I_BRID                 IN       VARCHAR2 DEFAULT NULL,
   TLID                   IN        VARCHAR2 default null
 )
IS
--bao cao Danh sach tai khoan do moi gioi quan ly
--created by Chaunh at 10/01/2012
   V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
   V_INBRID     VARCHAR2 (5);

   V_SEARCHDATE date;
   V_CUSTODYCD_MG varchar2(10);
   V_CUSTODYCD_KH varchar2(10);
   V_REROLE varchar2(4);
   V_REERNAME varchar2(50);
   v_INAMEKH varchar2(50);
   v_IBRID varchar2(10);
   v_TLID varchar2(10);

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
   IF (REROLE = 'ALL' OR REROLE = '%%')
   THEN
    V_REROLE := '%';
   ELSE
    V_REROLE := REROLE;
   END IF;
   -----------------------
   V_CUSTODYCD_MG := RE_CUSTODYCD;

   --V_REERNAME := 'ALL';
   IF (RE_CUSTODYCD <> 'ALL')
   THEN
    BEGIN
        V_CUSTODYCD_MG := RE_CUSTODYCD;
      --  SELECT cf.fullname INTO V_REERNAME FROM cfmast cf WHERE cf.custid like V_CUSTODYCD_MG;
    END ;
   ELSE
    V_CUSTODYCD_MG := '%';
    V_REERNAME := 'ALL';
   END IF;

   V_CUSTODYCD_KH := PV_CUSTODYCD;

   --V_REERNAME := 'ALL';
   IF (PV_CUSTODYCD <> 'ALL')
   THEN
    BEGIN
        V_CUSTODYCD_KH := PV_CUSTODYCD;
     --   SELECT cf.fullname INTO v_INAMEKH FROM cfmast cf WHERE cf.custid like V_CUSTODYCD_KH;
    END ;
   ELSE
    V_CUSTODYCD_KH := '%';
    v_INAMEKH := 'ALL';
   END IF;

    IF (UPPER(I_BRID) = 'ALL' OR I_BRID IS NULL) THEN
        v_IBRID := '%';
   ELSE
        v_IBRID := UPPER(I_BRID);
   END IF;

    IF (upper(TLID) = 'ALL' or TLID is null)  THEN
    v_TLID := '%';
   ELSE
    v_TLID := UPPER(TLID);
   END IF;
   ------------------------------
   V_SEARCHDATE := to_date(SEARCHDATE, 'DD/MM/YYYY');

OPEN PV_REFCURSOR FOR

SELECT txdate, txnum, so_tk_kh , custid, so_tk_MG, frdate, todate, ten_kh, cust_kh,IDMG custid_mg,
    retyApe || ' - ' || typename || '('|| vai_tro || ')'  retype,
    nvl(ten_truong_nhom,' ') ten_truong_nhom, afstatus, rerole, V_SEARCHDATE searchdate, pa_role,
    ten_mg ten_mg, ten_nhom, autoid, afacctno_mr, afacctno_n, country_kh,brid,brname, custtype, oddate,
    RE_CUSTODYCD BrokerIDPrm, I_BRID BridPrm
FROM
    (SELECT kh.frdate txdate, kh.txnum, kh.afacctno so_tk_kh, cf1.custid, kh.reacctno so_tk_MG, --cf1.valdate frdate,
        CF1.opndate frdate, kh.todate,tl.tlname IDMG,
        cf1.fullname ten_kh, cf2.fullname ten_mg, RETYPE.afstatus, mg.autoid, retype.rerole, allcode.cdcontent vai_tro,
        cf1.custodycd cust_kh, cf2.custid custid_mg, retype.actype retyApe,
        (CASE WHEN V_REROLE = '%' THEN '%' ELSE to_char(allcode.cdcontent) END) pa_role, RETYPE.typename,
        --case when mrt.mrtype='T' then af.acctno else '' end
        af.acctno afacctno_mr, af.acctno afacctno_n,
        --case when mrt.mrtype<>'T' then af.acctno else '' end afacctno_n,
        cf1.country country_kh, mg.brid, br.brname brname, a0.cdcontent custtype, nvl(od.txdate,null) oddate
    FROM reaflnk kh,recflnk mg,tlprofiles tl,
        (select custid, acctno acctno, actype from afmast ) af
            left join (
                select afacctno, max(txdate) txdate
                from vw_odmast_all
                where deltd<>'Y'
                    and txdate<=V_SEARCHDATE
                GROUP BY afacctno
            )od on od.afacctno=af.acctno
        , cfmast cf1, cfmast cf2, retype, allcode,
        aftype aft, /*mrtype mrt,*/ brgrp br, allcode a0
    WHERE kh.refrecflnkid = mg.autoid
        AND allcode.cdtype = 'RE' AND allcode.cdname = 'REROLE' AND allcode.cdval = retype.rerole
        AND kh.deltd <> 'Y'
        and mg.tlid = tl.tlid
        AND cf1.custid = af.custid AND cf1.custid = kh.afacctno and kh.status = 'A'
        and af.actype=aft.actype --and aft.mrtype=mrt.actype
        AND cf2.custid = mg.custid
        and mg.brid=br.brid
        AND V_SEARCHDATE <= TO_DATE(nvl(kh.clstxdate - 1,kh.todate),'DD/MM/RRRR')
        AND V_SEARCHDATE >= kh.frdate
        and V_SEARCHDATE <= kh.todate
        and V_SEARCHDATE between mg.effdate and  mg.expdate
        AND substr(kh.reacctno, 11,4) = retype.actype
        and a0.cdname='CUSTTYPE' and a0.cdtype='CF' and a0.cdval=cf1.custtype
        --AND (mg.brid LIKE V_STRBRID OR instr(V_STRBRID,mg.brid)<> 0)
        AND mg.brid LIKE v_IBRID
        AND mg.brid LIKE V_STRBRID
        AND EXISTS (select gu.grpid from tlgrpusers gu WHERE cf1.careby = gu.grpid and gu.tlid like v_TLID)
        ) a
    LEFT JOIN --truong nhom
    (SELECT cfmast.fullname ten_truong_nhom, tn.fullname ten_nhom, nhom.reacctno FROM regrplnk nhom, regrp tn, cfmast
    WHERE tn.autoid = nhom.refrecflnkid --AND nhom.status = 'A'
        AND tn.custid = cfmast.custid
        AND V_SEARCHDATE BETWEEN NHOM.frdate AND NHOM.todate
        --AND (substr(cfmast.custid,1,4) LIKE V_STRBRID OR instr(V_STRBRID,substr(cfmast.custid,1,4))<> 0)
        ) b
    ON a.so_tk_mg = b.reacctno
WHERE custid_mg LIKE V_CUSTODYCD_MG
and cust_kh like V_CUSTODYCD_KH
AND rerole LIKE V_REROLE
and V_SEARCHDATE <= todate    -- todate, frdate da duoc de dinh dang kieu date
AND V_SEARCHDATE >= frdate
ORDER BY afstatus,a.ten_kh
    ;
EXCEPTION
   WHEN OTHERS
   THEN
    --dbms_output.put_line(dbms_utility.format_error_backtrace);
      RETURN;
End;
/
