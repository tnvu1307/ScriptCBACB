SET DEFINE OFF;
CREATE OR REPLACE FUNCTION calc_se_amt (p_clause   varchar2)
return VARCHAR2 is
  l_return NUMBER := 0;
  l_date   DATE;
  l_custodycd VARCHAR2(10);
  l_exrate      NUMBER;
  l_custid      cfmast.custid%TYPE;
  l_ccycd       VARCHAR2(3) := 'VND';
begin
  l_date := TO_DATE(substr(p_clause, 1, 10), 'dd/mm/rrrr');
  l_custodycd := substr(p_clause, 11);
  SELECT custid INTO l_custid FROM cfmast WHERE custodycd = l_custodycd;
  l_exrate := getExchangeRateAll (p_rtype     => 'TTM',
                                  p_currency  => l_ccycd,
                                  p_itype     => 'SHV',
                                  p_tradedate => l_date);

  SELECT ROUND(SUM((MST.TRADE + MST.HOLD + MST.MORTAGE + MST.NETTING + MST.BLOCKED + MST.WITHDRAW + MST.BLOCKWITHDRAW + MST.EMKQTTY - NVL(se.namt,0)) * NVL(pr.avgprice, 0) / l_exrate), 2) INTO l_return
  FROM semast mst
  LEFT JOIN (SELECT se.acctno,
                    SUM(decode(se.txcd, 'C', se.namt, -se.namt)) namt
             FROM vw_setran_gen se
             WHERE se.custid = l_custid AND se.txdate > l_date
             AND se.field IN ('TRADE','HOLD','MORTAGE','NETTING','BLOCKED','WITHDRAW','BLOCKWITHDRAW','EMKQTTY')
             AND se.txcd IN ('C','D') AND se.deltd <> 'Y'
             GROUP BY se.acctno) se ON mst.acctno = se.acctno
  LEFT JOIN (SELECT codeid, avgprice FROM vw_securities_info_hist WHERE histdate = l_date) pr ON pr.codeid = mst.codeid
  WHERE mst.custid = l_custid;


  RETURN l_ccycd || REPLACE(TO_CHAR(NVL(l_return,'0'),'FM999999999999990.999999'),'.',',');
EXCEPTION
  WHEN OTHERS THEN
    RETURN l_ccycd || l_return;
end CALC_SE_AMT;
/
