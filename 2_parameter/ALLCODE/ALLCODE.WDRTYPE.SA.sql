SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('WDRTYPE','NULL') AND NVL(CDTYPE,'NULL') = NVL('SA','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'WDRTYPE', '001', 'Trả tiền mua', 0, 'Y', 'Trả tiền mua');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'WDRTYPE', '002', 'Trả phí mua', 1, 'Y', 'Trả phí mua');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'WDRTYPE', '003', 'Trả phí bán', 2, 'Y', 'Trả phí bán');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'WDRTYPE', '004', 'Trả thuế bán', 3, 'Y', 'Trả thuế bán');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'WDRTYPE', '005', 'Rút tiền sửa lỗi', 4, 'Y', 'Rút tiền sửa lỗi');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'WDRTYPE', '007', 'Thu tiền lẻ KH tất toán tài khoản', 5, 'Y', 'Thu tiền lẻ KH tất toán tài khoản');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'WDRTYPE', '009', 'Thu nợ cầm cố NH', 6, 'Y', 'Thu nợ cầm cố NH');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'WDRTYPE', '008', 'Cắt tiền kh trả phí cầm cố, phong tỏa ck', 7, 'Y', 'Cắt tiền kh trả phí cầm cố, phong tỏa ck');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'WDRTYPE', '011', 'Nộp tiền đấu giá IPO', 8, 'Y', 'Nộp tiền đấu giá IPO');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'WDRTYPE', '010', 'Thu đặt cọc đấu thầu trái phiếu', 9, 'Y', 'Thu đặt cọc đấu thầu trái phiếu');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'WDRTYPE', '028', 'Rút tiền sửa lỗi hủy thanh toán giao dịch', 10, 'Y', 'Rút tiền sửa lỗi hủy thanh toán giao dịch');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'WDRTYPE', '030', 'Cắt tiền cọc đấu giá', 11, 'Y', 'Cắt tiền cọc đấu giá');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'WDRTYPE', '029', 'Phí môi giới trái phiếu', 11, 'Y', 'Phí môi giới trái phiếu');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'WDRTYPE', '031', 'Phí sao kê tài khoản', 12, 'Y', 'Phí sao kê tài khoản');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'WDRTYPE', '032', 'Giảm tiền trong trường hợp sửa lỗi', 13, 'Y', 'Giảm tiền trong trường hợp sửa lỗi');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'WDRTYPE', '033', 'Thu thêm phí giao dịch', 14, 'Y', 'Thu thêm phí giao dịch');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'WDRTYPE', '034', 'Thu thêm phí ứng tiền', 15, 'Y', 'Thu thêm phí ứng tiền');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'WDRTYPE', '035', 'Thu thêm phí ứng tiền cổ tức', 16, 'Y', 'Thu thêm phí ứng tiền cổ tức');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'WDRTYPE', '036', 'Thu thêm phí lưu ký', 17, 'Y', 'Thu thêm phí lưu ký');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'WDRTYPE', '037', 'Thu thêm phí SMS', 18, 'Y', 'Thu thêm phí SMS');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'WDRTYPE', '038', 'Thu thêm phí chuyển nhượng quyền mua', 19, 'Y', 'Thu thêm phí chuyển nhượng quyền mua');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'WDRTYPE', '039', 'Thu thêm phí chuyển nhượng chứng khoán', 20, 'Y', 'Thu thêm phí chuyển nhượng chứng khoán');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'WDRTYPE', '040', 'Thu thêm lãi quá hạn trả chậm', 21, 'Y', 'Thu thêm lãi quá hạn trả chậm');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'WDRTYPE', '041', 'Thu thêm lãi quá hạn bảo lãnh', 22, 'Y', 'Thu thêm lãi quá hạn bảo lãnh');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'WDRTYPE', '042', 'Thu thêm lãi margin', 23, 'Y', 'Thu thêm lãi margin');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'WDRTYPE', '043', 'Thu thêm tiền phí renew margin', 24, 'Y', 'Thu thêm tiền phí renew margin');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'WDRTYPE', '044', 'Thu thêm tiền lãi chậm thanh toán margin', 25, 'Y', 'Thu thêm tiền lãi chậm thanh toán margin');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'WDRTYPE', '045', 'Thu thêm thuế chuyển nhượng chứng khoán', 26, 'Y', 'Thu thêm thuế chuyển nhượng chứng khoán');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'WDRTYPE', '046', 'Thu thêm thuế chuyển nhượng quyền mua', 27, 'Y', 'Thu thêm thuế chuyển nhượng quyền mua');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'WDRTYPE', '047', 'Thu thêm thuế bán chứng khoán', 28, 'Y', 'Thu thêm thuế bán chứng khoán');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'WDRTYPE', '048', 'Thu thêmthuế bán cổ phiếu lô lẻ', 29, 'Y', 'Thu thêmthuế bán cổ phiếu lô lẻ');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'WDRTYPE', '049', 'Thu thêm thuế cổ tức bằng tiền', 30, 'Y', 'Thu thêm thuế cổ tức bằng tiền');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'WDRTYPE', '050', 'Giảm lãi tài khoản tổng', 31, 'Y', 'Giảm lãi tài khoản tổng');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'WDRTYPE', '051', 'Điều chỉnh giảm tiền nộp của khách hàng', 32, 'Y', 'Điều chỉnh giảm tiền nộp của khách hàng');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'WDRTYPE', '052', 'Điều chỉnh tăng tiền rút của khách hàng', 33, 'Y', 'Điều chỉnh tăng tiền rút của khách hàng');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'WDRTYPE', '053', 'Tiền đấu giá IPO', 34, 'Y', 'Tiền đấu giá IPO');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'WDRTYPE', '054', 'Thu nợ SIC', 35, 'Y', 'Thu nợ SIC');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'WDRTYPE', '055', 'Thu phí chuyển tiền', 36, 'Y', 'Thu phí chuyển tiền');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'WDRTYPE', '056', 'Giảm khác', 37, 'Y', 'Giảm khác');COMMIT;