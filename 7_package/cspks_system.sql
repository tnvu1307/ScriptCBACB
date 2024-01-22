SET DEFINE OFF;
CREATE OR REPLACE PACKAGE cspks_system
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
     **  TienPQ      09-JUNE-2009    Created
     ** (c) 2008 by Financial Software Solutions. JSC.
     ----------------------------------------------------------------------------------------------------*/
     FUNCTION fn_get_sysvar (p_sys_grp IN VARCHAR2, p_sys_name IN VARCHAR2)
        RETURN sysvar.varvalue%TYPE;

     FUNCTION fn_get_errmsg (p_errnum IN varchar2)
        RETURN deferror.errdesc%TYPE;

  PROCEDURE pr_set_sysvar (p_sys_grp IN varchar2,
                            p_sys_name IN varchar2,
                            p_sys_value IN varchar2
   );

  Function fn_NETgen_trandesc (p_xmlmsg     IN varchar2,
                            p_tltxcd IN varchar2,
                            p_apptype IN varchar2,
                            p_apptxcd IN varchar2
   )
   return varchar2;
  Function fn_DBgen_trandesc (p_txmsg IN tx.msg_rectype,
                            p_tltxcd IN varchar2,
                            p_apptype IN varchar2,
                            p_apptxcd IN varchar2
   )
   return varchar2;

   FUNCTION fn_PasswordGenerator (p_PwdLenght IN varchar2)
   RETURN VARCHAR2;
   
   FUNCTION fn_PasswordGenerator2 (p_PwdLenght IN varchar2)
   RETURN VARCHAR2;

     Function fn_DBgen_trandesc_with_format (p_txmsg IN tx.msg_rectype,
                              p_tltxcd IN varchar2,
                              p_apptype IN varchar2,
                              p_apptxcd IN varchar2,
                              p_txdesc in varchar2
     )
     return varchar2;
   function fn_correct_field(p_txmsg in tx.msg_rectype, p_fldname in varchar2, p_type in varchar2) return varchar2;
   function fn_random_str(v_length number) return VARCHAR2;
   Function fn_formatnumber (p_number IN NUMBER) return VARCHAR2;

END;

 
 

 
 

/


