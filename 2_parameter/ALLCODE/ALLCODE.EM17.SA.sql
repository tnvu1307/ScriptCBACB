SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('EM17','NULL') AND NVL(CDTYPE,'NULL') = NVL('SA','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'EM17', '0021PRICE', 'giảm', 1, 'Y', 'decreasing');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'EM17', '0021RATE', 'LTV đã tăng lên vượt', 2, 'Y', 'LTV đã tăng lên');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'EM17', '0022PRICE', 'tăng', 3, 'Y', 'increasing');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'EM17', '0022RATE', 'LTV đã giảm xuống dưới', 4, 'Y', 'LTV đã giảm xuống');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'EM17', '0031PRICE', 'tăng', 5, 'Y', 'increasing');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'EM17', '0031RATE', 'CCR đã tăng lên vượt', 6, 'Y', 'CCR đã tăng lên');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'EM17', '0032PRICE', 'giảm', 7, 'Y', 'decreasing');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'EM17', '0032RATE', 'CCR đã giảm xuống dưới', 8, 'Y', 'CCR đã giảm xuống');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'EM17', '002', 'LTV (Tổng mệnh giá của Trái phiếu đang lưu hành/ Tổng Giá Trị Bảo Đảm)', 9, 'Y', 'LTV Ratio (Total Principal Amount of Outstanding Bonds/ Total Security Value)');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'EM17', '003', 'CCR (Tổng Giá Trị Bảo Đảm/ Tổng mệnh giá của Trái phiếu đang lưu hành)', 10, 'Y', 'CCR Ratio (Total Security Value/ Total Principal Amount of Outstanding Bonds)');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'EM17', 'CP', 'Cổ phiếu', 11, 'Y', 'shares');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'EM17', 'TP', 'Trái phiếu', 12, 'Y', 'bonds');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'EM17', 'LTV', 'LTV', 13, 'Y', 'LTV Ratio');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'EM17', 'CCR', 'CCR', 14, 'Y', 'CCR  Ratio');COMMIT;