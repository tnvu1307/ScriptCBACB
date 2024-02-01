SET DEFINE OFF;DELETE FROM RPTFIELDS WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('CF6027','NULL');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('CF', 'P_CUSTODYCD', 'CF6027', 'P_CUSTODYCD', 'Số TK luu ký', 'Trading account', 1, 'M', 'cccc.cccccc', '_', 10, NULL, NULL, NULL, 'Y', 'N', 'Y', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, NULL, NULL, 'CUSTODYCD_TX', 'CF', NULL, NULL, NULL, NULL, 'Y', 'T', 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('CF', 'P_CONTRACT', 'CF6027', 'P_CONTRACT', 'Số hợp đồng', 'Contract Number', 2, 'M', 'cccccccccccccccccccccccccccccc', '_', 30, NULL, NULL, NULL, 'Y', 'N', 'Y', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, NULL, NULL, 'CRPHYSAGREE_NOS', 'CF', NULL, 'P_CUSTODYCD', NULL, NULL, 'Y', 'T', 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('CF', 'P_CFAUTH', 'CF6027', 'P_CFAUTH', 'Người được ủy quyền', 'Authorized person', 3, 'T', 'ccc', '_', 30, NULL, NULL, '001', 'Y', 'N', 'Y', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'P_CUSTODYCD', 'select ''------'' FILTERCD, ''------''  VALUE, ''------''  VALUECD, ''------'' DISPLAY,
''------'' EN_DISPLAY from dual
union all
select CUSTID FILTERCD, CUSTID VALUE, CUSTID VALUECD, fullname DISPLAY,
fullname EN_DISPLAY  FROM (
        SELECT CF.CUSTID FILTERCD, CF.CUSTODYCD ,
               NVL(AU.CUSTID, AU.LICENSENO) CUSTID, AU.FULLNAME
        FROM CFAUTH AU, CFMAST CF, AFMAST AF, SYSVAR SYS
        WHERE CF.CUSTID = AU.CFCUSTID
              AND AF.CUSTID = CF.CUSTID
              AND SYS.VARNAME = ''CURRDATE''
              AND TO_DATE(VARVALUE,''DD/MM/RRRR'') BETWEEN AU.valdate AND AU.expdate
 )b
WHERE  b.CUSTODYCD = ''<$TAGFIELD>''', NULL, 'Y', 'C', 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('CF', 'P_SIGNTYPE', 'CF6027', 'P_SIGNTYPE', 'Người ký', 'Signature', 4, 'T', 'ccc', '-', 30, 'SELECT CDVAL VALUE, CDVAL VALUECD, CDCONTENT DISPLAY, CDCONTENT EN_DISPLAY, CDCONTENT DESCRIPTION
FROM ALLCODE WHERE CDTYPE = ''CF'' AND CDNAME = ''POSOFSIGN'' ORDER BY LSTODR', NULL, '001', 'Y', 'N', 'Y', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Y', 'C', 'N');COMMIT;