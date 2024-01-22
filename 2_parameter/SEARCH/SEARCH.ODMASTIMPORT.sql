SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('ODMASTIMPORT','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('ODMASTIMPORT', 'Tổng hợp nguồn lệnh client và broker', 'Order source from client and broker', 'SELECT A.*, SB.ASSETTYPEVAL, SB.ASSETTYPE
FROM
(
    SELECT ''Client'' SOURCE, A1.CDCONTENT VIA, TO_CHAR(TXTIME,''DD/MM/RRRR'') RECORDDATE, DP.SHORTNAME CTCK, OD.CUSTODYCD, OD.SEC_ID SYMBOL, A2.<@CDCONTENT> ODTYPE,
        OD.TRADE_DATE TRADEDATE, OD.SETTLE_DATE SETTLEDATE, OD.PRICE, OD.QUANTITY QTTY, OD.GROSS_AMOUNT GROSSAMOUNT, NVL(OD.COMMISSION_FEE,''0'') FEE,
        NVL(OD.TAX,''0'')TAX, FILEID IDFILE, AUTOID, A3.<@CDCONTENT> STATUSTEXT, A3.CDVAL STATUS
    FROM ODMASTCUST OD, DEPOSIT_MEMBER DP,
    (SELECT * FROM ALLCODE WHERE CDNAME = ''VIA'' AND CDTYPE = ''OD'') A1,
    (SELECT * FROM ALLCODE WHERE CDNAME = ''EXECTYPE'' AND CDTYPE = ''OD'') A2,
    (SELECT * FROM ALLCODE WHERE CDNAME = ''DELTDTEXT'' AND CDTYPE = ''DD'') A3
    WHERE OD.BROKER_CODE = DP.DEPOSITID
    AND OD.VIA = A1.CDVAL(+)
    AND OD.TRANS_TYPE = A2.CDVAL(+)
    AND OD.DELTD = A3.CDVAL(+)
    UNION ALL
    SELECT ''Broker'' SOURCE, (CASE WHEN LENGTH(FILEID) > 17 THEN ''MANUAL'' ELSE ''Import'' END) VIA, TO_CHAR(TXTIME,''DD/MM/RRRR'')RECORDDATE, DP.SHORTNAME CTCK, OD.CUSTODYCD, OD.SEC_ID SYMBOL, A2.<@CDCONTENT> ODTYPE,
        OD.TRADE_DATE TRADEDATE, OD.SETTLE_DATE SETTLEDATE, OD.PRICE, OD.QUANTITY QTTY, OD.GROSS_AMOUNT GROSSAMOUNT, NVL(OD.COMMISSION_FEE,''0'') FEE,
        NVL(OD.TAX,''0'')TAX, OD.FILEID IDFILE, OD.AUTOID, A3.<@CDCONTENT> STATUSTEXT, A3.CDVAL STATUS
    FROM ODMASTCMP OD, DEPOSIT_MEMBER DP,
    (SELECT * FROM ALLCODE WHERE CDNAME = ''EXECTYPE'' AND CDTYPE = ''OD'') A2,
    (SELECT * FROM ALLCODE WHERE CDNAME = ''DELTDTEXT'' AND CDTYPE = ''DD'') A3
    WHERE OD.BROKER_CODE = DP.DEPOSITID
    AND OD.TRANS_TYPE = A2.CDVAL(+)
    AND OD.DELTD = A3.CDVAL(+)
)A,
(
    SELECT SB.CODEID, SB.SYMBOL, A1.CDVAL ASSETTYPEVAL, A1.<@CDCONTENT> ASSETTYPE
    FROM SBSECURITIES SB,
    (SELECT * FROM ALLCODE WHERE CDTYPE = ''OD'' AND CDNAME = ''ASSETTYPE'') A1
    WHERE (CASE WHEN SB.TRADEPLACE = ''099'' THEN ''TPRL'' ELSE ''CKNY'' END) = A1.CDVAL(+)
) SB
WHERE 0 = 0
AND A.SYMBOL = SB.SYMBOL', 'ODMASTIMPORT', '', 'IDFILE', '', 0, 5000, 'N', 1, 'NNNNYYYNNN', 'N', 'T', '', 'N', '');COMMIT;