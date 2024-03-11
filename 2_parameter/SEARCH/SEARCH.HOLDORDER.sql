SET DEFINE OFF;

DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('HOLDORDER','NULL');

Insert into SEARCH
   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT)
 Values
   ('HOLDORDER', 'Hold số tiền mua khớp', 'Hold the matched purchase amount', 'SELECT  OD.ORDERID,''HOLDOD'' REQCODE,SB.CODEID , SB.SYMBOL,CF.CUSTID ACCTNO, DD.ACCTNO DDACCTNO,DD.REFCASAACCT ,
                                         CF.CUSTODYCD,CF.FULLNAME CUSTNAME, A1.<@CDCONTENT> EXECTYPE,
                                         OD.TXDATE,OD.CLEARDATE SETTLE_DATE,
                                         (CASE WHEN CF.FEEDAILY = ''Y'' THEN OD.NETAMOUNT ELSE OD.EXECAMT END) AMOUNT, OD.EXECQTTY QUANTITY,NVL(OD.FEEAMT,0) FEE,NVL(OD.TAXAMT,0) TAX,FA.SHORTNAME,
                                         CF.CIFID,DD.BALANCE,DD.HOLDBALANCE,DD.HOLDBALANCE BANKHOLDEDBYBROKER,FA.AUTOID MEMBERID,
                                         VW_MBR.DISPLAY BRNAME,VW_MP.DISPLAY BRPHONE
                             FROM TLLOG TL, ODMAST OD,DDMAST DD,CFMAST CF,SBSECURITIES SB,FAMEMBERS FA,VW_CUSTODYCD_MEMBER MM,
                                 VW_MEMBER_BROKER VW_MBR,VW_MEMBER_PHONE VW_MP,ALLCODE A1,
                                 (select varvalue  from sysvar where varname = ''DEALINGCUSTODYCD'')sys
                                 WHERE   TL.TXNUM = OD.TXNUM
                                     AND OD.ORSTATUS = ''4''
                                     AND TL.TLTXCD = ''8893''
                                     AND DD.STATUS <> ''C'' AND DD.CCYCD = ''VND'' AND DD.ISDEFAULT = ''Y''
                                     AND OD.CUSTODYCD = CF.CUSTODYCD
                                     AND CF.CUSTODYCD = DD.CUSTODYCD
                                     AND OD.CODEID = SB.CODEID
                                     AND FA.AUTOID = OD.MEMBER
                                     AND MM.VALUE = FA.AUTOID
                                     AND MM.FILTERCD = OD.CUSTODYCD
                                     AND OD.EXECTYPE = ''NB''
                                     AND OD.ISHOLD = ''N''
                                     AND FA.AUTOID = VW_MBR.FILTERCD (+)
                                     AND MM.value = VW_MBR.value (+)
                                     AND FA.AUTOID = VW_MP.FILTERCD (+)
                                     AND MM.value = VW_MP.value (+)
                                     AND FA.ROLES = ''BRK''
                                     AND OD.DELTD <> ''Y''
                                     AND A1.CDNAME = ''EXECTYPE'' AND A1.CDTYPE = ''OD'' AND A1.CDVAL = ''NB'' AND A1.CDVAL  = OD.exectype
                                     and SUBSTR(cf.custodycd,0,4) not like sys.varvalue
                                     AND NOT EXISTS ( SELECT F.CVALUE FROM
                                         TLLOG TL, TLLOGFLD F WHERE TL.TXNUM = F.TXNUM AND
                                         TL.TXDATE = F.TXDATE AND TL.TLTXCD = ''6690'' AND F.FLDCD
                                         = ''95'' AND TL.TXSTATUS IN(''1'', ''4'') AND F.CVALUE =  OD.ORDERID)', 'HOLDORDER', NULL, NULL, '6690', NULL, 5000, 'N', 1, 'NNNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);
COMMIT;
