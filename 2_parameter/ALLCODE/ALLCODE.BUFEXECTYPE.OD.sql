SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('BUFEXECTYPE','NULL') AND NVL(CDTYPE,'NULL') = NVL('OD','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'BUFEXECTYPE', 'NBN', 'Mua thông thường', 0, 'Y', 'Buy normal');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'BUFEXECTYPE', 'NSN', 'Bán thông thường', 1, 'Y', 'Normal selling');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'BUFEXECTYPE', 'SSN', 'Bán khống', 2, 'Y', 'Short sell');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'BUFEXECTYPE', 'BCN', 'Mua cover', 3, 'Y', 'Buy cover');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'BUFEXECTYPE', 'MSN', 'Bán cầm cố', 4, 'Y', 'Sell mortgage');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'BUFEXECTYPE', 'CBN', 'Hủy mua thông thường', 6, 'Y', 'Cancel normal buying');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'BUFEXECTYPE', 'CSN', 'Hủy bán thông thường', 7, 'Y', 'Cancel normal selling');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'BUFEXECTYPE', 'ABN', 'Sửa mua thông thường', 8, 'Y', 'Normal buying Edit');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'BUFEXECTYPE', 'ASN', 'Sửa bán thông thường', 9, 'Y', 'Normal selling edit');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'BUFEXECTYPE', 'NBP', 'Mua thỏa thuận', 10, 'Y', 'Buy Put through');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'BUFEXECTYPE', 'NSP', 'Bán thỏa thuận', 11, 'Y', 'Put through selling');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'BUFEXECTYPE', 'CBP', 'Hủy mua thỏa thuận', 12, 'Y', 'Cancel put through buying');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'BUFEXECTYPE', 'CSP', 'Hủy bán thỏa thuận', 13, 'Y', 'Cancel put through selling');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'BUFEXECTYPE', 'ABP', 'Sửa mua thỏa thuận', 14, 'Y', 'Put through buying Edit');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'BUFEXECTYPE', 'ASP', 'Sửa bán thỏa thuận', 15, 'Y', 'Put through selling edit');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'BUFEXECTYPE', 'SSP', 'Bán khống', 16, 'Y', 'Short sell');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'BUFEXECTYPE', 'BCP', 'Mua cover', 17, 'Y', 'Buy cover');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'BUFEXECTYPE', 'MSP', 'Bán cầm cố', 18, 'Y', 'Sell mortgage');COMMIT;