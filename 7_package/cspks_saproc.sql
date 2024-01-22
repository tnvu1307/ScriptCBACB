SET DEFINE OFF;
CREATE OR REPLACE PACKAGE cspks_saproc
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
    PROCEDURE pr_GenDeletedTable(ATTR_TABLE in varchar2, STRCLAUSE in varchar2, p_err_param in out varchar2);
    PROCEDURE pr_SaveLoginInfo(P_USERID in varchar2, P_IPADDRESS in varchar2,P_MACADDRESS in varchar2, P_GUID in varchar2, p_err_param in out varchar2);
    PROCEDURE pr_CheckSessionID( P_SESSIONID in varchar2, P_TLID in varchar2, p_err_param in out varchar2);
    procedure prc_FillValueFromSQL(p_strSQL IN VARCHAR2,p_datasource IN OUT VARCHAR2);
END;
/


CREATE OR REPLACE PACKAGE BODY cspks_saproc
IS
   -- declare log context
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;


PROCEDURE pr_GenDeletedTable(ATTR_TABLE in varchar2, STRCLAUSE in varchar2, p_err_param in out varchar2)
IS

v_count number;
l_sql_query varchar2(200);
BEGIN
    p_err_param := '0';

    SELECT count(1)
    into v_count
    FROM user_tables
    where table_name = ATTR_TABLE||'_DELTD';

    begin
        if(v_count = 0)  then

            l_sql_query:=' CREATE TABLE ' || ATTR_TABLE  || '_DELTD AS SELECT * FROM ' || ATTR_TABLE || ' WHERE 0=1 ';

            
            execute immediate l_sql_query;
            commit;
        end if;

         l_sql_query:=' INSERT INTO  ' || ATTR_TABLE  || '_DELTD  SELECT * FROM ' || ATTR_TABLE || ' WHERE 0=0 AND ' || STRCLAUSE;
         
         execute immediate l_sql_query;
         COMMIT;


    exception when others then
            plog.error (pkgctx, SQLERRM);
    end;


    plog.debug (pkgctx, '<<END OF pr_GenDeletedTable');
    plog.setendsection (pkgctx, 'pr_GenDeletedTable');
EXCEPTION
WHEN OTHERS
   THEN
      p_err_param := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_GenDeletedTable');
      RAISE errnums.E_SYSTEM_ERROR;
END pr_GenDeletedTable;

PROCEDURE pr_SaveLoginInfo(P_USERID in varchar2, P_IPADDRESS in varchar2,P_MACADDRESS in varchar2, P_GUID in varchar2, p_err_param in out varchar2)
IS

v_count number;
l_sql_query varchar2(200);
v_multi_session varchar2(1);
BEGIN
    p_err_param := '0';
    SELECT nvl(varvalue,'N') into v_multi_session FROM SYSVAR WHERE VARNAME LIKE 'MULTI_SESSION';
    begin

         -- cap nhat huy cac session hien tai voi cung user nhung khac ip
        if v_multi_session = 'N' then
            UPDATE LOGIN_INFO_BO
            SET STATUS = 'C'
            where upper(USERID) = upper(P_USERID) AND STATUS = 'A' AND IPADDRESS <> P_IPADDRESS;
        end if;


        /*-- cap nhat huy cac session hien tai cung ip, user --> C, chi chua lai 1 session truy cap gan nhat
          UPDATE LOGIN_INFO_BO
          SET STATUS = 'C'
          where logintime  <  ( select max(logintime) from LOGIN_INFO_BO
                                where USERID = P_USERID AND STATUS = 'A' AND IPADDRESS = P_IPADDRESS  )
          and USERID = P_USERID AND STATUS = 'A' AND IPADDRESS = P_IPADDRESS;*/

        -- insert thong tin session moi
          INSERT INTO LOGIN_INFO_BO(SESSIONID,   USERID, IPADDRESS, MACADDRESS ,STATUS, LOGINTIME)
          VALUES(P_GUID,P_USERID,P_IPADDRESS,P_MACADDRESS,'A',sysdate );

    exception when others then
            plog.error (pkgctx, SQLERRM);
              p_err_param := '-1';
    end;
    commit;
    plog.debug (pkgctx, '<<END OF pr_SaveLoginInfo');
    plog.setendsection (pkgctx, 'pr_SaveLoginInfo');
EXCEPTION
WHEN OTHERS
   THEN
      p_err_param := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'pr_SaveLoginInfo');
      RAISE errnums.E_SYSTEM_ERROR;
END pr_SaveLoginInfo;

PROCEDURE pr_CheckSessionID( P_SESSIONID in varchar2, P_TLID in varchar2, p_err_param in out varchar2)
IS

v_status varchar2(2);
v_lastRequest date ;
v_timeout number;
l_sql_query varchar2(200);
v_HOSTATUS  varchar2(10);
l_tlname varchar2(200);
BEGIN
    p_err_param := '0';

    if nvl(LENGTH( P_SESSIONID),0) =0 or nvl( LENGTH (P_TLID),0) =0 then

    RETURN;
    end if;


