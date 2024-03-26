SET DEFINE OFF;

DELETE FROM FOCMDCODE WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('COREBANK','NULL');

Insert into FOCMDCODE
   (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC, APPMODE, OBJNAME)
 Values
   ('PRC_GET_CRBTXREQ', 'BEGIN PRC_GET_CRBTXREQ(:p_refcursor,:p_err_code,:p_err_param);END;', 'Y', 'COREBANK', 'lấy danh sách crbtxreq', NULL, 'COREBANK');
Insert into FOCMDCODE
   (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC, APPMODE, OBJNAME)
 Values
   ('PRC_GET_REQEXCHANGETOKEN', 'BEGIN PRC_GET_REQEXCHANGETOKEN(:p_refcursor,:p_err_code,:p_err_param);END;', 'Y', 'COREBANK', 'lấy danh sách tk cần get EXCHANGE TOKEN', NULL, 'COREBANK');
Insert into FOCMDCODE
   (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC, APPMODE, OBJNAME)
 Values
   ('PRC_UPDATE_CRBTXREQ', 'BEGIN PRC_UPDATE_CRBTXREQ(:p_reqid,:p_status,:p_body,:p_err_code,:p_err_param);END;', 'Y', 'COREBANK', 'cap nhat crbtxreq', NULL, 'COREBANK');
Insert into FOCMDCODE
   (CMDCODE, CMDTEXT, CMDUSE, CMDTYPE, CMDDESC, APPMODE, OBJNAME)
 Values
   ('PRC_UPDATE_REQEXCHANGETOKEN', 'BEGIN PRC_UPDATE_REQEXCHANGETOKEN(:p_autoid,:p_exchangetoken,:p_status,:p_body,:p_error_msg,:p_err_code,:p_err_param);END;', 'Y', 'COREBANK', 'cap nhat EXCHANGE TOKEN', NULL, 'COREBANK');

COMMIT;
