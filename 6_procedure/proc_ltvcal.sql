SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE proc_ltvcal(P_TXDATE date, P_ISSUERID varchar2)
IS
    l_valueofissue              NUMBER(20,4); --tong gia tri phat hanh cua dot phat hanh
    l_ltv                       NUMBER(20,4);
    l_date                      date;
    l_symbol                    varchar2(100);
    l_actype                    varchar2(10);
    l_sectype                   varchar2(10);
    l_valmethod                 varchar2(10);
    --NAM.LY
    l_check                     NUMBER := 0;
    l_typerate                  VARCHAR2(3);  --loai nguyen tac dinh gia tai san dam bao
    l_type_pledged              VARCHAR2(15); --Loai tai san cam co
    l_sec_val_price             NUMBER(20,4); --Gia tri dinh gia cua chung khoan
    l_t_percent                 NUMBER(20,4); --T% cua tien gui/tien mat
    l_sec_qtty                  NUMBER;       --so luong chung khoan
    l_cash_amt                  NUMBER(20,4); --menh gia cua tien mat
    l_total_sec_amt             NUMBER(20,4); --tong gia tri cua tai sai cam co la chung khoan
    l_total_cashdepo_amt        NUMBER(20,4); --tong gia tri cua tien gui/tien mat
    l_count NUMBER;

