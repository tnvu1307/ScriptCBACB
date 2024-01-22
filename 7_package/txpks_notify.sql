SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_notify
/** ----------------------------------------------------------------------------------------------------
 ** Module: NOTIFY
 ** Description: Function for Event Push notification
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  System
 ** (c) 2019 by Financial Software Solutions. JSC.
 ----------------------------------------------------------------------------------------------------*/
IS
PROCEDURE pr_encodereftostringarray_db(
    pv_refcursor   IN            pkg_report.ref_cursor,
    maxrow         IN            NUMBER,
    maxpage        IN            NUMBER,
    vreturnarray      OUT        simplestringarraytype);
PROCEDURE PR_FLEX2FO_ENQUEUE (PV_REFCURSOR IN pkg_report.ref_cursor,
queue_name IN VARCHAR2,
enq_msgid IN OUT RAW);
PROCEDURE pr_InvokeEnqueueTest;

PROCEDURE PR_NOTIFYEVENT2FO(
    pv_refcursor   IN            pkg_report.ref_cursor,
    queue_name IN VARCHAR2 default 'txaqs_FLEX2FO');
END;
/


CREATE OR REPLACE PACKAGE BODY txpks_notify
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;
   ownerschema VARCHAR2(100);
 PROCEDURE pr_encodereftostringarray_db(
    pv_refcursor   IN            pkg_report.ref_cursor,
    maxrow         IN            NUMBER,
    maxpage        IN            NUMBER,
    vreturnarray      OUT        simplestringarraytype)
IS
--  GEN FIX MESSAGE FROM REF CURSOR
-- ---------   ------  -------------------------------------------
    v_cursor_number NUMBER;
    v_columns NUMBER;
    v_desc_tab dbms_sql.desc_tab;
    v_refcursor pkg_report.ref_cursor;
    v_number_value NUMBER;
    v_varchar_value VARCHAR(200);
    v_date_value DATE;
    l_str_val VARCHAR2(4000);
    l_spliter CHAR(1):=CHR(1);
    l_prefix VARCHAR2(10):= '8=FIX..';
    l_str_header VARCHAR2(4000);
    l_arr_msg simplestringarraytype := simplestringarraytype(1);
BEGIN
    plog.setbeginsection (pkgctx, 'pr_encodereftostringarray_db');
    plog.debug(pkgctx, 'abt to encode refcursor maxrow, maxpage: ' || maxrow||','||maxpage);

    --Call procedure to open cursor
    v_refcursor := pv_refcursor;
    --Convert cursor to DBMS_SQL CURSOR
    v_cursor_number := dbms_sql.to_cursor_number(v_refcursor);
    --Get information on the columns
    dbms_sql.describe_columns(v_cursor_number, v_columns, v_desc_tab);
    --Loop through all the columns, find columname position and TYPE
--Get columns
    l_str_header := l_prefix|| l_spliter;
    FOR i IN 1 .. v_desc_tab.COUNT LOOP
            IF v_desc_tab(i).col_type = dbms_types.typecode_number THEN
            --Number
            l_str_header :=  l_str_header  || v_desc_tab(i).col_name|| l_spliter ;
                dbms_sql.define_column(v_cursor_number, i, v_number_value);
            ELSIF v_desc_tab(i).col_type = dbms_types.typecode_varchar
                OR  v_desc_tab(i).col_type = dbms_types.typecode_char THEN
            --Varchar, char
                l_str_header :=  l_str_header  || v_desc_tab(i).col_name|| l_spliter ;
                dbms_sql.define_column(v_cursor_number, i, v_varchar_value,200);
            ELSIF v_desc_tab(i).col_type = dbms_types.typecode_date THEN
            --Date,
               l_str_header :=  l_str_header  || v_desc_tab(i).col_name|| l_spliter ;
               dbms_sql.define_column(v_cursor_number, i, v_date_value);
            END IF;
    END LOOP;
--Get values
    WHILE dbms_sql.fetch_rows(v_cursor_number) > 0 LOOP
        l_str_val := l_prefix|| l_spliter;
     FOR i IN 1 .. v_desc_tab.COUNT LOOP
          IF v_desc_tab(i).col_type = dbms_types.typecode_number THEN
          --Number
                dbms_sql.column_value(v_cursor_number, i, v_number_value);
                l_str_val :=l_str_val|| nvl(v_number_value,0) || l_spliter;
          END IF;
          IF v_desc_tab(i).col_type = dbms_types.typecode_varchar
            OR  v_desc_tab(i).col_type = dbms_types.typecode_char
            THEN
          --Varchar, char
                dbms_sql.column_value(v_cursor_number, i, v_varchar_value);
                l_str_val :=l_str_val|| nvl(v_varchar_value,'null') || l_spliter;
          END IF;
          IF v_desc_tab(i).col_type = dbms_types.typecode_date
            THEN
          --Date
                dbms_sql.column_value(v_cursor_number, i, v_date_value);
                l_str_val :=l_str_val|| to_char(v_date_value,'yyyymmdd-hh:mm:ss') || l_spliter;
          END IF;
    END LOOP;
    l_str_header:=l_str_header||l_str_val;
    END LOOP;
    l_arr_msg(1):= l_str_header;
    vreturnarray := l_arr_msg;
    dbms_sql.close_cursor(v_cursor_number);
    plog.setendsection (pkgctx, 'pr_encodereftostringarray_db');
