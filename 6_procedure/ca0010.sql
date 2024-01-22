SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE ca0010 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
 /*  F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,        */
   CACODE         IN       VARCHAR2,
   REPORT_NO      IN       VARCHAR2,
   PV_CUSTODYCD    IN       VARCHAR2,
   PLSENT         in       varchar2
  )
IS
--
/*=={}===============>*/
---------   ------  -------------------------------------------

    CUR             PKG_REPORT.REF_CURSOR;
    V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (400);
    V_INBRID       VARCHAR2 (4);

    V_STRCACODE    VARCHAR2 (20);
    V_STRCUSTODYCD    VARCHAR2 (20);
    v_BRNAME VARCHAR2 (200);
    v_COMPANYCD VARCHAR2(100);

BEGIN
   V_STROPTION := upper(OPT);
   V_INBRID := BRID;

   IF (V_STROPTION = 'A') THEN
      V_STRBRID := '%';
   ELSE if(V_STROPTION = 'B') then
            select brgrp.mapid into V_STRBRID from brgrp where brgrp.brid = V_INBRID;
        else
            V_STRBRID := V_INBRID;
        end if;
   END IF;
   IF (CACODE <> 'ALL')
   THEN
      V_STRCACODE := CACODE;
   ELSE
      V_STRCACODE := '%%';
   END IF;

  IF (PV_CUSTODYCD <> 'ALL')
  THEN
     V_STRCUSTODYCD := PV_CUSTODYCD;
  ELSE
   V_STRCUSTODYCD := '%%';
 END IF;

    ---------------------------------
   Select max(case when  varname='BRNAME' then varvalue else '' end),
       max(case when  varname='COMPANYCD' then varvalue else '' end)
       into v_BRNAME,v_COMPANYCD
   from sysvar WHERE varname IN ('BRNAME','COMPANYCD');

   -- GET REPORT'S PARAMETERS

--Tinh ngay nhan thanh toan bu tru

