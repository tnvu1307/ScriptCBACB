SET DEFINE OFF;DELETE FROM FLDMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('2256','NULL');Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('SE', '01', '2256', 'CODEID', 'Mã chứng khoán', 'Symbol', 0, 'C', '999999', '999999', 6, 'SELECT  SEC.CODEID VALUECD, SEC.CODEID VALUE, SEC.SYMBOL DISPLAY, SEC.SYMBOL EN_DISPLAY, SEC.SYMBOL DESCRIPTION, SEC.PARVALUE, SEINFO.BASICPRICE PRICE FROM SBSECURITIES SEC, SECURITIES_INFO SEINFO WHERE SEC.CODEID=SEINFO.CODEID ORDER BY SEC.CODEID', ' ', ' ', 'Y', 'Y', 'Y', ' ', ' ', 'Y', 'C', '', '', '', 'CODEID', '##########', '', '', '', '', 'C', 'N', 'MAIN', '', '', '', 'N', '', 'Y', '', 'N', '', '', '', 'N', 6, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('SE', '02', '2256', 'AFACCTNO', 'Số Tiểu khoản', 'Contract number', 1, 'C', '9999.999999', '9999.999999', 10, ' ', ' ', ' ', 'Y', 'Y', 'Y', ' ', ' ', 'N', 'C', '', '', '', 'AFACCTNO', '##########', '', 'AFMAST_ALL', 'CF', '', 'M', 'N', 'MAIN', '', '', '', 'N', '', 'Y', '', 'N', '', '', '', 'N', 10, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('SE', '03', '2256', 'ACCTNO', 'Số tài khoản', 'Account number', 2, 'C', '9999.999999.999999', '9999.999999.999999', 16, ' ', ' ', ' ', 'Y', 'Y', 'Y', ' ', ' ', 'N', 'C', '', '', '', 'ACCTNO', '##########', '', '', '', '', 'M', 'N', 'MAIN', '', '', '', 'N', '', 'Y', '', 'N', '', '', '', 'N', 16, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('SE', '05', '2256', 'AUTOID', 'Số tự tăng', 'Auto ID', -1, 'N', '999g999g999', '999g999g999', 30, ' ', ' ', ' ', 'Y', 'Y', 'Y', ' ', ' ', 'N', 'N', '', '', '', '', '##########', '', '', '', '', 'T', 'N', 'MAIN', '', '', '', 'N', '', 'Y', '0', 'N', '', '', '', 'N', 30, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('SE', '07', '2256', 'PDATE', 'Posted date', 'Posted date', 13, 'C', '99/99/9999', '99/99/9999', 10, ' ', ' ', ' ', 'Y', 'Y', 'N', ' ', ' ', 'N', 'D', '', '', '', 'PDATE', '##########', '03PDATE', '', '', '', 'M', 'N', 'MAIN', '', '', '', 'N', '', 'Y', '', 'N', '', '', '', 'N', 10, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('SE', '09', '2256', 'PRICE', 'Giá vốn', 'Cost price', 11, 'N', '999g999g999', '999g999g999', 11, ' ', ' ', ' ', 'Y', 'Y', 'Y', ' ', ' ', 'N', 'N', '', '', '', 'PRICE', '##########', '01PRICE', '', '', '', 'T', 'N', 'MAIN', '', '', '', 'N', '', 'Y', '0', 'N', '', '', '', 'N', 11, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('SE', '11', '2256', 'PARVALUE', 'Mệnh giá', 'Par value', 10, 'N', '999g999g999', '999g999g999', 9, ' ', ' ', ' ', 'Y', 'Y', 'Y', ' ', ' ', 'N', 'N', '', '', '', 'PARVALUE', '##########', '01PARVALUE', '', '', '', 'T', 'N', 'MAIN', '', '', '', 'N', '', 'Y', '0', 'N', '', '', '', 'N', 9, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('SE', '13', '2256', 'RDATE', 'Ngày giao dịch trở lại', 'Trade date', 8, 'D', '99/99/9999', '99/99/9999', 10, ' ', ' ', '', 'Y', 'N', 'N', ' ', ' ', 'N', 'C', '', '', '', '', '##########', '', '', '', '', 'M', 'N', 'MAIN', '', '', '', 'N', '', 'Y', '', 'N', '', '', '', 'N', 10, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('SE', '14', '2256', 'WTRADE', 'Chờ giao dịch', 'Wait-for-trade', 8, 'N', '999g999g999', '999g999g999', 13, ' ', ' ', '0', 'Y', 'Y', 'N', ' ', ' ', 'N', 'N', '', '', '', '', '##########', '', '', '', '', 'T', 'N', 'MAIN', '', '', '', 'N', '', 'Y', '0', 'N', '', '', '', 'N', 13, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('SE', '30', '2256', 'DESC', 'Diễn giải', 'Description', 12, 'C', ' ', ' ', 250, ' ', ' ', ' ', 'Y', 'N', 'N', ' ', ' ', 'N', 'C', '', '', '', '', '##########', '', '', '', '', 'T', 'N', 'MAIN', '', '', '', 'N', '', 'Y', '', 'N', '', '', '', 'N', 250, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('SE', '88', '2256', 'CUSTODYCD', 'Số TK lưu ký', 'Trading account', 1, 'C', '', '', 10, ' ', ' ', ' ', 'Y', 'Y', 'Y', ' ', ' ', 'N', 'C', '', '', '', 'CUSTODYCD', '##########', '', 'CUSTODYCD_CF', 'CF', '', 'T', 'N', 'MAIN', '', '', '', 'N', '', 'Y', '', 'N', '', '', '', 'N', 10, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('SE', '90', '2256', 'CUSTNAME', 'Họ tên', 'Full name', 3, 'C', ' ', ' ', 50, ' ', ' ', ' ', 'Y', 'Y', 'N', ' ', ' ', 'N', 'C', '', '', '', ' ', '##########', '', '', '', '', 'T', 'N', 'MAIN', '', '', '', 'N', '', 'Y', '', 'N', '', '', '', 'N', 50, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('SE', '91', '2256', 'ADDRESS', 'Địa chỉ', 'Address', 4, 'C', ' ', ' ', 50, ' ', ' ', ' ', 'Y', 'Y', 'N', ' ', ' ', 'N', 'C', '', '', '', ' ', '##########', '', '', '', '', 'T', 'N', 'MAIN', '', '', '', 'N', '', 'Y', '', 'N', '', '', '', 'N', 50, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('SE', '92', '2256', 'LICENSE', 'CMND/GPKD', 'ID code/Bus. certificate', 5, 'C', ' ', ' ', 50, ' ', ' ', ' ', 'Y', 'Y', 'N', ' ', ' ', 'N', 'C', '', '', '', ' ', '##########', '', '', '', '', 'T', 'N', 'MAIN', '', '', '', 'N', '', 'Y', '', 'N', '', '', '', 'N', 50, 1);COMMIT;