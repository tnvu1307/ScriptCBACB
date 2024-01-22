SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE ba6003 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   PV_TCPH                IN       VARCHAR2,
   PV_SYMBOL              IN       VARCHAR2,
   I_DATE                 IN       VARCHAR2,
   PV_CUSTODYCD           IN       VARCHAR2,
   PV_TXNUM               IN       VARCHAR2 /*SO CHUNG TU*/
)
IS
    -- person      date                 comments
    -- ---------   ------               -------------------------------------------
    -- NAM.LY     15-03-2020            MODIFIED
   V_SYMBOL               VARCHAR2 (20);
   V_CUSTODYCD            VARCHAR2 (15);
   V_TCPH                 VARCHAR2 (15);
   V_IDATE                DATE;
   V_STROPTION            VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID              VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0
   v_TXNUM                VARCHAR2(10);
   v_ReportDate           DATE;
   v_HEADOFFICE        varchar2(200);
   v_HEADOFFICE_EN     varchar2(200);
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
    IF  (PV_CUSTODYCD <> 'ALL') THEN
        V_CUSTODYCD := PV_CUSTODYCD;
    ELSE
        V_CUSTODYCD := '%';
    END IF;
--------------------------------------------
    IF  (PV_TXNUM IS NOT NULL) THEN
        v_TXNUM := PV_TXNUM;
    ELSE
        v_TXNUM := '......';
    END IF;
