SET DEFINE OFF;DELETE FROM VSDTXMAP WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('2292','NULL');Insert into VSDTXMAP   (OBJTYPE, OBJNAME, TRFCODE, FLDREFCODE, FLDNOTES, AMTEXP, AFFECTDATE, FLDACCTNO) Values   ('T', '2292', '542.NEWM.CLAS//NORM.SETR//TRAD.STCO//PHYS', NULL, '$30', '$55', '<$TXDATE>', '$02');Insert into VSDTXMAP   (OBJTYPE, OBJNAME, TRFCODE, FLDREFCODE, FLDNOTES, AMTEXP, AFFECTDATE, FLDACCTNO) Values   ('T', '2292', '542.NEWM.CLAS//PEND.SETR//TRAD.STCO//PHYS', NULL, '$30', '$55', '<$TXDATE>', '$02');COMMIT;