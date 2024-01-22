SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE sp_process_cifeeschd_common
/* Formatted on 08/05/2014 2:14:55 PM (QP5 v5.126) */
IS
    V_CURRDATE   DATE;
    V_NEXTDATE   DATE;
    V_BOMDATE    DATE;
    V_EOMDATE    DATE;
    V_TODATE     DATE;
    V_DOMTEMP    VARCHAR (5);
    V_EOMTEMP    VARCHAR (5);
    V_RESULT     NUMBER (20);
    V_TBALDT     DATE;
    v_EOMtemp2   DATE;
    v_sysvar varchar2(10);
BEGIN
    --PROCESS FEE FOR EXCHANGE FEETYPE=EXCBRK
    --****************************************************************************************
    --CALCULATE THE AMOUNT OF FEE FOR EXCHANGE

    UPDATE   ODMAST T1
       SET   EXCFEEAMT =
                 NVL (
                     (SELECT     DECODE (T2.FORP, 'P', FEEAMT / 100, FEEAMT)
                               * T1.EXECAMT
                               / (T2.LOTDAY * T2.LOTVAL)
                        FROM   (SELECT   A2.*
                                  FROM   (  SELECT   T.ORDERID,
                                                     MIN (T.ODRNUM) RFNUM
                                              FROM   VW_ODMAST_EXC_FEETERM T
                                          GROUP BY   T.ORDERID) A1,
                                         VW_ODMAST_EXC_FEETERM A2
                                 WHERE   A1.ORDERID = A2.ORDERID
                                         AND A1.RFNUM = A2.ODRNUM) T2
                       WHERE   T1.ORDERID = T2.ORDERID),
                     0);

    --MAP TO CIFEEDEF.AUTOID
    UPDATE   ODMAST T1
       SET   EXCFEEREFID =
                 NVL (
                     (SELECT   T2.AUTOID
                        FROM   (SELECT   A2.*
                                  FROM   (  SELECT   T.ORDERID,
                                                     MIN (T.ODRNUM) RFNUM
                                              FROM   VW_ODMAST_EXC_FEETERM T
                                          GROUP BY   T.ORDERID) A1,
                                         VW_ODMAST_EXC_FEETERM A2
                                 WHERE   A1.ORDERID = A2.ORDERID
                                         AND A1.RFNUM = A2.ODRNUM) T2
                       WHERE   T1.ORDERID = T2.ORDERID),
                     0);


    --PROCESS THE DEPOSITORY FEE
    --****************************************************************************************
    SELECT   TO_DATE (VARVALUE, SYSTEMNUMS.C_DATE_FORMAT)
      INTO   V_CURRDATE
      FROM   SYSVAR
     WHERE   GRNAME = 'SYSTEM' AND VARNAME = 'CURRDATE';
     V_NEXTDATE := GETNEXTWORKINGDATE(V_CURRDATE);

    --trung.luu: 08/06/2020 SHBVNEX-1158 b? tính phí cho TK t? doanh
     SELECT varvalue into v_sysvar from sysvar where varname = 'DEALINGCUSTODYCD';

    /*
    SELECT   TO_DATE (VARVALUE, SYSTEMNUMS.C_DATE_FORMAT)
      INTO   V_NEXTDATE
      FROM   SYSVAR
     WHERE   GRNAME = 'SYSTEM' AND VARNAME = 'NEXTDATE';
    */
    --SONLT 20140423 Them loai thu phi, ngay bat ky hoac cuoi thang
    SELECT   VARVALUE
      INTO   V_DOMTEMP
      FROM   SYSVAR
     WHERE   VARNAME IN ('DAYFEEDEPOSIT');

    SELECT   VARVALUE
      INTO   V_EOMTEMP
      FROM   SYSVAR
     WHERE   VARNAME IN ('EOMFEEDEPOSIT');

    --END SONLT 20140423

    --CHECK EOM PROCESSING
    --SELECT DECODE(extract(MONTH FROM v_NEXTDATE)-extract(MONTH FROM v_CURRDATE),0,'N','Y') into v_EOM FROM DUAL;
    v_EOMtemp2 := ADD_MONTHS(TRUNC(to_date(V_CURRDATE,'DD/MM/RRRR'), 'MM'), 1) -1;--Lay ngay cuoi thang
     IF to_number(v_DOMtemp) > to_number(to_char(v_EOMtemp2,'DD')) THEN
        v_DOMtemp := to_char(v_EOMtemp2,'DD');
     END IF;
    --START SONLT 20140426
    IF  v_EOMtemp = 'Y' THEN
    -- lay ra ngay cuoi cung cua thang
        --SELECT ADD_MONTHS(TRUNC(to_date(v_strCURRDATE,'DD/MM/RRRR'), 'MM'), 1) -1 INTO v_dateEOMtemp FROM DUAL;
        V_EOMDATE := v_EOMtemp2;
    ELSE
    -- lay ra ngay thu phi luu ky

        SELECT TO_DATE(v_DOMtemp || '/'||TO_CHAR(to_date(V_CURRDATE,'DD/MM/RRRR'),'MM/RRRR'),'DD/MM/RRRR') INTO V_EOMDATE FROM DUAL;
    END IF;
    --sua lai ghi nhan phi den ngay cuoi thang thay vi den ngay lam viec cuoi thang
    --SELECT   GET_SYS_PREWORKINGDATE (V_EOMDATE) INTO V_EOMDATE FROM DUAL;
    
    IF V_EOMDATE >= V_NEXTDATE
    THEN
        --DURING THIS MONTH: CALCULATE THE ACCRUE DEPOSITPORY FEE ONLY (BUSDATE-NEXTDATE)
        BEGIN
            --INCREASE CIDEPOFEEACR IN CIMAST
            FOR REC
            IN (SELECT   A2.AFACCTNO,
                         A2.ACCTNO,
                         ROUND (
                             (DECODE (A2.FORP,
                                      'P', A2.FEEAMT / 100,
                                      A2.FEEAMT)
                              * A2.SEBAL
                              * (V_NEXTDATE - NVL (A2.TBALDT, V_CURRDATE))
                              / (A2.LOTDAY * A2.LOTVAL)),
                             4)
                             FEEACR
                  FROM   (  SELECT   T.ACCTNO, MIN (T.ODRNUM) RFNUM
                              FROM   VW_SEMAST_VSDDEP_FEETERM T
                          GROUP BY   T.ACCTNO) A1,
                         VW_SEMAST_VSDDEP_FEETERM A2, CFMAST CF, AFMAST AF
                 WHERE   A1.ACCTNO = A2.ACCTNO AND A1.RFNUM = A2.ODRNUM
                    AND A2.AFACCTNO = AF.ACCTNO
                    AND AF.CUSTID = CF.CUSTID
                    --AND substr(CF.CUSTODYCD,0,4) <> v_sysvar
             )
            LOOP
                UPDATE   DDMAST T1
                   SET   DEPOFEEACR = DEPOFEEACR + NVL (REC.FEEACR, 0)
                 WHERE   AFACCTNO = REC.AFACCTNO AND ISDEFAULT ='Y'
                    AND CUSTID NOT IN (
                                    SELECT CF.CUSTID
                                    FROM FREEDEPOFEE CF
                                  );

                --LOG INTO SEDEPOBAL

                INSERT INTO SEDEPOBAL (AUTOID,
                                       ACCTNO,
                                       TXDATE,
                                       DAYS,
                                       QTTY,
                                       DELTD,
                                       AMT)
                    SELECT   SEQ_SEDEPOBAL.NEXTVAL,
                             SE.ACCTNO,
                             NVL (SE.TBALDT, V_CURRDATE),
                             V_NEXTDATE - NVL (SE.TBALDT, V_CURRDATE),
                             (  SE.TRADE
                              + SE.MARGIN
                              + SE.MORTAGE
                              + SE.BLOCKED
                              + SE.SECURED
                              + SE.REPO
                              + SE.NETTING
                              + SE.DTOCLOSE
                              + SE.WITHDRAW
                              + SE.EMKQTTY
                              + SE.BLOCKDTOCLOSE
                              + SE.BLOCKWITHDRAW),
                             'N',
                             NVL (REC.FEEACR, 0)
                      FROM   SEMAST SE
                     WHERE   ACCTNO = REC.ACCTNO
                             AND NVL (SE.TBALDT, V_CURRDATE) < V_NEXTDATE;
            END LOOP;

            --MARK TO SEMAST
            UPDATE   SEMAST
               SET   TBALDT = V_NEXTDATE;
        END;
    ELSE
        --NEED PROCESS END OF MONTH: CALCULATE THE ACCRUE DEPOSITPORY FEE  THE MATURITY DEPOSITORY FEE
        BEGIN
            --1.1: TINH CONG DON DEN NGAY CUOI THANG
            --INCREASE CIDEPOFEEACR IN CIMAST
            FOR REC
            IN (SELECT   A2.AFACCTNO,
                         A2.ACCTNO,
                         ROUND (
                             DECODE (A2.FORP,
                                     'P', A2.FEEAMT / 100,
                                     A2.FEEAMT)
                             * A2.SEBAL
                             * (V_EOMDATE - NVL (A2.TBALDT, V_CURRDATE) + 1)
                             / (A2.LOTDAY * A2.LOTVAL),
                             4)
                             FEEACR
                  FROM   (  SELECT   T.ACCTNO, MIN (T.ODRNUM) RFNUM
                              FROM   VW_SEMAST_VSDDEP_FEETERM T
                          GROUP BY   T.ACCTNO) A1,
                         VW_SEMAST_VSDDEP_FEETERM A2,CFMAST CF, AFMAST AF
                 WHERE   A1.ACCTNO = A2.ACCTNO AND A1.RFNUM = A2.ODRNUM
                    AND A2.AFACCTNO = AF.ACCTNO
                    AND AF.CUSTID = CF.CUSTID
                    --AND substr(CF.CUSTODYCD,0,4) <> v_sysvar
             )
            LOOP
                UPDATE   DDMAST T1
                   SET   DEPOFEEACR = DEPOFEEACR + NVL (REC.FEEACR, 0)
                 WHERE   AFACCTNO = REC.AFACCTNO AND ISDEFAULT ='Y'
                    AND CUSTID NOT IN (
                                    SELECT CF.CUSTID
                                    FROM FREEDEPOFEE CF
                                  );

                --LOG INTO SEDEPOBAL: UPTO END OF MONTH
                INSERT INTO SEDEPOBAL (AUTOID,
                                       ACCTNO,
                                       TXDATE,
                                       DAYS,
                                       QTTY,
                                       DELTD,
                                       AMT)
                    SELECT   SEQ_SEDEPOBAL.NEXTVAL,
                             SE.ACCTNO,
                             SE.TBALDT,
                             V_EOMDATE - NVL (SE.TBALDT, V_CURRDATE) + 1,
                             (  SE.TRADE
                              + SE.MARGIN
                              + SE.MORTAGE
                              + SE.BLOCKED
                              + SE.SECURED
                              + SE.REPO
                              + SE.NETTING
                              + SE.DTOCLOSE
                              + SE.WITHDRAW
                              + SE.EMKQTTY
                              + SE.BLOCKDTOCLOSE
                              + SE.BLOCKWITHDRAW),
                             'N',
                             NVL (REC.FEEACR, 0)
                      FROM   SEMAST SE
                     WHERE   ACCTNO = REC.ACCTNO
                             AND NVL (SE.TBALDT, V_CURRDATE) <= V_EOMDATE;
            END LOOP;

            --MARK TO SEMAST
            UPDATE   SEMAST
               SET   TBALDT = V_EOMDATE+1;

            --1.2: CHUYEN PHI LUU KY DEN HAN
            --SELECT TRUNC(v_CURRDATE, 'MM') INTO v_BOMDATE FROM DUAL; --SONLT: KO lay ngay dau thang nua, chuyen sang lay tu ngay tinh phi.
            --V_BOMDATE := V_NEXTDATE;

            INSERT INTO CIFEESCHD (AUTOID,
                                   AFACCTNO,
                                   FEETYPE,
                                   TXDATE,
                                   TXNUM,
                                   NMLAMT,
                                   PAIDAMT,
                                   FLOATAMT,
                                   FRDATE,
                                   TODATE,
                                   REFACCTNO,
                                   DELTD)
                SELECT   SEQ_CIFEESCHD.NEXTVAL,
                         AFACCTNO,
                         'VSDDEP',
                         V_EOMDATE,
                         'VSDDEP_DUE',
                         ROUND (DEPOFEEACR),
                         0,
                         0,
                         --V_BOMDATE,SONLT
                         GREATEST(OPNDATE,DEPOLASTDT+1),--: TINH TU NGAY THU PHI CUOI CUNG CUA THANG TRC, neu TK mo moi thi lay tu ngay mo tai khoan
                         V_EOMDATE,
                         NULL,
                         'N'
                  FROM   DDMAST
                 WHERE   DEPOFEEACR > 0 AND ISDEFAULT ='Y'
                         AND NVL (DEPOLASTDT, V_CURRDATE) < V_EOMDATE
                         --AND substr(DDMAST.CUSTODYCD,0,4) <> v_sysvar
                 ;

            UPDATE   DDMAST
               SET   DEPOFEEAMT = DEPOFEEAMT + ROUND (DEPOFEEACR),
                     DEPOFEEACR = 0;
            UPDATE DDMAST SET DEPOLASTDT = V_EOMDATE; --sonlt 20140124: Khong thu nhung van tinh nen tach ra cap nhat l?i ng?thu ph?

            --1.3: TINH CONG DON TU DAU THANG DEN NGAY HIEN TAI
            --INCREASE CIDEPOFEEACR IN CIMAST
            FOR REC
            IN (SELECT   A2.AFACCTNO,
                         A2.ACCTNO,
                         ROUND (
                             DECODE (A2.FORP,
                                     'P', A2.FEEAMT / 100,
                                     A2.FEEAMT)
                             * A2.SEBAL
                             * (V_NEXTDATE - NVL (A2.TBALDT, V_CURRDATE))
                             / (A2.LOTDAY * A2.LOTVAL),
                             4)
                             FEEACR
                  FROM   (  SELECT   T.ACCTNO, MIN (T.ODRNUM) RFNUM
                              FROM   VW_SEMAST_VSDDEP_FEETERM T
                          GROUP BY   T.ACCTNO) A1,
                         VW_SEMAST_VSDDEP_FEETERM A2,CFMAST CF, AFMAST AF
                 WHERE   A1.ACCTNO = A2.ACCTNO AND A1.RFNUM = A2.ODRNUM
                    AND A2.AFACCTNO = AF.ACCTNO
                    AND AF.CUSTID = CF.CUSTID
                    --AND substr(CF.CUSTODYCD,0,4) <> v_sysvar
             )
            LOOP
                UPDATE   DDMAST T1
                   SET   DEPOFEEACR = DEPOFEEACR + NVL (REC.FEEACR, 0)
                 WHERE   AFACCTNO = REC.AFACCTNO AND ISDEFAULT ='Y'
                    AND CUSTID NOT IN (
                                    SELECT CF.CUSTID
                                    FROM FREEDEPOFEE CF
                                  );

                --LOG INTO SEDEPOBAL: UPTO NEXTDATE
                INSERT INTO SEDEPOBAL (AUTOID,
                                       ACCTNO,
                                       TXDATE,
                                       DAYS,
                                       QTTY,
                                       DELTD,
                                       AMT)
                    SELECT   SEQ_SEDEPOBAL.NEXTVAL,
                             SE.ACCTNO,
                             NVL (SE.TBALDT, V_CURRDATE),
                             V_NEXTDATE - NVL (SE.TBALDT, V_CURRDATE),
                             (  SE.TRADE
                              + SE.MARGIN
                              + SE.MORTAGE
                              + SE.BLOCKED
                              + SE.SECURED
                              + SE.REPO
                              + SE.NETTING
                              + SE.DTOCLOSE
                              + SE.WITHDRAW
                              + SE.EMKQTTY
                              + SE.BLOCKDTOCLOSE
                              + SE.BLOCKWITHDRAW
                              + SE.HOLD),
                             'N',
                             NVL (REC.FEEACR, 0)
                      FROM   SEMAST SE
                     WHERE   ACCTNO = REC.ACCTNO
                             AND NVL (TBALDT, V_CURRDATE) < V_NEXTDATE;
            END LOOP;

            --MARK TO SEMAST
            UPDATE   SEMAST
               SET   TBALDT = V_NEXTDATE;

        END;
    END IF;

    --?A C?C BI?U THAM S? ?N NG?Y HI?U L?C V?O HO?T ?NG (BI?U PH?TUONG T? S? H?T H?N-FEETYPE/CODEID/EXCHANGE/SECTYPE)
    --?A C?C BI?U THAM S? ?N NG?Y HI?U L?C V?O HO?T ?NG (BI?U PH?TUONG T? S? H?T H?N-FEETYPE/CODEID/EXCHANGE/SECTYPE)
    -- update cac bieu phi co ngay hieu luc la nextdate

    FOR REC IN (SELECT   *
                  FROM   CIFEEDEF
                 WHERE   VALDATE = V_NEXTDATE AND STATUS = 'P')
    LOOP
        UPDATE   CIFEEDEF
           SET   STATUS = 'C'
         WHERE       FEETYPE = REC.FEETYPE
                 AND ACTYPE = REC.ACTYPE
                 AND NVL (CODEID, 'A') = NVL (REC.CODEID, 'A')
                 AND TRADEPLACE = REC.TRADEPLACE
                 AND SECTYPE = REC.SECTYPE
                 AND STATUS = 'A';

        UPDATE   CIFEEDEF
           SET   STATUS = 'A'
         WHERE   AUTOID = REC.AUTOID;
    END LOOP;

   -- COMMIT;
EXCEPTION
    WHEN OTHERS
    THEN
        BEGIN
            RAISE;
            RETURN;
        END;
END;
/
