SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf0032 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2
 )
IS
--
-- PURPOSE: DSKH HUY, THAY DOI NOI DUNG UY QUYEN
-- MODIFICATION HISTORY
-- PERSON       DATE        COMMENTS
-- THENN        03-MAR-2012 CREATED
-- ---------    ------      -------------------------------------------

   V_STROPTION         VARCHAR2  (5);
   V_STRBRID           VARCHAR2  (40);
   v_brid              VARCHAR2(4);
   V_CUSTODYCD      VARCHAR2(10);
   V_AFACCTNO       VARCHAR2(10);
   V_AUTH1      VARCHAR2(2000);
   V_AUTH2      VARCHAR2(2000);
   V_AUTH3      VARCHAR2(2000);
   V_AUTH4      VARCHAR2(2000);
   V_AUTH5      VARCHAR2(2000);
   V_AUTH6      VARCHAR2(2000);
   V_AUTH7      VARCHAR2(2000);
   V_AUTH8      VARCHAR2(2000);
   V_AUTH9      VARCHAR2(2000);
   V_AUTH10      VARCHAR2(2000);
   V_AUTH11      VARCHAR2(2000);

BEGIN
    -- GET REPORT'S PARAMETERS
   V_STROPTION := OPT;
      v_brid := brid;


   IF  V_STROPTION = 'A' and v_brid = '0001' then
    V_STRBRID := '%';
    elsif V_STROPTION = 'B' then
        select br.mapid into V_STRBRID from brgrp br where br.brid = v_brid;
    else V_STROPTION := v_brid;

