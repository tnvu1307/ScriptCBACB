SET DEFINE OFF;DELETE FROM FLDMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('6649','NULL');Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('RM', '02', '6649', 'CATXNUM', 'Mã GD gốc', 'Original tran. ID', 12, 'C', NULL, NULL, 50, NULL, NULL, NULL, 'N', 'Y', 'N', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, '##########', NULL, NULL, NULL, NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 50, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('RM', '03', '6649', 'SECACCOUNT', 'Số tiểu khoản', 'Sub account', 2, 'C', '9999.999999', '9999.999999', 16, ' ', ' ', ' ', 'Y', 'Y', 'Y', ' ', ' ', 'N', 'C', NULL, NULL, NULL, 'ACCTNO', '##########', NULL, 'AFMAST_ALL', 'CF', NULL, 'C', 'N', 'MAIN', '88', NULL, 'SELECT FILTERCD, VALUE, VALUECD, DISPLAY, EN_DISPLAY, DESCRIPTION FROM VW_CUSTODYCD_SUBACCOUNT_ACTIVE WHERE FILTERCD=''<$TAGFIELD>'' ORDER BY VALUE', 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 16, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('RM', '04', '6649', 'DDACCTNO', 'Tài khoản tiền tệ', 'Currency', 2, 'C', '9999.999999', '9999.999999', 17, ' ', ' ', ' ', 'Y', 'N', 'Y', ' ', ' ', 'N', 'C', NULL, NULL, NULL, 'DDACCTNO', '##########', NULL, 'DDMAST_ALL', 'DD', NULL, 'C', 'N', 'MAIN', '03', NULL, 'SELECT FILTERCD, VALUE, VALUECD, DISPLAY, EN_DISPLAY, DESCRIPTION FROM VW_AFMAST_DDACCOUNT_ACTIVE WHERE FILTERCD=substr(''<$TAGFIELD>'',1,10) ORDER BY FILTERCD', 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 17, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('RM', '05', '6649', 'DESACCTNO', 'Tài khoản đích', 'Destination account', 7, 'C', NULL, NULL, 33, ' ', ' ', ' ', 'Y', 'Y', 'Y', ' ', ' ', 'N', 'C', NULL, NULL, NULL, NULL, '##########', NULL, 'V_CRBTRFACCTSRC', 'SA', NULL, 'T', 'N', 'MAIN', '03', NULL, 'SELECT SRC.BANKACCTNO ||'':''||SRC.BANKACCTNAME FILTERCD,SRC.BANKACCTNO VALUE,
SRC.BANKACCTNO VALUECD,SRC.BANKACCTNO ||'':''||SRC.BANKACCTNAME DISPLAY,
SRC.BANKACCTNO ||'':''||SRC.BANKACCTNAME EN_DISPLAY,SRC.BANKACCTNO ||'':''||SRC.BANKACCTNAME DESCRIPTION
FROM CRBTRFACCTSRC SRC,AFMAST AF
WHERE SRC.BANKCODE=AF.BANKNAME AND AF.ACCTNO=''<$TAGFIELD>''', 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 33, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('RM', '06', '6649', 'TRFTYPE', 'Loại chuyển khoản', 'Transfer type', 0, 'C', NULL, NULL, 10, ' ', ' ', ' TRFCICAMT', 'Y', 'Y', 'Y', ' ', ' ', 'N', 'C', NULL, NULL, NULL, NULL, '##########', NULL, NULL, NULL, NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 10, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('RM', '07', '6649', 'DESACCTNAME', 'Tên tài khoản đích', 'Destination Name', 8, 'C', NULL, NULL, 50, NULL, NULL, 'Công ty cổ phần CK Bảo Việt', 'Y', 'Y', 'Y', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, '##########', '05BANKACCTNAME', NULL, NULL, NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 50, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('RM', '10', '6649', 'AMOUNT', 'Số tiền chuyển', 'Transfer amount', 11, 'N', '###g###g###g###', '###g###g###g###', 19, ' ', ' ', ' ', 'Y', 'N', 'Y', ' ', ' ', 'N', 'N', NULL, NULL, NULL, NULL, '##########', NULL, NULL, NULL, NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', '0', 'N', NULL, NULL, NULL, 'N', 19, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('RM', '30', '6649', 'DESCRIPTION', 'Mô tả', 'Description', 13, 'C', ' ', ' ', 250, ' ', ' ', 'Giao dịch cắt tiền khách hàng', 'Y', 'N', 'N', ' ', ' ', 'N', 'C', NULL, NULL, NULL, NULL, '##########', NULL, NULL, NULL, NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 250, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('RM', '88', '6649', 'CUSTODYCD', 'Số TK lưu ký', 'Trading account', 1, 'C', NULL, NULL, 10, ' ', ' ', ' ', 'Y', 'Y', 'Y', ' ', ' ', 'N', 'C', NULL, NULL, NULL, 'CUSTODYCD', '##########', NULL, 'CUSTODYCD_CF', 'CF', NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', 'P_CUSTODYCD', 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 10, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('RM', '90', '6649', 'CUSTNAME', 'Họ và tên', 'Full name', 3, 'C', ' ', ' ', 50, ' ', ' ', ' ', 'Y', 'N', 'N', ' ', ' ', 'N', 'C', NULL, NULL, NULL, ' ', '03CUSTNAME', '03FULLNAME', NULL, NULL, NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 50, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('RM', '91', '6649', 'ADDRESS', 'Ðịa chỉ', 'Address', 4, 'C', ' ', ' ', 50, ' ', ' ', ' ', 'Y', 'N', 'N', ' ', ' ', 'N', 'C', NULL, NULL, NULL, ' ', '03ADDRESS#', '03ADDRESS', NULL, NULL, NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 50, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('RM', '92', '6649', 'LICENSE', 'CMND/Chứng nhận', 'ID code/Certificate', 5, 'C', ' ', ' ', 50, ' ', ' ', ' ', 'Y', 'N', 'N', ' ', ' ', 'N', 'C', NULL, NULL, NULL, ' ', '03LICENSE#', '03LICENSE', NULL, NULL, NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 50, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('RM', '93', '6649', 'BANKACCTNO', 'Tài khoản NH', 'Bank account', 6, 'C', ' ', ' ', 50, ' ', ' ', ' ', 'Y', 'Y', 'Y', ' ', ' ', 'N', 'C', NULL, NULL, NULL, ' ', '03BANKAC#', '03BANKACCTNO', NULL, NULL, NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 50, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('RM', '94', '6649', 'BANKNAME', 'Tên ngân hàng', 'Bank Name', 9, 'C', ' ', ' ', 50, ' ', ' ', ' ', 'Y', 'Y', 'Y', ' ', ' ', 'N', 'C', NULL, NULL, NULL, ' ', '##########', '03BANKNAME', NULL, NULL, NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 50, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('RM', '95', '6649', 'BANKQUE', 'Mã ngân hàng', 'Bank code', 10, 'C', ' ', ' ', 50, ' ', ' ', ' ', 'Y', 'Y', 'Y', ' ', ' ', 'N', 'C', NULL, NULL, NULL, ' ', '##########', '03BANKNAME', NULL, NULL, NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 50, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('RM', '98', '6649', 'REFCASAACCT', 'Số TK tại ngân hàng', 'Bank acctno', 2.1, 'C', ' ', ' ', 25, ' ', ' ', ' ', 'Y', 'Y', 'N', ' ', ' ', 'N', 'C', NULL, NULL, NULL, ' ', '04REFCASAACCT', '04REFCASAACCT', NULL, NULL, NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 25, 1);COMMIT;