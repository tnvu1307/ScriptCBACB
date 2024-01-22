SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SMSTYPE','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SMSTYPE', 'Quản lý loại hình SMS', 'SMS product type management', '
select * from (SELECT actype, typename, feeamt, vat, a2.cdcontent status, a1.cdcontent apprv_sts, (CASE WHEN APPRV_STS IN (''D'') THEN ''N'' ELSE ''Y'' END) EDITALLOW, (CASE WHEN APPRV_STS IN (''P'') THEN ''Y'' ELSE ''N'' END) APRALLOW,
(CASE WHEN APPRV_STS IN (''D'') THEN ''N'' ELSE ''Y'' END) AS DELALLOW
 FROM smstype sm, allcode a1, allcode a2 where apprv_sts = a1.cdval and a1.cdname = ''APPRV_STS''
 AND  status = a2.cdval and a2.cdname = ''TYPEYESNO''
 order by actype) where 0 = 0
', 'SMSTYPE', 'frmSMSTYPE', '', '', 0, 5000, 'Y', 1, '', 'Y', 'T', '', 'N', '');COMMIT;