END IF;

   IF PV_CUSTODYCD IS NULL OR PV_CUSTODYCD = 'ALL' THEN
      V_CUSTODYCD := '%%';
   ELSE
      V_CUSTODYCD := PV_CUSTODYCD;
   END IF;

   IF PV_AFACCTNO IS NULL OR PV_AFACCTNO = 'ALL' THEN
      V_AFACCTNO := '%%';
   ELSE
      V_AFACCTNO := PV_AFACCTNO;
   END IF;

   -- GET INFORMATION OF AUTH'STRING
    SELECT MAX(AUTH1) AUTH1,MAX(AUTH2) AUTH2,MAX(AUTH3) AUTH3,MAX(AUTH4) AUTH4,MAX(AUTH5) AUTH5,
        MAX(AUTH6) AUTH6,MAX(AUTH7) AUTH7,MAX(AUTH8) AUTH8,MAX(AUTH9) AUTH9,MAX(AUTH10) AUTH10,MAX(AUTH11) AUTH11
    INTO V_AUTH1,V_AUTH2,V_AUTH3,V_AUTH4,V_AUTH5,V_AUTH6,V_AUTH7,V_AUTH8,V_AUTH9,V_AUTH10,V_AUTH11
    FROM
    (
        SELECT DECODE(A.CDVAL,'1',CDCONTENT,'') AUTH1,
            DECODE(A.CDVAL,'2',CDCONTENT,'') AUTH2,
            DECODE(A.CDVAL,'3',CDCONTENT,'') AUTH3,
            DECODE(A.CDVAL,'4',CDCONTENT,'') AUTH4,
            DECODE(A.CDVAL,'5',CDCONTENT,'') AUTH5,
            DECODE(A.CDVAL,'6',CDCONTENT,'') AUTH6,
            DECODE(A.CDVAL,'7',CDCONTENT,'') AUTH7,
            DECODE(A.CDVAL,'8',CDCONTENT,'') AUTH8,
            DECODE(A.CDVAL,'9',CDCONTENT,'') AUTH9,
            DECODE(A.CDVAL,'10',CDCONTENT,'') AUTH10,
            DECODE(A.CDVAL,'11',CDCONTENT,'') AUTH11
        FROM allcode A
        WHERE CDTYPE = 'CF' AND CDNAME = 'LINKAUTH'
    );

    OPEN PV_REFCURSOR
    FOR

    SELECT A.*, DECODE(A.ACTION_FLAG,'EDIT', TO_CHAR(A.CHANGEDATE,'DD/MM/YYYY'), '') EDITDATE,
        RTRIM(CASE WHEN LENGTH(OLDLINKAUTH) >0 THEN
                DECODE(SUBSTR(OLDLINKAUTH,1,1),'Y',V_AUTH1 || ', ','')
                || DECODE(SUBSTR(OLDLINKAUTH,2,1),'Y',V_AUTH2 || ', ','')
                || DECODE(SUBSTR(OLDLINKAUTH,3,1),'Y',V_AUTH3 || ', ','')
                || DECODE(SUBSTR(OLDLINKAUTH,4,1),'Y',V_AUTH4 || ', ','')
                || DECODE(SUBSTR(OLDLINKAUTH,5,1),'Y',V_AUTH5 || ', ','')
                || DECODE(SUBSTR(OLDLINKAUTH,6,1),'Y',V_AUTH6 || ', ','')
                || DECODE(SUBSTR(OLDLINKAUTH,8,1),'Y',V_AUTH8 || ', ','')
                || DECODE(SUBSTR(OLDLINKAUTH,9,1),'Y',V_AUTH9 || ', ','')
                || DECODE(SUBSTR(OLDLINKAUTH,10,1),'Y',V_AUTH10 || ', ','')
                || DECODE(SUBSTR(OLDLINKAUTH,11,1),'Y',V_AUTH11,'')
             ELSE '' END,', ') OLDLINKAUTHDTL,
        RTRIM(CASE WHEN LENGTH(NEWLINKAUTH) >0 THEN
                DECODE(SUBSTR(NEWLINKAUTH,1,1),'Y',V_AUTH1 || ', ','')
                || DECODE(SUBSTR(NEWLINKAUTH,2,1),'Y',V_AUTH2 || ', ','')
                || DECODE(SUBSTR(NEWLINKAUTH,3,1),'Y',V_AUTH3 || ', ','')
                || DECODE(SUBSTR(NEWLINKAUTH,4,1),'Y',V_AUTH4 || ', ','')
                || DECODE(SUBSTR(NEWLINKAUTH,5,1),'Y',V_AUTH5 || ', ','')
                || DECODE(SUBSTR(NEWLINKAUTH,6,1),'Y',V_AUTH6 || ', ','')
                || DECODE(SUBSTR(NEWLINKAUTH,8,1),'Y',V_AUTH8 || ', ','')
                || DECODE(SUBSTR(NEWLINKAUTH,9,1),'Y',V_AUTH9 || ', ','')
                || DECODE(SUBSTR(NEWLINKAUTH,10,1),'Y',V_AUTH10 || ', ','')
                || DECODE(SUBSTR(NEWLINKAUTH,11,1),'Y',V_AUTH11,'')
             ELSE '' END,', ') NEWLINKAUTHDTL

    FROM
    (
        SELECT AF.CUSTODYCD,  AF.FULLNAME, AF.IDCODE, AF.IDTYPE, AF.CUSTTYPE, AF.CUSTID, AF.AUTHFULLNAME,
            CASE WHEN CE.OLDLICENSE IS NULL THEN AF.AUTHIDCODE ELSE NVL(CE.OLDLICENSE,'') END AUTHIDCODE,
            AF.AUTHIDTYPE, AF.AUTHCUSTTYPE, AF.AUTHIDDATE,
            AF.AUTOID, AF.ADDNEWDATE, AF.CHANGEDATE, AF.ACTION_FLAG, NVL(AD.DELDATE,'') DELDATE, NVL(AE.OLDLINKAUTH,'') OLDLINKAUTH, NVL(AE.NEWLINKAUTH,'') NEWLINKAUTH,
            NVL(CE.OLDLICENSE,'') OLDLICENSE, NVL(CE.NEWLICENSE,'') NEWLICENSE,
            NVL(ADR.OLDADDRESS,'') OLDADDRESS, NVL(ADR.NEWADDRESS,'') NEWADDRESS,
            NVL(EXD.OLDEXPDATE,'') OLDEXPDATE, NVL(EXD.NEWEXPDATE,'') NEWEXPDATE,
            DECODE(AF.ACTION_FLAG,'EDIT',0,1) ODRNUM
        FROM
        (
            SELECT CF.CUSTODYCD,  CF.FULLNAME, CF.IDCODE, CF.IDTYPE, CF.CUSTTYPE, CFA.CUSTID, CF2.FULLNAME AUTHFULLNAME,
                    CF2.IDCODE AUTHIDCODE, CF2.IDTYPE AUTHIDTYPE, CF2.CUSTTYPE AUTHCUSTTYPE, TO_CHAR(CF2.IDDATE,'DD/MM/YYYY') AUTHIDDATE, CFA.AUTOID,
                    TO_CHAR(CFA.VALDATE,'DD/MM/YYYY') ADDNEWDATE, IC.CHANGEDATE, IC.ACTION_FLAG, CFA.CFCUSTID
                FROM CFMAST CF,  CFAUTH CFA, CFMAST CF2,AFMAST AF,
                (
                    SELECT CUSTID, AUTHAUTOID, CHANGEDATE, ACTION_FLAG
                    FROM
                    (
                        SELECT SUBSTR(MTL.RECORD_KEY,11,10) CUSTID, TO_NUMBER(REPLACE(SUBSTR(MTL.CHILD_RECORD_KEY,9),'''','')) AUTHAUTOID,
                                MTL.MAKER_DT CHANGEDATE, MTL.ACTION_FLAG
                            FROM MAINTAIN_LOG MTL
                            WHERE MTL.TABLE_NAME = 'CFMAST' AND MTL.CHILD_TABLE_NAME = 'CFAUTH'
                                AND MTL.ACTION_FLAG in ('DELETE','EDIT')
                                AND MTL.MAKER_DT >= TO_DATE(F_DATE,'DD/MM/YYYY')
                                AND MTL.MAKER_DT <= TO_DATE(T_DATE,'DD/MM/YYYY')
                        UNION ALL
                        SELECT SUBSTR(MTL.RECORD_KEY,11,10) CUSTID, CFA.AUTOID AUTHAUTOID, MTL.MAKER_DT CHANGEDATE, MTL.ACTION_FLAG
                            FROM CFAUTH CFA, MAINTAIN_LOG MTL
                            WHERE MTL.TABLE_NAME = 'CFMAST'
                                AND MTL.ACTION_FLAG = 'EDIT'
                                --AND CASE WHEN MTL.COLUMN_NAME='EXPDATE' AND MTL.child_table_name='CFAUTH' THEN 1 ELSE 0 END = 1
                                AND (MTL.COLUMN_NAME IN ('IDCODE') /*OR ,'ADDRESS' (MTL.COLUMN_NAME='EXPDATE' AND MTL.child_table_name='CFAUTH' )*/)
                                AND CFA.custid = SUBSTR(MTL.RECORD_KEY,11,10)
                                AND MTL.MAKER_DT >= TO_DATE(F_DATE,'DD/MM/YYYY')
                                AND MTL.MAKER_DT <= TO_DATE(T_DATE,'DD/MM/YYYY')
                    ) MTL
                    GROUP BY MTL.CUSTID, MTL.AUTHAUTOID, MTL.CHANGEDATE, MTL.ACTION_FLAG
                ) IC
                WHERE CF.CUSTID = CFA.CFCUSTID
                    AND CFA.CUSTID = CF2.CUSTID
                    AND IC.AUTHAUTOID = CFA.AUTOID
					AND CF.CUSTID = AF.CUSTID
                    AND CF.CUSTODYCD LIKE V_CUSTODYCD--'022C191231'
                    AND (af.brid like V_STRBRID or instr(V_STRBRID,af.brid) <> 0 )
                    AND AF.ACCTNO LIKE V_AFACCTNO
				GROUP BY CF.CUSTODYCD,  CF.FULLNAME, CF.IDCODE, CF.IDTYPE, CF.CUSTTYPE, CFA.CUSTID, CF2.FULLNAME ,
                    CF2.IDCODE , CF2.IDTYPE , CF2.CUSTTYPE , TO_CHAR(CF2.IDDATE,'DD/MM/YYYY') , CFA.AUTOID,
                    TO_CHAR(CFA.VALDATE,'DD/MM/YYYY') , IC.CHANGEDATE, IC.ACTION_FLAG, CFA.CFCUSTID
        ) AF
        LEFT JOIN
        (
            SELECT SUBSTR(MTL.RECORD_KEY,11,10) CUSTID, TO_NUMBER(REPLACE(SUBSTR(MTL.CHILD_RECORD_KEY,9),'''','')) AUTHAUTOID,
                    TO_CHAR(MTL.MAKER_DT,'DD/MM/YYYY') DELDATE, 4 ODRNUM, MTL.MAKER_DT CHANGEDATE, MTL.ACTION_FLAG
                FROM MAINTAIN_LOG MTL
                WHERE MTL.TABLE_NAME = 'CFMAST' AND MTL.CHILD_TABLE_NAME = 'CFAUTH'
                    AND MTL.ACTION_FLAG = 'DELETE'
                    AND MTL.MAKER_DT >= TO_DATE(F_DATE,'DD/MM/YYYY')
                    AND MTL.MAKER_DT <= TO_DATE(T_DATE,'DD/MM/YYYY')
        ) AD
        ON AF.CFCUSTID = AD.CUSTID AND AF.AUTOID = AD.AUTHAUTOID AND AF.CHANGEDATE = AD.CHANGEDATE AND AF.ACTION_FLAG = AD.ACTION_FLAG
        LEFT JOIN
        (
            SELECT SUBSTR(MTL.RECORD_KEY,11,10) CUSTID, TO_NUMBER(SUBSTR(MTL.CHILD_RECORD_KEY,9)) AUTHAUTOID,
                    TO_CHAR(MTL.MAKER_DT,'DD/MM/YYYY') EDITDATE,
                    MTL.OLDLINKAUTH, MTL.NEWLINKAUTH, 2 ODRNUM, MTL.MAKER_DT CHANGEDATE, MTL.ACTION_FLAG
                FROM
                    (SELECT MTL.MAKER_DT, MTM.RECORD_KEY, MTL.CHILD_RECORD_KEY, 'EDIT' ACTION_FLAG,
                        MAX(CASE WHEN MTL.MOD_NUM = MTM.MINNUM THEN MTL.FROM_VALUE ELSE '' END) OLDLINKAUTH,
                        MAX(CASE WHEN MTL.MOD_NUM = MTM.MAXNUM THEN MTL.TO_VALUE ELSE '' END) NEWLINKAUTH, MAX(MTL.MOD_NUM) MOD_NUM
                    FROM MAINTAIN_LOG MTL,
                        (SELECT MTL.RECORD_KEY, MTL.CHILD_RECORD_KEY, MTL.MAKER_DT,
                            MAX(MTL.MOD_NUM) MAXNUM,  MIN(MTL.MOD_NUM) MINNUM
                        FROM maintain_log MTL
                        WHERE MTL.TABLE_NAME = 'CFMAST' AND MTL.CHILD_TABLE_NAME = 'CFAUTH'
                            AND MTL.ACTION_FLAG = 'EDIT'
                            AND MTL.COLUMN_NAME = 'LINKAUTH'
                        GROUP BY MTL.RECORD_KEY, MTL.CHILD_RECORD_KEY, MTL.MAKER_DT
                        ) MTM
                    WHERE MTL.TABLE_NAME = 'CFMAST' AND MTL.CHILD_TABLE_NAME = 'CFAUTH'
                        AND MTL.ACTION_FLAG = 'EDIT'
                        AND MTL.COLUMN_NAME = 'LINKAUTH'
                        AND MTL.record_key = MTM.RECORD_KEY AND MTL.CHILD_RECORD_KEY = MTM.CHILD_RECORD_KEY AND MTL.MAKER_DT = MTM.MAKER_DT
                        AND MTL.MAKER_DT >= TO_DATE(F_DATE,'DD/MM/YYYY')
                        AND MTL.MAKER_DT <= TO_DATE(T_DATE,'DD/MM/YYYY')
                    GROUP BY MTL.maker_dt, MTM.RECORD_KEY, MTL.CHILD_RECORD_KEY
                    ) MTL
        ) AE
        ON AF.CFCUSTID = AE.CUSTID AND AF.AUTOID = AE.AUTHAUTOID AND AF.CHANGEDATE = AE.CHANGEDATE AND AF.ACTION_FLAG = AE.ACTION_FLAG
        LEFT JOIN
        (
            SELECT CFA.CUSTID, CFA.AUTOID AUTHAUTOID,
                    MTL.OLDLICENSE, MTL.NEWLICENSE, MTL.MAKER_DT CHANGEDATE, MTL.ACTION_FLAG
                FROM CFAUTH CFA,
                    (SELECT MTL.MAKER_DT, MTM.RECORD_KEY, 'EDIT' ACTION_FLAG,
                        MAX(CASE WHEN MTL.MOD_NUM = MTM.MINNUM THEN MTL.FROM_VALUE ELSE '' END) OLDLICENSE,
                        MAX(CASE WHEN MTL.MOD_NUM = MTM.MAXNUM THEN MTL.TO_VALUE ELSE '' END) NEWLICENSE, MAX(MTL.MOD_NUM) MOD_NUM
                    FROM MAINTAIN_LOG MTL,
                        (SELECT MTL.RECORD_KEY, MTL.CHILD_RECORD_KEY, MTL.MAKER_DT,
                            MAX(MTL.MOD_NUM) MAXNUM,  MIN(MTL.MOD_NUM) MINNUM
                        FROM maintain_log MTL
                        WHERE MTL.TABLE_NAME = 'CFMAST'
                            AND MTL.ACTION_FLAG = 'EDIT'
                            AND MTL.COLUMN_NAME = 'IDCODE'
                        GROUP BY MTL.RECORD_KEY, MTL.CHILD_RECORD_KEY, MTL.MAKER_DT
                        ) MTM
                    WHERE MTL.TABLE_NAME = 'CFMAST'
                        AND MTL.ACTION_FLAG = 'EDIT'
                        AND MTL.COLUMN_NAME = 'IDCODE'
                        AND MTL.record_key = MTM.RECORD_KEY AND MTL.MAKER_DT = MTM.MAKER_DT
                        AND MTL.MAKER_DT >= TO_DATE(F_DATE,'DD/MM/YYYY')
                        AND MTL.MAKER_DT <= TO_DATE(T_DATE,'DD/MM/YYYY')
                    GROUP BY MTL.maker_dt, MTM.RECORD_KEY
                    ) MTL
                WHERE CFA.CUSTID = SUBSTR(MTL.RECORD_KEY,11,10)

        ) CE
        --ON AF.custid = CE.cfcustid AND AF.AUTOID = CE.AUTHAUTOID AND AF.CHANGEDATE = CE.CHANGEDATE AND AF.ACTION_FLAG = CE.ACTION_FLAG
        ON AF.custid = CE.custid AND AF.AUTOID = CE.AUTHAUTOID AND AF.CHANGEDATE = CE.CHANGEDATE AND AF.ACTION_FLAG = CE.ACTION_FLAG
        LEFT JOIN
        (
            SELECT CFA.custid, CFA.AUTOID AUTHAUTOID,
                    MTL.OLDADDRESS, MTL.NEWADDRESS, MTL.MAKER_DT CHANGEDATE, MTL.ACTION_FLAG
                FROM CFAUTH CFA,
                    (SELECT MTL.MAKER_DT, MTM.RECORD_KEY, 'EDIT' ACTION_FLAG,
                        MAX(CASE WHEN MTL.MOD_NUM = MTM.MINNUM THEN MTL.FROM_VALUE ELSE '' END) OLDADDRESS,
                        MAX(CASE WHEN MTL.MOD_NUM = MTM.MAXNUM THEN MTL.TO_VALUE ELSE '' END) NEWADDRESS, MAX(MTL.MOD_NUM) MOD_NUM
                    FROM MAINTAIN_LOG MTL,
                        (SELECT MTL.RECORD_KEY, MTL.CHILD_RECORD_KEY, MTL.MAKER_DT,
                            MAX(MTL.MOD_NUM) MAXNUM,  MIN(MTL.MOD_NUM) MINNUM
                        FROM maintain_log MTL
                        WHERE MTL.TABLE_NAME = 'CFMAST'
                            AND MTL.ACTION_FLAG = 'EDIT'
                            AND MTL.COLUMN_NAME = 'ADDRESS'
                        GROUP BY MTL.RECORD_KEY, MTL.CHILD_RECORD_KEY, MTL.MAKER_DT
                        ) MTM
                    WHERE MTL.TABLE_NAME = 'CFMAST'
                        AND MTL.ACTION_FLAG = 'EDIT'
                        AND MTL.COLUMN_NAME = 'ADDRESS'
                        AND MTL.record_key = MTM.RECORD_KEY AND MTL.MAKER_DT = MTM.MAKER_DT
                        AND MTL.MAKER_DT >= TO_DATE(F_DATE,'DD/MM/YYYY')
                        AND MTL.MAKER_DT <= TO_DATE(T_DATE,'DD/MM/YYYY')
                    GROUP BY MTL.maker_dt, MTM.RECORD_KEY
                    ) MTL
                WHERE CFA.CUSTID = SUBSTR(MTL.RECORD_KEY,11,10)
        ) ADR
        ON AF.custid = ADR.custid AND AF.AUTOID = ADR.AUTHAUTOID AND AF.CHANGEDATE = ADR.CHANGEDATE AND AF.ACTION_FLAG = ADR.ACTION_FLAG
        LEFT JOIN
        (
            SELECT CFA.custid, CFA.AUTOID AUTHAUTOID,
                    MTL.OLDEXPDATE, MTL.NEWEXPDATE, MTL.MAKER_DT CHANGEDATE, MTL.ACTION_FLAG
                FROM CFAUTH CFA,
                    (SELECT MTL.MAKER_DT, MTM.RECORD_KEY, 'EDIT' ACTION_FLAG,
                        MAX(CASE WHEN MTL.MOD_NUM = MTM.MINNUM THEN MTL.FROM_VALUE ELSE '' END) OLDEXPDATE,
                        MAX(CASE WHEN MTL.MOD_NUM = MTM.MAXNUM THEN MTL.TO_VALUE ELSE '' END) NEWEXPDATE, MAX(MTL.MOD_NUM) MOD_NUM
                    FROM MAINTAIN_LOG MTL,
                        (SELECT MTL.RECORD_KEY, MTL.CHILD_RECORD_KEY, MTL.MAKER_DT,
                            MAX(MTL.MOD_NUM) MAXNUM,  MIN(MTL.MOD_NUM) MINNUM
                        FROM maintain_log MTL
                        WHERE MTL.TABLE_NAME = 'CFMAST'
                            and MTL.child_table_name='CFAUTH'
                            AND MTL.ACTION_FLAG = 'EDIT'
                            AND MTL.COLUMN_NAME = 'EXPDATE'
                        GROUP BY MTL.RECORD_KEY, MTL.CHILD_RECORD_KEY, MTL.MAKER_DT
                        ) MTM
                    WHERE MTL.TABLE_NAME = 'CFMAST'
                        AND MTL.ACTION_FLAG = 'EDIT'
                        AND MTL.COLUMN_NAME = 'EXPDATE'
                        AND MTL.record_key = MTM.RECORD_KEY AND MTL.MAKER_DT = MTM.MAKER_DT
                        AND MTL.MAKER_DT >= TO_DATE(F_DATE,'DD/MM/YYYY')
                        AND MTL.MAKER_DT <= TO_DATE(T_DATE,'DD/MM/YYYY')
                    GROUP BY MTL.maker_dt, MTM.RECORD_KEY
                    ) MTL
                WHERE CFA.CFCUSTID = SUBSTR(MTL.RECORD_KEY,11,10)
        ) EXD
        ON AF.custid = EXD.custid AND AF.AUTOID = EXD.AUTHAUTOID AND AF.CHANGEDATE = EXD.CHANGEDATE AND AF.ACTION_FLAG = EXD.ACTION_FLAG
    ) A
    ORDER BY A.CUSTODYCD, A.CUSTID, A.AUTOID, A.CHANGEDATE, A.ODRNUM --, A.MOD_NUM
    ;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;


-- End of DDL Script for Procedure HOST.CF0031

 
 
/
