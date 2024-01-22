SET DEFINE OFF;
CREATE OR REPLACE PACKAGE cspks_cfproc
IS
    /*----------------------------------------------------------------------------------------------------
     ** Module   : COMMODITY SYSTEM
     ** and is copyrighted by FSS.
     **
     **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
     **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
     **    graphic, optic recording or otherwise, translated in any language or computer language,
     **    without the prior written permission of Financial Software Solutions. JSC.
     **
     **  MODIFICATION HISTORY
     **  Person      Date           Comments
     **  FSS      20-mar-2010    Created
     ** (c) 2008 by Financial Software Solutions. JSC.
     ----------------------------------------------------------------------------------------------------*/
    PROCEDURE pr_AFMAST_ChangeTypeCheck (p_afacctno in varchar2,p_actype in varchar2, p_err_code in out varchar2);

    FUNCTION fn_0088checkAFACCTNO (p_closetype in varchar2, p_afacctno in varchar2, p_setafacctno in varchar2) RETURN NUMBER;

    FUNCTION fn_0088checkAFCOUNT (p_closetype in varchar2, p_custodycd in varchar2) RETURN NUMBER;

    FUNCTION fn_0088getAFACCTNO (p_closetype in varchar2, p_custodycd in varchar2, p_afacctno in varchar2) RETURN varchar2;

    FUNCTION fn_0088getFEEDATE (p_closetype in varchar2) RETURN NUMBER;

    FUNCTION fn_0088getNEEDTRFSE (p_closetype in varchar2, p_custodycd in varchar2, p_afacctno in varchar2) RETURN varchar2;

    FUNCTION fn_getCustIDByCustodyCD(p_custodycd in varchar2)
    RETURN varchar2;
    PROCEDURE prc_check_DDMAST(p_action in varchar2, p_custodycd in varchar2, p_ddacctno in varchar2, p_status in varchar2, p_err_code out varchar2);

END;
/


CREATE OR REPLACE PACKAGE BODY cspks_cfproc
IS
   -- declare log context
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;


  FUNCTION fn_getCustIDByCustodyCD(p_custodycd in varchar2)
  RETURN varchar2
  IS
    l_custid varchar2(10);
  BEGIN
    select custid into l_custid from cfmast where custodycd = p_custodycd;
    return l_custid;
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.error (pkgctx, SQLERRM);
      return '';
  END fn_getCustIDByCustodyCD;

FUNCTION fn_checkNonCustody (v_strCustodycd in varchar2) RETURN NUMBER IS
     /*
     **  Module: Neu khach hang thuoc cong ty return 0, else return -1.
     **  MODIFICATION HISTORY
     **  Person      Date           Comments
     **  ThanhNM     26-Feb-2012    Created
     ** (c) 2012 by Financial Software Solutions. JSC.
     */
    v_result   NUMBER;
    v_strCusType    varchar2(1);
    v_count    NUMBER;
BEGIN
    v_result:=0;
    v_count:=0;
    v_strCusType:='';
    plog.setbeginsection(pkgctx, 'fn_checkNonCustody');
    --Lay noi luu ky

     select count(1) into  v_count from cfmast  where  custodycd = replace(upper(v_strCustodycd),'.','');
     if v_count>0 then
            select CUSTATCOM into v_strCusType from cfmast  where  custodycd = replace(upper(v_strCustodycd),'.','');
            if v_strCusType ='Y' then
                v_result:=0;
                plog.setendsection(pkgctx, 'fn_checkNonCustody');
                return v_result;
            else
                 v_result:=-1;
                 plog.setendsection(pkgctx, 'fn_checkNonCustody');
                 return v_result;
            end if;
     else
        v_result:=-1;
        plog.setendsection(pkgctx, 'fn_checkNonCustody');
        return v_result;
     end if;
     plog.setendsection(pkgctx, 'fn_checkNonCustody');

    RETURN 0;
EXCEPTION
   WHEN others THEN
   plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
   plog.setendsection (pkgctx, 'fn_checkNonCustody');
   return 0;
END;

