SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf0034 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   INMONTH        IN       VARCHAR2,
   TAXTYPE        IN       VARCHAR2,
   ISBANKING      in       varchar2
    )
IS
--
-- PURPOSE: BANG KE CHI TIET GIA TRI CHUYEN NHUONG VA THUE TNCN
-- PERSON      DATE    COMMENTS
-- THANHNM    05-03-2012  CREATE

-- ---------   ------  -------------------------------------------

    CUR             PKG_REPORT.REF_CURSOR;
    V_STROPT    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);
    V_TAXTYPE   VARCHAR2 (3);
    V_ISBANKING varchar2(3);
    V_INMONTH   VARCHAR2(2);
    V_INYEAR    VARCHAR2(4);
    V_F_DATE    DATE;
    V_T_DATE    DATE;
    V_TAXTYPE_DES varchar2 (50);
    V_INBRID       VARCHAR2 (5);
BEGIN
 -- GET REPORT'S PARAMETERS

   V_TAXTYPE:=TAXTYPE;

   IF ISBANKING ='ALL' THEN
     V_ISBANKING :='%%';
   ELSE
     V_ISBANKING:=ISBANKING;
   END IF;

/*
   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;*/
 V_STROPT := upper(OPT);
    V_INBRID := BRID;
    if(V_STROPT = 'A') then
        V_STRBRID := '%';
    else
        if(V_STROPT = 'B') then
            --select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
            V_STRBRID := substr(BRID,1,2) || '__' ;
        else
            V_STRBRID := BRID;
        end if;
    end if;

    IF TO_NUMBER(SUBSTR(INMONTH,1,2)) <= 12 THEN
        V_F_DATE := TO_DATE('01/' || SUBSTR(INMONTH,1,2) || '/' || SUBSTR(INMONTH,3,4),'DD/MM/YYYY');
    ELSE
        V_F_DATE := TO_DATE('31/12/9999','DD/MM/YYYY');
    END IF;
    V_T_DATE := LAST_DAY(V_F_DATE);
    V_INMONTH := SUBSTR(INMONTH,1,2);
    V_INYEAR :=  SUBSTR(INMONTH,3,4);

   --Get taxtype
    SELECT CDCONTENT into V_TAXTYPE_DES  FROM ALLCODE WHERE CDNAME ='TAXTYPE' AND CDTYPE='SA' AND CDVAL = TAXTYPE;

