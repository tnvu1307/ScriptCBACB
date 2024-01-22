SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('GL1000','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('GL1000', 'Tra cứu COA trước batch', 'Look up COA before the batch', 'SELECT TO_CHAR(TR.TXDATE, ''YYYYMMDD'') || TR.TXNUM REF, GL.AUTOID REFAUTOID, TR.TLTXCD, TR.TXNUM, TR.TXDATE,  TR.BUSDATE,
           CF.CUSTID, CF.CUSTODYCD, nvl(cf.mcifid,CF.CIFID)CIFID, SB.SYMBOL,TR.NAMT QTTY, SB.PARVALUE AMOUNT, GL.CCYCD, GL.DORC,
           GL.DEBITACCOUNT DEBITACCT, GL.CREBITACCOUNT CREDITACCT, ''N'' DELTD
    FROM CFMAST CF,
         --VW_SETRAN_GEN TR,
         (
            SELECT TLTXCD, TXNUM, TXDATE, BUSDATE, CUSTODYCD,AFACCTNO, AFACCTNO||CODEID ACCTNO, SYMBOL,CODEID, ABS(NAMT) NAMT,
                   CASE WHEN  NAMT < 0 THEN ''D'' ELSE ''C'' END TXTYPE
            FROM
            (
                SELECT TR.TLTXCD, TR.TXNUM, TR.TXDATE, TR.BUSDATE, TR.CUSTODYCD,TR.AFACCTNO, --TR.ACCTNO, --TR.CODEID,
                       (case when SB.REFSYMBOL is null then SB.SYMBOL else SB.REFSYMBOL end) SYMBOL,
                       (case when SB.REFSYMBOL is null then SB.CODEID else SB.REFCODEID end) CODEID,
                       SUM(DECODE(TXTYPE,''C'', NAMT, -NAMT)) NAMT
                FROM VW_SETRAN_GEN tr,
                     (
                          SELECT SB.CODEID, SB.SYMBOL,
                                SB1.CODEID REFCODEID, SB1.SYMBOL REFSYMBOL
                            FROM SBSECURITIES SB, SBSECURITIES SB1
                            WHERE SB.REFCODEID = SB1.CODEID(+)
                                and sb.sectype <> ''004''
                     )SB
                WHERE tr.codeid = sb.codeid
                     -- and FIELD IN (''TRADE'',''NETTING'',''WITHDRAW'',''BLOCKED'',''DTOCLOSE'',''BLOCKWITHDRAW'',''BLOCKDTOCLOSE'',''EMKQTTY'')
                      and FIELD IN(''TRADE'',''NETTING'',''WITHDRAW'',''BLOCKED'',''DTOCLOSE'',''BLOCKWITHDRAW'',''BLOCKDTOCLOSE'',''EMKQTTY'',''HOLD'',''MORTAGE'' )
                GROUP BY TR.TLTXCD, TR.TXNUM, TR.TXDATE, TR.BUSDATE, TR.CUSTODYCD,TR.AFACCTNO, --TR.ACCTNO, --TR.CODEID,
                       (case when SB.REFSYMBOL is null then SB.SYMBOL else SB.REFSYMBOL end),
                       (case when SB.REFSYMBOL is null then SB.CODEID else SB.REFCODEID end)
                HAVING SUM(DECODE(TXTYPE,''C'', NAMT, -NAMT)) <> 0
            )
         ) TR,
         POSTMAPEXT GL, SBSECURITIES SB
    WHERE CF.CUSTODYCD = TR.CUSTODYCD
    --AND TR.FIELD =''TRADE''
    AND SB.CODEID = TR.CODEID
    AND TR.TXTYPE = GL.DORC
    AND TR.txdate = getcurrdate 
    AND SB.CCYCD = GL.CCYCD
    AND GL.status =''A''
    and sb.sectype <> ''004'' -- Khong lay CK quyen.
    AND (CASE WHEN SB.TRADEPLACE IN (''001'',''002'',''005'',''010'') THEN ''000'' ELSE ''001'' END) = GL.TRADEPLACE
    /*and sb.sectype NOT IN (''004'', ''006'') */
    AND (CASE WHEN GL.CFTYPE=''000'' THEN 1
            WHEN GL.CFTYPE =''001'' AND  SUBSTR(CF.CUSTODYCD,1,4) = (SELECT varvalue
          FROM SYSVAR WHERE varname = ''DEALINGCUSTODYCD'') THEN 1
            WHEN GL.CFTYPE =''003'' AND  SUBSTR(CF.CUSTODYCD,1,4) <> (SELECT varvalue
          FROM SYSVAR WHERE varname = ''DEALINGCUSTODYCD'')  THEN 1
            ELSE 0 END) = 1', 'GL1000', '', 'REF DESC', '', 0, 5000, 'Y', 1, '', 'Y', 'T', '', 'N', '');COMMIT;