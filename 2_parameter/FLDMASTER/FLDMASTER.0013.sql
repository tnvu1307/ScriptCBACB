SET DEFINE OFF;DELETE FROM FLDMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('0013','NULL');Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('CF', '01', '0013', 'USERID', 'Mã người sử dụng', 'User ID', 0, 'C', NULL, NULL, 10, ' ', ' ', '<$TLID>', 'Y', 'Y', 'Y', ' ', ' ', 'N', 'C', NULL, NULL, NULL, NULL, '##########', NULL, NULL, NULL, NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 10, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('CF', '03', '0013', 'ACCTNO', 'Số Tiểu khoản', 'Acctno', 0, 'C', '9999.999999', '9999.999999', 10, ' ', ' ', ' ', 'Y', 'N', 'Y', ' ', ' ', 'N', 'C', NULL, NULL, NULL, 'AFACCTNO', '##########', NULL, 'AFMAST_ALL', 'CF', NULL, 'M', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 10, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('CF', '10', '0013', 'ACCLIMIT', 'Hạn mức được cấp', 'Allocating limit', 1, 'N', '#,##0', '#,##0', 19, ' ', ' ', ' ', 'Y', 'N', 'N', ' ', ' ', 'N', 'N', NULL, NULL, NULL, NULL, '##########', NULL, NULL, NULL, NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', '0', 'N', NULL, NULL, NULL, 'N', 19, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('CF', '11', '0013', 'MRCRLIMITMAX', 'Hạn mức đã được cấp', 'Allocated limit', 2, 'N', '#,##0', '#,##0', 19, ' ', ' ', ' ', 'Y', 'Y', 'N', ' ', ' ', 'N', 'N', NULL, NULL, NULL, NULL, '##########', '03MRCRLIMITMAX', NULL, NULL, NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', '0', 'N', NULL, NULL, NULL, 'N', 19, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('CF', '30', '0013', 'DESC', 'Mô tả', 'Description', 4, 'C', ' ', ' ', 250, ' ', ' ', ' ', 'Y', 'N', 'N', ' ', ' ', 'N', 'C', NULL, NULL, NULL, NULL, '##########', NULL, NULL, NULL, NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 250, 1);COMMIT;