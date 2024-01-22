SET DEFINE OFF;DELETE FROM RPTFIELDS WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('CA0003','NULL');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('CA', 'CACODE', 'CA0003', 'CACODE', 'Mã CA', 'CA Code', 5, 'M', 'cccccccccccccccccccccc', '_', 20, 'SELECT SYM.SYMBOL,CAMAST.CAMASTID VALUE,CAMAST.AUTOID,SUBSTR(CAMAST.CAMASTID,1,4)||''.''||SUBSTR(CAMAST.CAMASTID,5,6)||''.''||SUBSTR(CAMAST.CAMASTID,11,6) CAMASTID,
CAMAST.CODEID, CAMAST.EXCODEID, A1.CDVAL TYPEID, A1.CDCONTENT CATYPE, REPORTDATE, DUEDATE, ACTIONDATE, EXPRICE, EXRATE, RIGHTOFFRATE, DEVIDENTRATE,OPTCODEID,
 DEVIDENTSHARES, SPLITRATE, INTERESTRATE, DESCRIPTION, INTERESTPERIOD, A2.CDCONTENT STATUS,
(CASE WHEN EXRATE IS NOT NULL THEN EXRATE ELSE (CASE WHEN RIGHTOFFRATE IS NOT NULL
       THEN RIGHTOFFRATE ELSE (CASE WHEN DEVIDENTRATE IS NOT NULL THEN DEVIDENTRATE  ELSE
       (CASE WHEN SPLITRATE IS NOT NULL THEN SPLITRATE ELSE (CASE WHEN INTERESTRATE IS NOT NULL
       THEN INTERESTRATE ELSE
       (CASE WHEN DEVIDENTSHARES IS NOT NULL THEN DEVIDENTSHARES ELSE ''0'' END)END)END)END) END)END) RATE
 FROM CAMAST, SBSECURITIES SYM, ALLCODE A1, ALLCODE A2 WHERE CAMAST.CODEID=SYM.CODEID AND A1.CDTYPE = ''CA''
 AND A1.CDNAME = ''CATYPE'' AND A1.CDVAL=CATYPE AND A2.CDTYPE = ''CA'' AN', '', '', 'Y', 'N', 'Y', '', '', 'N', 'C', '', '', '', '', '', '', 'CAMAST_STATUS_ALL', 'CA', '', '', '', '', 'Y', 'T', 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('CA', 'P_CUSTODYCD', 'CA0003', 'P_CUSTODYCD', 'Số TK lưu ký', 'Trading account', 6, 'M', 'cccc.cccccc', '_', 10, '', '', '', 'Y', 'N', 'Y', '', '', 'N', 'C', '', '', '', '', '', '', 'CUSTODYCD_TX', 'CF', '', '', '', '', 'Y', 'T', 'N');COMMIT;