SET DEFINE OFF;DELETE FROM FLDMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('0023','NULL');Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('CF', '02', '0023', 'TEMPLATEID', 'Mã email', 'Email code', 2, 'T', 'cccc', 'cccc', 20, ' ', ' ', ' ', 'Y', 'N', 'Y', ' ', ' ', 'N', 'C', '', '', '', '', '##########', '', 'ADDTEMPLATES', 'SA', '', 'T', 'N', 'MAIN', 'CUSTID', '', '', 'N', 'P_TEMPLATE', 'Y', '', 'N', '', '', '', 'N', 20, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('CF', '30', '0023', 'DESC', 'Diễn giải', 'Description', 10, 'C', ' ', ' ', 250, ' ', ' ', ' ', 'Y', 'N', 'N', ' ', ' ', 'N', 'C', '', '', '', '', '##########', '', '', '', '', 'T', 'N', 'MAIN', '', '', '', 'N', '', 'Y', '', 'N', '', '', '', 'N', 250, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('CF', '88', '0023', 'CUSTODYCD', 'Số tài khoản lưu ký', 'Trading account', 1, 'T', '', '', 20, ' ', ' ', ' ', 'Y', 'N', 'Y', ' ', ' ', 'N', 'C', '', '', '', '', '##########', '', 'CUSTODYCD_TX', 'CF', '', 'T', 'N', 'MAIN', 'CUSTID', '', '', 'N', 'P_CUSTODYCD', 'Y', '', 'N', '', '', '', 'N', 20, 1);COMMIT;