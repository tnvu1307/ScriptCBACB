SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -700090;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-700090, '[-700090]: Hệ thống Flex đang chặn mua/bán trên mã này! ', '[-700090]: Flex system is blocking the buy / sell on this symbol!', 'OD', 0);COMMIT;