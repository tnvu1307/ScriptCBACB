SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_PRIVATE_ROOM
(PRCODE, AFACCTNO, CODEID, ROOMLIMIT, ROOMUSED)
AS 
(
    select pr.prcode, af.afacctno, sec.symbol codeid, sum(sec.roomlimit) roomlimit, sum(sec.roomused) roomused
    from prmaster pr, prafmap af, prsecmap sec
    where pr.prcode = sec.prcode
          and pr.prcode = af.prcode
          and af.status ='A'
          and sec.status ='A'
    group by af.afacctno, sec.symbol, pr.prcode
)
/
