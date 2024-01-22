SET DEFINE OFF;DELETE FROM RPTFIELDS WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('BA0018','NULL');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('BA', 'PV_ISSUERS', 'BA0018', 'PV_ISSUERS', 'Mã TCPH', 'Issuers', 0, 'M', '', '', 10, 'SELECT NULL FROM DUAL', '', '', 'Y', 'N', 'Y', '', '', 'N', 'C', '', '', '', '', '', '', 'ISSUERS_SHORTNAME', 'SA', '', '', '', '', 'Y', 'T', 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('BA', 'P_CONTRACT', 'BA0018', 'P_CONTRACT', 'Số hợp đồng', 'Contract Number', 1, 'M', '', '_', 20, '', '', '', 'Y', 'N', 'Y', '', '', 'N', 'C', '', '', '', '', '', '', 'CONTRACT_NOSB', 'SA', '', '', '', '', 'Y', 'T', 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('BA', 'PV_SYMBOL', 'BA0018', 'PV_SYMBOL', 'Mã TP', 'Bond code', 2, 'M', '', '', 20, '', '', '', 'Y', 'N', 'Y', '', '', 'Y', 'C', '', '', '', '', '', '', 'SBSECURITIES_BOND', 'BA', '', '', '', '', 'Y', 'T', 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('BA', 'I_DATE', 'BA0018', 'I_DATE', 'Ngày thanh toán', 'Payment date', 3, 'M', '99/99/9999', 'dd/MM/yyyy', 10, '', '', '<$BUSDATE>', 'Y', 'N', 'Y', '', '', 'N', 'D', '', '', '', '', '', '', '', '', '', '', '', '', 'Y', 'T', 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('BA', 'P_CUSTODYCD', 'BA0018', 'P_CUSTODYCD', 'Số TK lưu ký', 'Trading account', 4, 'M', 'cccc.cccccc', '-', 10, '', '', 'ALL', 'Y', 'N', 'Y', '', '', 'N', 'C', '', '', '', '', '', '', 'CUSTODYCD_TC', 'BA', '', '', '', '', 'Y', 'T', 'N');COMMIT;