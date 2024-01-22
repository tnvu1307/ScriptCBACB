SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE se0051(
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2,
   PLSENT         in       varchar2
   )
IS
    -- REPORT ON THE DAY BECOME/IS NO LONGER MAJOR SHAREHOLDER, INVESTORS HOLDING 5% OR MORE OF SHARES
    -- PERSON      DATE                 COMMENTS
    -- ---------   ------               -------------------------------------------
    -- DU.PHAN    23-10-2019           CREATED
    /*V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0

    V_FROMDATE          DATE;
    V_TODATE            DATE;
    V_CURRDATE          DATE;
    V_ISSUEDATE         DATE;
    V_EXPDATE           DATE;
    V_CUSTODYCD         VARCHAR2(20);
    V_SYMBOL            VARCHAR2(50);
    V_IDCODE           VARCHAR2(200);
    V_OFFICE           VARCHAR2(200);
    V_REFNAME          VARCHAR2(200);
    V_SHVSTC           VARCHAR2(200);
    V_SHVCUSTODYCD     VARCHAR2(200);
    V_SHVCIFID         VARCHAR2(200);

    V_TLTITLE          VARCHAR2(200);
    V_TLFULLNAME       VARCHAR2(200);*/
    V_STRAFACCTNO  VARCHAR2 (15);
   V_CUSTODYCD VARCHAR2 (15);
   V_TYPE  VARCHAR2(10);

   V_CURRDATE date;
BEGIN
     /*V_STROPTION := OPT;
     V_CURRDATE   := GETCURRDATE;
     IF V_STROPTION = 'A' THEN
        V_STRBRID := '%';
     ELSIF V_STROPTION = 'B' THEN
        V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
     ELSE
        V_STRBRID:=BRID;
     END IF;

    V_CUSTODYCD := REPLACE(P_CUSTODYCD,'.','');
    IF P_SIGNTYPE = '002' THEN
        SELECT MAX(CASE WHEN  VARNAME='1IDCODE' THEN EN_VARDESC ELSE '' END),
           MAX(CASE WHEN  VARNAME='1OFFICE' THEN EN_VARDESC ELSE '' END),
           MAX(CASE WHEN  VARNAME='1REFNAME' THEN EN_VARDESC ELSE '' END)
            INTO V_IDCODE, V_OFFICE, V_REFNAME
        FROM SYSVAR WHERE VARNAME IN ('1IDCODE','1OFFICE','1REFNAME');
    ELSE
        SELECT
           MAX(CASE WHEN  VARNAME='2IDCODE' THEN EN_VARDESC ELSE '' END),
           MAX(CASE WHEN  VARNAME='2OFFICE' THEN EN_VARDESC ELSE '' END),
           MAX(CASE WHEN  VARNAME='2REFNAME' THEN EN_VARDESC ELSE '' END)
            INTO V_IDCODE, V_OFFICE, V_REFNAME
        FROM SYSVAR WHERE VARNAME IN ('2IDCODE','2OFFICE','2REFNAME');
    END IF;

-- LAY THONG TIN CUA SHV

    BEGIN
        SELECT MAX((CASE WHEN VARNAME ='TRANDINGCODE' THEN VARVALUE ELSE '' END))
        , MAX((CASE WHEN VARNAME ='CUSTODYCD' THEN VARVALUE ELSE '' END))
        , MAX((CASE WHEN VARNAME ='CIFID' THEN VARVALUE ELSE '' END))
        INTO V_SHVSTC, V_SHVCUSTODYCD,V_SHVCIFID
        FROM   SYSVAR
        WHERE VARNAME IN ('TRANDINGCODE','CUSTODYCD','CIFID');  --DATA TAM THOI
    EXCEPTION
        WHEN OTHERS  THEN
            V_SHVSTC := '';
            V_SHVCUSTODYCD := '';
            V_SHVCIFID :='';
    END;
-- LAY THONG TIN NGUOI UY QUYEN
    BEGIN
        SELECT TLFULLNAME, TLTITLE
        INTO V_TLFULLNAME, V_TLTITLE
        FROM   TLPROFILES
        WHERE TLNAME = P_CFAUTH;
    EXCEPTION
        WHEN OTHERS  THEN
            V_TLFULLNAME := '';
            V_TLTITLE := '';

    END;
*/
    V_CUSTODYCD := upper( PV_CUSTODYCD);
    select to_date(varvalue,'DD/MM/RRRR') into V_CURRDATE
    from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM';

    IF  (PV_AFACCTNO <> 'ALL')
    THEN
         V_STRAFACCTNO := PV_AFACCTNO;
    ELSE
         V_STRAFACCTNO := '%';
    END IF;
OPEN PV_REFCURSOR FOR
    SELECT custodycd,PLSENT,FULLNAME,idcode,iddate,idplace,address,mobilesms,SYMBOL,TRADEPLACE ,
    SUM(trade) trade,
    SUM(blocked) blocked,
    SUM(trade_wft) trade_wft,
    SUM(blocked_wft) blocked_wft,
    SUM(total)   total
    FROM (
    SELECT custodycd , PLSENT PLSENT, CF.FULLNAME,cf.idcode,cf.iddate, cf.idplace,cf.address, nvl(cf.mobilesms,' ') mobilesms, REPLACE( sb.symbol,'_WFT','') SYMBOL ,
    CASE WHEN sb.tradeplace ='002' THEN 'A. HNX' WHEN sb.tradeplace ='001' THEN 'B. HOSE' WHEN sb.tradeplace ='005' THEN 'C. UPCOM' END TRADEPLACE ,
    CASE WHEN sb.refcodeid IS  NULL THEN se.trade ELSE 0 END trade,
    CASE WHEN sb.refcodeid IS  NULL THEN se.blocked ELSE 0 END blocked,
    CASE WHEN sb.refcodeid IS not  NULL THEN se.trade ELSE 0 END trade_wft,
    CASE WHEN sb.refcodeid IS NOT NULL THEN se.blocked ELSE 0 END blocked_wft,
    se.trade+se.blocked total
    FROM sbsecurities sb,afmast af, vw_cfmast_m cf,
            (SELECT max(msgacct) seacctno, max(decode(fldcd,'10',nvalue)) trade,max(decode(fldcd,'06',nvalue)) blocked
            FROM vw_tllogfld_all tlfld,vw_tllog_all tl
            WHERE tl.txnum = tlfld.txnum AND tl.txdate= tlfld.txdate
            AND tl.txdate BETWEEN to_date (F_DATE,'dd/mm/yyyy') AND to_date (t_DATE,'dd/mm/yyyy')
            AND tl.deltd <>'Y'
            AND tl.tltxcd ='2247'
            GROUP BY tl.txnum , tl.txdate )se
    WHERE substr(se.seacctno,11)= sb.codeid
    AND substr(se.seacctno,1,10)= af.acctno
    AND af.custid = cf.custid
    AND cf.custodycd LIKE V_CUSTODYCD
    AND af.acctno LIKE V_STRAFACCTNO
    ) GROUP BY custodycd,PLSENT,FULLNAME,idcode,iddate,idplace,address,mobilesms,SYMBOL,TRADEPLACE
    ;

EXCEPTION
  WHEN OTHERS
   THEN
      PLOG.ERROR ('SE0051: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RETURN;
END;
/
