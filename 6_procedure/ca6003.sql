SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE ca6003(
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   I_DATE                 IN       VARCHAR2, /*REPORT DATE */
   P_CUSTODYCD               IN       VARCHAR2 /*CUSTODYCD */
   )
IS
    -- UNINSTRUCTED EVENTS REPORT
    -- PERSON      DATE                 COMMENTS
    -- ---------   ------               -------------------------------------------
    -- THOAI.TRAN    12-11-2019           CREATED
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0

    V_REPORTDATE          DATE;
    V_CUSTODYCD         VARCHAR2(20);
BEGIN
     V_STROPTION := OPT;
     IF V_STROPTION = 'A' THEN
        V_STRBRID := '%';
     ELSIF V_STROPTION = 'B' THEN
        V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
     ELSE
        V_STRBRID:=BRID;
     END IF;
    V_CUSTODYCD  := REPLACE(P_CUSTODYCD ,'.','');
    V_REPORTDATE  := TO_DATE(I_DATE, SYSTEMNUMS.C_DATE_FORMAT);

OPEN PV_REFCURSOR FOR
    SELECT MST.*
    FROM
      (
        SELECT CF.FULLNAME FUNDNAME
        ,CF.CIFID   CIFID
        ,CF.CUSTODYCD STC
        ,SB.SYMBOL  SYMBOL
        ,SB.ISINCODE    SBISIN
        ,(CASE WHEN CA.CATYPE ='014' THEN CA.OPTSYMBOL ELSE '' END) RIGHTCODE -- MA QUYEN MUA --TRUNG.LUU: 26/11/2020 SHBVNEX-1359
        ,(CASE WHEN CA.CATYPE ='014' THEN CA.optisincode ELSE '' END)    CAISIN
        , TO_CHAR(V_REPORTDATE,'DD - FMMONTH - YYYY')  REPORTDATE
        , TO_CHAR(CA.REPORTDATE,'DD/MM/YYYY')  RECORDDATE
        , A1.EN_CDCONTENT CATYPE--(CASE WHEN CA.CATYPE ='014' THEN 'RIGHT ISSUE' ELSE 'CONVERT TO BOND ' END)   CATYPE
        ,CA.CAMASTID    EVENTNO
        ,TO_CHAR(CA.INSDEADLINE,'DD/MM/YYYY')     DUEDATE
        ,TO_CHAR(GETPREVDATE(CA.INSDEADLINE, 5),'DD/MM/YYYY')            DUEDATE5
        ,TO_CHAR(GETPREVDATE(CA.INSDEADLINE, 2),'DD/MM/YYYY')            DUEDATE2
        ,(CASE WHEN CA.CATYPE ='014' THEN CAS.TRADE ELSE CAS.TRADE END) BALANCE
        ,(CASE WHEN CA.CATYPE ='014' THEN CAS.BALANCE ELSE CAS.TRADE-CAS.BALANCE END)       SUBCRIBE             --QTTY
        ,(CASE WHEN CA.CATYPE ='014' THEN NVL(CACAN.qtty,0)
            ELSE ROUND(NVL(CAS.QTTYCANCEL,0)*TO_NUMBER(SUBSTR(CA.EXRATE,0,INSTR(CA.EXRATE,'/')-1))/TO_NUMBER(SUBSTR(CA.EXRATE,INSTR(CA.EXRATE,'/')+1, LENGTH(CA.EXRATE)-INSTR(CA.EXRATE,'/'))))
        END) LAPSE
        ,(CASE WHEN CA.CATYPE ='014' THEN SE.AMT ELSE CAS.INBALANCE END)BUY
        ,CAS.OUTBALANCE SELL
        ,(CASE WHEN CA.CATYPE ='014' THEN CAS.TRADE-CAS.BALANCE
        - ROUND(NVL(CAR.CANCELQTTY,0)*TO_NUMBER(SUBSTR(CA.RIGHTOFFRATE,0,INSTR(CA.RIGHTOFFRATE,'/')-1))
        /TO_NUMBER(SUBSTR(CA.RIGHTOFFRATE,INSTR(CA.RIGHTOFFRATE,'/')+1,
        LENGTH(CA.RIGHTOFFRATE)-INSTR(CA.RIGHTOFFRATE,'/'))))
        +nvl(SE.AMT,0)-CAS.OUTBALANCE
        ELSE CAS.BALANCE - ROUND(NVL(CAS.QTTYCANCEL,0)*TO_NUMBER(SUBSTR(CA.EXRATE,0,INSTR(CA.EXRATE,'/')-1))
        /TO_NUMBER(SUBSTR(CA.EXRATE,INSTR(CA.EXRATE,'/')+1,
        LENGTH(CA.EXRATE)-INSTR(CA.EXRATE,'/')))) + CAS.INBALANCE-CAS.OUTBALANCE END) REMAININGBALANCE
        --DUOC MUA (QUYEN MUA)
        --trung.luu: 26-11-2020 SHBVNEX-1359
        --,(CASE WHEN CA.CATYPE='023' THEN '0' ELSE TO_CHAR(UTILS.SO_THANH_CHU(CAS.QTTY)) END)   PURCHASEQUANTITY
        ,
        /*case when ca.catype in ('023') then (case when MAX(cas.status) in ('S') then UTILS.SO_THANH_CHU2(cas.qtty)
                                                 when max(ca.status) = 'V' and max(cas.status) ='V' then
                                                       (case when max(cas.ISREGIS) = 'C' then UTILS.SO_THANH_CHU2(cas.qtty) else UTILS.SO_THANH_CHU2(0) end )
                            else UTILS.SO_THANH_CHU2(cas.balance) end)
            else UTILS.SO_THANH_CHU2(cas.pbalance+cas.balance) end PURCHASEQUANTITY*/
           CAS.QTTY PURCHASEQUANTITY --TRUNG.LUU: 07-01-2021 SHBVNEX-1359 KHACH HANG COMMENT KEU SUA LAI
        FROM
        /*(
            SELECT CA.CODEID,CA.OPTSYMBOL,CA.ISINCODE,CA.REPORTDATE,CA.CATYPE,CA.CAMASTID,CA.INSDEADLINE,
            TO_NUMBER(SUBSTR(CA.RIGHTOFFRATE,0,INSTR(CA.RIGHTOFFRATE,'/')-1))
        /TO_NUMBER(SUBSTR(CA.RIGHTOFFRATE,INSTR(CA.RIGHTOFFRATE,'/')+1,
        LENGTH(CA.RIGHTOFFRATE)-INSTR(CA.RIGHTOFFRATE,'/'))) RIGHTOFFRATE
            ,TO_NUMBER(SUBSTR(CA.EXRATE,0,INSTR(CA.EXRATE,'/')-1))
        /TO_NUMBER(SUBSTR(CA.EXRATE,INSTR(CA.EXRATE,'/')+1,
        LENGTH(CA.EXRATE)-INSTR(CA.EXRATE,'/'))) EXRATE
            FROM CAMAST CA
            WHERE V_REPORTDATE BETWEEN CA.REPORTDATE AND CA.INSDEADLINE
        )*/
        CAMAST CA,(select CACAN.camastid,CACAN.custodycd,sum(CACAN.qtty) qtty from CACANCEL CACAN group by CACAN.camastid,CACAN.custodycd) CACAN
        ,
        (
            SELECT CAS.CAMASTID,
            CAS.AFACCTNO,
            SUM(CAS.BALANCE) BALANCE ,
            SUM(CAS.PBALANCE) PBALANCE ,
            SUM(CAS.QTTYCANCEL ) QTTYCANCEL,
            SUM(CAS.AQTTY) AQTTY,
            SUM(CAS.INBALANCE)INBALANCE,
            SUM(CAS.OUTBALANCE) OUTBALANCE,
            SUM(CAS.QTTY)   QTTY,
            SUM(CAS.PQTTY) PQTTY,
            SUM(CAS.TRADE) TRADE,
            max(cas.STATUS) STATUS,
            max(cas.ISREGIS)ISREGIS
            FROM CASCHD CAS
            WHERE  CAS.STATUS  NOT IN ('P','N') --trung.luu: 13-01-2021 SHBVNEX-1359 doi test comment keu bo trang thai 'H' ra khoi dieu kien
            GROUP BY CAS.CAMASTID, CAS.AFACCTNO
        )CAS,
        (
            SELECT CAMASTID, SUM(CANCELQTTY) CANCELQTTY  FROM CAREGISTER
            WHERE CUSTODYCD LIKE V_CUSTODYCD
            GROUP BY CAMASTID
        )CAR,
        (
           /* SELECT CUSTODYCD,AFACCTNO,CODEID,NAMT FROM VW_SETRAN_GEN
            WHERE CUSTODYCD LIKE V_CUSTODYCD
            AND TXTYPE='C' AND FIELD='TRADE'*/
            SELECT CAT.CAMASTID,CAT.CODEID,CAT.OPTCODEID,CAT.AMT,CAT.TOACCTNO,CAT.TXDATE
            FROM SEMAST SE, CATRANSFER CAT
            WHERE  SE.ACCTNO=CAT.OPTSEACCTNOCR
            AND CAT.STATUS IN ('C')
        )SE
         ,SBSECURITIES SB,CFMAST CF, AFMAST AF, DDMAST DD, --,CATRANSFER CAM
         (
            SELECT * FROM ALLCODE WHERE CDTYPE = 'CA' AND CDNAME = 'CATYPE'
         )A1
        WHERE CA.CAMASTID =CAS.CAMASTID
        AND CA.CAMASTID =CAR.CAMASTID (+)
        AND CA.CAMASTID = CACAN.CAMASTID(+)
        AND CA.CAMASTID=SE.CAMASTID (+)
        AND CA.CODEID =SE.CODEID  (+)
        AND CA.OPTCODEID =SE.OPTCODEID  (+)
        AND CF.CUSTODYCD=SE.TOACCTNO (+)
        AND CA.CODEID=SB.CODEID
        AND CF.CUSTID=AF.CUSTID AND AF.ACCTNO=DD.AFACCTNO
        AND DD.AFACCTNO=CAS.AFACCTNO
        AND CA.CATYPE IN ('014','023')
        AND CA.STATUS IN ('S','M','G','H','I','J','W','K','V')  --TRUNG.LUU: 30-11-2020 SHBVNEX-1359
       -- AND SE.TXDATE BETWEEN CA.REPORTDATE AND CA.INSDEADLINE
        --AND V_REPORTDATE BETWEEN CA.REPORTDATE AND CA.INSDEADLINE TRUNG.LUU: 30-11-2020 SHBVNEX-1359 KHONG DUNG DIEU KIEN NGAY
        and cf.custodycd = CACAN.custodycd(+)
        AND CF.CUSTODYCD LIKE V_CUSTODYCD
        AND CA.CATYPE = A1.CDVAL
        GROUP BY CF.FULLNAME,CF.CIFID,CF.COUNTRY,CF.CUSTODYCD,CF.TRADINGCODE,SB.SYMBOL,CAS.PBALANCE,CAS.PQTTY,SB.ISINCODE ,CA.OPTSYMBOL, CA.OPTISINCODE , CA.REPORTDATE
        ,CA.CATYPE,CA.CAMASTID, CA.INSDEADLINE,CAS.BALANCE ,CAS.AQTTY,CAS.TRADE,CAS.QTTY ,SE.AMT ,CAS.QTTYCANCEL,CAR.CANCELQTTY ,CAS.INBALANCE ,CAS.OUTBALANCE,CA.EXRATE,CA.RIGHTOFFRATE
        ,A1.EN_CDCONTENT,CACAN.qtty,CA.ISINCODE
    )MST
    WHERE MST.BUY <> 0 OR MST.BALANCE <> 0;
EXCEPTION
  WHEN OTHERS
   THEN
      PLOG.ERROR ('CA6003: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RETURN;
END;
/
