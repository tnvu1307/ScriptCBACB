SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SETYPE','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SETYPE', 'Loại hình chứng khoán', 'SE product type', 'SELECT TYP.ACTYPE, SBC.CCYNAME CCYCD, TYP.TYPENAME, TYP.GLGRP, A0.CDCONTENT STATUS, TYP.GLBANK, TYP.SUBCD, TYP.DESCRIPTION NOTES,
A03.CDCONTENT APPRV_STS,
(CASE WHEN APPRV_STS IN (''D'') THEN ''N'' ELSE ''Y'' END) EDITALLOW, (CASE WHEN APPRV_STS IN (''P'') THEN ''Y'' ELSE ''N'' END) APRALLOW,
(CASE WHEN APPRV_STS IN (''D'') THEN ''N'' ELSE ''Y'' END) AS DELALLOW
FROM SETYPE TYP, SBCURRENCY SBC, ALLCODE A0, ALLCODE A03
WHERE A0.CDTYPE = ''SY'' AND A0.CDNAME = ''STATUS'' AND A0.CDVAL=TYP.STATUS AND SBC.CCYCD=TYP.CCYCD
AND A03.CDVAL = TYP.APPRV_STS AND A03.CDTYPE = ''SY'' AND A03.CDNAME = ''APPRV_STS''', 'SETYPE', 'frmSETYPE', '', '', 0, 5000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;