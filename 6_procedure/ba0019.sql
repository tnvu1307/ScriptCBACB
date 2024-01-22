SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE ba0019(
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,

   I_DATE                 IN       VARCHAR2,
   PV_ISSUERS             IN       VARCHAR2,
   P_CONTRACT             IN       VARCHAR2,
   PV_SYMBOL              IN       VARCHAR2
   )
IS
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0
    V_IDATE         DATE;
    V_currdate      DATE;
    V_ISSUER        VARCHAR(20);
    V_CONTRACTNO    VARCHAR(20);
    V_SYMBOL        VARCHAR(20);
BEGIN
     V_STROPTION := OPT;
     IF V_STROPTION = 'A' THEN
        V_STRBRID := '%';
     ELSIF V_STROPTION = 'B' THEN
        V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
     ELSE
        V_STRBRID:=BRID;
     END IF;

    V_currdate := GETCURRDATE;
    IF(PV_SYMBOL='ALL') THEN
        V_SYMBOL:='%';
    ELSE
        V_SYMBOL:=PV_SYMBOL;
    END IF;
    V_ISSUER:= PV_ISSUERS;
    V_CONTRACTNO:=P_CONTRACT;
    V_IDATE := TO_DATE(I_DATE, SYSTEMNUMS.C_DATE_FORMAT);
OPEN PV_REFCURSOR FOR
    SELECT  V_IDATE createdate,
            iss.fullname fullnamebond, --ten TCPH
            sb.contractno, --so hop dong
            sb.contractdate, --ngay hop dong
            sb.thirdpartner,
            sb.symbol, --ma trai phieu
            sb.issuedate, -- ngay phat hanh
            sb.expdate, -- ngay dao han
            to_char(utils.so_thanh_chu(nvl(sb.VALUEOFISSUE,0))) as VALUEOFISSUE, --gia tri phat hanh
            sb.parvalue, -- menh gia
            sb.intcoupon, -- lai suat
            cf.fullname, --ten KH
            (case when cf.country ='234' then cf.idcode else cf.tradingcode end) idcode,
            (case when cf.country ='234' then cf.iddate else cf.tradingcodedt end) iddate,
            cf.idplace,--noi cap giay to
            cf.address,--dia chi KH
            bse.blocked,--SL trai phieu nam giu cua trai chu tai ngay tao bao cao
            bse.trade,
            bse.bondsymbol--ma trai phieu nam giu
            --btp.begindate  --ngay phat hanh
        from sbsecurities sb, issuers iss, cfmast cf, afmast af, bondsemast bse --, bondtype btp
        where sb.issuerid = iss.issuerid
        --and iss.custid =cf.custid
        and cf.custid =af.custid
        and af.acctno = bse.afacctno
        --and bse.bondcode = btp.bondcode
        AND BSE.bondcode= SB.codeid
        --and sb.contractno is not null
            and iss.shortname LIKE V_ISSUER
            and sb.symbol LIKE V_SYMBOL
            and sb.contractno LIKE V_CONTRACTNO
        ;
EXCEPTION
  WHEN OTHERS
   THEN
      PLOG.ERROR ('BA0019: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RETURN;
END;
/
