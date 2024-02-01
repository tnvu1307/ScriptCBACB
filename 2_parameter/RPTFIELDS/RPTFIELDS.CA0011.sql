SET DEFINE OFF;DELETE FROM RPTFIELDS WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('CA0011','NULL');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('CA', 'CACODE', 'CA0011', 'CACODE', 'Mã sự kiện', 'CA Code', 3, 'M', 'cccc.cccccc.cccccc', '_', 20, NULL, NULL, NULL, 'Y', 'N', 'Y', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, NULL, NULL, 'CAMAST_STATUS_ALL', 'CA', NULL, NULL, NULL, NULL, 'Y', 'T', 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('CA', 'P_NUMBER', 'CA0011', 'P_NUMBER', 'Số', 'Number', 4, 'M', 'cccc', '_', 20, NULL, NULL, '____', 'Y', 'N', 'Y', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'CA', NULL, NULL, NULL, NULL, 'Y', 'T', 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('CA', 'PLSENT', 'CA0011', 'PLSENT', 'Nơi gửi ', 'Send place', 5, 'M', NULL, '_', 70, '
SELECT ''001'' VALUECD, ''001'' VALUE, ''Trung tâm Lưu ký Chứng khoán Việt Nam'' DISPLAY, ''Vietnam Securities Depository Center'' EN_DISPLAY FROM DUAL
UNION ALL
SELECT ''002'' VALUECD, ''002'' VALUE, ''Chi nhánh Trung tâm Lưu ký Chứng khoán Việt Nam'' DISPLAY, ''Vietnam Securities Depository Center Branch'' EN_DISPLAY FROM DUAL', NULL, NULL, 'Y', 'N', 'Y', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Y', 'C', 'N');COMMIT;