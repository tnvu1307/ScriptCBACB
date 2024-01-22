SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf0003 (
   PV_REFCURSOR     IN OUT   PKG_REPORT.REF_CURSOR,
   OPT              IN       VARCHAR2,
   BRID             IN       VARCHAR2,
   PV_CUSTODYCD     IN       VARCHAR2,
   CI0003KEY        IN       VARCHAR2
       )
IS

    V_BRID              VARCHAR2(4);
    V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
   V_INBRID     VARCHAR2 (5);
    V_IDATE DATE;
    V_CUSTODYCD varchar2(10);
    v_COUNT  number;

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
   V_CUSTODYCD := upper(PV_CUSTODYCD);

OPEN PV_REFCURSOR FOR
    SELECT TL.OFULLNAME, TL.NFULLNAME, TL.OADDRESS, TL.NADDRESS,
        TL.OIDCODE, TL.NIDCODE, TL.OIDDATE, TL.NIDDATE, TL.OIDEXPIRED,
        TL.NIDEXPIRED, TL.OIDPLACE, TL.NIDPLACE, TL.OTRADINGCODE,
        TL.NTRADINGCODE, TL.OTRADINGCODEDT, TL.NTRADINGCODEDT, TL.TXDATE,
        TL.TXNUM, TL.CONFIRMTXDATE, TL.CONFIRMTXNUM,
        CF.FULLNAME, CF.IDCODE, CF.IDDATE, CF.IDPLACE, AL.CDCONTENT COUNTRY, CF.ADDRESS, CF.mobilesms MOBILE, CF.CUSTODYCD,
        tlg.txdesc,
        al2.cdcontent CUSTYPE,
        al3.cdcontent CUSTYPEDT
    FROM CFVSDLOG TL, CFMAST CF, ALLCODE AL, ALLCODE AL2, allcode al3,
        (
            select * from tllog
            union all
            select * from tllogall
        ) tlg
    WHERE TL.CUSTID = CF.CUSTID
        AND AL.CDTYPE = 'CF' AND AL.CDNAME = 'COUNTRY'
		and al2.cdname  like  'CUSTTYPE' and al2.cdtype = 'CF' and TL.OCUSTTYPE = al2.cdval
		and al3.cdname  like  'CUSTTYPE' and al3.cdtype = 'CF' and TL.NCUSTTYPE = al3.cdval
        AND CF.COUNTRY = AL.CDVAL(+)
        AND CF.CUSTODYCD LIKE V_CUSTODYCD
        AND TO_CHAR(TL.TXDATE,'DD/MM/RRRR')||TL.TXNUM = CI0003KEY
        and tl.txdate = tlg.txdate and tl.txnum = tlg.txnum
;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;

 
 
 
/
