SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf0091 (
   PV_REFCURSOR         IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                  IN       VARCHAR2,
   BRID                 IN       VARCHAR2,
   F_DATE               IN       VARCHAR2,
   T_DATE               IN       VARCHAR2,
   PV_CUSTODYCD         IN       VARCHAR2,
   PV_AFACCTNO          IN       VARCHAR2,
   PV_BUSSINESSTYPE     IN       VARCHAR2,
   PV_SMSTYPE           IN       VARCHAR2,
   PV_FEETYPE           IN       VARCHAR2,
   PV_MAKER             IN       VARCHAR2,
   PV_CHECKER           IN       VARCHAR2

)
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
--
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- Hien.vu
-- ---------   ------  -------------------------------------------
   V_STROPTION          VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID            VARCHAR2 (4);              -- USED WHEN V_NUMOPTION > 0
   V_CUSTODYCD          VARCHAR2(50);
   V_AFACCTNO           VARCHAR2(50);
   V_BUSSINESSTYPE      VARCHAR2(50);
   V_SMSTYPE            VARCHAR2(50);
   V_FEETYPE            VARCHAR2(50);
   V_MAKER              VARCHAR2(50);
   V_CHECKER            VARCHAR2(50);
   V_FEETYPENAME            VARCHAR2(100);

