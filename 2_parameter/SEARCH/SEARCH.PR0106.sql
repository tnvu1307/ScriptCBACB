SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('PR0106','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('PR0106', 'Giảm số lượng CK cho Room_ĐB', 'Reduce the quantity of securities for Special Room', '
select mst.autoid, mst.prcode, mst.prname, mst.codeid, mst.symbol, mst.roomlimit prlimit,  nvl(pr.prinused,0)  prinused,
      mst.roomlimit -  nvl(pr.prinused,0)  pravllimit, mst.roomlimitmax
from
(
 Select prs.autoid, pr.prcode, pr.prname, sb.codeid, sb.symbol, prs.roomlimit, prs.roomused , sb.roomlimit roomlimitmax 
 from prmaster pr, prsecmap prs, securities_info sb
 where pr.prcode = prs.prcode and prs.symbol = sb.codeid
       and pr.prstatus =''A'' and prtyp=''R'' and roomtyp=''SPR''
)mst,
(
 select codeid, prcode, sum(PRINUSED) PRINUSED
           from VW_AFPRALLOC_ALL pr
           where pr.RESTYPE=''O'' 
           group by codeid, prcode
) pr
where mst.codeid = pr.codeid (+) and mst.prcode = pr.prcode (+) 
 ', 'PRSECMAP', '', '', '0106', NULL, 5000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;