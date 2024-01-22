SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#6679ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#6679EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      24/08/2021     Created
 **
 ** (c) 2008 by Financial Software Solutions. JSC.
 ** ----------------------------------------------------------------------------------------------------*/
IS
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txAftAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txPreAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txAftAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
END;
/


CREATE OR REPLACE PACKAGE BODY txpks_#6679ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_brid             CONSTANT CHAR(2) := '00';
   c_reqid            CONSTANT CHAR(2) := '31';
   c_actiontype       CONSTANT CHAR(2) := '01';
   c_actiontypecd     CONSTANT CHAR(2) := '99';
   c_cifid            CONSTANT CHAR(2) := '02';
   c_cifida           CONSTANT CHAR(2) := '39';
   c_custodycd        CONSTANT CHAR(2) := '25';
   c_fullname         CONSTANT CHAR(2) := '04';
   c_fullnamea        CONSTANT CHAR(2) := '05';
   c_internation      CONSTANT CHAR(2) := '06';
   c_internationa     CONSTANT CHAR(2) := '07';
   c_shortname        CONSTANT CHAR(2) := '08';
   c_shortnamea       CONSTANT CHAR(2) := '09';
   c_idplace          CONSTANT CHAR(2) := '58';
   c_idplacea         CONSTANT CHAR(2) := '59';
   c_idcode           CONSTANT CHAR(2) := '10';
   c_idcodea          CONSTANT CHAR(2) := '11';
   c_iddate           CONSTANT CHAR(2) := '54';
   c_iddatea          CONSTANT CHAR(2) := '55';
   c_idexpired        CONSTANT CHAR(2) := '14';
   c_idexpireda       CONSTANT CHAR(2) := '42';
   c_dateofbirth      CONSTANT CHAR(2) := '15';
   c_dateofbirtha     CONSTANT CHAR(2) := '41';
   c_address          CONSTANT CHAR(2) := '16';
   c_addressa         CONSTANT CHAR(2) := '46';
   c_country          CONSTANT CHAR(2) := '18';
   c_countrya         CONSTANT CHAR(2) := '47';
   c_custid           CONSTANT CHAR(2) := '27';
   c_idtype           CONSTANT CHAR(2) := '34';
   c_idtypea          CONSTANT CHAR(2) := '45';
   c_email            CONSTANT CHAR(2) := '35';
   c_emaila           CONSTANT CHAR(2) := '44';
   c_fax              CONSTANT CHAR(2) := '36';
   c_faxa             CONSTANT CHAR(2) := '43';
   c_phone            CONSTANT CHAR(2) := '37';
   c_phonea           CONSTANT CHAR(2) := '38';
   c_subtaxcode       CONSTANT CHAR(2) := '60';
   c_subtaxcodea      CONSTANT CHAR(2) := '61';
   c_ceo              CONSTANT CHAR(2) := '62';
   c_ceoa             CONSTANT CHAR(2) := '63';
   c_taxcode          CONSTANT CHAR(2) := '64';
   c_taxcodea         CONSTANT CHAR(2) := '65';
   c_taxcodeissueorgan   CONSTANT CHAR(2) := '66';
   c_taxcodeissueorgana  CONSTANT CHAR(2) := '67';
   c_taxcodeexpirydate   CONSTANT CHAR(2) := '68';
   c_taxcodeexpirydatea  CONSTANT CHAR(2) := '69';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS

BEGIN
   plog.setbeginsection (pkgctx, 'fn_txPreAppCheck');
   plog.debug(pkgctx,'BEGIN OF fn_txPreAppCheck');
   /***************************************************************************************************
    * PUT YOUR SPECIFIC RULE HERE, FOR EXAMPLE:
    * IF NOT <<YOUR BIZ CONDITION>> THEN
    *    p_err_code := '<<ERRNUM>>'; -- Pre-defined in DEFERROR table
    *    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
    *    RETURN errnums.C_BIZ_RULE_INVALID;
    * END IF;
    ***************************************************************************************************/
    plog.debug (pkgctx, '<<END OF fn_txPreAppCheck');
    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'fn_txPreAppCheck');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txPreAppCheck;

FUNCTION fn_txAftAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
BEGIN
   plog.setbeginsection (pkgctx, 'fn_txAftAppCheck');
   plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppCheck>>');
   /***************************************************************************************************
    * PUT YOUR SPECIFIC RULE HERE, FOR EXAMPLE:
    * IF NOT <<YOUR BIZ CONDITION>> THEN
    *    p_err_code := '<<ERRNUM>>'; -- Pre-defined in DEFERROR table
    *    plog.setendsection (pkgctx, 'fn_txAftAppCheck');
    *    RETURN errnums.C_BIZ_RULE_INVALID;
    * END IF;
    ***************************************************************************************************/
   plog.debug (pkgctx, '<<END OF fn_txAftAppCheck>>');
   plog.setendsection (pkgctx, 'fn_txAftAppCheck');
   RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'fn_txAftAppCheck');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txAftAppCheck;

