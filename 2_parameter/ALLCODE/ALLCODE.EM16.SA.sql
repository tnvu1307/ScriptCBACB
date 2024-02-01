SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('EM16','NULL') AND NVL(CDTYPE,'NULL') = NVL('SA','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'EM16', 'SYMBOL', 'Trái phiếu', 1, 'Y', 'Bond');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'EM16', 'ISSUEDATE', 'Ngày phát hành', 2, 'Y', 'Issue date');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'EM16', 'MATURITYDATE', 'Ngày đáo hạn', 3, 'Y', 'Maturity date');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'EM16', 'AMOUNT', 'Tổng giá trị phát hành theo mệnh giá', 4, 'Y', 'Total value of issuance at par value');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'EM16', 'INTRATE', 'Lãi suất', 5, 'Y', 'Coupon');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'EM16', 'AMOUNT_UNIT', 'đồng', 5, 'Y', 'dong');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'EM16', 'INTRATE_UNIT', '%/năm', 6, 'Y', '% p.a.');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'EM16', 'LTV_EN', 'đã tăng lên vượt', 12, 'Y', 'LTV Ratio is increasing and very close to the Maximum LTV Ratio of');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'EM16', 'CCR_EN', 'đã giảm xuống dưới', 12, 'Y', 'CCR Ratio is decreasing and very close to the Minimum CCR Ratio of ');COMMIT;