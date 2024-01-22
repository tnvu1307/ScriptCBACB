SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_CRPHYSAGREE
(GLOBALID, CRPHYSAGREEID, NO, NAME, CODEID, 
 QTTY, STATUS, CREATDATE, EFFDATE, ACCTNO, 
 CLVALUE, BANKACCTNO, BANKCODE, DESCRIPTION, PSTATUS, 
 REQTTY, SYMBOL, PAYSTATUS, BALANCESTATUS, REPOSSTATUS, 
 CITAD, ISSUERID, TXDATE, TXNUM, ORIGIONAL_NO, 
 ROLLID, BNAME, CUSTODYCD, TREMQTTY, TOTALQTTY, 
 STOCKQTTY, CHECKVAL, BALANCESTATUSCNT, REPOSSTATUSCNT, PARVALUE, 
 INTERESTDATE, ISSUERNAME, EXPDATE, EDITALLOW, TRADE1404, 
 APRALLOW, DELALLOW)
AS 
SELECT ('CB.' || to_char(cr.txdate,'yyyymmdd') || '.' || cr.txnum) GLOBALID,CR."CRPHYSAGREEID",CR."NO",CR."NAME",CR."CODEID",CR."QTTY",CR."STATUS",CR."CREATDATE",CR."EFFDATE",CR."ACCTNO",CR."CLVALUE",CR."BANKACCTNO",CR."BANKCODE",CR."DESCRIPTION",CR."PSTATUS",CR."REQTTY",CR."SYMBOL",CR."PAYSTATUS",CR."BALANCESTATUS",CR."REPOSSTATUS",CR."CITAD",CR."ISSUERID",CR."TXDATE",CR."TXNUM",CR."ORIGIONAL_NO",CR."ROLLID",CR."BNAME",CR."CUSTODYCD", (CR.QTTY-CR.REQTTY) TREMQTTY,
       LEAST(se.total, (nvl(NH.QTTY_NHAP,0) + nvl(q14.qt_1414,0) - NVL(RUT.QTTY_RUT,0) - nvl(q00.qt_1400,0) + nvl(q1444.qtty_1444,0))) TOTALQTTY
       , qtr.qt_docstranfer STOCKQTTY, 0 CHECKVAL, 
       --A0.CDCONTENT STATUSCNT, 
       --A1.CDCONTENT PAYSTATUSCNT,
       (case when nvl( q04.qt_1404,0)= 0 and nvl(q14.qt_1414,0)= 0 and nvl(RUT.QTTY_RUT,0)=0 and nvl(q00.qt_1400,0) = 0  then ''
                when nvl( q04.qt_1404,0) + nvl(q14.qt_1414,0) - nvl(RUT.QTTY_RUT,0) - nvl(q00.qt_1400,0)  = CR.qtty then 'Fully'
                when ( nvl(q04.qt_1404,0) + nvl(q14.qt_1414,0) ) >0 and se.trade = 0 then 'NA'
                when nvl(q04.qt_1404,0) + nvl(q14.qt_1414,0) - nvl(RUT.QTTY_RUT,0) - nvl(q00.qt_1400,0) < CR.qtty then 'Partially' else '' end) BALANCESTATUSCNT
       , (case    when nvl(q05.qt_1405,0) = 0  and nvl(q06.qt_1406,0) = 0 then ''
                when nvl(q05.qt_1405,0) - nvl(q06.qt_1406,0)  = CR.qtty then 'Fully'
                 when nvl(q05.qt_1405,0) = 0 then 'NA'
                when nvl(q05.qt_1405,0) - nvl(q06.qt_1406,0) < CR.qtty then 'Partially' else '' end) REPOSSTATUSCNT
       , SB.PARVALUE, SB.INTERESTDATE, ISS.FULLNAME ISSUERNAME,SB.EXPDATE,
       'Y' EDITALLOW,(NVL(NH1415.QTTY_NHAP,0) - NVL(R1416.QTTY_RUT,0)) TRADE1404,
       (CASE WHEN CR.STATUS IN ('P') THEN 'Y' ELSE 'N' END) APRALLOW,(CASE WHEN CR.STATUS IN ('P') THEN 'Y' ELSE 'N' END) DELALLOW
