SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf1003 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   F_CUSTODYCD    IN       VARCHAR2,
   TLID            IN       VARCHAR2
  )

IS
--

-- Danh sach dang ky mo TK GD co thong tin nha dau tu
-- MODIFICATION HISTORY
-- PERSON       DATE                COMMENTS
-- ---------   ------  -------------------------------------------
-- TUNH        13-05-2010           CREATED
--

   V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (4);                   -- USED WHEN V_NUMOPTION > 0
   V_STRCUSTODYCD VARCHAR2(10);
   v_TxDate date;
   V_STRTLID           VARCHAR2(6);

BEGIN

  V_STRTLID:= TLID;
V_STROPTION := OPT;
IF V_STROPTION = 'A' then
    V_STRBRID := '%';
ELSIF V_STROPTION = 'B' then
    V_STRBRID := substr(BRID,1,2) || '__' ;
else
    V_STRBRID:=BRID;
END IF;

V_STRCUSTODYCD:=F_CUSTODYCD;
IF V_STRCUSTODYCD = 'ALL' THEN
    V_STRCUSTODYCD:='%';
END IF;

v_TxDate:= to_date(F_DATE,'DD/MM/RRRR');


-- Main report
OPEN PV_REFCURSOR FOR

select DISTINCT cf.custid, cf.custodycd, cf.fullname,
    case when substr(cf.custodycd,4,1) = 'C' then to_char(idcode) else tradingcode end idcode,
    case when substr(cf.custodycd,4,1) = 'C' then iddate else tradingcodedt end iddate,
    idplace, CF.COUNTRY, --A2.CDCONTENT country,
    case when substr(cf.custodycd,4,1) = 'F' then 2
         else
            case when A1.cdval = '001' then 1
                 when A1.cdval = '002' then 2
                 when A1.cdval = '005' then 3
                 else                       4
            end
    end idtype,
    case when cf.custtype = 'I' and substr(cf.custodycd,4,1) = 'C' then 3
         when cf.custtype = 'I' and substr(cf.custodycd,4,1) = 'F' then 4
         when cf.custtype = 'B' and substr(cf.custodycd,4,1) = 'C' then 5
         when cf.custtype = 'B' and substr(cf.custodycd,4,1) = 'F' then 6
    end holder_type,
    cf.address, cf.mobile, cf.email

from cfmast cf, allcode A1, maintain_log log, allcode A2
where cf.idtype = A1.cdval and A1.cdtype = 'CF' and A1.cdname = 'IDTYPE'
    and A2.cdtype = 'CF' and A2.cdname = 'COUNTRY' AND A2.CDVAL = CF.COUNTRY
    and custodycd is not null
    AND CUSTODYCD LIKE V_STRCUSTODYCD
    --and af.opndate = v_TxDate
    and cf.status='A'
   -- and CF.OPNDATE BETWEEN TO_DATE(F_DATE ,'DD/MM/YYYY') AND TO_DATE(T_DATE ,'DD/MM/YYYY')
    AND log.table_name='CFMAST'
    AND log.action_flag in ('ADD','EDIT')
    AND log.column_name='CUSTODYCD'
    AND SUBSTR(log.record_key,11,10)=cf.custid
    AND log.approve_dt >= TO_DATE(F_DATE ,'DD/MM/YYYY') AND log.approve_dt <= TO_DATE(T_DATE ,'DD/MM/YYYY')
    AND nvl(child_table_name,'a') ='a'
   -- and exists (select gu.grpid from tlgrpusers gu where cf.careby = gu.grpid and gu.tlid = V_STRTLID )

union all

select DISTINCT cf.custid, cf.custodycd, cf.fullname,
    case when substr(cf.custodycd,4,1) = 'C' then to_char(idcode) else tradingcode end idcode,
    case when substr(cf.custodycd,4,1) = 'C' then iddate else tradingcodedt end iddate,
    idplace, CF.COUNTRY, --A2.CDCONTENT country,
    case when substr(cf.custodycd,4,1) = 'F' then 2
         else
            case when A1.cdval = '001' then 1
                 when A1.cdval = '002' then 2
                 when A1.cdval = '005' then 3
                 else                       4
            end
    end idtype,
    case when cf.custtype = 'I' and substr(cf.custodycd,4,1) = 'C' then 3
         when cf.custtype = 'I' and substr(cf.custodycd,4,1) = 'F' then 4
         when cf.custtype = 'B' and substr(cf.custodycd,4,1) = 'C' then 5
         when cf.custtype = 'B' and substr(cf.custodycd,4,1) = 'F' then 6
    end holder_type,
    cf.address, cf.mobile, cf.email

from cfmast cf,allcode A1, afmast af, ALLCODE A2,
(   select msgacct acctno from tllogall where tltxcd = '0067' and txdate BETWEEN TO_DATE(F_DATE ,'DD/MM/YYYY') AND TO_DATE(T_DATE ,'DD/MM/YYYY')
        union all
    select msgacct acctno  from tllog where tltxcd = '0067' and txdate BETWEEN TO_DATE(F_DATE ,'DD/MM/YYYY') AND TO_DATE(T_DATE ,'DD/MM/YYYY')
) tl

where cf.idtype = A1.cdval and A1.cdtype = 'CF' and A1.cdname = 'IDTYPE'
    and A2.cdtype = 'CF' and A2.cdname = 'COUNTRY' AND A2.CDVAL = CF.COUNTRY
    and cf.custid=af.custid and af.acctno = tl.acctno
    and custodycd is not null
    AND CUSTODYCD LIKE V_STRCUSTODYCD
    --and af.opndate = v_TxDate
    and cf.status='A'
   -- and exists (select gu.grpid from tlgrpusers gu where af.careby = gu.grpid and gu.tlid = V_STRTLID )



order by custodycd;



EXCEPTION
  WHEN OTHERS
   THEN
      RETURN;
END;
 
 
/
