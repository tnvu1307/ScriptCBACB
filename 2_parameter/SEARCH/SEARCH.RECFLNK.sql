SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('RECFLNK','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('RECFLNK', 'Quản lý đại lý/môi giới', 'Broker/Remiser management', 'SELECT tlp.tlname,RF.TLID,RF.AUTOID, CF.FULLNAME,RF.BRID,
RF.MINDREVAMT+RF.MINIREVAMT MINREVENUE, A0.CDCONTENT DESC_STATUS, RF.CUSTID, RF.AFACCTNO, RF.EFFDATE, RF.EXPDATE, (CASE WHEN RF.STATUS IN (''P'') THEN ''Y'' ELSE ''N'' END) APRALLOW
,brgrp.brname
FROM RECFLNK RF, CFMAST CF, ALLCODE A0,brgrp,TLPROFILES tlp
WHERE A0.CDTYPE=''RE'' AND A0.CDNAME=''STATUS'' AND A0.CDVAL=RF.STATUS AND RF.CUSTID=CF.CUSTID
AND RF.CUSTID=CF.CUSTID
and rf.brid=brgrp.brid(+)
--and (RF.STATUS <> ''C'' OR RF.STATUS IS NULL)
and rf.tlid=tlp.tlid(+)
AND (CF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = ''<$TELLERID>'')
     OR EXISTS (
        SELECT AF.CUSTID FROM AFMAST AF,TLGRPUSERS TLG
        WHERE AF.CAREBY=TLG.GRPID AND TLG.TLID = ''<$TELLERID>''
        AND AF.CUSTID=CF.CUSTID
       ))', 'RECFLNK', 'frmRECFLNK', 'FULLNAME', '', 0, 5000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;