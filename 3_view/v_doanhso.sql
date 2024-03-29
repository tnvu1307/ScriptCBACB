SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW V_DOANHSO
(SAN, LOAI, GTKHOP)
AS 
SELECT CASE B.TRADEPLACE WHEN '001' THEN 'HCM' WHEN '002' THEN 'HNX' WHEN '005' THEN 'UPCOM' ELSE B.TRADEPLACE END San, 
      DECODE(SUBSTR(A.EXECTYPE, 2,1),'B', 'Mua', 'Ban') Loai, SUM(A.execamt) GTKhop
  FROM ODMAST A, SBSECURITIES B
  WHERE EXECQTTY <> 0 AND A.CODEID = B.CODEID
      AND A.TXDATE = TRUNC(SYSDATE)
      and a.afacctno not in ('0001920070','0011017017')
  GROUP BY  B.TRADEPLACE, SUBSTR(A.EXECTYPE, 2,1)
  ORDER BY  B.TRADEPLACE, SUBSTR(A.EXECTYPE, 2,1)
/
