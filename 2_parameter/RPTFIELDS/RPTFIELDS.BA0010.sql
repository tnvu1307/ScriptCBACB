SET DEFINE OFF;DELETE FROM RPTFIELDS WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('BA0010','NULL');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('BA', 'PV_SYMBOL', 'BA0010', 'PV_SYMBOL', 'Mã trái phiếu', 'Bond code', 0, 'M', '', '', 20, 'SELECT DISTINCT SB.SYMBOL VALUE, SB.SYMBOL VALUECD, SB.SYMBOL DISPLAY, SB.SYMBOL EN_DISPLAY, SB.SYMBOL DESCRIPTION
FROM sbsecurities SB
WHERE SECTYPE IN (''003'',''006'')', '', '', 'Y', 'N', 'Y', '', '', 'Y', 'C', '', '', '', '', '', '', 'SBSECURITIES_SYMBOL', 'BA', '', '', '', '', 'Y', 'T', 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('BA', 'I_DATE', 'BA0010', 'I_DATE', 'Ngày thanh toán', 'Payment date', 1, 'M', '99/99/9999', 'dd/MM/yyyy', 10, '', '', '<$SQL>SELECT GETNEXTWORKINGDATE(GETCURRDATE()) DEFNAME FROM DUAL', 'Y', 'N', 'Y', '', '', 'N', 'D', '', '', '', '', '', '', 'BONDTYPEPAY_SRCH', 'BA', '', '', '', '', 'Y', 'T', 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('BA', 'P_CUSTODYCD', 'BA0010', 'P_CUSTODYCD', 'Số TK lưu ký', 'Trading account', 2, 'M', 'cccc.cccccc', '-', 10, '', '', 'ALL', 'Y', 'N', 'Y', '', '', 'N', 'C', '', '', '', '', '', '', 'CUSTODYCD_BOND', 'BA', '', '', '', '', 'Y', 'T', 'N');COMMIT;