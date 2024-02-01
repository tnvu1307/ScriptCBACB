SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('PRSECMAP','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('PRSECMAP', 'DS chứng khoán', 'Securities list', '
  select pr.autoid, pr.prcode, pr.status, pr.roomlimit, vr.codeid, vr.symbol, sb.FULLNAME, sb.TRADEPLACE, (se.LISTINGQTTY*SYSR1.VARVALUE/100) ROOMLIMITMAX,
       NVL(pr.ROOMUSED,0) SPRROOMUSED, pr.roomlimit-NVL(pr.ROOMUSED,0) SPRDECREASE , CASE WHEN pr.roomlimit-NVL(pr.ROOMUSED,0)<0 THEN NVL(pr.ROOMUSED,0)-pr.roomlimit ELSE 0 END SPRROOMREMAINRLS, vr.SYROOMLIMIT SYRROOMLIMIT, vr.SYROOMUSED SYRROOMUSED
  from prsecmap pr, VW_MARGINROOMSYSTEM vr ,(select sb.codeid, sb.symbol,a0.cdcontent TRADEPLACE, a1.FULLNAME
                      from sbsecurities sb,  allcode a0 , ISSUERS a1
                      where a0.cdname=''TRADEPLACE'' and a0.cdtype=''SA'' and a0.cdval=sb.TRADEPLACE and sb.ISSUERID=a1.ISSUERID) sb,
       securities_info se, SYSVAR SYSR1
  where pr.symbol=vr.codeid and sb.codeid=vr.codeid 
        AND SYSR1.GRNAME=''MARGIN'' AND SYSR1.VARNAME =''MAXDEBTQTTYRATE'' 
        and sb.codeid=se.codeid
        and pr.prcode=''<$KEYVAL>''
  order by pr.prcode,vr.symbol
', 'PR.PRSECMAP', 'BRID', NULL, NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;