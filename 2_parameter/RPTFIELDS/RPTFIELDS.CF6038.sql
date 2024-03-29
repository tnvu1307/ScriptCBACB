SET DEFINE OFF;DELETE FROM RPTFIELDS WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('CF6038','NULL');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('CF', 'P_CUSTODYCD', 'CF6038', 'P_CUSTODYCD', 'Số TK lưu ký', 'Trading account', 0, 'M', 'cccc.cccccc', '_', 10, NULL, NULL, NULL, 'Y', 'N', 'Y', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, NULL, NULL, 'CUSTODYCD_TX', 'CF', NULL, NULL, NULL, NULL, 'Y', 'T', 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('CF', 'PV_SYMBOL', 'CF6038', 'PV_SYMBOL', 'Mã trái phiếu', 'Bond code', 1, 'M', 'cccccccccccccccccccc', '_', 20, 'SELECT SYMBOL VALUE, SYMBOL VALUECD, fullname DISPLAY, SYMBOL EN_DISPLAY, SYMBOL DESCRIPTION
FROM (SELECT to_char(SYMBOL)SYMBOL , to_char(IR.fullname) fullname ,1 LSTODR 
FROM SBSECURITIES SB,ISSUERS IR WHERE IR.ISSUERID =SB.issuerid
union all 
SELECT ''ALL'' CDVAL ,''ALL'' CDCONTENT, 0 LSTODR FROM dual    
)ORDER BY LSTODR', NULL, NULL, 'Y', 'N', 'Y', NULL, NULL, 'Y', 'C', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Y', NULL, 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('CF', 'P_AUTH', 'CF6038', 'P_AUTH', 'Người được ủy quyền', 'Authorized person', 2, 'T', 'ccc', '_', 30, NULL, NULL, '001', 'Y', 'N', 'Y', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'P_CUSTODYCD', 'select ''------'' FILTERCD, ''------''  VALUE, ''------''  VALUECD, ''------'' DISPLAY,
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
WHERE  b.CUSTODYCD = ''<$TAGFIELD>''', NULL, 'Y', 'C', 'N');COMMIT;