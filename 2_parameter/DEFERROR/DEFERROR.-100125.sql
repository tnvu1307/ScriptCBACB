SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100125;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100125, '[-100125]: Không được phép đổi loại hình core bank!', '[-100125]: Cannot change core bank type!', 'SA', 0);COMMIT;