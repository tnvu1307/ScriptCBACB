SET DEFINE OFF;DELETE FROM VSDTXMAP WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('9026','NULL');Insert into VSDTXMAP   (OBJTYPE, OBJNAME, TRFCODE, FLDREFCODE, FLDNOTES, AMTEXP, AFFECTDATE, FLDACCTNO) Values   ('T', '9026', '566.CORP.CONF.QM', '', '', '', '<$TXDATE>', '');COMMIT;