EXCEPTION WHEN OTHERS THEN
    l_arr_msg(1):= '';
    vreturnarray := l_arr_msg;
   plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
    
    plog.setendsection (pkgctx, 'pr_encodereftostringarray_db');
END pr_encodereftostringarray_db;

PROCEDURE PR_FLEX2FO_ENQUEUE (PV_REFCURSOR IN pkg_report.ref_cursor,
queue_name IN VARCHAR2,
enq_msgid IN OUT RAW)
IS
   tmp_text_message   SYS.AQ$_JMS_TEXT_MESSAGE;
   eopt               DBMS_AQ.enqueue_options_t;
   mprop              DBMS_AQ.message_properties_t;
   tmp_encode_text    VARCHAR2 (32767);
   l_array_msg SimpleStringArrayType := SimpleStringArrayType();
BEGIN
    plog.setbeginsection (pkgctx, 'PR_FLEX2FO_ENQUEUE');
    plog.debug(pkgctx, 'abt to PR_FLEX2FO_ENQUEUE refcursor queue_name, enq_msgid: ' || queue_name||','||enq_msgid);
    pr_encodereftostringarray_db(PV_REFCURSOR => PV_REFCURSOR,
                              vReturnArray => l_array_msg,
                              maxRow       => 5,
                              maxPage      => 255);

    for i in 1 .. l_array_msg.COUNT
    loop
      tmp_encode_text := l_array_msg(i);
      if LENGTH(tmp_encode_text) > 1 then
        tmp_text_message := SYS.AQ$_JMS_TEXT_MESSAGE.construct;
        tmp_text_message.set_text(tmp_encode_text);
        DBMS_AQ.ENQUEUE(queue_name         => ownerschema ||
                                              '.' || queue_name,
                        enqueue_options    => eopt,
                        message_properties => mprop,
                        payload            => tmp_text_message,
                        msgid              => enq_msgid);


      end if;
      --DBMS_OUTPUT.PUT_LINE('PL/SQL element ' || i || ' obtains the value "' || vArray(i) || '".');
    end loop;
    --COMMIT;
    plog.setendsection (pkgctx, 'PR_FLEX2FO_ENQUEUE');
EXCEPTION WHEN OTHERS THEN
    plog.error (pkgctx, '[queue_name:' || queue_name || '],[enq_msgid:' || enq_msgid || ']' || SQLERRM);
    
    plog.setendsection (pkgctx, 'PR_FLEX2FO_ENQUEUE');
END PR_FLEX2FO_ENQUEUE;

PROCEDURE pr_InvokeEnqueueTest
IS
    rs VARCHAR2(4000);
    pv_ref pkg_report.ref_cursor;
    enq_msgid RAW(16);
begin
    plog.setbeginsection (pkgctx, 'pr_InvokeEnqueueTest');
    plog.debug(pkgctx, 'abt to pr_InvokeEnqueueTest refcursor');
    OPEN pv_ref for SELECT * from afmast where rownum <=3;
    PR_FLEX2FO_ENQUEUE(PV_REFCURSOR=>pv_ref, ENQ_MSGID=>enq_msgid, queue_name=>'txaqs_FLEX2FO');
    plog.debug(pkgctx, 'ID:'||enq_msgid);
    close pv_ref;
    commit;
    plog.setendsection (pkgctx, 'pr_InvokeEnqueueTest');
EXCEPTION WHEN OTHERS THEN
    plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
    
    plog.setendsection (pkgctx, 'pr_InvokeEnqueueTest');
end pr_InvokeEnqueueTest;

PROCEDURE PR_NOTIFYEVENT2FO(
    pv_refcursor   IN            pkg_report.ref_cursor,
    queue_name IN VARCHAR2 default 'txaqs_FLEX2FO')
IS
    enq_msgid RAW(16);
BEGIN
    plog.setbeginsection (pkgctx, 'PR_NOTIFYEVENT2FO');
    

    PR_FLEX2FO_ENQUEUE(PV_REFCURSOR=>pv_refcursor, ENQ_MSGID=>enq_msgid, queue_name=> queue_name);

    
    plog.setendsection (pkgctx, 'PR_NOTIFYEVENT2FO');
EXCEPTION WHEN OTHERS THEN
    plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
    
    plog.setendsection (pkgctx, 'PR_NOTIFYEVENT2FO');
END PR_NOTIFYEVENT2FO;

--Init the plog component
BEGIN
      FOR i IN (SELECT *
                FROM tlogdebug)
      LOOP
         logrow.loglevel    := i.loglevel;
         logrow.log4table   := i.log4table;
         logrow.log4alert   := i.log4alert;
         logrow.log4trace   := i.log4trace;
      END LOOP;
      pkgctx    :=
         plog.init ('txpks_NOTIFY',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
      select sys_context('USERENV', 'CURRENT_SCHEMA') INTO ownerschema from dual;
END txpks_NOTIFY;
/
