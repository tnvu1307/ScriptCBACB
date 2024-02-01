SET DEFINE OFF;DELETE FROM RPTFIELDS WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('CS070','NULL');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('ST', 'MICODE', 'CS070', 'MICODE', 'TVLK', 'Member', 1, 'M', NULL, NULL, 50, 'SELECT DEPOSITID VALUE, DEPOSITID VALUECD, DEPOSITID || ''-'' || FULLNAME DISPLAY, DEPOSITID || ''-'' || FULLNAME EN_DISPLAY FROM DEPOSIT_MEMBER', NULL, '<$SQL>SELECT D.DEPOSITID DEFNAME
FROM DEPOSIT_MEMBER D
JOIN (SELECT * FROM VSDBICCODE WHERE BRID=''0001'') V  ON V.BICCODE = D.BICCODE', 'Y', 'Y', 'Y', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Y', 'C', 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('ST', 'PERIOD', 'CS070', 'PERIOD', 'Chu kì thanh toán', 'Period', 2, 'M', NULL, NULL, 10, 'SELECT ''1'' VALUE, ''1'' VALUECD,''1'' DISPLAY, ''1'' EN_DISPLAY FROM DUAL
UNION ALL
SELECT ''2'' VALUE, ''2'' VALUECD,''2'' DISPLAY, ''2'' EN_DISPLAY FROM DUAL
UNION ALL
SELECT ''3'' VALUE, ''3'' VALUECD,''3'' DISPLAY, ''3'' EN_DISPLAY FROM DUAL', NULL, '2', 'Y', 'N', 'Y', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Y', 'C', 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('ST', 'TRANDATE', 'CS070', 'TRANDATE', 'Ngày giao dịch', 'Transaction date', 3, 'D', '99/99/9999', 'DD/MM/YYYY', 10, NULL, NULL, '<$BUSDATE>', 'Y', 'N', 'Y', NULL, NULL, 'N', 'D', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Y', 'T', 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('ST', 'BRID', 'CS070', 'BRID', 'Sàn giao dịch', 'Trade place', 4, 'M', NULL, NULL, 10, 'SELECT CDVAL VALUE, CDVAL VALUECD, CDCONTENT DISPLAY, EN_CDCONTENT EN_DISPLAY FROM ALLCODE WHERE CDNAME = ''TRADEPLACE'' AND CDUSER = ''Y'' AND CDTYPE = ''ST''', NULL, NULL, 'Y', 'N', 'Y', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Y', 'C', 'N');COMMIT;