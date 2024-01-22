SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE ca600201(
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   F_DATE                 IN       VARCHAR2, /*Tu ngay */
   T_DATE                 IN       VARCHAR2, /*den ngay */
   P_CIFID                IN       VARCHAR2 /*Ma KH tai ngan hang */
   )
IS
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0

    V_FROMDATE          DATE;
    V_TODATE            DATE;
    V_CURRDATE          DATE;
    V_ISSUEDATE         DATE;
    V_EXPDATE           DATE;
    V_CUSTODYCD         VARCHAR2(20);
    V_SYMBOL            VARCHAR2(50);
    V_IDCODE           VARCHAR2(200);
    V_OFFICE           VARCHAR2(200);
    V_REFNAME          VARCHAR2(200);
    V_SHVSTC           VARCHAR2(200);
    V_SHVCUSTODYCD     VARCHAR2(200);
    V_SHVCIFID         VARCHAR2(200);
    V_CIFID            VARCHAR2(20);
    V_TLTITLE          VARCHAR2(200);
    V_TLFULLNAME       VARCHAR2(200);
BEGIN
     V_STROPTION := OPT;
     V_CURRDATE   := GETCURRDATE;
     IF V_STROPTION = 'A' THEN
        V_STRBRID := '%';
     ELSIF V_STROPTION = 'B' THEN
        V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
     ELSE
        V_STRBRID:=BRID;
     END IF;
     IF  P_CIFID='ALL' THEN
          V_CIFID:='%' ;
     ELSE
          V_CIFID:=P_CIFID;
        END IF;
    V_FROMDATE  := TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    V_TODATE    := TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);

OPEN PV_REFCURSOR FOR
SELECT A.* --TRUNG.LUU: 19-02-2021 SHBVNEX-2067 LAY TAI KHOAN ME
        --TRUNG.LUU : 18-03-2021 SHBVNEX-2161  khong dung tai khoan me, dung master cifid
 FROM
