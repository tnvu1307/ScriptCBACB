SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_check_exists_stock(p_clause  VARCHAR2) RETURN NUMBER IS
  l_return NUMBER;
  l_date   DATE;
  l_custodycd VARCHAR2(100);
BEGIN
  l_date := TO_DATE(substr(p_clause, 1, 10), 'dd/MM/RRRR');
  l_custodycd := substr(p_clause, 11);

  SELECT COUNT(1) INTO l_return
  FROM (
          SELECT --MAX(REPLACE(sb.symbol,'_WTF','')) SYMBOL,
                 MAX(NVL(s1.isincode, s.isincode)) isincode,
                 MAX(sb.AVGPRICE) AVGPRICE,
                 SUM(DECODE(NVL(s.refcodeid,'x'),'x',mst.trade,0) - NVL(se.namt_trade, 0)) trade,
                 SUM(MST.TRADE + MST.HOLD + MST.MORTAGE + MST.NETTING + MST.BLOCKED + MST.WITHDRAW + MST.BLOCKWITHDRAW + MST.EMKQTTY - NVL(SE.NAMT,0)) total
          FROM cfmast cf, semast mst
          LEFT JOIN (SELECT se.acctno,
                             sum(decode(se.txcd, 'C', namt, -namt)) namt,
                             sum(CASE WHEN se.field='TRADE' AND instr(se.symbol, '_WFT')=0 THEN decode(se.txcd, 'C', namt, -namt) ELSE 0 END) namt_trade
                      FROM vw_setran_gen se
                      WHERE se.custodycd = l_custodycd AND se.BUSDATE > l_date
                      AND se.txcd IN ('C','D') AND se.deltd <> 'Y'
                      AND se.field IN ('TRADE','HOLD','MORTAGE','NETTING','BLOCKED','WITHDRAW','BLOCKWITHDRAW','EMKQTTY')
                      GROUP BY se.acctno
          ) se ON mst.acctno = se.acctno
          INNER JOIN vw_securities_info_hist sb ON sb.CODEID = mst.codeid AND sb.HISTDATE = l_date
          INNER JOIN sbsecurities s ON mst.codeid = s.codeid
          LEFT JOIN sbsecurities s1 ON s.refcodeid = s1.codeid
          WHERE mst.custid = cf.custid AND cf.custodycd = l_custodycd
          AND (MST.TRADE + MST.HOLD + MST.MORTAGE + MST.NETTING + MST.BLOCKED + MST.WITHDRAW + MST.BLOCKWITHDRAW + MST.EMKQTTY - NVL(SE.NAMT,0)) > 0
          GROUP BY cf.custid, NVL(s.refcodeid, s.codeid)
          ORDER BY NVL(s.refcodeid, s.codeid)
   );


  RETURN l_return;
EXCEPTION
  WHEN OTHERS THEN
    plog.error('fn_check_exists_stock::p_clause=[' || p_clause || '] Err: ' || SQLERRM);
END fn_check_exists_stock;
/
