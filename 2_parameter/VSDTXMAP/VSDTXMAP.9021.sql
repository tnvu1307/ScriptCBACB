SET DEFINE OFF;DELETE FROM VSDTXMAP WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('9021','NULL');Insert into VSDTXMAP   (OBJTYPE, OBJNAME, TRFCODE, FLDREFCODE, FLDNOTES, AMTEXP, AFFECTDATE, FLDACCTNO) Values   ('T', '9021', '564.CORP.REPE.BOND', '', '', '', '<$TXDATE>', '');COMMIT;