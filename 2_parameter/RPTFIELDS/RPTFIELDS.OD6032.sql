SET DEFINE OFF;DELETE FROM RPTFIELDS WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('OD6032','NULL');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('OD', 'I_DATE', 'OD6032', 'I_DATE', 'Ngày giao dịch', 'Transaction date', 0, 'M', '99/99/9999', 'dd/MM/yyyy', 10, '', '', '<$BUSDATE>', 'Y', 'N', 'Y', '', '', 'N', 'D', '', '', '', '', '', '', '', '', '', '', '', '', 'Y', 'T', 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('OD', 'PV_CUSTODYCD', 'OD6032', 'PV_CUSTODYCD', 'Số TKLK', 'Trading account', 1, 'M', 'cccc.cccccc', '_', 20, '', '', 'ALL', 'Y', 'N', 'Y', '', '', 'N', 'C', '', '', '', '', '', '', 'CUSTODYCD_TX', 'CF', '', '', '', '', 'Y', 'T', 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('OD', 'PV_AMC', 'OD6032', 'PV_AMC', 'Công ty QL quỹ', 'AMC', 2, 'M', 'cccccccccccccccccccc', '_', 20, '', '', 'ALL', 'Y', 'N', 'Y', '', '', 'N', 'C', '', '', '', '', '', '', 'AMC_LISTS', 'CF', '', '', '', '', 'Y', 'T', 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('OD', 'PV_GCB', 'OD6032', 'PV_GCB', 'GCB', 'GCB', 3, 'M', 'cccccccccccccccccccc', '_', 20, '', '', 'ALL', 'Y', 'N', 'Y', '', '', 'N', 'C', '', '', '', '', '', '', 'GCB_LISTS', 'CF', '', '', '', '', 'Y', 'T', 'N');COMMIT;