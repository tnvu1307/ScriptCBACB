SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('OPINIONVOTING','NULL') AND NVL(CDTYPE,'NULL') = NVL('CA','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CA', 'OPINIONVOTING', 'Y', 'Đồng ý', 0, 'Y', 'Agree');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CA', 'OPINIONVOTING', 'N', 'Không đồng ý', 1, 'Y', 'Disagree');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CA', 'OPINIONVOTING', 'NG', 'Bỏ trống', 2, 'Y', 'Empty');COMMIT;