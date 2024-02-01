SET DEFINE OFF;DELETE FROM FLDMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('1711','NULL');Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('MT', '03', '1711', 'CAMASTID', 'Mã sự kiện', 'CA Code', 2, 'C', '9999.999999.999999', '9999.999999.999999', 19, ' ', ' ', ' ', 'Y', 'N', 'N', ' ', ' ', 'N', 'C', NULL, NULL, NULL, NULL, '##########', NULL, 'CAMAST', 'CA', NULL, 'M', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 19, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('MT', '04', '1711', 'REFNUM', 'Mã tham chiếu', 'Related Reference', 4, 'C', NULL, NULL, 19, ' ', ' ', ' ', 'Y', 'N', 'N', ' ', ' ', 'N', 'C', NULL, NULL, NULL, NULL, '##########', NULL, 'SHVTXREQ', 'CA', NULL, 'M', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 19, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('MT', '06', '1711', 'MTTYPE', 'Mã điện', 'MT type', 0, 'C', NULL, NULL, 150, 'SELECT  vsdmt VALUECD, vsdmt VALUE, trfcode DISPLAY, trfcode EN_DISPLAY
FROM vsdtrfcode WHERE (vsdmt = ''599'' or vsdmt = ''568'') and tltxcd =''1711''
ORDER BY vsdmt', ' ', ' ', 'Y', 'N', 'Y', ' ', ' ', 'Y', 'C', NULL, NULL, NULL, NULL, '##########', NULL, NULL, NULL, NULL, 'C', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 19, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('MT', '30', '1711', 'DESC', 'Nội dung thông báo', 'Message content', 5, 'C', ' ', ' ', 1750, ' ', ' ', ' ', 'Y', 'N', 'N', ' ', ' ', 'N', 'C', NULL, NULL, NULL, NULL, '##########', NULL, NULL, NULL, NULL, 'R', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 100, 10);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('MT', '31', '1711', 'DESC_CV', 'Nội dung thông báo convert', 'Convert message content', 6, 'C', ' ', ' ', 1800, ' ', ' ', ' ', 'Y', 'N', 'N', ' ', ' ', 'N', 'C', NULL, NULL, NULL, NULL, '##########', NULL, NULL, NULL, NULL, 'R', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 100, 20);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('MT', '88', '1711', 'PCUSTODYCD', 'Số TK lưu ký', 'Trading account', 1, 'M', NULL, NULL, 10, ' ', ' ', 'ALL', 'Y', 'N', 'Y', ' ', ' ', 'N', 'C', NULL, NULL, NULL, NULL, '##########', NULL, 'CUSTODYCD_CF', 'CF', NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 10, 1);COMMIT;