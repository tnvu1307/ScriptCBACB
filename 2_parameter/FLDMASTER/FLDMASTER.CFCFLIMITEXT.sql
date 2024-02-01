SET DEFINE OFF;DELETE FROM FLDMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('CF.CFLIMITEXT','NULL');Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('CF', 'AUTOID', 'CF.CFLIMITEXT', 'AUTOID', 'Mã quản lý', 'Auto ID', 0, 'N', NULL, NULL, 10, NULL, NULL, NULL, 'N', 'N', 'N', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'M', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 10, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('CF', 'BANKID', 'CF.CFLIMITEXT', 'BANKID', 'Mã khách hàng Ngân Hàng', 'Customer - Bank ID', 1, 'C', '9999.999999', '9999.999999', 10, ' ', ' ', ' ', 'Y', 'N', 'Y', ' ', ' ', 'N', 'C', NULL, NULL, NULL, 'AUTOID', '##########', NULL, 'CFBANK', 'CF', NULL, 'M', 'Y', 'MAIN', NULL, NULL, NULL, 'N', 'P_AUTOID', 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 10, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('CF', 'CUSTID', 'CF.CFLIMITEXT', 'CUSTID', 'Mã khách hàng', 'Customer ID', 7, 'C', NULL, NULL, 10, ' ', ' ', ' ', 'Y', 'Y', 'Y', ' ', ' ', 'N', 'C', NULL, NULL, NULL, 'CUSTID', '##########', NULL, NULL, NULL, NULL, 'T', 'Y', 'MAIN', NULL, NULL, NULL, 'N', 'P_AUTOID', 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 10, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('CF', 'CUSTODYCD', 'CF.CFLIMITEXT', 'CUSTODYCD', 'Số TK lưu ký', 'Custodycd', 6, 'C', 'CCC.C.CCCCCC', 'CCC.C.CCCCCC', 10, NULL, NULL, NULL, 'Y', 'N', 'Y', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, '##########', NULL, 'CUSTODYCD_CF', 'CF', NULL, 'M', 'Y', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 10, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('CF', 'LMAMT', 'CF.CFLIMITEXT', 'LMAMT', 'Hạn mức', 'Limit', 2, 'N', '#,##0', '#,##0', 20, NULL, NULL, '0', 'Y', 'N', 'Y', NULL, NULL, 'N', 'N', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 20, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('CF', 'LMCHKTYP', 'CF.CFLIMITEXT', 'LMCHKTYP', 'Căn cứ số dư', 'Balance type', 5, 'C', NULL, NULL, 10, 'SELECT CDVAL VALUE, CDCONTENT DISPLAY, EN_CDCONTENT EN_DISPLAY  FROM ALLCODE WHERE CDTYPE = ''CF'' AND CDNAME =''LMCHKTYP''', NULL, 'C', 'Y', 'N', 'Y', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'C', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 10, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('CF', 'LMSUBTYPE', 'CF.CFLIMITEXT', 'LMSUBTYPE', 'Nghiệp vụ', 'Sub-type', 4, 'C', NULL, NULL, 10, 'SELECT CDVAL VALUE, CDCONTENT DISPLAY, EN_CDCONTENT EN_DISPLAY  FROM ALLCODE WHERE CDTYPE = ''CF'' AND CDNAME =''LMSUBTYPE'' AND CDUSER=''Y''', NULL, 'ALL', 'Y', 'N', 'Y', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'C', 'Y', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 10, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('CF', 'LMTYP', 'CF.CFLIMITEXT', 'LMTYP', 'Loại', 'Type', 3, 'C', NULL, NULL, 10, 'SELECT CDVAL VALUE, CDCONTENT DISPLAY, EN_CDCONTENT EN_DISPLAY  FROM ALLCODE WHERE CDTYPE = ''CF'' AND CDNAME =''LMTYP''', NULL, 'LN', 'Y', 'N', 'Y', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'C', 'Y', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 10, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('CF', 'STATUS', 'CF.CFLIMITEXT', 'STATUS', 'Trạng thái ', 'Status', 8, 'C', NULL, NULL, 10, 'SELECT CDVAL VALUE, CDCONTENT DISPLAY, en_cdcontent EN_DISPLAY FROM ALLCODE WHERE CDTYPE = ''SY'' AND CDNAME =''APPRV_STS''', NULL, 'P', 'Y', 'Y', 'Y', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'C', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 10, 1);COMMIT;