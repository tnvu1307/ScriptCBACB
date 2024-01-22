SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE "CA0021" (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   SYMBOL         IN       VARCHAR2 -- MA CK

   )
IS
--
-- PURPOSE: DANH SACH TONG HOP CHUYEN NHUONG QUYEN MUA CK
-- PERSON      DATE    COMMENTS
-- TRUONGLD   17-04-10  CREATE
-- TheNN        30-Mar-2012 Modified\
-- TheNN        23-jan-2013 Modified    them loc bao cao theo pham vi
-- ---------   ------  -------------------------------------------

    CUR             PKG_REPORT.REF_CURSOR;
    V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (50);
    V_INBRID        VARCHAR2(4);
    V_FRDATE       DATE;
    V_TODATE       DATE;
    V_STRACCTNO    VARCHAR2 (20);
    V_STRSYMBOL    VARCHAR2 (20);
BEGIN
   V_STROPTION := OPT;

  /* IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;*/

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

   V_FRDATE    := TO_DATE(F_DATE,'DD/MM/RRRR');
   V_TODATE    := TO_DATE(T_DATE,'DD/MM/RRRR');
  -- V_STRACCTNO := ACCTNO;
   V_STRSYMBOL := SYMBOL;

   -- GET REPORT'S PARAMETERS

   IF (SYMBOL <> 'ALL')
   THEN
     V_STRSYMBOL := SYMBOL;
   ELSE
      V_STRSYMBOL := '%%';
   END IF;

    OPEN PV_REFCURSOR
    FOR
        SELECT MST.*
        FROM(
            SELECT cf.custid,tl.txdate, tl.tltxcd, nvl(se.casymbol,ci.casymbol) symbol,
                   nvl(se.afacctno, ci.acctno) afacctno, nvl(se.camastid, ci.camastid) camastid,
                   nvl(se.custodycd, ci.custodycd) custodycd,
                   CASE WHEN tl.tltxcd in ('3384','3394') THEN 0 ELSE tl.msgamt END cat_ci,
                   CASE WHEN tl.tltxcd = '3324' THEN tl.msgamt ELSE 0 END ko_cat_ci,
                   tl.msgamt * nvl(se.exprice, ci.exprice) ca_amount,
                   CASE WHEN tl.tltxcd = '3324' THEN 0 ELSE tl.msgamt * nvl(se.exprice, ci.exprice) END ci_amount,
                   mk.tlfullname mk_name, ck.tlfullname ck_name, 'Complete' status,
                   decode(af.corebank,'Y', af.bankname, cspks_system.fn_get_sysvar('SYSTEM','COMPANYSHORTNAME')) txnum, -- dat ten txnum de ko fai bind lai rpt
                    tl.msgamt AMT,nvl(se.exprice, ci.exprice) exprice,
                    NVL(SE.BAL,CI.BAL) BAL,
                    NVL(SE.TRADE,CI.TRADE) TRADE, CF.BRID

            FROM vw_tllog_all tl, tlprofiles mk, tlprofiles ck, cfmast cf, afmast af,
                (SELECT chd.TRADE,se.*, ca.codeid cacodeid, ca.exprice, ca.camastid, sb.symbol casymbol,
                    chd.qtty + chd.pqtty BAL
                    FROM vw_setran_gen se, caschd chd, camast ca, sbsecurities sb
                    WHERE to_char(chd.autoid) = se.REF AND chd.camastid = ca.camastid
                    AND se.field = 'RECEIVING' AND sb.codeid = ca.codeid) se,
                    ---AND sb.symbol LIKE V_STRSYMBOL) se,
                (SELECT chd.TRADE,ci.*, ca.codeid cacodeid, ca.exprice, ca.camastid, sb.symbol casymbol,
                    chd.qtty + chd.pqtty BAL
                    FROM vw_ddtran_gen ci, caschd chd, camast ca, sbsecurities sb
                    WHERE to_char(chd.autoid) = ci.REF AND chd.camastid = ca.camastid
                    AND ci.field = 'BALANCE' AND sb.codeid = ca.codeid) ci
                    ---AND sb.symbol LIKE V_STRSYMBOL ) ci

            WHERE  tl.tltxcd IN ( '3384', '3394', '3324') AND tl.deltd <> 'Y'
                AND cf.custid = af.custid AND af.acctno = tl.msgacct
                AND tl.txdate = se.txdate (+) AND tl.txnum = se.txnum(+) --AND se.field = 'RECEIVING'
                AND tl.txdate = ci.txdate (+) AND tl.txnum = ci.txnum (+) --AND ci.field = 'BALANCE'
                AND tl.tlid = mk.tlid(+) AND tl.offid = ck.tlid(+)
                ---AND tl.txdate <= V_TODATE AND tl.txdate >= V_FRDATE
            ) MST,
            (
                SELECT RE.EFFDATE, RE.EXPDATE, RE.AFACCTNO CUSTID, RE.BRID BRID, RE.BRNAME BRNAME,re.recustid recustid
                FROM
                (
                    SELECT RAF.AFACCTNO,
                           RCF.CUSTID RECUSTID,
                           RCF.BRID BRID,
                           BR.BRID || ': ' || BR.BRNAME BRNAME,
                           GREATEST(RCF.EFFDATE, RAF.FRDATE) EFFDATE,
                           LEAST(RCF.EXPDATE, NVL(RAF.CLSTXDATE, RAF.TODATE)) EXPDATE
                    FROM RECFLNK RCF, REAFLNK RAF, BRGRP BR
                    WHERE RCF.AUTOID = RAF.REFRECFLNKID
                       AND RCF.BRID = BR.BRID
                       ---AND RCF.EFFDATE <= V_TODATE
                       ---AND RCF.EXPDATE > V_FRDATE
                       ---AND RAF.FRDATE <= V_TODATE
                       ---AND NVL(RAF.CLSTXDATE, RAF.TODATE) > V_FRDATE
                    --AND BR.BRID LIKE V_BRID
                ) RE
            ) RE
            WHERE MST.CUSTID = RE.CUSTID(+)
                AND MST.TXDATE >= NVL(RE.EFFDATE, MST.TXDATE-1)
                AND MST.TXDATE < NVL(RE.EXPDATE, MST.TXDATE+1)
                ---AND (NVL(RE.brid,MST.BRID) LIKE V_STRBRID or instr(V_STRBRID,NVL(RE.brid,MST.BRID)) <> 0)

            ;
                  /*
                select tl.txdate,cf.custodycd, af.acctno Sub_Account, sb.symbol, ca.qtty Quantity, ca.aamt CA_Amount,
                tl.namt ci_Amount,
                mk.tlname maker_name, ck.tlname checker_name,
                case when tl.txstatus = '1' then 'Completed' else 'Not_Completed' end Status ,
                ca.camastid, tl.txnum
            from vw_tllog_citran_all tl, apptx tx,
                cfmast cf, afmast af, caschd ca, sbsecurities sb, tlprofiles mk, tlprofiles ck,
                (
                    select tl.txnum, tl.txdate,
                        max(case when fldcd = '02' then cvalue else ' ' end) camastid ,
                        max(case when fldcd = '04' then cvalue else ' ' end) symbol
                    from vw_tllogfld_all fld, vw_tllog_all tl
                    where tl.txdate >= to_date(V_FRDATE,'DD/MM/RRRR')
                      and tl.txdate <= to_date(V_FRDATE,'DD/MM/RRRR')
                        and fld.txdate = tl.txdate and fld.txnum = tl.txnum and tl.tltxcd = '3384'
                    group by tl.txnum, tl.txdate
                ) fld
            where fld.txdate = tl.txdate and fld.txnum = tl.txnum
                and cf.custid = af.custid and af.acctno = tl.acctno
                and ca.camastid = fld.camastid
                and ca.codeid = sb.codeid
                and sb.symbol = fld.symbol
                and ca.afacctno = tl.acctno
                and tl.tlid = mk.tlid
                and tl.offid = ck.tlid (+)
                and tl.txcd = tx.txcd and field = 'BALANCE'
                and tx.txtype = 'D' and tx.apptype = 'CI'
                and ca.status = 'M'
                and tl.txdate >= to_date(V_FRDATE ,'DD/MM/RRRR')
                and tl.txdate <= to_date(V_TODATE ,'DD/MM/RRRR')
                and sb.symbol like  V_STRSYMBOL

            order by symbol,tl.txdate ;*/

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/
