SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('TRBANKACC','NULL') AND NVL(CDTYPE,'NULL') = NVL('RM','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('RM', 'TRBANKACC', '12310000162659', 'CTY CK BVSC-BIDV', 0, 'Y', 'BVSC-BIDV Securities company');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('RM', 'TRBANKACC', '12310000162668', 'CTY CK BVSC-BIDV', 1, 'Y', 'BVSC-BIDV Securities company');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('RM', 'TRBANKACC', '12310000192203', 'CTY CK BVSC-BIDV', 2, 'Y', 'BVSC-BIDV Securities company');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('RM', 'TRBANKACC', '12310000162640', 'CTY CK BVSC-BIDV', 3, 'Y', 'BVSC-BIDV Securities company');COMMIT;