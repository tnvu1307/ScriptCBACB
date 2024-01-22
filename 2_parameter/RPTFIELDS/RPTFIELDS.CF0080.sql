SET DEFINE OFF;DELETE FROM RPTFIELDS WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('CF0080','NULL');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('CF', 'CUSTODYCD', 'CF0080', 'PV_CUSTODYCD', 'Số TK lưu ký', 'Trading account', 0, 'M', 'cccc.cccccc', '_', 10, '', '', '', 'Y', 'N', 'Y', '', '', 'N', 'C', '', '', '', '', '', '', 'CUSTODYCD_TX', 'CF', '', '', '', '', 'Y', 'T', 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('CF', 'AFACCTNO', 'CF0080', 'AFACCTNO', 'Số tiểu khoản', 'Sub account', 1, 'T', '', '_', 30, 'SELECT ACCTNO VALUE ,DESCRIPTION DISPLAY, DESCRIPTION EN_DISPLAY, DESCRIPTION DISCRIPTION FROM AFMAST WHERE STATUS <> ''C'' ORDER BY ACCTNO ', '', 'ALL', 'Y', 'N', 'N', '', '', 'N', 'C', '', '', '', '', '', '', 'AFMAST', 'CF', '', 'CUSTODYCD', 'SELECT FILTERCD, VALUE, VALUECD, DISPLAY, EN_DISPLAY, DESCRIPTION FROM VW_CUSTODYCD_SUBACCOUNT_ACTIVE WHERE FILTERCD=UPPER(''<$TAGFIELD>'') UNION ALL SELECT ''ALL'' FILTERCD, ''ALL'' VALUE, ''ALL'' VALUECD, ''ALL'' DISPLAY, ''ALL'' EN_DISPLAY, ''ALL'' DESCRIPTION FROM DUAL', '', 'Y', 'C', 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('CF', 'PV_TXKEY', 'CF0080', 'PV_TXKEY', 'Số chứng từ', 'Bus No.', 2, 'T', '', '_', 50, '', '', 'ALL', 'Y', 'N', 'N', '', '', 'N', 'C', '', '', '', '', '', '', '', '', '', 'CUSTODYCD', 'SELECT DISTINCT  to_char(txdate, ''ddmmrrrr'') || txnum FILTERCD,  to_char(txdate, ''ddmmrrrr'') || txnum VALUE, to_char(txdate, ''ddmmrrrr'') || txnum VALUECD,  to_char(txdate, ''ddmmrrrr'') || txnum DISPLAY, to_char(txdate, ''ddmmrrrr'') || txnum EN_DISPLAY, to_char(txdate, ''ddmmrrrr'') || txnum DESCRIPTION FROM CF0080_LOG WHERE custodycd = upper(''<$TAGFIELD>'')', '', 'Y', 'C', 'N');COMMIT;