(
    SELECT
                    ROWNUM NO,
                    CF.CIFID PORTFOLIONO,
                    CF.FULLNAME PORTFOLIONAME,
                    BD.BONDCODE,
                    BD.ISINCODE,
                    BD.EVENTID,
                    TO_CHAR(BD.RECORDDATE, 'DD-FMMonth-RRRR') RECORDDATE,
                    BD.NAMEOFSERVICE NAMEOFSERVICE_TEMP,
                    CASE WHEN NAMEOFSERVICE_VN='TRIBUI' THEN  BD.NAMEOFSERVICE ELSE 'Other income received' END || CASE WHEN BD.ACTIONDATE IS NOT NULL THEN ' in ' END || TO_CHAR(BD.ACTIONDATE,'MM/RRRR') NAMEOFSERVICE,
                    CF.FULLNAME||'_'||NAMEOFSERVICE_VN||' ('|| BD.NAMEOFSERVICE|| CASE WHEN BD.ACTIONDATE IS NOT NULL THEN ' in ' END
                    || TO_CHAR(BD.ACTIONDATE,'MM/RRRR')||')'||CASE WHEN BD.BONDCODE IS NOT NULL THEN '_' ELSE NULL END||BD.BONDCODE JOBDESCRIPTION,
                    TO_CHAR(BD.ACTIONDATE,'DD-FMMonth-RRRR') PAYMENTDATE,
                    Round(BD.S_AMT) AMOUNTBEFORETAX,
                    TO_CHAR(BD.PITRATE,'990.000')||'%' DEEMEDCITRATE,
                    CASE
                        WHEN NAMEOFSERVICE = 'Order selling physical received' THEN BD.TAX
                        WHEN AMT_TAX > 0 THEN AMT_TAX
                        ELSE (BD.PITRATE/100) *BD.S_AMT
                    END TAXAMOUNTWITHHELD,
                    ROUND(BD.S_AMT)-CASE
                                WHEN NAMEOFSERVICE = 'Order selling physical received' THEN BD.TAX
                                WHEN AMT_TAX > 0 THEN AMT_TAX --CHO SKQ
                                ELSE (BD.PITRATE/100) *BD.S_AMT
                              END  AMOUNTAFTERTAX
                     --TRUNG.LUU : 18-03-2021 SHBVNEX-2161  khong dung tai khoan me, dung master cifid
                     --trung.luu: 28-04-2021 SHBVNEX-2161 khong co mastercif thi de null
                    ,CF.MCIFID
    FROM CFMAST CF,
    (
    ---------------------------------NIEM YET-CHUA NIEM YET---------------------------------
            SELECT
                    CF.CUSTID,
                    SEC.SECCODE BONDCODE,
                    SEC.ISINCODE,
                    SEC.SECNAME,
                    CA.REPORTDATE RECORDDATE,
                    CA.ACTIONDATE,
                    CA.CAMASTID EVENTID,
                    CASE
                        WHEN CF.VAT='Y'
                              THEN (
                                        CASE
                                            WHEN CA.PITRATEMETHOD='NO' THEN 0
                                            WHEN CF.CUSTTYPE='B' AND CA.CATYPE = '010' THEN 0
                                            ELSE MAX(CA.PITRATE)
                                        END
                                   )
                         ELSE 0
                    END PITRATE,
                    SEC.TRADEPLACE,
                    CASE
                         WHEN SEC.TRADEPLACE IN ('001','002','005') AND CA.CATYPE IN ('015','016','023')  THEN 'Listed bond coupon received'
                         WHEN SEC.TRADEPLACE IN ('001','002','005') AND CA.CATYPE = '010'  THEN 'Cash dividend of listed shares received'
                         WHEN SEC.TRADEPLACE ='003' AND CA.CATYPE  IN ('015','016','033') THEN 'Unlisted physical bond coupon received'
                         WHEN SEC.TRADEPLACE ='003' AND CA.CATYPE  IN ('033') THEN 'Unlisted physical bond coupon received'
                         WHEN SEC.TRADEPLACE ='003' AND CA.CATYPE = '010' THEN 'Cash dividend of unlisted physical shares received'
                         WHEN CA.CATYPE = '024'  THEN 'Covered warrant payment received'
                         ELSE NULL
                    END NAMEOFSERVICE,
                    'TRIBUI' NAMEOFSERVICE_VN,
                    CASE
                        WHEN CA.CATYPE IN ('016','033') THEN SUM(CAS.AMT-(CAS.TRADE*SEC.PARVALUE))
                        WHEN CA.CATYPE IN ('023') AND MAX(CA.FORMOFPAYMENT)='002' THEN SUM(CAS.AMT-(CAS.TRADE*SEC.PARVALUE))--002 TRA GOC VA LAI
                        WHEN CA.CATYPE IN ('024') THEN SUM(CAS.balance*ca.exprice/(TO_NUMBER(SUBSTR(CA.EXRATE ,0,INSTR(CA.EXRATE ,'/') - 1))/TO_NUMBER(SUBSTR(CA.EXRATE ,INSTR(CA.EXRATE ,'/')+1,LENGTH(CA.EXRATE )))))
                        ELSE SUM(CAS.AMT)
                    END S_AMT,
                    ----------
                    CASE
                        WHEN CF.VAT='Y'
                              THEN (
                                        CASE
                                            WHEN CA.PITRATEMETHOD='NO' THEN 0
                                            ELSE (
                                                    CASE
                                                        WHEN CA.CATYPE IN ('016','023','033') THEN SUM(ROUND(CA.PITRATE*CAS.INTAMT/100))
                                                        WHEN CA.CATYPE = '024' THEN SUM(ROUND(CAS.BALANCE*CA.EXPRICE*CA.PITRATE/100/(TO_NUMBER(SUBSTR(CA.EXRATE ,0,INSTR(CA.EXRATE ,'/') - 1))/TO_NUMBER(SUBSTR(CA.EXRATE ,INSTR(CA.EXRATE ,'/')+1,LENGTH(CA.EXRATE ))))))
                                                        WHEN CA.CATYPE = '010' AND CF.CUSTTYPE ='I' THEN SUM(ROUND(NVL(CAD.AMT,0) * CA.PITRATE / 100))
                                                        WHEN CA.CATYPE = '010' AND CF.CUSTTYPE ='B' THEN 0
                                                        ELSE SUM(ROUND(CA.PITRATE*CAS.AMT/100)) --015
                                                    END
                                                 )
                                        END
                                   )
                         ELSE 0
                    END AMT_TAX,
                    ------------
                    0 TAX
            FROM (
                    SELECT SB.CODEID,SB.EXERCISERATIO,SB.ISINCODE, ISS.ISSUERID, ISS.SHORTNAME SECCODE, ISS.FULLNAME SECNAME, SB.PARVALUE,SB.TRADEPLACE, TP.TRADEPLACENAME
                    FROM ISSUERS ISS,SBSECURITIES SB,
                            (
                                SELECT CDVAL TRADEPLACE, CDCONTENT TRADEPLACENAME, EN_CDCONTENT  TRADEPLACENAME_EN
                                FROM ALLCODE
                                WHERE CDNAME='TRADEPLACE' AND CDTYPE ='SE'
                                ORDER BY LSTODR
                            )TP
                    WHERE  ISS.ISSUERID = SB.ISSUERID AND TP.TRADEPLACE = SB.TRADEPLACE
                ) SEC
            JOIN CAMAST CA
                ON CA.CODEID = SEC.CODEID AND CA.PITRATEMETHOD = 'SC'
            JOIN CASCHD CAS
                ON CAS.CAMASTID = CA.CAMASTID
            JOIN AFMAST AF
                ON AF.ACCTNO = CAS.AFACCTNO
            JOIN CFMAST CF
                ON CF.CUSTID = AF.CUSTID
            LEFT JOIN (SELECT CSD1.* FROM CASCHDDTL CSD1 WHERE NVL(CSD1.DELTD, 'N') <> 'Y' AND CSD1.STATUS ='P') CAD
                ON CAS.AUTOID = CAD.AUTOID_CASCHD AND CAS.AFACCTNO = CAD.AFACCTNO
            WHERE NVL(CAS.DELTD, 'N') <> 'Y'
                AND ((CAS.STATUS IN ('J','G') AND CA.STATUS <> 'C') or
                (CAS.STATUS IN ('C') AND CA.STATUS = 'C'))
                AND NVL(CA.DELTD, 'N') <> 'Y'
                AND (CA.CATYPE IN ('010','015','016','023','024') OR (SEC.TRADEPLACE ='003' AND CA.CATYPE  IN ('033')) OR (SEC.TRADEPLACE IN ('001','002','005') AND CA.CATYPE IN ('023')))
            GROUP BY
                CF.CUSTID,
                CF.CUSTTYPE,
                CF.VAT,
                SEC.SECCODE ,
                SEC.ISINCODE,
                SEC.SECNAME,
                CA.REPORTDATE ,
                CA.ACTIONDATE,
                CA.CAMASTID ,
                CA.PITRATEMETHOD,
                 CASE
                        WHEN CF.VAT='Y'
                              THEN (
                                        CASE
                                            WHEN CA.PITRATEMETHOD='NO' THEN 0
                                            ELSE (
                                                    CASE
                                                        WHEN CA.CATYPE IN ('016','023','033') THEN CA.PITRATE
                                                        WHEN CA.CATYPE = '024' THEN CA.PITRATE
                                                        WHEN CA.CATYPE = '010' AND CF.CUSTTYPE ='I' THEN CA.PITRATE
                                                        WHEN CA.CATYPE = '010' AND CF.CUSTTYPE ='B' THEN 0 --TRUNG.LUU: 09-06-2020 SHBVNEX-1362 KH TO CHUC THI SO TIEN THUE = 0
                                                        ELSE ROUND(CA.PITRATE*CAS.AMT/100)
                                                    END
                                                 )
                                        END
                                   )
                         ELSE 0
                    END,
                CA.CATYPE,
                SEC.TRADEPLACE

    UNION ALL---------------------------------CHUYEN NHUONG CHUNG KHOAN---------------------------------

            SELECT
                        CF.CUSTID,
                        SEC.SECCODE BONDCODE,
                        SEC.ISINCODE,
                        SEC.SECNAME,
                        OD.TXDATE RECORDDATE,
                        OD.CRTXDATE ACTIONDATE,
                        '' EVENTID,
                        5 PITRATE,
                        SEC.TRADEPLACE,
                        'Securities sales proceeds received' NAMEOFSERVICE,
                        'TRIBUI' NAMEOFSERVICE_VN,
                        SUM(OD.TAX) S_AMT,
                        0 AMT_TAX,
                        0 TAX

            FROM (
                    SELECT SB.CODEID, SB.ISINCODE, ISS.ISSUERID, ISS.SHORTNAME SECCODE, ISS.FULLNAME SECNAME, SB.PARVALUE,SB.TRADEPLACE, TP.TRADEPLACENAME
                    FROM ISSUERS ISS,SBSECURITIES SB,
                            (
                                SELECT CDVAL TRADEPLACE, CDCONTENT TRADEPLACENAME, EN_CDCONTENT  TRADEPLACENAME_EN
                                FROM ALLCODE
                                WHERE CDNAME='TRADEPLACE' AND CDTYPE ='SE'
                                ORDER BY LSTODR
                            )TP
                    WHERE  ISS.ISSUERID = SB.ISSUERID AND TP.TRADEPLACE = SB.TRADEPLACE
                ) SEC
            LEFT JOIN (SELECT * FROM OTCODMAST WHERE NVL(DELTD, 'N') <> 'Y') OD ON OD.CODEID = SEC.CODEID
            LEFT JOIN CFMAST CF ON CF.CUSTODYCD =OD.SCUSTODYCD
            GROUP BY
                        CF.CUSTID,
                        SEC.SECCODE,
                        SEC.ISINCODE,
                        SEC.SECNAME,
                        OD.TXDATE,
                        OD.CRTXDATE,
                       -- OD.SEACCTNO,
                        SEC.TRADEPLACE

     UNION ALL---------------------------------BAN PHYSICAL 1400-->1402---------------------------------

             SELECT
                        CF.CUSTID,
                        SEC.SECCODE BONDCODE,
                        SEC.ISINCODE,
                        SEC.SECNAME,
                        null RECORDDATE,
                        CR.SELLDATE ACTIONDATE,
                        '' EVENTID,
                        ROUND((SUM(CR.TAX)*100)/CASE WHEN SUM(CR.AMT) =0 THEN 1 ELSE SUM(CR.AMT) END,5) PITRATE,
                        SEC.TRADEPLACE,
                        'Securities sales proceeds received' NAMEOFSERVICE,
                        'TRIBUI' NAMEOFSERVICE_VN,
                        SUM(CR.AMT) S_AMT,
                        0 AMT_TAX,
                        SUM(CR.TAX) TAX

            FROM (
                    SELECT SB.CODEID, SB.ISINCODE, ISS.ISSUERID, SB.SYMBOL SECCODE, ISS.FULLNAME SECNAME, SB.PARVALUE,SB.TRADEPLACE, TP.TRADEPLACENAME
                    FROM ISSUERS ISS,SBSECURITIES SB,
                            (
                                SELECT CDVAL TRADEPLACE, CDCONTENT TRADEPLACENAME, EN_CDCONTENT  TRADEPLACENAME_EN
                                FROM ALLCODE
                                WHERE CDNAME='TRADEPLACE' AND CDTYPE ='SE'
                                ORDER BY LSTODR
                            )TP
                    WHERE  ISS.ISSUERID = SB.ISSUERID AND TP.TRADEPLACE = SB.TRADEPLACE
                ) SEC
            LEFT JOIN ( SELECT CL.TXDATE,CL.SELLDATE,CL.TAX,CL.AMT, CR.CUSTODYCD, CR.CODEID,CR.PAYSTATUS
                        FROM CRPHYSAGREE_SELL_LOG CL, CRPHYSAGREE CR
                        WHERE CL.CRPHYSAGREEID = CR.CRPHYSAGREEID AND CR.PAYSTATUS='R' --HOAN THANH 1402
                      ) CR ON CR.CODEID = SEC.CODEID
            LEFT JOIN CFMAST CF ON CF.CUSTODYCD =CR.CUSTODYCD
            GROUP BY
                        CF.CUSTID,
                        SEC.SECCODE,
                        SEC.ISINCODE,
                        SEC.SECNAME,
                        CR.TXDATE,
                        CR.SELLDATE,
                       -- OD.SEACCTNO,
                        SEC.TRADEPLACE
     UNION ALL---------------------------------MAPPING MH 1205 PHI PHAT SINH MOI---------------------------------

             SELECT
                        CF.CUSTID,
                        '' BONDCODE,
                        '' ISINCODE,
                        '' SECNAME,
                        TB.TRANSDATE RECORDDATE,
                        TB.PAYMENTDATE ACTIONDATE,
                        '' EVENTID,
                        ROUND((SUM(TB.VATAMOUNT)*100)/CASE WHEN SUM(TB.AMOUNT) =0 THEN 1 ELSE SUM(TB.AMOUNT) END,5) PITRATE,
                        '' TRADEPLACE,
                        TB.ENGLISH||' received' NAMEOFSERVICE,
                        TB.VIETNAMESE NAMEOFSERVICE_VN,
                        --SUM(TB.AMOUNT) S_AMT, trung.luu : 01-12-2020 SHBVNEX-1052 khong sum
                        TB.AMOUNT S_AMT,
                        0 AMT_TAX,
                        0 TAX

            FROM (
                        SELECT TB.TRANSDATE,TB.PAYMENTDATE,TL.CUSTODYCD,TL.AMOUNT,TL.VATAMOUNT,TL.VIETNAMESE,REGEXP_SUBSTR(TB.REMARK,'[^-]+',1,2) ENGLISH
                        FROM
                        (
                                SELECT SUBSTR(TB.BANKGLOBALID,INSTR(TB.BANKGLOBALID,'.',5)+1,10) AS TXNUM,
                                       TB.*
                                FROM TAX_BOOKING_RESULT TB
                                WHERE NVL(TB.DELTD, 'N') <> 'Y'
                        ) TB,
                        (
                                SELECT TXDATE,TXNUM,"'88'_B" AS CUSTODYCD,"'10'_A" AS AMOUNT,"'26'_A" AS VATAMOUNT,"'30'_B" AS VIETNAMESE
                                FROM
                                (
                                    SELECT TL.TXDATE,TL.TXNUM,TD.FLDCD,TD.NVALUE,TD.CVALUE
                                    FROM
                                    (
                                        SELECT * FROM TLLOG
                                        UNION ALL
                                        SELECT DISTINCT * FROM TLLOGALL
                                    ) TL,
                                    (
                                        SELECT * FROM VW_TLLOGFLD_ALL  WHERE FLDCD IN ('10','26','88','30')
                                    ) TD
                                    WHERE TL.TXNUM = TD.TXNUM AND TL.TXDATE = TD.TXDATE AND TL.TLTXCD = '1205'
                                )
                                PIVOT
                                (
                                MAX(NVALUE) A,
                                MAX(CVALUE) B
                                FOR FLDCD IN ('10','26','88','30')
                                )
                        )TL
                        WHERE TB.TXNUM =TL.TXNUM AND TB.TRANSDATE = TL.TXDATE AND STATUS ='C'
                ) TB
            LEFT JOIN CFMAST CF ON CF.CUSTODYCD =TB.CUSTODYCD
            GROUP BY
                        CF.CUSTID,
                        TB.TRANSDATE,
                        TB.PAYMENTDATE,
                        TB.ENGLISH,
                        TB.VIETNAMESE,
                        TB.AMOUNT --, trung.luu : 01-12-2020 SHBVNEX-1052 khong sum

    ) BD
    WHERE CF.CUSTID=BD.CUSTID AND BD.PITRATE > 0 AND NVL(BD.S_AMT,0) <>0 AND NVL(CIFID,'%') LIKE v_CIFID AND BD.ACTIONDATE BETWEEN V_FROMDATE AND V_TODATE
    ORDER BY BD.ACTIONDATE
)A
;
EXCEPTION
  WHEN OTHERS
   THEN
      PLOG.ERROR ('CA600201: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

      RETURN;
END;
/
