SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('TBLNAME','NULL') AND NVL(CDTYPE,'NULL') = NVL('IC','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'TBLNAME', '001', 'AFMAST', 0, 'Y', 'AFMAST');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'TBLNAME', '002', 'SEMAST', 1, 'Y', 'SEMAST');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'TBLNAME', '003', 'CIMAST', 2, 'Y', 'CIMAST');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'TBLNAME', '004', 'RPMAST', 3, 'Y', 'RPMAST');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'TBLNAME', '005', 'ODMAST', 4, 'Y', 'ODMAST');COMMIT;