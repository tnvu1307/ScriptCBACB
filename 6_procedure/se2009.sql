SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE se2009 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD      IN       VARCHAR2,
   PV_ACCTNO  IN       VARCHAR2,
   PV_TYPE in VARCHAR2,
   TLID            IN       VARCHAR2
  )
IS

   CUR            PKG_REPORT.REF_CURSOR;
   V_STROPT       VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (100);                   -- USED WHEN V_NUMOPTION > 0
   V_INBRID       VARCHAR2 (5);
   vn_BRID        varchar2(50);
   vn_TRADEPLACE varchar2(50);
   v_strTRADEPLACE VARCHAR2 (4);
   FDate date;
   TDate date;
   v_Symbol varchar2(20);
    V_TYPE varchar2(20);
    V_CUSTODYCD varchar2(20);
    V_ACCTNO varchar2(20);
    V_TLID varchar2(20);

BEGIN

    V_STROPT := upper(OPT);
    V_INBRID := BRID;
    if(V_STROPT = 'A') then
        V_STRBRID := '%';
    else
        if(V_STROPT = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := BRID;
        end if;
    end if;

    FDate:= to_date(F_DATE,'DD/MM/RRRR');
    TDate:= to_date(T_DATE,'DD/MM/RRRR');

IF  (PV_CUSTODYCD <> 'ALL')
THEN
      V_CUSTODYCD := upper(REPLACE (PV_CUSTODYCD,' ','_'));
ELSE
   V_CUSTODYCD := '%';
END IF;


if PV_ACCTNO = 'ALL' or PV_ACCTNO is null then
    V_ACCTNO := '%';
else
    V_ACCTNO := PV_ACCTNO;
end if;

if PV_TYPE = 'ALL' or PV_TYPE is null then
    V_TYPE := '%';
else
    V_TYPE := PV_TYPE;
end if;


if TLID = 'ALL' or TLID is null then
    V_TLID := '%';
else
    V_TLID := TLID;
end if;

-- Main report
OPEN PV_REFCURSOR FOR
    select FDate fdate,TDate tdate,tr.txdate,tr.busdate,tr.custodycd cfcustodycd,cf.fullname,sb.symbol,
        tr.tltxcd,
        --tr.txdesc,
        case when tr.tltxcd = '1143' and tr.txcd = '0077' then ' So tien den han phai thanh toan '
                when tr.tltxcd in ('1143','1153') and tr.txcd = '0011' and tr.txdesc is null then ' Phi ung truoc '
                when tr.tltxcd = '5566' then  tr.txdesc
                when tr.tltxcd = '2266' then utf8nums.c_const_RPT_CF1000_2266
                else to_char(decode(substr(tr.txnum,1,2),'68', tr.txdesc || ' (Online)',
                                                         '69',tr.txdesc || ' (Home)',
                                                         '99',tr.txdesc || ' (Auto)',
                                                         '70',tr.txdesc || ' (Mobile)',tr.txdesc))
           end txdesc,
        tlp.tlfullname,tr.namt amt,tr.txtype,
        (case when sb.refcodeid is null then
            (CASE WHEN tr.txcd = '0045' or TR.field='TRADE' THEN '1'
                when tr.tltxcd = '2259' and nvl(tr2259.setyp,2) = 1 then '1'
                WHEN tr.tltxcd = '2266' or TR.field='WITHDRAW' THEN '1'
                ELSE '2' END)
        else
            CASE WHEN tr.txcd = '0045' or TR.field='TRADE' THEN '7'
                when tr.tltxcd = '2259' and nvl(tr2259.setyp,2) = 1 then '7'
                WHEN tr.tltxcd = '2266' or TR.field='WITHDRAW' THEN '7'
                ELSE '8' END end  ) type
    from (
            SELECT tr.autoid,tr.txnum, tr.txdate,tr.busdate,tr.custodycd,tr.tltxcd,tr.txdesc,tr.namt,tr.txcd,tr.tlid,tr.codeid,tr.txtype,TR.afacctno,
                    TR.field
            FROM vw_setran_gen tr
            where ((tr.txcd in('0040','0045') and tr.tltxcd='2242')
                        or
                        (TR.tltxcd in('2201','2259') and TR.txtype='D' AND TR.TXCD in ('0042','0088'))
                        oR
                        TR.TLTXCD IN ('2266','2249')
                        OR
                        (TR.tltxcd='2246' and TR.txtype='C' AND TR.TXCD IN('0043','0012'))--'0052'
                        OR
                        (TR.tltxcd='2245' and TR.txtype='C' AND TR.TXCD IN('0012','0043'))
                        )
            --UNION ALL
            --SELECT txdate,busdate,cfcustodycd custodycd,tltxcd,txdesc,msgamt amt,'1100' txcd,tlid,ccyusage codeid,'D' txtype,msgacct afacctno
            --FROM vw_tllog_all WHERE TLTXCD='2249'

            UNION ALL
            SELECT tr.autoid, tr.txnum, tr.txdate,tr.busdate,tr.custodycd,'2249' tltxcd,tr.txdesc,tr.namt,tr.txcd,tr.tlid,tr.codeid,tr.txtype,TR.afacctno,
                    TR.field
            FROM vw_setran_gen tr
            WHERE TR.tltxcd='2247' AND TR.txtype='C' AND TR.TXCD='0040'

         ) tr,cfmast cf,sbsecurities sb,tlprofiles tlp,
         (
            select tr.txdate, tr.txnum, tltxcd, tr.busdate, max(decode(field,'WITHDRAW',1,2)) setyp
            from vw_setran_gen tr
            where tltxcd='2259'
            group by tr.txdate, tr.txnum, tltxcd, tr.busdate
         )tr2259
    where  tr.custodycd=cf.custodycd
    and sb.codeid=tr.codeid
    and tr.tlid=tlp.tlid
    and tr.txdate = tr2259.txdate(+)
    and tr.txnum = tr2259.txnum(+)
        ---and tr.busdate BETWEEN FDate and TDate
    ---and tr.custodycd like V_CUSTODYCD
    ---and tr.afacctno like V_ACCTNO
    ---and tr.txtype like V_TYPE
    ---and tr.tlid like V_TLID
    order by tr.autoid
    ;



EXCEPTION
  WHEN OTHERS
   THEN
   dbms_output.put_line('12233');
      RETURN;
END;
/
