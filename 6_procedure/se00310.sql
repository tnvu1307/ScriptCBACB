SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE se00310 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2,
   PLSENT         IN       VARCHAR2
)
IS

-- RP NAME : YEU CAU CHUYEN KHOAN CHUNG KHOAN TAT TOAN TAI KHOAN
-- PERSON --------------DATE---------------------COMMENTS
-- THANHNM            17/07/2012                 CREATE
-- SE00310: report main
-- ---------   ------  -------------------------------------------
   V_STRAFACCTNO  VARCHAR2 (15);
   V_CUSTODYCD VARCHAR2 (15);
   V_CURRDATE DATE;
   V_STRFULLNAME  VARCHAR2(200);
   V_STR_TVLK_CODE  VARCHAR2(10);
   V_STR_TVLK_NAME  VARCHAR2(200);
   V_STR_CUSTODYCD_NHAN  VARCHAR2(10);
   CUR            PKG_REPORT.REF_CURSOR;
    V_HEADOFFICE    VARCHAR2(200);
   V_INBRID        VARCHAR2(4);
   V_STRBRID      VARCHAR2 (50);
   V_STROPTION    VARCHAR2(5);
   v_totalcaqtty number;

   v_FRDATE date;
   v_TODATE date;

BEGIN
-- GET REPORT'S PARAMETERS
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

    V_CUSTODYCD := REPLACE( PV_CUSTODYCD,'.','');
    V_STR_TVLK_NAME :=' ';
    V_STR_TVLK_CODE :=' ';
    V_STRFULLNAME :=' ';


    SELECT TO_DATE(VARVALUE,'DD/MM/RRRR') INTO V_CURRDATE
     FROM SYSVAR WHERE VARNAME = 'CURRDATE' AND GRNAME = 'SYSTEM';

   IF  (PV_AFACCTNO <> 'ALL')
   THEN
         V_STRAFACCTNO := PV_AFACCTNO;
   ELSE
         V_STRAFACCTNO := '%';
   END IF;

  --SELECT FULLNAME INTO V_STRFULLNAME FROM CFMAST WHERE custodycd = V_CUSTODYCD;

  SELECT  SUM(CAS.TRADE)  REPORT_QTTY into v_totalcaqtty
  FROM CASCHD  CAS, CAMAST CA, VW_CFMAST_M CF,
    AFMAST AF, SBSECURITIES SB
  WHERE CF.CUSTODYCD = V_CUSTODYCD AND CF.CUSTID = AF.CUSTID
    AND CAS.AFACCTNO = AF.ACCTNO AND CA.CAMASTID = CAS.CAMASTID
    AND AF.ACCTNO LIKE V_STRAFACCTNO
    AND CAS.CODEID = SB.CODEID
    AND CAS.STATUS ='O' ;

    v_FRDATE := TO_DATE (F_DATE  ,'DD/MM/YYYY');
    v_TODATE := TO_DATE (T_DATE  ,'DD/MM/YYYY');

    SELECT varvalue INTO V_HEADOFFICE FROM SYSVAR WHERE VARNAME='HEADOFFICE' AND GRNAME='SYSTEM';
