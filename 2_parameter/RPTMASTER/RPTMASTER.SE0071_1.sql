SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('SE0071_1','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('SE0071_1', 'HOST', 'SE', '12', '5', '5', '60', '5', '5', 'GIẤY ĐỀ NGHỊ CHUYỂN KHOẢN MỘT PHẦN CHỨNG KHOÁN (MẪU 26/LK - GD 2244)', 'N', 1, '1', 'L', 'SE0071_1#SE00311#SE00312#SE00313#SE00314#SE00315#SE00316#SE00317#SE00318', 'Y', 'S', 'N', 'R', 'N', 'N', 'M', '000', 'S', -1, 'GIẤY ĐỀ NGHỊ CHUYỂN KHOẢN MỘT PHẦN CHỨNG KHOÁN (MẪU 26/LK - GD 2244)', '', 0, 0, 0, 0, 'Y', 'N', 'Y', '');COMMIT;