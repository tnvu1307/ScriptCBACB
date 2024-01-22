SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW V_SE2220
(TXDATE, BUSDATE, CUSTODYCD, CIFID, TLTXCD, 
 SYMBOL, INCREASED, DECREASE, DESCCRIPTION, DORC, 
 SECTYPE, ISINCODE)
AS 
(
    SELECT TR.TXDATE,TR.BUSDATE,CF.CUSTODYCD,CF.CIFID, TR.TLTXCD,SB.SYMBOL,
            (case when  GL.DORC ='C' then TR.NAMT  else 0 end) INCREASED,
            (case when  GL.DORC ='D' then TR.NAMT  else 0 end) DECREASE,
            TR.TXDESC DESCCRIPTION, GL.DORC,SB.SECTYPE,SB.ISINCODE
        FROM CFMAST CF,
             --VW_SETRAN_GEN TR,
             (
                SELECT TLTXCD, TXNUM, TXDATE, BUSDATE, CUSTODYCD,AFACCTNO, AFACCTNO||CODEID ACCTNO, SYMBOL,CODEID, ABS(NAMT) NAMT,
                       CASE WHEN  NAMT < 0 THEN 'D' ELSE 'C' END TXTYPE,TXDESC
                FROM
                (
                    SELECT TR.TLTXCD, TR.TXNUM, TR.TXDATE, TR.BUSDATE, TR.CUSTODYCD,TR.AFACCTNO, --TR.ACCTNO, --TR.CODEID,
                           (case when SB.REFSYMBOL is null then SB.SYMBOL else SB.REFSYMBOL end) SYMBOL,
                           (case when SB.REFSYMBOL is null then SB.CODEID else SB.REFCODEID end) CODEID,
                           SUM(DECODE(TXTYPE,'C', NAMT, -NAMT)) NAMT,tr.TXDESC
                    FROM VW_SETRAN_GEN tr,
                         (
                              SELECT SB.CODEID, SB.SYMBOL,
                                    SB1.CODEID REFCODEID, SB1.SYMBOL REFSYMBOL
                                FROM SBSECURITIES SB, SBSECURITIES SB1
                                WHERE SB.REFCODEID = SB1.CODEID(+)
                                --AND SB.SECTYPE <> '004'
                         )SB
                    WHERE   tr.codeid = sb.codeid
                        and FIELD IN('TRADE','NETTING','WITHDRAW','BLOCKED','DTOCLOSE','BLOCKWITHDRAW','BLOCKDTOCLOSE','EMKQTTY','HOLD','MORTAGE' )
                        and TR.TLTXCD NOT IN ('1902','1903','2213')
                    GROUP BY TR.TLTXCD, TR.TXNUM, TR.TXDATE, TR.BUSDATE, TR.CUSTODYCD,TR.AFACCTNO ,TR.TXDESC,--TR.ACCTNO, --TR.CODEID,
                           (case when SB.REFSYMBOL is null then SB.SYMBOL else SB.REFSYMBOL end),
                           (case when SB.REFSYMBOL is null then SB.CODEID else SB.REFCODEID end)
                    HAVING SUM(DECODE(TXTYPE,'C', NAMT, -NAMT)) <> 0
                )
             ) TR,
             POSTMAPEXT GL, SBSECURITIES SB,(SELECT varvalue FROM SYSVAR WHERE varname = 'DEALINGCUSTODYCD')sv
        WHERE CF.CUSTODYCD = TR.CUSTODYCD
        AND SB.CODEID = TR.CODEID
        AND TR.TXTYPE = GL.DORC
        AND SB.CCYCD = GL.CCYCD
        AND GL.status ='A'
        --AND SB.SECTYPE <> '004' -- Khong lay CK quyen.
        AND (CASE WHEN SB.TRADEPLACE IN ('001','002','005','010') THEN '000' ELSE '001' END) = GL.TRADEPLACE
        AND (CASE WHEN GL.CFTYPE='000' THEN 1
                WHEN GL.CFTYPE ='001' AND  SUBSTR(CF.CUSTODYCD,1,4) = sv.varvalue THEN 1
                WHEN GL.CFTYPE ='003' AND  SUBSTR(CF.CUSTODYCD,1,4) <> sv.varvalue THEN 1
                ELSE 0 END) = 1
)
/
