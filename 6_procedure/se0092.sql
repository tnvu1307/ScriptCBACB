SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE se0092(
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2
)
IS

-- RP NAME : GIAY DE NGHI CHUYEN KHOAN TOAN BO CHUNG KHOAN
-- PERSON --------------DATE---------------------COMMENTS
-- DieuNDA            21/04/2012                 CREATE

-- ---------   ------  -------------------------------------------
   V_STROPTION          VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_INBRID        VARCHAR2(4);
   V_STRBRID      VARCHAR2 (50);
   V_CUSTODYCD VARCHAR2 (15);
   V_CURRDATE DATE;
   V_STRAFACCTNO  VARCHAR2(200);

   V_STR_TVLK_CODE  VARCHAR2(10);
   V_STR_TVLK_NAME  VARCHAR2(200);
   V_STR_CUSTODYCD_NHAN  VARCHAR2(10);
   CUR           PKG_REPORT.REF_CURSOR;
   CUR1           PKG_REPORT.REF_CURSOR;
   v_BRNAME VARCHAR2 (200);
BEGIN
-- GET REPORT'S PARAMETERS
    V_CUSTODYCD := UPPER( PV_CUSTODYCD);


    SELECT TO_DATE(VARVALUE,'DD/MM/RRRR') INTO V_CURRDATE
     FROM SYSVAR WHERE VARNAME = 'CURRDATE' AND GRNAME = 'SYSTEM';

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

   IF  (upper(PV_AFACCTNO) <> 'ALL')
   THEN
         V_STRAFACCTNO := PV_AFACCTNO;
   ELSE
         V_STRAFACCTNO := '%';
   END IF;

----------------------------
   Select max(case when  varname='BRNAME' then varvalue else '' end)
       into v_BRNAME
   from sysvar WHERE varname IN ('BRNAME');


-- GET REPORT'S DATA
 OPEN PV_REFCURSOR
 FOR
    SELECT v_BRNAME TVLK,nvl(DP.FULLNAME,'') BANKFULLNAME , DT.BANK,DT.RECEIVCUSTODYCD,nvl(cf.fullname,DT.FULLNAME) RECEIVFULLNAME, DT.FULLNAME FULLNAME,
    DT.IDCODE IDCODE,DT.IDDATE IDDATE,DT.IDPLACE IDPLACE,DT.ADDRESS ADDRESS, DT.MOBILE,
    DT.CUSTODYCD
    ---INTO V_STR_TVLK_NAME ,V_STR_TVLK_CODE,V_STR_CUSTODYCD_NHAN
    FROM DEPOSIT_MEMBER DP, (
    SELECT se.msgacct acctno, max(se.autoid) autoid,MAX(CASE WHEN TLF.FLDCD = '48' THEN  TLF.CVALUE ELSE ' ' END)   BANK,
           MAX(CASE WHEN TLF.FLDCD = '47' THEN  TLF.CVALUE ELSE ' ' END )  RECEIVCUSTODYCD,
           max(CF.FULLNAME) FULLNAME,
           max((case when substr(nvl(cf.custodycd ,''),4,1)='F' then  cf.tradingcode else to_char(nvl(cf.idcode,'')) end)) idcode,
          -- max(CF.IDCODE) IDCODE,
           max((case when substr(nvl(cf.custodycd ,''),4,1)='F' then  cf.tradingcodedt else to_date(nvl(cf.iddate,'')) end)) iddate,
          -- max(CF.IDDATE) IDDATE,
           max(CF.IDPLACE) IDPLACE,
           max(CF.ADDRESS) ADDRESS, max(NVL(CF.MOBILEsms,' ')) MOBILE, max(cf.CUSTODYCD) CUSTODYCD

       FROM vw_tllog_all  SE, VW_TLLOGFLD_ALL TLF, cfmast cf
    WHERE SE.TLTXCD ='2257' AND SE.DELTD='N'
        AND SE.cfcustodycd = V_CUSTODYCD
        and substr(se.msgacct,1,10) like V_STRAFACCTNO
        and se.CFCUSTODYCD = cf.custodycd
        AND TLF.FLDCD IN ('48','47')
        AND SE.TXNUM = TLF.TXNUM AND  SE.TXDATE =TLF.TXDATE
         AND SE.BUSDATE >= TO_DATE (F_DATE  ,'DD/MM/YYYY')
         AND SE.BUSDATE <= TO_DATE (T_DATE  ,'DD/MM/YYYY')
        group by se.msgacct
        ) DT, cfmast cf,
        (
            select se.msgacct acctno,max(se.autoid) autoid from vw_tllog_all  SE
            where se.tltxcd='2289' --and SE.cfcustodycd = V_CUSTODYCD
            and substr(se.msgacct,1,10) like V_STRAFACCTNO
            and  SE.BUSDATE >= TO_DATE (F_DATE  ,'DD/MM/YYYY')
            and SE.BUSDATE <= TO_DATE (T_DATE  ,'DD/MM/YYYY')
            group by se.msgacct
        ) rev_2257
    WHERE   DP.DEPOSITID(+)  = DT.BANK
            and dt.acctno = rev_2257.acctno(+)
            and dt.autoid >= nvl(rev_2257.autoid,-1)
            and DT.RECEIVCUSTODYCD=cf.custodycd(+)
            and rownum <= 1;

EXCEPTION
   WHEN OTHERS
   THEN
   plog.error('SE0092: Error: ' || SQLERRM || dbms_utility.format_error_backtrace);
      RETURN;
END;
/
