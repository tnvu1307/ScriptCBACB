SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('OD0011','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('OD0011', 'Danh sách chờ Kiểm soát chéo', 'Waiting list Cross control', 'select tl.txdate,tl.txnum,tl.cfcustodycd CUSTODYCD,mx1.extraval BROKER,mx2.extraval PHONE,tl.cffullname CTCK,'''' FX,
       (case when tl.tltxcd in (''6690'',''6691'') then f.DDACCTNO else '''' end) DDACCTNO,
       (case when tl.tltxcd in (''2212'',''2213'') then f.SYMBOL else '''' end ) SYMBOL,
       (case when tl.tltxcd in (''2212'',''2213'') then f.CODEID else '''' end ) CODEID,
       tl.msgamt AMOUNT,tlpr.tlfullname USERNAME, tl.txtime TIME
    from tllog tl,
         famembers m,
         famembersextra mx1,
         famembersextra mx2,
         (
            SELECT   txnum,
            MAX (CASE WHEN f.fldcd = ''93'' THEN f.cvalue ELSE '''' END)  DDACCTNO,
            MAX (CASE WHEN f.fldcd = ''14'' THEN f.cvalue ELSE '''' END)  SYMBOL,
            MAX (CASE WHEN f.fldcd = ''04'' THEN f.cvalue ELSE '''' END)  CODEID,
            MAX (CASE WHEN f.fldcd = ''06'' THEN f.cvalue ELSE '''' END)  brname,
            MAX (CASE WHEN f.fldcd = ''07'' THEN f.cvalue ELSE '''' END)  brphone,
            MAX (CASE WHEN f.fldcd = ''05'' THEN f.cvalue ELSE '''' END)  CTCK             
            FROM   tllogfld f,ddmast dd
            WHERE   fldcd IN (''93'',''14'',''05'',''04'',''06'',''07'') 
            GROUP BY   txnum
         )f,
         (
            select tlfullname,tlid from tlprofiles
         )tlpr    
    where       tl.tltxcd in(''6690'',''6691'',''2212'',''2213'') 
            and batchname = ''BROKERCONFIRM''
            AND f.CTCK = m.autoid
            AND mx1.autoid = f.brname
            AND mx2.autoid = f.brphone
            and tl.txnum = f.txnum
            and tl.tlid = tlpr.tlid
           and not exists ( select f.cvalue from
                                    tllog t, tllogfld f where t.txnum = f.txnum and
                                    t.txdate = f.txdate and t.tltxcd = ''8898'' and f.fldcd
                                    = ''02'' and t.txstatus in(''1'', ''4'') and f.cvalue = tl.txnum)', 'OD.ODMAST', 'frmODMAST', NULL, '8898', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;