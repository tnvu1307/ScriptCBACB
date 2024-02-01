SET DEFINE OFF;DELETE FROM RPTFIELDS WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('SE0042','NULL');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('SE', 'INMONTH', 'SE0042', 'INMONTH', 'Tháng', 'Month', 0, 'M', '99/9999', 'MM/yyyy', 7, NULL, NULL, NULL, 'Y', 'N', 'Y', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Y', NULL, 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('SE', 'PLSENT', 'SE0042', 'PLSENT', 'Nơi gửi', 'Send place', 6, 'M', NULL, '_', 50, '
SELECT ''Trung tâm Lưu ký Chứng Khoán Việt Nam'' VALUECD, ''Trung tâm Lưu ký Chứng Khoán Việt Nam'' VALUE, ''Trung tâm Lưu ký Chứng khoán Việt Nam'' DISPLAY, ''Vietnam Securities Depository Center'' EN_DISPLAY FROM DUAL
UNION ALL
SELECT ''Chi nhánh Trung tâm Lưu Ký Chứng Khoán Việt Nam'' VALUECD, ''Chi nhánh Trung tâm Lưu Ký Chứng Khoán Việt Nam'' VALUE, ''Chi nhánh Trung tâm Lưu ký Chứng khoán Việt Nam'' DISPLAY, ''Vietnam Securities Depository Center Branch'' EN_DISPLAY FROM DUAL
', NULL, NULL, 'Y', 'N', 'Y', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Y', 'C', 'N');COMMIT;