-- GET DATA
OPEN PV_REFCURSOR
   FOR

   SELECT ISBANKING BANK_DES,V_TAXTYPE_DES TAXTYPE,INMONTH IN_M , FULLNAME, IDCODE, IDTYPE,IDDATE, IDPLACE, CUSTODYCD, TAXCODE,
   decode(CTYPE,'C','TN','P','TD','F','NN') CTYPE ,SUM(EXECAMT) MATCHAMT, SUM(TAXSELLAMT) TAXSELLAMT
    FROM
   (
   --LAY SO LUONG TIEN BAN CHUNG KHOAN TRONG THANG
   SELECT CF.FULLNAME, CF.IDCODE, CF.IDTYPE, CF.IDDATE, CF.IDPLACE, CF.CUSTODYCD, CF.TAXCODE,
   MAX(SUBSTR(CF.CUSTODYCD,4,1)) CTYPE, -- MAX(CF.ISBANKING) ISBANKING,
   DECODE (V_TAXTYPE,'002',0, SUM(OD.EXECAMT)) EXECAMT,
   DECODE (V_TAXTYPE,'002',0, SUM(OD.TAXSELLAMT)) TAXSELLAMT
   FROM
   (SELECT AFACCTNO, SUM(EXECAMT) EXECAMT, SUM(TAXSELLAMT) TAXSELLAMT FROM
     (
       SELECT OD.AFACCTNO,OD.EXECAMT,(OD.EXECAMT * NVL((SELECT TO_NUMBER(VARVALUE)
                     FROM SYSVAR WHERE VARNAME = 'ADVSELLDUTY' AND GRNAME = 'SYSTEM'),0)/100) /*+ ST.ARIGHT*/ TAXSELLAMT
       FROM ODMAST OD, STSCHD ST WHERE OD.ORDERID = ST.orgorderid AND ST.DELTD='N' AND ST.DUETYPE='RM'
       AND OD.DELTD ='N' AND OD.EXECTYPE IN('NS','SS','MS') AND OD.EXECAMT>0
       AND ST.CLEARDATE >= V_F_DATE AND ST.CLEARDATE <= V_T_DATE

       UNION ALL
          SELECT OD.AFACCTNO,OD.EXECAMT, OD.TAXSELLAMT /*+ ST.ARIGHT*/ TAXSELLAMT FROM ODMASTHIST OD, STSCHDHIST ST
           WHERE OD.ORDERID = ST.orgorderid AND ST.DELTD='N' AND ST.DUETYPE='RM'
       AND OD.DELTD ='N' AND OD.EXECTYPE IN('NS','SS','MS') AND OD.EXECAMT>0
       AND ST.CLEARDATE >= V_F_DATE AND ST.CLEARDATE <= V_T_DATE

      ) OD GROUP BY OD.AFACCTNO ) OD ,
   CFMAST CF, AFMAST AF
   WHERE CF.CUSTID = AF.CUSTID AND OD.AFACCTNO = AF.ACCTNO and CF.ISBANKING like  V_ISBANKING
   and cf.brid like V_STRBRID
   GROUP BY CF.FULLNAME, CF.IDCODE, CF.IDTYPE, CF.IDDATE, CF.IDPLACE, CF.CUSTODYCD, CF.TAXCODE

   --LAY SO LUONG TIEN THU NHAP TU CO TUC
   UNION ALL
   SELECT  CF.FULLNAME, CF.IDCODE, CF.IDTYPE, CF.IDDATE, CF.IDPLACE, CF.CUSTODYCD, CF.TAXCODE,
   MAX(SUBSTR(CF.CUSTODYCD,4,1)) CTYPE,   --MAX(CF.ISBANKING) ISBANKING,
   DECODE (V_TAXTYPE,'001',0, SUM(TL.EXECAMT)) EXECAMT,
   DECODE (V_TAXTYPE,'001',0, SUM(TL.TAXSELLAMT)) TAXSELLAMT
   FROM
   (SELECT TL.MSGACCT, SUM(CI2.NAMT) EXECAMT, SUM(CI.NAMT) TAXSELLAMT
     FROM
        (
        SELECT  TXNUM ,TXDATE ,MSGACCT, TXDESC   FROM TLLOG WHERE TLTXCD='3350'    AND DELTD  <>'Y'
        AND BUSDATE >= V_F_DATE AND BUSDATE <= V_T_DATE
        UNION ALL
        SELECT  TXNUM ,TXDATE ,MSGACCT, TXDESC  FROM TLLOGALL WHERE TLTXCD='3350'  AND DELTD  <>'Y'
        AND BUSDATE >= V_F_DATE AND BUSDATE <= V_T_DATE
        ) TL ,
        (
        SELECT  TXNUM ,TXDATE , NAMT FROM DDTRAN  WHERE TXCD ='0011' AND DELTD <>'Y'
         AND BKDATE >= V_F_DATE AND BKDATE <= V_T_DATE
        UNION ALL
        SELECT  TXNUM ,TXDATE , NAMT FROM DDTRANA WHERE  TXCD ='0011'  AND DELTD <>'Y'
         AND BKDATE >= V_F_DATE AND BKDATE <= V_T_DATE
        ) CI,
           (
        SELECT  TXNUM ,TXDATE , NAMT FROM DDTRAN  WHERE TXCD ='0012' AND DELTD <>'Y'
         AND BKDATE >= V_F_DATE AND BKDATE <= V_T_DATE
        UNION ALL
        SELECT  TXNUM ,TXDATE , NAMT FROM DDTRANA WHERE  TXCD ='0012'  AND DELTD <>'Y'
         AND BKDATE >= V_F_DATE AND BKDATE <= V_T_DATE
        ) CI2
     WHERE  TL.TXNUM = CI.TXNUM
          AND    TL.TXDATE = CI.TXDATE
          AND    TL.TXNUM = CI2.TXNUM
          AND    TL.TXDATE = CI2.TXDATE
          GROUP BY TL.MSGACCT
     ) TL, CFMAST CF, AFMAST AF
   WHERE CF.CUSTID = AF.CUSTID AND TL.MSGACCT = AF.ACCTNO and CF.ISBANKING like  V_ISBANKING
   and cf.brid like V_STRBRID
   GROUP BY CF.FULLNAME, CF.IDCODE, CF.IDTYPE, CF.IDDATE, CF.IDPLACE, CF.CUSTODYCD, CF.TAXCODE
   )
   WHERE 0=0
   GROUP BY FULLNAME, IDCODE, IDTYPE,IDDATE, IDPLACE, CUSTODYCD, TAXCODE,
   CTYPE HAVING SUM(EXECAMT)  + SUM(TAXSELLAMT) >0

     ;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/
