SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('UNHOLDORDERQK','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('UNHOLDORDERQK', 'Unhold số tiền phong tỏa trong quá khứ', 'Unhold blockade amount', 'SELECT tl.TXDATE,DD.CUSTODYCD,tl.txnum,tl.tltxcd,F.TXNUM REFTXNUM ,DD.AFACCTNO SECACCOUNT,DD.ACCTNO DDACCTNO,CF.FULLNAME CUSTNAME,tlp.TLFULLNAME,
        DD.REFCASAACCT REFCASAACCT,DD.BALANCE,DD.HOLDBALANCE,F.MEMBERID,F.BRNAME,F.BRPHONE,F.CCYCD,CRB.TXAMT AMOUNT,F.NOTE,f.REQTXNUM,
        m.shortname MEMBERIDTEXT,mx1.extraval BRNAMETEXT,mx2.extraval BRPHONETEXT
    from crbtxreq crb,ddmast dd,cfmast cf,vw_tllog_all tl,tlprofiles tlp,
                            famembers m,
                         famembersextra mx1,
                         famembersextra mx2,
        (
            SELECT   txnum,txdate,
                                     MAX (CASE WHEN f.fldcd = ''05'' THEN f.cvalue ELSE '''' END)  memberid,
                                     MAX (CASE WHEN f.fldcd = ''06'' THEN f.cvalue ELSE '''' END)  brname,
                                     MAX (CASE WHEN f.fldcd = ''07'' THEN f.cvalue ELSE '''' END)  brphone,
                                     MAX (CASE WHEN f.fldcd = ''93'' THEN f.cvalue ELSE '''' END)  bankacctno,
                                     MAX (CASE WHEN f.fldcd = ''20'' THEN f.cvalue ELSE '''' END)  ccycd,
                                     MAX (CASE WHEN f.fldcd = ''30'' THEN f.cvalue ELSE '''' END)  note,
                                     MAX (CASE WHEN f.fldcd = ''95'' THEN f.cvalue ELSE '''' END)  reqtxnum
                              FROM   vw_tllogfld_all f
                              WHERE   fldcd IN (''04'',''05'', ''06'', ''07'', ''20'', ''93'',''30'',''95'')
                              GROUP BY   txnum,txdate
          )f
    where   crb.objname = ''6690''
        and crb.reqcode = ''BANKHOLDEDBYBROKER''
        and dd.acctno = crb.afacctno
        and dd.custodycd = cf.custodycd
        and crb.objkey = f.txnum
        and crb.txdate < getcurrdate
        AND f.memberid = m.autoid
        AND mx1.autoid = f.brname
        AND mx2.autoid = f.brphone
        and crb.txdate =tl.txdate
        and crb.objkey = tl.txnum
        and tl.tlid = tlp.tlid
        and crb.txdate = f.txdate
        and crb.unhold = ''N''
        and crb.status = ''C''
        and NOT EXISTS ( SELECT F.CVALUE FROM
                                    TLLOG TL, TLLOGFLD F WHERE TL.TXNUM = F.TXNUM AND
                                    TL.TXDATE = F.TXDATE AND TL.TLTXCD = ''6691'' AND F.FLDCD
                                    = ''91'' AND TL.TXSTATUS IN(''1'', ''4'') AND F.CVALUE =  F.TXNUM)', 'UNHOLDORDERQK', '', '', '6623', NULL, 5000, 'N', 1, 'NNNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;