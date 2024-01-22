SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_gen_fin_report (p_type        VARCHAR2,
                                             p_custodycd    VARCHAR2,
                                             p_date         DATE,
                                             p_txdate       DATE,
                                             p_fromRow      NUMBER,
                                             p_rowCount     NUMBER,
                                             p_last         IN OUT VARCHAR2,
                                             p_60M          IN OUT NUMBER) return VARCHAR2 IS
  l_strMessage    VARCHAR2(3000);
  l_count         NUMBER := 0;
  l_strMessageBuild  VARCHAR2(3000);
  l_strMessageSubBlock  VARCHAR2(3000);
  l_exrate           NUMBER;
  l_strMessageTemp VARCHAR2(3000);
  l_oldSymbol      VARCHAR2(100) := 'x';
  l_strFinBlock    VARCHAR2(3000);
  l_strSubSafeBlock VARCHAR2(3000);
  l_strDate        VARCHAR2(10) := TO_CHAR (p_date,'rrrrmmdd');
  l_strCurrDate    VARCHAR2(10) := TO_CHAR (p_txdate, 'rrrrmmdd');
  l_ccycd          VARCHAR2(10) := 'USD';
  l_pageNo         NUMBER;
  l_MT940_950_60F  VARCHAR2(100);
  l_MT940_950_62F  VARCHAR2(100);
  l_MT940_64  VARCHAR2(100);
  l_VND  VARCHAR2(100);
  l_60F NUMBER;
  l_62F NUMBER;
  l_60M NUMBER;
  l_62M NUMBER;
