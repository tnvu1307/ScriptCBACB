SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('SE0036','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('SE0036', 'HOST', 'SE', '12', '5', '5', '60', '5', '5', 'Yêu cầu chuyển khoản chứng khoán (29A/LK) ', 'N', 1, '1', 'L', 'SE00360#SE00361#SE00362#SE00363#SE00364#SE00365#SE00366#SE00367#SE00368', 'Y', 'S', 'N', 'R', 'N', 'N', 'M', '000', 'S', -1, 'Request transfer stock (29A/LK)', NULL, 0, 0, 0, 0, 'Y', 'N', 'Y', NULL);COMMIT;