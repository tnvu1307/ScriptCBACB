SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE ca0069 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   --F_DATE         IN       VARCHAR2,
   --T_DATE         IN       VARCHAR2,
   P_CACODE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2
   )
IS
--
-- PURPOSE: THONG BAO V/V SO HUU QUYEN MUA CK
-- PERSON      DATE    COMMENTS
-- TRUONGLD   27-03-10  CREATE
-- MODIFY QUYET.KIEU 08-03-2011
-- MODIFY hien.vu    24-05-2011
-- ---------   ------  -------------------------------------------

    CUR             PKG_REPORT.REF_CURSOR;
    V_STROPTION         VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID           VARCHAR2 (60);            -- USED WHEN V_NUMOPTION > 0
    V_INBRID            VARCHAR2 (5);
    V_STRAFACCTNO     VARCHAR2 (20);
    V_STRCUSTODYCD     VARCHAR2 (20);
    V_STRCACODE     VARCHAR2 (20);
    v_CURRDATE      date;
    v_CUSTTYPE      varchar2(5);
BEGIN
    V_INBRID:=BRID;
    /*IF (V_STROPTION = 'A') THEN
         V_STRBRID := '%';
    ELSE IF (V_STROPTION = 'B') THEN
            SELECT BRGRP.MAPID INTO V_STRBRID FROM BRGRP WHERE BRGRP.BRID = V_INBRID;
        ELSE
            V_STRBRID := V_INBRID;
        END IF;
    END IF; */                                        ---hoangnd loc theo pham vi

    IF (PV_AFACCTNO <> 'ALL')
   THEN
      V_STRAFACCTNO := PV_AFACCTNO;
   ELSE
      V_STRAFACCTNO := '%%';
   END IF;

     IF (PV_CUSTODYCD <> 'ALL')
   THEN
      V_STRCUSTODYCD := PV_CUSTODYCD;
   ELSE
      V_STRCUSTODYCD := '%%';
   END IF;

   if upper(V_STRCUSTODYCD) like '022F%' then
        v_CUSTTYPE := 'F';
   ELSE
        v_CUSTTYPE := 'C';
   end if;


        IF (P_CACODE <> 'ALL')
   THEN
      V_STRCACODE := P_CACODE;
   ELSE
      V_STRCACODE := '%%';
   END IF;

   v_CURRDATE := getcurrdate;


   --GET REPORT'S PARAMETERS

