SET DEFINE OFF;DELETE FROM FLDMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('1290','NULL');Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('CI', '03', '1290', 'ACCTNO', 'Số TK ngân hàng', 'Bank account', 1.2, 'C', NULL, NULL, 25, NULL, NULL, ' ', 'N', 'N', 'N', ' ', ' ', 'Y', 'C', NULL, NULL, NULL, NULL, '##########', NULL, NULL, NULL, NULL, 'C', 'N', 'MAIN', '88', NULL, 'SELECT * FROM
(
    SELECT T.ACCTNO FILTERCD,T.ACCTNO VALUE,T.ACCTNO VALUECD, T.DISPLAY DISPLAY, T.DISPLAY EN_DISPLAY
    FROM (
        SELECT CF.CUSTODYCD, CI.ACCTNO, CI.REFCASAACCT ||'' - ''|| CI.CCYCD || '' - '' || A1.CDCONTENT DISPLAY
        FROM DDMAST CI, ALLCODE A1, CFMAST CF
        WHERE A1.CDNAME = ''ACCOUNTTYPE'' AND A1.CDVAL = CI.ACCOUNTTYPE AND A1.CDTYPE = ''DD''
              AND CI.CUSTID = CF.CUSTID
              AND CI.STATUS <> ''C''
    ) T
    WHERE T.CUSTODYCD = ''<$TAGFIELD>''
    UNION ALL
    SELECT ''---'' FILTERCD, ''---'' VALUE, ''---'' VALUECD, ''---'' DISPLAY, ''---'' EN_DISPLAY
    FROM DUAL
    WHERE NOT EXISTS (
        SELECT 1
        FROM (
            SELECT CF.CUSTODYCD, CI.ACCTNO, CI.REFCASAACCT ||'' - ''|| CI.CCYCD || '' - '' || A1.CDCONTENT DISPLAY
            FROM DDMAST CI, ALLCODE A1, CFMAST CF
            WHERE A1.CDNAME = ''ACCOUNTTYPE'' AND A1.CDVAL = CI.ACCOUNTTYPE AND A1.CDTYPE = ''DD''
                  AND CI.CUSTID = CF.CUSTID
                  AND CI.STATUS <> ''C''
        ) T
        WHERE T.CUSTODYCD = ''<$TAGFIELD>''
    )
) WHERE 0 = 0', 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 25, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('CI', '10', '1290', 'FEEAMT', 'Số phí (trước thuế)', 'Fee amount (VAT-exclusive)', 7, 'N', '#,##0.##', '#,##0.##', 20, ' ', ' ', '0', 'Y', 'N', 'Y', ' ', ' ', 'N', 'N', NULL, NULL, NULL, NULL, '##########', NULL, NULL, NULL, NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', 'P_AMT', 'Y', '2', 'N', NULL, NULL, NULL, 'N', 25, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('CI', '20', '1290', 'POSTDATE', 'Ngày giao dịch', 'Transaction date', 0, 'D', '99/99/9999', '99/99/9999', 10, NULL, ' ', '<$BUSDATE>', 'Y', 'N', 'Y', ' ', ' ', 'N', 'D', NULL, NULL, NULL, NULL, '##########', NULL, NULL, NULL, NULL, 'M', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 10, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('CI', '21', '1290', 'CCYCD', 'Loại tiền tệ', 'Currency', 6.1, 'C', ' ', ' ', 25, 'SELECT CDVAL VALUECD, CDVAL VALUE, CDCONTENT DISPLAY, EN_CDCONTENT EN_DISPLAY, EN_CDCONTENT DESCRIPTION, LSTODR
FROM ALLCODE
WHERE CDTYPE = ''FA''
AND CDNAME = ''CCYCD''
AND CDVAL IN (''VND'',''USD'')
ORDER BY LSTODR', ' ', NULL, 'Y', 'N', 'Y', ' ', ' ', 'N', 'C', NULL, NULL, NULL, ' ', '##########', NULL, NULL, NULL, NULL, 'C', 'N', 'MAIN', '25', NULL, 'SELECT A2.CDVAL FILTERCD,A2.CDVAL VALUE,A2.CDVAL VALUECD,A2.CDCONTENT DISPLAY, A2.EN_CDCONTENT EN_DISPLAY
FROM FEEMASTER MST, ALLCODE A0, ALLCODE A1,ALLCODE A2, ALLCODE A3, ALLCODE A4
WHERE A0.CDTYPE=''SA'' AND A0.CDNAME=''FORP'' AND A0.CDVAL=MST.FORP
AND A1.CDTYPE=''SY'' AND A1.CDNAME=''YESNO'' AND A1.CDVAL=MST.STATUS
AND A2.CDTYPE=''FA'' AND A2.CDNAME = ''CCYCD'' AND A2.CDVAL=MST.CCYCD
AND A3.CDTYPE = ''CF'' AND A3.CDNAME = ''REFCODE'' AND A3.CDVAL=MST.REFCODE
AND A4.CDTYPE = ''SA'' AND A4.CDNAME = MST.REFCODE AND A4.CDVAL=MST.SUBTYPE
AND MST.FEECD=''<$TAGFIELD>''', 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 17, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('CI', '23', '1290', 'FEETYPE', 'Mã phí ', 'Fee code', 2, 'C', ' ', ' ', 25, 'SELECT distinct CDCONTENT VALUECD, CDCONTENT VALUE, CDCONTENT DISPLAY, CDCONTENT EN_DISPLAY
     FROM ALLCODE
     WHERE CDTYPE =''SA'' AND
           CDNAME =''FEECODE'' AND
           CDVAL in (SELECT EN_CDCONTENT
                        FROM ALLCODE
                        WHERE   CDNAME in (SELECT CDVAL  FROM ALLCODE WHERE CDTYPE = ''CF'' AND CDNAME = ''REFCODE'')
                            AND CDVAL in (SELECT FILTERCD  FROM vw_feedetails_all WHERE ID in(SELECT CDVAL  FROM ALLCODE WHERE CDTYPE = ''CF'' AND CDNAME = ''REFCODE'') group by FILTERCD)
                            AND CDTYPE =''SA'') order by cdcontent', ' ', ' ', 'Y', 'N', 'Y', ' ', ' ', 'Y', 'C', NULL, NULL, NULL, ' ', '##########', NULL, NULL, NULL, NULL, 'C', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 17, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('CI', '26', '1290', 'VATAMT', 'Thuế', 'Tax amount', 7.1, 'N', '#,##0.##', '#,##0.##', 20, NULL, NULL, '0', 'Y', 'N', 'Y', NULL, NULL, 'N', 'N', NULL, NULL, NULL, NULL, '##########', NULL, NULL, NULL, NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', '2', 'N', NULL, NULL, NULL, 'N', 25, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('CI', '27', '1290', 'FEEAMTVAT', 'Số phí (sau thuế)', 'Fee amount (VAT-inclusive)', 8.1, 'T', '#,##0.##', '#,##0.##', 20, NULL, NULL, '0', 'Y', 'Y', 'Y', NULL, NULL, 'N', 'N', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', '2', 'N', NULL, NULL, NULL, 'N', 25, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('CI', '30', '1290', 'DESCRIPTION', 'Diễn giải', 'Description', 9, 'C', ' ', ' ', 100, ' ', ' ', NULL, 'Y', 'N', 'N', ' ', ' ', 'N', 'C', NULL, NULL, NULL, NULL, '##########', NULL, NULL, NULL, NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 99, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('CI', '88', '1290', 'CUSTODYCD', 'Số TKLK', 'Trading account', 1, 'C', NULL, NULL, 10, ' ', ' ', ' ', 'Y', 'N', 'Y', ' ', ' ', 'N', 'C', NULL, NULL, NULL, 'CUSTODYCD', '##########', NULL, 'CUSTODYCD_CF', 'CF', NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 10, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('CI', '90', '1290', 'CUSTNAME', 'Họ tên KH', 'Account name', 6, 'C', ' ', ' ', 25, ' ', ' ', ' ', 'Y', 'Y', 'Y', ' ', ' ', 'N', 'C', NULL, NULL, NULL, 'FULLNAME', '##########', '88FULLNAME', NULL, NULL, NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 25, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('CI', '91', '1290', 'PROFOLIOCD', 'Mã KH', '# Portfolio', 5, 'C', ' ', ' ', 25, ' ', ' ', ' ', 'Y', 'Y', 'Y', ' ', ' ', 'N', 'C', NULL, NULL, NULL, 'CIFID', '##########', '88CIFID', NULL, NULL, NULL, 'T', 'N', 'MAIN', NULL, NULL, NULL, 'N', NULL, 'Y', NULL, 'N', NULL, NULL, NULL, 'N', 25, 1);COMMIT;