SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -200198;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-200198, '[-200198]: Hệ thống hiện tại không cho phép tại mới TK Margin!', '[-200198]:System not allow to create Margin account!', 'CF', NULL);COMMIT;