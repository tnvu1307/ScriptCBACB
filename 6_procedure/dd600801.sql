SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE dd600801(
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
    -- Fee - Safe custody fee details (for VSD fee checking)
    -- person      date                 comments
    -- ---------   ------               -------------------------------------------
    -- thoai.tran   09-07-2020           created
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0

    v_FromDate          date;
    v_ToDate            date;
    v_CurrDate          date;
    v_Nextdate          date;
    v_Prevdate          date;
    V_AMC           VARCHAR2(20);
    V_CUSTODYCD     VARCHAR2(20);
    V_AMT_A             NUMBER;
    V_AMT_B             NUMBER;

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
    v_varvalue           varchar2(10);
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
    v_Prevdate  := fn_get_prevdate(v_FromDate,1);
    v_Nextdate  := fn_get_nextdate(v_FromDate,1);
    select varvalue into v_varvalue from sysvar where varname='DEALINGCUSTODYCD';
--------------------------------------------------------------------------------
/*delete from sedepobal_tmp1;
BEGIN
for rec IN (
    SELECT DISTINCT acctno,QTTY,AMT,txdate,DAYS FROM (
        Select DISTINCT sd.acctno,  sd.qtty,sd.amt,sd.txdate,SD.DAYS
            from sedepobal sd, semast se, CFMAST cf,(select * from famembers where roles ='AMC')fa
            where sd.acctno = se.acctno
                    and se.custid= cf. custid
                    and cf.custatcom ='Y'
                    and cf.amcid = fa.autoid(+)
                    and cf.custodycd like V_CUSTODYCD
                    and nvl(fa.shortname,'%') like V_AMC
                    and sd.txdate >=v_FromDate and sd.txdate<=v_ToDate
                    AND (CASE WHEN P_CLIENTGR = '1' AND CF.BONDAGENT = 'Y' THEN 1
                          WHEN P_CLIENTGR = '2' AND CF.SUPEBANK = 'Y' THEN 1
                          WHEN P_CLIENTGR = '3' AND (CF.BONDAGENT = 'N' OR CF.SUPEBANK = 'N') THEN 1
                          WHEN P_CLIENTGR = 'ALL' THEN 1
                          ELSE 0 END) = 1
            UNION ALL
            Select DISTINCT sd.acctno,sd.qtty,sd.amt,sd.txdate,SD.DAYS
            from sedepobal sd, semast se, CFMAST cf,(select * from famembers where roles ='AMC')fa,(
                Select se.acctno,MAX(sd.txdate) txdate
                from sedepobal sd, semast se, CFMAST cf,(select * from famembers where roles ='AMC')fa
                where sd.acctno = se.acctno
                and se.custid= cf. custid
                and cf.custatcom ='Y'
                and cf.amcid = fa.autoid(+)
                and cf.custodycd like V_CUSTODYCD
                and nvl(fa.shortname,'%') like V_AMC
                and sd.txdate <=v_FromDate
                AND (CASE WHEN P_CLIENTGR = '1' AND CF.BONDAGENT = 'Y' THEN 1
                    WHEN P_CLIENTGR = '2' AND CF.SUPEBANK = 'Y' THEN 1
                    WHEN P_CLIENTGR = '3' AND (CF.BONDAGENT = 'N' OR CF.SUPEBANK = 'N') THEN 1
                    WHEN P_CLIENTGR = 'ALL' THEN 1
                    ELSE 0 END) = 1
                GROUP BY se.acctno
            ) seTMP
            where sd.acctno = se.acctno
            and se.custid= cf. custid
            and cf.custatcom ='Y'
            and cf.amcid = fa.autoid(+)
            and cf.custodycd like V_CUSTODYCD
            and nvl(fa.shortname,'%') like V_AMC
            and sd.txdate =seTMP.txdate
            AND se.acctno =seTMP.acctno
            AND (CASE WHEN P_CLIENTGR = '1' AND CF.BONDAGENT = 'Y' THEN 1
              WHEN P_CLIENTGR = '2' AND CF.SUPEBANK = 'Y' THEN 1
              WHEN P_CLIENTGR = '3' AND (CF.BONDAGENT = 'N' OR CF.SUPEBANK = 'N') THEN 1
              WHEN P_CLIENTGR = 'ALL' THEN 1
              ELSE 0 END) = 1
    )
)
loop
 if REC.DAYS =1 then
   insert INTO sedepobal_tmp1(acctno,txdate,days,qtty,amt) VALUES(REC.acctno,REC.txdate,REC.days,REC.qtty,REC.amt);
 else
   FOR TMP IN 0..REC.days-1
   LOOP
    insert INTO sedepobal_tmp1(acctno,txdate,days,qtty,amt)
    VALUES (REC.acctno,REC.txdate+TMP,1,REC.qtty,REC.amt/REC.DAYS);
   END LOOP;
 end if;
end loop;
END;*/
OPEN PV_REFCURSOR FOR
    with tpmSedByACCTNO as (
        Select sd.acctno,  sum(sd.qtty) QTTY, sum(sd.amt) AMT,sd.txdate
        from (SELECT DISTINCT acctno,QTTY,AMT,txdate,DAYS FROM sedepobal_report) sd, semast se, CFMAST cf,(select * from famembers where roles ='AMC')fa
        where sd.acctno = se.acctno
        and se.custid= cf. custid
        and cf.custatcom ='Y'
        and cf.amcid = fa.autoid(+)
        and cf.custodycd like V_CUSTODYCD
        and nvl(fa.shortname,'%') like V_AMC
        and sd.txdate >=v_FromDate and sd.txdate<=v_ToDate
        AND (CASE WHEN P_CLIENTGR = '1' AND CF.BONDAGENT = 'Y' THEN 1
              WHEN P_CLIENTGR = '2' AND CF.SUPEBANK = 'Y' THEN 1
              WHEN P_CLIENTGR = '3' AND (CF.BONDAGENT = 'N' OR CF.SUPEBANK = 'N') THEN 1
              WHEN P_CLIENTGR = 'ALL' THEN 1
              ELSE 0 END) = 1
        Group by sd.acctno,sd.txdate
    ),
    tmpSED_A as (
        Select cf.mcustodycd,cf.mcifid,cf.custodycd,cf.country,cf.cifid, cf.fullname, decode(cf.IDTYPE,'009',decode(substr(cf.custodycd,0,4),v_varvalue,'P','F'),decode(substr(cf.custodycd,0,4),v_varvalue,'P','D')) cfType, sb.sectype, sed.acctno, sed.qtty, sed.amt,sed.txdate
        from tpmSedByACCTNO sed
        inner join semast se on se.acctno = sed.acctno
        inner join CFMAST cf on se.custid= cf.custid
            AND (CASE WHEN P_CLIENTGR = '1' AND CF.BONDAGENT = 'Y' THEN 1
                  WHEN P_CLIENTGR = '2' AND CF.SUPEBANK = 'Y' THEN 1
                  WHEN P_CLIENTGR = '3' AND (CF.BONDAGENT = 'N' OR CF.SUPEBANK = 'N') THEN 1
                  WHEN P_CLIENTGR = 'ALL' THEN 1
                  ELSE 0 END) = 1
        inner join SBSECURITIES sb on se.codeid=sb.codeid
        where sb.sectype in ('001','002','011','008') --CP,CCQ, CW DAM BAO
            and sb.tradeplace in ('001','002','005','010','003','006')--TriBui 03/07/2020 San HOSE,HNX,UPCOM,BOND,OTC,WFT
        and (case when sb.tradeplace <> '003' then 1
                when sb.tradeplace = '003' and sb.ISSEDEPOFEE='Y' THEN 1
                else 0 end)=1
        and sb.DEPOSITORY='001' --Thoai.tran SHBVNEX-1270 SHBVNEX-1268 020004: Custody place = "Depository center"
    ),
    tmpSED_B as (
        Select cf.mcustodycd,cf.mcifid,cf.custodycd,cf.country,cf.cifid, cf.fullname, decode(cf.IDTYPE,'009',decode(substr(cf.custodycd,0,4),v_varvalue,'P','F'),decode(substr(cf.custodycd,0,4),v_varvalue,'P','D')) cfType, sb.sectype, sed.acctno, sed.qtty, sed.amt,sed.txdate
        from tpmSedByACCTNO sed
        inner join semast se on se.acctno = sed.acctno
        inner join CFMAST cf on se.custid= cf.custid
            AND (CASE WHEN P_CLIENTGR = '1' AND CF.BONDAGENT = 'Y' THEN 1
                  WHEN P_CLIENTGR = '2' AND CF.SUPEBANK = 'Y' THEN 1
                  WHEN P_CLIENTGR = '3' AND (CF.BONDAGENT = 'N' OR CF.SUPEBANK = 'N') THEN 1
                  WHEN P_CLIENTGR = 'ALL' THEN 1
                  ELSE 0 END) = 1
        inner join SBSECURITIES sb on se.codeid=sb.codeid
        where sb.sectype in ('003','006') --TRAI PHIEU
            and sb.tradeplace in ('001','002','005','010','003','006','099')--TriBui 03/07/2020 San HOSE,HNX,UPCOM,BOND,OTC,WFT
            and (case when sb.tradeplace <> '003' then 1
                when sb.tradeplace = '003' and sb.ISSEDEPOFEE='Y' THEN 1
                else 0 end)=1
        and sb.DEPOSITORY='001' --Thoai.tran SHBVNEX-1270 SHBVNEX-1268 020004: Custody place = "Depository center"
    ),
    tmpSED_C as (
        Select cf.mcustodycd,cf.mcifid,cf.custodycd,cf.country,cf.cifid, cf.fullname, decode(cf.IDTYPE,'009',decode(substr(cf.custodycd,0,4),v_varvalue,'P','F'),decode(substr(cf.custodycd,0,4),v_varvalue,'P','D')) cfType, sb.sectype, sed.acctno, sed.qtty, sed.amt,sed.txdate
        from tpmSedByACCTNO sed
        inner join semast se on se.acctno = sed.acctno
        inner join CFMAST cf on se.custid= cf.custid
            AND (CASE WHEN P_CLIENTGR = '1' AND CF.BONDAGENT = 'Y' THEN 1
                  WHEN P_CLIENTGR = '2' AND CF.SUPEBANK = 'Y' THEN 1
                  WHEN P_CLIENTGR = '3' AND (CF.BONDAGENT = 'N' OR CF.SUPEBANK = 'N') THEN 1
                  WHEN P_CLIENTGR = 'ALL' THEN 1
                  ELSE 0 END) = 1
        inner join SBSECURITIES sb on se.codeid=sb.codeid
        where sb.sectype in ('012') --TINH PHIEU
            and sb.tradeplace in ('001','002','005','010','003','006')--TriBui 03/07/2020 San HOSE,HNX,UPCOM,BOND,OTC,WFT
            and (case when sb.tradeplace <> '003' then 1
                when sb.tradeplace = '003' and sb.ISSEDEPOFEE='Y' THEN 1
                else 0 end)=1
            and sb.DEPOSITORY='001' --Thoai.tran SHBVNEX-1270 SHBVNEX-1268 020004: Custody place = "Depository center"
    ),
    tmpFeeVSD as (
        Select mcustodycd,mcifid,custodycd,country,cifid,fullname, cfType,  qtty qttyA, 0 qttyB, 0 qttyC, amt,'A'sec,txdate
        from tmpSED_A
        union all
        Select mcustodycd,mcifid,custodycd,country,cifid,fullname, cfType, 0 qttyA, qtty qttyB, 0 qttyC, amt, 'B'sec,txdate
        from tmpSED_B
        union all
        Select mcustodycd,mcifid,custodycd,country,cifid,fullname, cfType, 0 qttyA, 0 qttyB, qtty qttyC, amt, 'C'sec,txdate
        from tmpSED_C
    ),
    tmpGroupFeeVSD as (
        Select cfType,sum(NVL(qttyA,0)) qttyA,sum(NVL(qttyB,0)) qttyB, sum(NVL(qttyC,0)) qttyC, sum(amt) amt
        from tmpFeeVSD
        group by cfType
    ),
    tmpNameOfAccount as (
        Select 'Domestic investors'  NameOfAccount,'D' cfType,1 LSTODR  from dual
        union all
        Select 'Foreign investors' NameOfAccount,'F' cfType,2 LSTODR from dual
        union all
        Select 'Proprietary trading'  NameOfAccount,'E' cfType,3 LSTODR  from dual
    )

     select A.*,A0.CDCONTENT DESCCOUNTRY from (
                select mcustodycd,mcifid,custodycd,country,cifid,fullname,txdate SBDATE, round(sum(qttyA)) qttyA,round(sum(qttyB)) qttyB,round(sum(qttyC)) qttyC,round(sum(amt),2) amt
                from tmpFeeVSD
                group by mcustodycd,mcifid,custodycd,country,cifid,fullname,txdate
            )A, (SELECT * FROM ALLCODE WHERE CDNAME='COUNTRY' AND CDTYPE='CF') A0
            WHERE  (qttyA<> 0 OR qttyB<>0 OR qttyC<> 0)
            AND A.COUNTRY = A0.CDVAL
            ORDER BY SBDATE;
EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('DD600801: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;
End;
/