SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('SE8816','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('SE8816', 'HOST', 'SE', '12', '5', '5', '60', '5', '5', 'Danh sách các giao dịch mua bán lô lẻ bị trung tâm từ chối (Giao dịch 8816)', 'Y', 1, '1', 'P', 'SE8816', 'N', 'B', 'N', 'V', 'N', 'N', 'M', '000', 'S', -1, 'List of odd lot trading rejected by ( 8816)', NULL, 0, 0, 0, 0, 'N', 'N', 'Y', NULL);COMMIT;