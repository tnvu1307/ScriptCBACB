SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_ISSUES
(AUTOID, ISSUERID, SHORTNAME, FULLNAME, ISSUECODE, 
 ISSUEVAL, VALUEOFISSUE, ISSUEDATE, MAXLTVRATE, WARNINGLTVRATE, 
 MATURITYDATE, VTYPERATE, VPURPOSE, VROLE, EFFECTIVE, 
 APRALLOW, LTVRATE)
AS 
(
    SELECT ISS.AUTOID, ISS.ISSUERID, ISR.SHORTNAME, ISR.FULLNAME, ISS.ISSUECODE, ISS.ISSUEVAL, ISS.VALUEOFISSUE, ISS.ISSUEDATE, ISS.MAXLTVRATE, ISS.WARNINGLTVRATE, ISS.MATURITYDATE,
        ISS.TYPERATE VTYPERATE, ISS.PURPOSE VPURPOSE, ISS.ROLE VROLE, ISS.EFFECTIVE,
        (CASE WHEN ISS.STATUS IN ('P') THEN 'Y' ELSE 'N' END) APRALLOW,
        ROUND(
            CASE WHEN ISS.TYPERATE = '002' THEN (CASE WHEN NVL(MRK.AMT,0) = 0 THEN 0 ELSE ISS.VALUEOFISSUE/NVL(MRK.AMT,0) END)
                 WHEN ISS.TYPERATE = '003' THEN (CASE WHEN ISS.VALUEOFISSUE = 0 THEN 0 ELSE NVL(MRK.AMT,0)/ISS.VALUEOFISSUE END)
                 ELSE 0
            END
        , 4) * 100 LTVRATE
    FROM ISSUES ISS
    JOIN ISSUERS ISR ON ISS.ISSUERID = ISR.ISSUERID
    LEFT JOIN
    (
        SELECT MT.ISSUESID,
            SUM(ROUND(
                CASE WHEN MK.SECTYPE = '222' THEN MT.QTTY * MK.SHAREPRICE
                     WHEN MK.SECTYPE = '555' THEN (CASE WHEN MK.VALMETHOD = '001' THEN MK.XPARAM ELSE 0 END)
                     ELSE (
                        CASE WHEN SB.SECTYPE IN ('001','008','011','003','006') THEN MT.QTTY * MK.SHAREPRICE
                             ELSE (CASE WHEN SB.SECTYPE IN ('014') THEN MT.AMT
                                        WHEN SB.SECTYPE IN ('009','013') THEN MT.QTTY * SB.PARVALUE
                                        ELSE 0
                                  END) /100
                        END
                     )
                 END
           , 10)) AMT
        FROM SBSECURITIES SB,
        (
            SELECT SEM.ISSUESID, SEM.CODEID, SUM(SEM.QTTY) QTTY, SUM(SEM.AMT) AMT
            FROM
            (
                SELECT REPLACE(SE.ACCTNO,SE.AFACCTNO,'') CODEID, SE.ISSUESID, SE.TXDATE,
                       SUM(CASE WHEN SE.TLTXCD IN ('2232') THEN SE.QTTY
                                WHEN SE.TLTXCD IN ('2233') THEN -SE.QTTY ELSE 0 END) QTTY, 0 AMT
                FROM SEMORTAGE SE
                WHERE SE.STATUS IN ('C')
                AND SE.DELTD <> 'Y'
                AND SE.ISSUESID IS NOT NULL
                GROUP BY SE.ACCTNO, SE.AFACCTNO, SE.ISSUESID, SE.TXDATE
                UNION ALL
                SELECT REPLACE(SE.ACCTNO,SE.AFACCTNO,'') CODEID, SE.ISSUESID, SE.TXDATE,
                       SUM(CASE WHEN SE.TLTXCD IN ('1900') THEN SE.QTTY
                                WHEN SE.TLTXCD IN ('1901') THEN -SE.QTTY ELSE 0 END) QTTY, 0 AMT
                FROM SEMORTAGE SE
                WHERE SE.STATUS IN ('C')
                AND SE.DELTD <> 'Y'
                AND SE.ISSUESID IS NOT NULL
                GROUP BY SE.ACCTNO, SE.AFACCTNO, SE.ISSUESID, SE.TXDATE
                UNION ALL
                SELECT BL.CODEID, BL.ISSUESID, BL.TXDATE, 0 QTTY,
                       SUM(CASE WHEN BL.TLTXCD IN ('1909') THEN BL.AMT
                                WHEN BL.TLTXCD IN ('1910') THEN -BL.AMT ELSE 0 END) AMT
                FROM BLOCKAGE BL
                WHERE BL.DELTD <> 'Y'
                AND BL.ISSUESID IS NOT NULL
                GROUP BY BL.CODEID, BL.ISSUESID, BL.TXDATE
            ) SEM
            GROUP BY SEM.ISSUESID, SEM.CODEID
         ) MT,
         (
            SELECT MK.SYMBOL, BO.ISSUESID, BO.XPARAM, BO.VALMETHOD, BO.SECTYPE,
                   ROUND(
                        CASE WHEN BO.SECTYPE = '111' THEN (CASE WHEN BO.VALMETHOD = '001' THEN AVG(MK.PCLOSED) ELSE (CASE WHEN SUM(MK.TRANVALUE) = 0 THEN 0 ELSE SUM(MK.TRANVALUE)/SUM(MK.VOLUME) END) END)
                        ELSE 0 END
                   ,10) SHAREPRICE
            FROM SBREFMRKDATA MK,
            (
                SELECT DISTINCT TRIM(REGEXP_SUBSTR(BO.TICKERLIST,'[^,]+', 1, LEVEL)) SYMBOL, BO.ACTYPE, BO.SECTYPE, BO.VALMETHOD, BO.ISSUESID, BO.XPARAM
                FROM BONDTYPE BO
                CONNECT BY REGEXP_SUBSTR(BO.TICKERLIST, '[^,]+', 1, LEVEL) IS NOT NULL
            ) BO
            WHERE MK.SYMBOL = BO.SYMBOL
            AND BO.SECTYPE NOT IN ('222')
            AND MK.TRADINGDT <= GETCURRDATE
            AND MK.TRADINGDT > (SELECT SBDATE
                                FROM (
                                    SELECT ROWNUM DAY, CLDR.SBDATE
                                    FROM (
                                        SELECT SBDATE
                                        FROM SBCLDR
                                        WHERE SBDATE < GETPREVWORKINGDATE(GETCURRDATE)
                                        AND HOLIDAY = 'N'
                                        AND CLDRTYPE = '001'
                                        ORDER BY SBDATE DESC
                                    ) CLDR
                                ) RL
                                WHERE RL.DAY = BO.XPARAM)
            GROUP BY MK.SYMBOL, BO.XPARAM, BO.VALMETHOD, BO.SECTYPE, BO.ISSUESID
            UNION ALL
            SELECT BO.SYMBOL, BO.ISSUESID, BO.XPARAM, BO.VALMETHOD, BO.SECTYPE,
                ROUND(SUM(FN_GET_INTPRICE2(BO.SYMBOL, GETCURRDATE)),10) SHAREPRICE
            FROM
            (
                SELECT DISTINCT TRIM(REGEXP_SUBSTR(BO.TICKERLIST,'[^,]+', 1, LEVEL)) SYMBOL, BO.ACTYPE, BO.SECTYPE, BO.VALMETHOD, BO.ISSUESID, BO.XPARAM
                FROM BONDTYPE BO
                CONNECT BY REGEXP_SUBSTR(BO.TICKERLIST, '[^,]+', 1, LEVEL) IS NOT NULL
            ) BO
            WHERE BO.SECTYPE IN ('222')
            GROUP BY BO.SYMBOL, BO.XPARAM, BO.VALMETHOD, BO.SECTYPE, BO.ISSUESID
        ) MK
        WHERE SB.SYMBOL = MK.SYMBOL
        AND SB.CODEID = MT.CODEID
        AND MK.ISSUESID = MT.ISSUESID
        GROUP BY MT.ISSUESID
    ) MRK ON MRK.ISSUESID = ISS.AUTOID
)
/
