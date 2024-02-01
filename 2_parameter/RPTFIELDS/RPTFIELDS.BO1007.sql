SET DEFINE OFF;DELETE FROM RPTFIELDS WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('BO1007','NULL');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('BO', 'PV_CUSTID', 'BO1007', 'PV_CUSTID', 'Số TK lưu ký', 'Trading account', 0, 'M', 'cccc.cccccc', '_', 10, NULL, NULL, NULL, 'Y', 'N', 'Y', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, NULL, NULL, 'CUSTODYCD_TX', 'CF', NULL, NULL, NULL, NULL, 'Y', 'T', 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('BO', 'PV_BONDID', 'BO1007', 'PV_BONDID', 'Mã đấu thầu', 'Bond ID', 5, 'M', 'cccccccccccccccc', '_', 20, NULL, NULL, NULL, 'Y', 'N', 'Y', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, NULL, NULL, 'BONDIPO', 'CA', NULL, NULL, NULL, NULL, 'Y', 'T', 'N');COMMIT;