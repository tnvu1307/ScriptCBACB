SET DEFINE OFF;DELETE FROM VSDTXMAP WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('2255','NULL');Insert into VSDTXMAP   (OBJTYPE, OBJNAME, TRFCODE, FLDREFCODE, FLDNOTES, AMTEXP, AFFECTDATE, FLDACCTNO) Values   ('T', '2255', '542.NEWM.CLAS//NORM.STCO//DLWM', '$18', '$30', '$12', '<$TXDATE>', '$02');Insert into VSDTXMAP   (OBJTYPE, OBJNAME, TRFCODE, FLDREFCODE, FLDNOTES, AMTEXP, AFFECTDATE, FLDACCTNO) Values   ('T', '2255', '542.NEWM.CLAS//PEND.STCO//DLWM', '$18', '$30', '$12', '<$TXDATE>', '$02');COMMIT;