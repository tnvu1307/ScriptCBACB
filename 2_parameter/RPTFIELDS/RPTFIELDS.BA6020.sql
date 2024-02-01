SET DEFINE OFF;DELETE FROM RPTFIELDS WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('BA6020','NULL');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('BA', 'PV_SYMBOL', 'BA6020', 'PV_SYMBOL', 'Mã TP', 'Ticker', 0, 'M', NULL, NULL, 20, 'SELECT SYMBOL VALUE, SYMBOL VALUECD, fullname DISPLAY, SYMBOL EN_DISPLAY, SYMBOL DESCRIPTION
FROM (SELECT to_char(SYMBOL)SYMBOL , to_char(IR.fullname) fullname ,1 LSTODR
FROM SBSECURITIES SB,ISSUERS IR WHERE IR.ISSUERID =SB.issuerid
union all
SELECT ''ALL'' CDVAL ,''ALL'' CDCONTENT, 0 LSTODR FROM dual
)ORDER BY LSTODR', NULL, NULL, 'Y', 'N', 'Y', NULL, NULL, 'Y', 'C', NULL, NULL, NULL, NULL, NULL, NULL, 'SBSECURITIES_BOND', 'BA', NULL, NULL, NULL, NULL, 'Y', NULL, 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('BA', 'PV_CUSTODYCD', 'BA6020', 'PV_CUSTODYCD', 'Số TK lưu ký', 'Trading account', 1, 'M', 'cccc.cccccc', '_', 10, NULL, NULL, 'ALL', 'Y', 'N', 'Y', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, NULL, NULL, 'CUSTODYCD_TCPH', 'BA', NULL, NULL, NULL, NULL, 'Y', 'T', 'N');COMMIT;