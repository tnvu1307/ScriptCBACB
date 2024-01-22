SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SE2203','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SE2203', 'Tra cứu chứng khoán bị tạm giữ', 'View securities blocked', 'SELECT  FN_GET_LOCATION(AF.BRID) LOCATION, cf.custodycd,af.acctno afacctno, se.acctno,DT.CODEID, dt.symbol, se.blocked,se.emkqtty- nvl(sem.qtty,0) emkqtty, dt.parvalue,dt.tradeplace,se.blockwithdraw blockwithdraw,
se.blocked REALBLOCKED,se.emkqtty- nvl(sem.qtty,0) - nvl(er.qtty,0) REALEMKQTTY,
dt.price,cf.address,cf.fullname
FROM semast se, cfmast cf,afmast af,   (SELECT   sb.symbol,
               sb.codeid, sb.parvalue, sein.prevcloseprice price, a4.cdcontent tradeplace
            FROM   securities_info sein,
               sbsecurities sb,
               allcode a4
           WHERE     sb.codeid = sein.codeid
               AND a4.cdtype = ''SE''
               AND a4.cdname = ''TRADEPLACE''
               AND a4.cdval = sb.tradeplace) dt,
               (SELECT SUM ( QTTY) QTTY ,ACCTNO FROM SEMORTAGE WHERE STATUS =''N'' AND DELTD <>''Y''GROUP BY ACCTNO ) SEM,
               (select sseacctno, sum(blockedqtty) qtty from escrow es where es.deltd <> ''Y'' group by sseacctno) er
WHERE af.custid = cf.custid
AND se.afacctno = af.acctno
AND se.codeid = dt.codeid
AND se.acctno = sem.acctno (+)
AND se.acctno = er.sseacctno (+)
AND se.blocked+ se.emkqtty - nvl(sem.qtty,0) - nvl(er.qtty,0)>0', 'SEMAST', '', '', '2203', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;