SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('OD8893','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('OD8893', 'Đối chiếu kết quả giao dịch', 'Transaction reconciliation', 'SELECT VW.NOTE1, VW.NOTEVSBR, VW.NOTE, VW.ISODMAST, VW.CUSTMEMBER, VW.CMPMEMBER, VW.VSDMEMBER, A.<@CDCONTENT> SUPERBANK, CF.CUSTODYCD, VW.SYMBOL, SB.ASSETTYPE, VW.TRANSTYPE, VW.TRADEDATE, VW.TRADEDATECTCK, VW.TRADEDATEVSD, VW.CUSTSETTLEDATE, VW.CMPSETTLEDATE, VW.VSDSETTLEDATE,
    VW.CUSTPRICE, VW.CMPPRICE, VW.VSDPRICE, VW.CUSTQTTY, VW.CMPQTTY, VW.VSDQTTY, VW.CUSTAMOUNT, VW.CMPAMOUNT, VW.VSDAMOUNT, VW.CUSTAMOUNTNET, VW.CMPAMOUNTNET, VW.VSDAMOUNTNET, VW.CUSTFEE, VW.CMPFEE, VW.CUSTTAX, VW.CMPTAX, VW.STATUS,
    VW.DESCT, VW.CITAD, VW.IDENTITY, VW.ISODMASTVAL
FROM V_COMPARE_IMPORT VW,
(SELECT CUSTODYCD, SUPEBANK FROM CFMAST WHERE STATUS <> ''C'') CF,
(
    SELECT SB.CODEID, SB.SYMBOL, A1.CDVAL ASSETTYPEVAL, A1.<@CDCONTENT> ASSETTYPE
    FROM SBSECURITIES SB,
    (SELECT * FROM ALLCODE WHERE CDTYPE = ''OD'' AND CDNAME = ''ASSETTYPE'') A1
    WHERE (CASE WHEN SB.TRADEPLACE = ''099'' THEN ''TPRL'' ELSE ''CKNY'' END) = A1.CDVAL(+)
) SB,
(SELECT * FROM ALLCODE WHERE CDNAME = ''YESNO'' AND CDTYPE= ''SY'') A
WHERE 0 = 0
AND VW.CUSTODYCD = CF.CUSTODYCD
AND VW.SYMBOL = SB.SYMBOL
AND CF.SUPEBANK = A.CDVAL(+)', 'OD8893', NULL, 'cmpmember,note1', NULL, 0, 5000, 'N', 1, 'NNNNYYYNNN', 'N', 'T', NULL, 'N', NULL);COMMIT;