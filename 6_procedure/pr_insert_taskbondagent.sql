SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE pr_insert_taskbondagent
IS
v_currdate date;
BEGIN
        select to_date(varvalue,'dd/MM/RRRR') into v_currdate from sysvar where varname = 'CURRDATE';

        BEGIN
            INSERT INTO TASKBONDAGENT(AUTOID,TYPE,TASK,DEADLINE,STATUS,SYMBOL,ISSUEDATE)
            SELECT SEQ_TASKBONDAGENT.NEXTVAL,A1.CDCONTENT TYPE,A2.CDCONTENT TASK, TO_DATE(DEADLINE,'DD/MM/RRRR'),'O',V.SYMBOL,V.ISSUEDATE
            FROM (
                SELECT 'type1' TYPE, 'task1' TASK,TO_CHAR((
                                                        SELECT SBDATE
                                                        FROM (
                                                            SELECT ROWNUM DAY, CLDR.SBDATE
                                                            FROM (
                                                                SELECT SBDATE FROM SBCLDR WHERE SBDATE > CONTRACTDATE AND HOLIDAY = 'N' AND CLDRTYPE = '001' ORDER BY SBDATE ASC
                                                            ) CLDR
                                                        ) RL
                                                        WHERE RL.DAY = 10)) DEADLINE,SYMBOL,ISSUEDATE
                FROM (
                    SELECT *FROM (
                        SELECT SB.*
                        FROM SBSECURITIES SB, ISSUES ISS, ISSUERS ISR, BONDISSUE BI
                        WHERE SB.CODEID = BI.BONDCODE AND SB.SYMBOL = BI.BONDSYMBOL
                        AND BI.ISSUESID = ISS.AUTOID
                        AND ISS.ISSUERID = ISR.ISSUERID
                        AND ISS.EFFECTIVE = 'Y'
                        AND NVL(ISS.MATURITYDATE, V_CURRDATE) >= V_CURRDATE
                        AND TO_CHAR(SB.CONTRACTDATE,'RRRR') = TO_CHAR(TO_DATE(V_CURRDATE,'DD/MM/RRRR'),'RRRR')
                    ) WHERE SECTYPE = '006' OR(SECTYPE = '015' AND TRADEPLACE ='003') AND TO_CHAR(ISSUEDATE,'RRRR') = TO_CHAR(TO_DATE(V_CURRDATE,'DD/MM/RRRR'),'RRRR')
                )
                WHERE (
                    SELECT SBDATE
                    FROM (
                        SELECT ROWNUM DAY, CLDR.SBDATE
                        FROM (
                            SELECT   SBDATE FROM SBCLDR WHERE SBDATE > CONTRACTDATE AND HOLIDAY = 'N' AND CLDRTYPE = '001' ORDER BY SBDATE ASC
                        ) CLDR
                    ) RL
                     WHERE RL.DAY = 1
                ) <= V_CURRDATE
                AND V_CURRDATE <= (
                            SELECT SBDATE
                            FROM (
                                SELECT ROWNUM DAY, CLDR.SBDATE
                                FROM (
                                    SELECT SBDATE FROM SBCLDR WHERE SBDATE > CONTRACTDATE AND HOLIDAY = 'N' AND CLDRTYPE = '001' ORDER BY SBDATE ASC
                                ) CLDR
                            ) RL
                            WHERE RL.DAY = 10)
            )V,
            (SELECT *FROM ALLCODE WHERE CDTYPE ='BA' AND CDNAME ='BONDAGENTTYPE') A1,
            (SELECT *FROM ALLCODE WHERE CDTYPE ='BA' AND CDNAME ='BONDAGENTTASK') A2
            WHERE V.TYPE = A1.CDVAL(+)
            AND V.TASK = A2.CDVAL(+)
            AND (A1.CDCONTENT, A2.CDCONTENT, TO_DATE(DEADLINE,'DD/MM/RRRR'), V.SYMBOL, V.ISSUEDATE) NOT IN (SELECT TYPE,TASK,DEADLINE,SYMBOL,ISSUEDATE FROM TASKBONDAGENT WHERE STATUS = 'O');
        END;
        BEGIN
            INSERT INTO TASKBONDAGENT(AUTOID,TYPE,TASK,DEADLINE,STATUS,SYMBOL,ISSUEDATE)
            SELECT SEQ_TASKBONDAGENT.NEXTVAL,A1.CDCONTENT TYPE,A2.CDCONTENT TASK, TO_DATE(DEADLINE,'DD/MM/RRRR'),'O',V.SYMBOL,V.ISSUEDATE
            FROM (
                    SELECT 'type1' TYPE, 'task2' TASK,TO_CHAR((
                                                            SELECT SBDATE
                                                            FROM (
                                                                SELECT ROWNUM DAY, CLDR.SBDATE
                                                                FROM (
                                                                    SELECT SBDATE FROM SBCLDR WHERE SBDATE > ISSUEDATE AND HOLIDAY = 'N' AND CLDRTYPE = '001' ORDER BY SBDATE ASC
                                                                ) CLDR
                                                            ) RL
                                                            WHERE RL.DAY = 3)) DEADLINE,SYMBOL,ISSUEDATE
                    FROM (
                        SELECT *FROM (
                            SELECT SB.*
                            FROM SBSECURITIES SB, ISSUES ISS, ISSUERS ISR, BONDISSUE BI
                            WHERE SB.CODEID = BI.BONDCODE AND SB.SYMBOL = BI.BONDSYMBOL
                            AND BI.ISSUESID = ISS.AUTOID
                            AND ISS.ISSUERID = ISR.ISSUERID
                            AND ISS.EFFECTIVE = 'Y'
                            AND NVL(ISS.MATURITYDATE, V_CURRDATE) >= V_CURRDATE
                            AND TO_CHAR(SB.CONTRACTDATE,'RRRR') = TO_CHAR(TO_DATE(V_CURRDATE,'DD/MM/RRRR'),'RRRR')
                        ) WHERE SECTYPE = '006' OR(SECTYPE = '015' AND TRADEPLACE ='003')
                    )
                    WHERE (
                        SELECT SBDATE
                        FROM (
                            SELECT ROWNUM DAY, CLDR.SBDATE
                            FROM (
                                SELECT   SBDATE FROM SBCLDR WHERE SBDATE > ISSUEDATE AND HOLIDAY = 'N' AND CLDRTYPE = '001' ORDER BY SBDATE ASC
                            ) CLDR
                        ) RL
                        WHERE RL.DAY = 1
                    ) <= V_CURRDATE
                    AND V_CURRDATE <= (
                                SELECT SBDATE
                                FROM (
                                    SELECT ROWNUM DAY, CLDR.SBDATE
                                    FROM (
                                        SELECT   SBDATE FROM SBCLDR WHERE SBDATE > ISSUEDATE AND HOLIDAY = 'N' AND CLDRTYPE = '001' ORDER BY SBDATE ASC
                                    ) CLDR
                                ) RL
                                WHERE RL.DAY = 3)
                )V,
                (SELECT *FROM ALLCODE WHERE CDTYPE ='BA' AND CDNAME ='BONDAGENTTYPE') A1,
                (SELECT *FROM ALLCODE WHERE CDTYPE ='BA' AND CDNAME ='BONDAGENTTASK') A2
            WHERE V.TYPE = A1.CDVAL(+)
            AND V.TASK = A2.CDVAL(+)
            AND (A1.CDCONTENT, A2.CDCONTENT, TO_DATE(DEADLINE,'DD/MM/RRRR'), V.SYMBOL, V.ISSUEDATE) NOT IN (SELECT TYPE,TASK,DEADLINE,SYMBOL,ISSUEDATE FROM TASKBONDAGENT WHERE STATUS = 'O');
        END;
        BEGIN
            INSERT INTO TASKBONDAGENT(AUTOID,TYPE,TASK,DEADLINE,STATUS,SYMBOL,ISSUEDATE)
            SELECT SEQ_TASKBONDAGENT.NEXTVAL,A1.CDCONTENT TYPE,A2.CDCONTENT TASK, TO_DATE(DEADLINE,'DD/MM/RRRR'),'O',V.SYMBOL,V.ISSUEDATE
            FROM (
                    SELECT 'type1' TYPE, 'task4' TASK,TO_CHAR((
                                                            SELECT SBDATE
                                                            FROM (
                                                                SELECT ROWNUM DAY, CLDR.SBDATE
                                                                FROM (
                                                                    SELECT SBDATE FROM SBCLDR WHERE SBDATE > ISSUEDATE AND HOLIDAY = 'N' AND CLDRTYPE = '001' ORDER BY SBDATE ASC
                                                                ) CLDR
                                                            ) RL
                                                            WHERE RL.DAY = 5)) DEADLINE,SYMBOL,ISSUEDATE
                    FROM (
                        SELECT *FROM (
                            SELECT SB.*
                            FROM SBSECURITIES SB, ISSUES ISS, ISSUERS ISR, BONDISSUE BI
                            WHERE SB.CODEID = BI.BONDCODE AND SB.SYMBOL = BI.BONDSYMBOL
                            AND BI.ISSUESID = ISS.AUTOID
                            AND ISS.ISSUERID = ISR.ISSUERID
                            AND ISS.EFFECTIVE = 'Y'
                            AND NVL(ISS.MATURITYDATE, V_CURRDATE) >= V_CURRDATE
                            AND TO_CHAR(SB.CONTRACTDATE,'RRRR') = TO_CHAR(TO_DATE(V_CURRDATE,'DD/MM/RRRR'),'RRRR')
                        ) WHERE SECTYPE = '006' OR(SECTYPE = '015' AND TRADEPLACE ='003')
                    )
                    WHERE (
                        SELECT SBDATE
                        FROM (
                            SELECT ROWNUM DAY, CLDR.SBDATE
                            FROM (
                                SELECT   SBDATE FROM SBCLDR WHERE SBDATE > ISSUEDATE AND HOLIDAY = 'N' AND CLDRTYPE = '001' ORDER BY SBDATE ASC
                            ) CLDR
                        ) RL
                        WHERE RL.DAY = 1
                    ) <= V_CURRDATE
                    AND V_CURRDATE <= (
                            SELECT SBDATE
                            FROM (
                                SELECT ROWNUM DAY, CLDR.SBDATE
                                FROM (
                                    SELECT   SBDATE FROM SBCLDR WHERE SBDATE > ISSUEDATE AND HOLIDAY = 'N' AND CLDRTYPE = '001' ORDER BY SBDATE ASC
                                ) CLDR
                            ) RL
                            WHERE RL.DAY = 5)
                )V,
                (SELECT *FROM ALLCODE WHERE CDTYPE ='BA' AND CDNAME ='BONDAGENTTYPE') A1,
                (SELECT *FROM ALLCODE WHERE CDTYPE ='BA' AND CDNAME ='BONDAGENTTASK') A2
            WHERE V.TYPE = A1.CDVAL(+)
            AND V.TASK = A2.CDVAL(+)
            AND (A1.CDCONTENT, A2.CDCONTENT, TO_DATE(DEADLINE,'DD/MM/RRRR'), V.SYMBOL, V.ISSUEDATE) NOT IN (SELECT TYPE,TASK,DEADLINE,SYMBOL,ISSUEDATE FROM TASKBONDAGENT WHERE STATUS = 'O');
        END;
        BEGIN
            INSERT INTO TASKBONDAGENT(AUTOID,TYPE,TASK,DEADLINE,STATUS,SYMBOL,ISSUEDATE)
            SELECT SEQ_TASKBONDAGENT.NEXTVAL,A1.CDCONTENT TYPE,A2.CDCONTENT TASK, TO_DATE(DEADLINE,'DD/MM/RRRR'),'O',V.SYMBOL,V.ISSUEDATE
            FROM (
                    SELECT 'type1' TYPE,'task3' TASK,TO_CHAR((
                                                            SELECT SBDATE
                                                            FROM (
                                                                SELECT ROWNUM DAY, CLDR.SBDATE
                                                                FROM (
                                                                    SELECT SBDATE FROM SBCLDR WHERE SBDATE > ISSUEDATE AND HOLIDAY = 'N' AND CLDRTYPE = '001' ORDER BY SBDATE ASC
                                                                ) CLDR
                                                            ) RL
                                                            WHERE RL.DAY = 3)) DEADLINE,SYMBOL,ISSUEDATE
                    FROM (
                        SELECT *FROM (
                            SELECT SB.*
                            FROM SBSECURITIES SB, ISSUES ISS, ISSUERS ISR, BONDISSUE BI
                            WHERE SB.CODEID = BI.BONDCODE AND SB.SYMBOL = BI.BONDSYMBOL
                            AND BI.ISSUESID = ISS.AUTOID
                            AND ISS.ISSUERID = ISR.ISSUERID
                            AND ISS.EFFECTIVE = 'Y'
                            AND NVL(ISS.MATURITYDATE, V_CURRDATE) >= V_CURRDATE
                            AND TO_CHAR(SB.CONTRACTDATE,'RRRR') = TO_CHAR(TO_DATE(V_CURRDATE,'DD/MM/RRRR'),'RRRR')
                        ) WHERE SECTYPE = '006' OR(SECTYPE = '015' AND TRADEPLACE ='003')
                    )
                    WHERE (
                        SELECT SBDATE
                        FROM (
                            SELECT ROWNUM DAY, CLDR.SBDATE
                            FROM (
                                SELECT SBDATE FROM SBCLDR WHERE SBDATE > ISSUEDATE AND HOLIDAY = 'N' AND CLDRTYPE = '001' ORDER BY SBDATE ASC
                            ) CLDR
                        ) RL
                        WHERE RL.DAY = 1
                    ) <= V_CURRDATE
                    AND V_CURRDATE <=  (
                            SELECT SBDATE
                            FROM (
                                SELECT ROWNUM DAY, CLDR.SBDATE
                                FROM (
                                    SELECT   SBDATE FROM SBCLDR WHERE SBDATE > ISSUEDATE AND HOLIDAY = 'N' AND CLDRTYPE = '001' ORDER BY SBDATE ASC
                                ) CLDR
                            ) RL
                            WHERE RL.DAY = 3)
                )V,
                (SELECT *FROM ALLCODE WHERE CDTYPE ='BA' AND CDNAME ='BONDAGENTTYPE') A1,
                (SELECT *FROM ALLCODE WHERE CDTYPE ='BA' AND CDNAME ='BONDAGENTTASK') A2
            WHERE V.TYPE = A1.CDVAL(+)
            AND V.TASK = A2.CDVAL(+)
            AND (A1.CDCONTENT, A2.CDCONTENT, TO_DATE(DEADLINE,'DD/MM/RRRR'), V.SYMBOL, V.ISSUEDATE) NOT IN (SELECT TYPE,TASK,DEADLINE,SYMBOL,ISSUEDATE FROM TASKBONDAGENT WHERE STATUS = 'O');
        END;
        BEGIN
            INSERT INTO TASKBONDAGENT(AUTOID,TYPE,TASK,DEADLINE,STATUS,SYMBOL,ISSUEDATE)
            SELECT SEQ_TASKBONDAGENT.NEXTVAL,A1.CDCONTENT TYPE,A2.CDCONTENT TASK, TO_DATE(DEADLINE,'DD/MM/RRRR'),'O',V.SYMBOL,V.ISSUEDATE
            FROM (
                    SELECT 'type2' TYPE, 'task5' TASK, TO_CHAR((
                                                                SELECT SBDATE
                                                                FROM (
                                                                    SELECT ROWNUM DAY, CLDR.SBDATE
                                                                    FROM (
                                                                        SELECT SBDATE FROM SBCLDR WHERE SBDATE > ISSUEDATE AND HOLIDAY = 'N' AND CLDRTYPE = '001' ORDER BY SBDATE ASC
                                                                    ) CLDR
                                                                ) RL
                                                                WHERE RL.DAY = 5)) DEADLINE,SYMBOL,ISSUEDATE
                    FROM (
                        SELECT *FROM (
                            SELECT SB.*
                            FROM SBSECURITIES SB, ISSUES ISS, ISSUERS ISR, BONDISSUE BI
                            WHERE SB.CODEID = BI.BONDCODE AND SB.SYMBOL = BI.BONDSYMBOL
                            AND BI.ISSUESID = ISS.AUTOID
                            AND ISS.ISSUERID = ISR.ISSUERID
                            AND ISS.EFFECTIVE = 'Y'
                            AND NVL(ISS.MATURITYDATE, V_CURRDATE) >= V_CURRDATE
                            AND TO_CHAR(SB.CONTRACTDATE,'RRRR') = TO_CHAR(TO_DATE(V_CURRDATE,'DD/MM/RRRR'),'RRRR')
                        ) WHERE SECTYPE = '006' OR(SECTYPE = '015' AND TRADEPLACE ='003')
                    )
                    WHERE (
                        SELECT SBDATE
                        FROM (
                            SELECT ROWNUM DAY, CLDR.SBDATE
                            FROM (
                                SELECT SBDATE FROM SBCLDR WHERE SBDATE > ISSUEDATE AND HOLIDAY = 'N' AND CLDRTYPE = '001' ORDER BY SBDATE ASC
                            ) CLDR
                        ) RL
                        WHERE RL.DAY = 1
                    ) <= V_CURRDATE
                    AND V_CURRDATE <= (
                        SELECT SBDATE
                        FROM (
                            SELECT ROWNUM DAY, CLDR.SBDATE
                            FROM (
                                SELECT SBDATE FROM SBCLDR WHERE SBDATE > ISSUEDATE AND HOLIDAY = 'N' AND CLDRTYPE = '001' ORDER BY SBDATE ASC
                            ) CLDR
                        ) RL
                        WHERE RL.DAY = 5)
                )V,
                (SELECT *FROM ALLCODE WHERE CDTYPE ='BA' AND CDNAME ='BONDAGENTTYPE') A1,
                (SELECT *FROM ALLCODE WHERE CDTYPE ='BA' AND CDNAME ='BONDAGENTTASK') A2
            WHERE V.TYPE = A1.CDVAL(+)
            AND V.TASK = A2.CDVAL(+)
            AND (A1.CDCONTENT, A2.CDCONTENT, TO_DATE(DEADLINE,'DD/MM/RRRR'), V.SYMBOL, V.ISSUEDATE) NOT IN (SELECT TYPE,TASK,DEADLINE,SYMBOL,ISSUEDATE FROM TASKBONDAGENT WHERE STATUS = 'O');
        END;
        BEGIN
            INSERT INTO TASKBONDAGENT(AUTOID,TYPE,TASK,DEADLINE,STATUS,SYMBOL,ISSUEDATE)
            SELECT SEQ_TASKBONDAGENT.NEXTVAL,A1.CDCONTENT TYPE,A2.CDCONTENT TASK, TO_DATE(DEADLINE,'DD/MM/RRRR'),'O',V.SYMBOL,V.ISSUEDATE
            FROM (
                    SELECT 'type3' TYPE, 'task6' TASK,TO_CHAR(FN_CHECK_HOLIDAY(ADD_MONTHS(ISSUEDATE,3))) DEADLINE,SYMBOL,ISSUEDATE
                    FROM (SELECT *FROM (
                            SELECT SB.*
                            FROM SBSECURITIES SB, ISSUES ISS, ISSUERS ISR, BONDISSUE BI
                            WHERE SB.CODEID = BI.BONDCODE AND SB.SYMBOL = BI.BONDSYMBOL
                            AND BI.ISSUESID = ISS.AUTOID
                            AND ISS.ISSUERID = ISR.ISSUERID
                            AND ISS.EFFECTIVE = 'Y'
                            AND NVL(ISS.MATURITYDATE, V_CURRDATE) >= V_CURRDATE
                            AND TO_CHAR(SB.CONTRACTDATE,'RRRR') = TO_CHAR(TO_DATE(V_CURRDATE,'DD/MM/RRRR'),'RRRR')
                        ) WHERE SECTYPE = '006' OR(SECTYPE = '015' AND TRADEPLACE ='003'))
                    WHERE V_CURRDATE <= FN_CHECK_HOLIDAY(ADD_MONTHS(ISSUEDATE,3))
                )V,
                (SELECT *FROM ALLCODE WHERE CDTYPE ='BA' AND CDNAME ='BONDAGENTTYPE') A1,
                (SELECT *FROM ALLCODE WHERE CDTYPE ='BA' AND CDNAME ='BONDAGENTTASK') A2
            WHERE V.TYPE = A1.CDVAL(+)
            AND V.TASK = A2.CDVAL(+)
            AND (A1.CDCONTENT, A2.CDCONTENT, TO_DATE(DEADLINE,'DD/MM/RRRR'), V.SYMBOL, V.ISSUEDATE) NOT IN (SELECT TYPE,TASK,DEADLINE,SYMBOL,ISSUEDATE FROM TASKBONDAGENT WHERE STATUS = 'O');
        END;
        BEGIN
            INSERT INTO TASKBONDAGENT(AUTOID,TYPE,TASK,DEADLINE,STATUS,SYMBOL,ISSUEDATE)
            SELECT SEQ_TASKBONDAGENT.NEXTVAL,A1.CDCONTENT TYPE,A2.CDCONTENT TASK, TO_DATE(DEADLINE,'DD/MM/RRRR'),'O',V.SYMBOL,V.ISSUEDATE
            FROM (
                    SELECT 'type4' TYPE,'task8' TASK,TO_CHAR(GETPDATE_NEXT(V.TXDATE,1)) DEADLINE,SB.SYMBOL,SB.ISSUEDATE
                    FROM VW_TLLOG_ALL V,
                    (
                          SELECT TXNUM,TXDATE,
                                 MAX (CASE WHEN F.FLDCD = '02' THEN F.CVALUE ELSE '' END)  SYMBOL
                          FROM VW_TLLOGFLD_ALL F
                          WHERE FLDCD IN ('02')
                          GROUP BY TXNUM,TXDATE
                     ) F,
                     (
                        SELECT *FROM (
                                SELECT SB.*
                                FROM SBSECURITIES SB, ISSUES ISS, ISSUERS ISR, BONDISSUE BI
                                WHERE SB.CODEID = BI.BONDCODE AND SB.SYMBOL = BI.BONDSYMBOL
                                AND BI.ISSUESID = ISS.AUTOID
                                AND ISS.ISSUERID = ISR.ISSUERID
                                AND ISS.EFFECTIVE = 'Y'
                                AND NVL(ISS.MATURITYDATE, V_CURRDATE) >= V_CURRDATE
                                AND TO_CHAR(SB.CONTRACTDATE,'RRRR') = TO_CHAR(TO_DATE(V_CURRDATE,'DD/MM/RRRR'),'RRRR')
                         ) WHERE SECTYPE = '006' OR(SECTYPE = '015' AND TRADEPLACE ='003')
                     ) SB
                    WHERE V.TLTXCD = '1911'
                    AND V.TXNUM = F.TXNUM
                    AND V.TXDATE = F.TXDATE
                    AND F.SYMBOL = SB.SYMBOL(+)
                    AND V.TXDATE <= V_CURRDATE
                    AND V_CURRDATE <= GETPDATE_NEXT(V.TXDATE,1)
                )V,
                (SELECT *FROM ALLCODE WHERE CDTYPE ='BA' AND CDNAME ='BONDAGENTTYPE') A1,
                (SELECT *FROM ALLCODE WHERE CDTYPE ='BA' AND CDNAME ='BONDAGENTTASK') A2
            WHERE V.TYPE = A1.CDVAL(+)
            AND V.TASK = A2.CDVAL(+)
            AND (A1.CDCONTENT, A2.CDCONTENT, TO_DATE(DEADLINE,'DD/MM/RRRR'), V.SYMBOL, V.ISSUEDATE) NOT IN (SELECT TYPE,TASK,DEADLINE,SYMBOL,ISSUEDATE FROM TASKBONDAGENT WHERE STATUS = 'O');
        END;
        BEGIN
            INSERT INTO TASKBONDAGENT(AUTOID,TYPE,TASK,DEADLINE,STATUS,SYMBOL,ISSUEDATE)
            SELECT SEQ_TASKBONDAGENT.NEXTVAL,A1.CDCONTENT TYPE,A2.CDCONTENT TASK, TO_DATE(DEADLINE,'DD/MM/RRRR'),'O',V.SYMBOL,V.ISSUEDATE
            FROM (
                    SELECT 'type4' TYPE, 'task9' TASK, TO_CHAR(GETPDATE_NEXT(V.TXDATE,1)) DEADLINE,SB.SYMBOL,SB.ISSUEDATE
                    FROM VW_TLLOG_ALL V,
                    (
                          SELECT TXNUM,TXDATE,
                                 MAX (CASE WHEN F.FLDCD = '02' THEN F.CVALUE ELSE '' END)  SYMBOL
                          FROM VW_TLLOGFLD_ALL F
                          WHERE FLDCD IN ('02')
                          GROUP BY TXNUM,TXDATE
                    ) F,
                    (
                        SELECT *FROM (
                                SELECT SB.*
                                FROM SBSECURITIES SB, ISSUES ISS, ISSUERS ISR, BONDISSUE BI
                                WHERE SB.CODEID = BI.BONDCODE AND SB.SYMBOL = BI.BONDSYMBOL
                                AND BI.ISSUESID = ISS.AUTOID
                                AND ISS.ISSUERID = ISR.ISSUERID
                                AND ISS.EFFECTIVE = 'Y'
                                AND NVL(ISS.MATURITYDATE, V_CURRDATE) >= V_CURRDATE
                                AND TO_CHAR(SB.CONTRACTDATE,'RRRR') = TO_CHAR(TO_DATE(V_CURRDATE,'DD/MM/RRRR'),'RRRR')
                        ) WHERE SECTYPE = '006' OR(SECTYPE = '015' AND TRADEPLACE ='003')
                     ) SB
                    WHERE V.TLTXCD = '1911'
                    AND V.TXNUM = F.TXNUM
                    AND V.TXDATE = F.TXDATE
                    AND F.SYMBOL = SB.SYMBOL(+)
                    AND V.TXDATE <= V_CURRDATE
                    AND V_CURRDATE <= GETPDATE_NEXT(V.TXDATE,1)
                )V,
                (SELECT *FROM ALLCODE WHERE CDTYPE ='BA' AND CDNAME ='BONDAGENTTYPE') A1,
                (SELECT *FROM ALLCODE WHERE CDTYPE ='BA' AND CDNAME ='BONDAGENTTASK') A2
            WHERE V.TYPE =A1.CDVAL(+)
            AND V.TASK = A2.CDVAL(+)
            AND (A1.CDCONTENT, A2.CDCONTENT, TO_DATE(DEADLINE,'DD/MM/RRRR'), V.SYMBOL, V.ISSUEDATE) NOT IN (SELECT TYPE,TASK,DEADLINE,SYMBOL,ISSUEDATE FROM TASKBONDAGENT WHERE STATUS = 'O');
        END;
        BEGIN
            INSERT INTO TASKBONDAGENT(AUTOID,TYPE,TASK,DEADLINE,STATUS,SYMBOL,ISSUEDATE)
            SELECT SEQ_TASKBONDAGENT.NEXTVAL,A1.CDCONTENT TYPE,A2.CDCONTENT TASK, TO_DATE(DEADLINE,'DD/MM/RRRR'),'O',V.SYMBOL,V.ISSUEDATE
            FROM (
                    SELECT 'type5' TYPE, 'task11' TASK,TO_CHAR(GETPDATE_NEXT(B.ACTUALPAYDATE,3)) DEADLINE,SB.SYMBOL,SB.ISSUEDATE
                    FROM (
                        SELECT MIN(ACTUALPAYDATE) ACTUALPAYDATE,BONDSYMBOL FROM  BONDTYPEPAY GROUP BY BONDSYMBOL
                    )B,
                    (
                        SELECT *FROM (
                            SELECT SB.*
                            FROM SBSECURITIES SB, ISSUES ISS, ISSUERS ISR, BONDISSUE BI
                            WHERE SB.CODEID = BI.BONDCODE AND SB.SYMBOL = BI.BONDSYMBOL
                            AND BI.ISSUESID = ISS.AUTOID
                            AND ISS.ISSUERID = ISR.ISSUERID
                            AND ISS.EFFECTIVE = 'Y'
                            AND NVL(ISS.MATURITYDATE, V_CURRDATE) >= V_CURRDATE
                            AND TO_CHAR(SB.CONTRACTDATE,'RRRR') = TO_CHAR(TO_DATE(V_CURRDATE,'DD/MM/RRRR'),'RRRR')
                        ) WHERE SECTYPE = '006' OR(SECTYPE = '015' AND TRADEPLACE ='003')
                    ) SB --MIN NGAY THANH TOAN
                    WHERE B.BONDSYMBOL = SB.SYMBOL AND  FN_GET_PREVDATE(B.ACTUALPAYDATE,21) <= V_CURRDATE
                    AND V_CURRDATE <= GETPDATE_NEXT(B.ACTUALPAYDATE,3)
                )V,
                (SELECT *FROM ALLCODE WHERE CDTYPE ='BA' AND CDNAME ='BONDAGENTTYPE') A1,
                (SELECT *FROM ALLCODE WHERE CDTYPE ='BA' AND CDNAME ='BONDAGENTTASK') A2
            WHERE V.TYPE =A1.CDVAL(+)
            AND V.TASK = A2.CDVAL(+)
            AND (A1.CDCONTENT, A2.CDCONTENT, TO_DATE(DEADLINE,'DD/MM/RRRR'), V.SYMBOL, V.ISSUEDATE) NOT IN (SELECT TYPE,TASK,DEADLINE,SYMBOL,ISSUEDATE FROM TASKBONDAGENT WHERE STATUS = 'O');
        END;
        BEGIN
            INSERT INTO TASKBONDAGENT(AUTOID,TYPE,TASK,DEADLINE,STATUS,SYMBOL,ISSUEDATE)
            SELECT SEQ_TASKBONDAGENT.NEXTVAL,A1.CDCONTENT TYPE,A2.CDCONTENT TASK, TO_DATE(DEADLINE,'DD/MM/RRRR'),'O',V.SYMBOL,V.ISSUEDATE
            FROM (
                    SELECT 'type5' TYPE,'task12' TASK,TO_CHAR(GETPDATE_NEXT(B.ACTUALPAYDATE,3)) DEADLINE,SB.SYMBOL,SB.ISSUEDATE
                    FROM (
                        SELECT MIN(ACTUALPAYDATE) ACTUALPAYDATE,BONDSYMBOL FROM  BONDTYPEPAY GROUP BY BONDSYMBOL
                    )B ,
                    (
                        SELECT *FROM (
                            SELECT SB.*
                            FROM SBSECURITIES SB, ISSUES ISS, ISSUERS ISR, BONDISSUE BI
                            WHERE SB.CODEID = BI.BONDCODE AND SB.SYMBOL = BI.BONDSYMBOL
                            AND BI.ISSUESID = ISS.AUTOID
                            AND ISS.ISSUERID = ISR.ISSUERID
                            AND ISS.EFFECTIVE = 'Y'
                            AND NVL(ISS.MATURITYDATE, V_CURRDATE) >= V_CURRDATE
                            AND TO_CHAR(SB.CONTRACTDATE,'RRRR') = TO_CHAR(TO_DATE(V_CURRDATE,'DD/MM/RRRR'),'RRRR')
                        ) WHERE SECTYPE = '006' OR(SECTYPE = '015' AND TRADEPLACE ='003')
                    ) SB--MIN NGAY THANH TOAN
                    WHERE  B.BONDSYMBOL = SB.SYMBOL AND FN_GET_PREVDATE(B.ACTUALPAYDATE,15) <= V_CURRDATE
                    AND V_CURRDATE <= GETPDATE_NEXT(B.ACTUALPAYDATE,3)
                    )V,
                (SELECT *FROM ALLCODE WHERE CDTYPE ='BA' AND CDNAME ='BONDAGENTTYPE') A1,
                (SELECT *FROM ALLCODE WHERE CDTYPE ='BA' AND CDNAME ='BONDAGENTTASK') A2
            WHERE V.TYPE = A1.CDVAL(+)
            AND V.TASK = A2.CDVAL(+)
            AND (A1.CDCONTENT, A2.CDCONTENT, TO_DATE(DEADLINE,'DD/MM/RRRR'), V.SYMBOL, V.ISSUEDATE) NOT IN (SELECT TYPE,TASK,DEADLINE,SYMBOL,ISSUEDATE FROM TASKBONDAGENT WHERE STATUS = 'O');
        END;
        BEGIN
            INSERT INTO TASKBONDAGENT(AUTOID,TYPE,TASK,DEADLINE,STATUS,SYMBOL,ISSUEDATE)
            SELECT SEQ_TASKBONDAGENT.NEXTVAL,A1.CDCONTENT TYPE,A2.CDCONTENT TASK, TO_DATE(DEADLINE,'DD/MM/RRRR'),'O',V.SYMBOL,V.ISSUEDATE
            FROM (
                    SELECT 'type5' TYPE, 'task13' TASK,TO_CHAR(C.RECORDDATE) DEADLINE,SB.SYMBOL,SB.ISSUEDATE
                    FROM (
                        SELECT MAX(RECORDDATE) RECORDDATE ,BONDSYMBOL FROM  BONDTYPEPAY GROUP BY BONDSYMBOL
                    )C ,
                    (
                        SELECT * FROM (
                            SELECT SB.*
                            FROM SBSECURITIES SB, ISSUES ISS, ISSUERS ISR, BONDISSUE BI
                            WHERE SB.CODEID = BI.BONDCODE AND SB.SYMBOL = BI.BONDSYMBOL
                            AND BI.ISSUESID = ISS.AUTOID
                            AND ISS.ISSUERID = ISR.ISSUERID
                            AND ISS.EFFECTIVE = 'Y'
                            AND NVL(ISS.MATURITYDATE, V_CURRDATE) >= V_CURRDATE
                            AND TO_CHAR(SB.CONTRACTDATE,'RRRR') = TO_CHAR(TO_DATE(V_CURRDATE,'DD/MM/RRRR'),'RRRR')
                        ) WHERE SECTYPE = '006' OR(SECTYPE = '015' AND TRADEPLACE ='003')
                    ) SB--MAX NGAY DANG KY
                    WHERE C.RECORDDATE = V_CURRDATE AND C.BONDSYMBOL = SB.SYMBOL
                )V,
                (SELECT *FROM ALLCODE WHERE CDTYPE ='BA' AND CDNAME ='BONDAGENTTYPE')A1,
                (SELECT *FROM ALLCODE WHERE CDTYPE ='BA' AND CDNAME ='BONDAGENTTASK') A2
            WHERE V.TYPE =A1.CDVAL(+)
            AND V.TASK = A2.CDVAL(+)
            AND (A1.CDCONTENT, A2.CDCONTENT, TO_DATE(DEADLINE,'DD/MM/RRRR'), V.SYMBOL, V.ISSUEDATE) NOT IN (SELECT TYPE,TASK,DEADLINE,SYMBOL,ISSUEDATE FROM TASKBONDAGENT WHERE STATUS = 'O');
        END;
        BEGIN
            INSERT INTO TASKBONDAGENT(AUTOID,TYPE,TASK,DEADLINE,STATUS,SYMBOL,ISSUEDATE)
            SELECT SEQ_TASKBONDAGENT.NEXTVAL,A1.CDCONTENT TYPE,A2.CDCONTENT TASK, TO_DATE(DEADLINE,'DD/MM/RRRR'),'O',V.SYMBOL,V.ISSUEDATE
            FROM (
                    SELECT 'type5' TYPE,'task14' TASK,TO_CHAR(GETPDATE_NEXT(C.RECORDDATE,1))DEADLINE,SB.SYMBOL,SB.ISSUEDATE
                    FROM (
                        SELECT MAX(RECORDDATE) RECORDDATE ,BONDSYMBOL FROM  BONDTYPEPAY GROUP BY BONDSYMBOL
                    )C,
                    (
                        SELECT *FROM (
                            SELECT SB.*
                            FROM SBSECURITIES SB, ISSUES ISS, ISSUERS ISR, BONDISSUE BI
                            WHERE SB.CODEID = BI.BONDCODE AND SB.SYMBOL = BI.BONDSYMBOL
                            AND BI.ISSUESID = ISS.AUTOID
                            AND ISS.ISSUERID = ISR.ISSUERID
                            AND ISS.EFFECTIVE = 'Y'
                            AND NVL(ISS.MATURITYDATE, V_CURRDATE) >= V_CURRDATE
                            AND TO_CHAR(SB.CONTRACTDATE,'RRRR') = TO_CHAR(TO_DATE(V_CURRDATE,'DD/MM/RRRR'),'RRRR')
                        ) WHERE SECTYPE = '006' OR(SECTYPE = '015' AND TRADEPLACE ='003')
                    ) SB --MAX NGAY DANG KY
                    WHERE GETPDATE_NEXT(C.RECORDDATE,1) = V_CURRDATE AND C.BONDSYMBOL = SB.SYMBOL
                )V,
                (SELECT *FROM ALLCODE WHERE CDTYPE ='BA' AND CDNAME ='BONDAGENTTYPE') A1,
                (SELECT *FROM ALLCODE WHERE CDTYPE ='BA' AND CDNAME ='BONDAGENTTASK') A2
            WHERE V.TYPE = A1.CDVAL(+)
            AND V.TASK = A2.CDVAL(+)
            AND (A1.CDCONTENT, A2.CDCONTENT, TO_DATE(DEADLINE,'DD/MM/RRRR'), V.SYMBOL, V.ISSUEDATE) NOT IN (SELECT TYPE,TASK,DEADLINE,SYMBOL,ISSUEDATE FROM TASKBONDAGENT WHERE STATUS = 'O');
        END;
        BEGIN
            INSERT INTO TASKBONDAGENT(AUTOID,TYPE,TASK,DEADLINE,STATUS,SYMBOL,ISSUEDATE)
            SELECT SEQ_TASKBONDAGENT.NEXTVAL,A1.CDCONTENT TYPE,A2.CDCONTENT TASK, TO_DATE(DEADLINE,'DD/MM/RRRR'),'O',V.SYMBOL,V.ISSUEDATE
            FROM (
                    SELECT 'type5' TYPE,'task15' TASK,TO_CHAR(FN_GET_PREVDATE(B.ACTUALPAYDATE,2))  DEADLINE,SB.SYMBOL,SB.ISSUEDATE
                    FROM (
                        SELECT MIN(ACTUALPAYDATE) ACTUALPAYDATE,BONDSYMBOL FROM  BONDTYPEPAY GROUP BY BONDSYMBOL
                    )B,
                     (
                        SELECT *FROM (
                            SELECT SB.*
                            FROM SBSECURITIES SB, ISSUES ISS, ISSUERS ISR, BONDISSUE BI
                            WHERE SB.CODEID = BI.BONDCODE AND SB.SYMBOL = BI.BONDSYMBOL
                            AND BI.ISSUESID = ISS.AUTOID
                            AND ISS.ISSUERID = ISR.ISSUERID
                            AND ISS.EFFECTIVE = 'Y'
                            AND NVL(ISS.MATURITYDATE, V_CURRDATE) >= V_CURRDATE
                            AND TO_CHAR(SB.CONTRACTDATE,'RRRR') = TO_CHAR(TO_DATE(V_CURRDATE,'DD/MM/RRRR'),'RRRR')
                        ) WHERE SECTYPE = '006' OR(SECTYPE = '015' AND TRADEPLACE ='003')
                    ) SB --MIN NGAY THANH TOAN
                    WHERE FN_GET_PREVDATE(B.ACTUALPAYDATE,2) = V_CURRDATE
                    AND B.BONDSYMBOL = SB.SYMBOL
                )V,
                (SELECT *FROM ALLCODE WHERE CDTYPE ='BA' AND CDNAME ='BONDAGENTTYPE') A1,
                (SELECT *FROM ALLCODE WHERE CDTYPE ='BA' AND CDNAME ='BONDAGENTTASK') A2
            WHERE V.TYPE = A1.CDVAL(+)
            AND V.TASK = A2.CDVAL(+)
            AND (A1.CDCONTENT, A2.CDCONTENT, TO_DATE(DEADLINE,'DD/MM/RRRR'), V.SYMBOL, V.ISSUEDATE) NOT IN (SELECT TYPE,TASK,DEADLINE,SYMBOL,ISSUEDATE FROM TASKBONDAGENT WHERE STATUS = 'O');
        END;
        BEGIN
            INSERT INTO TASKBONDAGENT(AUTOID,TYPE,TASK,DEADLINE,STATUS,SYMBOL,ISSUEDATE)
            SELECT SEQ_TASKBONDAGENT.NEXTVAL,A1.CDCONTENT TYPE,A2.CDCONTENT TASK, TO_DATE(DEADLINE,'DD/MM/RRRR'),'O',V.SYMBOL,V.ISSUEDATE
            FROM (
                    SELECT 'type5' TYPE, 'task16' TASK,TO_CHAR(B.ACTUALPAYDATE) DEADLINE,SB.SYMBOL,SB.ISSUEDATE
                    FROM (
                        SELECT MIN(ACTUALPAYDATE) ACTUALPAYDATE,BONDSYMBOL FROM  BONDTYPEPAY GROUP BY BONDSYMBOL
                    )B,
                    (
                        SELECT *FROM (
                            SELECT SB.*
                            FROM SBSECURITIES SB, ISSUES ISS, ISSUERS ISR, BONDISSUE BI
                            WHERE SB.CODEID = BI.BONDCODE AND SB.SYMBOL = BI.BONDSYMBOL
                            AND BI.ISSUESID = ISS.AUTOID
                            AND ISS.ISSUERID = ISR.ISSUERID
                            AND ISS.EFFECTIVE = 'Y'
                            AND NVL(ISS.MATURITYDATE, V_CURRDATE) >= V_CURRDATE
                            AND TO_CHAR(SB.CONTRACTDATE,'RRRR') = TO_CHAR(TO_DATE(V_CURRDATE,'DD/MM/RRRR'),'RRRR')
                        ) WHERE SECTYPE = '006' OR(SECTYPE = '015' AND TRADEPLACE ='003')
                    ) SB  --MIN NGAY THANH TOAN
                    WHERE V_CURRDATE = B.ACTUALPAYDATE  AND B.BONDSYMBOL = SB.SYMBOL
                )V,
                (SELECT *FROM ALLCODE WHERE CDTYPE ='BA' AND CDNAME ='BONDAGENTTYPE') A1,
                (SELECT *FROM ALLCODE WHERE CDTYPE ='BA' AND CDNAME ='BONDAGENTTASK') A2
            WHERE V.TYPE =A1.CDVAL(+)
            AND V.TASK = A2.CDVAL(+)
            AND (A1.CDCONTENT, A2.CDCONTENT, TO_DATE(DEADLINE,'DD/MM/RRRR'), V.SYMBOL, V.ISSUEDATE) NOT IN (SELECT TYPE,TASK,DEADLINE,SYMBOL,ISSUEDATE FROM TASKBONDAGENT WHERE STATUS = 'O');
        END;
        BEGIN
            INSERT INTO TASKBONDAGENT(AUTOID,TYPE,TASK,DEADLINE,STATUS,SYMBOL,ISSUEDATE)
            SELECT SEQ_TASKBONDAGENT.NEXTVAL,A1.CDCONTENT TYPE,A2.CDCONTENT TASK, TO_DATE(DEADLINE,'DD/MM/RRRR'),'O',V.SYMBOL,V.ISSUEDATE
            FROM (
                    SELECT 'type6' TYPE, 'task17' TASK,TO_CHAR(GETPDATE_NEXT(EXPDATE,10)) DEADLINE,SYMBOL,ISSUEDATE
                    FROM (
                        SELECT * FROM (
                            SELECT SB.*
                            FROM SBSECURITIES SB, ISSUES ISS, ISSUERS ISR, BONDISSUE BI
                            WHERE SB.CODEID = BI.BONDCODE AND SB.SYMBOL = BI.BONDSYMBOL
                            AND BI.ISSUESID = ISS.AUTOID
                            AND ISS.ISSUERID = ISR.ISSUERID
                            AND ISS.EFFECTIVE = 'Y'
                            AND NVL(ISS.MATURITYDATE, V_CURRDATE) >= V_CURRDATE
                            AND TO_CHAR(SB.CONTRACTDATE,'RRRR') = TO_CHAR(TO_DATE(V_CURRDATE,'DD/MM/RRRR'),'RRRR')
                        ) WHERE SECTYPE = '006' OR(SECTYPE = '015' AND TRADEPLACE ='003')
                    )
                    WHERE EXPDATE = V_CURRDATE
            )V,
            (SELECT *FROM ALLCODE WHERE CDTYPE ='BA' AND CDNAME ='BONDAGENTTYPE') A1,
            (SELECT *FROM ALLCODE WHERE CDTYPE ='BA' AND CDNAME ='BONDAGENTTASK') A2
            WHERE V.TYPE =A1.CDVAL(+)
            AND V.TASK = A2.CDVAL(+)
            AND (A1.CDCONTENT, A2.CDCONTENT, TO_DATE(DEADLINE,'DD/MM/RRRR'), V.SYMBOL, V.ISSUEDATE) NOT IN (SELECT TYPE,TASK,DEADLINE,SYMBOL,ISSUEDATE FROM TASKBONDAGENT WHERE STATUS = 'O');
        END;
        commit;
END;
/
