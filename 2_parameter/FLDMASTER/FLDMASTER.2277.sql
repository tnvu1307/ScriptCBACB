SET DEFINE OFF;DELETE FROM FLDMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('2277','NULL');Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('SE', '03', '2277', 'CODEID', 'Mã chứng khoán', 'Symbol', -1, 'C', '999999', '999999', 6, 'SELECT  SEC.CODEID VALUECD, SEC.CODEID VALUE, SEC.SYMBOL DISPLAY, SEC.SYMBOL EN_DISPLAY, SEC.SYMBOL DESCRIPTION, SEC.PARVALUE, SEINFO.BASICPRICE PRICE FROM SBSECURITIES SEC, SECURITIES_INFO SEINFO WHERE SEC.CODEID=SEINFO.CODEID ORDER BY SEC.SYMBOL', ' ', ' ', 'Y', 'Y', 'Y', ' ', ' ', 'Y', 'C', '', '', '', 'CODEID', '##########', '', 'SE2277', 'SE', '', 'C', 'N', 'MAIN', '', '', '', 'N', '', 'Y', '', 'N', '', '', '', 'N', 6, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('SE', '04', '2277', 'ISSUERID', 'Mã tổ chức phát hành', 'Issuer ID', 0, 'C', ' ', ' ', 20, ' ', ' ', ' ', 'Y', 'Y', 'N', ' ', ' ', 'N', 'C', '', '', '', '', '##########', '', '', '', '', 'T', 'N', 'MAIN', '', '', '', 'N', '', 'Y', '', 'N', '', '', '', 'N', 20, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('SE', '05', '2277', 'FULLNAME', 'Tên tổ chức phát hành', 'Issuer name', 1, 'C', ' ', ' ', 250, ' ', ' ', ' ', 'Y', 'Y', 'N', ' ', ' ', 'N', 'C', '', '', '', '', '##########', '', '', '', '', 'T', 'N', 'MAIN', '88', '', 'SELECT FULLNAME VALUECD, FULLNAME VALUE ,FULLNAME DISPLAY, FULLNAME EN_DISPLAY  FROM ONUSERINFO WHERE AUTOID = ''<$TAGFIELD>''', 'N', '', 'Y', '', 'N', '', '', '', 'N', 250, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('SE', '09', '2277', 'PRICE', 'Giá', 'Price', 24, 'N', '#,##0', '#,##0', 11, ' ', ' ', ' ', 'Y', 'N', 'Y', ' ', ' ', 'N', 'N', '', '', '', 'PRICE', '##########', '', '', '', '', 'T', 'N', 'MAIN', '', '', '', 'N', '', 'Y', '0', 'N', '', '', '', 'N', 11, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('SE', '11', '2277', 'PARVALUE', 'Mệnh giá', 'Par value', 23, 'N', '#,##0', '#,##0', 9, ' ', ' ', ' ', 'Y', 'Y', 'Y', ' ', ' ', 'N', 'N', '', '', '', 'PARVALUE', '##########', '', '', '', '', 'T', 'N', 'MAIN', '', '', '', 'N', '', 'Y', '0', 'N', '', '', '', 'N', 9, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('SE', '30', '2277', 'DESC', 'Mô tả', 'Description', 35, 'C', ' ', ' ', 250, ' ', ' ', ' ', 'Y', 'N', 'N', ' ', ' ', 'N', 'C', '', '', '', '', '##########', '', '', '', '', 'T', 'N', 'MAIN', '', '', '', 'N', '', 'Y', '', 'N', '', '', '', 'N', 250, 1);COMMIT;