BEGIN
    l_date:= P_TXDATE;
    FOR rec IN
        (
            SELECT ISS.AUTOID ISSUESID, ISS.ISSUECODE,ISS.ISSUERID, ISR.FULLNAME, ISS.ISSUEDATE,
               ISS.VALUEOFISSUE, ISS.LTVRATE, ISS.TYPERATE, ISS.MAXLTVRATE, ISS.WARNINGLTVRATE
            FROM ISSUES ISS, ISSUERS ISR
            WHERE ISR.ISSUERID = ISS.ISSUERID
            AND ISS.AUTOID like nvl(P_ISSUERID,'%%')
         )
    LOOP
        l_valueofissue       := to_number(rec.VALUEOFISSUE);
        l_total_sec_amt      := 0;
        l_total_cashdepo_amt := 0;
        l_typerate           := rec.TYPERATE;
        FOR REC2 IN (
            SELECT ISS.AUTOID ISSUESID, SB.SYMBOL, SB.PARVALUE, SB.CODEID, SB.SECTYPE, A1.CDCONTENT SECTYPE_NAME, SUM(MT.QTTY) QTTY,
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
                   ISS.ISSUECODE
            FROM (
                    SELECT REPLACE(SE.ACCTNO,SE.AFACCTNO,'') CODEID, SE.ISSUESID,
                        SUM(CASE WHEN SE.TLTXCD IN ('2232') THEN SE.QTTY
                                 WHEN SE.TLTXCD IN ('2233') THEN -SE.QTTY ELSE 0 END) QTTY, 0 AMT
                    FROM SEMORTAGE SE
                    WHERE SE.STATUS IN ('C')
                    AND SE.DELTD <> 'Y'
                    AND SE.ISSUESID IS NOT NULL
                    AND SE.TXDATE <= l_date
                    GROUP BY SE.ACCTNO, SE.AFACCTNO,SE.ISSUESID

                    UNION ALL

                    SELECT REPLACE(SE.ACCTNO,SE.AFACCTNO,'') CODEID, SE.ISSUESID,
                        SUM(CASE WHEN SE.TLTXCD IN ('1900') THEN SE.QTTY
                                 WHEN SE.TLTXCD IN ('1901') THEN -SE.QTTY ELSE 0 END) QTTY, 0 AMT
                    FROM SEMORTAGE SE
                   WHERE SE.STATUS IN ('C')
                    AND SE.DELTD <> 'Y'
                    AND SE.ISSUESID IS NOT NULL
                    AND SE.TXDATE <= l_date
                    GROUP BY SE.ACCTNO, SE.AFACCTNO,SE.ISSUESID

                    UNION ALL

                    SELECT BL.CODEID, BL.ISSUESID, 0 QTTY,
                        SUM(CASE WHEN BL.TLTXCD IN ('1909') THEN BL.AMT
                                 WHEN BL.TLTXCD IN ('1910') THEN -BL.AMT ELSE 0 END) AMT
                    FROM BLOCKAGE BL
                    WHERE BL.DELTD <> 'Y'
                    AND BL.ISSUESID IS NOT NULL
                    AND BL.TXDATE <= l_date
                    GROUP BY BL.CODEID,BL.ISSUESID
                 ) MT
            JOIN SBSECURITIES SB ON MT.CODEID = SB.CODEID
            JOIN ISSUES ISS ON MT.ISSUESID = ISS.AUTOID
            JOIN ALLCODE A1 ON A1.CDVAL = SB.SECTYPE AND CDNAME ='SECTYPE' AND CDTYPE ='SA'
            JOIN ISSUERS ISR ON ISR.ISSUERID = ISS.ISSUERID
            WHERE NOT (MT.QTTY = 0 AND MT.AMT = 0)
            AND MT.ISSUESID = REC.ISSUESID
            GROUP BY ISS.AUTOID, SB.SYMBOL, SB.PARVALUE, SB.CODEID, SB.SECTYPE, A1.CDCONTENT, ISS.ISSUECODE
        )
        LOOP
            l_sec_qtty     := REC2.QTTY;
            l_cash_amt     := REC2.AMT;
            l_type_pledged := REC2.TYPE_PLEDGED;
            BEGIN
                SELECT SYMBOL, ACTYPE, SECTYPE, VALMETHOD, COUNT(1)
                INTO l_symbol, l_actype, l_sectype, l_valmethod, l_check
                FROM (
                        SELECT DISTINCT TRIM(REGEXP_SUBSTR(BO.TICKERLIST,'[^,]+', 1, LEVEL)) SYMBOL, BO.ACTYPE, BO.SECTYPE, BO.VALMETHOD
                        FROM BONDTYPE BO
                        WHERE BO.ISSUESID = REC2.ISSUESID
                        CONNECT BY REGEXP_SUBSTR(BO.TICKERLIST, '[^,]+', 1, LEVEL) IS NOT NULL
                     )
                WHERE SYMBOL = REC2.SYMBOL
               GROUP BY SYMBOL, ACTYPE, SECTYPE, VALMETHOD;
            EXCEPTION WHEN OTHERS THEN
                l_sec_val_price := 0;
                l_t_percent     := 0;
            END;

            IF l_check <> 0 THEN
                BEGIN
                    IF l_sectype <> '555' THEN --co phieu & trai phieu
                        l_sec_val_price := NVL(fn_get_mortage_price_txdate(l_symbol, l_actype, l_sectype, l_valmethod, l_date),0);

                        DELETE FROM BONDINFO WHERE ISSUESID = REC2.ISSUESID AND TXDATE = l_date and CODEID = REC2.CODEID;
                        INSERT INTO BONDINFO (ISSUESID, TXDATE, BONDACTYPE, BONDPRICE, CODEID, VBMA, REUTERS, INTERPOLATION, SYMBOL, NOTE, PRICETYPE)
                        VALUES (REC2.ISSUESID, l_date, l_actype, l_sec_val_price, REC2.CODEID, NULL, NULL, NULL, l_symbol, NULL, l_valmethod);
                    ELSE --tien
                        l_t_percent     := NVL(fn_get_mortage_price_txdate(l_symbol, l_actype, l_sectype, l_valmethod, l_date),0);

                        DELETE FROM BONDINFO WHERE ISSUESID = REC2.ISSUESID AND TXDATE = l_date and CODEID = REC2.CODEID;
                        INSERT INTO BONDINFO (ISSUESID, TXDATE, BONDACTYPE, TPERCENT, CODEID, VBMA, REUTERS, INTERPOLATION, SYMBOL, NOTE, PRICETYPE)
                        VALUES (REC2.ISSUESID, l_date, l_actype, l_t_percent, REC2.CODEID, NULL, NULL, NULL, l_symbol, NULL, l_valmethod);
                    END IF;
                END;
                l_check := 0;
            END IF;

            IF (l_type_pledged = 'SHARE' OR l_type_pledged = 'BOND') THEN
                l_total_sec_amt := l_total_sec_amt + (l_sec_qtty * l_sec_val_price);
            ELSIF (l_type_pledged = 'CASH' OR l_type_pledged = 'CD' OR l_type_pledged = 'TERM_DEPOSIT') THEN
                l_total_cashdepo_amt := l_total_cashdepo_amt + (l_cash_amt*(l_t_percent/100));
            END IF;
        END LOOP;

        --TINH LTVRATE
        IF L_TYPERATE ='002' THEN --LTV
            L_LTV := ROUND(((L_VALUEOFISSUE - L_TOTAL_CASHDEPO_AMT)/L_TOTAL_SEC_AMT)*100,2);
        ELSIF L_TYPERATE ='003' THEN --CCR
            L_LTV := ROUND((L_TOTAL_SEC_AMT/(L_VALUEOFISSUE - L_TOTAL_CASHDEPO_AMT))*100,2);
        END IF;

        IF L_DATE = GETCURRDATE THEN
            UPDATE ISSUES SET LTVRATE = L_LTV
            WHERE AUTOID = REC.ISSUESID;
        ELSE
            SELECT COUNT(1) INTO L_COUNT FROM ISSUES_HIST WHERE AUTOID = REC.ISSUESID AND HISTDATE = L_DATE;
            IF L_COUNT = 0 THEN
                INSERT INTO ISSUES_HIST (HISTDATE, AUTOID, ISSUERID, ISSUECODE, VALUEOFISSUE, STATUS, PSTATUS, CREATEDDT, LAST_CHANGE, ISSUEDATE, TYPERATE, MAXLTVRATE, WARNINGLTVRATE, LTVRATE)
                SELECT L_DATE HISTDATE, AUTOID, ISSUERID, ISSUECODE, VALUEOFISSUE, STATUS, PSTATUS, CREATEDDT, LAST_CHANGE, ISSUEDATE, TYPERATE, MAXLTVRATE, WARNINGLTVRATE, L_LTV LTVRATE
                FROM ISSUES
                WHERE AUTOID=REC.ISSUESID;
            ELSE
                UPDATE ISSUES_HIST SET LTVRATE = L_LTV
                WHERE AUTOID = REC.ISSUESID
                AND HISTDATE = L_DATE;
            END IF;
        END IF;
    END LOOP;
EXCEPTION WHEN OTHERS THEN
    pr_error('proc_LTVCal', 'error:' || SQLERRM || to_char(dbms_utility.format_error_backtrace));
END;
/
