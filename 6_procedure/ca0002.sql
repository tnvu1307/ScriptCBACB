SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE ca0002(PV_REFCURSOR in out PKG_REPORT.REF_CURSOR,
                                   OPT          in varchar2,
                                   BRID         in varchar2,
                                   CACODE       in varchar2,
                                   AFACCTNO     in varchar2,
                                   CUSTTYPERPT  in varchar2) is
  --
  -- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
  -- BAO CAO TAI KHOAN TIEN TONG HOP CUA NGUOI DAU TU
  -- MODIFICATION HISTORY
  -- PERSON      DATE    COMMENTS
  -- NAMNT   20-DEC-06  CREATED
  -- ---------   ------  -------------------------------------------

  CUR           PKG_REPORT.REF_CURSOR;
  V_STROPTION   varchar2(5); -- A: ALL; B: BRANCH; S: SUB-BRANCH
  V_STRBRID     varchar2(4);
  V_STRCACODE   varchar2(20);
  V_STRAFACCTNO varchar2(20);
  V_STRAFACCTNOOUTPUT varchar2(20);
  V_STRCUSTTYPERPT varchar2(2);

  /*pkgctx plog.log_ctx;
  logrow tlogdebug%rowtype;*/
begin

  /*-- Initialization log
  for i in (select * from tlogdebug)
  loop
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  end loop;

  pkgctx := plog.init('ca0002',
                      plevel    => nvl(logrow.loglevel, 30),
                      plogtable => (nvl(logrow.log4table, 'N') = 'Y'),
                      palert    => (nvl(logrow.log4alert, 'N') = 'Y'),
                      ptrace    => (nvl(logrow.log4trace, 'N') = 'Y'));

  plog.setBeginSection(pkgctx, 'ca0002');*/
  V_STRAFACCTNOOUTPUT := AFACCTNO;
  V_STROPTION := OPT;

  if (V_STROPTION <> 'A') and (BRID <> 'ALL') then
    V_STRBRID := BRID;
  else
    V_STRBRID := '%%';
  end if;

  if (CACODE <> 'ALL') then
    V_STRCACODE := CACODE;
  else
    V_STRCACODE := '%%';
  end if;
  if (AFACCTNO <> 'ALL') then
    V_STRAFACCTNO := AFACCTNO;
  else
    V_STRAFACCTNO := '%%';
  end if;





  -- GET REPORT'S PARAMETERS

  --Tinh ngay nhan thanh toan bu tru

  open PV_REFCURSOR for
    select CACODE CACODEOUTPUT,V_STRAFACCTNOOUTPUT AFACCTNOOUTPUT,(SELECT CDCONTENT FROM ALLCODE WHERE  CDTYPE='CA' AND CDNAME = 'CUSTTYPERPT' AND CDVAL = CUSTTYPERPT) CUSTTYPERPTOUTPUT,
            --CUSTTYPERPT CUSTTYPERPT,cf.country,
           af.acctno, cf.custodycd, cf.fullname, cf.MOBILESMS MOBILE,
           (case when cf.country = '234' then cf.idcode else cf.tradingcode end) IDCODE,
           cas.balance SLCKSH,
           (case when nvl(mst.DEVIDENTRATE,cam.DEVIDENTRATE) = '0' and nvl(mst.DEVIDENTVALUE,cam.DEVIDENTVALUE) > 0
                 then TO_CHAR(nvl(mst.DEVIDENTVALUE,cam.DEVIDENTVALUE))
            else  nvl(mst.DEVIDENTRATE,cam.DEVIDENTRATE) || '' end)
            ||'/'||
            (case when cam.DEVIDENTRATE = '0' and cam.DEVIDENTVALUE > 0
                 then TO_CHAR(cam.DEVIDENTVALUE)
            else cam.DEVIDENTRATE || '%' end) DEVIDENTRATE,
           A0.cdcontent Catype,
           A1.cdcontent status, cam.camastid,
           (case
             when cf.VAT = 'Y' then
                (
                    case when cam.catype = '010' then
                            (
                                case when mst.typerate ='R'
                                        then round(cas.balance * se.parvalue * mst.devidentrate /100)
                                     else round(cas.balance * mst.devidentvalue)
                                end
                            ) * (1 - cam.pitrate/100)
                        else
                            (nvl(mst.amt,cas.amt) - round(cam.pitrate * nvl(mst.amt,cas.amt) / 100))
                    end
                )

             else
              nvl(mst.amt,cas.amt)
           end) amt,
           se.symbol, cam.REPORTDATE, af.status status_af,
           (case
             when cf.VAT <> 'Y' then
              0
             else
                case when cam.catype = '010' then
                         (
                             case when mst.typerate ='R'
                                     then round(cas.balance * se.parvalue * mst.devidentrate /100)
                                  else round(cas.balance * mst.devidentvalue)
                             end
                         ) * cam.pitrate/100
                     else
                         cam.pitrate * nvl(mst.amt,cas.amt) / 100
                 end

           end) thue,

           CAS.ISEXEC ISEXEC

      from (SELECT * FROM CASCHD UNION SELECT * FROM caschdhist) cas, sbsecurities se, vw_camast_all cam, afmast af, aftype aft,
            (
                select DISTINCT cad.*, csd.afacctno, csd.autoid_caschd, csd.amt, csd.aamt, csd.feeamt
                from vw_camastdtl_all cad, vw_caschddtl_all csd
                where cad.camastid = csd.camastid and cad.autoid = csd.autoid_camastdtl
            )mst,
           cfmast cf, allcode A0, Allcode A1
     where cas.codeid = se.codeid
       and cas.deltd <>'Y'
       and AF.ACTYPE     =  AFT.ACTYPE
       and cam.camastid = cas.camastid
       and cas.camastid = mst.camastid (+)
       and cas.autoid = mst.autoid_caschd (+)
       and cas.afacctno = mst.afacctno (+)
       and cas.afacctno = af.acctno
       and af.custid = cf.custid
       and a0.CDTYPE = 'CA'
       and a0.CDNAME = 'CATYPE'
       and a0.CDVAL = cam.CATYPE
       and A1.CDTYPE = 'CA'
       and A1.CDNAME = 'CASTATUS'
       --and A1.CDVAL = cas.STATUS
       and A1.CDVAL = (case when mst.status ='C' then cas.STATUS else 'I' End)
       and cam.CATYPE = '010'
       ---and cam.camastid like V_STRCACODE
      ---and cas.afacctno like V_STRAFACCTNO
       and 1= (case when CUSTTYPERPT='01' and cf.country = '234' then 1
       when  CUSTTYPERPT='02' and cf.country <> '234' then 1
       when  CUSTTYPERPT='00'  then 1 else 0  end)

     order by af.acctno, nvl(cas.autoid,0), nvl(mst.txdate,null), nvl(mst.autoid,0);
  /*plog.setEndSection(pkgctx, 'ca0002');*/

exception
  when others then
    /*plog.error(pkgctx, sqlerrm);
    plog.setEndSection(pkgctx, 'ca0002');*/
    return;
end; -- PROCEDURE
/
