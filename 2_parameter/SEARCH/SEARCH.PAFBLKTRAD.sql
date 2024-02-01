SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('PAFBLKTRAD','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('PAFBLKTRAD', 'Tra cứu cảnh báo', 'Alert monitoring', 'select * from (
SELECT RF.TLNAME, A0.CDCONTENT SIDE_DESC,
MST.AUTOID, MST.TXDATE, MST.SYMBOL, MST.TRADERID, MST.SIDE, MST.NOTES, MST.QTTY, MST.PRICE, MST.AFACCTNO, TO_CHAR(MST.SYSTIME) LOGTIME
FROM CFAFTRDALERTLOG MST, TLPROFILES RF, ALLCODE A0
WHERE MST.TRADERID=RF.TLID AND A0.CDTYPE=''OD'' AND A0.CDNAME=''EXECTYPE'' AND A0.CDVAL=MST.SIDE

union all
select '''',ALERTTYPE,0,txdate,symbol,'''','''',notes,trade,BASICPRICE,AFACCTNO,TO_CHAR(SYSTIMESTAMP) from vw_dl_profitloss_alert_log
WHERE notes <> ''NONE''
)
where 0=0', 'PAFBLKTRAD', 'frmPAFBLKTRAD', 'AUTOID', NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;