SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SE9997','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SE9997', 'Màn hình tra cứu lịch sử chứng khoán', 'View stock list(history)', 'SELECT   SE.SYMBOL AS TICKER
        ,SE.HISTDATE AS TRADINGDATE
        ,SE.BASICPRICE
        ,SE.CLOSEPRICE
        ,SE.AVGPRICE AS AVERAGEPRICE
        ,SE.OLDCIRCULATINGQTTY AS OUTSTANDING_SHARE
        ,SE.NEWCIRCULATINGQTTY AS OUTSTANDING_SHARE_ADJUSTED
        ,A1.CDCONTENT AS TRADEPLACE
FROM (
        SELECT CODEID,SYMBOL,getcurrdate HISTDATE,BASICPRICE,CLOSEPRICE,AVGPRICE,OLDCIRCULATINGQTTY,NEWCIRCULATINGQTTY
        FROM SECURITIES_INFO WHERE SYMBOL NOT LIKE ''%_WFT''
        UNION ALL
        SELECT CODEID,SYMBOL,HISTDATE,BASICPRICE,CLOSEPRICE,AVGPRICE,OLDCIRCULATINGQTTY,NEWCIRCULATINGQTTY
        FROM SECURITIES_INFO_HIST WHERE SYMBOL NOT LIKE ''%_WFT''
      ) SE,
        SBSECURITIES SB, ALLCODE A1
WHERE SE.CODEID = SB.CODEID
        AND SB.TRADEPLACE = A1.CDVAL
        AND A1.CDNAME =''TRADEPLACE''
        AND A1.CDTYPE =''SE''', 'SE9997', NULL, NULL, NULL, NULL, 1000, 'N', 30, 'NNNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;