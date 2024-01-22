SET DEFINE OFF;
CREATE OR REPLACE function check_exist_setran(p_clause   varchar2)
return VARCHAR2 is
  l_return NUMBER := 0;
  l_date   DATE;
  l_custodycd VARCHAR2(10);
  l_exrate      NUMBER;
  l_custid      cfmast.custid%TYPE;
begin
  l_date := TO_DATE(substr(p_clause, 1, 10), 'dd/mm/rrrr');
  l_custodycd := substr(p_clause, 11);

  SELECT COUNT(1) INTO l_return
  FROM vw_setran_gen se, sbsecurities sb, sbsecurities sb2
  WHERE se.custodycd = l_date
  AND se.field IN ('TRADE','BLOCKED','NETTING','DTOCLOSE','BLOCKDTOCLOSE','WITHDRAW','TRANSFER','BLOCKTRANFER')
  AND se.txtype IN ('C', 'D')
  AND se.txdate = l_date
  AND se.codeid = sb.codeid AND sb.refcodeid = sb2.codeid(+)
  AND (CASE WHEN se.field = 'TRADE' AND se.sectype NOT IN ('004') AND se.tltxcd NOT IN ('3356','2263','2202','2203') AND txtype IN ('C') THEN 1
            WHEN se.field = 'TRADE' AND se.sectype = '004' AND se.tltxcd IN ('3375','3385','3386') AND se.txtype = 'C' THEN 1
            WHEN se.field = 'TRADE' AND se.sectype = '004' AND se.tltxcd NOT IN ('3376','3337','3384','3333') AND se.txtype = 'D' THEN 1
            WHEN se.field = 'BLOCKED' AND se.tltxcd NOT IN ('3356','2263','2202','2203') AND txtype IN ('C') THEN 1
            WHEN se.field IN ('TRADE','BLOCKED') AND txtype IN ('C') THEN 1
            WHEN se.field IN ('NETTING','DTOCLOSE','BLOCKDTOCLOSE','WITHDRAW','TRANSFER','BLOCKTRANFER') AND se.txtype = 'D' THEN 1
            ELSE 0 END) = 1
  AND (txnum,txdate) NOT IN (SELECT txnum,txdate FROM vw_setran_gen
                             WHERE txdate = l_date
                             AND field IN ('EMKQTTY','MORTAGE'))
  ORDER BY NVL(sb2.symbol, sb.symbol), se.autoid
;

  RETURN NVL(l_return, 0);
EXCEPTION
  WHEN OTHERS THEN
    RETURN l_return;
end check_exist_setran;

/
