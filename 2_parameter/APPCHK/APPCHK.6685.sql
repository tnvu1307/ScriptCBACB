SET DEFINE OFF;DELETE FROM APPCHK WHERE 1 = 1 AND NVL(TLTXCD,'NULL') = NVL('6685','NULL');Insert into APPCHK   (TLTXCD, APPTYPE, ACFLD, RULECD, AMTEXP, FLDKEY, DELTDCHK, ISRUN, CHKLEV) Values   ('6685', 'RM', '01', '02', '@PA', 'AUTOID', 'N', '@1', 0);Insert into APPCHK   (TLTXCD, APPTYPE, ACFLD, RULECD, AMTEXP, FLDKEY, DELTDCHK, ISRUN, CHKLEV) Values   ('6685', 'RM', '95', '01', '@OI', 'BANKCODE', 'N', '@1', 0);COMMIT;