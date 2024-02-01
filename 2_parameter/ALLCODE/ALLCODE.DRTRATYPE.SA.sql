SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('DRTRATYPE','NULL') AND NVL(CDTYPE,'NULL') = NVL('SA','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'DRTRATYPE', '001', 'Chuyển tiền cổ tức', 0, 'Y', 'Transfer dividend amount');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'DRTRATYPE', '002', 'Chuyển tiền cọc không trúng đấu giá', 1, 'Y', 'Transfer bidding amount ');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'DRTRATYPE', '004', 'Chuyển tiền KH đăng ký mua PHT cho VSD', 2, 'Y', 'Transfer right register amount to VSD');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'DRTRATYPE', '013', 'Chi phí dịch vụ ngân hàng cho hoạt động môi giới', 3, 'Y', 'RE bank expense ');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'DRTRATYPE', '015', 'Chuyển tiền KH đấu giá IPO cho TCPH - Sở GD', 4, 'Y', 'Transfer IPO amount to issuer - Stock Exchange');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'DRTRATYPE', '016', 'Chuyển tiền KH nộp thừa', 5, 'Y', 'Transfer customer overpaid amount');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'DRTRATYPE', '010', 'Điều chuyển vốn TK KH - KH', 9, 'Y', 'Capital transfer Customer - customer');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'DRTRATYPE', '017', 'Điều chuyển vốn TK KH - CTY', 10, 'Y', 'Capital transfer Customer - company');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'DRTRATYPE', '019', 'Chuyển tiền trả nợ cầm cố NH', 12, 'Y', 'Transfer DF paid amount to bank');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'DRTRATYPE', '030', 'Khác', 13, 'Y', 'Other');COMMIT;