BEGIN
    p_last := 'Y';
    l_count := 0;
    BEGIN
        l_pageNo := (p_fromRow - 1)/p_rowCount;
    EXCEPTION WHEN OTHERS THEN
        l_pageNo := 1;
    END;

    IF p_type = '535.STMT.HOLD' THEN
    BEGIN
        l_strSubSafeBlock := ':16R:SUBSAFE' || '||' ||
                             '<$DETAIL>' || '||' ||
                             ':16S:SUBSAFE' || '||';
        l_strMessageTemp := ':16R:FIN' || '||' ||
                            ':35B:ISIN <$SYMBOL>' || '||' ||
                            ':90B::MRKT//ACTU/VND<$PRICE>'|| '||' ||
                            ':98A::PRIC//<$DATE>' || '||' ||
                            ':93B::AGGR//UNIT/<$QTTY>'|| '||' ||
                            ':16R:SUBBAL' || '||' ||
                            ':93B::AVAI//UNIT/<$AVLQTTY>' || '||' ||
                            ':94C::SAFE//VN' || '||' ||
                            ':16S:SUBBAL' || '||' ||
                            ':19A::HOLD//VND<$AMOUNT>' || '||' ||
                            ':92B::EXCH//VND/USD/<$EXRATE>' || '||' ||
                            ':16S:FIN';
        l_exrate := getExchangeRateAll (p_rtype     => 'TTM',
                                      p_currency  => l_ccycd,
                                      p_itype     => 'SHV',
                                      p_tradedate => TO_CHAR (p_date,'dd/mm/rrrr'));

        FOR rec IN (
          SELECT *
          FROM
          (
            SELECT tbl.*, rownum rn
            FROM
            (
              SELECT --MAX(REPLACE(sb.symbol,'_WTF','')) SYMBOL,
                     MAX(NVL(s1.isincode, s.isincode)) isincode,
                     MAX(NVL(sb.AVGPRICE,0)) AVGPRICE,
                     SUM(DECODE(NVL(s.refcodeid,'x'),'x',mst.trade,0) - NVL(se.namt_trade, 0)) trade,
                     SUM(MST.TRADE + MST.HOLD + MST.MORTAGE + MST.NETTING + MST.BLOCKED + MST.WITHDRAW + MST.BLOCKWITHDRAW + MST.EMKQTTY - NVL(SE.NAMT,0)) total
              FROM cfmast cf, semast mst
              LEFT JOIN (SELECT se.acctno,
                                 sum(decode(se.txcd, 'C', namt, -namt)) namt,
                                 sum(CASE WHEN se.field='TRADE' AND instr(se.symbol, '_WFT')=0 THEN decode(se.txcd, 'C', namt, -namt) ELSE 0 END) namt_trade
                          FROM vw_setran_gen se
                          WHERE se.custodycd = p_custodycd AND se.BUSDATE > p_date
                          AND se.txcd IN ('C','D') AND se.deltd <> 'Y'
                          AND se.field IN ('TRADE','HOLD','MORTAGE','NETTING','BLOCKED','WITHDRAW','BLOCKWITHDRAW','EMKQTTY')
                          GROUP BY se.acctno
              ) se ON mst.acctno = se.acctno
              LEFT JOIN vw_securities_info_hist sb ON sb.CODEID = mst.codeid AND sb.HISTDATE = p_date
              INNER JOIN sbsecurities s ON mst.codeid = s.codeid
              LEFT JOIN sbsecurities s1 ON s.refcodeid = s1.codeid
              WHERE mst.custid = cf.custid AND cf.custodycd = p_custodycd
              AND (MST.TRADE + MST.HOLD + MST.MORTAGE + MST.NETTING + MST.BLOCKED + MST.WITHDRAW + MST.BLOCKWITHDRAW + MST.EMKQTTY - NVL(SE.NAMT,0)) > 0
              AND S.SECTYPE NOT IN ('013','009','014') --TRUNG.LUU: 03-12-2020 SHBVNEX-1860
              GROUP BY cf.custid, NVL(s.refcodeid, s.codeid)
              ORDER BY NVL(s.refcodeid, s.codeid)
            ) tbl
            WHERE rownum <= p_fromRow + p_rowCount + 1
          )
          WHERE rn >= p_fromRow AND rn <= p_fromRow + p_rowCount + 1
        ) LOOP
          l_count := l_count + 1;
          IF l_count > p_rowCount THEN
            p_last := 'N';
            EXIT ;
          END IF;

          l_strMessageBuild := l_strMessageTemp;
          l_strMessageBuild := REPLACE(l_strMessageBuild,'<$SYMBOL>',rec.isincode);
          l_strMessageBuild := REPLACE(l_strMessageBuild,'<$PRICE>',rec.avgprice || ',');
          l_strMessageBuild := REPLACE(l_strMessageBuild,'<$DATE>',l_strCurrDate);
          l_strMessageBuild := REPLACE(l_strMessageBuild,'<$QTTY>',rec.total || ',');
          l_strMessageBuild := REPLACE(l_strMessageBuild,'<$AVLQTTY>',rec.trade || ',');
          l_strMessageBuild := REPLACE(l_strMessageBuild,'<$AMOUNT>',rec.total * rec.avgprice || ',');
          l_strMessageBuild := REPLACE(l_strMessageBuild,'<$EXRATE>',l_exrate || ',');

          IF l_strMessage IS NULL OR length(l_strMessage) = 0 THEN
            l_strMessage := l_strMessageBuild;
          ELSE
            l_strMessage := l_strMessage ||'||'|| l_strMessageBuild;
          END IF;

        END LOOP;
        IF l_strMessage IS NOT NULL THEN
          l_strMessage := REPLACE(l_strSubSafeBlock, '<$DETAIL>', l_strMessage);
        END IF;
    END;
    ELSIF p_type = '535.STMT.HOLD.NU' THEN
    BEGIN
        l_strSubSafeBlock := ':16R:SUBSAFE' || '||' ||
                             '<$DETAIL>' || '||' ||
                             ':16S:SUBSAFE' || '||';
        l_strMessageTemp := ':16R:FIN' || '||' ||
                            ':35B:ISIN <$SYMBOL>' || '||' ||
                            ':90B::MRKT//ACTU/VND<$PRICE>'|| '||' ||
                            ':98A::PRIC//<$DATE>' || '||' ||
                            ':93B::AGGR//UNIT/<$QTTY>'|| '||' ||
                            ':16R:SUBBAL' || '||' ||
                            ':93B::AVAI//UNIT/<$AVLQTTY>' || '||' ||
                            ':94C::SAFE//VN' || '||' ||
                            ':16S:SUBBAL' || '||' ||
                            ':19A::HOLD//VND<$AMOUNT>' || '||' ||
                            ':92B::EXCH//VND/USD/<$EXRATE>' || '||' ||
                            ':16S:FIN';
        l_exrate := getExchangeRateAll (p_rtype     => 'TTM',
                                      p_currency  => l_ccycd,
                                      p_itype     => 'SHV',
                                      p_tradedate => TO_CHAR (p_date,'dd/mm/rrrr'));

        FOR rec IN (
          SELECT *
          FROM
          (
            SELECT tbl.*, rownum rn
            FROM
            (
              SELECT --MAX(REPLACE(sb.symbol,'_WTF','')) SYMBOL,
                     MAX(NVL(s1.isincode, s.isincode)) isincode,
                     MAX(NVL(sb.AVGPRICE,0)) AVGPRICE,
                     SUM(DECODE(NVL(s.refcodeid,'x'),'x',mst.trade,0) - NVL(se.namt_trade, 0)) trade,
                     SUM(MST.TRADE + MST.HOLD + MST.MORTAGE + MST.NETTING + MST.BLOCKED + MST.WITHDRAW + MST.BLOCKWITHDRAW + MST.EMKQTTY - NVL(SE.NAMT,0)) total
              FROM cfmast cf, semast mst
              LEFT JOIN (SELECT se.acctno,
                                 sum(decode(se.txcd, 'C', namt, -namt)) namt,
                                 sum(CASE WHEN se.field='TRADE' AND instr(se.symbol, '_WFT')=0 THEN decode(se.txcd, 'C', namt, -namt) ELSE 0 END) namt_trade
                          FROM vw_setran_gen se
                          WHERE se.custodycd = p_custodycd AND se.BUSDATE > p_date
                          AND se.txcd IN ('C','D') AND se.deltd <> 'Y'
                          AND se.field IN ('TRADE','HOLD','MORTAGE','NETTING','BLOCKED','WITHDRAW','BLOCKWITHDRAW','EMKQTTY')
                          GROUP BY se.acctno
              ) se ON mst.acctno = se.acctno
              LEFT JOIN vw_securities_info_hist sb ON sb.CODEID = mst.codeid AND sb.HISTDATE = p_date
              INNER JOIN sbsecurities s ON mst.codeid = s.codeid
              LEFT JOIN sbsecurities s1 ON s.refcodeid = s1.codeid
              WHERE mst.custid = cf.custid AND cf.custodycd = p_custodycd
              AND (MST.TRADE + MST.HOLD + MST.MORTAGE + MST.NETTING + MST.BLOCKED + MST.WITHDRAW + MST.BLOCKWITHDRAW + MST.EMKQTTY - NVL(SE.NAMT,0)) > 0
              AND S.SECTYPE NOT IN ('013','009','014') --TRUNG.LUU: 03-12-2020 SHBVNEX-1860
              AND (S.TRADEPLACE <> '003' OR (S.TRADEPLACE = '003' AND S.DEPOSITORY <> '001')) --SHBVNEX-1859
              GROUP BY cf.custid, NVL(s.refcodeid, s.codeid)
              ORDER BY NVL(s.refcodeid, s.codeid)
            ) tbl
            WHERE rownum <= p_fromRow + p_rowCount + 1
          )
          WHERE rn >= p_fromRow AND rn <= p_fromRow + p_rowCount + 1
        ) LOOP
          l_count := l_count + 1;
          IF l_count > p_rowCount THEN
            p_last := 'N';
            EXIT ;
          END IF;

          l_strMessageBuild := l_strMessageTemp;
          l_strMessageBuild := REPLACE(l_strMessageBuild,'<$SYMBOL>',rec.isincode);
          l_strMessageBuild := REPLACE(l_strMessageBuild,'<$PRICE>',rec.avgprice || ',');
          l_strMessageBuild := REPLACE(l_strMessageBuild,'<$DATE>',l_strCurrDate);
          l_strMessageBuild := REPLACE(l_strMessageBuild,'<$QTTY>',rec.total || ',');
          l_strMessageBuild := REPLACE(l_strMessageBuild,'<$AVLQTTY>',rec.trade || ',');
          l_strMessageBuild := REPLACE(l_strMessageBuild,'<$AMOUNT>',rec.total * rec.avgprice || ',');
          l_strMessageBuild := REPLACE(l_strMessageBuild,'<$EXRATE>',l_exrate || ',');

          IF l_strMessage IS NULL OR length(l_strMessage) = 0 THEN
            l_strMessage := l_strMessageBuild;
          ELSE
            l_strMessage := l_strMessage ||'||'|| l_strMessageBuild;
          END IF;

        END LOOP;
        IF l_strMessage IS NOT NULL THEN
          l_strMessage := REPLACE(l_strSubSafeBlock, '<$DETAIL>', l_strMessage);
        END IF;
    END;
    ELSIF p_type = '536.STMT.TXN' THEN
    BEGIN
        l_strFinBlock := ':16R:FIN' ||'||' ||
                         ':35B:ISIN <$SYMBOL>'|| '||' ||
                         '<$TRANS>' || '||' ||
                         ':16S:FIN' || '||';
        l_strMessageTemp := ':16R:TRAN' || '||' ||
                            ':16R:LINK' || '||' ||
                            ':20C::RELA//<$TXNUM>' || '||' ||
                            ':16S:LINK' || '||' ||
                            ':16R:TRANSDET' || '||' ||
                            -- ':36B::PSTA//<$PSTA>/<$QTTY>' || '||' || gan cung UNIT theo yeu cau tester
                            ':36B::PSTA//UNIT/<$QTTY>' || '||' ||
                            ':22F::TRAN//<$TRAN>' || '||' ||
                            ':22H::<$SUBTRAN>' || '||' ||
                            ':22H::PAYM//FREE' || '||' ||
                            ':98A::ESET//<$BDATE>' || '||' ||
                            ':16S:TRANSDET' || '||' ||
                            ':16S:TRAN';
        FOR rec IN (
          SELECT *
          FROM (
            SELECT tbl.*, rownum rn
            FROM (
              SELECT se.busdate, se.txnum, se.namt, NVL(sb2.isincode, sb.isincode) isincode, NVL(sb2.symbol, sb.symbol) symbol,
                     --decode(NVL(sb2.symbol,'x'), 'x', 'SETT', 'CORP') tran,
                     CASE WHEN field = 'TRADE' AND sb.sectype = '004' AND tltxcd IN ('3375','3385','3386') AND txtype = 'C' THEN 'CORP'
                          WHEN field = 'TRADE' AND sb.sectype = '004' AND tltxcd IN ('3376','3337','3384','3333') AND txtype = 'D' THEN 'CORP'
                          ELSE 'SETT' END tran,
                     decode(se.txtype, 'C', 'REDE//RECE', 'REDE//DELI') substran,
                     --CASE WHEN se.sectype IN ('001','002','008','011') THEN 'UNIT' ELSE 'FAMT' END PSTA
                     CASE WHEN se.sectype IN ('004') THEN 'FAMT' ELSE 'UNIT' END PSTA
              FROM vw_setran_gen se, sbsecurities sb, sbsecurities sb2
              WHERE se.custodycd = p_custodycd
              AND se.field IN ('TRADE','BLOCKED','NETTING','EMKQTTY','DTOCLOSE','BLOCKDTOCLOSE','WITHDRAW','TRANSFER','BLOCKTRANFER')
              AND se.txtype IN ('C', 'D')
              AND se.txdate = p_date
              AND se.codeid = sb.codeid AND sb.refcodeid = sb2.codeid(+)
              AND (CASE WHEN se.field = 'TRADE' AND se.sectype <> '004' AND se.txtype = 'C' AND se.tltxcd NOT IN ('2202','2203','2263','3355','3356','8895') THEN 1
                        WHEN se.field = 'TRADE' AND se.sectype = '004' AND se.txtype = 'C' AND se.tltxcd IN ('3375','3385') THEN 1
                        WHEN se.field = 'TRADE' AND se.sectype = '004' AND se.txtype = 'D' AND se.tltxcd NOT IN ('3333','3337','3376') THEN 1
                        WHEN se.field = 'BLOCKED' AND se.tltxcd NOT IN ('2202','2203','2263','3355','3356') AND se.txtype = 'C' THEN 1
                        WHEN se.field = 'NETTING' AND se.sectype = '004' AND se.txtype = 'D' THEN 1
                        WHEN se.field = 'NETTING' AND se.sectype <> '004' AND se.txtype = 'D' AND se.tltxcd NOT IN ('8895') THEN 1
                        WHEN se.field = 'EMKQTTY' AND se.tltxcd NOT IN ('2202','2203') THEN 1
                        WHEN se.field = 'DTOCLOSE' AND se.txtype = 'D' AND se.tltxcd NOT IN ('2290') THEN 1
                        WHEN se.field = 'BLOCKDTOCLOSE' AND se.txtype = 'D' THEN 1
                        WHEN se.field = 'WITHDRAW' AND se.txtype = 'D' AND se.tltxcd NOT IN ('2254','2289','2293') THEN 1
                        WHEN se.field = 'BLOCKWITHDRAW' AND se.txtype = 'D' AND se.tltxcd NOT IN ('2254','2289','2293') THEN 1
                        WHEN se.field = 'TRANSFER' AND se.txtype = 'D' THEN 1
                        WHEN se.field = 'BLOCKTRANFER' AND se.txtype = 'D' THEN 1
                        ELSE 0 END) = 1
              AND (txnum,txdate) NOT IN (SELECT txnum,txdate FROM vw_setran_gen
                                         WHERE txdate = p_date
                                         AND field IN ('MORTAGE'))
              ORDER BY NVL(sb2.symbol, sb.symbol), se.autoid
            ) tbl
            WHERE rownum <= p_fromRow + p_rowCount + 1
          )
          WHERE rn >= p_fromRow AND rn <= p_fromRow + p_rowCount + 1
        ) LOOP
          l_count := l_count + 1;
          IF l_count > p_rowCount THEN
            p_last := 'N';
            EXIT ;
          END IF;
          l_strMessageBuild := l_strMessageTemp;
          l_strMessageBuild := REPLACE(l_strMessageBuild,'<$SYMBOL>',rec.isincode);
          l_strMessageBuild := REPLACE(l_strMessageBuild,'<$TXNUM>',rec.txnum);
          l_strMessageBuild := REPLACE(l_strMessageBuild,'<$QTTY>',rec.namt || ',');
          l_strMessageBuild := REPLACE(l_strMessageBuild,'<$TRAN>',rec.tran);
          l_strMessageBuild := REPLACE(l_strMessageBuild,'<$SUBTRAN>',rec.substran);
          l_strMessageBuild := REPLACE(l_strMessageBuild,'<$PSTA>',rec.PSTA);
          l_strMessageBuild := REPLACE(l_strMessageBuild,'<$DATE>',l_strDate);
          l_strMessageBuild := REPLACE(l_strMessageBuild,'<$BDATE>',TO_CHAR(rec.busdate,'rrrrmmdd'));

          IF l_oldSymbol <> 'x' AND l_oldSymbol <> rec.isincode THEN
            IF l_strMessage IS NULL OR length(l_strMessage) = 0 THEN
              l_strMessage := l_strMessage || REPLACE(l_strFinBlock, '<$TRANS>', l_strMessageSubBlock);
            ELSE
              l_strMessage := l_strMessage || '||' || REPLACE(l_strFinBlock, '<$TRANS>', l_strMessageSubBlock);
            END IF;
            l_strMessage := REPLACE (l_strMessage, '<$SYMBOL>', l_oldSymbol);

            l_strMessageSubBlock := '';

          END IF;

          IF l_strMessageSubBlock IS NULL OR length(l_strMessageSubBlock) = 0 THEN
            l_strMessageSubBlock := l_strMessageBuild;
          ELSE
            l_strMessageSubBlock := l_strMessageSubBlock || '||' || l_strMessageBuild;
          END IF;

          l_oldSymbol := rec.isincode;
        END LOOP;

        IF l_strMessageSubBlock IS NOT NULL AND length(l_strMessageSubBlock) > 0 THEN
          IF l_strMessage IS NULL OR length(l_strMessage) = 0 THEN
              l_strMessage := REPLACE(l_strFinBlock, '<$TRANS>', l_strMessageSubBlock);
            ELSE
              --l_strMessage := l_strMessage || CHR(10) || l_strMessageSubBlock;
              l_strMessage := l_strMessage || '||' || REPLACE(l_strFinBlock, '<$TRANS>', l_strMessageSubBlock);
            END IF;
            l_strMessage := REPLACE (l_strMessage, '<$SYMBOL>', l_oldSymbol);
        END IF;
        IF l_strMessage IS NOT NULL AND length(l_strMessage) > 0 THEN
          l_strMessage := ':16R:SUBSAFE' || '||' || l_strMessage || '||' || ':16S:SUBSAFE';
        END IF;
    END;
    ELSIF p_type = '940.CST.STMT.MSG' THEN
    BEGIN
        l_strMessageTemp := ':61:<$STATEMENT>' || '||' ||
                            ':86:<$DESC>';

        BEGIN
            SELECT CCYCD INTO l_VND
            FROM ddmast dd
            WHERE dd.ACCTNO  = p_custodycd;  --trung.luu:  11-01-2021  SHBVNEX-1889 MT940 MT950 sinh theo ddmast.acctno
        EXCEPTION WHEN OTHERS THEN
            l_VND := 'ERROR';

        END;
        BEGIN
            SELECT dd.balance + dd.holdbalance - NVL(ddt.CI_TOTAL_MOVE_FRDT_AMT, 0)
            INTO l_60F
            FROM ddmast dd
            LEFT JOIN
            (
                SELECT TR.DDACCTNO,
                SUM(CASE WHEN TR.TXTYPE = 'D' THEN -TR.NAMT ELSE TR.NAMT END) CI_TOTAL_MOVE_FRDT_AMT
                FROM
                (
                    SELECT LOG.TXTYPE, LOG.NAMT, NVL(LOG.BUSDATE, LOG.TXDATE) BKDATE, LOG.ACCTNO DDACCTNO, LOG.FIELD
                    FROM VW_DDTRAN_GEN LOG, VW_TLLOG_ALL TL1,
                    (SELECT EN_TXDESC, TLTXCD, TXDESC CDCONTENT, EN_TXDESC EN_CDCONTENT FROM TLTX) TLTX
                    WHERE LOG.TLTXCD = TLTX.TLTXCD
                    AND LOG.TXDATE = TL1.TXDATE AND LOG.TXNUM = TL1.TXNUM
                    AND LOG.FIELD = 'BALANCE'
                    AND LOG.TXTYPE IN ('D','C')
                    AND LOG.DELTD = 'N'
                    AND LOG.NAMT <> 0
                    AND LOG.TLTXCD NOT IN ('6690', '6691', '6696', '6697', '6698', '6699', '6689', '6692', '6603', '6604')
                    AND LOG.TLTXCD NOT IN ('6628', '6629', '6615', '6659')
                    AND TL1.TLTXCD NOT IN ('1296')
                    AND NOT EXISTS (
                        SELECT 1 FROM VW_TLLOG_ALL TL2
                        WHERE TL2.TLTXCD IN ('6628', '6629', '6615', '6659')
                        AND TL2.TXDATE = TL1.TXDATE
                        AND TL2.REFTXNUM = TL1.TXNUM
                    )
                ) TR
                WHERE TR.BKDATE >= P_DATE
                GROUP BY TR.DDACCTNO
            ) ddt ON dd.acctno = ddt.DDACCTNO
            WHERE dd.acctno  = p_custodycd ; --trung.luu:  11-01-2021  SHBVNEX-1889 MT940 MT950 sinh theo ddmast.acctno
        EXCEPTION WHEN OTHERS THEN
            l_60F := 0;
            
        END;

        IF p_60M = 0 OR p_60M IS NULL THEN
            l_60M := l_60F;
        ELSE
            l_60M := p_60M;
        END IF;
        l_62M := l_60F;

        FOR REC IN (
            SELECT *
            FROM (
                SELECT TBL.*, ROWNUM RN
                FROM (
                    SELECT (CASE WHEN NAMT > 0 THEN 'C' ELSE 'D' END) TXTYPE,
                         NAMT N_NAMT,
                         TO_CHAR(TXDATE, 'RRMMDD')    TXDATE,
                         SUBSTR(DD.CCYCD,3,1)         CCYCD,
                         REPLACE(TO_CHAR(ABS(NAMT) ,'FM999999999999999990.999999'),'.',',') NAMT,
                         'FTRFNONREF//' || TXNUM      REFVAL,
                         TXDESC
                    FROM DDMAST DD
                    INNER JOIN
                    (
                        SELECT LOG.ACCTNO,
                            SUM(DECODE(LOG.TXTYPE,'C',LOG.NAMT,-LOG.NAMT)) NAMT,
                            LOG.TXDATE, LOG.TXNUM, LOG.TLLOG_AUTOID,
                            MAX(NVL(LOG.TXDESC, TLTX.EN_TXDESC)) TXDESC
                        FROM VW_DDTRAN_GEN LOG, VW_TLLOG_ALL TL1,
                        (SELECT EN_TXDESC, TLTXCD, TXDESC CDCONTENT, EN_TXDESC EN_CDCONTENT FROM TLTX) TLTX
                        WHERE LOG.TLTXCD = TLTX.TLTXCD
                        AND LOG.TXDATE = TL1.TXDATE AND LOG.TXNUM = TL1.TXNUM
                        AND LOG.FIELD = 'BALANCE'
                        AND LOG.TXTYPE IN ('D','C')
                        AND LOG.DELTD = 'N'
                        AND LOG.NAMT <> 0
                        AND LOG.TLTXCD NOT IN ('6690', '6691', '6696', '6697', '6698', '6699', '6689', '6692', '6603', '6604')
                        AND LOG.TLTXCD NOT IN ('6628', '6629', '6615', '6659')
                        AND TL1.TLTXCD NOT IN ('1296')
                        AND NOT EXISTS (
                            SELECT 1 FROM VW_TLLOG_ALL TL2
                            WHERE TL2.TLTXCD IN ('6628', '6629', '6615', '6659')
                            AND TL2.TXDATE = TL1.TXDATE
                            AND TL2.REFTXNUM = TL1.TXNUM
                        )
                        AND NVL(LOG.BUSDATE, LOG.TXDATE) = P_DATE
                        GROUP BY LOG.ACCTNO, LOG.TXDATE, LOG.TXNUM, LOG.TLLOG_AUTOID
                    ) DDT ON DD.ACCTNO = DDT.ACCTNO
                    WHERE DD.STATUS <> 'C'
                    AND DD.ACCTNO  = P_CUSTODYCD  --TRUNG.LUU:  11-01-2021  SHBVNEX-1889 MT940 MT950 SINH THEO DDMAST.ACCTNO
                    ORDER BY DDT.TXDATE, DDT.TLLOG_AUTOID, DDT.TXNUM
                ) TBL
                WHERE ROWNUM <= P_FROMROW + P_ROWCOUNT + 1
            )
            WHERE RN >= P_FROMROW AND RN <= P_FROMROW + P_ROWCOUNT + 1
        ) LOOP

            l_count := l_count + 1;
            IF l_count > p_rowCount THEN
                p_last := 'N';
                EXIT ;
            END IF;

            l_62M := l_62M + rec.n_namt;

            l_strMessageBuild := l_strMessageTemp;
            l_strMessageBuild := REPLACE(l_strMessageBuild,'<$STATEMENT>',rec.txdate || rec.txtype || rec.ccycd || rec.namt || rec.refval);
            l_strMessageBuild := REPLACE(l_strMessageBuild,'<$DESC>', substr(nmpks_ems.fn_convert_to_vn(rec.txdesc),1,65));

            IF l_strMessage IS NULL OR length(l_strMessage) = 0 THEN
                l_strMessage := l_strMessageBuild;
            ELSE
                l_strMessage := l_strMessage || '||' || l_strMessageBuild;
            END IF;
        END LOOP;

        IF l_strMessage IS NOT NULL AND length(l_strMessage) > 0 THEN
            l_strMessage := l_strMessage || '||';
        END IF;

        IF p_last = 'Y' THEN
            BEGIN
                SELECT 'C' || TO_CHAR(p_date,'rrmmdd') || CCYCD || REPLACE(TO_CHAR(dd.balance - NVL(ddt.CI_TOTAL_MOVE_FRDT_AMT,0),'FM999999999999999990.999999'),'.',',')
                INTO l_MT940_64
                FROM ddmast dd
                LEFT JOIN (
                    SELECT TR.DDACCTNO,
                    SUM(CASE WHEN TR.TXTYPE = 'D' THEN -TR.NAMT ELSE TR.NAMT END) CI_TOTAL_MOVE_FRDT_AMT
                    FROM
                    (
                        SELECT LOG.TXTYPE, LOG.NAMT, NVL(LOG.BUSDATE, LOG.TXDATE) BKDATE, LOG.ACCTNO DDACCTNO, LOG.FIELD
                        FROM VW_DDTRAN_GEN LOG, VW_TLLOG_ALL TL1,
                        (SELECT EN_TXDESC, TLTXCD, TXDESC CDCONTENT, EN_TXDESC EN_CDCONTENT FROM TLTX) TLTX
                        WHERE LOG.TLTXCD = TLTX.TLTXCD
                        AND LOG.TXDATE = TL1.TXDATE AND LOG.TXNUM = TL1.TXNUM
                        AND LOG.FIELD = 'BALANCE'
                        AND LOG.TXTYPE IN ('D','C')
                        AND LOG.DELTD = 'N'
                        AND LOG.NAMT <> 0
                        AND LOG.TLTXCD NOT IN ('6690', '6691', '6696', '6697', '6698', '6699', '6689', '6692', '6603', '6604')
                        AND LOG.TLTXCD NOT IN ('6628', '6629', '6615', '6659')
                        AND TL1.TLTXCD NOT IN ('1296')
                        AND NOT EXISTS (
                            SELECT 1 FROM VW_TLLOG_ALL TL2
                            WHERE TL2.TLTXCD IN ('6628', '6629', '6615', '6659')
                            AND TL2.TXDATE = TL1.TXDATE
                            AND TL2.REFTXNUM = TL1.TXNUM
                        )
                    ) TR
                    WHERE TR.BKDATE > P_DATE
                    GROUP BY TR.DDACCTNO
                ) ddt ON dd.acctno = ddt.DDACCTNO
                WHERE dd.acctno  = p_custodycd ; --trung.luu:  11-01-2021  SHBVNEX-1889 MT940 MT950 sinh theo ddmast.acctno
            EXCEPTION WHEN OTHERS THEN
                l_MT940_64 := 'ERROR';
                
            END;

            BEGIN
                SELECT DD.BALANCE + DD.HOLDBALANCE - NVL(DDT.CI_TOTAL_MOVE_FRDT_AMT,0)
                INTO l_62M
                FROM DDMAST DD
                LEFT JOIN (
                    SELECT TR.DDACCTNO,
                    SUM(CASE WHEN TR.TXTYPE = 'D' THEN -TR.NAMT ELSE TR.NAMT END) CI_TOTAL_MOVE_FRDT_AMT
                    FROM
                    (
                        SELECT LOG.TXTYPE, LOG.NAMT, NVL(LOG.BUSDATE, LOG.TXDATE) BKDATE, LOG.ACCTNO DDACCTNO, LOG.FIELD
                        FROM VW_DDTRAN_GEN LOG, VW_TLLOG_ALL TL1,
                        (SELECT EN_TXDESC, TLTXCD, TXDESC CDCONTENT, EN_TXDESC EN_CDCONTENT FROM TLTX) TLTX
                        WHERE LOG.TLTXCD = TLTX.TLTXCD
                        AND LOG.TXDATE = TL1.TXDATE AND LOG.TXNUM = TL1.TXNUM
                        AND LOG.FIELD = 'BALANCE'
                        AND LOG.TXTYPE IN ('D','C')
                        AND LOG.DELTD = 'N'
                        AND LOG.NAMT <> 0
                        AND LOG.TLTXCD NOT IN ('6690', '6691', '6696', '6697', '6698', '6699', '6689', '6692', '6603', '6604')
                        AND LOG.TLTXCD NOT IN ('6628', '6629', '6615', '6659')
                        AND TL1.TLTXCD NOT IN ('1296')
                        AND NOT EXISTS (
                            SELECT 1 FROM VW_TLLOG_ALL TL2
                            WHERE TL2.TLTXCD IN ('6628', '6629', '6615', '6659')
                            AND TL2.TXDATE = TL1.TXDATE
                            AND TL2.REFTXNUM = TL1.TXNUM
                        )
                    ) TR
                    WHERE TR.BKDATE > P_DATE
                    GROUP BY TR.DDACCTNO
                ) DDT ON DD.ACCTNO = DDT.DDACCTNO
                WHERE DD.ACCTNO  = P_CUSTODYCD;
            EXCEPTION WHEN OTHERS THEN
                l_62M := 0;
                
            END;
        END IF;

        L_MT940_950_60F := 'C' || TO_CHAR(p_date,'rrmmdd') || l_VND || REPLACE(TO_CHAR(l_60M,'FM999999999999999990.999999'),'.',',');
        L_MT940_950_62F := 'C' || TO_CHAR(p_date,'rrmmdd') || l_VND || REPLACE(TO_CHAR(l_62M,'FM999999999999999990.999999'),'.',',');

        IF p_last = 'Y' AND l_pageNo = 0 THEN
            l_strMessage := ':60F:' || L_MT940_950_60F || '||' || l_strMessage || ':62F:' || L_MT940_950_62F || '||' || ':64:' || l_MT940_64;
        ELSIF p_last = 'Y' THEN
            l_strMessage := ':60M:' || L_MT940_950_60F || '||' || l_strMessage || ':62F:' || L_MT940_950_62F || '||' || ':64:' || l_MT940_64;
        ELSIF l_pageNo = 0 THEN
            l_strMessage := ':60F:' || L_MT940_950_60F || '||' || l_strMessage || ':62M:' || L_MT940_950_62F;
        ELSE
            l_strMessage := ':60M:' || L_MT940_950_60F || '||' || l_strMessage || ':62M:' || L_MT940_950_62F;
        END IF;
        p_60M := l_62M;

    END;
    ELSIF p_type = '950.STMT.MSG' THEN
    BEGIN
        l_strMessageTemp := ':61:<$STATEMENT>';

        BEGIN
            SELECT CCYCD INTO l_VND
            FROM ddmast dd
            WHERE dd.acctno  = p_custodycd;  --trung.luu:  11-01-2021  SHBVNEX-1889 MT940 MT950 sinh theo ddmast.acctno
        EXCEPTION WHEN OTHERS THEN
            l_VND := 'ERROR';
            
        END;
        BEGIN
            SELECT DD.BALANCE + DD.HOLDBALANCE - NVL(DDT.CI_TOTAL_MOVE_FRDT_AMT, 0)
            INTO L_60F
            FROM DDMAST DD
            LEFT JOIN (
                SELECT TR.DDACCTNO,
                SUM(CASE WHEN TR.TXTYPE = 'D' THEN -TR.NAMT ELSE TR.NAMT END) CI_TOTAL_MOVE_FRDT_AMT
                FROM
                (
                    SELECT LOG.TXTYPE, LOG.NAMT, NVL(LOG.BUSDATE, LOG.TXDATE) BKDATE, LOG.ACCTNO DDACCTNO, LOG.FIELD
                    FROM VW_DDTRAN_GEN LOG, VW_TLLOG_ALL TL1,
                    (SELECT EN_TXDESC, TLTXCD, TXDESC CDCONTENT, EN_TXDESC EN_CDCONTENT FROM TLTX) TLTX
                    WHERE LOG.TLTXCD = TLTX.TLTXCD
                    AND LOG.TXDATE = TL1.TXDATE AND LOG.TXNUM = TL1.TXNUM
                    AND LOG.FIELD = 'BALANCE'
                    AND LOG.TXTYPE IN ('D','C')
                    AND LOG.DELTD = 'N'
                    AND LOG.NAMT <> 0
                    AND LOG.TLTXCD NOT IN ('6690', '6691', '6696', '6697', '6698', '6699', '6689', '6692', '6603', '6604')
                    AND LOG.TLTXCD NOT IN ('6628', '6629', '6615', '6659')
                    AND TL1.TLTXCD NOT IN ('1296')
                    AND NOT EXISTS (
                        SELECT 1 FROM VW_TLLOG_ALL TL2
                        WHERE TL2.TLTXCD IN ('6628', '6629', '6615', '6659')
                        AND TL2.TXDATE = TL1.TXDATE
                        AND TL2.REFTXNUM = TL1.TXNUM
                    )
                ) TR
                WHERE TR.BKDATE >= P_DATE
                GROUP BY TR.DDACCTNO
            ) DDT ON DD.ACCTNO = DDT.DDACCTNO
            WHERE DD.ACCTNO  = P_CUSTODYCD; --TRUNG.LUU:  11-01-2021  SHBVNEX-1889 MT940 MT950 SINH THEO DDMAST.ACCTNO
        EXCEPTION WHEN OTHERS THEN
            l_60F := 0;
            
        END;

        IF p_60M = 0 OR p_60M IS NULL THEN
            l_60M := l_60F;
        ELSE
            l_60M := p_60M;
        END IF;
        l_62M := l_60F;

        FOR REC IN (
            SELECT *
            FROM (
                SELECT TBL.*, ROWNUM RN
                FROM (
                    SELECT CASE WHEN DDT.NAMT > 0 THEN 'C' ELSE 'D' END TXTYPE,
                         TO_CHAR(DDT.TXDATE, 'RRMMDD') TXDATE, DDT.TXNUM,
                         TRANSLATE(DDT.TXDESC, UTF8NUMS.C_FINDTEXT, UTF8NUMS.C_REPLTEXT) TXDESC,
                         SUBSTR(DD.CCYCD,3,1) CCYCD,
                         REPLACE(TO_CHAR(ABS(DDT.NAMT) ,'FM999999999999999990.999999'),'.',',') NAMT,
                         DDT.NAMT N_NAMT,
                         'FTRFNONREF//' || DDT.TXNUM REFVAL
                    FROM DDMAST DD
                    INNER JOIN (
                        SELECT LOG.ACCTNO,
                            SUM(DECODE(LOG.TXTYPE,'C',LOG.NAMT,-LOG.NAMT)) NAMT,
                            LOG.TXDATE, LOG.TXNUM, LOG.TLLOG_AUTOID,
                            MAX(NVL(LOG.TXDESC, TLTX.EN_TXDESC)) TXDESC
                        FROM VW_DDTRAN_GEN LOG, VW_TLLOG_ALL TL1,
                        (SELECT EN_TXDESC, TLTXCD, TXDESC CDCONTENT, EN_TXDESC EN_CDCONTENT FROM TLTX) TLTX
                        WHERE LOG.TLTXCD = TLTX.TLTXCD
                        AND LOG.TXDATE = TL1.TXDATE AND LOG.TXNUM = TL1.TXNUM
                        AND LOG.FIELD = 'BALANCE'
                        AND LOG.TXTYPE IN ('D','C')
                        AND LOG.DELTD = 'N'
                        AND LOG.NAMT <> 0
                        AND LOG.TLTXCD NOT IN ('6690', '6691', '6696', '6697', '6698', '6699', '6689', '6692', '6603', '6604')
                        AND LOG.TLTXCD NOT IN ('6628', '6629', '6615', '6659')
                        AND TL1.TLTXCD NOT IN ('1296')
                        AND NOT EXISTS (
                            SELECT 1 FROM VW_TLLOG_ALL TL2
                            WHERE TL2.TLTXCD IN ('6628', '6629', '6615', '6659')
                            AND TL2.TXDATE = TL1.TXDATE
                            AND TL2.REFTXNUM = TL1.TXNUM
                        )
                        AND NVL(LOG.BUSDATE, LOG.TXDATE) = P_DATE
                        GROUP BY LOG.ACCTNO, LOG.TXDATE, LOG.TXNUM, LOG.TLLOG_AUTOID
                    ) DDT ON DD.ACCTNO = DDT.ACCTNO
                    WHERE DD.STATUS <> 'C'
                    --AND DD.ISDEFAULT = 'Y'
                    AND DD.ACCTNO  = P_CUSTODYCD --TRUNG.LUU:  11-01-2021  SHBVNEX-1889 MT940 MT950 SINH THEO DDMAST.ACCTNO
                    ORDER BY DDT.TXDATE, DDT.TLLOG_AUTOID, DDT.TXNUM
                ) TBL
                WHERE ROWNUM <= P_FROMROW + P_ROWCOUNT + 1
            )
            WHERE RN >= P_FROMROW AND RN <= P_FROMROW + P_ROWCOUNT + 1
        ) LOOP
            l_count := l_count + 1;
            IF l_count > p_rowCount THEN
                p_last := 'N';
                EXIT ;
            END IF;

            l_62M := l_62M + rec.n_namt;

            l_strMessageBuild := l_strMessageTemp;
            l_strMessageBuild := REPLACE(l_strMessageBuild,'<$STATEMENT>', rec.txdate || rec.txtype || rec.ccycd || rec.namt || rec.refval);

            IF l_strMessage IS NULL OR length(l_strMessage) = 0 THEN
                l_strMessage := l_strMessageBuild;
            ELSE
                l_strMessage := l_strMessage || '||' || l_strMessageBuild;
            END IF;
        END LOOP;

        IF l_strMessage IS NOT NULL AND length(l_strMessage) > 0 THEN
          l_strMessage := l_strMessage || '||';
        END IF;

        IF p_last = 'Y' THEN
            BEGIN
                SELECT DD.BALANCE + DD.HOLDBALANCE - NVL(DDT.CI_TOTAL_MOVE_FRDT_AMT,0)
                INTO l_62M
                FROM DDMAST DD
                LEFT JOIN (
                    SELECT TR.DDACCTNO,
                    SUM(CASE WHEN TR.TXTYPE = 'D' THEN -TR.NAMT ELSE TR.NAMT END) CI_TOTAL_MOVE_FRDT_AMT
                    FROM
                    (
                        SELECT LOG.TXTYPE, LOG.NAMT, NVL(LOG.BUSDATE, LOG.TXDATE) BKDATE, LOG.ACCTNO DDACCTNO, LOG.FIELD
                        FROM VW_DDTRAN_GEN LOG, VW_TLLOG_ALL TL1,
                        (SELECT EN_TXDESC, TLTXCD, TXDESC CDCONTENT, EN_TXDESC EN_CDCONTENT FROM TLTX) TLTX
                        WHERE LOG.TLTXCD = TLTX.TLTXCD
                        AND LOG.TXDATE = TL1.TXDATE AND LOG.TXNUM = TL1.TXNUM
                        AND LOG.FIELD = 'BALANCE'
                        AND LOG.TXTYPE IN ('D','C')
                        AND LOG.DELTD = 'N'
                        AND LOG.NAMT <> 0
                        AND LOG.TLTXCD NOT IN ('6690', '6691', '6696', '6697', '6698', '6699', '6689', '6692', '6603', '6604')
                        AND LOG.TLTXCD NOT IN ('6628', '6629', '6615', '6659')
                        AND TL1.TLTXCD NOT IN ('1296')
                        AND NOT EXISTS (
                            SELECT 1 FROM VW_TLLOG_ALL TL2
                            WHERE TL2.TLTXCD IN ('6628', '6629', '6615', '6659')
                            AND TL2.TXDATE = TL1.TXDATE
                            AND TL2.REFTXNUM = TL1.TXNUM
                        )
                    ) TR
                    WHERE TR.BKDATE > P_DATE
                    GROUP BY TR.DDACCTNO
                ) DDT ON DD.ACCTNO = DDT.DDACCTNO
                WHERE DD.ACCTNO  = P_CUSTODYCD;
            EXCEPTION WHEN OTHERS THEN
                l_62M := 0;
                
            END;
        END IF;

        L_MT940_950_60F := 'C' || TO_CHAR(p_date,'rrmmdd') || l_VND || REPLACE(TO_CHAR(l_60M,'FM999999999999999990.999999'),'.',',');
        L_MT940_950_62F := 'C' || TO_CHAR(p_date,'rrmmdd') || l_VND || REPLACE(TO_CHAR(l_62M,'FM999999999999999990.999999'),'.',',');

        IF p_last = 'Y' AND l_pageNo = 0 THEN
            l_strMessage := ':60F:' || L_MT940_950_60F || '||' || l_strMessage || ':62F:' || L_MT940_950_62F;
        ELSIF p_last = 'Y' THEN
            l_strMessage := ':60M:' || L_MT940_950_60F || '||' || l_strMessage || ':62F:' || L_MT940_950_62F;
        ELSIF l_pageNo = 0 THEN
            l_strMessage := ':60F:' || L_MT940_950_60F || '||' || l_strMessage || ':62M:' || L_MT940_950_62F;
        ELSE
            l_strMessage := ':60M:' || L_MT940_950_60F || '||' || l_strMessage || ':62M:' || L_MT940_950_62F;
        END IF;
        p_60M := l_62M;
    END;
    END IF;
  RETURN l_strMessage;
EXCEPTION
  WHEN OTHERS THEN
    
    RETURN 'ERROR';
end fn_gen_fin_report;
/