FROM    (
    select CR1.crphysagreeid, CR1.no, CR1.name, CR1.codeid, CR1.qtty, CR1.status, CR1.creatdate, CR1.effdate, CR1.acctno, CR1.clvalue, CR1.bankacctno, CR1.bankcode, CR1.description, CR1.pstatus,
            CR1.reqtty, CR1.symbol, CR1.paystatus, CR1.balancestatus, CR1.reposstatus, CR1.citad, CR1.issuerid, CR1.txdate, CR1.txnum,CR1.origional_no, CR1.rollid, CR1.bname, 
        CF.CUSTODYCD
    From CRPHYSAGREE CR1, CFMAST CF
    where CR1.deltd <>'Y'
    AND CR1.ACCTNO = CF.CUSTID
) CR,ISSUERS ISS, SBSECURITIES SB, --ALLCODE A0, ALLCODE A1,--ALLCODE A2,ALLCODE A3,
        (SELECT CRPHYSAGREEID,SUM(QTTY)QTTY_NHAP FROM CRPHYSAGREE_LOG WHERE TYPE ='R'  GROUP BY CRPHYSAGREEID)NH ,
        ( select crphysagreeid,sum(qtty) qt_1405 from docstransfer where status = 'OPN' group by crphysagreeid) q05,--1405
        ( select crphysagreeid,sum(qtty) qt_1406 from docstransfer where status = 'CLS' group by crphysagreeid) q06,--1406
        ( select  crphysagreeid,sum(qtty) qt_1404  from crphysagree_log where type= 'R' group by crphysagreeid) q04,--1404
        ( select crphysagreeid,sum(wdqtty) QTTY_RUT from crphysagree_withdraw_log where type = 'WD' group by crphysagreeid)RUT,--1413
        ( select crphysagreeid,sum(icqtty) qt_1414 from crphysagree_withdraw_log where type = 'IC' group by crphysagreeid)q14,--1414
        ( select crphysagreeid,sum(qtty) qt_1400 from crphysagree_sell_log group by crphysagreeid)q00,--1400,
        ( select crphysagreeid,(case when status = 'OPN' then SUM(nvl(qtty,0)) else 0 end) qt_docstranfer from docstransfer where status = 'OPN' GROUP BY crphysagreeid,STATUS) qtr,--1405
        (select acctno, sum(trade) trade, sum(trade+hold+mortage+netting+blocked+withdraw+blockwithdraw+emkqtty) total from semast group by acctno) se,
        (select CRPHYSAGREEID,sum(qtty) qtty_1444 From CRPHYSAGREE_LOG_ALL where tltxcd = '1444' group by CRPHYSAGREEID) q1444,
        (SELECT CRPHYSAGREEID,SUM(QTTY)QTTY_NHAP FROM CRPHYSAGREE_LOG WHERE TYPE ='TRADE1404'  GROUP BY CRPHYSAGREEID)NH1415 ,--Nhap 1415
        (SELECT CRPHYSAGREEID,SUM(QTTY)QTTY_RUT FROM CRPHYSAGREE_LOG WHERE TYPE ='RUT1404'  GROUP BY CRPHYSAGREEID)R1416--Rut 1416
WHERE CR.ISSUERID = ISS.ISSUERID
AND CR.CODEID = SB.CODEID
--AND A0.CDVAL =CR.STATUS AND A0.CDTYPE='AP' AND A0.CDNAME='STATUS'
--AND A1.CDVAL =CR.PAYSTATUS AND A1.CDTYPE='AP' AND A1.CDNAME='PAYSTATUS'
AND CR.CRPHYSAGREEID = NH.CRPHYSAGREEID(+)
AND CR.CRPHYSAGREEID = RUT.CRPHYSAGREEID(+)
AND CR.CRPHYSAGREEID = q05.CRPHYSAGREEID(+)
AND CR.CRPHYSAGREEID = q06.CRPHYSAGREEID(+)
AND CR.CRPHYSAGREEID = q04.CRPHYSAGREEID(+)
AND CR.CRPHYSAGREEID = q14.CRPHYSAGREEID(+)
AND CR.CRPHYSAGREEID = q00.CRPHYSAGREEID(+)
AND CR.CRPHYSAGREEID = qtr.CRPHYSAGREEID(+)
AND CR.CRPHYSAGREEID = q1444.CRPHYSAGREEID(+)
AND CR.CRPHYSAGREEID = NH1415.CRPHYSAGREEID(+)
AND CR.CRPHYSAGREEID = R1416.CRPHYSAGREEID(+)
and cr.acctno||cr.codeid = se.acctno(+)
/