PROCEDURE pr_AFMAST_ChangeTypeCheck (p_afacctno in varchar2,p_actype in varchar2, p_err_code in out varchar2)
IS
l_count number;
l_oldcorebank varchar2(10);
l_newcorebank varchar2(10);
l_newcitype  varchar2(10);
l_newsetype  varchar2(10);
BEGIN
    plog.setbeginsection(pkgctx, 'pr_AFMAST_ChangeTypeCheck');
    p_err_code:= '0';
    select corebank into l_oldcorebank from afmast where acctno = p_afacctno;
    select corebank into l_newcorebank from aftype where actype = p_actype;
    if l_oldcorebank <> l_newcorebank then
    

        if l_count > 0 then

            p_err_code:= '-100144';

            plog.setendsection(pkgctx, 'pr_AFMAST_ChangeTypeCheck');
            return;
        end if;
        select count(1) into l_count from afmast where acctno = p_afacctno and advanceline <> 0;
        
        if l_count > 0 then

            p_err_code:= '-100149';

            plog.setendsection(pkgctx, 'pr_AFMAST_ChangeTypeCheck');
            return;
        end if;

        -- Kiem tra loai hinh SE
        Begin
            Select count(1) into l_count
            From afmast af, semast se,
                (Select actype,  setype from aftype where actype = p_actype) new_typ
            Where af.acctno = se.afacctno
                  and af.acctno = p_afacctno
                  and se.actype = new_typ.setype;
            
            If l_count = 0 Then
                p_err_code:= '-100155';
                plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
                plog.setendsection(pkgctx, 'pr_AFMAST_ChangeTypeCheck');
                return;
            End If;
        EXCEPTION
           WHEN others THEN
                p_err_code:= '-100155';
                plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
                plog.setendsection(pkgctx, 'pr_AFMAST_ChangeTypeCheck');
                return;
        End;
        --End TruongLD
    end if;
    p_err_code:='0';
    plog.setendsection(pkgctx, 'pr_AFMAST_ChangeTypeCheck');
EXCEPTION
   WHEN others THEN
   plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
   plog.setendsection (pkgctx, 'pr_AFMAST_ChangeTypeCheck');
   p_err_code:='-1';
   return;
END;


FUNCTION fn_0088checkAFCOUNT (p_closetype in varchar2, p_custodycd in varchar2) RETURN NUMBER IS
    v_result   NUMBER;
    v_strCusType    varchar2(1);
    v_count    NUMBER;
BEGIN
    plog.setbeginsection(pkgctx, 'fn_checkAFCOUNT');
    --Lay noi luu ky
    select count(1) into v_count
    from afmast where custid in (
                    select custid from cfmast where custodycd = p_custodycd)
    and status not in ('N','C');
    if v_count = 1 and p_closetype = '002' then
        return -1;
    end if;

    plog.setendsection(pkgctx, 'fn_checkAFCOUNT');

    RETURN 0;
EXCEPTION
   WHEN others THEN
   plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
   plog.setendsection (pkgctx, 'fn_checkAFCOUNT');
   return 0;
END;

FUNCTION fn_0088getFEEDATE (p_closetype in varchar2) RETURN NUMBER IS
v_Result number;
BEGIN
    plog.setbeginsection(pkgctx, 'fn_getFEEDATE');
    if p_closetype = '002' then
        select sbdate - currdate into v_Result from sbcurrdate where numday=0 AND sbtype='B' ;
    else
        select sbdate - currdate into v_Result from sbcurrdate where numday=2 AND sbtype='B' ;
    end if;

    plog.setendsection(pkgctx, 'fn_getFEEDATE');
    return v_Result;
EXCEPTION
   WHEN others THEN
   plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
   plog.setendsection (pkgctx, 'fn_getFEEDATE');
   return 0;
END;

FUNCTION fn_0088getNEEDTRFSE (p_closetype in varchar2, p_custodycd in varchar2, p_afacctno in varchar2) RETURN varchar2 IS
l_count number;
l_countmcustodycd number;
BEGIN
    plog.setbeginsection(pkgctx, 'fn_getFEEDATE');
