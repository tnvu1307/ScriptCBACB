SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CF0036','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CF0036', 'Tạo file excel danh sách giao dịch lưu ký cho VSD', 'Create excel file - list of depository transaction VSD', 'SELECT ROWNUM STT, CF.fullname, CF.custodycd,
    (CASE WHEN CF.IDTYPE = ''002'' THEN CF.tradingcode ELSE CF.idcode END) idcode,
    (CASE WHEN CF.IDTYPE = ''002'' THEN CF.tradingcodedt ELSE CF.iddate END) iddate,
    decode (cf.idtype, 001, 1, 009, 2, 005, 3, 4 ) IDTYPE, TR.QTTY ,
    (CASE WHEN INSTR(SB.symbol,''_WFT'') > 0 THEN 6 ELSE 0 END) + TR.QTTYTYPE QTTYTYPE,
    TR.busdate, TR.TXDATE,
    (CASE WHEN INSTR(SB.symbol,''_WFT'') > 0 THEN
         SUBSTR(SB.symbol,1,LENGTH(SB.symbol)-4) ELSE SB.symbol END) SYMBOL
FROM
(
select TL.busdate, DP.TXDATE, DP.acctno, DP.depotrade QTTY, 1 QTTYTYPE
from vw_tllog_all TL , sedeposit DP
where TL.tltxcd = ''2240'' AND TL.TXSTATUS = ''1'' AND TL.deltd = ''N''
    AND TL.TXNUM = DP.TXNUM AND TL.TXDATE = DP.txdate AND DP.depotrade > 0
    AND DP.status <> ''C'' AND DP.deltd = ''N''
UNION ALL
select TL.busdate, DP.TXDATE, DP.acctno, DP.depoblock QTTY, 2 QTTYTYPE
from vw_tllog_all TL , sedeposit DP
where TL.tltxcd = ''2240'' AND TL.TXSTATUS = ''1'' AND TL.deltd = ''N''
    AND TL.TXNUM = DP.TXNUM AND TL.TXDATE = DP.txdate  AND DP.depoblock > 0
    AND DP.status <> ''C'' AND DP.deltd = ''N''
) TR, semast SE, cfmast CF, afmast AF, sbsecurities SB
WHERE TR.acctno = SE.acctno AND SE.afacctno = AF.acctno AND AF.custid = CF.custid
    AND SE.codeid = SB.codeid', 'SEMAST', 'frmSEMAST', '', '', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;