SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('FALORG','NULL') AND NVL(CDTYPE,'NULL') = NVL('FA','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('FA', 'FALORG', 'LCB', 'LOCAL CUSTODIAN BANK', 1, 'Y', 'LOCAL CUSTODIAN BANK');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('FA', 'FALORG', 'GCB', 'GLOBAL CUSTODIAN BANK', 2, 'Y', 'GLOBAL CUSTODIAN BANK');COMMIT;