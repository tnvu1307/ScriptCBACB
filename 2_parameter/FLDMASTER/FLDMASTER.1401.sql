SET DEFINE OFF;DELETE FROM FLDMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('1401','NULL');Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('AP', '01', '1401', 'CODEID', 'Mã chứng khoán', 'Code id', 3, 'C', '999999', '999999', 500, NULL, ' ', ' ', 'Y', 'Y', 'Y', ' ', ' ', 'N', 'C', NULL, NULL, NULL, NULL, '##########', NULL, NULL, NULL, NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 15, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('AP', '02', '1401', 'BANKACCTNO', 'Số TK của TCPH', 'Beneficiary account', 6, 'C', NULL, NULL, 500, NULL, NULL, NULL, 'Y', 'Y', 'Y', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, '##########', NULL, NULL, NULL, NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 15, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('AP', '03', '1401', 'TYPE', 'Loại', 'Type', -1, 'C', NULL, NULL, 500, 'SELECT CDVAL VALUECD, CDVAL VALUE, CDCONTENT DISPLAY, EN_CDCONTENT EN_DISPLAY
FROM ALLCODE
WHERE CDNAME =''REFTYPE'' AND CDTYPE =''AP''', ' ', NULL, 'Y', 'Y', 'N', ' ', ' ', 'N', 'C', NULL, NULL, NULL, NULL, '##########', NULL, NULL, NULL, NULL, 'C', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 10, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('AP', '06', '1401', 'CITAD', 'Mã CITAD', 'CITAD code', 4, 'C', NULL, NULL, 500, NULL, ' ', NULL, 'Y', 'Y', 'N', ' ', ' ', 'N', 'C', NULL, NULL, NULL, NULL, '##########', NULL, NULL, NULL, NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 15, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('AP', '09', '1401', 'REMAMT', 'Số tiền theo mệnh giá physical', '(Remaining amount (at face value', 8, 'N', '#,##0.###0', '#,##0.###0', 500, NULL, NULL, '0', 'Y', 'Y', 'Y', NULL, NULL, 'N', 'N', NULL, NULL, NULL, NULL, '##########', NULL, NULL, NULL, NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', '4', 'N', NULL, NULL, NULL, 'N', 15, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('AP', '10', '1401', 'AMT', 'Số tiền (VND)', 'Amount (VND)', 11, 'N', '#,##0.###0', '#,##0.###0', 500, ' ', ' ', '0', 'Y', 'Y', 'Y', ' ', ' ', 'N', 'N', NULL, NULL, NULL, NULL, '##########', NULL, NULL, NULL, NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', '4', 'N', NULL, NULL, NULL, 'N', 15, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('AP', '12', '1401', 'FACEAMT', 'Số tiền TT theo mệnh giá physical', 'Amount at face value', 10, 'N', '#,##0.###0', '#,##0.###0', 500, NULL, NULL, '0', 'Y', 'Y', 'Y', NULL, NULL, 'N', 'N', NULL, NULL, NULL, NULL, '##########', NULL, NULL, NULL, NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', '4', 'N', NULL, NULL, NULL, 'N', 15, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('AP', '16', '1401', 'FEETYPE', 'Loại phí', 'Fee type', 11.5, 'C', NULL, NULL, 20, 'SELECT  CDVAL VALUECD, CDVAL VALUE, CDCONTENT DISPLAY, EN_CDCONTENT EN_DISPLAY FROM ALLCODE WHERE CDNAME=''IOROFEE'' AND CDTYPE=''SA'' ORDER BY LSTODR', NULL, '1', 'Y', 'N', 'Y', ' ', ' ', 'N', 'C', NULL, NULL, NULL, NULL, '##########', NULL, NULL, NULL, NULL, 'C', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 20, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('AP', '18', '1401', 'CUSTODYCD', 'Khách hàng', 'Trading account', 1, 'C', NULL, NULL, 500, ' ', ' ', ' ', 'Y', 'Y', 'Y', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, '##########', NULL, NULL, NULL, NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 15, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('AP', '19', '1401', 'TAX', 'Thuế', 'Tax', 7.1, 'N', '#,##0.###0', '#,##0.###0', 500, ' ', ' ', '0', 'Y', 'Y', 'Y', ' ', ' ', 'N', 'N', NULL, NULL, NULL, NULL, '##########', NULL, NULL, NULL, NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', '4', 'N', NULL, NULL, NULL, 'N', 15, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('AP', '30', '1401', 'DESC', 'Diễn giải', 'Description', 12, 'C', NULL, NULL, 500, ' ', ' ', ' ', 'Y', 'N', 'N', ' ', ' ', 'N', 'C', NULL, NULL, NULL, NULL, '##########', NULL, NULL, NULL, NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 50, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('AP', '32', '1401', 'BANKCODE', 'NH thụ hưởng', 'Bank name', 5, 'C', NULL, NULL, 500, NULL, NULL, NULL, 'Y', 'Y', 'Y', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, '##########', NULL, NULL, NULL, NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 25, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('AP', '33', '1401', 'SYMBOL', 'Mã chứng khoán', 'Physical', 2, 'C', NULL, NULL, 500, NULL, ' ', ' ', 'Y', 'Y', 'Y', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, '##########', NULL, NULL, NULL, NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 15, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('AP', '34', '1401', 'BNAME', 'Tên TK thụ hưởng', 'Beneficiary Name', 6.1, 'C', NULL, NULL, 1000, NULL, NULL, NULL, 'Y', 'Y', 'N', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, '##########', NULL, NULL, NULL, NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 35, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('AP', '35', '1401', 'CCYNAME', 'Loại tiền tệ', 'Currency', 9, 'C', NULL, NULL, 500, NULL, NULL, NULL, 'Y', 'Y', 'Y', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, '##########', NULL, NULL, NULL, NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 20, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('AP', '55', '1401', 'CLVALUE', 'Giá trị hợp đồng', 'Agreement value', 7, 'N', '#,##0.###0', '#,##0.###0', 500, ' ', ' ', '0', 'Y', 'Y', 'Y', ' ', ' ', 'N', 'N', NULL, NULL, NULL, NULL, '##########', NULL, NULL, NULL, NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', '4', 'N', NULL, NULL, NULL, 'N', 15, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('AP', '88', '1401', 'CRPHYSAGREEID', 'Mã hợp đồng/phụ lục', 'Agreement/Appendix ID', 0, 'C', NULL, NULL, 500, NULL, NULL, NULL, 'Y', 'Y', 'Y', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, '##########', NULL, NULL, NULL, NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 10, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('AP', '90', '1401', 'FULLNAME', 'Họ tên', 'Full name', 1, 'C', NULL, NULL, 500, ' ', ' ', ' ', 'Y', 'Y', 'Y', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, '##########', NULL, NULL, NULL, NULL, 'T', 'N', 'MAIN', '88', NULL, 'SELECT FULLNAME VALUECD, FULLNAME VALUE ,FULLNAME DISPLAY, FULLNAME EN_DISPLAY  FROM ONUSERINFO WHERE AUTOID = ''<$TAGFIELD>''', 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 25, 1);COMMIT;