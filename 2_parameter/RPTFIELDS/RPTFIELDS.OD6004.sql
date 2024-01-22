SET DEFINE OFF;DELETE FROM RPTFIELDS WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('OD6004','NULL');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('OD', 'F_DATE_PREVIOUS', 'OD6004', 'F_DATE_PREVIOUS', 'Từ ngày kì báo cáo trước', 'From previous date', 0, 'M', '99/99/9999', 'dd/MM/yyyy', 10, 'SELECT CDVAL VALUE, CDCONTENT DISPLAY, CDCONTENT EN_DISPLAY, CDCONTENT DISCRIPTION FROM (SELECT CDVAL, CDCONTENT, LSTODR FROM ALLCODE WHERE CDTYPE = ''SA'' AND CDNAME = ''TRADEPLACE'' UNION SELECT ''ALL'' CDVAL, ''<Not selected>'' CDCONTENT, -1 LSTODR FROM DUAL) ORDER BY LSTODR', '', '<$BUSDATE>', 'Y', 'N', 'Y', '', '', 'N', 'D', '', '', '', '', '', '', '', '', '', '', '', '', 'Y', 'T', 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('OD', 'T_DATE_PREVIOUS', 'OD6004', 'F_DATE_PREVIOUS', 'Đến ngày kì báo cáo trước', 'To previous date', 1, 'M', '99/99/9999', 'dd/MM/yyyy', 10, 'SELECT CDVAL VALUE, CDCONTENT DISPLAY, CDCONTENT EN_DISPLAY, CDCONTENT DISCRIPTION FROM (SELECT CDVAL, CDCONTENT, LSTODR FROM ALLCODE WHERE CDTYPE = ''SA'' AND CDNAME = ''TRADEPLACE'' UNION SELECT ''ALL'' CDVAL, ''<Not selected>'' CDCONTENT, -1 LSTODR FROM DUAL) ORDER BY LSTODR', '', '<$BUSDATE>', 'Y', 'N', 'Y', '', '', 'N', 'D', '', '', '', '', '', '', '', '', '', '', '', '', 'Y', 'T', 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('OD', 'F_DATE', 'OD6004', 'F_DATE', 'Từ ngày kì báo cáo này', 'From date', 2, 'M', '99/99/9999', 'dd/MM/yyyy', 10, 'SELECT CDVAL VALUE, CDCONTENT DISPLAY, CDCONTENT EN_DISPLAY, CDCONTENT DISCRIPTION FROM (SELECT CDVAL, CDCONTENT, LSTODR FROM ALLCODE WHERE CDTYPE = ''SA'' AND CDNAME = ''TRADEPLACE'' UNION SELECT ''ALL'' CDVAL, ''<Not selected>'' CDCONTENT, -1 LSTODR FROM DUAL) ORDER BY LSTODR', '', '<$BUSDATE>', 'Y', 'N', 'Y', '', '', 'N', 'D', '', '', '', '', '', '', '', '', '', '', '', '', 'Y', 'T', 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('OD', 'T_DATE', 'OD6004', 'T_DATE', 'Đến ngày kì báo cáo này', 'To date', 3, 'M', '99/99/9999', 'dd/MM/yyyy', 10, 'SELECT CDVAL VALUE, CDCONTENT DISPLAY, CDCONTENT EN_DISPLAY, CDCONTENT DISCRIPTION FROM (SELECT CDVAL, CDCONTENT, LSTODR FROM ALLCODE WHERE CDTYPE = ''SA'' AND CDNAME = ''TRADEPLACE'' UNION SELECT ''ALL'' CDVAL, ''<Not selected>'' CDCONTENT, -1 LSTODR FROM DUAL) ORDER BY LSTODR', '', '<$BUSDATE>', 'Y', 'N', 'Y', '', '', 'N', 'D', '', '', '', '', '', '', '', '', '', '', '', '', 'Y', 'T', 'N');COMMIT;