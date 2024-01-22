SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE dd6003(
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   F_DATE                 IN       VARCHAR2, /*Tu ngay */
   T_DATE                 IN       VARCHAR2, /*den ngay */
   P_AMCCODE              IN       VARCHAR2, /*Ma AMC */
   PV_CUSTODYCD           IN       VARCHAR2, /*So TK Luu ky */
   P_CLIENTGR             IN       VARCHAR2  /*Loai KH 1,2,3,ALL */
   )
IS
    -- Report on the day become/is no longer major shareholder, investors holding 5% or more of shares
    -- person      date                 comments
    -- ---------   ------               -------------------------------------------
    -- du.phan    23-10-2019           created
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0

    v_FromDate          date;
    v_ToDate            date;
    v_CurrDate          date;
    v_Nextdate          date;
    v_Prevdate          date;
    V_AMC     VARCHAR2(20);
    V_CUSTODYCD     VARCHAR2(20);


    v_IA1               number;
    v_IA2               number;
    v_IA3               number;
    v_IB1               number;
    v_IB2               number;
    v_IB3               number;
    v_IC1               number;
    v_IC2               number;
    v_IC3               number;
    v_ID1               number;
    v_ID2               number;
    v_ID3               number;

    v_IIA1               number;
    v_IIA2               number;
    v_IIB1               number;
    v_IIB2               number;
    v_IIIA1               number;
    v_IIIA2               number;
    v_IIIB1               number;
    v_IIIB2               number;
BEGIN
     V_STROPTION := OPT;
     v_CurrDate   := getcurrdate;
     if v_stroption = 'A' then
        v_strbrid := '%';
     elsif v_stroption = 'B' then
        v_strbrid := substr(brid,1,2) || '__' ;
     else
        v_strbrid:=brid;
     end if;
     ----
     IF UPPER(P_AMCCODE) = 'ALL' THEN
        V_AMC := '%';
     ELSE
        V_AMC:= UPPER(P_AMCCODE);
     END IF;
     ----
     V_CUSTODYCD:= REPLACE(PV_CUSTODYCD,'.','');
     IF UPPER(V_CUSTODYCD) = 'ALL' THEN
        V_CUSTODYCD := '%';
     ELSE
        V_CUSTODYCD:= UPPER(V_CUSTODYCD);
     END IF;
    v_FromDate  := TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_ToDate    := TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);



OPEN PV_REFCURSOR FOR
Select   distinct
         'from '||TO_CHAR(V_FROMDATE,'DD/MM/RRRR')||' to '||TO_CHAR(V_TODATE,'DD/MM/RRRR') AS REPORT_PERIOD,
         CASE WHEN V_AMC ='%' THEN 'ALL' ELSE UPPER(FA.FULLNAME) END GROUP_NAME,
          getcurrdate
          from cfmast cf,
          (select * from famembers where roles ='AMC') fa
          where cf.custatcom ='Y'
          and cf.amcid = fa.autoid(+)
          and nvl(fa.shortname,'%') like V_AMC
          and cf.custodycd like V_CUSTODYCD
          AND (CASE WHEN P_CLIENTGR = '1' AND CF.BONDAGENT = 'Y' THEN 1
                  WHEN P_CLIENTGR = '2' AND CF.SUPEBANK = 'Y' THEN 1
                  WHEN P_CLIENTGR = '3' AND (CF.BONDAGENT = 'N' OR CF.SUPEBANK = 'N') THEN 1
                  WHEN P_CLIENTGR = 'ALL' THEN 1
                  ELSE 0 END) = 1;

EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('DD6003: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;
End;
/
