SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE ba6020 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,


   PV_SYMBOL      IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2
)
IS

   V_SYMBOL     VARCHAR2 (20);
   V_CUSTODYCD  VARCHAR2 (15);


   V_STROPTION         VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID           VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0

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
   IF  (PV_CUSTODYCD <> 'ALL')
   THEN
         V_CUSTODYCD := PV_CUSTODYCD;
   ELSE
        V_CUSTODYCD := '%';
   END IF;
--------------------------------------------
   IF  (PV_SYMBOL <> 'ALL')
   THEN
         V_SYMBOL := PV_SYMBOL;
   ELSE
      V_SYMBOL := '%';
   END IF;
 --------------------------------------------


 OPEN PV_REFCURSOR
 FOR
       SELECT   ISS.FULLNAME AS NAME_TCPH
               ,ISS.EN_FULLNAME AS NAME_TCPH_EN
               ,ISS.ADDRESS AS DIA_CHI
               ,CF.MOBILESMS AS SO_DT
               ,CF.FAXNO AS FAX
               ,ISS.EN_OFFICENAME
               ,ISS.EN_ADDRESS
               ,CF.FULLNAME AS TEN_TRAICHU --TEN TRAI CHU
               ,CASE WHEN CF.CUSTATCOM = 'N' THEN CF.INTERNATION ELSE CF.FULLNAME END AS TEN_TRAICHU_EN
               ,CF.ADDRESS AS DIA_CHI_TRAI_CHU
               ,CF.BANKATADDRESS AS DIA_CHI_TRAI_CHU_EN
               ,CF.IDCODE AS SO_DKKD    --SO DANG KY KINH DOANH
               ,CF.IDDATE AS NGAY_CAP_DKKD
               ,CF.IDPLACE AS NOI_CAP_DKKD
               ,BO.CUSTODYCD
               ,EXTRACT(YEAR FROM SB.ISSUEDATE) AS NAM_PHAT_HANH_TP   --NGAY PHAT HANH TRAI PHIEU
               ,SB.ISSUEDATE AS NGAY_PHAT_HANH_TP   --NGAY PHAT HANH TRAI PHIEU
               ,SB.SYMBOL
               ,SB.SECTYPE
               ,SB.EXPDATE AS NGAY_DAO_HAN
               ,REPLACE(TO_CHAR(SB.PARVALUE, 'FM999,999,999,999,999'),',','.') AS MENH_GIA_TP
               ,TO_CHAR(SB.PARVALUE, 'FM999,999,999,999,999') AS MENH_GIA_TP_EN
               ,lower(A1.CDCONTENT) DINH_KY_LAI  --DINH KY LAI
               ,lower(A1.EN_CDCONTENT)DINH_KY_LAI_EN  --DINH KY LAI
               ,REPLACE(TO_CHAR(BO.TRADE, 'FM999,999,999,999,999'),',','.') AS SO_LUONG
               ,TO_CHAR(BO.TRADE, 'FM999,999,999,999,999') AS SO_LUONG_EN
               ,REPLACE(TO_CHAR(SB.INTCOUPON, 'FM999,999.099'),'.',',') AS LAI_SUAT   --LAI XUAT
               ,TO_CHAR(SB.INTCOUPON, 'FM999,999.099') AS LAI_SUAT_EN
               ,REPLACE(TO_CHAR(NVL(SB.PARVALUE,0)*NVL(BO.TRADE,0), 'FM999,999,999,999,999'),',','.') AS TONG_MENH_GIA
               ,TO_CHAR(NVL(SB.PARVALUE,0)*NVL(BO.TRADE,0), 'FM999,999,999,999,999') AS TONG_MENH_GIA_EN
               ,SB.TERM || ' '|| TR.CDCONTENT   AS KY_HAN_TP
               ,CASE
                    WHEN SB.TERM > 1 THEN SB.TERM  || ' '|| TR.EN_CDCONTENT||'s'
                    ELSE SB.TERM  || ' '|| TR.EN_CDCONTENT
                END AS KY_HAN_TP_EN

        FROM SBSECURITIES SB,ISSUERS ISS,CFMAST CF,BONDSEMAST BO,
               ( SELECT CDVAL, CDCONTENT, EN_CDCONTENT
                FROM ALLCODE
                WHERE CDNAME='TYPETERM' AND CDTYPE='SA' ORDER BY LSTODR
               )TR,
               ( SELECT CDVAL, CDCONTENT, EN_CDCONTENT
                FROM ALLCODE
                WHERE CDNAME='PERIODINTEREST' AND CDTYPE='CB' ORDER BY LSTODR
               )A1
        WHERE BO.CUSTODYCD = CF.CUSTODYCD
              AND SB.ISSUERID = ISS.ISSUERID
              AND SB.CODEID = BO.BONDCODE
              AND SB.TYPETERM = TR.CDVAL
              AND SB.PERIODINTEREST = A1.CDVAl
              AND BO.CUSTODYCD LIKE  V_CUSTODYCD
              AND BO.BONDSYMBOL LIKE V_SYMBOL
              AND SB.ISSUEDATE IS NOT NULL
        ;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/
