SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CITAD_REVERT','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CITAD_REVERT', 'Revert CITAD', 'Revert CITAD', 'select transactionnumber, txdate, status, errordesc, refno,
       addinfo, cardno, transactiondescription, theirrefno,
       trandate, currency, amount, benefitaccountname,
       applcaccountno, applcaccountname, interfacetype,
       sendingbankname, revbankname, valuedate,
       fundtranferfilename, to_char(reqid)reqid,TRANSFERORDER,BENEFITACCOUNTNO
 from CITAD_REVERT 
where  not exists ( select f.cvalue from
                                    vw_tllog_all tl, vw_tllogfld_all f where tl.txnum = f.txnum and
                                    tl.txdate = f.txdate and tl.tltxcd = ''6615'' and f.fldcd
                                    = ''01'' and tl.txstatus in(''1'', ''4'') and f.cvalue = transactionnumber)', 'CITAD_REVERT', '', '', '6615', NULL, 50, 'N', 1, 'NNNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;