SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE prc_3rdInsertEmailLog(
       p_email in varchar2, p_templateid in varchar2, p_datasource in varchar2,
       p_account in varchar2, p_fullname in varchar2,
       p_err_param out varchar2)
IS
    pkgctx plog.log_ctx;
    logrow tlogdebug%rowtype;
    l_count number;
--
-- Purpose: Briefly explain the functionality of the package body
-- Person      Date             Comments
-- ---------   ------           ------------------------------------------
-- TruongLD    17/01/2020       Insert emaillog 4 shv
    v_fullname      VARCHAR2(1000);
    v_email         VARCHAR2(500);
    v_datasource    VARCHAR2(4000);
    v_CUSTOMERID    VARCHAR2(100);
BEGIN

    plog.setbeginsection(pkgctx,'prc_3rdInsertEmailLog');
    v_fullname      := p_fullname;
    v_CUSTOMERID    := p_account;
    v_email         := p_email;
    v_datasource    := p_datasource;


    INSERT INTO NVSCHEDULEACCEPT(
    ECARE_NO, -- SERVICE NUMBER , NEED DEFINE, FIXED for each email template
    CHANNEL, -- 'M' > EMAIL FIX
    SEQ, -- UNIQUE KEY
    REQ_DT,  -- REQUEST DATE -'YYYYMMDD'
    REQ_TM, -- REQUEST TIME -'HH24MISS'
    TMPL_TYPE, -- 'J' >> FIX
    RECEIVER_ID, -- CUSTOMER ID
    RECEIVER_NM,  -- CUSTOMER NAME
    RECEIVER, -- CUSTOMER EMAIL
    SENDER_NM, -- SENDER NAME
    SENDER, -- SENDER EMAIL
    SEND_FG, -- 'R' > SEND FLAG 'R'EADY FIX
    JONMUN, -- TRANFER DATA -- this column content all the message (in HTML)
    PREVIEW_TYPE, -- 'N' >> FIX
    DATA_CNT, -- ATTACHEMENT FILE COUNT
    FILE_PATH1, -- ATTACHEMENT FILE1 PATH
    FILE_PATH2, -- ATTACHEMENT FILE2 PATH
    FILE_PATH3 -- ATTACHEMENT FILE3 PATH
    )
VALUES (
    44,
    'M',
    TO_CHAR(SYSTIMESTAMP,'YYYYMMDDHH24MISSFF3'),
    TO_CHAR(SYSDATE,'YYYYMMDD'),
    TO_CHAR(SYSDATE,'hh24miss'),
    'J',
    v_CUSTOMERID,
    v_fullname,
    v_email,
    'Shinhan Bank Vietnam',
    'admin@shinhan.com.vn',
    'R',
    v_datasource, --this column content all the message (in HTML)
    'N',
    0,
    '', --ATTACHEMENT FILE1 PATH in wiseU Mail Server
    '', --ATTACHEMENT FILE2 PATH in wiseU Mail Server
    '' --ATTACHEMENT FILE3 PATH in wiseU Mail Server
    );

    p_err_param := '0';
    plog.setbeginsection(pkgctx, 'prc_3rdInsertEmailLog');

EXCEPTION WHEN OTHERS THEN
    p_err_param := '-1';
    plog.error(pkgctx,sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
END;
/
