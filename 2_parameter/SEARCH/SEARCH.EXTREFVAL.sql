SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('EXTREFVAL','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('EXTREFVAL', 'TT mo dong', 'Status', 'SELECT def.defname, def.caption, def.en_caption, def.datatype, def.fldmask, def.fldformat, val.autoid, val.tblkey, (case when def.datatype=''N'' then to_char(val.nval) else to_char(val.cval) end) extval FROM extrefdef def, extrefval val where def.defname=val.defname and def.objname=val.objname and def.objname=''<$OBJNAME>'' and val.tblkey=''<$KEYVAL>''', 'SA.EXTREFVAL', 'frmEXTREFVAL', NULL, NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;