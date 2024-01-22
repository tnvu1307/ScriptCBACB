SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SMSTYPLNK','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SMSTYPLNK', 'Biểu mẫu của loại hình SMS', 'Templates of SMS product type management', '
SELECT sm.autoid, sm.actype, sm.code, sm.txdate, a1.cdcontent status, te.name, te.subject
FROM smstyplnk sm, templates te, allcode a1
WHERE sm.actype = ''<$KEYVAL>'' and sm.code = te.code(+) and sm.status = a1.cdval(+) and cdname(+) = ''STATUS'' AND cdtype(+) = ''SA''
', 'CF.SMSTYPLNK', 'frmSMSTYPLNK', '', '', 0, 5000, 'Y', 1, '', 'Y', 'T', '', 'N', '');COMMIT;