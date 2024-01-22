SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW V_SE2257
(ACCTNO, SYMBOL, AFACCTNO, TRADE, BLOCKED, 
 CODEID, PARVALUE, SELASTDATE, AFLASTDATE, LASTDATE, 
 CUSTODYCD, MCUSTODYCD, FULLNAME, IDCODE, TYPENAME, 
 TRADEPLACE, MINVAL, MAXVAL, REFCUSTODYCD, REFINWARD, 
 RIGHTQTTY, RIGHTOFFQTTY, CAQTTYRECEIV, CAQTTYDB, CAAMTRECEIV, 
 MORTAGE, STANDING)
AS 
(
    SELECT SUBSTR(SEMAST.ACCTNO,1,4) || '.' || SUBSTR(SEMAST.ACCTNO,5,6) || '.' || SUBSTR(SEMAST.ACCTNO,11,6) ACCTNO,
           SYM.SYMBOL, SUBSTR(SEMAST.AFACCTNO,1,4) || '.' || SUBSTR(SEMAST.AFACCTNO,5,6) AFACCTNO, SEMAST.TRADE TRADE,
           SEMAST.BLOCKED BLOCKED,SEMAST.CODEID, SYM.PARVALUE, SEMAST.LASTDATE SELASTDATE, AF.LASTDATE AFLASTDATE,
           NVL(SEMAST.LASTDATE,AF.LASTDATE) LASTDATE, CF.CUSTODYCD, CF.MCUSTODYCD,CF.FULLNAME, CF.IDCODE, TYP.TYPENAME, A1.CDCONTENT TRADEPLACE,
           0 minval, 999999999 maxval,
           SENDSETOCLOSE.REFCUSTODYCD,SENDSETOCLOSE.REFINWARD, nvl(SCHD.RIGHTQTTY,0) RIGHTQTTY,nvl(SCHD.RIGHTOFFQTTY,0) RIGHTOFFQTTY,
           nvl(SCHD.CAQTTYRECEIV,0)CAQTTYRECEIV, NVL((CASE WHEN SCHD.ISDBSEALL=1 THEN SEMAST.TRADE ELSE SCHD.CAQTTYDB END),0) CAQTTYDB,
           nvl(schd.CAAMTRECEIV,0) CAAMTRECEIV, SEMAST.MORTAGE, SEMAST.STANDING -- 28/11/2013 ANTB Them SEMAST.MORTAGE, SEMAST.STANDING
FROM (SELECT ACCTNO,ACTYPE,CODEID,AFACCTNO,OPNDATE,CLSDATE,LASTDATE,STATUS,PSTATUS,IRTIED,IRCD,COSTPRICE,TRADE,MORTAGE,MARGIN,
             NETTING,STANDING,WITHDRAW,DEPOSIT,LOAN,BLOCKED,RECEIVING,TRANSFER,PREVQTTY,DCRQTTY,DCRAMT,DEPOFEEACR,REPO,
             PENDING,TBALDEPO,CUSTID,COSTDT,SECURED,ICCFCD,ICCFTIED,TBALDT,SENDDEPOSIT,SENDPENDING,DDROUTQTTY,DDROUTAMT,DTOCLOSE,
             SDTOCLOSE,QTTY_TRANSFER,LAST_CHANGE,DEALINTPAID,WTRADE,GRPORDAMT
      FROM SEMAST
      UNION ALL -- union them nhung tk co CA cho ve ma ko co SEMAST
      SELECT DISTINCT(SCHD.AFACCTNO||SCHD.CODEID) ACCTNO,NULL,SCHD.CODEID, SCHD.AFACCTNO,NULL,NULL,NULL,'A',NULL,NULL,NULL,NULL,
             0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
            AF.CUSTID,NULL,0,NULL,NULL,NULL,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL
      FROM (
            SELECT AFACCTNO,CODEID FROM CASCHD WHERE DELTD='N'
            UNION ALL
            SELECT AFACCTNO,TOCODEID CODEID FROM CASCHD, CAMAST WHERE CASCHD.CAMASTID=CAMAST.CAMASTID
                                                         AND CASCHD.DELTD='N' AND CATYPE IN ('017','020','023','027')
            ) SCHD,AFMAST AF
      WHERE NOT EXISTS (SELECT AFACCTNO,CODEID FROM SEMAST SE WHERE SE.AFACCTNO = SCHD.AFACCTNO AND SE.CODEID = SCHD.CODEID)
            AND AF.ACCTNO=SCHD.AFACCTNO) SEMAST, SBSECURITIES SYM,
    (
        SELECT * FROM afmast af1
        WHERE NOT EXISTS (SELECT * FROM afmast af2 WHERE af2.custid = af1.custid and af2.status IN ('N','C'))
    ) AF, AFTYPE TYP, CFMAST CF,ALLCODE A1, --, FEEMASTER FT, FEEMAP FM,
    (
        SELECT * FROM SENDSETOCLOSE where deltd='N'
    ) SENDSETOCLOSE,
(SELECT max(codeid)codeid,max(afacctno) afacctno,max(ISDBSEALL) ISDBSEALL,max(schd.seacctno)seacctno,
SUM(RIGHTOFFQTTY) RIGHTOFFQTTY,SUM(CAQTTYRECEIV) CAQTTYRECEIV,
SUM(CAQTTYDB) CAQTTYDB,SUM(CAAMTRECEIV) CAAMTRECEIV,SUM(RIGHTQTTY) RIGHTQTTY,
SUM(CASE WHEN ISWFT='N' THEN CAQTTYRECEIV ELSE 0 END ) CARECEIVING
FROM
(SELECT
    schd.codeid, schd.afacctno,(schd.afacctno||schd.codeid) seacctno,
   (CASE WHEN (schd.catype='014' AND schd.castatus NOT IN ('A','P','N','C') AND schd.duedate >=sys.CURRDATE )
      THEN schd.pbalance ELSE 0 END) RIGHTOFFQTTY,
   (CASE WHEN (schd.catype='014' AND schd.status IN ('M','S','I','G','O','W','F') AND isse='N' ) THEN schd.qtty
       WHEN (schd.catype IN ('017','020','023') AND schd.status IN ('G','S','I','O','W','V') AND isse='N' AND istocodeid='Y' ) THEN schd.qtty
       WHEN (schd.catype IN ('011','021') AND schd.status  IN ('G','S','I','O','W') AND isse='N' ) THEN schd.qtty
       ELSE 0 END) CAQTTYRECEIV,
   (CASE WHEN (schd.catype IN ('017','020','023','027') AND schd.status  IN ('G','S','I','O','W') AND isse='N') THEN schd.aqtty
         ELSE 0 END) CAQTTYDB, --- SL CK cho giam
  ( CASE  WHEN (schd.catype IN ('016') AND schd.status  IN ('G','S','I','O','W')) AND isse='N' THEN 1 ELSE 0 END) ISDBSEALL,
  (CASE WHEN  (schd.status  IN ('H','S','I','O','W','K','V')AND isci='N' AND schd.isexec='Y') THEN schd.amt ELSE 0 END) CAAMTRECEIV,
  (CASE WHEN (schd.catype IN ('005','006','022') AND schd.status IN ('H','G','S','I','J','O','W') AND isse='N') THEN schd.rqtty ELSE 0 END) RIGHTQTTY,
  iswft

    FROM
          (SELECT schd.rqtty,schd.status,camast.catype,camast.duedate,camast.status castatus,schd.afacctno,camast.codeid,
           camast.tocodeid, schd.camastid,schd.balance,schd.qtty,schd.aqtty,
           --(case when camast.catype IN ('010') Then (nvl(cad.execrate, camast.exerate)/100 * schd.amt)
           (case when camast.catype IN ('010') Then ((nvl(cad.execrate,0) + camast.exerate)/100 * schd.amt)
                else  schd.amt end) amt,
           schd.aamt,schd.pbalance,schd.pqtty ,
           schd.isci,schd.isexec ,'N' istocodeid,NVL(ISWFT,'Y') ISWFT,schd.isse
           FROM caschd schd, camast,
                (
                    select * from camastdtl cad1 where cad1.deltd <> 'Y' and cad1.status ='P'
                ) cad
           WHERE schd.camastid=camast.camastid
                 and schd.camastid=cad.camastid (+)
                 AND schd.deltd='N' AND camast.deltd='N' AND camast.status <> 'C'
           UNION ALL
           SELECT schd.rqtty, schd.status,camast.catype,camast.duedate,camast.status castatus,schd.afacctno, camast.tocodeid codeid,
           '',schd.camastid,0,schd.qtty,0,0,0,0,0,
            schd.isci,schd.isexec ,'Y' istocodeid, NVL(ISWFT,'Y') ISWFT,schd.isse
           FROM caschd schd, camast
           WHERE schd.camastid=camast.camastid AND camast.catype IN ('017','020','023') AND schd.deltd='N' AND camast.deltd='N' AND camast.status <> 'C'
           ) SCHD, (select to_date(varvalue,'DD/MM/RRRR') CURRDATE from sysvar WHERE GRNAME = 'SYSTEM' AND VARNAME ='CURRDATE') sys
         ) schd
         GROUP BY (codeid, afacctno) ) schd
WHERE A1.CDTYPE = 'SA' AND A1.CDNAME = 'TRADEPLACE' AND A1.CDVAL = SYM.TRADEPLACE
AND CF.CUSTID =AF.CUSTID AND SYM.CODEID = SEMAST.CODEID AND SEMAST.AFACCTNO= AF.ACCTNO and sym.sectype <> '004'
AND TYP.ACTYPE=AF.ACTYPE AND AF.status not in ('N','C')
--and ft.feecd = fm.feecd and ft.status = 'Y'
--and fm.tltxcd = '2257'
--toannds bo semast.deposit,semast.senddeposit
and (abs(semast.netting)+semast.receiving- nvl(schd.CARECEIVING,0)  )=0
--toannds bo semast.withdraw,semast.mortage
and (semast.trade +semast.blocked+ semast.deposit+semast.senddeposit+
nvl(SCHD.RIGHTQTTY,0) +nvl(SCHD.CAQTTYRECEIV,0)+nvl(SCHD.RIGHTOFFQTTY,0)+
NVL((CASE WHEN SCHD.ISDBSEALL=1 THEN SEMAST.TRADE ELSE SCHD.CAQTTYDB END),0)+
nvl(schd.CAAMTRECEIV,0)) >0
and af.CUSTID=sendsetoclose.CUSTID(+)
AND semast.acctno=schd.seacctno(+) )
/
