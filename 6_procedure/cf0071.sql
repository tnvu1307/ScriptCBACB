SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf0071 (
   PV_REFCURSOR     IN OUT   PKG_REPORT.REF_CURSOR,
   OPT              IN       VARCHAR2,
   BRID             IN       VARCHAR2,
   PV_CUSTODYCD     IN       VARCHAR2,
   PV_AFACCTNO      IN       VARCHAR2
)
IS

    V_BRID          VARCHAR2(4);
    V_STROPTION     VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID        VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
    V_INBRID         VARCHAR2 (5);
    V_IDATE         DATE;
    V_CUSTODYCD     varchar2(10);
    v_COUNT         number;

    V_STRAFACCTNO   varchar2(10);

BEGIN

   V_STROPTION := upper(OPT);
   V_INBRID := BRID;
   v_COUNT :=0;

   if(V_STROPTION = 'A') then
        V_STRBRID := '%';
    else
        if(V_STROPTION = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := BRID;
        end if;
    end if;
   SELECT TO_DATE(varvalue,'DD/MM/RRRR') INTO V_IDATE FROM SYSVAR WHERE VARNAME = 'CURRDATE'
    AND GRNAME = 'SYSTEM';

   V_CUSTODYCD := upper(PV_CUSTODYCD);
   IF(UPPER(PV_AFACCTNO) = 'ALL') THEN
    V_STRAFACCTNO := '%';
   ELSE
       V_STRAFACCTNO := PV_AFACCTNO;
   END IF;

OPEN PV_REFCURSOR FOR
        SELECT UPPER(PV_AFACCTNO) AFACCTNO, A.CATYPENAME, A.SYMBOL, A.DEVIDENTSHARES, A.DEVIDENTRATE, A.RIGHTOFFRATE, A.EXPRICE, A.INTERESTRATE,
            A.CATYPE, A.REPORTDATE, A.EXRATE ,
            SUM(TRADE) TRADE, SUM(AMT) AMT, SUM(QTTY) QTTY, SUM(RQTTY) RQTTY, SUM(PBALANCE) PBALANCE,
            SUM(BALANCE) BALANCE, A.TRADEPLACE
        FROM
        (
            SELECT CAS.CAMASTID,CAS.BALANCE, CAS.PBALANCE, CAS.RQTTY, CAS.QTTY, CAS.AMT, CAS.TRADE,
                CA.CATYPE , CA.REPORTDATE, CA.EXRATE,CA.INTERESTRATE, CA.EXPRICE, CA.RIGHTOFFRATE,
                CASE WHEN CA.CATYPE='010' AND CA.DEVIDENTRATE=0 THEN TO_CHAR(CA.DEVIDENTVALUE) ELSE CA.DEVIDENTRATE END DEVIDENTRATE,
                CA.DEVIDENTSHARES , SB.SYMBOL, A1.CDCONTENT TRADEPLACE,
                CASE WHEN CA.CATYPE = '011' THEN utf8nums.c_const_ca_rightname_a -- 'A. QUY?N NH?N C? T?C B?NG C? PHI?U'
                     WHEN CA.CATYPE = '010' THEN utf8nums.c_const_ca_rightname_c -- 'C. QUY?N NH?N C? T?C B?NG TI?N'
                     WHEN CA.CATYPE = '021' THEN utf8nums.c_const_ca_rightname_b -- 'B. QUY?N C? PHI?U THU?NG'
                     WHEN CA.CATYPE = '014' THEN utf8nums.c_const_ca_rightname_d -- 'D. QUY?N MUA'
                     WHEN CA.CATYPE = '020' THEN utf8nums.c_const_ca_rightname_e -- 'E. QUY?N HO?N ?I C? PHI?U'
                     WHEN CA.CATYPE in ('017','023') THEN utf8nums.c_const_ca_rightname_f --'F. QUY?N CHUY?N ?I TR?I PHI?U'
                     WHEN CA.CATYPE IN ('022','005','006') THEN utf8nums.c_const_ca_rightname_g --'G. QUY?N BI?U QUY?T'
                     ELSE '999' --'H. QUY?N KH?C'
                end CATYPENAME,
                CASE WHEN CA.CATYPE IN ('011','021') THEN 1
                     WHEN CA.CATYPE IN ('010') THEN 2
                     WHEN CA.CATYPE IN ('014') THEN 3
                     WHEN CA.CATYPE IN ('020') THEN 4
                     WHEN CA.CATYPE IN ('017','023') THEN 5
                     WHEN CA.CATYPE IN ('022','005','006')  THEN 6 ELSE 7
                END CA_GROUP
            FROM CASCHD CAS, CAMAST CA, SBSECURITIES SB, ALLCODE A1, ALLCODE A2, AFMAST AF, CFMAST CF
            WHERE CAS.CAMASTID = CA.CAMASTID AND CAS.CODEID=SB.CODEID AND CAS.AFACCTNO = AF.ACCTNO
            AND AF.CUSTID= CF.CUSTID
            AND A1.CDNAME='TRADEPLACE' AND A1.CDTYPE='SE' AND A1.CDVAL=SB.TRADEPLACE
            AND A2.CDNAME='CATYPE' AND A2.CDTYPE='CA' AND CA.CATYPE = A2.CDVAL
            AND cf.custodycd  = V_CUSTODYCD
            AND AF.ACCTNO LIKE V_STRAFACCTNO
            ---AND AF.STATUS='N'
            AND CAS.DELTD <> 'Y'
            AND (CASE WHEN CAS.STATUS IN ('C','J') THEN 0 ELSE 1 END) > 0
        ) A
        GROUP BY A.CATYPENAME, A.SYMBOL, A.DEVIDENTSHARES, A.DEVIDENTRATE, A.RIGHTOFFRATE, A.EXPRICE, A.INTERESTRATE,
            A.CATYPE, A.REPORTDATE, A.EXRATE, A.TRADEPLACE
        ORDER BY A.CATYPENAME
        ;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;

 
 
 
 
 
 
 
 
 
 
/
