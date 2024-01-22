SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_GL0041_TR
(ACCTNO, BUSDATE, TRADE_NAMT, BLOCKED_NAMT, NETTING_NAMT, 
 EMKQTTY_NAMT, MORTAGE_NAMT, STANDING_NAMT, RECEIVING_NAMT, CA_RECEIVING_NAMT, 
 WITHDRAW_NAMT, DTOCLOSE_NAMT, BLOCKWITHDRAW_NAMT, BLOCKDTOCLOSE_NAMT)
AS 
SELECT ACCTNO, BUSDATE,
                SUM(CASE WHEN FIELD = 'TRADE' THEN (CASE WHEN TXTYPE = 'D' THEN - NAMT ELSE NAMT END) ELSE 0 END) TRADE_NAMT,
                SUM(CASE WHEN FIELD = 'BLOCKED' THEN (CASE WHEN TXTYPE = 'D' THEN - NAMT ELSE NAMT END) ELSE 0 END) BLOCKED_NAMT,
                SUM(CASE WHEN FIELD = 'NETTING' THEN (CASE WHEN TXTYPE = 'D' THEN - NAMT ELSE NAMT END) ELSE 0 END) NETTING_NAMT,
                SUM(CASE WHEN FIELD = 'EMKQTTY' THEN (CASE WHEN TXTYPE = 'D' THEN - NAMT ELSE NAMT END) ELSE 0 END) EMKQTTY_NAMT,
                SUM(CASE WHEN FIELD = 'MORTAGE' THEN (CASE WHEN TXTYPE = 'D' THEN - NAMT ELSE NAMT END) ELSE 0 END) MORTAGE_NAMT,
                SUM(CASE WHEN FIELD = 'STANDING' THEN (CASE WHEN TXTYPE = 'D' THEN NAMT ELSE -NAMT END) ELSE 0 END) STANDING_NAMT,
                SUM(CASE WHEN FIELD = 'RECEIVING' AND substr(TLTXCD,1,2) not IN('33','22') THEN
                    (CASE WHEN TXTYPE = 'D' THEN -NAMT ELSE NAMT END) ELSE 0 END) RECEIVING_NAMT,
                SUM(CASE WHEN FIELD = 'RECEIVING' AND substr(TLTXCD,1,2) IN('33','22') THEN
                    (CASE WHEN TXTYPE = 'D' THEN -NAMT ELSE NAMT END) ELSE 0 END) CA_RECEIVING_NAMT,
                SUM(CASE WHEN FIELD = 'WITHDRAW' THEN (CASE WHEN TXTYPE = 'D' THEN -NAMT ELSE NAMT END) ELSE 0 END) WITHDRAW_NAMT,
                SUM(CASE WHEN FIELD = 'DTOCLOSE' THEN (CASE WHEN TXTYPE = 'D' THEN -NAMT ELSE NAMT END) ELSE 0 END) DTOCLOSE_NAMT,
                SUM(CASE WHEN FIELD = 'BLOCKWITHDRAW' THEN (CASE WHEN TXTYPE = 'D' THEN -NAMT ELSE NAMT END) ELSE 0 END) BLOCKWITHDRAW_NAMT,
                SUM(CASE WHEN FIELD = 'BLOCKDTOCLOSE' THEN (CASE WHEN TXTYPE = 'D' THEN -NAMT ELSE NAMT END) ELSE 0 END) BLOCKDTOCLOSE_NAMT
            FROM VW_SETRAN_GEN
            WHERE DELTD <> 'Y' AND FIELD IN ('TRADE','BLOCKED','NETTING','EMKQTTY','MORTAGE','STANDING','WITHDRAW','DTOCLOSE','BLOCKWITHDRAW','BLOCKDTOCLOSE','RECEIVING')
                --and busdate > v_OnDate
            GROUP BY ACCTNO, BUSDATE
            HAVING SUM(CASE WHEN FIELD = 'TRADE' THEN (CASE WHEN TXTYPE = 'D' THEN - NAMT ELSE NAMT END) ELSE 0 END) <> 0 or
                SUM(CASE WHEN FIELD = 'BLOCKED' THEN (CASE WHEN TXTYPE = 'D' THEN - NAMT ELSE NAMT END) ELSE 0 END) <> 0 or
                SUM(CASE WHEN FIELD = 'NETTING' THEN (CASE WHEN TXTYPE = 'D' THEN - NAMT ELSE NAMT END) ELSE 0 END) <> 0 or
                SUM(CASE WHEN FIELD = 'EMKQTTY' THEN (CASE WHEN TXTYPE = 'D' THEN - NAMT ELSE NAMT END) ELSE 0 END) <> 0 or
                SUM(CASE WHEN FIELD = 'MORTAGE' THEN (CASE WHEN TXTYPE = 'D' THEN - NAMT ELSE NAMT END) ELSE 0 END) <> 0 or
                SUM(CASE WHEN FIELD = 'STANDING' THEN (CASE WHEN TXTYPE = 'D' THEN NAMT ELSE -NAMT END) ELSE 0 END) <> 0 or
                SUM(CASE WHEN FIELD = 'RECEIVING' AND substr(TLTXCD,1,2) not IN('33','22') THEN
                    (CASE WHEN TXTYPE = 'D' THEN -NAMT ELSE NAMT END) ELSE 0 END) <> 0 or
                SUM(CASE WHEN FIELD = 'RECEIVING' AND substr(TLTXCD,1,2) IN('33','22') THEN
                    (CASE WHEN TXTYPE = 'D' THEN -NAMT ELSE NAMT END) ELSE 0 END) <> 0 or
                SUM(CASE WHEN FIELD = 'WITHDRAW' THEN (CASE WHEN TXTYPE = 'D' THEN -NAMT ELSE NAMT END) ELSE 0 END) <> 0 or
                SUM(CASE WHEN FIELD = 'DTOCLOSE' THEN (CASE WHEN TXTYPE = 'D' THEN -NAMT ELSE NAMT END) ELSE 0 END) <> 0 or
                SUM(CASE WHEN FIELD = 'BLOCKWITHDRAW' THEN (CASE WHEN TXTYPE = 'D' THEN -NAMT ELSE NAMT END) ELSE 0 END) <> 0 or
                SUM(CASE WHEN FIELD = 'BLOCKDTOCLOSE' THEN (CASE WHEN TXTYPE = 'D' THEN -NAMT ELSE NAMT END) ELSE 0 END) <> 0
/
