SET DEFINE OFF;DELETE FROM CMDMENU WHERE 1 = 1 AND NVL(PRID,'NULL') = NVL('011000','NULL');Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('011005', '011000', 3, 'Y', 'A', 'SY1505', 'SA', 'BATCH', 'Xử lý cuối ngày', 'End of day processing', 'YYYYYYYYYYN', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('011008', '011000', 3, 'Y', 'A', 'SY1508', 'SA', 'TRADING_RESULT', 'Nhận kết quả khớp lệnh', 'Receive matching result', 'YYYYYYYYYYN', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('011009', '011000', 3, 'Y', 'A', 'SY1509', 'SA', 'BFBATCH', 'Xử lý trước cuối ngày', 'Before end of day processing', 'YYYYYYYYYYN', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('011011', '011000', 3, 'Y', 'A', 'SY1511', 'SA', 'OPERATION', 'Bảng vận hành', 'Operation panel', 'YYYYYYYYYYN', NULL);COMMIT;