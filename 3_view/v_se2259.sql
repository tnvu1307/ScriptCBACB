SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW V_SE2259
(ACCTNO, SYMBOL, AFACCTNO, DTOCLOSE, BLOCKTRANFER, 
 CODEID, PARVALUE, SELASTDATE, AFLASTDATE, LASTDATE, 
 CUSTODYCD, FULLNAME, IDCODE, TYPENAME, TRADEPLACE, 
 SENDPBALANCE, SENDAMT, SENDAQTTY, RIGHTQTTY, QTTY, 
 MCUSTODYCD)
AS 
(SELECT SUBSTR(SEMAST.ACCTNO,1,4)
    || '.'
    || SUBSTR(SEMAST.ACCTNO,5,6)
    || '.'
    || SUBSTR(SEMAST.ACCTNO,11,6) ACCTNO,
    SYM.SYMBOL,
    SUBSTR(SEMAST.AFACCTNO,1,4)
    || '.'
    || SUBSTR(SEMAST.AFACCTNO,5,6) AFACCTNO,
    SEMAST.EXTRANFER DTOCLOSE,
    SEMAST.BLOCKTRANFER BLOCKTRANFER,
    SEMAST.CODEID,
    SYM.PARVALUE,
    SEMAST.LASTDATE SELASTDATE,
    AF.LASTDATE AFLASTDATE,
    NVL(SEMAST.LASTDATE,AF.LASTDATE) LASTDATE,
    CF.CUSTODYCD,
    CF.FULLNAME,
    CF.IDCODE,
    TYP.TYPENAME,
    A1.CDCONTENT TRADEPLACE,
    NVL(SENDPBALANCE,0) SENDPBALANCE ,
    NVL(SENDAMT,0) SENDAMT ,
    NVL(SENDAQTTY,0) SENDAQTTY,
    NVL(RIGHTQTTY,0) RIGHTQTTY ,
    NVL(QTTY,0) QTTY,
    CF.MCUSTODYCD
  FROM
    (SELECT ACCTNO,
      ACTYPE,
      CODEID,
      AFACCTNO,
      OPNDATE,
      CLSDATE,
      LASTDATE,
      STATUS,
      PSTATUS,
      IRTIED,
      IRCD,
      COSTPRICE,
      TRADE,
      MORTAGE,
      MARGIN,
      NETTING,
      STANDING,
      WITHDRAW,
      DEPOSIT,
      LOAN,
      BLOCKED,
      RECEIVING,
      TRANSFER,
      PREVQTTY,
      DCRQTTY,
      DCRAMT,
      DEPOFEEACR,
      REPO,
      PENDING,
      TBALDEPO,
      CUSTID,
      COSTDT,
      SECURED,
      ICCFCD,
      ICCFTIED,
      TBALDT,
      SENDDEPOSIT,
      SENDPENDING,
      DDROUTQTTY,
      DDROUTAMT,
      DTOCLOSE,
      SDTOCLOSE,
      QTTY_TRANSFER,
      LAST_CHANGE,
      DEALINTPAID,
      WTRADE,
      GRPORDAMT,
      EXTRANFER,
      BLOCKTRANFER
    FROM SEMAST
    UNION ALL -- union them nhung tk co CA cho ve ma ko co SEMAST
    SELECT DISTINCT(schd.afacctno
      ||schd.codeid) acctno,
      NULL,
      schd.CODEID,
      schd.AFACCTNO,
      NULL,
      NULL,
      NULL,
      'N',
      NULL,
      NULL,
      NULL,
      NULL,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      af.custid,
      NULL,
      0,
      NULL,
      NULL,
      NULL,
      0,0,0,0,0,0,0,
      NULL,
      NULL,
      NULL,
      NULL,
      0,
      0
    FROM
      (SELECT afacctno,codeid FROM caschd WHERE deltd='N'
      UNION ALL
      SELECT afacctno,
        tocodeid codeid
      FROM caschd,
        camast
      WHERE caschd.camastid=camast.camastid
      AND caschd.deltd     ='N'
      AND catype          IN ('017','020','023')
      ) schd,
      afmast af
    WHERE (afacctno,codeid) NOT IN
      (SELECT afacctno,codeid FROM semast
      )
    AND af.acctno=schd.afacctno
    )SEMAST,
    SBSECURITIES SYM,
    AFMAST AF,
    AFTYPE TYP,
    CFMAST CF,
    ALLCODE A1,
    (SELECT *
    FROM
      (SELECT schd.codeid,
        schd.afacctno,
        (schd.afacctno
        ||schd.codeid) seacctno,
        SUM(schd.CUTPBALANCE) SENDPBALANCE ,
        SUM(schd.CUTAMT) SENDAMT ,
        SUM(CUTAQTTY) SENDAQTTY,
        SUM(
        CASE
          WHEN (ca.catype IN ('005','006','022'))
          THEN schd.CUTQTTY
          ELSE 0
        END) RIGHTQTTY,
        SUM(
        CASE
          WHEN (ca.catype NOT IN ('005','006','022'))
          THEN schd.CUTQTTY
          ELSE 0
        END) QTTY
      FROM
        (SELECT schd.status,
          camast.catype,
          camast.duedate,
          camast.status castatus,
          schd.afacctno,
          camast.codeid,
          camast.tocodeid,
          schd.camastid,
          schd.balance,
          schd.qtty,
          schd.aqtty,
          schd.amt,
          schd.aamt,
          schd.pbalance,
          schd.pqtty ,
          schd.isci,
          schd.isexec ,
          CUTPBALANCE,
          CUTAMT,
          CUTAQTTY,
          (
          CASE
            WHEN (catype IN ('017','020','023'))
            THEN 0
            ELSE CUTQTTY
          END )CUTQTTY
        FROM caschd schd ,
          camast
        WHERE schd.camastid=camast.camastid
        AND schd.deltd     ='N'
        AND camast.deltd   ='N'
        AND camast.status <> 'C'
        UNION ALL
        SELECT schd.status,
          camast.catype,
          camast.duedate,
          camast.status castatus,
          schd.afacctno,
          camast.tocodeid codeid,
          '',
          schd.camastid,
          0,
          schd.qtty,
          0,0,0,0,0,
          schd.isci,
          schd.isexec ,
          0,0,0,
          CUTQTTY
        FROM caschd schd,
          camast
        WHERE schd.camastid=camast.camastid
        AND camast.catype IN ('017','020','023')
        AND schd.deltd     ='N'
        AND camast.deltd   ='N'
        AND camast.status <> 'C'
        ) schd,
        camast ca
      WHERE schd.camastid=ca.camastid
      GROUP BY (schd.afacctno,schd.codeid)
      )
    WHERE SENDPBALANCE+SENDAMT+SENDAQTTY+RIGHTQTTY+QTTY>0
    ) schd
  WHERE A1.CDTYPE                                  = 'SA'
  AND A1.CDNAME                                    = 'TRADEPLACE'
  AND A1.CDVAL                                     = SYM.TRADEPLACE
  AND CF.CUSTID                                    =AF.CUSTID
  AND SYM.CODEID                                   = SEMAST.CODEID
  AND SEMAST.AFACCTNO                              = AF.ACCTNO
  AND TYP.ACTYPE                                   =AF.ACTYPE
  AND SEMAST.STATUS                                ='T'
  AND (NVL(SEMAST.EXTRANFER,0)                     > 0
  OR (SENDPBALANCE+SENDAMT+SENDAQTTY+RIGHTQTTY+QTTY>0))
  AND semast.acctno                                =schd.seacctno(+)
  )
/
