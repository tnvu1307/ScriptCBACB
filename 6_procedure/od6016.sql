SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE OD6016 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   
   I_DATE         IN       VARCHAR2,
   PV_CUSTODYCD         IN       VARCHAR2

)
IS

------------------------------------------------------------
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (40);        -- USED WHEN V_NUMOPTION > 0
   V_INBRID           VARCHAR2 (4);

   V_INDATE         DATE;
   V_CUSTODYCD    VARCHAR2(20);


    v_HEADOFFICE_EN     varchar2(200);
    v_BRADDRESS_EN      varchar2(200);
    v_PHONE             varchar2(200);
    v_FAX               varchar2(200);

-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN

    V_STROPTION := OPT;
    IF V_STROPTION = 'A' THEN
        V_STRBRID := '%';
    ELSIF V_STROPTION = 'B' THEN
        V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
    ELSE
        V_STRBRID:=BRID;
    END IF;
    ------------------
   V_CUSTODYCD := REPLACE(PV_CUSTODYCD,'.',''); 
    IF (V_CUSTODYCD = 'ALL') THEN
        V_CUSTODYCD := '%';
     ELSE
        V_CUSTODYCD:= V_CUSTODYCD;
     END IF;
   -------------------
   V_INDATE := to_date(I_DATE,'DD/MM/YYYY');

Select 
           max(case when  varname='BRADDRESS_EN' then varvalue else '' end),
           max(case when  varname='HEADOFFICE_EN' then varvalue else '' end),
           max(case when  varname='PHONE' then varvalue else '' end),
           max(case when  varname='FAX' then varvalue else '' end)
into v_BRADDRESS_EN,v_HEADOFFICE_EN,v_PHONE,v_FAX
from sysvar WHERE varname IN ('BRADDRESS_EN','HEADOFFICE_EN','PHONE','FAX');

-- GET REPORT'S DATA
OPEN PV_REFCURSOR FOR
    SELECT --*
            TO_CHAR(sysdate,'DD/MM/YYYY') as CREATE_DATE
           ,v_HEADOFFICE_EN AS HEADOFFICE_EN
           ,v_BRADDRESS_EN AS  ADDRESS_EN
           ,v_PHONE AS PHONE
           ,v_FAX AS FAX
           ,A.CUSTODYCD --TK LUU KY
           ,A.TRADE_DATE --NGAY DAT LENH
           ,A.SEC_ID -- MA CK
           ,A.MEMBER_CMP CMPMEMBER -- Ten viet tat CTy CK (1)
           ,A.TRANS_TYPE --LOAI LENH
           ,A.PRICE_VSD  --GIA DAT LENH THEO FILE NGUON VSD
           ,A.QTTY_VSD  --KL DAT LENH THEO NGUON
           ,A.AMT_VSD  --GIA TRI LENH KHOP THEO NGUON VSD
           ,A.QTTY_CMP  --KL DAT LENH THEO NGUON CTCK
           ,A.AMT_CMP  --GIA TRI LENH KHOP THEO NGUON
           ,A.FEE_CMP  --PGI GD PHAI TRA CHO CTCK
           ,A.TAX_CMP -- THUE LENH BAN THEO NGUON CTCK
           ,A.SETTLE_DATE_CMP  --NGAY TTBT THEO CTCK
           ,A.SETTLE_DATE_CUST  --NGAY TTBT THEO KH
           ,A.QTTY_CUST  ----KL DAT LENH THEO NGUON KH
           ,A.AMT_CUST  --GIA TRI LENH KHOP THEO NGUON KH
           ,A.FEE_CUST  --PHI GIAO DICH TRA THEO NGUÔN KH
           ,A.TAX_CUST -- THUE LENH BAN THEO NGUON KHACH HANG
           ,A.STATUS  --TRANG TAI DOI CHIEU GIUA BA NGUON
           ,A.NOTE  --DIEN GIAI THANH PHAN DOI CHIEU KHONG KHOP
           ,'' AS CMP_VSD_BROKER_STS -- Trang thai doi chieu voi VSD (2)
           ,'' AS CMP_BROKER_CUSTOMER_STS -- Trang thai doi chieu voi VSD (3)  
    FROM compare_trading_result A
    WHERE A.CUSTODYCD LIKE V_CUSTODYCD  
        AND A.TRADE_DATE = V_INDATE     
;
 EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/
