SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE ca6019 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,

   P_CACODE       IN       VARCHAR2,
   P_CUSTODYCD    IN       VARCHAR2
)
IS
    --TRI.BUI 29/06/2020
    RE_DATE       VARCHAR2 (20);
    CRE_DATE       VARCHAR2 (50);
    V_CACODE       VARCHAR2 (20);
    V_CUSTODYCD    VARCHAR2 (50);
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0
BEGIN
    V_STROPTION := OPT;
    IF V_STROPTION = 'A' THEN
        V_STRBRID := '%';
    ELSIF V_STROPTION = 'B' THEN
        V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
    ELSE
        V_STRBRID:= BRID;
    END IF;
    V_CACODE := P_CACODE;
    -----
    IF UPPER(P_CUSTODYCD) ='ALL'
    THEN
        V_CUSTODYCD := '%';
    ELSE
        V_CUSTODYCD := P_CUSTODYCD;
    END IF;
    -----
    SELECT TO_CHAR(GETCURRDATE,'DD Mon RRRR') INTO RE_DATE FROM DUAL;
    SELECT TO_CHAR(SYSDATE,'DD/MM/YYYY HH:MI:SS AM') INTO CRE_DATE  FROM DUAL;
--==============MAIN QUERY================
 OPEN PV_REFCURSOR
 FOR

    SELECT --DISTINCT
        RE_DATE AS REPORT_DATE,
        CRE_DATE AS DATE_TIME,
        CA.CAMASTID,
        A2.EN_CDCONTENT PURPOSEDESC,
        DD.REFCASAACCT,
        -----------------------------------------------------ACTIONDATE
        CASE
            WHEN CA.CATYPE IN ('014') AND CAS.QTTY > 0 AND CAS.ISSE='Y'  THEN CA.ACTIONDATE --3341 RIGHT ISSUE

            WHEN CA.CATYPE IN ('011','021') THEN --3341,3342 --STOCK DEVIDEND, BONUS ISSUE
                 CASE
                    WHEN CAS.QTTY > 0 AND  CAS.ISSE='Y' AND CAS.ISCI='Y'  THEN CA.ACTIONDATE --3341,3342
                    WHEN CAS.QTTY > 0 AND  CAS.ISSE='Y' THEN CA.ACTIONDATE --3341
                    ELSE NULL
                 END
            WHEN CA.CATYPE IN ('010','015','016','024','027','033') AND CAS.AMT1 > 0 AND CAS.ISCI='Y'  THEN CA.ACTIONDATE --3342 CASH DIVIDEND,BOND COUPON,BOND COUPONS AND REDEMPTION,COVERED WARRANT PAYMENT,LIQUIDATION

            WHEN CA.CATYPE IN ('017','020') AND CA.CANCELSTATUS ='Y' AND CAS.AQTTY > 0 THEN --3342,3345,3346 BOND CONVERSION-MANDATORY,SHARE CONVERSION
                 CASE
                    WHEN CAS.QTTY > 0 AND CAS.ISSE='Y' AND CAS.ISCI='Y' AND CAS.AMT1 > 0  THEN CA.ACTIONDATE --3342,3345,3346
                    WHEN CAS.QTTY > 0 AND CAS.ISSE='Y' AND CAS.AMT1 = 0 THEN CA.ACTIONDATE --3345,3346
                    ELSE NULL
                 END

            WHEN CA.CATYPE IN ('023')  THEN --3342,3345,3346 BOND CONVERSION-VOLUNTARY
                 CASE
                    WHEN CA.CANCELSTATUS ='Y' AND CAS.AQTTY > 0 AND CAS.QTTY > 0  AND CAS.ISSE='Y'  THEN CA.ACTIONDATE --3345,3346 CO DANG KY CHUYEN DOI
                    WHEN CA.CANCELSTATUS ='Y' AND CAS.AQTTY > 0 AND CAS.QTTY > 0  AND CAS.ISSE='Y' AND CAS.ISCI='Y' THEN CA.ACTIONDATE --3342,3345,3346 CO DANG KY CHUYEN DOI,CO TRA TIEN CHO PHAN KHONG DANG KY
                    WHEN CAS.QTTY = 0 AND CAS.ISCI='Y' THEN CA.ACTIONDATE --3342--KHONG DANG KY
                    ELSE NULL
                 END

            ELSE NULL
        END ACTIONDATE,
        -----------------------------------------------------CA.REPORTDATE
        CASE
            WHEN CA.CATYPE IN ('014') AND CAS.QTTY > 0 AND CAS.ISSE='Y'  THEN CA.REPORTDATE --3341

            WHEN CA.CATYPE IN ('011','021') THEN --3341,3342 --STOCK DEVIDEND, BONUS ISSUE
                 CASE
                    WHEN CAS.QTTY > 0 AND  CAS.ISSE='Y' AND CAS.ISCI='Y'   THEN CA.REPORTDATE --3341,3342
                    WHEN CAS.QTTY > 0 AND CAS.ISSE='Y'   THEN CA.REPORTDATE --3341
                    ELSE NULL
                 END
            WHEN CA.CATYPE IN ('010','015','016','024','027','033') AND CAS.AMT1 > 0 AND CAS.ISCI='Y'  THEN CA.REPORTDATE --3342

            WHEN CA.CATYPE IN ('017','020') AND CA.CANCELSTATUS ='Y' AND CAS.AQTTY > 0 THEN --3342,3345,3346 BOND CONVERSION-MANDATORY,SHARE CONVERSION
                 CASE
                    WHEN CAS.QTTY > 0 AND  CAS.ISSE='Y'  AND CAS.ISCI='Y' AND CAS.AMT1 > 0  THEN CA.REPORTDATE --3342,3345,3346
                    WHEN CAS.QTTY > 0 AND CAS.ISSE='Y' AND CAS.AMT1 = 0  THEN CA.REPORTDATE --3345,3346
                    ELSE NULL
                 END

            WHEN CA.CATYPE IN ('023')  THEN --3342,3345,3346 BOND CONVERSION-VOLUNTARY
                 CASE
                    WHEN CA.CANCELSTATUS ='Y' AND CAS.AQTTY > 0 AND CAS.QTTY > 0  AND CAS.ISSE='Y'  THEN CA.REPORTDATE --3345,3346 CO DANG KY CHUYEN DOI
                    WHEN CA.CANCELSTATUS ='Y' AND CAS.AQTTY > 0 AND CAS.QTTY > 0  AND CAS.ISSE='Y' AND CAS.ISCI='Y' THEN CA.REPORTDATE --3342,3345,3346 CO DANG KY CHUYEN DOI,CO TRA TIEN CHO PHAN KHONG DANG KY
                    WHEN CAS.QTTY = 0 AND CAS.ISCI='Y' THEN CA.REPORTDATE --3342--KHONG DANG KY
                    ELSE NULL
                 END

            ELSE NULL
        END DUEDATE,
        -----------------------------------------------------EXRATE
        CASE
            WHEN CA.CATYPE IN ('010','024','027') AND CA.TYPERATE='R'  THEN CA.DEVIDENTRATE||'%'
            WHEN CA.CATYPE IN ('010','024','027') AND CA.TYPERATE='V'  THEN 'VND '||TO_CHAR(CA.DEVIDENTVALUE,'FM999,999,999,999')||' per unit'
            WHEN CA.CATYPE IN ('011','020')  THEN CA.DEVIDENTSHARES
            WHEN CA.CATYPE IN ('015','016')  THEN CA.INTERESTRATE||'%'
            WHEN CA.CATYPE IN ('014')  THEN CA.RIGHTOFFRATE
            WHEN CA.CATYPE IN ('017','021','023')  THEN CA.EXRATE
            WHEN CA.CATYPE IN ('033')  THEN CA.SPLITRATE||'%'
            ELSE NULL
        END PAYMENT_RATIO,
        -----------------------------------------------------SYMBOL
       CASE
            WHEN CA.CATYPE IN ('014') AND CAS.QTTY > 0 AND CAS.ISSE='Y'  THEN SB1.SYMBOL --3341

            WHEN CA.CATYPE IN ('011','021') THEN --3341,3342
                 CASE
                    WHEN CAS.QTTY > 0 AND CAS.ISSE='Y' AND CAS.ISCI='Y'   THEN SB1.SYMBOL --3341,3342 --STOCK DEVIDEND, BONUS ISSUE
                    WHEN CAS.QTTY > 0 AND CAS.ISSE='Y'   THEN SB1.SYMBOL --3341
                    ELSE NULL
                 END
            WHEN CA.CATYPE IN ('010','015','016','024','027','033') AND CAS.AMT1 > 0 AND CAS.ISCI='Y'  THEN SB1.SYMBOL --3342

            WHEN CA.CATYPE IN ('017','020') AND CA.CANCELSTATUS ='Y' AND CAS.AQTTY > 0 THEN --3342,3345,3346 BOND CONVERSION-MANDATORY,SHARE CONVERSION
                 CASE
                    WHEN CAS.QTTY > 0 AND  CAS.ISSE='Y' AND CAS.ISCI='Y' AND CAS.AMT1 > 0  THEN SB1.SYMBOL --3342,3345,3346
                    WHEN CAS.QTTY > 0 AND CAS.ISSE='Y' AND CAS.AMT1 = 0  THEN SB1.SYMBOL --3345,3346
                    ELSE NULL
                 END

            WHEN CA.CATYPE IN ('023')  THEN --3342,3345,3346 BOND CONVERSION-VOLUNTARY
                 CASE
                    WHEN CA.CANCELSTATUS ='Y' AND CAS.AQTTY > 0 AND CAS.QTTY > 0  AND CAS.ISSE='Y'  THEN SB1.SYMBOL --3345,3346 CO DANG KY CHUYEN DOI
                    WHEN CA.CANCELSTATUS ='Y' AND CAS.AQTTY > 0 AND CAS.QTTY > 0  AND CAS.ISSE='Y' AND CAS.ISCI='Y' THEN SB1.SYMBOL --3342,3345,3346 CO DANG KY CHUYEN DOI,CO TRA TIEN CHO PHAN KHONG DANG KY
                    WHEN CAS.QTTY = 0 AND CAS.ISCI='Y' THEN SB1.SYMBOL --3342--KHONG DANG KY
                    ELSE NULL
                 END

            ELSE NULL
        END SYMBOL,
        -----------------------------------------------------SYMBOL
       CASE
          WHEN CA.CATYPE IN ('016','017','020','023') AND CA.CANCELSTATUS ='Y' AND CAS.AQTTY > 0 THEN SB1.SYMBOL --3345
            ELSE NULL
        END WITHDRAWN_SYMBOL,
        -----------------------------------------------------ISINCODE
        CASE
            WHEN CA.CATYPE IN ('014') AND CAS.QTTY > 0 AND CAS.ISSE='Y'  THEN SB1.ISINCODE --3341

            WHEN CA.CATYPE IN ('011','021') THEN --3341,3342 --STOCK DEVIDEND, BONUS ISSUE
                 CASE
                    WHEN CAS.QTTY > 0 AND CAS.ISSE='Y' AND CAS.ISCI='Y'   THEN SB1.ISINCODE --3341,3342
                    WHEN CAS.QTTY > 0 AND CAS.ISSE='Y'   THEN SB1.ISINCODE --3341
                    ELSE NULL
                 END
            WHEN CA.CATYPE IN ('010','015','016','024','027','033') AND CAS.AMT1 > 0 AND CAS.ISCI='Y'  THEN SB1.ISINCODE --3342

            WHEN CA.CATYPE IN ('017','020') AND CA.CANCELSTATUS ='Y' AND CAS.AQTTY > 0 THEN --3342,3345,3346 BOND CONVERSION-MANDATORY,SHARE CONVERSION
                 CASE
                    WHEN CAS.QTTY > 0 AND  CAS.ISSE='Y' AND CAS.ISCI='Y' AND CAS.AMT1 > 0  THEN SB1.ISINCODE --3342,3345,3346
                    WHEN CAS.QTTY > 0 AND CAS.ISSE='Y' AND CAS.AMT1 = 0  THEN SB1.ISINCODE --3345,3346
                    ELSE NULL
                 END

            WHEN CA.CATYPE IN ('023')  THEN --3342,3345,3346 BOND CONVERSION-VOLUNTARY
                 CASE
                    WHEN CA.CANCELSTATUS ='Y' AND CAS.AQTTY > 0 AND CAS.QTTY > 0  AND CAS.ISSE='Y'  THEN SB1.ISINCODE --3345,3346 CO DANG KY CHUYEN DOI
                    WHEN CA.CANCELSTATUS ='Y' AND CAS.AQTTY > 0 AND CAS.QTTY > 0  AND CAS.ISSE='Y' AND CAS.ISCI='Y' THEN SB1.ISINCODE --3342,3345,3346 CO DANG KY CHUYEN DOI,CO TRA TIEN CHO PHAN KHONG DANG KY
                    WHEN CAS.QTTY = 0 AND CAS.ISCI='Y' THEN SB1.ISINCODE --3342--KHONG DANG KY
                    ELSE NULL
                 END

            ELSE NULL
        END ISINCODE,
        -----------------------------------------------------SYMBOL1
        CASE
           WHEN CA.CATYPE IN ('027','033')  THEN 'N/A'
          WHEN  CAS.AMT1 > 0 AND CAS.QTTY = 0 AND CAS.ISCI='Y' AND CAS.ISSE='N'  THEN 'N/A' -- KHONG HIEN THI VOI SKQ CHI PHAN BO TIEN
            ELSE SB.SYMBOL
        END SYMBOL_RECIEVE,
        -----------------------------------------------------ISINCODE
        CASE
            WHEN  CAS.AMT1 > 0 AND CAS.QTTY = 0 AND CAS.ISCI='Y' AND CAS.ISSE='N'  THEN 'N/A' -- KHONG HIEN THI VOI SKQ CHI PHAN BO TIEN
            WHEN CA.CATYPE IN ('027','033')  THEN 'N/A'
            ELSE SB.ISINCODE
        END ISINCODE_RECIEVE,
        -----------------------------------------------------CUSTODYCD
        CASE
            WHEN CA.CATYPE IN ('014') AND CAS.QTTY > 0 AND CAS.ISSE='Y'  THEN CF.CUSTODYCD --3341

            WHEN CA.CATYPE IN ('011','021') THEN --3341,3342 --STOCK DEVIDEND, BONUS ISSUE
                 CASE
                    WHEN CAS.QTTY > 0 AND CAS.ISSE='Y' AND CAS.ISCI='Y'   THEN CF.CUSTODYCD --3341,3342
                    WHEN CAS.QTTY > 0 AND CAS.ISSE='Y'   THEN CF.CUSTODYCD --3341
                    ELSE NULL
                 END
            WHEN CA.CATYPE IN ('010','015','016','024','027','033') AND CAS.AMT1 > 0 AND CAS.ISCI='Y'  THEN CF.CUSTODYCD --3342

            WHEN CA.CATYPE IN ('017','020') AND CA.CANCELSTATUS ='Y' AND CAS.AQTTY > 0 THEN --3342,3345,3346 BOND CONVERSION-MANDATORY,SHARE CONVERSION
                 CASE
                    WHEN CAS.QTTY > 0 AND CAS.ISSE='Y' AND CAS.ISCI='Y' AND CAS.AMT1 > 0  THEN CF.CUSTODYCD --3342,3345,3346
                    WHEN CAS.QTTY > 0 AND CAS.ISSE='Y' AND CAS.AMT1 = 0   THEN CF.CUSTODYCD --3345,3346
                    ELSE NULL
                 END

            WHEN CA.CATYPE IN ('023')  THEN --3342,3345,3346 BOND CONVERSION-VOLUNTARY
                 CASE
                    WHEN CA.CANCELSTATUS ='Y' AND CAS.AQTTY > 0 AND CAS.QTTY > 0  AND CAS.ISSE='Y'  THEN CF.CUSTODYCD --3345,3346 CO DANG KY CHUYEN DOI
                    WHEN CA.CANCELSTATUS ='Y' AND CAS.AQTTY > 0 AND CAS.QTTY > 0  AND CAS.ISSE='Y' AND CAS.ISCI='Y' THEN CF.CUSTODYCD --3342,3345,3346 CO DANG KY CHUYEN DOI,CO TRA TIEN CHO PHAN KHONG DANG KY
                    WHEN CAS.QTTY = 0 AND CAS.ISCI='Y' THEN CF.CUSTODYCD --3342--KHONG DANG KY
                    ELSE NULL
                 END

            ELSE NULL
        END CUSTODYCD,
        -----------------------------------------------------CIFID
        CASE
            WHEN CA.CATYPE IN ('014') AND CAS.QTTY > 0 AND CAS.ISSE='Y'  THEN CF.CIFID --3341

            WHEN CA.CATYPE IN ('011','021') THEN --3341,3342 --STOCK DEVIDEND, BONUS ISSUE
                 CASE
                    WHEN CAS.QTTY > 0 AND  CAS.ISSE='Y' AND CAS.ISCI='Y'   THEN CF.CIFID --3341,3342
                    WHEN CAS.QTTY > 0 AND  CAS.ISSE='Y'   THEN CF.CIFID --3341
                    ELSE NULL
                 END
            WHEN CA.CATYPE IN ('010','015','016','024','027','033') AND  CAS.AMT1 > 0 AND CAS.ISCI='Y'  THEN CF.CIFID --3342

            WHEN CA.CATYPE IN ('017','020') AND CA.CANCELSTATUS ='Y' AND CAS.AQTTY > 0 THEN --3342,3345,3346 BOND CONVERSION-MANDATORY,SHARE CONVERSION
                 CASE
                    WHEN CAS.QTTY > 0 AND  CAS.ISSE='Y' AND CAS.ISCI='Y' AND CAS.AMT1 > 0  THEN CF.CIFID --3342,3345,3346
                    WHEN CAS.QTTY > 0 AND  CAS.ISSE='Y' AND CAS.AMT1 = 0  THEN CF.CIFID --3345,3346
                    ELSE NULL
                 END

            WHEN CA.CATYPE IN ('023')  THEN --3342,3345,3346 BOND CONVERSION-VOLUNTARY
                 CASE
                    WHEN CA.CANCELSTATUS ='Y' AND CAS.AQTTY > 0 AND CAS.QTTY > 0  AND CAS.ISSE='Y'  THEN CF.CIFID --3345,3346 CO DANG KY CHUYEN DOI
                    WHEN CA.CANCELSTATUS ='Y' AND CAS.AQTTY > 0 AND CAS.QTTY > 0  AND CAS.ISSE='Y' AND CAS.ISCI='Y' THEN CF.CIFID --3342,3345,3346 CO DANG KY CHUYEN DOI,CO TRA TIEN CHO PHAN KHONG DANG KY
                    WHEN CAS.QTTY = 0 AND CAS.ISCI='Y' THEN CF.CIFID --3342--KHONG DANG KY
                    ELSE NULL
                 END

            ELSE NULL
        END CIFID,
        -----------------------------------------------------FULLNAME
        CASE
            WHEN CA.CATYPE IN ('014') AND CAS.QTTY > 0 AND CAS.ISSE='Y'  THEN CF.FULLNAME --3341

            WHEN CA.CATYPE IN ('011','021') THEN --3341,3342 --STOCK DEVIDEND, BONUS ISSUE
                 CASE
                    WHEN CAS.QTTY > 0 AND CAS.ISSE='Y' AND CAS.ISCI='Y'   THEN CF.FULLNAME --3341,3342
                    WHEN CAS.QTTY > 0 AND CAS.ISSE='Y'   THEN CF.FULLNAME --3341
                    ELSE NULL
                 END

            WHEN CA.CATYPE IN ('010','015','016','024','027','033') AND  CAS.AMT1 > 0 AND CAS.ISCI='Y'  THEN CF.FULLNAME --3342

            WHEN CA.CATYPE IN ('017','020') AND CA.CANCELSTATUS ='Y' AND CAS.AQTTY > 0 THEN --3342,3345,3346 BOND CONVERSION-MANDATORY,SHARE CONVERSION
                 CASE
                    WHEN CAS.QTTY > 0 AND CAS.ISSE='Y' AND CAS.ISCI='Y' AND CAS.AMT1 > 0  THEN CF.FULLNAME --3342,3345,3346
                    WHEN CAS.QTTY > 0 AND CAS.ISSE='Y' AND CAS.AMT1 = 0  THEN CF.FULLNAME --3345,3346
                    ELSE NULL
                 END

            WHEN CA.CATYPE IN ('023')  THEN --3342,3345,3346 BOND CONVERSION-VOLUNTARY
                 CASE
                    WHEN CA.CANCELSTATUS ='Y' AND CAS.AQTTY > 0 AND CAS.QTTY > 0  AND CAS.ISSE='Y'  THEN CF.FULLNAME --3345,3346 CO DANG KY CHUYEN DOI
                    WHEN CA.CANCELSTATUS ='Y' AND CAS.AQTTY > 0 AND CAS.QTTY > 0  AND CAS.ISSE='Y' AND CAS.ISCI='Y' THEN CF.FULLNAME --3342,3345,3346 CO DANG KY CHUYEN DOI,CO TRA TIEN CHO PHAN KHONG DANG KY
                    WHEN CAS.QTTY = 0 AND CAS.ISCI='Y' THEN CF.FULLNAME --3342--KHONG DANG KY
                    ELSE NULL
                 END

            ELSE NULL
        END FULLNAME,
        -----------------------------------------------------ENTITLED_HOLDING
        CASE
            WHEN CA.CATYPE IN ('014') AND CAS.QTTY > 0 AND CAS.ISSE='Y'  THEN CAS.BALANCE+ CAS.PBALANCE --3341

            WHEN CA.CATYPE IN ('011','021') THEN --3341,3342 --STOCK DEVIDEND, BONUS ISSUE
                 CASE
                    WHEN CAS.QTTY > 0 AND CAS.ISSE='Y' AND CAS.ISCI='Y'   THEN CAS.BALANCE --3341,3342
                    WHEN CAS.QTTY > 0 AND CAS.ISSE='Y'   THEN CAS.BALANCE --3341
                    ELSE NULL
                 END

            WHEN CA.CATYPE IN ('010','015','016','024','027','033') AND CAS.AMT1 > 0 AND CAS.ISCI='Y'  THEN CAS.BALANCE --3342

            WHEN CA.CATYPE IN ('017','020') AND CA.CANCELSTATUS ='Y' AND CAS.AQTTY > 0 THEN --3342,3345,3346 BOND CONVERSION-MANDATORY,SHARE CONVERSION
                 CASE
                    WHEN CAS.QTTY > 0 AND  CAS.ISSE='Y' AND CAS.ISCI='Y' AND CAS.AMT1 > 0   THEN CAS.BALANCE --3342,3345,3346
                    WHEN CAS.QTTY > 0 AND  CAS.ISSE='Y' AND CAS.AMT1 = 0  THEN CAS.BALANCE --3345,3346
                    ELSE NULL
                 END

            WHEN CA.CATYPE IN ('023')  THEN --3342,3345,3346 BOND CONVERSION-VOLUNTARY
                 CASE
                    WHEN CA.CANCELSTATUS ='Y' AND CAS.AQTTY > 0 AND CAS.QTTY > 0  AND CAS.ISSE='Y'  THEN CAS.BALANCE --3345,3346 CO DANG KY CHUYEN DOI
                    WHEN CA.CANCELSTATUS ='Y' AND CAS.AQTTY > 0 AND CAS.QTTY > 0  AND CAS.ISSE='Y' AND CAS.ISCI='Y' THEN CAS.BALANCE --3342,3345,3346 CO DANG KY CHUYEN DOI,CO TRA TIEN CHO PHAN KHONG DANG KY
                    WHEN CAS.QTTY = 0 AND CAS.ISCI='Y' THEN CAS.BALANCE --3342--KHONG DANG KY
                    ELSE NULL
                 END

            ELSE NULL
        END ENTITLED_HOLDING,
        -----------------------------------------------------WITHDRAWN_SECURITIES
        CASE
          WHEN CA.CATYPE IN ('016','017','020','023') AND CA.CANCELSTATUS ='Y' AND CAS.AQTTY > 0 THEN CAS.AQTTY --3345
          WHEN CA.CATYPE IN ('027') AND CAS.AMT1 > 0 AND CAS.ISCI='Y'  THEN CAS.AQTTY --3342
          WHEN CA.CATYPE IN ('033') AND CAS.AMT1 > 0 AND CAS.ISCI='Y'  THEN CAS.BALANCE --3342
          ELSE 0
        END WITHDRAWN_SECURITIES,
        -----------------------------------------------------WITHDRAWN_SECURITIES_SEGREGATED
        CASE
            WHEN CA.CATYPE IN ('014') AND CAS.QTTY > 0 AND CAS.ISSE='Y'  THEN CAS.QTTY --3341

            WHEN CA.CATYPE IN ('011','021') THEN --3341,3342 --STOCK DEVIDEND, BONUS ISSUE
                 CASE
                    WHEN CAS.QTTY > 0 AND  CAS.ISSE='Y' AND CAS.ISCI='Y'   THEN CAS.QTTY --3341,3342
                    WHEN CAS.QTTY > 0 AND  CAS.ISSE='Y'   THEN CAS.QTTY --3341
                    ELSE 0
                 END

            WHEN CA.CATYPE IN ('010','015','016','024','027','033') AND CAS.AMT1 > 0 AND CAS.ISCI='Y'  THEN CAS.QTTY --3342

            WHEN CA.CATYPE IN ('017','020') AND CA.CANCELSTATUS ='Y' AND CAS.AQTTY > 0 THEN --3342,3345,3346 BOND CONVERSION-MANDATORY,SHARE CONVERSION
                 CASE
                    WHEN CAS.QTTY > 0 AND  CAS.ISSE='Y' AND CAS.ISCI='Y' AND CAS.AMT1 > 0   THEN CAS.QTTY --3342,3345,3346
                    WHEN CAS.QTTY > 0 AND  CAS.ISSE='Y' AND CAS.AMT1 = 0  THEN CAS.QTTY --3345,3346
                    ELSE 0
                 END

            WHEN CA.CATYPE IN ('023')  THEN --3342,3345,3346
                 CASE
                    WHEN CA.CANCELSTATUS ='Y' AND CAS.QTTY > 0 AND CAS.ISSE='Y'  THEN CAS.QTTY --3345,3346
                    WHEN CA.CANCELSTATUS ='Y' AND CAS.QTTY > 0 AND CAS.AMT1 > 0 AND  CAS.ISSE='Y' AND CAS.ISCI='Y'  THEN CAS.QTTY --3342,3345,3346
                    WHEN CA.CANCELSTATUS ='N' AND CAS.AMT1 > 0 AND CAS.ISCI='Y'   THEN CAS.QTTY --3342
                    ELSE 0
                 END

            ELSE 0
        END WITHDRAWN_SECURITIES_SEGREGATED,
        -----------------------------------------------------CASH_AMOUNT_PAID
        CASE
            WHEN CA.CATYPE IN ('014') AND CAS.QTTY > 0 AND CAS.ISSE='Y'
                THEN ROUND(CAS.AMT1)- (
                                         CASE
                                              WHEN CF.CUSTTYPE='B' AND CA.CATYPE = '010' THEN 0
                                              WHEN CF.VAT = 'Y' THEN
                                                  CASE WHEN CA.PITRATEMETHOD='NO' THEN 0 ELSE
                                                         (
                                                         CASE  WHEN TRIM(CA.CATYPE) IN ('016','023','033')THEN ROUND (CAS.INTAMT * CA.PITRATE / 100)
                                                                WHEN CA.CATYPE = '024' THEN ROUND(CAS.BALANCE*CA.EXPRICE*CA.PITRATE/100/ (TO_NUMBER(SUBSTR(CA.EXRATE ,0,INSTR(CA.EXRATE ,'/') - 1))/ TO_NUMBER(SUBSTR(CA.EXRATE ,INSTR(CA.EXRATE ,'/')+1,LENGTH(CA.EXRATE )))))
                                                                WHEN CA.CATYPE = '010' AND CF.CUSTTYPE ='I' THEN ROUND(NVL(CAS.AMT1,0) * CA.PITRATE / 100)
                                                                WHEN CA.CATYPE = '010' AND CF.CUSTTYPE ='B' THEN 0
                                                                ELSE ROUND (CAS.AMT1 * CA.PITRATE / 100)
                                                          END
                                                          )
                                                  END
                                             ELSE 0
                                          END
                                      ) --3341

            WHEN CA.CATYPE IN ('011','021') THEN --3341,3342 --STOCK DEVIDEND, BONUS ISSUE
                 CASE
                    WHEN CAS.QTTY > 0 AND CAS.ISSE='Y' AND CAS.ISCI='Y'
                        THEN ROUND(CAS.AMT1)- (
                                                 CASE
                                                      WHEN CF.CUSTTYPE='B' AND CA.CATYPE = '010' THEN 0
                                                      WHEN CF.VAT = 'Y' THEN
                                                          CASE WHEN CA.PITRATEMETHOD='NO' THEN 0 ELSE
                                                                 (
                                                                 CASE  WHEN TRIM(CA.CATYPE) IN ('016','023','033')THEN ROUND (CAS.INTAMT * CA.PITRATE / 100)
                                                                        WHEN CA.CATYPE = '024' THEN ROUND(CAS.BALANCE*CA.EXPRICE*CA.PITRATE/100/ (TO_NUMBER(SUBSTR(CA.EXRATE ,0,INSTR(CA.EXRATE ,'/') - 1))/ TO_NUMBER(SUBSTR(CA.EXRATE ,INSTR(CA.EXRATE ,'/')+1,LENGTH(CA.EXRATE )))))
                                                                        WHEN CA.CATYPE = '010' AND CF.CUSTTYPE ='I' THEN ROUND(NVL(CAS.AMT1,0) * CA.PITRATE / 100)
                                                                        WHEN CA.CATYPE = '010' AND CF.CUSTTYPE ='B' THEN 0
                                                                        ELSE ROUND (CAS.AMT1 * CA.PITRATE / 100)
                                                                  END
                                                                  )
                                                          END
                                                     ELSE 0
                                                  END
                                              ) --3341,3342
                    WHEN CAS.QTTY > 0 AND  CAS.ISSE='Y'
                        THEN ROUND(CAS.AMT1)- (
                                                 CASE
                                                      WHEN CF.CUSTTYPE='B' AND CA.CATYPE = '010' THEN 0
                                                      WHEN CF.VAT = 'Y' THEN
                                                          CASE WHEN CA.PITRATEMETHOD='NO' THEN 0 ELSE
                                                                 (
                                                                 CASE  WHEN TRIM(CA.CATYPE) IN ('016','023','033')THEN ROUND (CAS.INTAMT * CA.PITRATE / 100)
                                                                        WHEN CA.CATYPE = '024' THEN ROUND(CAS.BALANCE*CA.EXPRICE*CA.PITRATE/100/ (TO_NUMBER(SUBSTR(CA.EXRATE ,0,INSTR(CA.EXRATE ,'/') - 1))/ TO_NUMBER(SUBSTR(CA.EXRATE ,INSTR(CA.EXRATE ,'/')+1,LENGTH(CA.EXRATE )))))
                                                                        WHEN CA.CATYPE = '010' AND CF.CUSTTYPE ='I' THEN ROUND(NVL(CAS.AMT1,0) * CA.PITRATE / 100)
                                                                        WHEN CA.CATYPE = '010' AND CF.CUSTTYPE ='B' THEN 0
                                                                        ELSE ROUND (CAS.AMT1 * CA.PITRATE / 100)
                                                                  END
                                                                  )
                                                          END
                                                     ELSE 0
                                                  END
                                              ) --3341
                    ELSE NULL
                 END

            WHEN CA.CATYPE IN ('010','015','016','024','027','033') AND CAS.AMT1 > 0 AND CAS.ISCI='Y'
                    THEN ROUND(CAS.AMT1) - (
                                             CASE
                                                  WHEN CF.CUSTTYPE='B' AND CA.CATYPE = '010' THEN 0
                                                  WHEN CF.VAT = 'Y' THEN
                                                      CASE WHEN CA.PITRATEMETHOD='NO' THEN 0 ELSE
                                                             (
                                                             CASE  WHEN TRIM(CA.CATYPE) IN ('016','023','033')THEN ROUND (CAS.INTAMT * CA.PITRATE / 100)
                                                                    WHEN CA.CATYPE = '024' THEN ROUND(CAS.BALANCE*CA.EXPRICE*CA.PITRATE/100/ (TO_NUMBER(SUBSTR(CA.EXRATE ,0,INSTR(CA.EXRATE ,'/') - 1))/ TO_NUMBER(SUBSTR(CA.EXRATE ,INSTR(CA.EXRATE ,'/')+1,LENGTH(CA.EXRATE )))))
                                                                    WHEN CA.CATYPE = '010' AND CF.CUSTTYPE ='I' THEN ROUND(NVL(CAS.AMT1,0) * CA.PITRATE / 100)
                                                                    WHEN CA.CATYPE = '010' AND CF.CUSTTYPE ='B' THEN 0
                                                                    ELSE ROUND (CAS.AMT1 * CA.PITRATE / 100)
                                                              END
                                                              )
                                                      END
                                                 ELSE 0
                                              END
                                          ) --3342

            WHEN CA.CATYPE IN ('017','020') AND CA.CANCELSTATUS ='Y' AND CAS.AQTTY > 0 THEN --3342,3345,3346 BOND CONVERSION-MANDATORY,SHARE CONVERSION
                 CASE
                    WHEN CAS.QTTY > 0 AND CAS.ISSE='Y' AND CAS.ISCI='Y' AND CAS.AMT1 > 0
                        THEN ROUND(CAS.AMT1)- (
                                                 CASE
                                                      WHEN CF.CUSTTYPE='B' AND CA.CATYPE = '010' THEN 0
                                                      WHEN CF.VAT = 'Y' THEN
                                                          CASE WHEN CA.PITRATEMETHOD='NO' THEN 0 ELSE
                                                                 (
                                                                 CASE  WHEN TRIM(CA.CATYPE) IN ('016','023','033')THEN ROUND (CAS.INTAMT * CA.PITRATE / 100)
                                                                        WHEN CA.CATYPE = '024' THEN ROUND(CAS.BALANCE*CA.EXPRICE*CA.PITRATE/100/ (TO_NUMBER(SUBSTR(CA.EXRATE ,0,INSTR(CA.EXRATE ,'/') - 1))/ TO_NUMBER(SUBSTR(CA.EXRATE ,INSTR(CA.EXRATE ,'/')+1,LENGTH(CA.EXRATE )))))
                                                                        WHEN CA.CATYPE = '010' AND CF.CUSTTYPE ='I' THEN ROUND(NVL(CAS.AMT1,0) * CA.PITRATE / 100)
                                                                        WHEN CA.CATYPE = '010' AND CF.CUSTTYPE ='B' THEN 0
                                                                        ELSE ROUND (CAS.AMT1 * CA.PITRATE / 100)
                                                                  END
                                                                  )
                                                          END
                                                     ELSE 0
                                                  END
                                              ) --3342,3345,3346
                    WHEN CAS.QTTY > 0 AND  CAS.ISSE='Y' AND CAS.AMT1 = 0
                        THEN ROUND(CAS.AMT1)-  (
                                                 CASE
                                                      WHEN CF.CUSTTYPE='B' AND CA.CATYPE = '010' THEN 0
                                                      WHEN CF.VAT = 'Y' THEN
                                                          CASE WHEN CA.PITRATEMETHOD='NO' THEN 0 ELSE
                                                                 (
                                                                 CASE  WHEN TRIM(CA.CATYPE) IN ('016','023','033')THEN ROUND (CAS.INTAMT * CA.PITRATE / 100)
                                                                        WHEN CA.CATYPE = '024' THEN ROUND(CAS.BALANCE*CA.EXPRICE*CA.PITRATE/100/ (TO_NUMBER(SUBSTR(CA.EXRATE ,0,INSTR(CA.EXRATE ,'/') - 1))/ TO_NUMBER(SUBSTR(CA.EXRATE ,INSTR(CA.EXRATE ,'/')+1,LENGTH(CA.EXRATE )))))
                                                                        WHEN CA.CATYPE = '010' AND CF.CUSTTYPE ='I' THEN ROUND(NVL(CAS.AMT1,0) * CA.PITRATE / 100)
                                                                        WHEN CA.CATYPE = '010' AND CF.CUSTTYPE ='B' THEN 0
                                                                        ELSE ROUND (CAS.AMT1 * CA.PITRATE / 100)
                                                                  END
                                                                  )
                                                          END
                                                     ELSE 0
                                                  END
                                              ) --3345,3346
                    ELSE NULL
                 END

            WHEN CA.CATYPE IN ('023')  THEN --3342,3345,3346 BOND CONVERSION-VOLUNTARY
                 CASE
                    WHEN CA.CANCELSTATUS ='Y' AND CAS.AQTTY > 0 AND CAS.QTTY > 0  AND CAS.ISSE='Y'
                        THEN ROUND(CAS.AMT1)- (
                                                 CASE
                                                      WHEN CF.CUSTTYPE='B' AND CA.CATYPE = '010' THEN 0
                                                      WHEN CF.VAT = 'Y' THEN
                                                          CASE WHEN CA.PITRATEMETHOD='NO' THEN 0 ELSE
                                                                 (
                                                                 CASE  WHEN TRIM(CA.CATYPE) IN ('016','023','033')THEN ROUND (CAS.INTAMT * CA.PITRATE / 100)
                                                                        WHEN CA.CATYPE = '024' THEN ROUND(CAS.BALANCE*CA.EXPRICE*CA.PITRATE/100/ (TO_NUMBER(SUBSTR(CA.EXRATE ,0,INSTR(CA.EXRATE ,'/') - 1))/ TO_NUMBER(SUBSTR(CA.EXRATE ,INSTR(CA.EXRATE ,'/')+1,LENGTH(CA.EXRATE )))))
                                                                        WHEN CA.CATYPE = '010' AND CF.CUSTTYPE ='I' THEN ROUND(NVL(CAS.AMT1,0) * CA.PITRATE / 100)
                                                                        WHEN CA.CATYPE = '010' AND CF.CUSTTYPE ='B' THEN 0
                                                                        ELSE ROUND (CAS.AMT1 * CA.PITRATE / 100)
                                                                  END
                                                                  )
                                                          END
                                                     ELSE 0
                                                  END
                                              ) --3345,3346 CO DANG KY CHUYEN DOI
                    WHEN CA.CANCELSTATUS ='Y' AND CAS.AQTTY > 0 AND CAS.QTTY > 0  AND CAS.ISSE='Y' AND CAS.ISCI='Y'
                        THEN ROUND(CAS.AMT1)-  (
                                                 CASE
                                                      WHEN CF.CUSTTYPE='B' AND CA.CATYPE = '010' THEN 0
                                                      WHEN CF.VAT = 'Y' THEN
                                                          CASE WHEN CA.PITRATEMETHOD='NO' THEN 0 ELSE
                                                                 (
                                                                 CASE  WHEN TRIM(CA.CATYPE) IN ('016','023','033')THEN ROUND (CAS.INTAMT * CA.PITRATE / 100)
                                                                        WHEN CA.CATYPE = '024' THEN ROUND(CAS.BALANCE*CA.EXPRICE*CA.PITRATE/100/ (TO_NUMBER(SUBSTR(CA.EXRATE ,0,INSTR(CA.EXRATE ,'/') - 1))/ TO_NUMBER(SUBSTR(CA.EXRATE ,INSTR(CA.EXRATE ,'/')+1,LENGTH(CA.EXRATE )))))
                                                                        WHEN CA.CATYPE = '010' AND CF.CUSTTYPE ='I' THEN ROUND(NVL(CAS.AMT1,0) * CA.PITRATE / 100)
                                                                        WHEN CA.CATYPE = '010' AND CF.CUSTTYPE ='B' THEN 0
                                                                        ELSE ROUND (CAS.AMT1 * CA.PITRATE / 100)
                                                                  END
                                                                  )
                                                          END
                                                     ELSE 0
                                                  END
                                              ) --3342,3345,3346 CO DANG KY CHUYEN DOI,CO TRA TIEN CHO PHAN KHONG DANG KY
                    WHEN CAS.QTTY = 0 AND CAS.ISCI='Y'
                        THEN ROUND(CAS.AMT1)-  (
                                                 CASE
                                                      WHEN CF.CUSTTYPE='B' AND CA.CATYPE = '010' THEN 0
                                                      WHEN CF.VAT = 'Y' THEN
                                                          CASE WHEN CA.PITRATEMETHOD='NO' THEN 0 ELSE
                                                                 (
                                                                 CASE  WHEN TRIM(CA.CATYPE) IN ('016','023','033')THEN ROUND (CAS.INTAMT * CA.PITRATE / 100)
                                                                        WHEN CA.CATYPE = '024' THEN ROUND(CAS.BALANCE*CA.EXPRICE*CA.PITRATE/100/ (TO_NUMBER(SUBSTR(CA.EXRATE ,0,INSTR(CA.EXRATE ,'/') - 1))/ TO_NUMBER(SUBSTR(CA.EXRATE ,INSTR(CA.EXRATE ,'/')+1,LENGTH(CA.EXRATE )))))
                                                                        WHEN CA.CATYPE = '010' AND CF.CUSTTYPE ='I' THEN ROUND(NVL(CAS.AMT1,0) * CA.PITRATE / 100)
                                                                        WHEN CA.CATYPE = '010' AND CF.CUSTTYPE ='B' THEN 0
                                                                        ELSE ROUND (CAS.AMT1 * CA.PITRATE / 100)
                                                                  END
                                                                  )
                                                          END
                                                     ELSE 0
                                                  END
                                              ) --3342
                    ELSE NULL
                 END

            ELSE NULL
        END CASH_AMOUNT_PAID,
        -----------------------------------------------------STATUS