--trung.luu: 05-03-2021 loop theo view vw_cfmast_m (neu khong co tai khoan con thi xu ly nhu cu)
    /*select count(1) into l_count
    from semast se, sbsecurities sb
    where se.codeid = sb.codeid
    and se.custid in (select custid from cfmast where custodycd = p_custodycd)
    and SE.TRADE + SE.MORTAGE + SE.BLOCKED + SE.WITHDRAW
               + SE.DEPOSIT  + SE.SENDDEPOSIT > 0
    and sb.sectype <> '004';

    if l_count > 0 and p_closetype = '001' then
        return 'Y';
    end if;

    select count(1) into l_count
    from caschd ca, afmast af
    where ca.afacctno = af.acctno and af.custid in (select custid from cfmast where custodycd = p_custodycd)
    and ((ca.qtty > 0 and ca.isse = 'N') or (ca.amt > 0 and ca.isci = 'N'));

    if l_count > 0 and p_closetype = '001' then
        return 'Y';
    end if;*/

    FOR R IN (select CUSTODYCD_ORG from vw_cfmast_m where custodycd = p_custodycd)
    LOOP
        select count(1) into l_count
        from semast se, sbsecurities sb
        where se.codeid = sb.codeid
        and se.custid in (select custid from cfmast where custodycd = R.CUSTODYCD_ORG)
        and SE.TRADE + SE.MORTAGE + SE.BLOCKED + SE.WITHDRAW
                   + SE.DEPOSIT  + SE.SENDDEPOSIT > 0
        and sb.sectype <> '004';

        if l_count > 0 and p_closetype = '001' then
            return 'Y';
        end if;

        select count(1) into l_count
        from caschd ca, afmast af
        where ca.afacctno = af.acctno and af.custid in (select custid from cfmast where custodycd = R.CUSTODYCD_ORG)
        and ((ca.qtty > 0 and ca.isse = 'N') or (ca.amt > 0 and ca.isci = 'N'))
        and ca.status not in ('C')
        and ca.deltd not in ('Y');

        if l_count > 0 and p_closetype = '001' then
            return 'Y';
        end if;
    END LOOP;



    if p_closetype = '002' then
        select count(1) into l_count
        from semast se, sbsecurities sb
        where se.codeid = sb.codeid
            and se.afacctno = p_afacctno
            and SE.TRADE + SE.MORTAGE + SE.BLOCKED + SE.WITHDRAW
            + SE.DEPOSIT  + SE.SENDDEPOSIT > 0
            and sb.sectype <> '004';
        if l_count > 0 then
            return 'Y';
        end if;

        select count(1) into l_count
        from caschd ca
        where ca.afacctno = p_afacctno
        and ((ca.qtty > 0 and ca.isse = 'N') or (ca.amt > 0 and ca.isci = 'N'))
        and ca.status not in ('C')
        and ca.deltd not in ('Y');

        if l_count > 0 then
            return 'Y';
        end if;
    end if;

    plog.setendsection(pkgctx, 'fn_getFEEDATE');
    return 'N';
EXCEPTION
   WHEN others THEN
   plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
   plog.setendsection (pkgctx, 'fn_getFEEDATE');
   return 'N';
END;

FUNCTION fn_0088getAFACCTNO (p_closetype in varchar2, p_custodycd in varchar2, p_afacctno in varchar2) RETURN varchar2 IS
l_count number;
BEGIN
    plog.setbeginsection(pkgctx, 'fn_getFEEDATE');
    if p_closetype = '001' then
        return p_custodycd || '|ALL';
    else
        return p_afacctno;
    end if;
    plog.setendsection(pkgctx, 'fn_getFEEDATE');
EXCEPTION
   WHEN others THEN
   plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
   plog.setendsection (pkgctx, 'fn_getFEEDATE');
END;

FUNCTION fn_0088checkAFACCTNO (p_closetype in varchar2, p_afacctno in varchar2, p_setafacctno in varchar2) RETURN NUMBER IS
BEGIN
    plog.setbeginsection(pkgctx, 'fn_checkAFCOUNT');
    --Lay noi luu ky
    if p_closetype = '001' and instr(p_afacctno, 'ALL') = 0 then
        return -1;
    end if;
    if p_closetype <> '001' and instr(p_afacctno, 'ALL') <> 0 then
        return -1;
    end if;
    if p_closetype <> '001' and p_afacctno <> p_setafacctno then
        return -1;
    end if;
    plog.setendsection(pkgctx, 'fn_checkAFCOUNT');

    RETURN 0;
EXCEPTION
   WHEN others THEN
   plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
   plog.setendsection (pkgctx, 'fn_checkAFCOUNT');
   return 0;
END;

PROCEDURE prc_check_DDMAST(p_action in varchar2, p_custodycd in varchar2, p_ddacctno in varchar2, p_status in varchar2, p_err_code out varchar2)
IS
BEGIN
    plog.setbeginsection(pkgctx, 'prc_check_DDMAST');

    p_err_code := systemnums.C_SUCCESS;
    plog.setendsection(pkgctx, 'prc_check_DDMAST');
    return ;
EXCEPTION
   WHEN others THEN
   p_err_code   := errnums .C_SYSTEM_ERROR;
   plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
   plog.setendsection (pkgctx, 'prc_check_DDMAST');
   return ;
END;

-- initial LOG
BEGIN
   SELECT *
   INTO logrow
   FROM tlogdebug
   WHERE ROWNUM <= 1;

   pkgctx    :=
      plog.init ('cspks_cfproc',
                 plevel => logrow.loglevel,
                 plogtable => (logrow.log4table = 'Y'),
                 palert => (logrow.log4alert = 'Y'),
                 ptrace => (logrow.log4trace = 'Y')
      );
END;
/
