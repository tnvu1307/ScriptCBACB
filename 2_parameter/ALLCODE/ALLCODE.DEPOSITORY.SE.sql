SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('DEPOSITORY','NULL') AND NVL(CDTYPE,'NULL') = NVL('SE','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SE', 'DEPOSITORY', '001', 'TT lưu ký', 0, 'Y', 'Depository center');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SE', 'DEPOSITORY', '002', 'SBS', 1, 'Y', 'SBS');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SE', 'DEPOSITORY', '003', 'Tổ chức xác nhận', 2, 'Y', 'Confirming organization');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SE', 'DEPOSITORY', '004', 'Tổ chức phát hành', 3, 'Y', 'Issuer');COMMIT;