OPEN PV_REFCURSOR FOR
    SELECT  AF.BRID BRID,CF.CUSTID, CF.CUSTODYCD, MAX(AF.ACCTNO) ACCTNO, CF.FULLNAME , CF.ADDRESS, CF.phone ,nvl(mobile,phone) Mobile_phone,
            (case when cf.country = '234' then cf.idcode else cf.tradingcode end) IDCODE,
             (case when cf.country = '234' then cf.IDDATE else cf.tradingcodedt end) IDDATE, CF.IDPLACE,
             CA.REPORTDATE,
             CA.ACTIONDATE,CA.EXRATE, CA.RIGHTOFFRATE,
             decode(CF.CUSTTYPE,'F', to_char(CA.FRDATETRANSFER,'DD Month RRRR'),to_char(CA.FRDATETRANSFER,'DD/MM/RRRR')) FRDATETRANSFER,
             decode(CF.CUSTTYPE,'F', to_char(CA.TODATETRANSFER,'DD Month RRRR'),to_char(CA.TODATETRANSFER,'DD/MM/RRRR')) TODATETRANSFER,
             /*(substr(CA.EXRATE,instr(CA.EXRATE,'/') + 1,length(CA.EXRATE))) as Y,
             (substr(CA.EXRATE,0,instr(CA.EXRATE,'/') - 1)) as X,*/
             (substr(CA.RIGHTOFFRATE,instr(CA.RIGHTOFFRATE,'/') + 1,length(CA.RIGHTOFFRATE))) as Y,
             (substr(CA.RIGHTOFFRATE,0,instr(CA.RIGHTOFFRATE,'/') - 1)) as X, V_INBRID INBRID,
             sum(SCH.TRADE) BALANCE
             --SCH.TRADE,to_number(substr(CA.EXRATE,instr(CA.EXRATE,'/') + 1,length(CA.EXRATE))), to_number(substr(CA.EXRATE,0,instr(CA.EXRATE,'/') - 1))
             -- ,trunc((SCH.TRADE*(substr(CA.EXRATE,instr(CA.EXRATE,'/') + 1,length(CA.EXRATE)))/(substr(CA.EXRATE,0,instr(CA.EXRATE,'/') - 1)))) QTTY
             ,sum(SCH.balance + SCH.pbalance) QTTY,
             sum(SCH.pqtty + SCH.qtty) QTTY1, CA.EXPRICE,
             decode(CF.CUSTTYPE,'F', to_char(CA.BEGINDATE,'DD Month RRRR'),to_char(CA.BEGINDATE,'DD/MM/RRRR'))  BEGINDATE,
             decode(CF.CUSTTYPE,'F', to_char(CA.DUEDATE,'DD Month RRRR'),to_char(CA.DUEDATE,'DD/MM/RRRR')) DUEDATE,
             SEC.CODEID, SEC.ISSUERID, SEC.SECTYPE ,SEC.IISSHORTNAME , DECODE(CF.CUSTTYPE,'F', SEC.EN_ISSFULLNAME,SEC.ISSFULLNAME) ISSFULLNAME,
             TOSEC.*,
             v_CURRDATE CURRDATE, CF.CUSTTYPE CUSTTYPE
      FROM (
                select CUSTID, CUSTODYCD, FULLNAME, ADDRESS, phone, mobile, country, idcode, tradingcode, IDDATE, tradingcodedt, IDPLACE,
                    DECODE(SUBSTR(CUSTODYCD,1,4),'022F','F','C') CUSTTYPE
                from CFMAST
            ) CF, AFMAST AF, CAMAST CA, CASCHD SCH,
           (
               SELECT SB.CODEID, SB.ISSUERID, A1.cdcontent SECTYPE ,ISS.SHORTNAME IISSHORTNAME,
                ISS.FULLNAME ISSFULLNAME, NVL(ISS.EN_FULLNAME,ISS.FULLNAME) EN_ISSFULLNAME
               FROM SBSECURITIES SB, ISSUERS ISS,ALLCODE A1
               WHERE SB.ISSUERID = ISS.ISSUERID
               and SB.SECTYPE = A1.cdval and A1.cdname = 'SECTYPE'
               --ORDER BY SB.CODEIDd
            )SEC,
            (
               SELECT SB.CODEID TOCODEID, SB.ISSUERID TOISSUERID, A1.cdcontent TOSECTYPE ,ISS.SHORTNAME TOIISSHORTNAME, ISS.FULLNAME TOISSFULLNAME
               FROM SBSECURITIES SB, ISSUERS ISS,ALLCODE A1
               WHERE SB.ISSUERID = ISS.ISSUERID
               and SB.SECTYPE = A1.cdval and A1.cdname = 'SECTYPE'
               --ORDER BY SB.CODEIDd
            )toSEC
      WHERE CF.CUSTID = AF.CUSTID AND AF.STATUS IN ('A')
            AND SCH.AFACCTNO = AF.ACCTNO
            AND SCH.CAMASTID = CA.CAMASTID
            AND SCH.CODEID = CA.CODEID
            AND CA.CODEID = SEC.CODEID
            AND nvl(CA.TOCODEID,CA.CODEID) = TOSEC.TOCODEID
            AND SCH.DELTD <> 'Y'
            and catype='014'
            AND CF.CUSTODYCD like  V_STRCUSTODYCD
            AND AF.ACCTNO like  V_STRAFACCTNO
            AND CA.CAMASTID like  V_STRCACODE
            --AND (AF.BRID LIKE V_STRBRID OR INSTR(V_STRBRID,AF.BRID) <> 0)     -- hoangnd loc theo pham vi
      GROUP BY CF.CUSTID, CF.CUSTODYCD, /*AF.ACCTNO,*/ CF.FULLNAME , CF.ADDRESS, CF.phone ,nvl(mobile,phone) ,
            (case when cf.country = '234' then cf.idcode else cf.tradingcode end) ,
             (case when cf.country = '234' then cf.IDDATE else cf.tradingcodedt end) , CF.IDPLACE,
             CA.REPORTDATE, CA.ACTIONDATE,CA.EXRATE, CA.RIGHTOFFRATE,
             decode(CF.CUSTTYPE,'F', to_char(CA.FRDATETRANSFER,'DD Month RRRR'),to_char(CA.FRDATETRANSFER,'DD/MM/RRRR')),
             decode(CF.CUSTTYPE,'F', to_char(CA.TODATETRANSFER,'DD Month RRRR'),to_char(CA.TODATETRANSFER,'DD/MM/RRRR')),
             (substr(CA.RIGHTOFFRATE,instr(CA.RIGHTOFFRATE,'/') + 1,length(CA.RIGHTOFFRATE))) ,
             (substr(CA.RIGHTOFFRATE,0,instr(CA.RIGHTOFFRATE,'/') - 1)) ,
             CA.EXPRICE, decode(CF.CUSTTYPE,'F', to_char(CA.BEGINDATE,'DD Month RRRR'),to_char(CA.BEGINDATE,'DD/MM/RRRR')),
             decode(CF.CUSTTYPE,'F', to_char(CA.DUEDATE,'DD Month RRRR'),to_char(CA.DUEDATE,'DD/MM/RRRR')),
             SEC.CODEID, SEC.ISSUERID, SEC.SECTYPE ,SEC.IISSHORTNAME , DECODE(CF.CUSTTYPE,'F', SEC.EN_ISSFULLNAME,SEC.ISSFULLNAME) ,
             toSEC.TOCODEID , toSEC.TOISSUERID , toSEC.TOSECTYPE ,toSEC.TOIISSHORTNAME , toSEC.TOISSFULLNAME, AF.BRID,CF.CUSTTYPE
      ORDER BY CF.CUSTID

 ;


EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
 
 
/
