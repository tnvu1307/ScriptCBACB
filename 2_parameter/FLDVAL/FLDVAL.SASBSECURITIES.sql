SET DEFINE OFF;

DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('SA.SBSECURITIES','NULL');

Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('ISSUEDATE', 'SA.SBSECURITIES', 0, 'V', '<=', 'EXPDATE', NULL, 'Ngày phát hành phải nhỏ hơn ngày hết hạn!', 'Issue date must not later than expired date!', NULL, NULL, 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('PARVALUE', 'SA.SBSECURITIES', 1, 'V', '>>', '@0', NULL, 'Mệnh giá phải lớn hơn 0!', 'The parvalue must greater than 0!', NULL, NULL, 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('INTRATE', 'SA.SBSECURITIES', 2, 'V', '>=', '@0', NULL, 'Lãi suất không thấp hơn 0!', 'The interest rate is not less than 0!', NULL, NULL, 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('INTPERIOD', 'SA.SBSECURITIES', 3, 'V', '>=', '@0', NULL, 'Kỳ hạn trả lãi phải lớn hơn 0!', 'The interest period is not less than 0!', NULL, NULL, 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('SYMBOL', 'SA.SBSECURITIES', 5, 'F', 'IN', '@^([A-Z0-9_])*$', NULL, 'Mã chứng khoán phải là chữ in hoa!', 'Symbol must be in capital ', NULL, NULL, 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('ALLOWSESSION', 'SA.SBSECURITIES', 6, 'E', 'FX', 'FN_SBSECURITIES_ALLOWSESSION', 'TRADEPLACE##ALLOWSESSION', NULL, NULL, NULL, NULL, 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('011CWTERM', 'SA.SBSECURITIES', 7, 'V', '>>', '@0', NULL, 'Thời hạn của chứng quyền có bảo đảm phải lớn hớn 0!', 'The term covered warrant should must greater than 0!', 'SECTYPE', '@011', 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('015CWTERM', 'SA.SBSECURITIES', 7, 'V', '>>', '@0', NULL, 'Thời hạn của chứng quyền phải lớn hớn 0!', 'The term warrant should must greater than 0!', 'SECTYPE', '@015', 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('011EXERCISEPRICE', 'SA.SBSECURITIES', 20, 'V', '>>', '@0', NULL, 'Giá thực hiện chứng quyền có bảo đảm phải lớn hớn 0!', 'The Exercise Price should greater than 0!', 'SECTYPE', '@011', 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('015EXERCISEPRICE', 'SA.SBSECURITIES', 20, 'V', '>>', '@0', NULL, 'Giá thực hiện chứng quyền phải lớn hớn 0!', 'The Exercise Price should greater than 0!', 'SECTYPE', '@015', 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('011SETTLEMENTPRICE', 'SA.SBSECURITIES', 21, 'V', '>=', '@0', NULL, 'Giá thanh toán chứng quyền có bảo đảm phải lớn hớn hoặc bằng 0!', 'The Settlement Price is not less than 0!', 'SECTYPE', '@011', 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('015SETTLEMENTPRICE', 'SA.SBSECURITIES', 21, 'V', '>=', '@0', NULL, 'Giá thanh toán chứng quyền phải lớn hớn hoặc bằng 0!', 'The Settlement Price is not less than 0!', 'SECTYPE', '@015', 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('011NVALUE', 'SA.SBSECURITIES', 22, 'V', '>>', '@0', NULL, 'Hệ số nhân phải lớn hớn 0!', 'The Add Value should greater than 0!', 'SECTYPE', '@011', 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('015NVALUE', 'SA.SBSECURITIES', 22, 'V', '>>', '@0', NULL, 'Hệ số nhân phải lớn hớn 0!', 'The Add Value should greater than 0!', 'SECTYPE', '@015', 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('011EXERCISERATIO', 'SA.SBSECURITIES', 23, 'F', 'IN', '@^[^0-]\d*/[^0-]\d*$', NULL, 'Tỷ lệ thực hiện có dạng a/b và lớn hơn 0!', 'The rate format is invalid!', 'SECTYPE', '@011', 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('015EXERCISERATIO', 'SA.SBSECURITIES', 23, 'F', 'IN', '@^[^0-]\d*/[^0-]\d*$', NULL, 'Tỷ lệ thực hiện có dạng a/b và lớn hơn 0!', 'The rate format is invalid!', 'SECTYPE', '@015', 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('011EXERCISERATIO', 'SA.SBSECURITIES', 24, 'V', '>>', '@0', NULL, 'Tỷ lệ chuyển đổi phải lớn hơn 0!', 'Conversion rate should be greater than 0!', 'SECTYPE', '@011', 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('015EXERCISERATIO', 'SA.SBSECURITIES', 24, 'V', '>>', '@0', NULL, 'Tỷ lệ chuyển đổi phải lớn hơn 0!', 'Conversion rate should be greater than 0!', 'SECTYPE', '@015', 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('011EXERCISERATIO', 'SA.SBSECURITIES', 25, 'E', 'FX', 'fn_check_isnumber', '011EXERCISERATIO', NULL, NULL, 'SECTYPE', '@011', 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('015EXERCISERATIO', 'SA.SBSECURITIES', 25, 'E', 'FX', 'fn_check_isnumber', '015EXERCISERATIO', NULL, NULL, 'SECTYPE', '@015', 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('011MATURITYDATE', 'SA.SBSECURITIES', 30, 'V', '==', '<$WORKDATE>', NULL, 'Ngày đáo hạn phải là ngày làm việc!', 'Maturity date must be working date!', 'SECTYPE', '@011', 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('015MATURITYDATE', 'SA.SBSECURITIES', 30, 'V', '==', '<$WORKDATE>', NULL, 'Ngày đáo hạn phải là ngày làm việc!', 'Maturity date must be working date!', 'SECTYPE', '@015', 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('011LASTTRADINGDATE', 'SA.SBSECURITIES', 31, 'V', '==', '<$WORKDATE>', NULL, 'Ngày giao dịch cuối cùng phải là ngày làm việc!', 'The last trading day must be working date!', 'SECTYPE', '@011', 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('015LASTTRADINGDATE', 'SA.SBSECURITIES', 31, 'V', '==', '<$WORKDATE>', NULL, 'Ngày giao dịch cuối cùng phải là ngày làm việc!', 'The last trading day must be working date!', 'SECTYPE', '@015', 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('011MATURITYDATE', 'SA.SBSECURITIES', 32, 'V', '>=', '@<$BUSDATE>', NULL, 'Ngày đáo hạn phải lớn hơn hoặc bằng ngày hiện tại!', 'Maturity date must be greater than current date!', 'SECTYPE', '@011', 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('015MATURITYDATE', 'SA.SBSECURITIES', 32, 'V', '>=', '@<$BUSDATE>', NULL, 'Ngày đáo hạn phải lớn hơn hoặc bằng ngày hiện tại!', 'Maturity date must be greater than current date!', 'SECTYPE', '@015', 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('011LASTTRADINGDATE', 'SA.SBSECURITIES', 33, 'V', '>=', '@<$BUSDATE>', NULL, 'Ngày giao dịch cuối cùng phải lớn hơn hoặc bằng ngày hiện tại!', 'The last trading day must be greater than current date!', 'SECTYPE', '@011', 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('015LASTTRADINGDATE', 'SA.SBSECURITIES', 33, 'V', '>=', '@<$BUSDATE>', NULL, 'Ngày giao dịch cuối cùng phải lớn hơn hoặc bằng ngày hiện tại!', 'The last trading day must be greater than current date!', 'SECTYPE', '@015', 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('011LASTTRADINGDATE', 'SA.SBSECURITIES', 34, 'V', '<<', '011MATURITYDATE', NULL, 'Ngày giao dịch cuối cùng nhỏ hơn ngày đáo hạn!', 'The last trading day is less than the maturity date!', 'SECTYPE', '@011', 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('015LASTTRADINGDATE', 'SA.SBSECURITIES', 34, 'V', '<<', '015MATURITYDATE', NULL, 'Ngày giao dịch cuối cùng nhỏ hơn ngày đáo hạn!', 'The last trading day is less than the maturity date!', 'SECTYPE', '@015', 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('EXPDATE', 'SA.SBSECURITIES', 35, 'E', 'FX', 'GET_EXPDATE_SECURITIES', 'ISSUEDATE##TYPETERM##TERM', NULL, NULL, NULL, NULL, 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('INTCOUPON', 'SA.SBSECURITIES', 36, 'V', '>=', '@0', NULL, 'Lãi đến hạn phải >= 0', 'Coupon rate must be greater or equal to 0!', NULL, NULL, 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('INTPREMATURE', 'SA.SBSECURITIES', 37, 'V', '>=', '@0', NULL, 'Lãi trước hạn phải >= 0', 'Premature interest must be greater or equal to 0!', NULL, NULL, 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('INTERESTDATE', 'SA.SBSECURITIES', 38, 'V', '>=', '@0', NULL, 'Cơ số ngày tính lãi phải >= 0', 'Day year must be greater or equal to 0!', NULL, NULL, 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('CHKRATE', 'SA.SBSECURITIES', 39, 'V', '>=', '@0', NULL, 'Tỷ lệ theo dõi phải >= 0', 'Monitor rate must be greater or equal to 0!', NULL, NULL, 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('FOREIGNRATE', 'SA.SBSECURITIES', 40, 'V', '>=', '@0', NULL, 'Tỷ lệ nắm giữ NN phải >= 0', 'Foreign rate must be greater or equal to 0!', NULL, NULL, 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('VALUEOFISSUE', 'SA.SBSECURITIES', 41, 'V', '>=', '@0', NULL, 'Giá trị đợt phát hành phải >= 0', 'Face value of issuance must be greater or equal to 0!', NULL, NULL, 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('001MAXLTVRATE', 'SA.SBSECURITIES', 42, 'V', '>=', '@0', NULL, 'Tỷ lệ cầm cố tối đa phải >= 0', 'Max LTV rate must be greater or equal to 0!', NULL, NULL, 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('001WARNINGLTVRATE', 'SA.SBSECURITIES', 43, 'V', '>=', '@0', NULL, 'Tỷ lệ cầm cố cảnh báo phải >= 0', 'Warning LTV rate must be greater or equal to 0!', NULL, NULL, 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('TERM', 'SA.SBSECURITIES', 44, 'V', '>>', '@0', NULL, 'Kỳ hạn phải > 0', 'Term must be greate than 0!', NULL, NULL, 0);
COMMIT;
