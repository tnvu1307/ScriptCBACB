SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('ASETSTATUS','NULL') AND NVL(CDTYPE,'NULL') = NVL('SA','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'ASETSTATUS', '0', 'Chưa có xác nhận từ Sở', 1, 'Y', 'Chưa có xác nhận từ Sở');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'ASETSTATUS', '3', '3: Không tồn tại user này', 2, 'Y', '3: User not Recognised');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'ASETSTATUS', '4', '4: Pass không đúng', 3, 'Y', '4: Password Incorrect');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'ASETSTATUS', '5', '5: Mật khẩu đã được đổi', 4, 'Y', '5: Password changed');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'ASETSTATUS', '7', '7: Sở từ chối', 5, 'Y', '7: Asset refush ');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'ASETSTATUS', '6', '6: Khác', 5, 'Y', '6: Other');COMMIT;