--IF P_SESSIONID IS NOT NULL THEN
    begin
    select tlname into l_tlname  from  tlprofiles where tlid =P_TLID;

      EXCEPTION
         WHEN OTHERS then
         l_tlname:='';
    end ;


    SELECT  VARVALUE
    INTO v_HOSTATUS
    FROM SYSVAR
    WHERE GRNAME = 'SYSTEM' AND VARNAME = 'HOSTATUS';
    if v_HOSTATUS = '1' then
        -- get time out from sysvar
         begin
            select to_number(varvalue ) into v_timeout
            from sysvar
            where grname = 'SYSTEM'
            and varname = 'TIMEOUT';
         EXCEPTION
         WHEN no_data_found then
             v_timeout := 30;  -- default 30p
         end;

     -- cap nhat trang thai la time out
             update   LOGIN_INFO_BO
             set status = 'C'
             where  status = 'A' and lastRequest +(v_timeout/1440) < sysdate;
    -- kiem tra trang thai cua session
       begin
        select status --, nvl(lastrequest,logintime)
        into v_status--,v_lastRequest
        from LOGIN_INFO_BO
        where sessionid = P_SESSIONID  and UPPER( userid) =nvl(l_tlname,userid)
        ;

        if v_status <> 'A' then
          p_err_param := '-777777';
          commit;

          return;
        end if;
       EXCEPTION
       WHEN no_data_found
       THEN
         p_err_param := '-777777';
         commit;
            return;
       end;
       -- cap nhat time last request
         update   LOGIN_INFO_BO
         set lastrequest = sysdate
         where sessionid = P_SESSIONID and status = 'A';
    end if;
    commit;
    plog.debug (pkgctx, '<<END OF pr_SaveLoginInfo');
    plog.setendsection (pkgctx, 'pr_SaveLoginInfo');

     


   --   END IF;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_param := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      PLOG.ERROR(PKGCTX, DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      plog.setendsection (pkgctx, 'pr_SaveLoginInfo');
      RAISE errnums.E_SYSTEM_ERROR;
END pr_CheckSessionID;

procedure prc_FillValueFromSQL(p_strSQL IN VARCHAR2,p_datasource IN OUT VARCHAR2)
IS
l_return varchar2(4000);
l_count NUMBER;
l_refcursor pkg_report.ref_cursor;
v_desc_tab dbms_sql.desc_tab;
v_cursor_number NUMBER;
v_columns NUMBER;
v_number_value NUMBER;
v_varchar_value VARCHAR(4000);
v_date_value DATE;
l_fldname varchar2(100);
BEGIN
    /*
    12/02/2020, TruongLD add
    Dua vao SQL User truyen vao va datasource cua email, tu dong dien gia tri vao.
    Ghi chu: Cac cot trong datasource phai co trong SQL.
    VD: Cacn goi va khai bao
    declare
        v_SQL VARCHAR2(4000);
        v_datasource VARCHAR2(4000);
    Begin
        v_SQL := 'Select fullname, custodycd, custodycd || ''.'' || fullname fullname2 from cfmast where custodycd=''SHVB000307''';
        v_datasource := '<p>Kinh gui [fullname]!</p>
                   </br>
                   <p>Shinhan bank thong bao TK [custodycd] cua khach hang [fullname2]</p>';
        cspks_saproc.prc_getvalFromSQL(v_SQL, v_datasource);
        dbms_output.put_line('v_datasource:' || v_datasource);
    End;
    */
    plog.setbeginsection (pkgctx, 'prc_FillValueFromSQL');

    l_return :='';
    OPEN l_refcursor FOR p_strSQL;
    v_cursor_number := dbms_sql.to_cursor_number(l_refcursor);
    dbms_sql.describe_columns(v_cursor_number, v_columns, v_desc_tab);
    --define colums
    FOR i IN 1 .. v_desc_tab.COUNT LOOP
            IF v_desc_tab(i).col_type = dbms_types.typecode_number THEN
            --Number
                dbms_sql.define_column(v_cursor_number, i, v_number_value);
            ELSIF v_desc_tab(i).col_type = dbms_types.typecode_varchar
                OR  v_desc_tab(i).col_type = dbms_types.typecode_char THEN
            --Varchar, char
                dbms_sql.define_column(v_cursor_number, i, v_varchar_value,4000);
            ELSIF v_desc_tab(i).col_type = dbms_types.typecode_date THEN
            --Date,
               dbms_sql.define_column(v_cursor_number, i, v_date_value);
            END IF;
    END LOOP;

    WHILE dbms_sql.fetch_rows(v_cursor_number) > 0 LOOP
        FOR i IN 1 .. v_desc_tab.COUNT LOOP
              l_fldname :=  v_desc_tab(i).col_name;
              IF v_desc_tab(i).col_type = dbms_types.typecode_number THEN
                   dbms_sql.column_value(v_cursor_number, i, v_number_value);
                   l_return := to_char(v_number_value);
              ELSIF  v_desc_tab(i).col_type = dbms_types.typecode_varchar
                OR  v_desc_tab(i).col_type = dbms_types.typecode_char
                THEN
                   dbms_sql.column_value(v_cursor_number, i, v_varchar_value);
                   l_return := v_varchar_value;
              ELSIF v_desc_tab(i).col_type = dbms_types.typecode_date THEN
                   dbms_sql.column_value(v_cursor_number, i, v_date_value);
                   l_return:=to_char(v_date_value,'DD/MM/RRRR');
              END IF;
              --plog.error('fldname:' || l_fldname || ', fldvalue:' || l_return);
              --plog.error('p_datasource: '||p_datasource);
              p_datasource := replace(p_datasource, '[' || LOWER(l_fldname) || ']', l_return);
        END LOOP;
    END LOOP;
    plog.setendsection (pkgctx, 'prc_FillValueFromSQL');
EXCEPTION WHEN OTHERS THEN
      plog.error (pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'prc_FillValueFromSQL');
      raise errnums.e_system_error;
END;

-- initial LOG
BEGIN
   SELECT *
   INTO logrow
   FROM tlogdebug
   WHERE ROWNUM <= 1;

   pkgctx    :=
      plog.init ('cspks_saproc',
                 plevel => logrow.loglevel,
                 plogtable => (logrow.log4table = 'Y'),
                 palert => (logrow.log4alert = 'Y'),
                 ptrace => (logrow.log4trace = 'Y')
      );
END;
/
