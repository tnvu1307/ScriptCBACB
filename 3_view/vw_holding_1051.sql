SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_HOLDING_1051
(AMT, CAMASTID)
AS 
SELECT AMT, CAMASTID
FROM (
    SELECT NVL(SUM(SE.TOTAL),0) AMT, CA.CAMASTID
    FROM CAMAST CA
    LEFT JOIN
    (
        SELECT SE.*, (SE.TRADE + SE.MARGIN + SE.WTRADE + SE.MORTAGE + SE.BLOCKWITHDRAW + SE.EMKQTTY + SE.BLOCKDTOCLOSE + SE.BLOCKED + SE.SECURED + SE.REPO + SE.NETTING + SE.DTOCLOSE + SE.WITHDRAW + SE.HOLD) - NVL(TR.AMT, 0) TOTAL,
               SB.REFCODEID
        FROM SEMAST SE, SBSECURITIES SB,
        (
            SELECT  SUM((CASE WHEN APP.TXTYPE = 'D' THEN -TR.NAMT WHEN APP.TXTYPE = 'C' THEN TR.NAMT ELSE 0  END )) AMT, TR.ACCTNO ACCTNO
                            FROM APPTX APP, SETRAN TR, TLLOG TL
                            WHERE TR.TXCD = APP.TXCD
                            AND TL.TXNUM =TR.TXNUM
                            AND APP.APPTYPE = 'SE'
                            AND APP.TXTYPE IN ('C', 'D')
                            AND TL.DELTD <>'Y'
                            AND TR.NAMT<>0
                            AND APP.FIELD IN ('TRADE','MARGIN','BLOCKWITHDRAW','EMKQTTY','BLOCKDTOCLOSE','WTRADE','MORTAGE','BLOCKED','SECURED','REPO','NETTING','DTOCLOSE','WITHDRAW','HOLD')
                            AND TL.BUSDATE > GETCURRDATE
                            GROUP BY  TR.ACCTNO
            UNION ALL
            SELECT SUM((CASE WHEN APP.TXTYPE = 'D' THEN -TR.NAMT WHEN APP.TXTYPE = 'C' THEN TR.NAMT ELSE 0 END )) AMT, TR.ACCTNO ACCTNO
                            FROM APPTX APP, SETRANA TR ,TLLOGALL TL
                            WHERE TR.TXCD = APP.TXCD
                            AND TL.TXNUM =TR.TXNUM
                            AND TL.TXDATE =TR.TXDATE
                            AND APP.APPTYPE = 'SE'
                            AND APP.TXTYPE IN ('C', 'D')
                            AND TL.DELTD <>'Y'
                            AND TR.NAMT<>0
                            AND APP.FIELD IN ('TRADE','MARGIN','BLOCKWITHDRAW','EMKQTTY','BLOCKDTOCLOSE','WTRADE','MORTAGE','BLOCKED','SECURED','REPO','NETTING','DTOCLOSE','WITHDRAW','HOLD')
                            AND TL.BUSDATE > GETCURRDATE
                            GROUP BY  TR.ACCTNO
        ) TR
        WHERE SE.CODEID = SB.CODEID
        AND SE.ACCTNO = TR.ACCTNO(+)
    ) SE ON CA.CODEID = SE.CODEID OR CA.CODEID = SE.REFCODEID
    WHERE CA.STATUS = 'P'
    GROUP BY CA.CAMASTID
)NUM
/
