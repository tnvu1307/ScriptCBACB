SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CA3324','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CA3324', 'Đăng ký mua CP phát hành thêm không cắt tiền CI', 'Register right issue not debit CI balance', 'SELECT ABC, autoid,v.CUSTODYCD,cf.CIFID, v.FULLNAME, AFACCTNO, CAMASTID, SYMBOL,
CODEID, TRADE,BALANCE, PBALANCE,INBALANCE,OUTBALANCE, QTTY, MAXQTTY, CUSTNAME, v.IDCODE,
v.IDPLACE, v.ADDRESS, v.IDDATE, 0 AAMT, OPTCODEID, OPTSYMBOL, ISCOREBANK,
COREBANK, v.STATUS, SEACCTNO, OPTSEACCTNO,issname, PARVALUE, REPORTDATE, ACTIONDATE, EXPRICE,
EN_DESCRIPTION, v.DESCRIPTION, CATYPE, BALDEFOVD CIBALANCE,v.PHONE, v.BANKACCTNO, BANKNAME,SYMBOL_ORG , isincode
FROM vw_strade_ca_rightoff v 
left join cfmast cf on cf.CUSTODYCD = v.CUSTODYCD WHERE 0=0', 'CAMAST', NULL, NULL, '3324', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;