FUNCTION fn_txPreAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txPreAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txPreAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC PROCESS HERE. . DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    plog.debug (pkgctx, '<<END OF fn_txPreAppUpdate');
    plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
       plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txPreAppUpdate;

FUNCTION fn_txAftAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
v_table_name varchar2(100);
v_custid varchar2(100);

V_RECORD_KEY VARCHAR2(100);
v_modnum number;
p_err_param  varchar2(100);
v_strCURRDATE varchar2(20);
L_txnum         VARCHAR2(20);
l_txmsg         tx.msg_rectype;
v_strEN_Desc   varchar2(250);
p_xmlmsg varchar2(10000);
vold_ACTIVESTS varchar2(250);
vold_CUSTODYCD varchar2(250);
vold_COUNTRY varchar2(250);
vold_MOBILE varchar2(250);
vold_FULLNAME varchar2(250);
vold_IDCODE varchar2(250);
vold_IDDATE date;
vold_IDEXPIRED date;
vold_IDPLACE  varchar2(250);
vold_TRADINGCODE  varchar2(250);
vold_TRADINGCODEDT date;
vold_CUSTTYPE  varchar2(250);
vold_VAT  varchar2(250);
vold_ADDRESS  varchar2(250);
v_sqlcmd varchar2(4000);
vnew_country varchar2(100);
v_ACTIVESTS varchar2(10);
-- varchar2(250);

l_actiontype    varchar2(50);
l_cifid         varchar2(50);
l_cifida        varchar2(50);
l_fullname      varchar2(500);
l_fullnamea     varchar2(500);
l_internation   varchar2(500);
l_internationa  varchar2(500);
l_shortname     varchar2(500);
l_shortnamea    varchar2(500);
l_idcode        varchar2(50);
l_idcodea       varchar2(50);
l_idexpired     varchar2(50);
l_idexpireda    varchar2(50);
l_dateofbirth   varchar2(50);
l_dateofbirtha  varchar2(50);
l_address       varchar2(1000);
l_addressa      varchar2(1000);
l_country       varchar2(500);
l_countrya      varchar2(500);
l_custtype      varchar2(50);
l_custodycd     varchar2(50);
l_custid        varchar2(50);
l_reqid         varchar2(50);
l_sex           varchar2(50);
l_idtype        varchar2(50);
l_idtypea       varchar2(50);
l_email         varchar2(500);
l_emaila        varchar2(500);
l_fax           varchar2(100);
l_faxa          varchar2(100);
l_phone         varchar2(50);
l_phonea        varchar2(50);
l_subtaxcode    varchar2(100);
l_subtaxcodea   varchar2(100);
l_taxcode    varchar2(100);
l_taxcodea    varchar2(100);
l_taxcodeissueorgan    varchar2(500);
l_taxcodeissueorgana    varchar2(500);
l_taxcodeexpirydate    varchar2(100);
l_taxcodeexpirydatea    varchar2(100);
l_ceo           varchar2(500);
l_ceoa          varchar2(500);
l_iddate        varchar2(50);
l_iddatea       varchar2(50);
l_idplace       varchar2(1000);
l_idplacea      varchar2(1000);
l_desc          varchar2(4000);
l_lcbid         varchar2(50);
l_placeofbirth varchar2(500);
l_placeofbirtha varchar2(500);

BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    v_table_name:= 'CFMAST';
    V_RECORD_KEY := 'CUSTID = ';

    l_actiontype := p_txmsg.txfields(c_actiontype).VALUE;
    l_cifid := p_txmsg.txfields(c_cifid).VALUE;
    l_cifida := p_txmsg.txfields(c_cifida).VALUE;
    l_fullname := p_txmsg.txfields(c_fullname).VALUE;
    l_fullnamea := p_txmsg.txfields(c_fullnamea).VALUE;
    l_internation := p_txmsg.txfields(c_internation).VALUE;
    l_internationa := p_txmsg.txfields(c_internationa).VALUE;
    l_shortname := p_txmsg.txfields(c_shortname).VALUE;
    l_shortnamea := p_txmsg.txfields(c_shortnamea).VALUE;
    l_idcode := p_txmsg.txfields(c_idcode).VALUE;
    l_idcodea := p_txmsg.txfields(c_idcodea).VALUE;
    l_idexpired := p_txmsg.txfields(c_idexpired).VALUE;
    l_idexpireda := p_txmsg.txfields(c_idexpireda).VALUE;
    l_dateofbirth := p_txmsg.txfields(c_dateofbirth).VALUE;
    l_dateofbirtha := p_txmsg.txfields(c_dateofbirtha).VALUE;
    l_address := p_txmsg.txfields(c_address).VALUE;
    l_addressa := p_txmsg.txfields(c_addressa).VALUE;
    l_custodycd := p_txmsg.txfields(c_custodycd).VALUE;
    l_custid := p_txmsg.txfields(c_custid).VALUE;
    l_reqid := p_txmsg.txfields(c_reqid).VALUE;
    l_idtype := p_txmsg.txfields(c_idtype).VALUE;
    l_idtypea := p_txmsg.txfields(c_idtypea).VALUE;
    l_email := p_txmsg.txfields(c_email).VALUE;
    l_emaila := p_txmsg.txfields(c_emaila).VALUE;
    l_fax := p_txmsg.txfields(c_fax).VALUE;
    l_faxa := p_txmsg.txfields(c_faxa).VALUE;
    l_phone := p_txmsg.txfields(c_phone).VALUE;
    l_phonea := p_txmsg.txfields(c_phonea).VALUE;
    l_subtaxcode := p_txmsg.txfields(c_subtaxcode).VALUE;
    l_subtaxcodea := p_txmsg.txfields(c_subtaxcodea).VALUE;
    l_ceo := p_txmsg.txfields(c_ceo).VALUE;
    l_ceoa := p_txmsg.txfields(c_ceoa).VALUE;
    l_iddate := p_txmsg.txfields(c_iddate).VALUE;
    l_iddatea := p_txmsg.txfields(c_iddatea).VALUE;
    l_idplace := p_txmsg.txfields(c_idplace).VALUE;
    l_idplacea := p_txmsg.txfields(c_idplacea).VALUE;
    l_desc := p_txmsg.txfields(c_ceoa).VALUE;
    l_country := p_txmsg.txfields(c_country).VALUE;
    l_countrya := p_txmsg.txfields(c_countrya).VALUE;
    l_taxcode := p_txmsg.txfields(c_taxcode).VALUE;
    l_taxcodea := p_txmsg.txfields(c_taxcodea).VALUE;
    l_taxcodeissueorgan := p_txmsg.txfields(c_taxcodeissueorgan).VALUE;
    l_taxcodeissueorgana := p_txmsg.txfields(c_taxcodeissueorgan).VALUE;
    l_taxcodeexpirydate := p_txmsg.txfields(c_taxcodeexpirydate).VALUE;
    l_taxcodeexpirydatea := p_txmsg.txfields(c_taxcodeexpirydatea).VALUE;
    l_placeofbirtha := p_txmsg.txfields(c_countrya).VALUE;

    BEGIN
        SELECT TO_CHAR(AUTOID) INTO l_lcbid FROM FAMEMBERS WHERE ROLES = 'LCB' AND ACTIVESTATUS = 'Y' AND SHORTNAME = 'SHV';
    EXCEPTION WHEN OTHERS THEN
        l_lcbid := '';
    END;

    IF p_txmsg.deltd <> 'Y' THEN -- Normal transaction
        
        begin
            select cdval into vnew_country from allcode where CDNAME='NATIONAL' and cdcontent  = trim(l_countrya);
        exception when NO_DATA_FOUND
            then
            vnew_country := trim(l_countrya);
        end;

        SELECT DECODE(VNEW_COUNTRY,'234','005','009') INTO l_idtypea
        FROM DUAL;

        if p_txmsg.txfields ('01').VALUE = '01' then --01 them moi, 02 sua
            BEGIN
            SELECT MAX(ODR)+1 INTO v_custid  FROM
                  (SELECT ROWNUM ODR, INVACCT
                  FROM (SELECT CUSTID INVACCT FROM CFMAST WHERE SUBSTR(CUSTID,1,4)= p_txmsg.brid ORDER BY CUSTID) DAT
                  WHERE TO_NUMBER(SUBSTR(INVACCT,5,6))=ROWNUM) INVTAB
                  GROUP BY SUBSTR(INVACCT,1,4);

            v_custid:= '0001'||lpad(v_custid,6,'000');
            V_RECORD_KEY := V_RECORD_KEY || ''''||v_custid ||'''';
            select max(mod_num)+1 into v_modnum from maintain_log where table_name = v_table_name and action_flag ='ADD';
            

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'CIFID',null,l_cifida,'ADD',null,null,p_txmsg.txtime,null);
            /*
            --trung.luu: 30-03-2021 khong day vao cifid, chi day vao mastercif(cifi aither la mastercif)

            -- 39 MCIFID
            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,
                                child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'MCIFID',null,l_cifida,'ADD',null,null,p_txmsg.txtime,null);
            */

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'FULLNAME',null,l_fullnamea,'ADD',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'INTERNATION',null,l_internationa,'ADD',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'SHORTNAME',null,l_shortnamea,'ADD',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'IDCODE',null,l_idcodea,'ADD',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'IDDATE',null,l_iddatea,'ADD',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'IDEXPIRED',null,l_idexpireda,'ADD',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'DATEOFBIRTH',null,l_dateofbirtha,'ADD',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'ADDRESS',null,l_addressa,'ADD',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'COUNTRY',null,vnew_country,'ADD',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'IDTYPE',null,l_idtypea,'ADD',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'EMAIL',null,l_emaila,'ADD',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'FAX',null,l_faxa,'ADD',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'FAXNO',null,l_faxa,'ADD',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'PHONE',null,l_phonea,'ADD',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'SUBTAXCODE',null,l_subtaxcodea,'ADD',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'ESTABLISHDATE',null,l_dateofbirtha,'ADD',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'CEO',null,l_ceoa,'ADD',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'MOBILE',null,l_phonea,'ADD',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'BANKATADDRESS',null,l_addressa,'ADD',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'MOBILESMS',null,l_phonea,'ADD',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'TAXCODE',null,l_taxcodea,'ADD',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'TAXCODEDATE',null,l_iddatea,'ADD',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'TAXCODEEXPIRYDATE',null,l_taxcodeexpirydatea,'ADD',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'TAXCODEISSUEORGAN',null,l_taxcodeissueorgana,'ADD',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'LCBID',null,l_lcbid,'ADD',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'SWIFTCODE',null,'SHBKKRSEXXX','ADD',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'PLACEOFBIRTH',null,l_placeofbirtha,'ADD',null,null,p_txmsg.txtime,null);

            INSERT INTO CFMAST (COUNTRY,PROVINCE,CUSTID,CUSTODYCD,FULLNAME,TRADEFLOOR,AMCID,TRADETELEPHONE,GCBID,MNEMONIC,DATEOFBIRTH,FEEDAILY,SENDSWIFT,TRADEONLINE,BONDAGENT,
                                IDTYPE,IDCODE,IDDATE,COMMRATE,IDPLACE,IDEXPIRED,ADDRESS,RESIDENT,CONSULTANT,VAT,CUSTATCOM,SEX,BRID,CAREBY,APPROVEID,
                                LASTDATE,AUDITDATE,MRLOANLIMIT,LANGUAGE,BANKCODE,VALUDADDED,TLID,MARRIED,TAXCODE,TAXCODEDATE,TAXCODEEXPIRYDATE,CUSTTYPE,EXPERIENCECD,STATUS,ISBANKING,
                                ISFORCUSTMASTACC,MANAGETYPE,CIFID,ACTIVESTS,TRADINGCODEDT,ISCHKONLIMIT,ONLINELIMIT,MARGINALLOW,LCBID,OPNDATE,SUPEBANK,TRUSTEEID,ESTABLISHDATE,SUBTAXCODE,EMAIL,
                                CEO,PHONE,MOBILE,FAXNO,FAX,BANKATADDRESS,SHORTNAME,INTERNATION,MOBILESMS,TAXCODEISSUEORGAN,SWIFTCODE,PLACEOFBIRTH)
            VALUES (vnew_country,'--',v_custid,'',l_fullnamea,'Y','0','Y','0',l_fullnamea,TO_DATE(l_dateofbirtha, 'DD/MM/RRRR'),'Y','N','Y','N',
                    l_idtypea,l_idcodea,TO_DATE(l_iddatea, 'DD/MM/RRRR'),100,l_idplacea,TO_DATE(l_idexpireda, 'DD/MM/RRRR'),l_addressa,'001','Y',DECODE(vnew_country,'234','N','Y'),'Y','000','0001','0001','0000',
                    TO_DATE(getcurrdate, 'DD/MM/RRRR'),TO_DATE(getcurrdate, 'DD/MM/RRRR'),0,'001','000','000','0001','004',l_taxcodea,TO_DATE(l_iddatea, 'DD/MM/RRRR'),TO_DATE(l_taxcodeexpirydatea, 'DD/MM/RRRR'),'B','00000','P','N',
                    'N','A',l_cifida,'N',TO_DATE(getcurrdate, 'DD/MM/RRRR'),'Y',0,'Y',l_lcbid,TO_DATE(l_dateofbirtha, 'DD/MM/RRRR'),'N','0',TO_DATE(l_dateofbirtha, 'DD/MM/RRRR'),l_subtaxcodea,l_emaila,
                    l_ceoa,l_phonea,l_phonea,l_faxa,l_faxa,l_addressa,l_shortnamea,l_internationa,l_phonea,l_taxcodeissueorgana,'SHBKKRSEXXX',vnew_country);

            INSERT INTO afmast (ACTYPE, CUSTID, ACCTNO, AFTYPE, BANKACCTNO, BANKNAME, SWIFTCODE, STATUS, PSTATUS, BRATIO, AUTOADV, ALTERNATEACCT, VIA, COREBANK,
            GROUPLEADER, BRKFEETYPE, TLID, BRID, CAREBY, MRIRATE, MRSRATE, MRMRATE, MRLRATE, MBIRATE, MBSRATE, MBMRATE, MBLRATE, MCIRATE, MCSRATE, MCMRATE, MCLRATE, MRIRATIO,
            MRSRATIO, MRMRATIO, MRLRATIO, ADDRATE, ADDDAY, BASECALLDAY, EXTCALLDAY, TERMOFUSE, DESCRIPTION, ISOTC, PISOTC, DEPOLASTDT, TRIGGERDATE, OPNDATE, CLSDATE, ADVANCELINE,
            DEPOSITLINE, T0AMT, MRCRLIMIT, MRCRLIMITMAX, DPCRLIMITMAX, LIMITDAILY, ISFIXACCOUNT,
            AUTOTRF, CHGACTYPE, LASTDATE, LAST_CHANGE, TRADELINE, SMSTYPE, PSMSTYPE, BEGINCALLDATE, ENDCALLDATE, ENDTRIGGERDATE, CALLDAY, APPLYSCR, ISTRIGGER, ISODDLOT)
            VALUES ('0000',v_custid,v_custid,'000','','','','A','P',100,'Y','N','F','N','','CF','0022','0001','0001',0,0,0,0,100,100,100,100,0,0,0,0,0,0,0,0,0,0,0,0,'001','','N','N','','',TO_DATE(getcurrdate, 'DD/MM/RRRR'),'',0,0,0,0,0,0,'2000000000000','N','N','N',TO_DATE(getcurrdate, 'DD/MM/RRRR'),TO_DATE(getcurrdate, 'DD/MM/RRRR'),0,'','','','','','','N','','N' );

            update cfmast_aither set status = 'C',lastchange= systimestamp where reqid = l_reqid;
            END;
        ELSE
            BEGIN
            --active VSD moi sinh 0017
            --select ACTIVESTS into v_ACTIVESTS from cfmast where cifid =p_txmsg.txfields ('39').VALUE;
            BEGIN
                SELECT ACTIVESTS, PLACEOFBIRTH INTO V_ACTIVESTS, L_PLACEOFBIRTH FROM CFMAST WHERE CUSTODYCD = L_CUSTODYCD; --TRUNG.LUU: 19-03-2021 SHBVNEX-2159 LAM GIAO DICH 6679 CHO TUNG TAI KHOAN LUU KY
            EXCEPTION WHEN OTHERS THEN
                V_ACTIVESTS := 'N';
            END;

            select max(mod_num)+1 into v_modnum from maintain_log where table_name = v_table_name and action_flag ='EDIT';
            v_custid :=l_custid;
            V_RECORD_KEY := V_RECORD_KEY || ''''||v_custid ||'''';
            

            BEGIN
            /*
            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'CIFID',l_cifid,l_cifida,'ADD',null,null,p_txmsg.txtime,null);
            */

            --trung.luu: 30-03-2021 khong day vao cifid, chi day vao mastercif(cifi aither la mastercif)

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'MCIFID',null,l_cifida,'ADD',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'FULLNAME',l_fullname,l_fullnamea,'EDIT',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'INTERNATION',l_internation,l_internationa,'EDIT',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'SHORTNAME',l_shortname,l_shortnamea,'EDIT',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'IDCODE',l_idcode,l_idcodea,'EDIT',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'IDDATE',l_iddate,l_iddatea,'EDIT',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'IDEXPIRED',l_idexpired,l_idexpireda,'EDIT',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'DATEOFBIRTH',l_dateofbirth,l_dateofbirtha,'EDIT',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'ADDRESS',l_address,l_addressa,'EDIT',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'COUNTRY',l_country,vnew_country,'EDIT',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'IDTYPE',l_idtype,l_idtypea,'EDIT',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'EMAIL',l_email,l_emaila,'EDIT',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'FAX',l_fax,l_faxa,'EDIT',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'FAXNO',l_fax,l_faxa,'EDIT',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'PHONE',l_phone,l_phonea,'EDIT',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'SUBTAXCODE',l_subtaxcode,l_subtaxcodea,'EDIT',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'ESTABLISHDATE',l_dateofbirth,l_dateofbirtha,'EDIT',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'CEO',l_ceo,l_ceoa,'EDIT',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'BANKATADDRESS',l_address,l_addressa,'EDIT',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'MOBILESMS',l_phone,l_phonea,'EDIT',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'TAXCODE',l_taxcode,l_taxcodea,'EDIT',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'TAXCODEDATE',l_iddate,l_iddatea,'EDIT',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'TAXCODEEXPIRYDATE',l_taxcodeexpirydate,l_taxcodeexpirydatea,'EDIT',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'TAXCODEISSUEORGAN',l_taxcodeissueorgan,l_taxcodeissueorgana,'EDIT',null,null,p_txmsg.txtime,null);

            insert into maintain_log (table_name,record_key,maker_id,maker_dt,approve_rqd,approve_id,approve_dt,mod_num,column_name,from_value,to_value,action_flag,child_table_name,child_record_key,maker_time,approve_time)
            values (v_table_name,V_RECORD_KEY,p_txmsg.tlid,p_txmsg.txdate,'Y',null,null,v_modnum,'PLACEOFBIRTH',l_placeofbirth,l_placeofbirtha,'EDIT',null,null,p_txmsg.txtime,null);

            UPDATE CFMAST SET
            STATUS = 'P',
            last_mkid = p_txmsg.tlid,
            last_ofid = nvl(p_txmsg.offid,p_txmsg.tlid)
            WHERE CUSTID = v_custid;

            insert into cfmastmemo s select *from cfmast where CUSTID = v_custid;
            update cfmastmemo set
            mcifid = l_cifida,
            fullname = l_fullnamea,
            internation = l_internationa,
            shortname = l_shortnamea,
            idcode = l_idcodea,
            iddate = to_date(l_iddatea, 'DD/MM/RRRR'),
            idexpired = to_date(l_idexpireda, 'DD/MM/RRRR'),
            dateofbirth = to_date(l_dateofbirtha,'DD/MM/RRRR'),
            address = l_addressa,
            country = vnew_country,
            idtype = l_idtypea,
            email = l_emaila,
            fax = l_faxa,
            faxno =l_faxa,
            phone =l_phonea,
            subtaxcode = l_subtaxcodea,
            establishdate = to_date(l_dateofbirtha, 'DD/MM/RRRR'),
            ceo = l_ceoa,
            bankataddress = l_addressa,
            mobilesms = l_phonea,
            taxcode = l_taxcodea,
            taxcodedate = to_date(l_iddate, 'DD/MM/RRRR'),
            taxcodeexpirydate = to_date(l_taxcodeexpirydatea, 'DD/MM/RRRR'),
            taxcodeissueorgan = l_taxcodeissueorgana,
            placeofbirth = l_placeofbirtha
            WHERE CUSTID = v_custid;

            v_sqlcmd:= 'UPDATE CFMAST SET MCIFID=''' || l_cifida ||''',FULLNAME='''|| l_fullnamea ||''',INTERNATION='''|| l_internationa ||''',SHORTNAME='''|| l_shortnamea ||''',';
            v_sqlcmd:=v_sqlcmd||'IDCODE='''|| l_idcodea ||''',IDDATE=to_date('''|| l_iddatea ||''',''DD/MM/RRRR''),IDEXPIRED=to_date('''|| l_idexpireda ||''',''DD/MM/RRRR''),DATEOFBIRTH=to_date('''|| l_dateofbirtha ||''',''DD/MM/RRRR''),ADDRESS ='''|| l_addressa ||''',';
            v_sqlcmd:=v_sqlcmd||'COUNTRY='''|| vnew_country ||''',IDTYPE='''|| l_idtypea ||''',EMAIL='''|| l_emaila ||''',FAX='''|| l_faxa ||''',FAXNO='''|| l_faxa ||''',';
            v_sqlcmd:=v_sqlcmd||'PHONE='''|| l_phonea ||''',SUBTAXCODE='''|| l_subtaxcodea ||''',ESTABLISHDATE=to_date('''|| l_dateofbirtha ||''',''DD/MM/RRRR''),CEO='''|| l_ceoa ||''',BANKATADDRESS='''|| l_addressa ||''',';
            v_sqlcmd:=v_sqlcmd||'MOBILESMS='''|| l_phonea ||''',TAXCODE='''|| l_taxcodea ||''',TAXCODEDATE=to_date('''|| l_iddate ||''',''DD/MM/RRRR''),TAXCODEEXPIRYDATE=to_date('''|| l_taxcodeexpirydatea ||''',''DD/MM/RRRR''),';
            v_sqlcmd:=v_sqlcmd||'TAXCODEISSUEORGAN ='''|| l_taxcodeissueorgana ||''' WHERE 0=0 AND CUSTID ='''|| v_custid||'''';

            
            Insert into apprvexec (autoid,table_name,record_key,child_table_name,child_record_key,action_flag,sqlcmd,sqlcmdtype,status,make_dt,maketime) values
            (seq_apprvexec.nextval,'CFMAST',V_RECORD_KEY, '', '','EDIT',v_sqlcmd,'1','N',To_Date(p_txmsg.TXDATE,'DD/MM/RRRR'), SYSTIMESTAMP);
            END;
            if v_ACTIVESTS = 'Y' then
                BEGIN
                SELECT TO_DATE (varvalue, systemnums.c_date_format)
                       INTO v_strCURRDATE
                       FROM sysvar
                       WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
                SELECT systemnums.C_HO_BRID
                                 || LPAD (seq_BATCHTXNUM.NEXTVAL, 6, '0')
                          INTO l_txmsg.txnum
                          FROM DUAL;
                l_txmsg.msgtype:='T';
                l_txmsg.local:='N';
                l_txmsg.tlid        := p_txmsg.tlid;
                l_txmsg.brid        := p_txmsg.brid;
                SELECT SYS_CONTEXT ('USERENV', 'HOST'),
                         SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
                  INTO l_txmsg.wsname, l_txmsg.ipaddress
                FROM DUAL;
                select txdesc into v_strEN_Desc from tltx where tltxcd = '0017';

                l_txmsg.off_line    := 'N';
                L_TXMSG.DELTD       := TXNUMS.C_DELTD_TXNORMAL;
                L_TXMSG.TXSTATUS    := TXSTATUSNUMS.c_txpending;
                l_txmsg.ovrrqd      := '@00';
                l_txmsg.msgsts      := '0';
                l_txmsg.ovrsts      := '0';
                l_txmsg.batchname   := 'DAY';
                l_txmsg.txtime    := to_char(SYSdate,'hh24:mi:ss');
                l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
                l_txmsg.BUSDATE:=to_date(v_strCURRDATE,systemnums.c_date_format);
                l_txmsg.tltxcd:='0017';
                l_txmsg.nosubmit    := '2';


                begin
                    select ACTIVESTS,CUSTODYCD ,COUNTRY,MOBILE,FULLNAME ,IDCODE ,IDDATE,IDEXPIRED ,IDPLACE,TRADINGCODE,TRADINGCODEDT,CUSTTYPE ,VAT ,ADDRESS
                        into vold_ACTIVESTS,vold_CUSTODYCD ,vold_COUNTRY,vold_MOBILE,vold_FULLNAME ,vold_IDCODE ,vold_IDDATE,vold_IDEXPIRED ,vold_IDPLACE,vold_TRADINGCODE,vold_TRADINGCODEDT,
                            vold_CUSTTYPE ,vold_VAT ,vold_ADDRESS
                        from cfmast where custid = v_custid;
                exception when NO_DATA_FOUND
                    then
                    vold_ACTIVESTS := '';
                    vold_CUSTODYCD := '';
                    vold_COUNTRY := '';
                    vold_MOBILE := '';
                    vold_FULLNAME := '';
                    vold_IDCODE := getcurrdate;
                    vold_IDDATE:= getcurrdate;
                    vold_IDEXPIRED := getcurrdate;
                    vold_IDPLACE:= '';
                    vold_TRADINGCODE:= '';
                    vold_TRADINGCODEDT:= getcurrdate;
                    vold_CUSTTYPE := '';
                    vold_VAT := '';
                    vold_ADDRESS := '';
                end;

                l_txmsg.txfields ('03').defname   := 'CUSTID';
                l_txmsg.txfields ('03').TYPE      := 'C';
                l_txmsg.txfields ('03').VALUE      := v_custid;
                ------ACTIVESTS
                l_txmsg.txfields ('15').defname   := 'ACTIVESTS';
                l_txmsg.txfields ('15').TYPE      := 'C';
                l_txmsg.txfields ('15').VALUE      := vold_ACTIVESTS;
                ------CUSTODYCD
                l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                l_txmsg.txfields ('88').TYPE      := 'D';
                l_txmsg.txfields ('88').VALUE      := vold_CUSTODYCD;
                ------COUNTRY
                l_txmsg.txfields ('87').defname   := 'COUNTRY';
                l_txmsg.txfields ('87').TYPE      := 'C';
                l_txmsg.txfields ('87').VALUE      := vold_COUNTRY;
                ------MOBILE
                l_txmsg.txfields ('86').defname   := 'MOBILE';
                l_txmsg.txfields ('86').TYPE      := 'C';
                l_txmsg.txfields ('86').VALUE      := vold_MOBILE;
                ------FULLNAME
                l_txmsg.txfields ('28').defname   := 'FULLNAME';
                l_txmsg.txfields ('28').TYPE      := 'C';
                l_txmsg.txfields ('28').VALUE      := vold_FULLNAME;
                ------NFULLNAME
                l_txmsg.txfields ('38').defname   := 'NFULLNAME';
                l_txmsg.txfields ('38').TYPE      := 'C';
                l_txmsg.txfields ('38').VALUE      := l_fullnamea;
                ------IDCODE
                l_txmsg.txfields ('21').defname   := 'IDCODE';
                l_txmsg.txfields ('21').TYPE      := 'C';
                l_txmsg.txfields ('21').VALUE      := vold_IDCODE;
                ------NIDCODE
                l_txmsg.txfields ('31').defname   := 'NIDCODE';
                l_txmsg.txfields ('31').TYPE      := 'C';
                l_txmsg.txfields ('31').VALUE      := l_idcodea;
                ------IDDATE
                l_txmsg.txfields ('22').defname   := 'IDDATE';
                l_txmsg.txfields ('22').TYPE      := 'D';
                l_txmsg.txfields ('22').VALUE      := vold_IDDATE;
                ------NIDDATE
                l_txmsg.txfields ('32').defname   := 'NIDDATE';
                l_txmsg.txfields ('32').TYPE      := 'D';
                l_txmsg.txfields ('32').VALUE      := TO_DATE(l_iddatea, 'DD/MM/RRRR');
                ------IDEXPIRED
                l_txmsg.txfields ('23').defname   := 'IDEXPIRED';
                l_txmsg.txfields ('23').TYPE      := 'D';
                l_txmsg.txfields ('23').VALUE      := vold_IDEXPIRED;
                ------NIDEXPIRED
                l_txmsg.txfields ('33').defname   := 'NIDEXPIRED';
                l_txmsg.txfields ('33').TYPE      := 'D';
                l_txmsg.txfields ('33').VALUE      := to_date(l_idexpireda,'DD/MM/RRRR');
                ------IDPLACE
                l_txmsg.txfields ('24').defname   := 'IDPLACE';
                l_txmsg.txfields ('24').TYPE      := 'C';
                l_txmsg.txfields ('24').VALUE      := vold_IDPLACE;
                ------NIDPLACE
                l_txmsg.txfields ('34').defname   := 'NIDPLACE';
                l_txmsg.txfields ('34').TYPE      := 'C';
                l_txmsg.txfields ('34').VALUE      := l_idplacea;

                ------TRADINGCODE
                l_txmsg.txfields ('25').defname   := 'TRADINGCODE';
                l_txmsg.txfields ('25').TYPE      := 'C';
                l_txmsg.txfields ('25').VALUE      := vold_TRADINGCODE;

                ------NTRADINGCODE
                l_txmsg.txfields ('35').defname   := 'NTRADINGCODE';
                l_txmsg.txfields ('35').TYPE      := 'C';
                l_txmsg.txfields ('35').VALUE      := vold_TRADINGCODE;

                ------TRADINGCODEDT
                l_txmsg.txfields ('26').defname   := 'TRADINGCODEDT';
                l_txmsg.txfields ('26').TYPE      := 'D';
                l_txmsg.txfields ('26').VALUE      := vold_TRADINGCODEDT;

                ------NTRADINGCODEDT
                l_txmsg.txfields ('36').defname   := 'NTRADINGCODEDT';
                l_txmsg.txfields ('36').TYPE      := 'D';
                l_txmsg.txfields ('36').VALUE      := vold_TRADINGCODEDT;

                ------CUSTTYPE
                l_txmsg.txfields ('45').defname   := 'CUSTTYPE';
                l_txmsg.txfields ('45').TYPE      := 'C';
                l_txmsg.txfields ('45').VALUE      := vold_CUSTTYPE;

                ------NCUSTTYPE
                l_txmsg.txfields ('46').defname   := 'NCUSTTYPE';
                l_txmsg.txfields ('46').TYPE      := 'C';
                l_txmsg.txfields ('46').VALUE      := vold_CUSTTYPE;

                ------VAT
                l_txmsg.txfields ('47').defname   := 'VAT';
                l_txmsg.txfields ('47').TYPE      := 'C';
                l_txmsg.txfields ('47').VALUE      := vold_VAT;

                ------NVAT
                l_txmsg.txfields ('48').defname   := 'NVAT';
                l_txmsg.txfields ('48').TYPE      := 'C';
                l_txmsg.txfields ('48').VALUE      := vold_VAT;

                ------ADDRESS
                l_txmsg.txfields ('27').defname   := 'ADDRESS';
                l_txmsg.txfields ('27').TYPE      := 'C';
                l_txmsg.txfields ('27').VALUE      := vold_ADDRESS;

                ------NADDRESS
                l_txmsg.txfields ('37').defname   := 'NADDRESS';
                l_txmsg.txfields ('37').TYPE      := 'C';
                l_txmsg.txfields ('37').VALUE      := l_addressa;

                ------TYPEOFDOCUMENT
                l_txmsg.txfields ('83').defname   := 'TYPEOFDOCUMENT';
                l_txmsg.txfields ('83').TYPE      := 'C';
                l_txmsg.txfields ('83').VALUE      := '';

                ------STATUS
                l_txmsg.txfields ('82').defname   := 'STATUS';
                l_txmsg.txfields ('82').TYPE      := 'C';
                l_txmsg.txfields ('82').VALUE      := 'R';

                ------DESC
                l_txmsg.txfields ('30').defname   := 'DESC';
                l_txmsg.txfields ('30').TYPE      := 'C';
                l_txmsg.txfields ('30').VALUE      := v_strEN_Desc;



                p_err_code    := systemnums.c_success;
                p_err_param := 'SUCCESS';

                p_xmlmsg := txpks_msg.fn_obj2xml(l_txmsg);
                IF  txpks_#0017.fn_txProcess(p_xmlmsg, p_err_code, p_err_param) <> systemnums.c_success THEN
                    plog.error (pkgctx,'got error 0017: '|| p_err_code);
                    RETURN errnums.C_BIZ_RULE_INVALID;
                else
                    p_err_code:=systemnums.c_success;
                end if ;
                END;
            end if;

            update cfmast_aither set status = 'C',lastchange= systimestamp where reqid = l_reqid;
            END;
        end if;
    end if;
    plog.debug (pkgctx, '<<END OF fn_txAftAppUpdate');
    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
       plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txAftAppUpdate;

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
         plog.init ('TXPKS_#6679EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#6679EX;
/
