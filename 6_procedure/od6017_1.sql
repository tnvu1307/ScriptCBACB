SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE OD6017_1 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   TRANDATE               IN       VARCHAR2, /*Ngay giao dich*/
   PV_CUSTODYCD           IN       VARCHAR2 /*So tai khoan luu ky*/
   )
IS
    -- DRAFT FX to GTC team (SUBREPORT OF OD6017)
    -- person      date                 comments
    -- ---------   ------               -------------------------------------------
    -- NAM.LY      25-11-2019           created
    V_STROPTION         VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID           VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0
    v_TranDate          DATE;
    v_CustodyCD         VARCHAR2(20);

BEGIN
    V_STROPTION := OPT;
    v_TranDate      :=      TO_DATE(TRANDATE, SYSTEMNUMS.C_DATE_FORMAT);

    --------------------------
    if V_STROPTION = 'A' then
        V_STRBRID := '%';
    elsif V_STROPTION = 'B' then
        V_STRBRID := substr(BRID,1,2) || '__' ;
    else
        V_STRBRID:= BRID;
    end if;
    --------------------------
    if PV_CUSTODYCD = 'ALL' then
        v_CustodyCD := '%';
    else
        v_CustodyCD := REPLACE(PV_CUSTODYCD,'.','');
    end if;


    --MAIN QUERY--------------
    OPEN PV_REFCURSOR FOR
        SELECT TO_CHAR(v_TranDate,'DD MON YYYY') TRANDATE
             , CF.FULLNAME
             , CF.CIFID
             , SUM(TL.AMT) AMT_USD
             , SUM(TL.EXCHANGEAMT) AMT_VND
             , TL.EXCHANGERATE RATE
             , TL.DESCRIPTION
        FROM (
                SELECT TXNUM
                     , DDACCTNO_CVALUE DDACCTNO --TAI KHOAN TIEN TE CHUYEN
                     , DDACCTNO1_CVALUE DDACCTNO1 --TAI KHOAN TIEN TE NHAN
                     , AMT_NVALUE AMT --SO TIEN
                     , TXDATE_CVALUE TXDATE --NGAY GIAO DICH
                     , FXTYPE_CVALUE FXTYPE --LOAI TY GIA
                     , EXCHANGERATE_NVALUE EXCHANGERATE --TY GIA QUY DOI
                     , EXCHANGEAMT_NVALUE EXCHANGEAMT --GIA TRI QUY DOI
                     , DESCRIPTION_CVALUE DESCRIPTION --DIEN GIAI
                     , CUSTODYCD_CVALUE CUSTODYCD --SO TAI KHOAN LUU KY
                FROM (
                       SELECT *
                       FROM (
                               SELECT TF.TXNUM, TF.TXDATE, TF.NVALUE, TF.CVALUE, TF.FLDCD
                               FROM VW_TLLOG_ALL TL, VW_TLLOGFLD_ALL TF
                               WHERE TL.TXNUM = TF.TXNUM AND
                                     TL.TXDATE = TF.TXDATE AND
                                     TL.TLTXCD='1712'

                            )
                       PIVOT
                       (
                           MAX(NVALUE) NVALUE, MAX(CVALUE) CVALUE
                           FOR FLDCD IN ('04' DDACCTNO,
                                         '05' DDACCTNO1,
                                         '10' AMT,
                                         '20' TXDATE,
                                         '22' FXTYPE,
                                         '25' EXCHANGERATE,
                                         '26' EXCHANGEAMT ,
                                         '30' DESCRIPTION,
                                         '88' CUSTODYCD)
                       )
                       ORDER BY TXNUM
                    )
                ) TL
                  JOIN DDMAST DD1 ON DD1.ACCTNO = TL.DDACCTNO AND DD1.CCYCD ='USD' 
                  JOIN DDMAST DD2 ON DD2.ACCTNO = TL.DDACCTNO1 AND DD2.CCYCD ='VND'
                  JOIN CFMAST CF ON CF.CUSTODYCD = TL.CUSTODYCD
             WHERE TL.TXDATE = v_TranDate
                   AND TL.CUSTODYCD LIKE v_CustodyCD
             GROUP BY CF.FULLNAME, CF.CIFID, TL.EXCHANGERATE, TL.DESCRIPTION;

EXCEPTION
  WHEN OTHERS
   THEN
   DBMS_OUTPUT.PUT_LINE('OD6017_1 ERROR');
   PLOG.ERROR('OD6017_1: - ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RETURN;
END;
/
