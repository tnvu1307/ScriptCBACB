SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('ODMAST','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('ODMAST', 'Quản lý sổ lệnh', 'Order management', 'SELECT VW.ORDERID, VW.CTCK, CF.FULLNAME, VW.CUSTODYCD, CF.CIFID, VW.EXECTYPE, VW.SYMBOL, ROUND(VW.PRICE,6) PRICE, VW.QTTY, VW.AMT, VW.FEE, VW.TAX, VW.TXDATE, VW.SETLDATE, VW.TIMECREATE,
        (CASE WHEN VW.ODTYPE = ''ODG'' THEN ROUND((VW.PRICE/NVL(SB.PARVALUE,0))*100,3) ELSE 0 END) NOMINALPRICE,
        (CASE WHEN VW.ODTYPE <> ''SWE'' THEN A4.<@CDCONTENT> ELSE '''' END) SOURCE,
        (
            case when vw.odtype <> ''SWE'' then
                case when vw.source = ''CLIENT'' then A5.<@CDCONTENT>
                     when vw.source = ''BROKER'' then A7.<@CDCONTENT>
                     else
                        (
                            case when vw.source in (''OD8893'',''CLIENTVSD'') then
                                      (case when length(odcu.fileid) >17 then ''Manual-'' else ''Import-'' end)
                                 when vw.source in (''BROKERCLIENT'') and length(A5.<@CDCONTENT>) > 0 then
                                      A5.<@CDCONTENT> || ''-''
                                 else ''''
                            end
                        ) ||
                        (
                            case when vw.source in (''OD8893'',''VSDBROKER'') then
                                      (case when length(odcmp.fileid) >17 then ''Manual-'' else ''Import-'' end)
                                 when vw.source in (''BROKERCLIENT'') and length(A7.<@CDCONTENT>) > 0 then
                                      A7.<@CDCONTENT>
                                 else ''''
                            end
                        ) ||
                        (
                            case when vw.source in (''OD8893'',''VSDBROKER'',''CLIENTVSD'') then
                                      (case when length(odvsd.fileid) >17 then ''Manual'' else ''Import'' end)
                            else '''' end
                        )
                end
            else '''' end
        ) VIA,
        A2.CDVAL STATUSCDVAL, A2.<@CDCONTENT> STATUS,
        A3.CDVAL ODTYPEVAL, A3.<@CDCONTENT> ODTYPE,
        A6.CDVAL PAYMENTSTATUSVAL, A6.<@CDCONTENT> ISPAYMENT,
        A8.CDVAL ASSETTYPEVAL, A8.<@CDCONTENT> ASSETTYPE
FROM VW_ODMAST_IMPORT VW, CFMAST CF, SBSECURITIES SB,
    (SELECT MAX(FILEID) FILEID,ORDERID,VIA FROM ODMASTCMP WHERE DELTD <>''Y'' GROUP BY ORDERID,VIA) ODCMP,
    (SELECT MAX(FILEID) FILEID,ORDERID,VIA FROM ODMASTCUST WHERE DELTD <> ''Y'' GROUP BY ORDERID,VIA) ODCU,
    (SELECT MAX(FILEID) FILEID,ORDERID FROM ODMASTVSD WHERE DELTD <> ''Y'' GROUP BY ORDERID) ODVSD,
    (SELECT * FROM ALLCODE WHERE CDNAME = ''ORSTATUS'' AND CDTYPE = ''OD'') A2,
    (SELECT * FROM ALLCODE WHERE CDNAME = ''ODTYPE'' AND CDTYPE = ''OD'') A3,
    (SELECT * FROM ALLCODE WHERE CDNAME = ''ODMASTRESULT'') A4,
    (SELECT * FROM ALLCODE WHERE CDTYPE = ''OD'' AND CDNAME = ''VIA'') A5,
    (SELECT * FROM ALLCODE WHERE CDNAME = ''ISPAYMENT'' AND CDTYPE = ''OD'') A6,
    (SELECT * FROM ALLCODE WHERE CDTYPE = ''OD'' AND CDNAME = ''VIA'') A7,
    (SELECT * FROM ALLCODE WHERE CDTYPE = ''OD'' AND CDNAME = ''ASSETTYPE'') A8
WHERE 0=0
AND CF.CUSTODYCD = VW.CUSTODYCD
AND VW.SYMBOL = SB.SYMBOL
AND VW.ISPAYMENT = A6.CDVAL(+)
AND VW.STATUS = A2.CDVAL(+)
AND VW.ODTYPE = A3.CDVAL(+)
AND VW.SOURCE = A4.CDVAL(+)
AND VW.ORDERID = ODCMP.ORDERID(+)
AND VW.ORDERID = ODCU.ORDERID(+)
AND VW.ORDERID = ODVSD.ORDERID(+)
AND ODCU.VIA = A5.CDVAL(+)
AND ODCMP.VIA = A7.CDVAL(+)
AND (CASE WHEN SB.TRADEPLACE = ''099'' THEN ''TPRL'' ELSE ''CKNY'' END) = A8.CDVAL(+)', 'ODMAST', 'frmODMAST', 'ORDERID DESC', '', 0, 500, 'Y', 1, '', 'Y', 'T', '', 'N', '');COMMIT;