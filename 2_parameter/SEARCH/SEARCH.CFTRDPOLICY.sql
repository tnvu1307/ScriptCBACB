SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CFTRDPOLICY','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CFTRDPOLICY', 'Chính sách đầu tư', 'Trading policy', 'SELECT MST.AUTOID, A0.CDCONTENT LEVELCD, MST.MAXNAV, MST.REFID, RF.RFNAME, 
 MST.NOTES, MST.FRDATE, MST.TODATE, A2.CDCONTENT STATUS,
 (CASE WHEN MST.STATUS=''P'' THEN ''Y'' ELSE ''N'' END) APRALLOW
FROM CFTRDPOLICY MST, ALLCODE A0, ALLCODE A2,
(select ''U'' refcd, tlid refid, tlname rfname from tlprofiles 
union all
select ''G'' refcd, grpid refid, grpname rfname from tlgroups
union all
select ''I'' refcd, codeid refid, symbol rfname from sbsecurities
union all
select ''S'' refcd, ''NULL'' refid, varvalue rfname from sysvar where varname=''COMPANYSHORTNAME'') RF
WHERE RF.REFCD=MST.LEVELCD 
AND RF.REFID=NVL(MST.REFID,''NULL'')
AND A0.CDTYPE=''SA'' AND A0.CDNAME=''LEVELCD'' AND A0.CDVAL=MST.LEVELCD
AND A2.CDTYPE=''SY'' AND A2.CDNAME=''TYPESTS'' AND A2.CDVAL=MST.STATUS', 'CFTRDPOLICY', 'frmCFTRDPOLICY', NULL, 'EXEC', NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;