--------------------------------------------
    V_SYMBOL      := PV_SYMBOL;
    V_TCPH        := PV_TCPH;
    V_IDATE       := TO_DATE(I_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_ReportDate  := getcurrdate;

--------------------------------------------------------------------------
  Select max(case when  varname='HEADOFFICE' then varvalue else '' end),
           max(case when  varname='HEADOFFICE_EN' then varvalue else '' end)
     into v_HEADOFFICE,v_HEADOFFICE_EN
    from sysvar WHERE varname IN ('HEADOFFICE','HEADOFFICE_EN');
--------------------------------------------------------------------------
 OPEN PV_REFCURSOR
 FOR
       SELECT v_TXNUM AS CT
            ,v_ReportDate AS REPORTINGDATE
            ,HD.FULLNAME AS TEN_TRAICHU                              --TEN TRAI CHU
            ,SB.CONTRACTNO                                          --SO HD
            ,SB.CONTRACTDATE                                        --NGAY KY
            ,ISS.SHORTNAME                                          --TEN VIET TAT TCPH
            ,ISS.FULLNAME AS NAME_TCPH                              --FULL NAME TCPH
            ,SB.THIRDPARTNER                                        --BEN THU 3
            ,SB.ISSUEDATE                                           --NGAY PHAT HANH TRAI PHIEU
            ,SB.EXPDATE                                             --NGAY DAO HAN TP
            ,to_char(utils.so_thanh_chu(nvl(sb.VALUEOFISSUE,0))) as VALUEOFISSUE --GIA TRI PHAT HANH CUA MA TP
            ,SB.INTCOUPON                                           --LAI XUAT
            ,BO.RECORDDATE                                          --NGAY DANG KY CUOI CUNG
            ,A0.Cdcontent PERIODINTEREST                            --DINH KY LAI
            ,TO_CHAR(BO.BEGINDATE,'DD/MM/RRRR') ||' đến '|| TO_CHAR(V_IDATE,'DD/MM/RRRR') AS NGAY_TINH_LAI_VA_THANH_TOAN --NGAY BAT DAU TINH LAI VA THANH TOAN
            ,MONTHS_BETWEEN(TO_DATE(TO_CHAR(V_IDATE,'MM/RRRR'),'MM/RRRR'),TO_DATE(TO_CHAR(BO.BEGINDATE,'MM/RRRR'),'MM/RRRR')) AS NUM_OF_MONTH
            ,BO.PAYMENTDATE                                         --NGAY THANH TOAN
            ,BO.ACTUALPAYDATE                                       --NGAY THUC THANH TOAN
            ,getprevdate(BO.ACTUALPAYDATE,3) as NGAY_CUOI_CUNG_CONG_BA  --NGAY DANG KY CUOI CUNG +3
            ,(CASE WHEN SUBSTR(NVL(CF.CUSTODYCD ,''),4,1)='F' THEN  CF.TRADINGCODE ELSE TO_CHAR(NVL(CF.IDCODE,'')) END) IDCODE      --MSGD
            ,(CASE WHEN SUBSTR(NVL(CF.CUSTODYCD ,''),4,1)='F' THEN  CF.TRADINGCODEDT ELSE TO_DATE(NVL(CF.IDDATE,'')) END) IDDATE    --NGAY CAP
            ,CF.IDPLACE                                             --NOI CAP
            ,SB.SYMBOL AS MA_TP                                     --TEN VIET TAC TCPH
            ,BO.BEGINDATE AS BAT_DAU_TINH_LAI                       --NGAY ABT DAU TINH LAI
            ,BO.ACTUALPAYDATE - BO.BEGINDATE AS SO_NGAY_LAI         --SO NGAY LAI
            ,HD.Netamount  --LAI
            ,CASE
                   WHEN CA.CATYPE ='015' THEN ' Ngày ĐKCC thanh toán lãi trái phiếu định kỳ'
                   WHEN CA.CATYPE ='016' THEN ' Ngày ĐKCC thanh toán gốc và lãi trái phiếu định kỳ'
                   ELSE 'Xác nhận Chủ Sở hữu Trái phiếu'
             END CATYPE
            ,CASE
                 WHEN SUBSTR(CF.CUSTODYCD,1,3)='SHV' THEN  DD.REFCASAACCT
                 ELSE  CFO.BANKACC
             END SO_TAI_KHOAN
            ,CASE
                 WHEN SUBSTR(CF.CUSTODYCD,1,3)='SHV' THEN v_HEADOFFICE
                 ELSE CFO.BANKACNAME
             END NGAN_HANG,
             CASE
                WHEN CA.CATYPE ='015' THEN 'Thanh toán Lãi trái phiếu '||CA.OPTSYMBOL
                WHEN CA.CATYPE ='016' THEN 'Thanh toán Gốc và Lãi trái phiếu '||CA.OPTSYMBOL
                ELSE 'Thanh toán tiền lãi trái phiếu ' ||CA.OPTSYMBOL
              END TT
        FROM BONDCASCHD HD, CAMAST CA, SBSECURITIES SB, BONDTYPEPAY BO, ISSUERS ISS, CFMAST CF
            , (SELECT * FROM ALLCODE WHERE CDTYPE = 'CB' AND CDNAME = 'PERIODINTEREST') A0
            , (SELECT * FROM DDMAST DD WHERE DD.ISDEFAULT = 'Y' AND DD.STATUS <> 'C') DD
            , (SELECT * FROM CFOTHERACC CF WHERE CF.Defaultacct = 'Y') CFO
        WHERE HD.CAMASTID = CA.CAMASTID
         AND CA.CODEID = SB.CODEID
         AND CA.CODEID = BO.BONDCODE
         AND SB.ISSUERID = ISS.ISSUERID
         AND HD.CUSTODYCD = CF.CUSTODYCD
         AND HD.Custodycd = DD.Custodycd(+)
         AND CF.Custid = CFO.Cfcustid(+)
         AND SB.Periodinterest = A0.Cdval
         AND ISS.SHORTNAME  LIKE V_TCPH
         AND HD.Custodycd LIKE V_CUSTODYCD
         AND SB.SECTYPE IN('003','006')
         AND SB.CONTRACTNO IS NOT NULL
         AND SB.SYMBOL LIKE V_SYMBOL
         AND BO.PAYMENTDATE = V_IDATE;
EXCEPTION
   WHEN OTHERS
   THEN
      PLOG.ERROR ('BA6003: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RETURN;
END;
/
