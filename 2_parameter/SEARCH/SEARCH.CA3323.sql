SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CA3323','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CA3323', 'Chuyển quyền mua chưa được đăng ký của TK chờ đóng', 'Transfer unregistered right issue of pending close sub account', 'SELECT  schd.autoid, mst.camastid, cf.custodycd,cf.cifid, cf.fullname, af.acctno, sec.symbol symbol_org, sec2.symbol,
        schd.trade orgqtty, schd.pqtty + schd.qtty maxqtty, mst.exprice, mst.reportdate,
        mst.exrate, mst.rightoffrate
FROM    cfmast cf, afmast af, camast mst, caschd schd, sbsecurities sec, sbsecurities sec2
WHERE   cf.custid = af.custid AND af.acctno = schd.afacctno AND schd.camastid = mst.camastid
        AND mst.codeid = sec.codeid AND nvl(mst.tocodeid, mst.codeid) = sec2.codeid
        AND mst.catype = ''014'' AND schd.status IN (''A'',''V'') AND af.status = ''N''', 'CAMAST', NULL, NULL, '3323', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;