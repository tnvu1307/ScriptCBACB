SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE ba6004 (
   PV_REFCURSOR IN  OUT PKG_REPORT.REF_CURSOR,
   OPT          IN  VARCHAR2,
   BRID         IN  VARCHAR2,
   IDATE        IN  VARCHAR2,
   PV_TCPH      IN  VARCHAR2,
   PV_SYMBOL    IN  VARCHAR2,
   I_PAYDATE    IN  VARCHAR2
)
IS
   V_SYMBOL         VARCHAR2 (20);
   V_ISSUER         VARCHAR2 (30);
   V_IDATE          DATE;
   V_PAYMENTDATE    DATE;
   l_prev_paidDate  DATE;
   V_STROPTION      VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID        VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0
    ---
  L_LTP VARCHAR2(1000);
  L_GLTP  VARCHAR2(1000);
  L_TTLTP VARCHAR2(1000);
  L_TTGLTP VARCHAR2(1000);
  L_MLTP  VARCHAR2(1000);
  L_DK  VARCHAR2(1000);
  L_TT  VARCHAR2(1000);
  L_D  VARCHAR2(1000);
BEGIN

    V_STROPTION := OPT;
    IF V_STROPTION = 'A' THEN
        V_STRBRID := '%';
    ELSIF V_STROPTION = 'B' THEN
        V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
    ELSE
        V_STRBRID:= BRID;
    END IF;
--------------------------------------------

         V_ISSUER := PV_TCPH;

--------------------------------------------
    IF PV_SYMBOL = 'ALL' THEN
        V_SYMBOL := '%';
    ELSE
         V_SYMBOL := PV_SYMBOL;
    END IF;

 --------------------------------------------
        V_IDATE    :=     TO_DATE(IDATE, SYSTEMNUMS.C_DATE_FORMAT);
        V_PAYMENTDATE    :=     TO_DATE(I_PAYDATE, SYSTEMNUMS.C_DATE_FORMAT);
    --
    SELECT MAX("'LTP'"),MAX("'GLTP'"),MAX("'TTLTP'"),MAX("'TTGLTP'"),MAX("'MLTP'"),MAX("'DK'"),MAX("'TT'"),MAX("'D'")
    INTO L_LTP,L_GLTP,L_TTLTP,L_TTGLTP,L_MLTP,L_DK,L_TT,L_D
    FROM (
    SELECT *
    FROM ALLCODE
    WHERE CDNAME ='EM14'
        )
    PIVOT
    (
    MAX(CDCONTENT)
    FOR CDVAL IN ('LTP','GLTP','TTLTP','TTGLTP','MLTP','DK','TT','D')
    )
    GROUP BY CDNAME ;
   /* --
        SELECT MAX(bt.paymentdate) INTO l_prev_paidDate
    FROM bondtypepay bt,  sbsecurities sb
    WHERE bt.bondcode = sb.codeid
    AND sb.symbol = V_SYMBOL AND bt.paymentdate < TO_DATE(V_PAYMENTDATE, 'DD/MM/RRRR');

    IF l_prev_paidDate IS NULL THEN
      SELECT s.issuedate
      INTO l_prev_paidDate
      FROM sbsecurities s
      WHERE s.symbol = V_SYMBOL;
    END IF;*/
 OPEN PV_REFCURSOR
 FOR
SELECT DISTINCT TO_CHAR(sb.ISSUEDATE, 'DD/MM/RRRR') CONTRACTDATE, to_char(sb.expdate,'DD/MM/RRRR')expdate,
            trim(to_char(sb.VALUEOFISSUE, '9,999,999,999,999,999,999,999')) VALUEOFISSUE,
            utils.fnc_number2vie(sb.VALUEOFISSUE) strvalue, Lower(al.cdcontent) periodinterest, sb.intcoupon,
           iss.Fullname BONDNAME, to_char(fn_get_prevdate(bt.paymentdate, 2),'DD/MM/RRRR') senddate,
           TO_CHAR(NVL(bt.BEGINDATE,sb.issuedate), 'DD/MM/RRRR') prevpaidDate,
           sb.symbol,to_char(bt.paymentdate,'DD/MM/RRRR') paymentdate,
           MONTHS_BETWEEN(TO_DATE(TO_CHAR(bt.PAYMENTDATE,'MM/RRRR'),'MM/RRRR'),TO_DATE(TO_CHAR(NVL(bt.BEGINDATE,sb.issuedate),'MM/RRRR'),'MM/RRRR')) Countmonth,
           case  when ca.catype ='015' then L_LTP else L_GLTP end gltpp,
           case
                 when ca.catype ='015' then L_TTLTP
                 when ca.catype ='016' then L_TTGLTP
                 else L_MLTP
           end ||sb.symbol||L_DK||MONTHS_BETWEEN(TO_DATE(TO_CHAR(bt.PAYMENTDATE,'MM/RRRR'),'MM/RRRR'),TO_DATE(TO_CHAR(NVL(bt.BEGINDATE,sb.issuedate),'MM/RRRR'),'MM/RRRR')) ||L_TT||TO_CHAR(NVL(bt.BEGINDATE,sb.issuedate),'DD/MM/RRRR')||L_D||TO_CHAR(bt.PAYMENTDATE,'DD/MM/RRRR') DESCRIP
    FROM issuers iss, bondtypepay bt, sbsecurities sb, allcode al, bondcaschd bo, camast ca,
    (SELECT sb.symbol,MAX(bt.paymentdate) paidDate
    FROM bondtypepay bt,  sbsecurities sb
    WHERE bt.bondcode = sb.codeid
    AND sb.symbol like V_SYMBOL AND bt.paymentdate < TO_DATE(V_PAYMENTDATE, 'DD/MM/RRRR')
    group by sb.symbol) PRP
    WHERE bt.bondcode = sb.codeid
        AND sb.issuerid = iss.issuerid
        and al.cdname='PERIODINTEREST'
        and sb.periodinterest = al.cdval (+)
        and bt.autoid = bo.periodinterest
        and bo.camastid = ca.camastid
        and bT.BONDSYMBOL = prp.symbol (+)
        and bT.BONDSYMBOL like V_SYMBOL
        AND BT.PAYMENTDATE = TO_DATE(V_PAYMENTDATE, 'DD/MM/RRRR')
        ;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/