-- GET REPORT'S DATA
 OPEN PV_REFCURSOR
 FOR
    select V_HEADOFFICE HEADOFFICE,V_CURRDATE CREATEDDATE,parvalue, symbol, tk_no, tk_co, CUSTODYCD,
        san_gd, sum(namt) namt,se_type, FULLNAME, ten_tvlk_nhan, ma_tvlk_nhan,
        so_tklk_nhan, ten_nguoi_nhan,autoid2247,
        CURDATE,PL_SENT , TOTALCAQTTY,ord_num
        from (
        select
        nvl(dt.parvalue,10000) parvalue, nvl(dt.symbol,'--') symbol, nvl(dt.tk_no,'') tk_no, nvl(dt.tk_co,'') tk_co, ac.CUSTODYCD,
        nvl(dt.san_gd,'') san_gd, nvl(dt.namt,0) namt, nvl(dt.se_type,'') se_type, ac.FULLNAME, nvl(dt.ten_tvlk_nhan,'') ten_tvlk_nhan, nvl(dt.ma_tvlk_nhan,'') ma_tvlk_nhan,
        nvl(dt.so_tklk_nhan,'') so_tklk_nhan, nvl(dt.TEN_NGUOI_NHAN,ac.FULLNAME) ten_nguoi_nhan,autoid2247,
        V_CURRDATE CURDATE,PLSENT  PL_SENT , nvl(v_totalcaqtty,0) TOTALCAQTTY,
        TO_NUMBER(dt.ord_num) ord_num
    from (
        select tl.autoid, nvl(reat_2247.autoid,-1) autoid2247,tl.txdate, fld.txnum, tl.busdate, max(decode(fld.fldcd,'80',cvalue,'')) CLOSETYPE ,
            max(decode(fld.fldcd,'88',cvalue,'')) CUSTODYCD, max(decode(fld.fldcd,'31',cvalue,'')) FULLNAME
        from vw_tllog_all tl, vw_tllogfld_all fld,
            (
                select max(autoid) autoid
                from vw_tllog_all tl
                where tl.tltxcd='0088' and tl.DELTD='N' and tl.cfcustodycd = V_CUSTODYCD
                    and tl.BUSDATE >= v_FRDATE
                    and tl.BUSDATE <= v_TODATE
            ) log,
            (
                select max(autoid) autoid
                from vw_tllog_all tl
                where tl.tltxcd='2291' and tl.DELTD='N' and tl.cfcustodycd = V_CUSTODYCD
                    and tl.BUSDATE >= v_FRDATE
                    and tl.BUSDATE <= v_TODATE
            ) reat_0088,
            (
              select max(autoid) autoid
              from vw_tllog_all tl
              where tl.tltxcd='2290' and tl.DELTD='N' and tl.cfcustodycd = V_CUSTODYCD
                  and tl.BUSDATE >= v_FRDATE
                  and tl.BUSDATE <= v_TODATE
            ) reat_2247
        where tl.tltxcd = '0088'  AND tl.DELTD = 'N' and tl.autoid=log.autoid and log.autoid > nvl(reat_0088.autoid,0)
            and fld.txnum=tl.txnum and fld.txdate=tl.txdate
            and fld.fldcd in ('80','88','31')
            AND tl.txdate >= v_FRDATE
            AND tl.txdate <= v_TODATE
        group by tl.autoid, nvl(reat_2247.autoid,-1),tl.txdate, fld.txnum, tl.busdate
    )ac, (
        SELECT dt.autoid, SB.PARVALUE , SB.SYMBOL,
            ('012' || (case when DT.SE_TYPE IN ('8','7') then '72' else
                (case when DT.SE_TYPE = '1' THEN '12' ELSE '22' END) end) || '.' || DT.MA_TVLK_NHAN
            ) TK_NO,
            ('012' || (case when DT.SE_TYPE IN ('8','7') then '72' else
                (case when DT.SE_TYPE = '1' THEN '12' ELSE '22' END) end) || '.022'
            ) TK_CO,
            DT.CUSTODYCD,
            /*
            (CASE WHEN  nvl(sb.tradeplace,'') = '010' AND sb.sectype IN ('003','006','222','333','444') THEN '4. BOND'
                  ELSE
                      (CASE WHEN SB.TRADEPLACE='002' THEN '1. HNX'
                            WHEN SB.TRADEPLACE='001' THEN '2. HOSE'
                            WHEN SB.TRADEPLACE='005' THEN '3. UPCOM'
                            WHEN SB.TRADEPLACE='003' THEN '5. OTC'
                            WHEN SB.TRADEPLACE='009' THEN '6. DCCNY'
                            --when SB.TRADEPLACE='010' THEN 'D. BOND'
                            ELSE '3. UPCOM' END) END
            ) SAN_GD, */

            --//-------------NAM.LY 12-11-2019---------------------//--
            (CASE WHEN  NVL(SB.TRADEPLACE,'') = '010' AND SB.SECTYPE IN ('003','006','222','333','444') THEN 'BOND'
                  ELSE
                      (CASE WHEN SB.TRADEPLACE='002' THEN 'HNX'
                            WHEN SB.TRADEPLACE='001' THEN 'HOSE'
                            WHEN SB.TRADEPLACE='005' THEN 'UPCOM'
                            WHEN SB.TRADEPLACE='003' THEN 'OTC'
                            WHEN SB.TRADEPLACE='009' THEN 'DCCNY'
                            ELSE 'UPCOM' END) END
            ) SAN_GD,
            RANK() OVER (ORDER BY ( (CASE WHEN  NVL(SB.TRADEPLACE,'') = '010' AND SB.SECTYPE IN ('003','006','222','333','444') THEN 4
                ELSE
                    (CASE WHEN SB.TRADEPLACE ='002' THEN 1
                          WHEN SB.TRADEPLACE='001' THEN 2
                          WHEN SB.TRADEPLACE='005' THEN 3
                          WHEN SB.TRADEPLACE='003' THEN 5
                          WHEN SB.TRADEPLACE='009' THEN 6
                          ELSE 3 END) END )))  ORD_NUM,
            --//-------------------------------------------------//--

            DT.NAMT, DT.SE_TYPE,-- V_STRFULLNAME FULLNAME,
            NVL(DeP.FULLNAME,' ') TEN_TVLK_NHAN, MA_TVLK_NHAN, SO_TKLK_NHAN, nvl(cf.fullname,'') TEN_NGUOI_NHAN
            --,PLSENT  PL_SENT , nvl(v_totalcaqtty,0) TOTALCAQTTY
          FROM SBSECURITIES SB,
          (

 SELECT autoid,custodycd ,
                AFACCTNO, txcd,
                TRADEPLACE,
                sum(namt) namt, BUSDATE,
                codeid,
                SE_TYPE,
                MENH_GIA,
                MA_TVLK_NHAN,
                SO_TKLK_NHAN,
                TEN_NGUOI_NHAN
                FROM(
 SELECT  MAX(tl.autoid) autoid,cf.custodycd ,
                cf.custid AFACCTNO, se.txcd,SB.TRADEPLACE,
               se.namt, SE.BUSDATE,
                nvl(sb.refcodeid,sb.codeid) codeid,
                (case when sb.refcodeid is null then '1' else '7' end) SE_TYPE,
                max(decode(fld.fldcd,'11',fld.nvalue,null)) MENH_GIA,
                max(decode(fld.fldcd,'27',cvalue,null)) MA_TVLK_NHAN,
                max(decode(fld.fldcd,'28',cvalue,null)) SO_TKLK_NHAN,
                max(decode(fld.fldcd,'29',cvalue,null)) TEN_NGUOI_NHAN
            FROM   vw_tllog_all tl,sbsecurities sb, vw_setran_gen se,
                vw_tllogfld_all fld,VW_CFMAST_M CF
            WHERE   tl.tltxcd = '2247'  AND tl.DELTD = 'N'
                and se.txnum=tl.txnum and se.txdate=tl.txdate
                and fld.txnum=tl.txnum and fld.txdate=tl.txdate
                and se.txcd='0040'
                and se.namt<>0
                and substr(msgacct, 11, 6)=sb.codeid
                AND tl.txdate >= TO_DATE (F_DATE  ,'DD/MM/YYYY')
                AND tl.txdate <= TO_DATE (T_DATE  ,'DD/MM/YYYY')
                and se.afacctno like V_STRAFACCTNO
                and se.custodycd = cf.custodycd_org
                and cf.custodycd like V_CUSTODYCD
                GROUP BY cf.custodycd ,
                cf.custid , se.txcd,SB.TRADEPLACE,
               se.namt, SE.BUSDATE,
                nvl(sb.refcodeid,sb.codeid),
                (case when sb.refcodeid is null then '1' else '7' end)
                )
            group by autoid,custodycd ,AFACCTNO, txcd,TRADEPLACE,BUSDATE,codeid,SE_TYPE,
            MENH_GIA,MA_TVLK_NHAN,SO_TKLK_NHAN,TEN_NGUOI_NHAN
            UNION all

 SELECT autoid,custodycd ,
                AFACCTNO, txcd,
                TRADEPLACE,
                sum(namt) namt, BUSDATE,
                codeid,
                SE_TYPE,
                MENH_GIA,
                MA_TVLK_NHAN,
                SO_TKLK_NHAN,
                TEN_NGUOI_NHAN
                FROM(
 SELECT  MAX(tl.autoid) autoid,cf.custodycd ,
                cf.custid AFACCTNO, se.txcd,SB.TRADEPLACE,
               se.namt, SE.BUSDATE,
                nvl(sb.refcodeid,sb.codeid) codeid,
                (case when sb.refcodeid is null then '2' else '8' end) SE_TYPE,
                max(decode(fld.fldcd,'11',fld.nvalue,null)) MENH_GIA,
                max(decode(fld.fldcd,'27',cvalue,null)) MA_TVLK_NHAN,
                max(decode(fld.fldcd,'28',cvalue,null)) SO_TKLK_NHAN,
                max(decode(fld.fldcd,'29',cvalue,null)) TEN_NGUOI_NHAN
            FROM   vw_tllog_all tl,sbsecurities sb, vw_setran_gen se,
                vw_tllogfld_all fld,VW_CFMAST_M CF
            WHERE   tl.tltxcd = '2247'  AND tl.DELTD = 'N'
                and se.txnum=tl.txnum and se.txdate=tl.txdate
                and fld.txnum=tl.txnum and fld.txdate=tl.txdate
                and se.txcd='0044'
                and se.namt<>0
                and substr(msgacct, 11, 6)=sb.codeid
                AND tl.txdate >= TO_DATE (F_DATE  ,'DD/MM/YYYY')
                AND tl.txdate <= TO_DATE (T_DATE  ,'DD/MM/YYYY')
                and se.afacctno like V_STRAFACCTNO
                and se.custodycd = cf.custodycd_org
                and cf.custodycd like V_CUSTODYCD
                GROUP BY cf.custodycd ,
                cf.custid , se.txcd,SB.TRADEPLACE,
               se.namt, SE.BUSDATE,
                nvl(sb.refcodeid,sb.codeid),
                (case when sb.refcodeid is null then '2' else '8' end)
                )
            group by autoid,custodycd ,AFACCTNO, txcd,TRADEPLACE,BUSDATE,codeid,SE_TYPE,
            MENH_GIA,MA_TVLK_NHAN,SO_TKLK_NHAN,TEN_NGUOI_NHAN
        ) DT, DEPOSIT_MEMBER dep, cfmast cf
        WHERE SB.CODEID= DT.CODEID --AND DT.CUSTODYCD LIKE V_CUSTODYCD
          AND DT.NAMT >0
          and cf.custodycd(+)=dt.SO_TKLK_NHAN
          and dt.MA_TVLK_NHAN = dep.DEPOSITID(+)
    ) DT
    where ac.CLOSETYPE='001'
        and ac.custodycd=dt.custodycd(+)
        and ac.autoid2247 < nvl(dt.autoid, ac.autoid2247+2)
        and ac.custodycd like V_CUSTODYCD
        ) group by parvalue, symbol, tk_no, tk_co, CUSTODYCD,
        san_gd, se_type, FULLNAME, ten_tvlk_nhan, ma_tvlk_nhan,
        so_tklk_nhan, ten_nguoi_nhan,autoid2247,
        CURDATE,PL_SENT , TOTALCAQTTY,ord_num
    ;
EXCEPTION
  WHEN OTHERS
   THEN
   DBMS_OUTPUT.PUT_LINE('SE00310 ERROR');
   PLOG.ERROR('SE00310: - ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RETURN;
END;
/
