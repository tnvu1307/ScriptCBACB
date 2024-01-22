SET DEFINE OFF;DELETE FROM APPRULES WHERE 1 = 1 AND NVL(APPTYPE,'NULL') = NVL('SE','NULL');Insert into APPRULES   (APPTYPE, RULECD, TBLNAME, FIELD, OPERAND, ERRNUM, ERRMSG, REFID, FLDRND) Values   ('SE', '01', 'SEMAST', 'STATUS', 'IN', -900019, 'Invalid status', 'SEMAST', '');Insert into APPRULES   (APPTYPE, RULECD, TBLNAME, FIELD, OPERAND, ERRNUM, ERRMSG, REFID, FLDRND) Values   ('SE', '02', 'SEMAST', 'WITHDRAW', '>=', -900017, 'TRADE NOT ENOUGHT', 'SEMAST', '');Insert into APPRULES   (APPTYPE, RULECD, TBLNAME, FIELD, OPERAND, ERRNUM, ERRMSG, REFID, FLDRND) Values   ('SE', '03', 'SEMAST', 'TRADE', '>=', -900017, 'TRADE NOT ENOUGHT', 'SEMAST', '');Insert into APPRULES   (APPTYPE, RULECD, TBLNAME, FIELD, OPERAND, ERRNUM, ERRMSG, REFID, FLDRND) Values   ('SE', '04', 'SEMAST', 'BLOCKED', '>=', -900040, 'BLOCK NOT ENOUGHT', 'SEMAST', '');Insert into APPRULES   (APPTYPE, RULECD, TBLNAME, FIELD, OPERAND, ERRNUM, ERRMSG, REFID, FLDRND) Values   ('SE', '05', 'SEMAST', 'COSTPRICE', '>=', -900014, 'COST PRICE NOT ENOUGHT', 'SEMAST', '');Insert into APPRULES   (APPTYPE, RULECD, TBLNAME, FIELD, OPERAND, ERRNUM, ERRMSG, REFID, FLDRND) Values   ('SE', '06', 'SEMAST', 'DEPOSIT', '>=', -900102, 'AMOUNT OVER DEPOSIT', 'SEMAST', '');Insert into APPRULES   (APPTYPE, RULECD, TBLNAME, FIELD, OPERAND, ERRNUM, ERRMSG, REFID, FLDRND) Values   ('SE', '07', 'SEMAST', 'SECURED', '>=', -900018, 'AMOUNT OVER DEPOSIT', 'SEMAST', '');Insert into APPRULES   (APPTYPE, RULECD, TBLNAME, FIELD, OPERAND, ERRNUM, ERRMSG, REFID, FLDRND) Values   ('SE', '08', 'SEMAST', 'SENDDEPOSIT', '>=', -900020, 'AMOUNT OVER SENDDEPOSIT', 'SEMAST', '');Insert into APPRULES   (APPTYPE, RULECD, TBLNAME, FIELD, OPERAND, ERRNUM, ERRMSG, REFID, FLDRND) Values   ('SE', '09', 'SEMAST', 'MORTAGE', '>=', -900020, 'AMOUNT OVER MORTAGE', 'SEMAST', '');Insert into APPRULES   (APPTYPE, RULECD, TBLNAME, FIELD, OPERAND, ERRNUM, ERRMSG, REFID, FLDRND) Values   ('SE', '10', 'SEMAST', 'NETTING', '>=', -900041, 'NETTING NOT ENOUGHT', 'SEMAST', '');Insert into APPRULES   (APPTYPE, RULECD, TBLNAME, FIELD, OPERAND, ERRNUM, ERRMSG, REFID, FLDRND) Values   ('SE', '11', 'SEWITHDRAW', 'AVLSEWITHDRAW', '>=', -900017, 'TRADE NOT ENOUGHT', '', '');Insert into APPRULES   (APPTYPE, RULECD, TBLNAME, FIELD, OPERAND, ERRNUM, ERRMSG, REFID, FLDRND) Values   ('SE', '12', 'SEMAST', 'TRADING', '>=', -900017, 'TRADE NOT ENOUGHT', '', '');Insert into APPRULES   (APPTYPE, RULECD, TBLNAME, FIELD, OPERAND, ERRNUM, ERRMSG, REFID, FLDRND) Values   ('SE', '13', 'SEREVERT', 'SESTATUS', '<=', -900042, 'EXIST INACTIVE SE ACCOUNTS', '', '');Insert into APPRULES   (APPTYPE, RULECD, TBLNAME, FIELD, OPERAND, ERRNUM, ERRMSG, REFID, FLDRND) Values   ('SE', '14', 'SEWITHDRAWDTL', 'STATUS', 'IN', -900043, '[-900043]: Invalid SEWITHDRAWDTL status', '', '');Insert into APPRULES   (APPTYPE, RULECD, TBLNAME, FIELD, OPERAND, ERRNUM, ERRMSG, REFID, FLDRND) Values   ('SE', '15', 'SEWITHDRAWDTL', 'STATUS', 'IN', -900046, '[-900046]: INVALID STATUS', '', '');Insert into APPRULES   (APPTYPE, RULECD, TBLNAME, FIELD, OPERAND, ERRNUM, ERRMSG, REFID, FLDRND) Values   ('SE', '16', 'SEMORTAGEDTL', 'STATUS', 'IN', -900049, '[-900049]: INVALID STATUS', '', '');Insert into APPRULES   (APPTYPE, RULECD, TBLNAME, FIELD, OPERAND, ERRNUM, ERRMSG, REFID, FLDRND) Values   ('SE', '17', 'SEMAST', 'ABSSTANDING', '>=', -900050, 'AMOUNT OVER MORTAGE', 'SEMAST', '');Insert into APPRULES   (APPTYPE, RULECD, TBLNAME, FIELD, OPERAND, ERRNUM, ERRMSG, REFID, FLDRND) Values   ('SE', '18', 'SEMAST', 'RETAILLOT', '>>', -900053, 'AMOUNT IS NOT RETAIL', 'SEMAST', '');Insert into APPRULES   (APPTYPE, RULECD, TBLNAME, FIELD, OPERAND, ERRNUM, ERRMSG, REFID, FLDRND) Values   ('SE', '19', 'SEMAST', 'RECEIVING', '>=', -900054, 'RECEIVING AMOUNT IS NOT ENOUGHT', 'SEMAST', '');Insert into APPRULES   (APPTYPE, RULECD, TBLNAME, FIELD, OPERAND, ERRNUM, ERRMSG, REFID, FLDRND) Values   ('SE', '20', 'SEMAST', 'BLOCKQTTY', '>=', -900040, 'Block not enought', 'SEBLOCKDEAL', '');Insert into APPRULES   (APPTYPE, RULECD, TBLNAME, FIELD, OPERAND, ERRNUM, ERRMSG, REFID, FLDRND) Values   ('SE', '23', 'SEMAST', 'SENDDEPOSIT', '>=', -900057, 'AMOUNT OVER SENDDEPOSIT', 'SEMAST', '');Insert into APPRULES   (APPTYPE, RULECD, TBLNAME, FIELD, OPERAND, ERRNUM, ERRMSG, REFID, FLDRND) Values   ('SE', '25', 'SEMAST', 'DTOCLOSE', '>=', -900120, 'AMOUNT OVER DTOCLOSE', 'SEMAST', '');Insert into APPRULES   (APPTYPE, RULECD, TBLNAME, FIELD, OPERAND, ERRNUM, ERRMSG, REFID, FLDRND) Values   ('SE', '30', 'SBSECURITIES', 'CAREBY', 'CB', -900100, 'ERR_SBSECURITIES_CAREBY_INVALID', 'SBSECURITIES', '');Insert into APPRULES   (APPTYPE, RULECD, TBLNAME, FIELD, OPERAND, ERRNUM, ERRMSG, REFID, FLDRND) Values   ('SE', '31', 'SEMAST', 'EMKQTTY', '>=', -900143, 'EMKQTTY NOT ENOUGHT', 'SEMAST', '');Insert into APPRULES   (APPTYPE, RULECD, TBLNAME, FIELD, OPERAND, ERRNUM, ERRMSG, REFID, FLDRND) Values   ('SE', '32', 'SEMAST', 'BLOCKWITHDRAW', '>=', -900144, 'BLOCKWITHDRAW NOT ENOUGHT', 'SEMAST', '');Insert into APPRULES   (APPTYPE, RULECD, TBLNAME, FIELD, OPERAND, ERRNUM, ERRMSG, REFID, FLDRND) Values   ('SE', '33', 'SEMAST', 'BLOCKDTOCLOSE', '>=', -900145, 'BLOCKDTOCLOSE NOT ENOUGHT', 'SEMAST', '');Insert into APPRULES   (APPTYPE, RULECD, TBLNAME, FIELD, OPERAND, ERRNUM, ERRMSG, REFID, FLDRND) Values   ('SE', '34', 'SEMAST', 'HOLD', '>=', -900034, 'HOLD NOT ENOUGHT', 'SEMAST', '');COMMIT;