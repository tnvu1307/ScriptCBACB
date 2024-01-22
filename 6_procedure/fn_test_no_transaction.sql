SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE FN_TEST_NO_TRANSACTION
IS
    l_symbol varchar2(100);
    l_actype varchar2(100);
    l_sectype varchar2(100);
    l_valmethod varchar2(100);
    l_check number;
    l_yparam number;
BEGIN
    FOR rec IN
    (
        SELECT ISS.AUTOID ISSUESID, ISS.ISSUECODE,ISS.ISSUERID, ISR.FULLNAME, ISS.ISSUEDATE,
           ISS.VALUEOFISSUE, ISS.LTVRATE, ISS.TYPERATE, ISS.MAXLTVRATE, ISS.WARNINGLTVRATE
        FROM ISSUES ISS, ISSUERS ISR
        WHERE ISR.ISSUERID = ISS.ISSUERID
     )
    LOOP
        FOR r IN (
                    SELECT ISS.AUTOID ISSUESID, SB.SYMBOL, SB.PARVALUE,
                           SB.CODEID, SB.SECTYPE, A1.CDCONTENT SECTYPE_NAME,
                           SUM(MT.QTTY) QTTY,
                           (CASE WHEN SB.SECTYPE IN ('014') THEN SUM(MT.AMT)
                                 WHEN SB.SECTYPE IN ('009','013') THEN SUM(MT.QTTY)*SB.PARVALUE
                                 ELSE 0
                            END) AMT,
                           (CASE WHEN SB.SECTYPE IN ('014') THEN 'CASH'
                                 WHEN SB.SECTYPE IN ('013') THEN 'CD'
                                 WHEN SB.SECTYPE IN ('009') THEN 'TERM_DEPOSIT'
                                 WHEN SB.SECTYPE IN ('003','006') THEN 'BOND'
                                 WHEN SB.SECTYPE IN ('001','008','011') THEN 'SHARE'
                            END) TYPE_PLEDGED,
                           ISS.ISSUECODE, SB.ISSUEDATE
                    FROM (
                            SELECT REPLACE(SE.ACCTNO,SE.AFACCTNO,'') CODEID, SE.ISSUESID,
                                SUM(CASE WHEN SE.TLTXCD IN ('2232') THEN SE.QTTY
                                         WHEN SE.TLTXCD IN ('2233') THEN -SE.QTTY ELSE 0 END) QTTY, 0 AMT
                            FROM SEMORTAGE SE
                            WHERE     SE.STATUS IN ('C')
                                  AND SE.DELTD <> 'Y'
                                  AND SE.ISSUESID IS NOT NULL
                            GROUP BY SE.ACCTNO, SE.AFACCTNO,SE.ISSUESID
                            UNION ALL
                            SELECT REPLACE(SE.ACCTNO,SE.AFACCTNO,'') CODEID, SE.ISSUESID,
                                SUM(CASE WHEN SE.TLTXCD IN ('1900') THEN SE.QTTY
                                         WHEN SE.TLTXCD IN ('1901') THEN -SE.QTTY ELSE 0 END) QTTY, 0 AMT
                            FROM SEMORTAGE SE
                            WHERE     SE.STATUS IN ('C')
                                  AND SE.DELTD <> 'Y'
                                  AND SE.ISSUESID IS NOT NULL
                            GROUP BY SE.ACCTNO, SE.AFACCTNO,SE.ISSUESID
                            UNION ALL
                            SELECT BL.CODEID, BL.ISSUESID, 0 QTTY,
                                SUM(CASE WHEN BL.TLTXCD IN ('1909') THEN BL.AMT
                                         WHEN BL.TLTXCD IN ('1910') THEN -BL.AMT ELSE 0 END) AMT
                            FROM BLOCKAGE BL
                            WHERE     BL.DELTD <> 'Y'
                                  AND BL.ISSUESID IS NOT NULL
                            GROUP BY BL.CODEID,BL.ISSUESID
                         ) MT
                    JOIN SBSECURITIES SB ON MT.CODEID = SB.CODEID
                    JOIN ISSUES ISS ON MT.ISSUESID = ISS.AUTOID
                    JOIN ALLCODE A1 ON A1.CDVAL = SB.SECTYPE AND CDNAME ='SECTYPE' AND CDTYPE ='SA'
                    JOIN ISSUERS ISR ON ISR.ISSUERID = ISS.ISSUERID
                    WHERE NOT (MT.QTTY = 0 AND MT.AMT = 0)
                          AND MT.ISSUESID = REC.ISSUESID
                    GROUP BY ISS.AUTOID, SB.SYMBOL, SB.PARVALUE, SB.CODEID, SB.SECTYPE, A1.CDCONTENT, ISS.ISSUECODE, SB.ISSUEDATE
                )
        LOOP
            BEGIN
                SELECT SYMBOL, ACTYPE, SECTYPE, VALMETHOD, COUNT(1)
                INTO l_symbol, l_actype, l_sectype, l_valmethod, l_check
                FROM (
                        SELECT DISTINCT TRIM(REGEXP_SUBSTR(BO.TICKERLIST,'[^,]+', 1, LEVEL)) SYMBOL, BO.ACTYPE, BO.SECTYPE, BO.VALMETHOD
                        FROM BONDTYPE BO
                        WHERE BO.ISSUESID = r.ISSUESID
                        CONNECT BY REGEXP_SUBSTR(BO.TICKERLIST, '[^,]+', 1, LEVEL) IS NOT NULL
                     )
                WHERE SYMBOL = r.SYMBOL
                GROUP BY SYMBOL, ACTYPE, SECTYPE, VALMETHOD;
            EXCEPTION WHEN OTHERS THEN
                l_check := 0;
            END;
            IF l_check <> 0 THEN
                IF l_sectype = '111' THEN
                    IF FN_CHECK_NO_TRANSACTION(l_symbol, l_actype, l_sectype, l_valmethod, l_yparam) = TRUE THEN
                        NMPKS_EMS.PR_SENDINTERNALEMAIL('SELECT ''' || l_symbol || ''' p_symbol, ''' || TO_CHAR(r.ISSUEDATE,'DD/MM/RRRR') || ''' p_issuedate, ''' || TO_CHAR(getcurrdate, 'DD/MM/RRRR') || ''' p_currdate, ''' || l_yparam || ''' p_yparam FROM DUAL', 'EM46', '','N');
                    END IF;
                END IF;
            END IF;
        END LOOP;
    END LOOP;
    COMMIT;
EXCEPTION WHEN OTHERS THEN
    plog.error ('FN_TEST_NO_TRANSACTION: ' || SQLERRM || dbms_utility.format_error_backtrace);
END;
/
