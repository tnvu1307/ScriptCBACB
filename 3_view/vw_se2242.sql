SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_SE2242
(LOCATION, ACTYPE, ACCTNO, TYPENAME, CODEID, 
 SYMBOL, AFACCTNO, OPNDATE, CLSDATE, LASTDATE, 
 STATUS, PSTATUS, IRTIED, ICCFTIED, IRCD, 
 COSTPRICE, TRADE, ORGAMT, TRADEWTF, ORGTRADEWTF, 
 MORTAGE, MARGIN, NETTING, STANDING, WITHDRAW, 
 DEPOSIT, TRANSFER, LOAN, CUSTID, COSTDT, 
 BLOCKED, BLOCKED_CHK, RECEIVING, PARVALUE, CUSTODYCD, 
 AUTOID, IDCODE, FULLNAME, IDDATE, IDPLACE, 
 ADDRESS, ACCTNOAFMAST)
AS 
SELECT FN_GET_LOCATION(af.BRID) LOCATION, actype,
          SUBSTR (semast.acctno, 1, 4)
       || '.'
       || SUBSTR (semast.acctno, 5, 6)
       || '.'
       || SUBSTR (semast.acctno, 11, 6) acctno,AFT.TYPENAME,
       sym.codeid codeid, sym.symbol symbol,
       SUBSTR (semast.afacctno, 1, 4) || '.' || SUBSTR (semast.afacctno, 5, 6) afacctno,
       opndate, clsdate, lastdate, a1.cdcontent status, pstatus,
       a2.cdcontent irtied, a3.cdcontent iccftied, ircd, costprice,

	   --semast.trade,
	   least(trade -NVL(od.secureamt,0),GETAVLSEWITHDRAW(seMAST.acctno)) trade,
       trade ORGAMT,
       nvl(pit.qtty,0) tradewtf, nvl(pit.qtty,0) ORGTRADEWTF, (mortage ) mortage, margin, netting, standing, withdraw, deposit, transfer, loan,
       SUBSTR (custid, 1, 4) || '.' || SUBSTR (custid, 5, 6) custid, costdt,
       nvl(semast.blocked,0) blocked, semast.blocked blocked_chk, receiving, sym.parvalue, cf.custodycd, '0' autoid,
       cf.idcode,  cf.fullname, cf.iddate, cf.idplace, cf.ADDRESS,af.acctnoafmast
  FROM sbsecurities sym, allcode a1, allcode a2, allcode a3,
    (select custodycd, custid custidcfmast, idcode,fullname, iddate, idplace,ADDRESS  from cfmast) cf,
    (select brid,ACTYPE AFTYPE, custid custidafmast, acctno acctnoafmast from afmast WHERE STATUS NOT IN ('C')) af,
    (SELECT ACTYPE AFTYPE, TYPENAME FROM AFTYPE) AFT,
     semast,
     (SELECT    seacctno seacctno,
        SUM (case when od.exectype IN ('NS', 'SS') then remainqtty + execqtty else 0 end)  secureamt,
        SUM (case when od.exectype ='MS' then remainqtty + execqtty else 0 end)  securemtg
        FROM odmast od
        WHERE deltd <> 'Y' AND od.exectype IN ('NS', 'SS','MS')
        and txdate = (select to_date(VARVALUE,'DD/MM/YYYY') from sysvar where grname='SYSTEM' and varname='CURRDATE')
		group by seacctno
     ) od,
(select acctno,sum(qtty-mapqtty) qtty
    from sepitlog where deltd <> 'Y' and qtty-mapqtty>0
    group by acctno) pit

 WHERE a1.cdtype = 'SE'
   AND a1.cdname = 'STATUS'
   AND a1.cdval = semast.status
   AND a2.cdtype = 'SY'
   AND a2.cdname = 'YESNO'
   AND a2.cdval = irtied
   AND sym.codeid = semast.codeid
   AND sym.sectype <> '004'
   AND a3.cdtype = 'SY'
   AND a3.cdname = 'YESNO'
   AND a3.cdval = semast.iccftied
   AND semast.afacctno = af.acctnoafmast
   and af.custidafmast = cf.custidcfmast
   AND AF.AFTYPE = AFT.AFTYPE
   AND nvl(semast.blocked,0) + trade > 0
   and semast.acctno =pit.acctno(+)
   AND seMAST.acctno = od.seacctno(+)
/