/*        CASE
            WHEN CA.CATYPE IN ('014') AND  CAS.QTTY > 0 AND CAS.ISSE='Y'  THEN A1.EN_CDCONTENT --3341

            WHEN CA.CATYPE IN ('011','021') THEN --3341,3342 --STOCK DEVIDEND, BONUS ISSUE
                 CASE
                    WHEN CAS.QTTY > 0 AND  CAS.ISSE='Y' AND CAS.ISCI='Y'   THEN A1.EN_CDCONTENT --3341,3342
                    WHEN CAS.QTTY > 0 AND  CAS.ISSE='Y'   THEN A1.EN_CDCONTENT --3341
                    ELSE NULL
                 END

            WHEN CA.CATYPE IN ('010','015','016','024','027') AND  CAS.AMT > 0 AND CAS.ISCI='Y'  THEN A1.EN_CDCONTENT --3342

            WHEN CA.CATYPE IN ('017','020') AND CA.CANCELSTATUS ='Y' AND CAS.AQTTY > 0 THEN --3342,3345,3346 BOND CONVERSION-MANDATORY,SHARE CONVERSION
                 CASE
                    WHEN CAS.QTTY > 0 AND  CAS.ISSE='Y' AND CAS.ISCI='Y' AND CAS.AMT > 0  THEN A1.EN_CDCONTENT --3342,3345,3346
                    WHEN CAS.QTTY > 0 AND  CAS.ISSE='Y' AND CAS.AMT = 0  THEN A1.EN_CDCONTENT --3345,3346
                    ELSE NULL
                 END

            WHEN CA.CATYPE IN ('023')  THEN --3342,3345,3346 BOND CONVERSION-VOLUNTARY
                 CASE
                    WHEN CA.CANCELSTATUS ='Y' AND CAS.AQTTY > 0 AND CAS.QTTY > 0  AND CAS.ISSE='Y'  THEN A1.EN_CDCONTENT --3345,3346 CO DANG KY CHUYEN DOI
                    WHEN CA.CANCELSTATUS ='Y' AND CAS.AQTTY > 0 AND CAS.QTTY > 0  AND CAS.ISSE='Y' AND CAS.ISCI='Y' THEN A1.EN_CDCONTENT --3342,3345,3346 CO DANG KY CHUYEN DOI,CO TRA TIEN CHO PHAN KHONG DANG KY
                    WHEN CAS.QTTY = 0 AND CAS.ISCI='Y' THEN A1.EN_CDCONTENT --3342--KHONG DANG KY
                    ELSE NULL
                 END

            ELSE NULL
        END */ 'Completed' STATUS
    FROM CAMAST CA, CFMAST CF , SBSECURITIES SB , SBSECURITIES SB1, DDMAST DD,
        (SELECT * FROM ALLCODE WHERE CDNAME = 'CASTATUS')A1,(SELECT * FROM ALLCODE WHERE CDNAME ='CATYPE')A2,
        (SELECT CSD1.* FROM CASCHDDTL CSD1 WHERE CSD1.DELTD <> 'Y' AND CSD1.STATUS ='P') CAD,
        (
            SELECT CHS.*, NVL(CHD.AMT, CHS.AMT) AMT1
            FROM CASCHD CHS,
            (
                SELECT *
                FROM CASCHDDTL
                WHERE AUTOID IN (
                    SELECT MAX(AUTOID) FROM CASCHDDTL WHERE DELTD = 'N' AND STATUS = 'C' GROUP BY AUTOID_CASCHD
                )
            ) CHD
            WHERE CHS.AUTOID = CHD.AUTOID_CASCHD(+)
        ) CAS
    WHERE CA.CAMASTID = CAS.CAMASTID
            AND CAS.AFACCTNO= CF.CUSTID
            AND CA.CATYPE IN ('016','023','020','017','011','021','010','014','015','024','027','033') AND CAS.DELTD ='N'
            AND CAS.STATUS IN ('J', 'W', 'C','H','G')
            AND (CAS.AMT1 > 0 OR CAS.QTTY > 0)
            AND (CAS.ISSE='Y' OR CAS.ISCI='Y')
            AND NVL(CA.TOCODEID,CA.CODEID) = SB.CODEID --CK NHAN
            AND CA.CODEID= SB1.CODEID --CK GOC
            AND CAS.STATUS = A1.CDVAL(+)
            AND CA.CATYPE = A2.CDVAL (+)
            AND CAS.AFACCTNO = DD.AFACCTNO AND DD.ISDEFAULT='Y'
            AND CAS.AUTOID = CAD.AUTOID_CASCHD (+)
            AND CAS.AFACCTNO = CAD.AFACCTNO (+)
            AND CAS.CAMASTID LIKE V_CACODE
            AND CF.CUSTODYCD LIKE V_CUSTODYCD
            AND
            CASE
                WHEN CA.CATYPE IN ('014') AND CAS.QTTY > 0 AND CAS.ISSE='Y'  THEN CF.CUSTODYCD --3341

                WHEN CA.CATYPE IN ('011','021') THEN --3341,3342 --STOCK DEVIDEND, BONUS ISSUE
                     CASE
                        WHEN CAS.QTTY > 0 AND CAS.ISSE='Y' AND CAS.ISCI='Y'   THEN CF.CUSTODYCD --3341,3342
                        WHEN CAS.QTTY > 0 AND CAS.ISSE='Y'   THEN CF.CUSTODYCD --3341
                        ELSE NULL
                     END
                WHEN CA.CATYPE IN ('010','015','016','024','027','033') AND CAS.AMT1 > 0 AND CAS.ISCI='Y'  THEN CF.CUSTODYCD --3342

                WHEN CA.CATYPE IN ('017','020') AND CA.CANCELSTATUS ='Y' AND CAS.AQTTY > 0 THEN --3342,3345,3346 BOND CONVERSION-MANDATORY,SHARE CONVERSION
                     CASE
                        WHEN CAS.QTTY > 0 AND CAS.ISSE='Y' AND CAS.ISCI='Y' AND CAS.AMT1 > 0  THEN CF.CUSTODYCD --3342,3345,3346
                        WHEN CAS.QTTY > 0 AND CAS.ISSE='Y' AND CAS.AMT1 = 0   THEN CF.CUSTODYCD --3345,3346
                        ELSE NULL
                     END

                WHEN CA.CATYPE IN ('023')  THEN --3342,3345,3346 BOND CONVERSION-VOLUNTARY
                     CASE
                        WHEN CA.CANCELSTATUS ='Y' AND CAS.AQTTY > 0 AND CAS.QTTY > 0  AND CAS.ISSE='Y'  THEN CF.CUSTODYCD --3345,3346 CO DANG KY CHUYEN DOI
                        WHEN CA.CANCELSTATUS ='Y' AND CAS.AQTTY > 0 AND CAS.QTTY > 0  AND CAS.ISSE='Y' AND CAS.ISCI='Y' THEN CF.CUSTODYCD --3342,3345,3346 CO DANG KY CHUYEN DOI,CO TRA TIEN CHO PHAN KHONG DANG KY
                        WHEN CAS.QTTY = 0 AND CAS.ISCI='Y' THEN CF.CUSTODYCD --3342--KHONG DANG KY
                        ELSE NULL
                     END

                ELSE NULL
            END IS NOT NULL
ORDER BY CF.CUSTODYCD
;
EXCEPTION
  WHEN OTHERS
   THEN
      PLOG.ERROR ('CA6019: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RETURN;
END;
/
