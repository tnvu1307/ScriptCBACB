SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('RISK_MAMAGEMENT','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('RISK_MAMAGEMENT', 'RISK_MAMAGEMENT', 'RISK_MAMAGEMENT', 'SELECT AUTOID, CODEID, SYMBOL, TXDATE, LISTINGQTTY, TRADEUNIT, A1.CDCONTENT LISTINGSTATUS, ADJUSTQTTY, LISTTINGDATE, A2.CDCONTENT REFERENCESTATUS, ADJUSTRATE, REFERENCERATE, REFERENCEDATE, A3.CDCONTENT STATUS, BASICPRICE, OPENPRICE, PREVCLOSEPRICE, CURRPRICE, AVGPRICE, CEILINGPRICE, FLOORPRICE, MTMPRICE, A4.CDCONTENT MTMPRICECD, INTERNALBIDPRICE, INTERNALASKPRICE, PE,EPS, DIVYEILD, DAYRANGE, YEARRANGE FROM SECURITIES_INFO, ALLCODE A1, ALLCODE A2, ALLCODE A3, ALLCODE A4 WHERE A1.CDTYPE = ''OD'' AND A1.CDNAME = ''LISTINGSTATUS'' AND A1.CDVAL=LISTINGSTATUS AND A2.CDTYPE = ''OD'' AND A2.CDNAME = ''REFERENCESTATUS'' AND A2.CDVAL=REFERENCESTATUS AND A3.CDTYPE = ''OD'' AND A3.CDNAME = ''STATUS'' AND A3.CDVAL=STATUS AND A4.CDTYPE = ''OD'' AND A4.CDNAME = ''MTMPRICECD'' AND A4.CDVAL=MTMPRICECD', 'SECURITIES_INFO', 'frmSECINFO', NULL, NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;