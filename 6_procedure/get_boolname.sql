SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE Get_BoolName  (
    p_prname IN OUT VARCHAR2,
    p_prlimit IN OUT NUMBER
)
IS
    p_prcode NUMBER;
    p_prinused NUMBER;
    p_prtype VARCHAR2(5);
    p_symbol VARCHAR2(5);
    p_rprstatus VARCHAR2(100);
    p_prsecured NUMBER;
    p_pravllimit NUMBER;
    p_expireddt date;
    p_aprallow VARCHAR2 (1);
    p_prstatus VARCHAR2 (1);
BEGIN
    BEGIN
        SELECT MST.PRCODE, MST.PRNAME, A0.CDCONTENT , SB.SYMBOL, A1.CDCONTENT , MST.PRLIMIT,
                NVL(MST.PRINUSED,0) + NVL(prlog.prinused,0) , NVL(prlog.prinused,0) , GREATEST(MST.PRLIMIT - NVL(MST.PRINUSED,0) - NVL(prlog.prinused,0),0) , MST.EXPIREDDT,
                (CASE WHEN PRSTATUS IN ('P') THEN 'Y' ELSE 'N' END) ,MST.PRSTATUS
        INTO p_prcode,p_prname, p_prtype,p_symbol,p_rprstatus,p_prlimit,p_prinused,p_prsecured,p_pravllimit,p_expireddt,p_aprallow,p_prstatus
        FROM PRMASTER MST,
             (SELECT CODEID, SYMBOL FROM SBSECURITIES UNION ALL SELECT CCYCD CODEID, SHORTCD SYMBOL FROM SBCURRENCY) SB,
             ALLCODE A0,
             ALLCODE A1,
             (select prcode, sum(prinused) prinused from prinusedlog where deltd <> 'Y' group by prcode) prlog
        WHERE MST.CODEID=SB.CODEID(+) AND A0.CDTYPE='SY'
             AND A0.CDNAME='PRTYPE' AND A0.CDVAL=MST.PRTYP
             AND A1.CDTYPE='SY' AND A1.CDNAME='PRSTATUS' AND A1.CDVAL=MST.PRSTATUS
             and mst.prcode = prlog.prcode(+) and nvl(ROOMTYP, ' ')<>'SPR'
             and MST.PRNAME = p_prname;
        EXCEPTION WHEN OTHERS THEN
             p_prcode := '';
    END;

    IF p_prlimit <> '0' THEN
       UPDATE PRMASTER
       SET PRLIMIT = p_prlimit
       WHERE PRNAME = p_prname;
    END IF;

EXCEPTION WHEN OTHERS THEN
      plog.error (p_prtype||':'||p_prlimit);
  END Get_BoolName;
 
 
/
