SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_get_exchangerate( PV_CURRENCY IN VARCHAR2, PV_ITYPE IN VARCHAR2, PV_RTYPE IN VARCHAR2, PV_FROMDATE IN DATE)
RETURN NUMBER IS
V_RESULT NUMBER;
BEGIN
    SELECT EA.VND INTO V_RESULT
    FROM (
        SELECT * FROM EXCHANGERATE
        UNION ALL
        SELECT * FROM EXCHANGERATE_HIST
    ) EA,
    (
        SELECT EB2.CURRENCY, EB2.ITYPE, EB2.RTYPE, EB2.TRADEDATE, MAX(EB2.LASTCHANGE) LASTCHANGE
        FROM
        (
            SELECT CURRENCY, ITYPE, RTYPE, MAX(TRADEDATE) TRADEDATE
            FROM (
                SELECT * FROM EXCHANGERATE
                UNION ALL
                SELECT * FROM EXCHANGERATE_HIST
            )
            WHERE CURRENCY = PV_CURRENCY
            AND ITYPE = PV_ITYPE
            AND RTYPE = PV_RTYPE
            GROUP BY CURRENCY, ITYPE, RTYPE
        )EB1,
        (
            SELECT * FROM EXCHANGERATE
            UNION ALL
            SELECT * FROM EXCHANGERATE_HIST
        )EB2
        WHERE EB1.CURRENCY = EB2.CURRENCY
        AND EB1.ITYPE = EB2.ITYPE
        AND EB1.RTYPE = EB2.RTYPE
        AND EB1.TRADEDATE = EB2.TRADEDATE
        GROUP BY EB2.CURRENCY, EB2.ITYPE, EB2.RTYPE, EB2.TRADEDATE
    )EB
    WHERE EA.CURRENCY = EB.CURRENCY
    AND EA.ITYPE = EB.ITYPE
    AND EA.RTYPE = EB.RTYPE
    AND EA.TRADEDATE = EB.TRADEDATE
    AND EA.LASTCHANGE = EB.LASTCHANGE;

    RETURN V_RESULT;

EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
/
