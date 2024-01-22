SET DEFINE OFF;DELETE FROM RPTFIELDS WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('CA0024','NULL');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('CA', 'CACODE', 'CA0024', 'CACODE', 'Mã sự kiện CA', 'CA Code', 1, 'M', 'cccc.cccccc.cccccc', '_', 20, '', '', '', 'Y', 'N', 'Y', '', '', 'N', 'C', '', '', '', '', '', '', 'CAMAST_STATUS_ALL', 'CA', '', '', '', '', 'Y', 'T', 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('CA', 'I_BRIDGD', 'CA0024', 'I_BRIDGD', 'Chi nhánh', 'Branch', 2, 'M', 'cccccccccc', '_', 10, 'SELECT   brid VALUE,
 brid display, brname en_display, brname description FROM (SELECT brid, brname,
  1 lstodr FROM brgrp UNION SELECT ''ALL'' brid, ''ALL'' brname, -1 lstodr FROM DUAL) ORDER BY lstodr', '', 'ALL', 'Y', 'N', 'Y', '', '', 'Y', 'C', '', '', '', '', '', '', '', '', '', '', '', '', 'Y', 'T', 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('CA', 'ISCOREBANK', 'CA0024', 'ISCOREBANK', 'Tài khoản', 'Account', 3, 'M', '', '_', 10, '
SELECT ''ALL'' VALUECD, ''ALL'' VALUE, ''Tất cả'' DISPLAY, ''ALL'' EN_DISPLAY FROM DUAL
UNION ALL
SELECT ''Y'' VALUECD, ''Y'' VALUE, ''Corebank'' DISPLAY, ''Corebank'' EN_DISPLAY FROM DUAL
UNION ALL
SELECT ''N'' VALUECD, ''N'' VALUE, ''Tại PHS'' DISPLAY, ''In company'' EN_DISPLAY FROM DUAL
', '', 'ALL', 'Y', 'N', 'Y', '', '', 'N', 'C', '', '', '', '', '', '', '', '', '', '', '', '', 'Y', 'C', 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('CA', 'CASHPLACE', 'CA0024', 'CASHPLACE', 'Ngân hàng', 'Bank', 4, 'M', 'cccccccccc', '_', 10, '
SELECT CDVAL VALUE,CDVAL VALUECD, CDCONTENT DISPLAY, CDCONTENT EN_DISPLAY, CDCONTENT DESCRIPTION
FROM (SELECT CDVAL, CDCONTENT, LSTODR FROM ALLCODE WHERE CDTYPE = ''CF'' AND CDNAME = ''BANKNAME''
      UNION SELECT ''ALL'' CDVAL, ''Tất cả'' CDCONTENT, -1 LSTODR FROM DUAL
      ) ORDER BY LSTODR', '', 'ALL', 'Y', 'N', 'Y', '', '', 'Y', 'C', '', '', '', '', '', '', '', '', '', '', '', '', 'Y', '', 'N');COMMIT;