CREATE OR REPLACE PACKAGE BODY CSPKS_SYSTEM
IS
   -- declare log context
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;


    function fn_correct_field(p_txmsg in tx.msg_rectype, p_fldname in varchar2, p_type in varchar2)
    return varchar2
    is
    begin
        return p_txmsg.txfields(p_fldname).value;
    exception when others then
        return case when p_type='N' then '0' else '' end;
    end fn_correct_field;

   PROCEDURE pr_set_sysvar (p_sys_grp IN varchar2,
                            p_sys_name IN varchar2,
                            p_sys_value IN varchar2
   )
   IS
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      UPDATE sysvar
      SET varvalue    = p_sys_value
      WHERE varname = p_sys_name AND grname = p_sys_grp;

      COMMIT;
   END;

   PROCEDURE pr_set_sysvar (p_sys_grp IN varchar2,
                            p_sys_name IN varchar2,
                            p_sys_value IN varchar2,
                            p_auto_commit IN boolean
   )
   IS
   BEGIN
      UPDATE sysvar
      SET varvalue    = p_sys_value
      WHERE varname = p_sys_name AND grname = p_sys_grp;

      IF p_auto_commit
      THEN
         COMMIT;
      END IF;
   END;

   FUNCTION fn_get_sysvar (p_sys_grp IN varchar2, p_sys_name IN varchar2)
      RETURN sysvar.varvalue%TYPE
   IS
      l_sys_value   sysvar.varvalue%TYPE;
   BEGIN
      SELECT varvalue
      INTO l_sys_value
      FROM sysvar
      WHERE varname = p_sys_name AND grname = p_sys_grp;

      RETURN l_sys_value;
   END;

   FUNCTION fn_get_errmsg (p_errnum IN varchar2)
      RETURN deferror.errdesc%TYPE
   IS
      l_errdesc   deferror.errdesc%TYPE;
   BEGIN
      FOR i IN (SELECT errdesc
                FROM deferror
                WHERE errnum = p_errnum)
      LOOP
         l_errdesc   := i.errdesc;
      END LOOP;

      RETURN l_errdesc;
   END;

   FUNCTION fn_get_date (p_date IN varchar2, p_date_format IN varchar2)
      RETURN VARCHAR2
   IS
      l_date   DATE;
   BEGIN
      l_date   := TO_DATE (p_date, systemnums.c_date_format);
      RETURN TO_CHAR (l_date, p_date_format);
   END;

   FUNCTION fn_get_param (p_type IN varchar2, p_name IN varchar2)
      RETURN VARCHAR2
   IS
      l_value   VARCHAR2 (20);
   BEGIN
      SELECT a.cdval
      INTO l_value
      FROM allcode a
      WHERE UPPER (a.cdtype) = UPPER (p_type)
            AND UPPER (a.cdname) = UPPER (p_name);

      RETURN l_value;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;

   Function fn_NETgen_trandesc (p_xmlmsg     IN varchar2,
                            p_tltxcd IN varchar2,
                            p_apptype IN varchar2,
                            p_apptxcd IN varchar2
   )
   return varchar2
   IS
        p_txmsg tx.msg_rectype;
        var1 varchar2(1000);
        var2 varchar2(1000);
        var3 varchar2(1000);
        p_txdesc varchar2(1000);
   BEGIN
      plog.setbeginsection(pkgctx, 'fn_NETgen_trandesc');
      plog.debug (pkgctx, 'p_tltxcd:' || p_tltxcd);
      plog.debug (pkgctx, 'p_apptype:' || p_apptype);
      plog.debug (pkgctx, 'p_apptxcd:' || p_apptxcd);

      p_txmsg := txpks_msg.fn_xml2obj(p_xmlmsg);
      p_txdesc:='';
      plog.setendsection(pkgctx, 'fn_NETgen_trandesc');
      return p_txdesc;
   exception when others then

    plog.setendsection (pkgctx, 'fn_NETgen_trandesc');
    RETURN '';
   END;

   Function fn_DBgen_trandesc (p_txmsg IN tx.msg_rectype,
                            p_tltxcd IN varchar2,
                            p_apptype IN varchar2,
                            p_apptxcd IN varchar2
   )
   return varchar2
   IS
        p_txdesc varchar2(1000);
        var1 varchar2(1000);
        var2 varchar2(1000);
        --var3 varchar2(1000);
   BEGIN
      plog.setbeginsection(pkgctx, 'fn_DBgen_trandesc');
      plog.debug (pkgctx, 'p_tltxcd:' || p_tltxcd);
      plog.debug (pkgctx, 'p_apptype:' || p_apptype);
      plog.debug (pkgctx, 'p_apptxcd:' || p_apptxcd);

      p_txdesc:='';
      plog.setendsection(pkgctx, 'fn_DBgen_trandesc');
      return p_txdesc;
   exception when others then
      plog.setendsection(pkgctx, 'fn_DBgen_trandesc');
    return '';
   END;

   Function fn_DBgen_trandesc_with_format (p_txmsg IN tx.msg_rectype,
                            p_tltxcd IN varchar2,
                            p_apptype IN varchar2,
                            p_apptxcd IN varchar2,
                            p_txdesc in varchar2
   )
   return varchar2
   IS
        l_txdesc varchar2(1000);
        var1 varchar2(1000);
        var2 varchar2(1000);
        var3 varchar2(1000);
        var4 varchar2(1000);
        l_acctno varchar(20);
        l_rlsdate date;
        l_rlsamt number;
        l_catype varchar2(100);
        l_lntype varchar2(100);
        l_strtxdesc varchar2(100);
   BEGIN
      plog.setbeginsection(pkgctx, 'fn_DBgen_trandesc_with_format');
      begin
          select substr(trdesc,16) into l_txdesc
          from v_appmap_by_tltxcd
          where tltxcd = p_txmsg.tltxcd and apptype = p_apptype and substr(trdesc,9,4) = p_txdesc
          and substr(trdesc,1,7) = 'FORMAT:';
      exception when others then
            l_txdesc:=p_txmsg.txdesc;
      end;
      --GianhVG add for 3350,3354
      if p_tltxcd in ('3350','3354') then
         var1:='';
         var2:='';
         var3:='';
         var4:='';

         begin
           select catype into l_catype from camast where camastid = p_txmsg.txfields('02').value;
           if l_catype = '010' then --Co tuc bang tien
              select sb.symbol, ca.devidentrate, to_char(ca.reportdate,'DD/MM/RRRR')
                     /*
                     , (CASE WHEN ca.catype = '010' AND ca.exerate < 100 THEN
                        (CASE WHEN ca.status = 'K' THEN ' ( ' || UTF8NUMS.C_TXDESC_3350_2 || ', ' ||
                              (100-ca.exerate) || '% )'
                            ELSE ' ( ' || UTF8NUMS.C_TXDESC_3350_1 || ca.exerate || '% )' END
                            ) ELSE NULL END)
                     */
					 /*
                     ,CASE WHEN CA.CATYPE = '010' AND CA.TYPERATE ='R'
                            THEN '(phân bổ ' || NVL(CAD.DEVIDENTRATE, CA.DEVIDENTRATE) || '%/ ' || CA.DEVIDENTRATE || '%)'
                       WHEN CA.CATYPE = '010' AND CA.TYPERATE ='V'
                            THEN '(phân bổ ' || NVL(CAD.DEVIDENTVALUE, CA.DEVIDENTVALUE) || '/' || CA.DEVIDENTVALUE || ')'
                       ELSE NULL END
					   */
					   ,CASE WHEN CA.CATYPE = '010' AND NVL(cad.execrate,ca.exerate) < 100 Then
							 '( thanh toán ' || cad.execrate || '%, còn lại ' || ca.exerate || '%)'
							else null end
                     into var1, var2, var3, l_strtxdesc
              from camast ca, sbsecurities sb,
                   (select * from camastdtl where deltd <> 'Y' and status ='P') cad
              where ca.camastid = cad.camastid(+) 
                    and ca.camastid = p_txmsg.txfields('02').value 
                    and ca.codeid = sb.codeid;
                    
              if p_txdesc = '0001' then --So tien Goc
                 l_txdesc:='Cổ tức bằng tiền ' || var1 || ' ' || var2 || '% chốt ngày ' || var3 || ' ' || l_strtxdesc;
              elsif p_txdesc = '0003' then --So thien thue
                 l_txdesc:='Thuế TNCN cổ tức bằng tiền ' || var1 || ' ' || var2 || '% chốt ngày ' || var3 || ' ' || l_strtxdesc;
              --else
              --   l_txdesc:=p_txmsg.txdesc;
              end if;
           elsif  l_catype = '011' then --Co tuc bang co phieu
              select sb.symbol || ' ' || ca.devidentshares,exprice, to_char(ca.reportdate,'DD/MM/RRRR')
                     into var1, var2, var3
              from camast ca, sbsecurities sb
              where camastid = p_txmsg.txfields('02').value and ca.codeid = sb.codeid;
              if p_txdesc = '0001' then --So tien Goc
                 l_txdesc:='CP lể trả bằng tiền của cổ tức bằng cổ phiếu ' || var1 || ' chốt ngày ' || var3 || ', giá ' || var2 || ' d/1CP';
              elsif p_txdesc = '0003' then --So thien thue
                 l_txdesc:='Thuế CP lẻ trả bằng tiền của Cổ tức bằng cổ phiếu ' || var1 || ' chốt ngày ' || var3 || ', giá ' || var2 || ' d/1CP';
              --else
              --   l_txdesc:=p_txmsg.txdesc;
              end if;
           elsif  l_catype = '021' then --Co phieu thuong
              select sb.symbol || ' ' || ca.exrate,exprice, to_char(ca.reportdate,'DD/MM/RRRR')
                     into var1, var2, var3
              from camast ca, sbsecurities sb
              where camastid = p_txmsg.txfields('02').value and ca.codeid = sb.codeid;
              if p_txdesc = '0001' then --So tien Goc
                 l_txdesc:='CP lẻ trả bằng tiền của Cổ phiếu thưởng ' || var1 || ' chốt ngày ' || var3 || ', giá ' || var2 || ' d/1CP';
              elsif p_txdesc = '0003' then --So thien thue
                 l_txdesc:='Thuế CP lẻ trả bằng tiền của Cổ phiếu thưởng ' || var1 || ' chốt ngày ' || var3 || ', giá ' || var2 || ' d/1CP';
              --else
              --   l_txdesc:=p_txmsg.txdesc;
              end if;
           elsif  l_catype in ('015','016') then --Tra lai trai phieu va Lai + goc trai phieu
              select sb.symbol, ca.exrate,to_char(ca.reportdate,'DD/MM/RRRR'),ca.pitrate
                     into var1, var2 , var3,var4
              from camast ca, sbsecurities sb
              where camastid = p_txmsg.txfields('02').value and ca.codeid = sb.codeid;
              if p_txdesc = '0001' then --So tien Goc
                 l_txdesc:='Gốc trái phiếu ' || var1  || ' ' || var2 || ' chốt ngày ' || var3;
              elsif p_txdesc = '0002' then --So ti?n lãi
                 l_txdesc:='Lãi trái phiếu ' || var1  || ' ' || var2 || ' chốt ngày ' || var3;
              elsif p_txdesc = '0002' then --So ti?n lãi
                 l_txdesc:='Thuế trái tức ' || var1  || ' ' || var4 || ' chốt ngày ' || var3;
              --else
              --   l_txdesc:=p_txmsg.txdesc;
              end if;
           --else
           --   l_txdesc:=p_txmsg.txdesc;
           end if;
         exception when others then
           l_txdesc:=l_txdesc;
         end;
      end if;
      --End GianhVG add for 3350
      --GianhVG add for 3351
      if p_tltxcd in ('3351') then
         var1:='';
         var2:='';
         var3:='';
         var4:='';
         l_txdesc:=p_txmsg.txdesc;
         begin
           select catype into l_catype from camast where camastid = p_txmsg.txfields('02').value;
           if l_catype = '014' then --quyen mua
              select sb.symbol, to_char(ca.reportdate,'DD/MM/RRRR')
                     into var1, var2
              from camast ca, sbsecurities sb
              where camastid = p_txmsg.txfields('02').value and nvl(ca.tocodeid,ca.codeid) = sb.codeid;
              if p_txdesc = '0001' then --Chung khoan nhan
                 l_txdesc:='Phân bổ chứng khoán mua phát hành thêm ' || var1 || ' chốt ngày ' || var2;
              end if;
           elsif  l_catype = '011' then --Co tuc bang co phieu
              select sb.symbol || ' ' || ca.devidentshares,to_char(ca.reportdate,'DD/MM/RRRR')
                     into var1, var2
              from camast ca, sbsecurities sb
              where camastid = p_txmsg.txfields('02').value and ca.codeid = sb.codeid;
              if p_txdesc = '0001' then --Chung khoan nhan
                 l_txdesc:='Cổ tức bằng cổ phiếu ' || var1 || ' chốt ngày ' || var2;
              end if;
           elsif  l_catype = '021' then --Co phieu thuong
              select sb.symbol || ' ' || ca.exrate,to_char(ca.reportdate,'DD/MM/RRRR')
                     into var1, var2
              from camast ca, sbsecurities sb
              where camastid = p_txmsg.txfields('02').value and ca.codeid = sb.codeid;
              if p_txdesc = '0001' then --Chung khoán nhan
                 l_txdesc:='Cổ phiếu thưởng ' || var1 || ' chốt ngày ' || var2;
              end if;
           elsif  l_catype in ('020') then --Chuyen chung khoan thanh chung khoan
              select sb.symbol,sbto.symbol, ca.devidentshares,to_char(ca.reportdate,'DD/MM/RRRR')
                     into var1, var2 , var3, var4
              from camast ca, sbsecurities sb , sbsecurities sbto
              where camastid = p_txmsg.txfields('02').value
              and ca.codeid = sb.codeid
              and ca.tocodeid = sbto.codeid;
              if p_txdesc = '0001' then --Chung khoán nhan
                 l_txdesc:='Chuyển chứng khoán ' || var1  || ' thành chứng khoán ' || var2 || ' tỷ lệ ' || var3;
              elsif p_txdesc = '0002' then --chung khoan chuyen doi
                 l_txdesc:='Chuyển chứng khoán ' || var1  || ' thành chứng khoán ' || var2 || ' tỷ lệ ' || var3;
              end if;
           --else
           --   l_txdesc:=p_txmsg.txdesc;
           end if;
         exception when others then
           l_txdesc:=l_txdesc;
         end;
      end if;
      --End GianhVG add for 3351
      --GianhVG add for 3382,3383,3385, 3384,3394

      If p_tltxcd ='3383' and p_apptype ='SE' Then
         l_txdesc := l_txdesc || ' ' || trim(to_char(TO_NUMBER(p_txmsg.txfields('21').value), '999,999,999,999,999,999'));
      End If;

      if p_tltxcd in ('3385','3382', '3384', '3394') then

         l_txdesc := l_txdesc || ' ' || trim(to_char(TO_NUMBER(p_txmsg.txfields('21').value), '999,999,999,999,999,999'));
         if   p_tltxcd in ('3384', '3394') then
              l_txdesc := l_txdesc || ' ' || p_txmsg.txfields('04').value;
         else
              l_txdesc := l_txdesc || ' ' || p_txmsg.txfields('35').value;
         end if;
      end if;
      --End GianhVG add add for 3382,3383,3385, 3384,3394

      --TruongLD Add
      If p_tltxcd in ('2239','2242','2268') Then
         l_txdesc:= replace(l_txdesc,'<$ACCTNO02>',p_txmsg.txfields('02').value);
         l_txdesc:= replace(l_txdesc,'<$ACCTNO04>',p_txmsg.txfields('04').value);
      End If;
      --End TruongLD

      if p_tltxcd = '0066' then
         if p_txdesc = '0001' then
            l_txdesc:= p_txmsg.txfields('30').value || ' (CK quyền)';
         end if;
      end if;

      

      if p_tltxcd = '0088' then
            if p_apptype = 'CI' then
               if p_txdesc = '0001' then
                l_txdesc:= replace(l_txdesc,'<$TXDATE>',to_char(p_txmsg.txdate,'MM/RRRR'));
                END IF;
               if p_txdesc = '0002' then
                l_txdesc:= replace(l_txdesc,'<$TXDATE>',to_char(p_txmsg.txdate,'MM/RRRR'));
                END IF;
            end if;
      end if;

      
      plog.setendsection(pkgctx, 'fn_DBgen_trandesc_with_format');
      return l_txdesc;
   exception when others then
        plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
        plog.setendsection(pkgctx, 'fn_DBgen_trandesc_with_format');
        return p_txmsg.txdesc;
   END fn_DBgen_trandesc_with_format;

   FUNCTION fn_PasswordGenerator (p_PwdLenght IN varchar2)
      RETURN VARCHAR2
   IS
      l_Password   sysvar.varvalue%TYPE;
   BEGIN

     -- SELECT upper(dbms_random.string('U', 10)) str INTO l_Password from dual;
      SELECT   ROUND (dbms_random.value(100000,999998)) str INTO l_Password from dual;
      RETURN l_Password;
   END;
   
   FUNCTION fn_PasswordGenerator2 (p_PwdLenght IN varchar2)
      RETURN VARCHAR2
   IS
      l_Password   sysvar.varvalue%TYPE;
   BEGIN

     -- SELECT upper(dbms_random.string('U', 10)) str INTO l_Password from dual;
      SELECT  '123456' INTO l_Password from dual;
      RETURN l_Password;
   END;
   
   function fn_random_str(v_length number) return varchar2 is
    my_str varchar2(4000);
    begin
    for i in 1..v_length loop
        my_str := my_str || dbms_random.string(
            case when dbms_random.value(0, 1) < 0.5 then 'l' else 'x' end, 1);
    end loop;
    return my_str;
    END;
    
    function fn_formatnumber (p_number IN NUMBER) return varchar2 is
    my_str varchar2(4000);
    begin
           if p_number=floor(p_number) then
             my_str := ltrim(to_char(p_number,'999,999,999,999,999,999,999,999,990'));
           else
             my_str := ltrim(rtrim(to_char(p_number,'999,999,999,999,999,999,999,999,990.9999999999999999'),'0'));
           end if;
    return my_str;
    Exception 
    When others then
      return to_char(p_number);
    END;

-- initial LOG
BEGIN
   SELECT *
   INTO logrow
   FROM tlogdebug
   WHERE ROWNUM <= 1;

   pkgctx    :=
      plog.init ('CSPKS_SYSTEM',
                 plevel => logrow.loglevel,
                 plogtable => (logrow.log4table = 'Y'),
                 palert => (logrow.log4alert = 'Y'),
                 ptrace => (logrow.log4trace = 'Y')
      );
END;

/