-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN
-- insert into temp_bug(text) values('CF0001');commit;
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

   -- GET REPORT'S PARAMETERS
   IF (PV_CUSTODYCD <> 'ALL')
   THEN
      V_CUSTODYCD := PV_CUSTODYCD;
   ELSE
      V_CUSTODYCD := '%%';
   END IF;
     -- GET REPORT'S PARAMETERS
   IF (PV_AFACCTNO <> 'ALL')
   THEN
      V_AFACCTNO := PV_AFACCTNO;
   ELSE
      V_AFACCTNO := '%%';
   END IF;
        -- GET REPORT'S PARAMETERS
   IF (PV_BUSSINESSTYPE <> 'ALL')
   THEN
      V_BUSSINESSTYPE := PV_BUSSINESSTYPE;
   ELSE
      V_BUSSINESSTYPE := '%%';
   END IF;

        -- GET REPORT'S PARAMETERS
   IF (PV_SMSTYPE <> 'ALL')
   THEN
      V_SMSTYPE := PV_SMSTYPE;
   ELSE
      V_SMSTYPE := '%%';
   END IF;
     -- GET REPORT'S PARAMETERS
   IF (PV_FEETYPE <> 'ALL')
   THEN
      V_FEETYPE := PV_FEETYPE;
      select cdcontent into V_FEETYPENAME from allcode where cdname='FEETYPE' and cdtype='CF' and cdval=PV_FEETYPE and rownum<=1;
   ELSE
      V_FEETYPE := '%%';
      V_FEETYPENAME:='ALL';
   END IF;
           -- GET REPORT'S PARAMETERS
   IF (PV_MAKER <> 'ALL')
   THEN
      V_MAKER := PV_MAKER;
   ELSE
      V_MAKER := '%%';
   END IF;
     -- GET REPORT'S PARAMETERS
   IF (PV_CHECKER <> 'ALL')
   THEN
      V_CHECKER := PV_CHECKER;
   ELSE
      V_CHECKER := '%%';
   END IF;
   OPEN PV_REFCURSOR
   FOR
    -- 27/02/2015 TruongLD sua lai nhu sau
    SELECT TL.TXDATE, CF.FULLNAME CFFULLNAME,REG.AFACCTNO, A.CDCONTENT ACTION,
            CF.CUSTODYCD CFCUSTODYCD, TYP.ACTYPE, ROUND(TYP.FEEAMT*(1+TYP.VAT/100)) FEEAMT,
            TYP.TXDATE APPROVE_DT, MAKER.TLFULLNAME MAKER,
            NVL(CHECKER.TLFULLNAME,'') CHECKER, TYP.TXDATE SMSDATE,
            PV_CUSTODYCD PV_CUSTODYCD, PV_AFACCTNO PV_AFACCTNO, PV_BUSSINESSTYPE PV_BUSSINESSTYPE,
            PV_SMSTYPE PV_SMSTYPE, V_FEETYPENAME PV_FEETYPE,
            PV_MAKER PV_MAKER, PV_CHECKER PV_CHECKER

   FROM AFMAST AF, CFMAST CF, SMSREGISLOG REG,
        (SELECT * FROM VW_TLLOG_ALL WHERE TLTXCD IN ('0043','1185')) TL,
        ALLCODE A,
        TLPROFILES MAKER, TLPROFILES CHECKER, SMSTYPE TYP
   WHERE CF.CUSTID = AF.CUSTID
         AND AF.ACCTNO = REG.AFACCTNO
         AND REG.TXNUM = TL.TXNUM
         AND REG.TXDATE = TL.TXDATE
         AND REG.SMSTYPE = TYP.ACTYPE
         AND REG.ACTION = A.CDVAL AND A.CDNAME='SMSACTION' AND A.CDTYPE='CF'
         AND TL.TLID = MAKER.TLID
         AND TL.OFFID = CHECKER.TLID
         AND REG.SMSTYPE = TYP.ACTYPE
         AND CF.CUSTODYCD LIKE V_CUSTODYCD
         AND REG.AFACCTNO LIKE V_AFACCTNO
         AND A.CDVAL LIKE V_BUSSINESSTYPE
         AND TYP.ACTYPE LIKE V_SMSTYPE
         AND (CASE WHEN 5000 <= ROUND(TYP.FEEAMT*(1+TYP.VAT/100)) AND ROUND(TYP.FEEAMT*(1+TYP.VAT/100)) < 10000 THEN '001'
                   WHEN 10000 <= ROUND(TYP.FEEAMT*(1+TYP.VAT/100)) AND ROUND(TYP.FEEAMT*(1+TYP.VAT/100)) < 20000 THEN '002'
                   WHEN 20000 <= ROUND(TYP.FEEAMT*(1+TYP.VAT/100)) AND ROUND(TYP.FEEAMT*(1+TYP.VAT/100)) < 50000 THEN '003'
          ELSE '010' END)   LIKE V_FEETYPE
         AND MAKER.TLID LIKE V_MAKER
         AND nvl(TL.OFFID,'--') LIKE V_CHECKER
         AND REG.TXDATE>=TO_DATE(F_DATE,'DD/MM/RRRR')
         AND REG.TXDATE<=TO_DATE(T_DATE,'DD/MM/RRRR')
    ORDER BY TL.TXDATE,CF.CUSTODYCD, REG.AFACCTNO,TL.OFFTIME;
    -- End TruongLD

   /*
   SELECT TL.TXDATE, CF.FULLNAME CFFULLNAME,REG.AFACCTNO,
        A.CDCONTENT ACTION,

        CF.CUSTODYCD CFCUSTODYCD,
            TYPE.ACTYPE,ROUND(TYPE.FEEAMT*(1+TYPE.VAT/100)) FEEAMT, --ROUND(LOG.TO_VALUE*(1+TYPE.VAT/100)) FEEAMT,
            TYPE.TXDATE APPROVE_DT, --LOG.APPROVE_DT,
            MAKER.TLFULLNAME MAKER, nvl(CHECKER.TLFULLNAME,'') CHECKER, TYPE.TXDATE SMSDATE,
            PV_CUSTODYCD PV_CUSTODYCD, PV_AFACCTNO PV_AFACCTNO, PV_BUSSINESSTYPE PV_BUSSINESSTYPE,
            PV_SMSTYPE PV_SMSTYPE, V_FEETYPENAME PV_FEETYPE,
            PV_MAKER PV_MAKER, PV_CHECKER PV_CHECKER
   FROM
   (
    select REG.autoid,REG.txdate,REG.afacctno, REG.smstype,REG.action,REG.txnum, LOG.record_key  , max(LOG.APPROVE_DT) APPROVE_DT,max(log.mod_num) mod_num
    -- select *
    from  SMSREGISLOG REG,  (
                               SELECT record_key, (LOG.APPROVE_DT) APPROVE_DT, max(log.mod_num) mod_num
                               FROM MAINTAIN_LOG LOG WHERE  LOG.TABLE_NAME='SMSTYPE'
                                   AND LOG.ACTION_FLAG='ADD'
                                   AND LOG.COLUMN_NAME='FEEAMT'
                                   AND NVL(LOG.CHILD_TABLE_NAME,'a')='a'
                               group by record_key, LOG.APPROVE_DT
                           UNION ALL
                               SELECT record_key, (LOG.APPROVE_DT) APPROVE_DT, max(log.mod_num) mod_num
                               FROM MAINTAIN_LOG LOG WHERE  LOG.TABLE_NAME='SMSTYPE'
                                   AND LOG.ACTION_FLAG='EDIT'
                                   AND LOG.COLUMN_NAME='FEEAMT'
                                   AND NVL(LOG.CHILD_TABLE_NAME,'a')='a'
                               group by record_key, LOG.APPROVE_DT
                           ) LOG
            where  SUBSTR(LOG.record_key,11,4)=REG.SMSTYPE
                and reg.txdate > =log.APPROVE_DT
            group by REG.autoid,REG.txdate,REG.afacctno, REG.smstype,REG.action,REG.txnum, LOG.record_key
        ) reg,(
          SELECT LOG2.record_key, LOG2.TO_VALUE,LOG2.APPROVE_DT,max(log2.mod_num) mod_num, max(NVL(LOG1.APPROVE_DT,'01-JAN-2050')) EDITDATE
          FROM
              (
                  SELECT record_key, LOG.FROM_VALUE, LOG.TO_VALUE, (LOG.APPROVE_DT) APPROVE_DT
                  FROM MAINTAIN_LOG LOG WHERE  LOG.TABLE_NAME='SMSTYPE'
                      AND LOG.ACTION_FLAG='EDIT'
                      AND  LOG.COLUMN_NAME='FEEAMT'
                      AND NVL(LOG.CHILD_TABLE_NAME,'a')='a'
              ) log1,
              (
                  SELECT record_key, LOG.TO_VALUE,(LOG.APPROVE_DT) APPROVE_DT,log.mod_num
                  FROM MAINTAIN_LOG LOG WHERE  LOG.TABLE_NAME='SMSTYPE'
                      AND LOG.ACTION_FLAG='ADD'
                      AND LOG.COLUMN_NAME='FEEAMT'
                      AND NVL(LOG.CHILD_TABLE_NAME,'a')='a'
              UNION ALL
                  SELECT record_key, LOG.TO_VALUE,(LOG.APPROVE_DT) APPROVE_DT,log.mod_num
                  FROM MAINTAIN_LOG LOG WHERE  LOG.TABLE_NAME='SMSTYPE'
                      AND LOG.ACTION_FLAG='EDIT'
                      AND LOG.COLUMN_NAME='FEEAMT'
                      AND NVL(LOG.CHILD_TABLE_NAME,'a')='a'
              ) LOG2
          WHERE log1.record_key(+) = log2.record_key
              AND LOG2.TO_VALUE = LOG1.FROM_VALUE(+)
          group by LOG2.record_key, LOG2.TO_VALUE,LOG2.APPROVE_DT
      ) log,
      (SELECT * FROM TLLOG WHERE DELTD <> 'Y' UNION ALL SELECT * FROM TLLOGALL WHERE DELTD <> 'Y') TL,
      ALLCODE a,afmast af, cfmast cf,TLPROFILES MAKER,TLPROFILES CHECKER,SMSTYPE TYPE
      where
         TL.TXDATE=REG.TXDATE
         AND af.custid = cf.custid
         AND reg.afacctno = af.acctno
         AND TL.TXNUM=REG.TXNUM
         --AND (case when (REG.ACTION='ADD' and log.APPROVE_DT=log.EDITDATE) then 'EDIT' else REG.ACTION end) =A.CDVAL AND A.CDNAME='SMSACTION' AND A.CDTYPE='CF'
         AND REG.ACTION=A.CDVAL AND A.CDNAME='SMSACTION' AND A.CDTYPE='CF'
         AND TL.TLID=MAKER.TLID
         AND nvl(TL.OFFID,'--')=CHECKer.TLID(+)
         AND REG.SMSTYPE=TYPE.ACTYPE
         AND TYPE.apprv_sts='A'
         AND LOG.record_key=reg.record_key
         and LOG.APPROVE_DT=reg.APPROVE_DT
         and LOG.mod_num=reg.mod_num
         --and reg.txdate <= LOG.EDITDATE
         and reg.txdate >= LOG.APPROVE_DT
         AND CF.CUSTODYCD LIKE V_CUSTODYCD
         AND REG.AFACCTNO LIKE V_AFACCTNO
         AND A.CDVAL LIKE V_BUSSINESSTYPE
         AND TYPE.ACTYPE LIKE V_SMSTYPE
          and (case when 5000 <= ROUND(TYPE.FEEAMT*(1+TYPE.VAT/100)) and ROUND(TYPE.FEEAMT*(1+TYPE.VAT/100)) < 10000 then '001'
                   when 10000 <= ROUND(TYPE.FEEAMT*(1+TYPE.VAT/100)) and ROUND(TYPE.FEEAMT*(1+TYPE.VAT/100)) < 20000 then '002'
                   when 20000 <= ROUND(TYPE.FEEAMT*(1+TYPE.VAT/100)) and ROUND(TYPE.FEEAMT*(1+TYPE.VAT/100)) < 50000 then '003'
          else '010' end)   LIKE V_FEETYPE
         --AND ROUND(TYPE.FEEAMT*(1+TYPE.VAT/100)) LIKE V_FEETYPE
         AND MAKER.TLID LIKE V_MAKER
         AND nvl(TL.OFFID,'--') LIKE V_CHECKER
         AND REG.TXDATE>=TO_DATE(F_DATE,'DD/MM/RRRR')
         AND REG.TXDATE<=TO_DATE(T_DATE,'DD/MM/RRRR')
    order by tl.txdate,tl.CFCUSTODYCD,reg.afacctno,TL.OFFTIME;
    */
 EXCEPTION
   WHEN OTHERS
   THEN
    --insert into temp_bug(text) values('CF0001');commit;
      RETURN;
END;                                                              -- PROCEDURE
 
 
/
