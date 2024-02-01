SET DEFINE OFF;DELETE FROM RPTFIELDS WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('CF6042','NULL');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('CF', 'P_CUSTODYCD', 'CF6042', 'P_CUSTODYCD', 'Số TK lưu ký', 'Trading account', 0, 'M', 'cccc.cccccc', '_', 10, NULL, NULL, NULL, 'Y', 'N', 'Y', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, NULL, NULL, 'CUSTODYCD_TX', 'CF', NULL, NULL, NULL, NULL, 'Y', 'T', 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('CF', 'P_BRKID', 'CF6042', 'P_BRKID', 'Short Name', 'Short Name', 2, 'T', 'cccccccccc', '_', 20, ' SELECT ''-----'' VALUE, ''-----''  VALUECD, ''''  DISPLAY, ''''  EN_DISPLAY, ''''  DESCRIPTION, ''''  EN_DESCRIPTION
 FROM DUAL
 UNION ALL
SELECT VALUE, VALUE VALUECD, VALUE DISPLAY, VALUE EN_DISPLAY, FULLNAME DESCRIPTION, FULLNAME EN_DESCRIPTION
 FROM (
        SELECT DISTINCT MST.SHORTNAME VALUE, MST.FULLNAME
        FROM FAMEMBERS MST, FABROKERAGE BRK
        WHERE MST.AUTOID = BRK.BRKID
        AND MST.ROLES=''BRK''
      )
 ORDER BY VALUE', NULL, NULL, 'Y', 'N', 'Y', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, NULL, NULL, 'BRK_LISTS', 'CF', NULL, 'P_CUSTODYCD', 'SELECT VALUE, VALUE VALUECD, VALUE DISPLAY, VALUE EN_DISPLAY, FULLNAME DESCRIPTION, FULLNAME EN_DESCRIPTION
 FROM (
        SELECT DISTINCT MST.SHORTNAME VALUE, MST.FULLNAME
        FROM FAMEMBERS MST
        WHERE MST.ROLES=''BRK''
        MINUS
        SELECT DISTINCT MST.SHORTNAME VALUE, MST.FULLNAME
        FROM FAMEMBERS MST, FABROKERAGE BRK
        WHERE MST.AUTOID = BRK.BRKID AND BRK.CUSTODYCD = UPPER(''<$TAGFIELD>'')
        AND MST.ROLES=''BRK''
      )
 ORDER BY VALUE', NULL, 'Y', 'C', 'N');COMMIT;