OPEN PV_REFCURSOR
   FOR
   select PLSENT sendto,v_BRNAME TVLK,v_COMPANYCD SOHIEU_TV,REPORT_NO as REPORT_NO,TO_CHAR(GETCURRDATE,'yyyy') CURRDATE,
   TYPELG_NAME,CUSTTYPE_NAME,ISS_NAME,TOISSNAME,TOSYMBOL,custodycd,fullname,address,IDCODE,IDDATE,RIGHTOFFRATE,
   Catype,status_af,status,camastid,SUM(amt) AMT,
   symbol,reportdate,frdatetransfer , todatetransfer,
   SUM(stcv) stcv,actiondate,SUM(NUM_TRF) NUM_TRF,SUM(NUM_RectrF)NUM_RectrF,codeca,SUM(nmqtty)nmqtty,
   exprice,codetl,SUM(SLSH)SLSH,SUM(SLDKM) SLDKM,SUM(THANHTIEN) THANHTIEN,'0' SUMSLDKM, '0' SUMAMT,
   roundtype,SUM(aamt) aamt,isincode, '407' TVLK_CODE
   FROM (
    SELECT --PLSENT sendto,v_BRNAME TVLK,v_COMPANYCD SOHIEU_TV,REPORT_NO as REPORT_NO,TO_CHAR(GETCURRDATE,'yyyy') CURRDATE,
    (CASE WHEN SUBSTR(CA.custodycd,4,1) = 'P' THEN ' Tu doanh ' ELSE ' Moi gioi ' END) TYPELG_NAME,
         NVL(trim(CA.CUSTTYPE_NAME),'') CUSTTYPE_NAME ,
         NVL(CA.ISS_NAME,'') ISS_NAME,
         CA.TOISSNAME, CA.TOSYMBOL,  --Chaunh 02/10/2012
         nvl(ca.country,'')  country,
         nvl(ca.acctno,'')   acctno ,
         nvl(ca.custodycd,'') custodycd ,
         nvl(ca.fullname,'')  fullname ,
         nvl(ca.address,'')   address ,
         nvl(ca.MOBILE,'') MOBILE ,
         nvl(ca.IDCODE,'') IDCODE,
         nvl(to_char(ca.IDDATE,'dd/MM/yyyy'),'') IDDATE,
         Replace(nvl(ca.RIGHTOFFRATE,''),'/',':') RIGHTOFFRATE,
         ca.Catype,ca.status_af status_af,ca.status,ca.camastid,ca.amt,
         ca.symbol,ca.reportdate, ca.frdatetransfer , ca.todatetransfer,
         ca.stcv, ca.actiondate,
         NVL(TL.NUM_TRF,0) NUM_TRF, NVL(TL.NUM_RectrF,0)NUM_RectrF, CA.codeid codeca,ca.nmqtty,
         --replace(UTILS.so_thanh_chu(ca.exprice),',','.') exprice,
         to_char(ca.exprice) exprice,
         NVL(tl.codeid,'a') codetl,
         NVL(SLQUYEN.Balance,0) SLSH,
         --replace(UTILS.so_thanh_chu(NVL(TL.SLDKM,0)),',','.') SLDKM,
         NVL(TL.SLDKM,0) SLDKM,
         NVL(TL.SLDKM,0)*ca.exprice THANHTIEN,
         --'0' SUMSLDKM, '0' SUMAMT,
         NVL(ca.roundtype,'') roundtype, NVL(CA.slctm,'') slctm,
         NVL(ca.aamt,'') aamt,
         ca.isincode
    FROM
        (
            SELECT  cas.aamt,af.acctno acctno , cf.custodycd custodycd, cf.fullname fullname, cf.MOBILE mobile,
                    (case when cf.country = '234' then cf.idcode else cf.tradingcode end) idcode,
                    (case when cf.country = '234' then cf.iddate else cf.tradingcodedt end) IDDATE, cf.country, cf.address,
                    cas.balance SLCKSH, cam.RIGHTOFFRATE rightoffrate, A0.cdcontent Catype,
                    (case when cas.status<>'C' and cas.tqtty >0 then 'Thuc hien 3387' else to_char( A1.cdcontent) end  ) status, cam.camastid camastid,
                    cas.AMT AMT, se.symbol symbol, se.codeid codeid, cam.REPORTDATE reportdate, cas.qtty SLQMDNG, cas.amt STCV, CAS.PQTTY SLQMDPB,
                    cam.ACTIONDATE actiondate, cas.PBALANCE PBALANCE, cam.optcodeid optcodeid, cam.roundtype, cas.nmqtty, cam.exprice,
                    AF.status status_af,cam.begindate frdatetransfer , cam.duedate todatetransfer,
                    (cas.PQTTY+cas.QTTY) slctm, a2.cdcontent  AS CUSTTYPE_NAME, SE.ISS_NAME,
                    sb.ISS_NAME ToISSname, sb.symbol tosymbol, cas.autoid,cam.optsymbol isincode
            FROM caschd cas, (SELECT ISSUERS.FULLNAME ISS_NAME, SB.* from SBSECURITIES SB, ISSUERS  WHERE SB.ISSUERID = ISSUERS.ISSUERID) se,
                 camast cam, afmast af, VW_CFMAST_M cf, allcode A0, Allcode A1, allcode a2,
                 (SELECT ISSUERS.FULLNAME ISS_NAME, SB.* from SBSECURITIES SB, ISSUERS  WHERE SB.ISSUERID = ISSUERS.ISSUERID) sb  --Chaunh 02/10/2012
            WHERE cas.codeid = se.codeid
            AND cam.camastid = cas.camastid
            AND cas.afacctno = af.acctno
            AND af.custid = cf.custid
            AND nvl(cam.tocodeid,cam.codeid) = sb.codeid --Chaunh 02/10/2012
            --and (af.brid like V_STRBRID or INSTR(V_STRBRID,af.brid) <> 0)
            --and (af.brid like V_STRBRID or INSTR(V_STRBRID,af.brid) <> 0)
            AND a0.CDTYPE = 'CA' AND a0.CDNAME = 'CATYPE' AND a0.CDVAL = cam.CATYPE
            AND A1.CDTYPE = 'CA' AND A1.CDNAME = 'CASTATUS' AND trim(A1.CDVAL) = trim(cas.STATUS)
            AND A2.CDTYPE = 'CF' AND A2.CDNAME = 'CUSTTYPE' AND trim(A2.CDVAL) = trim(cf.CUSTTYPE)
            AND cam.catype ='014'
            --and cas.afacctno like V_STRAFACCTNO
            AND cam.camastid LIKE V_STRCACODE
            AND CAS.deltd<>'Y'
        ) CA,
        (
           SELECT Sum(NVL(Num_trf,0)) NUM_TRF, sum(NVL(num_rectrf,0)) NUM_RectrF, sum(NVL(SLDKM,0)) SLDKM,  acctno, codeid , autoid FROM
            (
               SELECT    substr(se.acctno,1,10) acctno, substr(se.acctno,11,6) codeid, SE.NAMT Num_trf, 0 Num_rectrf, 0 SLDKM, se.ref autoid
                FROM TLLOG TL, SETRAN SE, APPTX APP
                WHERE TL.TXNUM = SE.TXNUM AND TL.TXDATE = SE.TXDATE
                AND SE.TXCD = APP.TXCD AND TL.DELTD <> 'Y' AND TL.TLTXCD IN( '3382','3383','3385') -- bo 3384
                AND SE.TXCD IN('0040') AND APP.apptype ='SE'
                    ----and (tl.brid like V_STRBRID or INSTR(V_STRBRID,tl.brid) <> 0)
                    and (tl.brid like V_STRBRID or INSTR(V_STRBRID,tl.brid) <> 0)
                UNION ALL
                SELECT    substr(se.acctno,1,10) acctno, substr(se.acctno,11,6) codeid, SE.NAMT Num_trf, 0 Num_rectrf, 0 SLDKM, se.ref autoid
                FROM TLLOGALL TL, SETRANA SE, APPTX APP
                WHERE TL.TXNUM = SE.TXNUM AND TL.TXDATE = SE.TXDATE
                AND SE.TXCD = APP.TXCD AND TL.DELTD <> 'Y' AND TL.TLTXCD IN( '3382','3383','3385')
                AND SE.TXCD IN('0040')AND APP.apptype ='SE'
                ---and (tl.brid like V_STRBRID or INSTR(V_STRBRID,tl.brid) <> 0)
                 and (tl.brid like V_STRBRID or INSTR(V_STRBRID,tl.brid) <> 0)
                UNION  ALL
                SELECT    substr(se.acctno,1,10) acctno, substr(se.acctno,11,6) codeid, 0 Num_trf, SE.NAMT Num_rectrf, 0 SLDKM, se.ref autoid
                FROM TLLOG TL, SETRAN SE, APPTX APP
                WHERE TL.TXNUM = SE.TXNUM AND TL.TXDATE = SE.TXDATE
                AND SE.TXCD = APP.TXCD AND TL.DELTD <> 'Y' AND TL.TLTXCD IN( '3382','3383','3385')
                AND SE.TXCD IN('0045') AND APP.apptype ='SE'
                    ----and (tl.brid like V_STRBRID or INSTR(V_STRBRID,tl.brid) <> 0)
                and (tl.brid like V_STRBRID or INSTR(V_STRBRID,tl.brid) <> 0)
                UNION ALL
                SELECT    substr(se.acctno,1,10) acctno, substr(se.acctno,11,6) codeid, 0 Num_trf, SE.NAMT Num_rectrf, 0 SLDKM, se.ref autoid
                FROM TLLOGALL TL, SETRANA SE, APPTX APP
                WHERE TL.TXNUM = SE.TXNUM AND TL.TXDATE = SE.TXDATE
                AND SE.TXCD = APP.TXCD AND TL.DELTD <> 'Y' AND TL.TLTXCD IN( '3382','3383','3385')
               AND SE.TXCD IN('0045')AND APP.apptype ='SE'
               ---and (tl.brid like V_STRBRID or INSTR(V_STRBRID,tl.brid) <> 0)
               and (tl.brid like V_STRBRID or INSTR(V_STRBRID,tl.brid) <> 0)
               --3384
                UNION ALL
              SELECT  CA.AFACCTNO acctno  ,CAMAST.optcodeid  codeid , 0 Num_trf, 0 Num_rectrf,  SUM(CA.QTTY)  SLDKM, to_char(CA.autoid) autoid
              FROM caschd CA , CAMAST
              WHERE CAMAST.camastid  = CA.camastid AND CAMAST.catype ='014'AND CA.QTTY >0
              GROUP BY CA.AFACCTNO, CAMAST.optcodeid, CA.autoid
            )GROUP BY acctno, codeid, autoid
        )TL,
        ( -- Begin SLQuyen
            select (mst.BALANCE -nvl(AMT.amt,0))balance , mst.acctno, mst.CODEID ,MST.CAMASTID, mst.autoid  from
            (
                   SELECT (CAS.PBALANCE + CAS.BALANCE ) BALANCE, CAS.AFACCTNO ACCTNO, CAM.CODEID CODEID,
                          CAM.CAMASTID CAMASTID, CAM.OPTCODEID, cas.autoid
                   FROM  CAMAST CAM, CASCHD CAS  WHERE  CAS.CAMASTID = CAM.CAMASTID AND  CAS.DELTD <>'Y'
             )mst,
             (
                   SELECT SUBSTR (AMT.ACCTNO,1,10) AFACCTNO , SUBSTR (AMT.ACCTNO,11,6)CODEID , SUM (AMT.AMT) AMT, AMT.autoid
                   FROM
                          (
                                 SELECT  SE.ACCTNO ,(CASE WHEN APP.TXTYPE = 'D'THEN -SE.NAMT WHEN APP.TXTYPE = 'C' THEN SE.NAMT ELSE 0  END ) AMT
                                         ,se.ref autoid
                                 FROM TLLOG TL, SETRAN SE, APPTX APP
                                 WHERE TL.TXNUM = SE.TXNUM AND TL.TXDATE = SE.TXDATE
                                 AND SE.TXCD = APP.TXCD AND TL.DELTD <> 'Y' AND TL.TLTXCD IN( '3382','3383','3385')
                                 AND SE.TXCD IN('0045','0040') AND APP.apptype ='SE'
                                    ---and (tl.brid like V_STRBRID or INSTR(V_STRBRID,tl.brid) <> 0)
                                    and (tl.brid like V_STRBRID or INSTR(V_STRBRID,tl.brid) <> 0)
                                 UNION ALL
                                 SELECT  SE.ACCTNO ,(CASE WHEN APP.TXTYPE = 'D'THEN -SE.NAMT WHEN APP.TXTYPE = 'C' THEN SE.NAMT ELSE 0  END ) AMT
                                         ,se.ref autoid
                                 FROM TLLOGALL TL, SETRANA SE, APPTX APP
                                 WHERE TL.TXNUM = SE.TXNUM AND TL.TXDATE = SE.TXDATE
                                 AND SE.TXCD = APP.TXCD AND TL.DELTD <> 'Y' AND TL.TLTXCD IN( '3382','3383','3385')
                                    ---and (tl.brid like V_STRBRID or INSTR(V_STRBRID,tl.brid) <> 0)
                                    and (tl.brid like V_STRBRID or INSTR(V_STRBRID,tl.brid) <> 0)
                                 AND SE.TXCD IN('0045','0040')AND APP.apptype ='SE'
                               )AMT
                            GROUP BY AMT.ACCTNO, AMT.autoid
                  )AMT
          where  mst.ACCTNO = AMT.AFACCTNO(+) AND  MST.OPTCODEID = AMT.CODEID(+) AND mst.autoid = amt.autoid(+)
        )SLQuyen
    WHERE CA.camastid LIKE V_STRCACODE
    AND  CA.acctno = TL.acctno (+)
    AND CA.optcodeid = TL.codeid (+)
    AND CA.autoid = TL.autoid (+)
    AND CA.acctno = SLQuyen.acctno
    AND CA.camastid = SLQuyen.camastid
    AND CA.autoid = SLQuyen.autoid
    and tl.SLDKM<>0
    ORDER  BY ca.acctno
) GROUP BY TYPELG_NAME,CUSTTYPE_NAME,ISS_NAME,TOISSNAME,TOSYMBOL,custodycd,fullname,address,IDCODE,IDDATE,RIGHTOFFRATE,
   Catype,status_af,status,camastid,
   symbol,reportdate,frdatetransfer , todatetransfer,actiondate,codeca,
   exprice,codetl,roundtype,isincode
  ;

EXCEPTION
   WHEN OTHERS
   THEN
        plog.error('Error');
      RETURN;
END;
/
