SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -670006;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-670006, '[-670006]: Bảng kê đã huỷ', '[-670006]: List canceled', 'RM', 0);COMMIT;