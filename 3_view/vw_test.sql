SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_TEST
(AFACCTNO, CODEID, AMT)
AS 
SELECT SE.AFACCTNO AFACCTNO,  NVL(SB.REFCODEID,SB.CODEID ) CODEID,
               SUM(
                    NVL(SE.TRADE,0) +
                    NVL(SE.BLOCKED,0) +
                    NVL(SE.EMKQTTY,0) +
                    NVL(SE.SECURED,0) +
                    NVL(SE.BLOCKWITHDRAW,0) +
                    NVL(SE.WITHDRAW,0) +
                    NVL(SE.MORTAGE,0) +
                    NVL(SE.NETTING,0) +
                    NVL(SE.DTOCLOSE,0)+
                    NVL(SE.BLOCKDTOCLOSE,0) +
                    NVL(SE.WTRADE,0) +
                    NVL(SE.HOLD,0) -
                    NVL(NUM.AMT,0)
                ) AMT
        FROM  SEMAST SE, SBSECURITIES SB,
        (
            SELECT NVL(SUM(AMT ),0) AMT, ACCTNO
            FROM
            (
                SELECT SUM((CASE WHEN APP.TXTYPE = 'D' THEN -TR.NAMT WHEN APP.TXTYPE = 'C' THEN TR.NAMT ELSE 0  END )) AMT, TR.ACCTNO ACCTNO
                FROM APPTX APP, SETRAN TR, TLLOG TL
                WHERE TR.TXCD = APP.TXCD
                AND TL.TXNUM =TR.TXNUM
                AND APP.APPTYPE = 'SE'
                AND APP.TXTYPE IN ('C', 'D')
                AND TL.DELTD <>'Y'
                AND  TR.NAMT<>0
                AND TL.BUSDATE > TO_DATE(GETCURRDATE,'DD/MM/RRRR')
                AND APP.FIELD IN ('TRADE','BLOCKED','EMKQTTY','BLOCKWITHDRAW','WITHDRAW','MORTAGE','SECURED','NETTING','BLOCKDTOCLOSE','DTOCLOSE','WTRADE','HOLD')
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
                AND  TR.NAMT<>0
                AND TL.BUSDATE > TO_DATE(GETCURRDATE,'DD/MM/RRRR')
                AND APP.FIELD IN ('TRADE','BLOCKED','EMKQTTY','BLOCKWITHDRAW','WITHDRAW','MORTAGE','SECURED','NETTING','BLOCKDTOCLOSE','DTOCLOSE','WTRADE','HOLD')
                GROUP BY  TR.ACCTNO
            )
            GROUP BY ACCTNO
        )NUM
        WHERE SE.ACCTNO= NUM.ACCTNO (+)
        AND SE.CODEID =SB.CODEID
        AND (SE.TRADE + SE.BLOCKED + SE.SECURED + SE.WITHDRAW + SE.MORTAGE + NVL(SE.NETTING,0) + NVL(SE.DTOCLOSE,0) + NVL(SE.WTRADE,0) - NVL(NUM.AMT,0)) <> 0
        GROUP BY SE.AFACCTNO, NVL(SB.REFCODEID, SB.CODEID)
/
