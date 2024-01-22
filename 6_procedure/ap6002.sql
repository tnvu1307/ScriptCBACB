SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE ap6002(
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   F_DATE                 IN       VARCHAR2, /*Tu ngay */
   T_DATE                 IN       VARCHAR2, /*den ngay */
   P_CUSTODYCD            IN       VARCHAR2, /*Ma KH tai ngan hang */
   P_CRPHYSAGREEID        IN       VARCHAR2 /*Ma hop dong*/
   )
IS
    -- Report on the day become/is no longer major shareholder, investors holding 5% or more of shares
    -- person      date                 comments
    -- Thoai.tran  26/05/2022            CREATED
    -- ---------   ------               -------------------------------------------
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0
    v_FromDate          date;
    v_ToDate            date;
    v_CurrDate          date;
    v_custodycd         varchar2(20);
    v_crphysagreeid     varchar2(20);
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
    if P_CUSTODYCD = 'ALL' then
        v_CustodyCD:='%';
    else
        v_CustodyCD:=P_CUSTODYCD;
    end if;

    if P_CUSTODYCD = 'ALL' then
        v_custodycd:='%';
    else
        v_custodycd:=P_CUSTODYCD;
    end if;

    if P_CRPHYSAGREEID = 'ALL' then
        v_crphysagreeid:='%';
    else
        v_crphysagreeid:=P_CRPHYSAGREEID;
    end if;
    v_FromDate  := TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_ToDate    := TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);
OPEN PV_REFCURSOR FOR
    select TO_CHAR(v_FromDate,'DD/MM/RRRR')||'-'||TO_CHAR(v_ToDate,'DD/MM/RRRR') FRTODATE,
    v_CurrDate CURRDATE,cr.crphysagreeid,cr.no,cr.CUSTODYCD,CF.FULLNAME CFFULLNAME,
    ISR.FULLNAME ISSUERFULLNAME,CR.SYMBOL,SB.ISSUEDATE,
    q05.qtty, q05.qtty*SB.PARVALUE AMT,DECODE(q05.status,'OPN',q05.OPNDATE,null) OPNDATE,
    DECODE(q05.status,'CLS',q05.CLSDATE,null) CLSDATE
    from
    (select *From CRPHYSAGREE where deltd <>'Y') CR,CFMAST CF,SBSECURITIES SB,ISSUERS ISR,
    ( select autoid,crphysagreeid,status,qtty,OPNDATE,CLSDATE,DECODE(status,'OPN',OPNDATE,CLSDATE) transferdate
    from docstransfer
    where status IN ('OPN','CLS') AND QTTY<>0) q05--1405 OPN/ 1406 CLS
    where CR.CUSTODYCD=CF.CUSTODYCD AND CR.CODEID = SB.CODEID
    AND SB.ISSUERID = ISR.ISSUERID and CR.STATUS='A'
    AND CR.CRPHYSAGREEID = q05.CRPHYSAGREEID
    and CR.CUSTODYCD LIKE v_custodycd
    AND CR.crphysagreeid LIKE v_crphysagreeid
    and q05.transferdate >= v_FromDate and q05.transferdate <= v_ToDate
    order by cr.CUSTODYCD,cr.crphysagreeid,q05.autoid desc;
EXCEPTION
WHEN OTHERS THEN
  plog.error ('AP6002: ' || SQLERRM || dbms_utility.format_error_backtrace);
  Return;
End;
/
