SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW V_CA3383
(QTTY, PQTTY, CAMASTID, AFACCTNO, BALDEFAVL, 
 CODEID, SYMBOL, TRADEPLACE, STATUS, SEACCTNO, 
 PARVALUE, REPORTDATE, ACTIONDATE, EXPRICE, ACCTNO, 
 CUSTODYCD, CUSTNAME, COUNTRY, ADDRESS, LICENSE, 
 IDDATE, IDPLACE, CATYPE, TRFLIMIT, ISSNAME, 
 CODEID0, AUTOID, TOSYMBOL, TOISSNAME, TOCODEID, 
 ISINCODE, ISSUERMEMBER, FROMCUSADD, ISSUERMEMBERCD)
AS 
SELECT MST."QTTY",MST."PQTTY",MST."CAMASTID",MST."AFACCTNO",MST."BALDEFAVL",MST."CODEID",MST."SYMBOL",MST."TRADEPLACE",MST."STATUS",MST."SEACCTNO",MST."PARVALUE",MST."REPORTDATE",MST."ACTIONDATE",MST."EXPRICE",MST."ACCTNO",MST."CUSTODYCD",MST."CUSTNAME",MST."COUNTRY",MST."ADDRESS",MST."LICENSE",MST."IDDATE",MST."IDPLACE",MST."CATYPE",MST."TRFLIMIT",MST."ISSNAME",MST."CODEID0",MST."AUTOID",MST."TOSYMBOL",MST."TOISSNAME",MST."TOCODEID",MST."ISINCODE", (CASE WHEN VW.ISSUERMEMBER='Y' THEN 'TVQT TCPH' ELSE 'No' END ) ISSUERMEMBER,
    M.VARVALUE FROMCUSADD, (CASE WHEN VW.ISSUERMEMBER='Y'THEN 'Y' ELSE 'N' END ) ISSUERMEMBERCD
FROM (SELECT caf.QTTY, caf.PQTTY ,
    SUBSTR(CAMAST.CAMASTID,1,4) || '.'||
    SUBSTR(CAMAST.CAMASTID,5,6) ||'.' ||
    SUBSTR(CAMAST.CAMASTID,11,6) CAMASTID,
           CA.AFACCTNO,nvl(getbaldefavl(CA.AFACCTNO),0) BALDEFAVL, CAMAST.optcodeid  CODEID,
    SYM.SYMBOL,SYM.TRADEPLACE, A1.CDCONTENT
    STATUS,CA.AFACCTNO || CAMAST.CODEID
    SEACCTNO,SYM.PARVALUE PARVALUE,
           CAMAST.REPORTDATE REPORTDATE,
    CAMAST.ACTIONDATE,CAMAST.EXPRICE, AFM.*, A2.CDCONTENT
    CATYPE, CAMAST.TRFLIMIT,ISS.FULLNAME ISSNAME,
    CAMAST.codeid codeid0,
    CA.autoid, sb2.symbol tosymbol, iss2.fullname toissname,
    sb2.codeid tocodeid, camast.isincode
FROM  SBSECURITIES SYM,issuers ISS , ALLCODE A1, CAMAST, CASCHD CA,
      (
      Select af.ACCTNO, CF.CUSTODYCD, cf.fullname
        CUSTNAME, A1.CDCONTENT COUNTRY, cf.address,
        (case when cf.country = '234' then cf.idcode else cf.tradingcode end) LICENSE,
        (case when cf.country = '234' then cf.iddate else cf.tradingcodedt end) iddate,
        cf.idplace
      From cfmast cf, afmast af, ALLCODE A1
      Where af.custid = cf.custid
              and af.status  IN ('A','N')
              AND CF.COUNTRY = A1.CDVAL
              AND A1.CDTYPE ='CF'
              AND A1.CDNAME = 'COUNTRY'
       ) AFM, ALLCODE A2, sbsecurities sb2, issuers iss2,
       (
        select cf.custodycd, ca.camastid,
            sum(CA.Pbalance-ca.inbalance) QTTY, sum(CA.Pbalance- ca.inbalance) PQTTY
        from CAMAST, CASCHD CA, cfmast cf, afmast af
        where cf.custid = af.custid and af.acctno = ca.AFACCTNO
            AND CAMAST.status in ('V','S','M')
            AND CAMAST.catype = '014' AND CA.camastid = CAMAST.camastid
            AND CA.status in('V','S','M') AND CA.DELTD <>'Y' AND CA.PBALANCE - ca.inbalance > 0
            AND CAMAST.TRFLIMIT = 'Y'
            AND camast.frdatetransfer <= GETCURRDATE() AND camast.todatetransfer >= GETCURRDATE()
        group by cf.custodycd, ca.camastid
        ) caf
WHERE CA.AFACCTNO=AFM.ACCTNO AND A1.CDTYPE = 'CA'
    AND A1.CDNAME = 'CASTATUS' AND A1.CDVAL = CA.STATUS
    AND CAMAST.CODEID = SYM.CODEID AND CAMAST.status in ('V','S','M')
    and AFM.CUSTODYCD = caf.custodycd and ca.camastid = caf.camastid
    AND CAMAST.catype='014' AND CA.camastid = CAMAST.camastid
    AND CA.status in('V','S','M') AND CA.DELTD <>'Y' AND CA.PBALANCE - ca.inbalance > 0
    AND CAMAST.CATYPE = A2.CDVAL AND A2.CDTYPE = 'CA'
    AND A2.CDNAME = 'CATYPE' AND CAMAST.TRFLIMIT = 'Y' AND ISS.ISSUERID = SYM.ISSUERID
    and nvl(camast.tocodeid, camast.codeid) = sb2.codeid and sb2.issuerid = iss2.issuerid
    AND camast.frdatetransfer <= GETCURRDATE() AND camast.todatetransfer >= GETCURRDATE()
) MST, (Select VWW.*, 'Y' ISSUERMEMBER from VW_ISSUER_MEMBER VWW) VW, (select VARVALUE from sysvar where VARNAME like '%ISSUERMEMBER%') M
WHERE  MST.CUSTODYCD = VW.CUSTODYCD  (+)
                AND MST.SYMBOL = VW.SYMBOL (+)
/
