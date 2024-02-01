SET DEFINE OFF;DELETE FROM FLDMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('2800','NULL');Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('FN', '03', '2800', 'ACCTNO', 'Tài khoản ủy thác', 'Trust unit account', 0, 'C', '9999.999999.999999', '9999.999999.999999', 20, ' ', ' ', ' ', 'Y', 'N', 'Y', ' ', ' ', 'N', 'C', NULL, NULL, NULL, 'ACCTNO', '##########', NULL, 'FNMAST', 'CF', NULL, 'M', 'N', 'MAIN', NULL, NULL, NULL, 'N', 'P_ACCTNO', 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 20, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('FN', '06', '2800', 'REFAFACCTNO', 'Tiểu khoản thanh toán', 'Customer sub-account', 1, 'C', '9999.999999', '9999.999999', 10, NULL, ' ', ' ', 'Y', 'N', 'Y', ' ', ' ', 'Y', 'C', NULL, NULL, NULL, 'AFACCTNO', '##########', '03REFAFACCTNO', 'AFMAST', 'CF', NULL, 'M', 'N', 'MAIN', NULL, NULL, NULL, 'N', 'P_AFACCTNO', 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 10, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('FN', '10', '2800', 'AMT', 'Giá trị', 'Amount', 4, 'N', NULL, '#,##0', 20, NULL, NULL, '0', 'Y', 'N', 'Y', ' ', ' ', 'N', 'N', NULL, NULL, NULL, NULL, '##########', NULL, NULL, NULL, NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', 'P_AMT', 'Y', '0', 'N', NULL, NULL, NULL, 'N', 20, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('FN', '11', '2800', 'AVLBAL', 'Số dư', 'Balance', 3, 'N', NULL, '#,##0', 20, NULL, NULL, '0', 'Y', 'Y', 'Y', ' ', ' ', 'N', 'N', NULL, NULL, NULL, NULL, '##########', '03AVLBAL', NULL, NULL, NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', 'P_AMT', 'Y', '0', 'N', NULL, NULL, NULL, 'N', 20, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('FN', '30', '2800', 'DESC', 'Diễn giải', 'Description', 10, 'C', NULL, NULL, 50, ' ', ' ', ' ', 'Y', 'N', 'Y', ' ', ' ', 'N', 'C', NULL, NULL, NULL, NULL, '##########', NULL, NULL, 'CF', NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', 'P_DESC', 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 50, 1);COMMIT;