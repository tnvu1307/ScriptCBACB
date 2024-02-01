SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('FAACCT','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('FAACCT', 'Gán TKLK', 'Add STC', 'SELECT FA.CUSTODYCD ,FA.cifid PORTFOLIO,FA.FULLNAME ,st.<@CDCONTENT> STATUS
 FROM
      (
      SELECT CUSTODYCD , amcid ID, STATUS,FULLNAME,cifid
       FROM CFMAST where amcid<>0
       UNION ALL
       SELECT CUSTODYCD , gcbid ID, STATUS,FULLNAME,cifid
        FROM CFMAST where amcid<>0
        UNION ALL
        SELECT CUSTODYCD , trusteeid ID, STATUS,FULLNAME,cifid
        FROM CFMAST where amcid<>0
        UNION ALL
       SELECT CUSTODYCD , lcbid ID, STATUS,FULLNAME,cifid
        FROM CFMAST where amcid<>0
        union all
        select Cf.CUSTODYCD , fa.brkid ID, STATUS,FULLNAME,cifid from cfmast cf, fabrokerage fa where cf.custodycd = fa.custodycd
        union all
        select Cf.CUSTODYCD , ap.refid ID, STATUS,FULLNAME,cifid from cfmast cf, cflnkap ap where cf.custid = ap.custid
      )
    FA,
    (
        select *from allcode  where cdname = ''STATUS'' and cdtype = ''CF''
    )ST
WHERE   ST.cdval = FA.status
    and FA.ID = ''<$KEYVAL>''', 'FA.FAACCT', NULL, NULL, NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;