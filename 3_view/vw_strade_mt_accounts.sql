SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_STRADE_MT_ACCOUNTS
(REFID, CITYEF, CITYBANK, AFACCTNO, TYPE, 
 REG_TYPE, EN_REG_TYPE, REG_CUSTID, REG_ACCTNO, REG_CUSTODYCD, 
 REG_BENEFICARY_NAME, REG_BENEFICARY_INFO, FEECD, FEENAME, FORP, 
 FEEAMT, FEERATE, MINVAL, MAXVAL, VATRATE, 
 ACNIDCODE, ACNIDDATE, ACNIDPLACE, CUSTODYCD, MTFRTIME, 
 MTTOTIME, TYPEMNEMONIC)
AS 
select rownum REFID,
     mst.cityef, mst.citybank, mst.afacctno, mst.type, mst.reg_type, mst.en_reg_type,
    mst.reg_custid, mst.reg_acctno, mst.reg_custodycd, mst.reg_beneficary_name,
    mst.reg_beneficary_info, mst.feecd, mst.feename, mst.forp, mst.feeamt, mst.feerate, mst.minval,
    mst.maxval, mst.vatrate, mst.acnidcode, mst.acniddate, mst.acnidplace,
    mst.custodycd, mst.mtfrtime, mst.MTTOTIME, mst.TYPEMNEMONIC
from
(
select MST.Cityef, MST.Citybank, afm.acctno AFACCTNO, MST.TYPE,
    (CASE WHEN MST.TYPE=1 THEN 'Ben ngoai' ELSE 'Noi bo' END) REG_TYPE,
    (CASE WHEN MST.TYPE=1 THEN 'External' ELSE 'Internal' END) EN_REG_TYPE,
    (CASE WHEN MST.TYPE=1 THEN MST.CUSTID ELSE AF.CUSTID END) REG_CUSTID,
    (CASE WHEN MST.TYPE=1 THEN MST.BANKACC ELSE MST.CIACCOUNT END) REG_ACCTNO,
    (CASE WHEN MST.TYPE=1 THEN '' ELSE AF.CUSTODYCD END) REG_CUSTODYCD,
    (CASE WHEN MST.TYPE=1 THEN MST.BANKACNAME ELSE TO_CHAR(AF.FULLNAME) END) REG_BENEFICARY_NAME,
    (CASE WHEN MST.TYPE=1 THEN MST.BANKNAME ELSE 'PHS' END) REG_BENEFICARY_INFO,
    FDEF.FEECD, FDEF.FEENAME, FDEF.FORP, FDEF.FEEAMT, FDEF.FEERATE, FDEF.MINVAL, FDEF.MAXVAL, FDEF.VATRATE,
    (CASE WHEN MST.TYPE=1 THEN MST.acnidcode ELSE to_char(AF.idcode) END) acnidcode,
    (CASE WHEN MST.TYPE=1 THEN MST.acniddate ELSE AF.iddate END) acniddate,
    (CASE WHEN MST.TYPE=1 THEN MST.acnidplace ELSE to_char(AF.idplace) END) acnidplace,
    cf.custodycd, var1.VARVALUE MTFRTIME, var2.VARVALUE MTTOTIME, af.TYPEMNEMONIC
FROM CFOTHERACC MST,
    (select cf.*, af.acctno, typ.MNEMONIC TYPEMNEMONIC from cfmast cf, afmast af, aftype typ where cf.custid = af.custid AND af.actype = typ.actype) AF,
    FEEMASTER FDEF , afmast afm, cfmast cf, sysvar var1, sysvar var2
WHERE MST.ciaccount = AF.acctno (+) AND MST.FEECD=FDEF.FEECD (+)
    AND afm.custid = mst.cfcustid AND cf.custid = afm.custid
    AND MST.DELTD = 'N'
    and mst.status ='A' --28/09/2015 TruongLD Add, Chi cho phep chuyen khoan doi voi TH trang thai A:Active
    and afm.acctno <> nvl(MST.CIACCOUNT,'A')
and var1.grname = 'STRADE' and var1.varname = 'MT_FRTIME'
and var2.grname = 'STRADE' and var2.varname = 'MT_TOTIME'
union
select null cityef, NULL  citybank, mst.acctno afacctno, '0' type, 'Noi bo' reg_type, 'Internal' en_reg_type,
    mst.custid reg_custid, af.acctno reg_acctno, af.custodycd reg_custodycd, af.fullname reg_beneficary_name,
    'PHS' reg_beneficary_info, NULL feecd, nULL feename, nULL forp, nULL feeamt, nULL feerate, null minval,
    null maxval, null vatrate, af.idcode acnidcode, af.iddate acniddate, af.idplace acnidplace,
    af.custodycd custodycd, var1.VARVALUE MTFRTIME, var2.VARVALUE MTTOTIME, af.TYPEMNEMONIC
from
(
    select cf.custodycd, af.acctno, cf.custid
    from afmast af, cfmast cf
    where af.custid = cf.custid and af.status = 'A'
) mst,
(
    select cf.custodycd, af.acctno, af.custid, cf.fullname, cf.idcode, cf.iddate, cf.idplace, typ.mnemonic TYPEMNEMONIC
    from afmast af, cfmast cf, aftype typ
    where af.custid = cf.custid and af.status = 'A' and af.actype = typ.actype
) af, sysvar var1, sysvar var2
where mst.custodycd = af.custodycd and mst.acctno <> af.acctno
    and var1.grname = 'STRADE' and var1.varname = 'MT_FRTIME'
    and var2.grname = 'STRADE' and var2.varname = 'MT_TOTIME'
union
select ls.regional cityef, ls.regional  citybank, af2.acctno afacctno, '1' type, 'Noi bo' reg_type, 'Internal' en_reg_type,
    af.custid reg_custid, af.bankacctno reg_acctno, cf.custodycd reg_custodycd, cf.fullname reg_beneficary_name,
    ls.bankname reg_beneficary_info, NULL feecd, nULL feename, nULL forp, nULL feeamt, nULL feerate, null minval,
    null maxval, null vatrate, cf.idcode acnidcode, cf.iddate acniddate, cf.idplace acnidplace,
    cf.custodycd custodycd, var1.VARVALUE MTFRTIME, var2.VARVALUE MTTOTIME, aft.mnemonic mnemonic
from afmast af , cfmast cf, aftype aft, sysvar var1, sysvar var2, crbbanklist ls, crbbankmap map, afmast af2
where af.corebank = 'N' and af.custid = cf.custid
    and af.alternateacct = 'Y' and af.actype = aft.actype
    and ls.bankcode= map.bankcode and map.bankid= substr(af.bankacctno,1,3)
    and var1.grname = 'STRADE' and var1.varname = 'MT_FRTIME'
    and var2.grname = 'STRADE' and var2.varname = 'MT_TOTIME'
    and af2.custid = cf.custid
)mst
/
