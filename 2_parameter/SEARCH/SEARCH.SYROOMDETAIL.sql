SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SYROOMDETAIL','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SYROOMDETAIL', 'TT room đặc biệt', 'Special Room Information', '
SELECT * FROM
(
    select prse.autoid, prse.prcode, prse.prname, sb.codeid, sb.symbol, prse.roomlimit prlimit, nvl(afpr.DBPRINUSED,0) prinused,
        prse.roomlimit - nvl(afpr.DBPRINUSED,0) pravllimit
    from  VW_MARGINROOMSYSTEM sb,
        (select pr.prname, prse.*  from prsecmap prse, prmaster pr
         where pr.prcode=prse.prcode  ) prse,
         (  SELECT CODEID,PRCODE,
                  SUM(DECODE(RESTYPE, ''O'',PRINUSED, 0)) DBPRINUSED
             FROM VW_AFPRALLOC_ALL
             WHERE RESTYPE in (''O'')
             GROUP BY CODEID, PRCODE
          ) AFPR

    where  prse.symbol=sb.codeid
        and prse.symbol=afpr.codeid(+)
        and prse.prcode=afpr.prcode(+)
    order by prse.prcode, sb.symbol
) WHERE codeid = ''<$KEYVAL>''', 'PR.SYROOMDETAIL', NULL, NULL, NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;