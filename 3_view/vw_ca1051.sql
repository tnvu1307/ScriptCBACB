SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_CA1051
(CAMASTID, CATYPE, SYMBOL, REPORTDATE, ACTIONDATE, 
 CAPTUREDATE, REPORTDATEPASS, RATE)
AS 
select a."CAMASTID",a."CATYPE",a."SYMBOL",a."REPORTDATE",a."ACTIONDATE",a."CAPTUREDATE",a."REPORTDATEPASS",a."RATE" from (
SELECT ca.camastid camastid, --CA ID
         a1.CDCONTENT CATYPE,--Event type
         sb.symbol symbol, --Ticker,
         ca.reportdate, --Record date,
         TO_CHAR(ca.actiondate,'DD/MM/RRRR') actiondate,
         TO_CHAR(nvl(log.approve_dt,''),'DD/MM/RRRR') capturedate,
         (case when ca.status = 'P' and getcurrdate > ca.reportdate then 'Y' else 'N' end ) REPORTDATEPASS,
         (CASE WHEN ca.RIGHTOFFRATE IS NOT NULL THEN ca.RIGHTOFFRATE
               ELSE (CASE WHEN ca.EXRATE IS NOT NULL THEN ca.EXRATE
                          ELSE (CASE WHEN ca.DEVIDENTRATE IS NOT NULL AND ca.DEVIDENTRATE <> '0' THEN ca.DEVIDENTRATE
                                     ELSE (CASE WHEN SPLITRATE IS NOT NULL THEN ca.SPLITRATE
                                                ELSE (CASE WHEN ca.INTERESTRATE IS NOT NULL THEN INTERESTRATE
                                                           ELSE (CASE WHEN DEVIDENTSHARES IS NOT NULL THEN DEVIDENTSHARES
                                                                      ELSE '0' END)END)END)END) END)END) RATE
    FROM  sbsecurities sb,
        CAMAST ca 
        left join
        (
            select min(approve_dt) approve_dt, record_key
            from maintain_log where table_name ='CAMAST'
            group by record_key
        )log on ca.camastid=SUBSTR(log.record_key,13,length(log.record_key)-13)
        left join allcode a1 on a1.cdval = ca.catype
    where   ca.status = 'P'
        and ca.codeid = sb.codeid
        and a1.cdtype='CA' and a1.cdname='CATYPE'
)a,(select * from vw_holding_1051 where amt =0  ) cas
        where    a.camastid = cas.camastid
            and getcurrdate > a.reportdate 

union all
select a."CAMASTID",a."CATYPE",a."SYMBOL",a."REPORTDATE",a."ACTIONDATE",a."CAPTUREDATE",a."REPORTDATEPASS",a."RATE" from (
SELECT ca.camastid camastid, --CA ID
         a1.CDCONTENT CATYPE,--Event type
         sb.symbol symbol, --Ticker,
         ca.reportdate, --Record date,
         TO_CHAR(ca.actiondate,'DD/MM/RRRR') actiondate,
         TO_CHAR(nvl(log.approve_dt,''),'DD/MM/RRRR') capturedate,
         (case when ca.status = 'P' and getcurrdate > ca.reportdate then 'Y' else 'N' end ) REPORTDATEPASS,
         (CASE WHEN ca.RIGHTOFFRATE IS NOT NULL THEN ca.RIGHTOFFRATE
               ELSE (CASE WHEN ca.EXRATE IS NOT NULL THEN ca.EXRATE
                          ELSE (CASE WHEN ca.DEVIDENTRATE IS NOT NULL AND ca.DEVIDENTRATE <> '0' THEN ca.DEVIDENTRATE
                                     ELSE (CASE WHEN SPLITRATE IS NOT NULL THEN ca.SPLITRATE
                                                ELSE (CASE WHEN ca.INTERESTRATE IS NOT NULL THEN INTERESTRATE
                                                           ELSE (CASE WHEN DEVIDENTSHARES IS NOT NULL THEN DEVIDENTSHARES
                                                                      ELSE '0' END)END)END)END) END)END) RATE
    FROM  sbsecurities sb,
        CAMAST ca 
        left join
        (
            select min(approve_dt) approve_dt, record_key
            from maintain_log where table_name ='CAMAST'
            group by record_key
        )log on ca.camastid=SUBSTR(log.record_key,13,length(log.record_key)-13)
        left join allcode a1 on a1.cdval = ca.catype
    where   ca.status = 'P'
        and ca.codeid = sb.codeid
        and a1.cdtype='CA' and a1.cdname='CATYPE'
)a,(select * from vw_holding_1051 where amt > 0 )  cas
        where    a.camastid = cas.camastid
/
