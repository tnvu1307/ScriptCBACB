SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('EA1108','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('EA1108', 'Phong tỏa tiền tạm (GD 1108)', 'Block temporary cash (Trans 1108)', 'SELECT * FROM(
SELECT R2.*,
       (CASE WHEN R2.CCYCD = ''VND'' THEN 
                  LEAST(R2.BLKAMT - R2.BALANCE - R2.HOLDBALANCE, R2.BALANCE)
             ELSE ROUND(LEAST(R2.BLKAMT_USD - R2.BALANCE_USD - R2.HOLDBALANCE/(EX.VND + EX.VND*SY.RATIO), R2.BALANCE/(EX.VND + EX.VND*SY.RATIO)) * EX.VND)
             END
       ) MAXBLKAMT,
       (CASE WHEN R2.CCYCD = ''VND'' THEN 
                  LEAST(R2.BLKAMT - R2.BALANCE - R2.HOLDBALANCE, R2.BALANCE)
             ELSE ROUND(LEAST(R2.BLKAMT_USD - R2.BALANCE_USD - R2.HOLDBALANCE/(EX.VND + EX.VND*SY.RATIO), R2.BALANCE/(EX.VND + EX.VND*SY.RATIO)) * EX.VND)
             END
       ) AMTCHK,
       NVL(EDT.HOLD_TEMP,0) HOLD_TEMP
FROM
(
    SELECT R1.CCYCD, R1.BCUSTODYCD, R1.BFULLNAME, R1.BDDACCTNO, R1.REFCASAACCT, R1.BALANCE, R1.BALANCE_USD, R1.HOLDBALANCE,
           SUM(R1.BLKAMT_USD) BLKAMT_USD, SUM(R1.BLKAMT) BLKAMT 
    FROM
    (
        SELECT DD.CCYCD, E.BCUSTODYCD, E.BFULLNAME,
            (CASE WHEN DD.CCYCD = ''VND'' THEN DD.ACCTNO ELSE D_II.ACCTNO END) BDDACCTNO,
            (CASE WHEN DD.CCYCD = ''VND'' THEN DD.REFCASAACCT ELSE D_II.REFCASAACCT END) REFCASAACCT,
            (CASE WHEN DD.CCYCD = ''VND'' THEN DD.BALANCE ELSE D_II.BALANCE END) BALANCE,
            (CASE WHEN DD.CCYCD = ''VND'' THEN DD.HOLDBALANCE ELSE D_II.HOLDBALANCE END) HOLDBALANCE,
            DD.BALANCE BALANCE_USD,
            E.BLKAMT_USD, E.BLKAMT
        FROM ESCROW E ,DDMAST DD, DDMAST D_II,
        (
            SELECT GETCURRDATE CURRDATE FROM DUAL
        ) CRDATE
        WHERE E.BDDACCTNO_ESCROW = DD.ACCTNO
        AND E.BDDACCTNO_IICA = D_II.ACCTNO
        AND E.DELTD <> ''Y''
        AND TRIM(E.BDDACCTNO_IICA) IS NOT NULL
        AND E.DDSTATUS IN (''P'',''A'')
        AND E.BLOCKDATE <= CRDATE.CURRDATE
        AND E.BLOCKENDDATE >= CRDATE.CURRDATE
    ) R1
    GROUP BY R1.CCYCD, R1.BCUSTODYCD, R1.BFULLNAME, R1.BDDACCTNO, R1.REFCASAACCT, R1.BALANCE, R1.BALANCE_USD, R1.HOLDBALANCE
) R2,
(
    SELECT VND, CURRENCY FROM EXCHANGERATE WHERE RTYPE = ''TTM'' AND ITYPE = ''SHV''
) EX,
(
    SELECT BCUSTODYCD,BDDACCTNO,SUM(HOLD_DD) HOLD_TEMP FROM ESCROW_HOLD_TEMP WHERE UNHOLD = ''N'' AND DELTD <>''Y'' GROUP BY BCUSTODYCD, BDDACCTNO
) EDT,
(
    SELECT TO_NUMBER(VARVALUE) RATIO FROM SYSVAR WHERE VARNAME = ''EAUSDRATIO'' AND GRNAME = ''EA''
) SY
WHERE R2.CCYCD = EX.CURRENCY
AND R2.BCUSTODYCD = EDT.BCUSTODYCD(+)
AND R2.BDDACCTNO = EDT.BDDACCTNO(+)
)WHERE MAXBLKAMT > 0', 'EA1108', NULL, NULL, '1108', NULL, 5000, 'N', 30, 'NNNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;