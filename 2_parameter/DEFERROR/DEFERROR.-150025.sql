SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -150025;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-150025, '[-150025]: Không thực hiện rút lưu ký cùng lúc cả 2 loại chứng khoán!', '[-150025]: Không thực hiện rút lưu ký cùng lúc cả 2 loại chứng khoán!', 'ST', NULL);COMMIT;