SET DEFINE OFF;DELETE FROM CMDMENU WHERE 1 = 1 AND NVL(PRID,'NULL') = NVL('010000','NULL');Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('010002', '010000', 3, 'Y', 'M', 'SY1002', 'SA', 'BRGRP', 'Quản lý chi nhánh', 'Branch management', 'YYYYYYYNNYN', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('010003', '010000', 3, 'Y', 'O', 'SY1003', 'SA', 'RPTMASTER', 'Quản lý báo cáo và tra cứu', 'Reports management', 'YYYYYYYNNYN', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('010004', '010000', 3, 'Y', 'M', 'SY1004', 'SA', 'TLGROUPS', 'Nhóm người sử dụng', 'User group management', 'YYYYYYYNNYN', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('010005', '010000', 3, 'Y', 'M', 'SY1005', 'SA', 'TLPROFILES', 'Người sử dụng', 'User management', 'YYYYYYYNNYN', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('010006', '010000', 3, 'Y', 'A', 'SY1006', 'SA', 'GROUPUSERS', 'Thêm người sử dụng vào nhóm', 'Add users to group', 'YYYYYYYYYY', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('010008', '010000', 3, 'Y', 'O', 'SY1008', 'SA', 'TEMPLATES', 'Quản lý mẫu SMS/Email', 'SMS/Email templates', 'NYYNYNNNNNN', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('010009', '010000', 3, 'Y', 'R', 'SY1009', 'SA', 'RPTMASTER', 'Báo cáo hệ thống', 'SA report', 'YYYYYYYYYYN', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('010014', '010000', 3, 'Y', 'O', 'SY1015', 'SA', 'RIGHTASSIGNED', 'Tra cứu thông tin phân quyền', 'Permission info inquiry', 'NNNNYYNNNNN', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('010015', '010000', 3, 'Y', 'O', 'SY1014', 'SA', 'MAINTAIN_LOG', 'Tra cứu thông tin chỉnh sửa', 'Inquiry edit information', 'NNNNYYNNNNN', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('010016', '010000', 3, 'Y', 'M', 'SY1005', 'SA', 'FILEUPLOAD', 'Quản lý file', 'Management of the file', 'YYYYYYYNNYN', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('010017', '010000', 3, 'Y', 'M', 'SY1005', 'FA', 'SBACTIMST', 'Theo dõi công việc', 'Work status', 'YYYYYYYNNYN', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('010018', '010000', 3, 'Y', 'M', 'SY1005', 'SA', 'RPTGENCFG', 'Quản lý cài đặt gen báo cáo tự động', 'Set up automatically general reports', 'YYYYYYYNNYN', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('010019', '010000', 3, 'Y', 'M', 'SY1005', 'SA', 'TLOG', 'Quản lý log', 'Quản lý log', 'YYYYYYYNNYN', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('010021', '010000', 3, 'Y', 'M', 'SY1005', 'SA', 'EMAILLOGOTP', 'Quản lý log OTP', 'Management OTP log', 'YYYYYYYNNYN', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('011000', '010000', 2, 'N', 'P', NULL, NULL, NULL, 'Quản lý vận hành', 'Operation management', 'YYYYYYYYYYN', NULL);COMMIT;