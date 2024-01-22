SET DEFINE OFF;
CREATE OR REPLACE PACKAGE pks_data_conversion
  IS
--
-- To modify this template, edit file PKGSPEC.TXT in TEMPLATE
-- directory of SQL Navigator
--
-- Purpose: Briefly explain the functionality of the package
--
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- ---------   ------  ------------------------------------------
   -- Enter package declarations as shown below


  --PROCEDURE pr_DoConvert(p_date in varchar2);

  PROCEDURE pr_InitSetup(p_date in varchar2);
 procedure ResetSeq  ;
  PROCEDURE pr_GenDefaultData;
procedure Truncate_table;
  function todate(p_date in varchar2)
  return date;
    function tonumber(p_number in varchar2)
  return number;



  PROCEDURE pr_Do_CFMAST;

  PROCEDURE PR_DO_DDMASTCV  ;

  PROCEDURE pr_Do_FAMEMBERS;

  PROCEDURE pr_Do_SBSECURITIES;

  PROCEDURE pr_do_semastcv  ;

  PROCEDURE pr_DoConvert(p_date in varchar2);

  PROCEDURE pr_Gen_AfterConvert;


END; -- Package spec
/


CREATE OR REPLACE PACKAGE BODY pks_data_conversion
IS

pkgctx plog.log_ctx;
logrow tlogdebug%rowtype;

c_custodycd_prefix_4        CONSTANT CHAR(4) := '022C';
c_date_default              CONSTANT char(10) := '01/01/1900';
c_brid_HO                   CONSTANT char(4) := '0001';

E_SYSTEM_ERROR EXCEPTION;

PROCEDURE pr_DoConvert(p_date in varchar2)
IS

BEGIN
    pr_Do_CFMAST;
    PR_DO_DDMASTCV;
    pr_Do_FAMEMBERS;
    pr_do_semastcv;

RETURN;
EXCEPTION
  WHEN others THEN
    plog.error('CONVERT:' || SQLERRM || '.At:' || dbms_utility.format_error_backtrace);
    rollback;
    RAISE errnums.E_SYSTEM_ERROR;
END;

PROCEDURE pr_InitSetup(p_date in varchar2)
IS
l_currdate date;
l_prevdate date;
l_nextdate date;

BEGIN
  -- Tam thoi cap nhat dong cua he thong
    update sysvar set varvalue = '0' where varname = 'HOSTATUS';
        begin
                for rec in
                (
                select * from user_objects where object_type = 'TRIGGER'
                )
                loop
                             execute immediate 'ALTER TRIGGER ' || rec.object_name || ' DISABLE';
                end loop;
        end;

    l_currdate:= to_date(p_date,'DD/MM/RRRR');
    select min(sbdate) into l_nextdate from sbcldr where sbdate > l_currdate and holiday = 'N';
    select max(sbdate) into l_prevdate from sbcldr where sbdate < l_currdate and holiday = 'N';

    update sysvar set varvalue = to_char(l_currdate,'DD/MM/RRRR') where grname = 'SYSTEM' and varname = 'SYSTEMSTARTDATE';
    update sysvar set varvalue = to_char(l_currdate,'DD/MM/RRRR') where grname = 'SYSTEM' and varname = 'CURRDATE';
    update sysvar set varvalue = to_char(l_prevdate,'DD/MM/RRRR') where grname = 'SYSTEM' and varname = 'PREVDATE';
    update sysvar set varvalue = to_char(l_currdate,'DD/MM/RRRR') where grname = 'SYSTEM' and varname = 'BUSDATE';
    update sysvar set varvalue = to_char(l_nextdate,'DD/MM/RRRR') where grname = 'SYSTEM' and varname = 'NEXTDATE';

    update sbcldr set sbbusday = 'N' where sbdate <> l_currdate and sbbusday = 'Y';
    update sbcldr set sbbusday = 'Y' where cldrtype = '000' and sbdate = l_currdate;
    commit;
    pr_gen_sbcurrdate;
    commit;
EXCEPTION
  WHEN others THEN
    plog.error('CONVERT:' || SQLERRM || '.At:' || dbms_utility.format_error_backtrace);
    rollback;
    RAISE errnums.E_SYSTEM_ERROR;
END;

PROCEDURE pr_GenDefaultData
IS
BEGIN

---- Sequence
reset_sequence('seq_bridtype',1);
reset_sequence('seq_ICCFTYPEDEF',1);
reset_sequence('seq_cifeedef',1);
reset_sequence('seq_iccftier',1);
reset_sequence('seq_afidtype',1);
reset_sequence('seq_cfmast_convert',1);
reset_sequence('seq_cfauth',1);
reset_sequence('seq_cfcontact',1);
reset_sequence('seq_cfotheracc',1);
reset_sequence('seq_tlgroups_convert',1);
reset_sequence('seq_CVtxnum',1);
reset_sequence('SEQ_TLLOG',1);
reset_sequence('SEQ_CITRAN',1);
reset_sequence('seq_ciinttran',1);
reset_sequence('SEQ_SETRAN',1);
reset_sequence('seq_Cv_orderid',1);
reset_sequence('seq_stschd',1);
reset_sequence('seq_adschd',1);
reset_sequence('seq_lnmast',1);
reset_sequence('seq_lnschd',1);
reset_sequence('seq_dfgroup',1);
reset_sequence('seq_cfmast_bankid',1);
reset_sequence('seq_cfcontact',1);
reset_sequence('seq_tlgrpusers',1);
reset_sequence('seq_lntype_df',1);
reset_sequence('seq_tlgrpaftype',1);
reset_sequence('SEQ_DFTRAN',1);
reset_sequence('seq_secbasket',1);
reset_sequence('seq_lnsebasket',1);
reset_sequence('seq_tlgrpaftype',1);
reset_sequence('seq_emaillog',1);
reset_sequence('seq_cifeeschd',1);
reset_sequence('SEQ_TLLOGFLD',1);
reset_sequence('SEQ_TLLOG',1);


EXECUTE immediate 'truncate table tllogall';
EXECUTE immediate 'truncate table tllogfldall';
EXECUTE immediate 'truncate table tllog';
EXECUTE immediate 'truncate table tllogfld';
EXECUTE immediate 'truncate table tlgrpusers';
EXECUTE immediate 'truncate table securities_info_log';



EXCEPTION
  WHEN others THEN
    plog.error('CONVERT:' || SQLERRM || '.At:' || dbms_utility.format_error_backtrace);
    rollback;
    RAISE errnums.E_SYSTEM_ERROR;
END;

procedure Truncate_table  IS
  str  nvarchar2(3200);
  V_STRSQL VARCHAR2(1000);
BEGIN

    dbms_utility.exec_ddl_statement('TRUNCATE TABLE convert_log' );

    Delete from tlgroups;
    Delete from tlgrpusers;
    Delete from tlprofiles where tlid not in ('0001','0000','6868','9999');
    Delete from brgrp where brid <> '0001';

    Begin
        for rec in
        (
            select object_name
            from user_objects
            where object_type='TABLE' AND GENERATED ='N'
                -- System const
                AND  INSTR('CMDMENU/TLTX/ALLCODE/APPCHK/APPEVENTS/APPMAP/APPMAPBRAVO/APPMODULES/APPRULES/APPRVRQD/BUSMAPTX/TEMPLATES/'
                        || 'APPTX/CONTENTTMP/CRBDEFACCT/CRBDEFBANK/CRBTXMAP/CRBTXMAPEXT/DEFERROR/EVAL_EXPRESSTION/FILEMAP/'
                        || 'FILEMASTER/FLDAMTEXP/FLDDEFDESC/FLDMASTER/FLDVAL/GLREF/GLREFCOM/GLRULES/GRMASTER/GRTYPE/'
                        || 'ICCFTX/MIS_ITEMS/MIS_ITEM_GROUPS/MIS_ITEM_RESULTS/MSGMAP/MSGMAP_HA/MSGMAST/MSGMAST_HA/'
                        || 'OBJMASTER/PMTXMAP/POSTMAP/PRCHK/RECONCILE/SBBATCHCTL/SBCLDR/SBCURRDATE/SBCURRDATE4NEW/SBCURRENCY/SBFXRT/SBFXRTMNT/'
                        || 'HASECURITY_REQ/HA_BRD/ISSUERS/ORDERSYS/ORDERSYS_HA/ORDERSYS_UPCOM/TRADERID/'
                        || 'SECURITIES_INFO/SECURITIES_RATE/SECURITIES_RISK/SECURITIES_TICKSIZE/VSDTXMAP/VSDTRFCODE/VSDTXMAPEXT/VSDBICCODE/'
                        || 'SEARCH/SEARCHFLD/SYSVAR/TBLBACKUP/TLOGDEBUG/TRFGL/VERSION/VIEWLNK2TMP/VOUCHERLIST/EVAL_EXPRESSTION'
                        || 'RPTFIELDS/RPTITEMS/RPTMASTER/TABLINK/TXMAPGLRULES/WATCHLIST/HO_SEC_INFO/SBSECURITIES/DEPOSIT_MEMBER'
                        , object_name) = 0
                -- Product

                AND  INSTR('ADTYPE/AFIDTYPE/AFTYPE/CITYPE/BASKET/CIFEEDEF/CLTYPE/DFTYPE/DFBASKET/FEEMAP/FEEMASTER/FNTYPE/'
                        || 'FOTYPE/ICCFTIER/ICCFTYPEDEF/LMTYPE/LNTYPE/MRTYPE/ODTYPE/RETYPE/TDTYPE/PLYCFTYPE/PRAFMAP/SETYPE/'
                        || 'PRMASTER/PRTYPE/PRTYPEMAP/SECBASKET/TLGRPAFTYPE/BANKCODE/BANKINFO/BANKNOSTRO/BANK_INFO/CFLIMIT/CFLIMITMAP/'
                        , object_name) = 0

                -- Bang tempCV
                AND  INSTR('FO_BO2FO_QUEUE/TXAQS_FLEX2/TXAQS_FLEX2FO_QUEUE/TXAQS_FLEX2VSD_TABLE/FO_FO2BO_QUEUE/FO_BO2FO_QUEUE_LOG'
                        , object_name) = 0

                AND object_name NOT IN ('T_ADSCHDCV','T_AFMASTCV','T_BANKLISTCV','T_CFAUTHCV','T_CFMASTCV','T_CIMASTCV',
                                        'T_LNMASTCV','T_OTHERACCTCV','T_SEMASTCV','T_STSCHDCV')

                AND object_name NOT LIKE 'PLSQL_PROFILER%'

                 AND object_name NOT LIKE 'AQ$%'

                -- System Param and auth
                AND  INSTR('BRGRP/BRGRPPARAM/TLGROUPS/TLPROFILES/TLGRPUSERS/'
                        || 'BRIDMAP/BRIDTYPE/CMDAUTH/TLAUTH/'
                        , object_name) = 0
            order by object_name
        )loop
            Begin
                V_STRSQL := ' truncate table ' || rec.object_name;
                EXECUTE IMMEDIATE V_STRSQL;
            exception
                when others then
                    plog.error(pkgctx, sqlerrm || V_STRSQL);
                    CONTINUE;
            End;
        End loop;
    exception
    when others then
        plog.error('CONVERT:' || SQLERRM || '.At:' || dbms_utility.format_error_backtrace);
    End;


exception
    when others then
      plog.error('CONVERT:' || SQLERRM || '.At:' || dbms_utility.format_error_backtrace);
end;

procedure ResetSeq  IS

    v_strSEQName    VARCHAR2(100);
begin

    For rec in
    (
        select object_name from user_objects where object_type='SEQUENCE'
    )loop
        v_strSEQName := rec.object_name;
        Begin
            RESET_SEQUENCE(SEQ_NAME => v_strSEQName, STARTVALUE => 1);
        Exception
            when others then
                plog.error(pkgctx, sqlerrm || ', v_strSEQName: ' || v_strSEQName);
                CONTINUE;
        End;
    End loop;

    COMMIT;


exception
    when others then
      plog.error('CONVERT:' || SQLERRM || '.At:' || dbms_utility.format_error_backtrace);
end;

PROCEDURE pr_Do_CFMAST
IS
l_loginpwd varchar2(10);
l_tradingpwd varchar2(10);
l_datasourcesql varchar2(1000);
BEGIN

    reset_sequence('seq_cfmast_convert', 1);
    reset_sequence('seq_ddmast', 1);
    Delete from cfmast;
    Delete from afmast;
    Delete from ddmast;


    INSERT INTO CFMAST
    (
        ACTIVEDATE,
        ACTIVESTS,
        ADDRESS,
        AFSTATUS,
        AMCID,
        APPROVEID,
        ASSETRANGE,
        AUDITDATE,
        AUDITORID,
        BANKACCTNO,
        BANKATADDRESS,
        BANKCODE,
        BRID,
        BUSINESSTYPE,
        CAREBY,
        CEO,
        CFCLSDATE,
        CIFID,
        CLASS,
        COMMRATE,
        COMPANYID,
        CONSULTANT,
        CONTRACTNO,
        COUNTRY,
        CUSTATCOM,
        CUSTID,
        CUSTODYCD,
        CUSTTYPE,
        DATEOFBIRTH,
        DESCRIPTION,
        DMSTS,
        EDUCATION,
        EMAIL,
        EMAILBR,
        ESTABLISHDATE,
        EXPERIENCECD,
        EXPERIENCETYPE,
        FAX,
        FAXNO,
        FOCUSTYPE,
        FULLNAME,
        GCBID,
        GRINVESTOR,
        HEADOFFICE,
        HEADOFFICECORP,
        IDCODE,
        IDDATE,
        IDEXPIRED,
        IDPLACE,
        IDTYPE,
        INCOMERANGE,
        INTERNATION,
        INVESTMENTEXPERIENCE,
        INVESTRANGE,
        INVESTTYPE,
        ISBANKING,
        ISCHKONLIMIT,
        ISFORCUSTMASTACC,
        ISSUERID,
        LANGUAGE,
        LAST_CHANGE,
        LAST_MKID,
        LAST_OFID,
        LASTDATE,
        LCBID,
        MANAGETYPE,
        MARGINALLOW,
        MARGINCONTRACTNO,
        MARRIED,
        MNEMONIC,
        MOBILE,
        MOBILESMS,
        MRLOANLIMIT,
        NSDSTATUS,
        OCCUPATION,
        OLAUTOID,
        ONLINELIMIT,
        OPENVIA,
        OPERATINGMODE,
        OPNDATE,
        ORGINF,
        PCUSTODYCD,
        PHONE,
        PIN,
        PLACEOFBIRTH,
        POSITION,
        POSTCODE,
        PROVINCE,
        PSTATUS,
        REFNAME,
        RESIDENT,
        RISKLEVEL,
        SECTOR,
        SEX,
        SHORTNAME,
        STAFF,
        STATUS,
        SUBTAXCODE,
        SUPEBANK,
        SWIFTCODE,
        T0LOANLIMIT,
        TAXCODE,
        TAXCODEDATE,
        TAXCODEEXPIRYDATE,
        TAXCODEISSUEORGAN,
        TIMETOJOIN,
        TLID,
        TRADEFLOOR,
        TRADEONLINE,
        TRADETELEPHONE,
        TRADINGCODE,
        TRADINGCODEDT,
        TRUSTEEID,
        USERNAME,
        VALUDADDED,
        VAT
    )
    SELECT MST.*
    FROM
    (
        select cv.OPNDATE ACTIVEDATE,
                'A' ACTIVESTS,
                CV.ADDRESS,
                'A' AFSTATUS,
                NVL(AMC.AUTOID, 0) AMCID,
                '0000' APPROVEID,
                '000' ASSETRANGE,
                pks_data_conversion.todate(null) AUDITDATE,
                '' AUDITORID,
                '' BANKACCTNO,
                '' BANKATADDRESS,
                '' BANKCODE,
                CV.BRID,
                '009' BUSINESSTYPE,
                CV.CAREBY,
                CV.CEO,
                pks_data_conversion.todate(null) CFCLSDATE,
                CV.CIFNO CIFID,
                '001' CLASS,
                0 COMMRATE,
                '' COMPANYID,
                'I' CONSULTANT,
                '' CONTRACTNO,
                CV.COUNTRY,
                (case when SUBSTR(custodycd,1,3) ='SHB' then 'Y' else 'N' end)  CUSTATCOM,
                cv.custodycd CUSTID,
                CV.CUSTODYCD,
                CV.CUSTTYPE,
                CV.DATEOFBIRTH,
                CV.DESCRIPTION,
                '' DMSTS,
                '000' EDUCATION,
                CV.EMAIL,
                '' EMAILBR,
                pks_data_conversion.todate(null) ESTABLISHDATE,
                '' EXPERIENCECD,
                '000' EXPERIENCETYPE,
                CV.FAX,
                '' FAXNO,
                '000' FOCUSTYPE,
                CV.FULLNAME,
                NVL(GCB.AUTOID, 0) GCBID,
                '000' GRINVESTOR,
                '' HEADOFFICE,
                '' HEADOFFICECORP,
                CV.IDCODE,
                CV.IDDATE,
                '' IDEXPIRED,
                CV.IDPLACE,
                CV.IDTYPE,
                '000' INCOMERANGE,
                '' INTERNATION,
                '' INVESTMENTEXPERIENCE,
                '000' INVESTRANGE,
                '000' INVESTTYPE,
                'N' ISBANKING,
                'N' ISCHKONLIMIT,
                '' ISFORCUSTMASTACC,
                '' ISSUERID,
                '' LANGUAGE,
                '' LAST_CHANGE,
                '0000' LAST_MKID,
                '0000' LAST_OFID,
                sysdate LASTDATE,
                nvl(lcb.autoid, 0) LCBID,
                'M' MANAGETYPE,
                'Y' MARGINALLOW,
                '' MARGINCONTRACTNO,
                '004' MARRIED,
                CV.MNEMONIC,
                '' MOBILE,
                '' MOBILESMS,
                0 MRLOANLIMIT,
                'C' NSDSTATUS,
                '000' OCCUPATION,
                '' OLAUTOID,
                0 ONLINELIMIT,
                'F' OPENVIA,
                '' OPERATINGMODE,
                CV.OPNDATE,
                '' ORGINF,
                '' PCUSTODYCD,
                CV.PHONE,
                '' PIN,
                pks_data_conversion.todate(null) PLACEOFBIRTH,
                '000' POSITION,
                '' POSTCODE,
                '--' PROVINCE,
                'P' PSTATUS,
                '' REFNAME,
                '' RESIDENT,
                'O' RISKLEVEL,
                '000' SECTOR,
                CV.SEX,
                '' SHORTNAME,
                '000' STAFF,
                CV.STATUS,
                CV.SUBTAXCODE,
                '' SUPEBANK,
                CV.SWIFTCODE,
                0 T0LOANLIMIT,
                CV.TAXCODE,
                CV.TAXCODEDATE,
                pks_data_conversion.todate(null) TAXCODEEXPIRYDATE,
                '' TAXCODEISSUEORGAN,
                '' TIMETOJOIN,
                '000' TLID,
                'Y' TRADEFLOOR,
                'N' TRADEONLINE,
                'N' TRADETELEPHONE,
                CV.TRADINGCODE,
                pks_data_conversion.todate(cv.opndate) TRADINGCODEDT,
                TRU.autoid TRUSTEEID,
                cv.custodycd USERNAME,
                '000' VALUDADDED,
                CV.VAT
                from cfmastcv CV
                    left join
                    (
                        select * from famembers where ROLES ='AMC'
                    )amc on amc.shortname = cv.amcid
                    left join
                    (
                        select * from famembers where ROLES ='GCB'
                    )GCB on GCB.shortname = cv.GCBid
                    left join
                    (
                        select * from famembers where ROLES ='LCB'
                    )LCB on LCB.shortname = cv.LCBid
                    left join
                    (
                        select * from famembers where ROLES ='TRU'
                    )TRU on TRU.shortname = cv.trustid

        )MST;


        Update cfmast set custid = '0001' || LPAD(seq_cfmast_convert.NEXTVAL,6,'0');


        FOR REC_2 IN (
            SELECT cf.*, nvl(cv.refcasaacct,'') refcasaacct, nvl(cv.ccycd,'') ccycd, nvl(ccytype,'IICA') ccytype
            FROM CFMAST CF
            left join ddmastcv cv on cv.cifno = cf.cifid
        )
        LOOP

            INSERT INTO afmast (ACTYPE,CUSTID,ACCTNO,AFTYPE,BANKACCTNO,BANKNAME,SWIFTCODE,STATUS,PSTATUS,BRATIO,AUTOADV,ALTERNATEACCT,VIA,
                                COREBANK,GROUPLEADER,BRKFEETYPE,TLID,BRID,CAREBY,MRIRATE,MRSRATE,MRMRATE,MRLRATE,MBIRATE,MBSRATE,MBMRATE,
                                MBLRATE,MCIRATE,MCSRATE,MCMRATE,MCLRATE,MRIRATIO,MRSRATIO,MRMRATIO,MRLRATIO,ADDRATE,ADDDAY,BASECALLDAY,
                                EXTCALLDAY,TERMOFUSE,DESCRIPTION,ISOTC,PISOTC,DEPOLASTDT,TRIGGERDATE,OPNDATE,CLSDATE,ADVANCELINE,DEPOSITLINE,
                                T0AMT,MRCRLIMIT,MRCRLIMITMAX,DPCRLIMITMAX,LIMITDAILY,ISFIXACCOUNT,AUTOTRF,CHGACTYPE,LASTDATE,LAST_CHANGE,TRADELINE,
                                SMSTYPE,PSMSTYPE,BEGINCALLDATE,ENDCALLDATE,ENDTRIGGERDATE,CALLDAY,APPLYSCR,ISTRIGGER,ISODDLOT)
            VALUES('0000',REC_2.custid,REC_2.custid,'000',NULL,NULL,NULL,'A','P',100,'N','N','F',
                    'N',NULL,'CF','0000','0001','0000',0,0,0,0,100,100,100,
                    100,0,0,0,0,0,0,0,0,0,0,
                    0,0,'001',NULL,'N','N',NULL,NULL,rec_2.opndate,NULL,0,
                    0,0,0,0,0,2000000000000,'N','N','N',getcurrdate,sysdate,0,
                    NULL,NULL,NULL,NULL,NULL,NULL,'N',NULL,'N');


            INSERT INTO ddmast (AUTOID,ACTYPE,CUSTID,AFACCTNO,CUSTODYCD,ACCTNO,CCYCD,REFCASAACCT,BALANCE,ACRAMT,ADRAMT,MCRAMT,MDRAMT,
                        HOLDBALANCE,BLOCKAMT,RECEIVING,NETTING,STATUS,PSTATUS,OPNDATE,CLSDATE,LASTCHANGE,LAST_CHANGE,PENDINGHOLD,PENDINGUNHOLD,
                        BANKBALANCE,BANKHOLDBALANCE,ISDEFAULT,DEPOFEEACR,DEPOFEEAMT,DEPOLASTDT,COREBANK,ACCOUNTTYPE)
            VALUES(seq_ddmast.nextval,'0000',REC_2.custid,REC_2.custid,REC_2.custodycd,to_char(getcurrdate, 'DDMMYYYY') || REC_2.custid,
                    rec_2.ccycd,rec_2.refcasaacct,0,0,0,0,0,0,0,0,0,'C',NULL,getcurrdate,NULL,sysdate,NULL,0,0,0,0,'N',0,0,NULL,'N',REC_2.ccytype);

        END LOOP;



EXCEPTION
  WHEN others THEN

    plog.error('CONVERT:' || SQLERRM || '.At:' || dbms_utility.format_error_backtrace);
    rollback;
    RAISE errnums.E_SYSTEM_ERROR;
END;

PROCEDURE PR_DO_DDMASTCV  IS
v_currdate date;
v_prevdate date;
v_nextdate date;
v_t_1_date date;
v_t_2_date date;
v_t_3_date date;
BEGIN


    UPDATE DDMAST SET BALANCE =0,RECEIVING=0,NETTING=0;

    select to_date(varvalue,'DD/MM/RRRR') into v_currdate from sysvar where grname ='SYSTEM' and varname ='CURRDATE';
    select to_date(varvalue,'DD/MM/RRRR') into v_prevdate from sysvar where grname ='SYSTEM' and varname ='PREVDATE';
    select to_date(varvalue,'DD/MM/RRRR') into v_nextdate from sysvar where grname ='SYSTEM' and varname ='NEXTDATE';
    v_t_1_date:=get_t_date(v_currdate,1);
    v_t_2_date:=get_t_date(v_currdate,2);
    v_t_3_date:=get_t_date(v_currdate,3);


    FOR REC IN
    (
        select dd.acctno, cv.cifno, cv.refcasaacct, cv.balance,cv.emkamt, '0001' BRID,
               '0001' || LPAD(seq_cvtxnum.NEXTVAL,6,'0') TXNUM
        from ddmastcv cv, ddmast dd
        where cv.refcasaacct=dd.refcasaacct
    )
    LOOP
        INSERT INTO TLLOGALL
        (AUTOID,TXNUM,TXDATE,TXTIME,BRID,TLID,OFFID,OVRRQS,CHID,CHKID,TLTXCD,IBT,BRID2,TLID2,CCYUSAGE,OFF_LINE,DELTD,BRDATE,
                BUSDATE,TXDESC,IPADDRESS,WSNAME,TXSTATUS,MSGSTS,OVRSTS,BATCHNAME,MSGAMT,MSGACCT,CHKTIME,OFFTIME)
        VALUES
        (SEQ_TLLOG.NEXTVAL ,REC.TXNUM,v_t_1_date,'00:00:00',REC.BRID,'0001','0001','@00','0001',NULL,'9100',
            NULL,NULL,NULL,'00','N','N',v_t_1_date,v_t_1_date,'CASH DEPOSIT','172.0.0.0','CV Server','1','0','0','DAY',REC.BALANCE,REC.ACCTNO,NULL,'00:00:00');

        INSERT INTO DDTRANA
        (TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,REF,DELTD,ACCTREF,AUTOID)
        VALUES
        (REC.TXNUM,v_t_1_date,REC.ACCTNO,'0002',REC.BALANCE,NULL,NULL,'N',NULL,SEQ_DDTRAN.NEXTVAL );

        INSERT INTO DDTRANA
        (TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,REF,DELTD,ACCTREF,AUTOID)
        VALUES
        (REC.TXNUM,v_t_1_date,REC.ACCTNO,'0005',REC.emkamt,NULL,NULL,'N',NULL,SEQ_DDTRAN.NEXTVAL );
    END LOOP;



    delete from  ddtran_gen;
    INSERT INTO DDTRAN_GEN
      (AUTOID,
       CUSTODYCD,
       CUSTID,
       TXNUM,
       TXDATE,
       ACCTNO,
       TXCD,
       NAMT,
       CAMT,
       REF,
       DELTD,
       ACCTREF,
       TLTXCD,
       BUSDATE,
       TXDESC,
       TXTIME,
       BRID,
       TLID,
       OFFID,
       CHID,
       TXTYPE,
       FIELD,
       TLLOG_AUTOID,
       TRDESC,
       COREBANK)
      SELECT CI.AUTOID,
             AF.CUSTODYCD,
             AF.CUSTID,
             CI.TXNUM,
             CI.TXDATE,
             CI.ACCTNO,
             CI.TXCD,
             CI.NAMT,
             CI.CAMT,
             CI.REF,
             NVL(CI.DELTD, 'N') DELTD,
             CI.ACCTREF,
             TL.TLTXCD,
             TL.BUSDATE,
             CASE
               WHEN TL.TLID = '6868' THEN
                TRIM(TL.TXDESC) || ' (Online)'
               ELSE
                TL.TXDESC
             END TXDESC,
             TL.TXTIME,
             TL.BRID,
             TL.TLID,
             TL.OFFID,
             TL.CHID,
             APP.TXTYPE,
             APP.FIELD,
             TL.AUTOID,
             CASE
               WHEN CI.TRDESC IS NOT NULL THEN
                (CASE
                  WHEN TL.TLID = '6868' THEN
                   TRIM(CI.TRDESC) || ' (Online)'
                  ELSE
                   CI.TRDESC
                END)
               ELSE
                CI.TRDESC
             END TRDESC,
             AF.COREBANK
        FROM DDTRANA CI,
             TLLOGALL TL,
             DDMAST AF,
             APPTX APP
       WHERE CI.TXDATE = TL.TXDATE
         AND CI.TXNUM = TL.TXNUM
         AND CI.ACCTNO = AF.ACCTNO
         AND CI.TXCD = APP.TXCD
         AND APP.APPTYPE = 'DD'
         AND APP.TXTYPE IN ('D', 'C')
         AND TL.DELTD <> 'Y'
         AND CI.NAMT <> 0;
    COMMIT;



EXCEPTION
WHEN OTHERS THEN
    plog.error('CONVERT:' || SQLERRM || '.At:' || dbms_utility.format_error_backtrace);
END;


PROCEDURE pr_do_semastcv  IS



v_currdate date;
v_prevdate date;
v_nextdate date;
v_t_1_date date;
v_t_2_date date;
v_t_3_date date;
v_now timestamp;

BEGIN
    dbms_utility.exec_ddl_statement('TRUNCATE TABLE semast' );

    select to_date(varvalue,'DD/MM/RRRR') into v_currdate from sysvar where grname ='SYSTEM' and varname ='CURRDATE';
    select to_date(varvalue,'DD/MM/RRRR') into v_prevdate from sysvar where grname ='SYSTEM' and varname ='PREVDATE';
    select to_date(varvalue,'DD/MM/RRRR') into v_nextdate from sysvar where grname ='SYSTEM' and varname ='NEXTDATE';
    v_t_1_date:=get_t_date(v_currdate,1);
    v_t_2_date:=get_t_date(v_currdate,2);
    v_t_3_date:=get_t_date(v_currdate,3);
    SELECT SYSDATE into v_now FROM DUAL;
    dbms_utility.exec_ddl_statement('TRUNCATE TABLE SEMAST' );
    dbms_utility.exec_ddl_statement('TRUNCATE TABLE SEBLOCKED' );
    dbms_utility.exec_ddl_statement('TRUNCATE TABLE SEMORTAGE' );
    Delete from tllogall where txnum in (select txnum from setrana);
    dbms_utility.exec_ddl_statement('TRUNCATE TABLE SETRANA' );


    for rec in
    (
        select  af.ACCTNO,sb.CODEID ,af.acctno||sb.codeid seacctno,af.custid
        from AFMAST AF,  SBSECURITIES sb,
        (
            SELECT CF.CUSTODYCD ,CV.SYMBOL SYMBOL , to_number(NVL(TRADE,0)) TRADE ,to_number(NVL(STANDING,0)) STANDING,to_number(NVL(WAITFORTRADE,0)) WAITFORTRADE ,to_number(NVL(BLOCKED,0)) BLOCKED ,to_number(NVL(MORTAGE,0)) MORTAGE ,
            to_number(NVL(waitingfortradeblocked,0))   waitingfortradeblocked, blockw  ,0 NETTING,0 RECEIVING,
            CUSTODYCD description
            FROM SEMASTCV CV, CFMAST CF
            WHERE CV.bankcif = CF.CIFID

            UNION ALL
            SELECT  CUSTODYCD , SYMBOL , 0 TRADE , 0 STANDING,0 WAITFORTRADE ,0 BLOCKED ,0 MORTAGE ,0 waitingfortradeblocked,0 blockw ,
             SUM(matchqtty) NETTING, 0 RECEIVING,CF.CUSTODYCD description
            FROM stschdcv CV, CFMAST CF
            WHERE CV.bankcif = CF.CIFID AND exectype='NB'
            group by CF.custodycd,CV.symbol
            union all
            SELECT  CUSTODYCD , SYMBOL , 0 TRADE , 0 STANDING,0 WAITFORTRADE ,0 BLOCKED ,0 MORTAGE,0 waitingfortradeblocked,0 blockw ,
             0  NETTING, SUM(matchqtty) RECEIVING,CF.CUSTODYCD description
            FROM stschdcv CV, CFMAST CF
            WHERE CV.bankcif = CF.CIFID AND  exectype='NS'
            group by custodycd,symbol

        )se
        where  af.description = se.description
        and sb.symbol = se.symbol
        group by  af.description,sb.SYMBOL,af.ACCTNO,sb.CODEID,af.custid
        having  SUM (NVL(TRADE,0)) +SUM (NVL(STANDING,0)) +SUM (NVL(WAITFORTRADE,0))+SUM (NVL(BLOCKED,0))+SUM (NVL(blockw,0))
        +SUM (NVL(MORTAGE,0)) +SUM(NVL(se.NETTING,0)) +SUM(NVL(se.RECEIVING,0))
         >0
        UNION
        SELECT  af.ACCTNO,sb.CODEID ,af.acctno||sb.codeid seacctno,af.custid
        FROM CFMAST CF, SEMASTCV  CV, AFMAST AF,  SBSECURITIES sb
        where WAITFORTRADE+waitingfortradeblocked >0
        and CF.CUSTID = af.CUSTID AND CV.bankcif = CF.CIFID
        and CV.SYMBOL||'_WFT' = SB.SYMBOL
    )

    loop
        insert into semast (ACTYPE, ACCTNO, CODEID, AFACCTNO, OPNDATE, CLSDATE, LASTDATE, STATUS, PSTATUS, IRTIED, IRCD, COSTPRICE, TRADE, MORTAGE, MARGIN, NETTING, STANDING, WITHDRAW, DEPOSIT, LOAN, BLOCKED, RECEIVING, TRANSFER, PREVQTTY, DCRQTTY, DCRAMT, DEPOFEEACR, REPO, PENDING, TBALDEPO, CUSTID, COSTDT, SECURED, ICCFCD, ICCFTIED, TBALDT, SENDDEPOSIT, SENDPENDING, DDROUTQTTY, DDROUTAMT, DTOCLOSE, SDTOCLOSE, QTTY_TRANSFER, LAST_CHANGE, DEALINTPAID, WTRADE)
        values ('0000', rec.seacctno, rec.codeid, rec.ACCTNO,v_t_1_date, null, v_t_1_date, 'A', '', 'Y', '001', 0.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, rec.custid, v_t_1_date, 0, '', 'Y',v_t_1_date, 0, 0, 0, 0, 0, 0, 0, v_now, 0.0000, 0);
    end loop;

    for rec in
    (

        SELECT  SUBSTR(DTL.ACCTNO,1,4)|| LPAD(seq_CVtxnum.NEXTVAL,6,'0')  TXNUM ,DTL.* from(
        select   se.CUSTODYCD CUSTODYCD,sb.SYMBOL,af.ACCTNO,sb.CODEID ,af.acctno||sb.codeid seacctno,af.custid , SUM (NVL(TRADE,0)) TRADE,SUM (NVL(STANDING,0)) STANDING,SUM (NVL(WAITFORTRADE,0)) WAITFORTRADE
        ,SUM (NVL(BLOCKED,0)) BLOCKED,SUM (NVL(MORTAGE,0)) MORTAGE,
         SUM(NVL(se.waitingfortradeblocked,0)) waitingfortradeblocked,
         SUM(NVL(se.NETTING,0)) NETTING,SUM(NVL(se.RECEIVING,0)) RECEIVING, sum(nvl(se.blockw,0)) blockw
        from AFMAST AF,  SBSECURITIES sb,
        (
        SELECT CUSTODYCD ,SYMBOL SYMBOL , to_number(NVL(TRADE,0)) TRADE ,to_number(NVL(STANDING,0)) STANDING,to_number(NVL(WAITFORTRADE,0)) WAITFORTRADE ,to_number(NVL(BLOCKED,0)) BLOCKED ,to_number(NVL(MORTAGE,0)) MORTAGE ,
        to_number(NVL(waitingfortradeblocked,0))   waitingfortradeblocked , blockw,
         0 NETTING, 0 RECEIVING ,CUSTODYCD description
        FROM SEMASTCV CV, CFMAST CF
        WHERE CV.bankcif = CF.CIFID

        UNION ALL
        SELECT  CUSTODYCD , SYMBOL , 0 TRADE , 0 STANDING,0 WAITFORTRADE ,0 BLOCKED ,0 MORTAGE ,0 waitingfortradeblocked,0 blockw,
         SUM(matchqtty) NETTING, 0 RECEIVING,CUSTODYCD description
        FROM stschdcv CV, CFMAST CF
        WHERE CV.BANKcif = cf.cifid and exectype='NS' group by custodycd,symbol
        union all
        SELECT  CUSTODYCD , SYMBOL , 0 TRADE , 0 STANDING,0 WAITFORTRADE ,0 BLOCKED ,0 MORTAGE ,0 waitingfortradeblocked,0 blockw,
         0  NETTING, SUM(matchqtty) RECEIVING,CUSTODYCD description
        FROM stschdcv cv, cfmast cf
        WHERE cv.bankcif = cf.cifid and exectype='NB' group by custodycd,symbol
        )se
        where  af.description = se.description
        and sb.symbol = se.symbol
        group by  af.description, se.CUSTODYCD, sb.SYMBOL,af.ACCTNO,sb.CODEID,af.custid
        having  SUM (NVL(TRADE,0)) +SUM (NVL(STANDING,0)) +SUM (NVL(BLOCKED,0))
        +SUM (NVL(MORTAGE,0)) +SUM(NVL(se.NETTING,0)) + SUM(NVL(se.RECEIVING,0)) + SUM(NVL(se.blockw,0))

           >0
        )dtl
    )
    loop

        UPDATE SEMAST SET  TRADE = TRADE + REC.TRADE , STANDING = STANDING - REC.STANDING , mortage = mortage+rec.standing, BLOCKED = BLOCKED + REC.BLOCKED ,
                            emkqtty = emkqtty+ REC.MORTAGE + rec.blockw ,RECEIVING = RECEIVING+ REC.RECEIVING,NETTING = NETTING+ REC.NETTING
        WHERE  ACCTNO =REC.SEACCTNO ;
    END LOOP;

    for rec in
    (
        SELECT  SUBSTR(DTL.ACCTNO,1,4)|| LPAD(seq_CVtxnum.NEXTVAL,6,'0')  TXNUM ,DTL.* from(
        SELECT  cf.CUSTODYCD,sb.SYMBOL,af.ACCTNO,sb.CODEID ,af.acctno||sb.codeid seacctno,af.custid ,  to_number(NVL(TRADE,0)) TRADE ,to_number(NVL(STANDING,0)) STANDING,to_number(NVL(WAITFORTRADE,0)) WAITFORTRADE ,to_number(NVL(BLOCKED,0)) BLOCKED ,to_number(NVL(MORTAGE,0)) MORTAGE ,
        to_number(NVL(waitingfortradeblocked,0))   waitingfortradeblocked ,
         0 NETTING, 0 RECEIVING
        FROM SEMASTCV  cv, cfmast cf, AFMAST AF,  SBSECURITIES sb
        where WAITFORTRADE+waitingfortradeblocked >0
        and cv.bankcif = cf.cifid and cf.custid = af.custid
        and cv.SYMBOL||'_WFT' = SB.SYMBOL)DTL
    )
    loop
        UPDATE SEMAST SET  trade = trade + REC.WAITFORTRADE, BLOCKED =BLOCKED+REC.waitingfortradeblocked
        WHERE  ACCTNO =REC.SEACCTNO ;
    end loop;

    update semast set TBALDT = getcurrdate();

    -- lay costpice truong hop ko co gia tri costprice trong SEMASTCV
    update semast set costprice = (select  avgprice from securities_info where codeid = semast.codeid) where nvl(costprice,0) = 0;



    FOR REC IN (
           SELECT SUBSTR(SEACCTNO,1,4) BRID  ,  '9'|| LPAD(seq_CVtxnum.NEXTVAL,9,'0') TXNUM,DTL.*
           FROM (
                 SELECT SUM (netting) netting , ABS(SUM(standing)) standing,SUM(withdraw) withdraw,
                        SUM (deposit) deposit , SUM(blocked) blocked,SUM(receiving) receiving,
                        SUM (senddeposit) senddeposit , SUM(dtoclose) dtoclose, SUM(trade) trade,
                 ACCTNO SEACCTNO
                 FROM SEMAST
                 GROUP BY ACCTNO
                 HAVING SUM (netting) + ABS(SUM(standing)) +SUM(withdraw) +
                        SUM (deposit) + SUM(blocked) +SUM(receiving) +
                        SUM (senddeposit) + SUM(dtoclose) + SUM(trade)>0
                ) DTL
         )
    LOOP

        INSERT INTO tllogall
        (AUTOID,TXNUM,TXDATE,TXTIME,BRID,TLID,OFFID,OVRRQS,CHID,CHKID,TLTXCD,IBT,BRID2,TLID2,CCYUSAGE,OFF_LINE,DELTD,BRDATE,BUSDATE,TXDESC,IPADDRESS,WSNAME,TXSTATUS,MSGSTS,OVRSTS,BATCHNAME,MSGAMT,MSGACCT,CHKTIME,OFFTIME,CAREBYGRP)
        VALUES
        (seq_tllog.NEXTVAL ,rec.txnum,v_t_1_date,'13:50:24','0001','0001','0001','@00',NULL,NULL,'9902',NULL,NULL,NULL,'00','N','N',v_t_1_date,v_t_1_date,'Inward SE Transfer','10.26.0.125','namnt','1','0','0','DAY',REC.netting + REC.standing+ REC.withdraw + REC.deposit + REC.blocked + REC.receiving + REC.senddeposit + REC.dtoclose+ rec.trade ,REC.SEACCTNO,NULL,'01:51:39',NULL);

        if rec.trade>0 then
        INSERT INTO setrana
        (TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,REF,DELTD,AUTOID)
        VALUES
        (rec.txnum,v_t_1_date,rec.seacctno,'0045',rec.trade,NULL,'','N',seq_setran.nextval);
        end if;

        if rec.netting >0 then
        INSERT INTO setrana
        (TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,REF,DELTD,AUTOID)
        VALUES
        (rec.txnum,v_t_1_date,rec.seacctno,'0019',rec.netting,NULL,'','N',seq_setran.nextval);
        end if;

        if rec.standing >0 then
        INSERT INTO setrana
        (TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,REF,DELTD,AUTOID)
        VALUES
        (rec.txnum,v_t_1_date,rec.seacctno,'0013',rec.standing,NULL,'','N',seq_setran.nextval);
        end if;

        if rec.withdraw>0 then
        INSERT INTO setrana
        (TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,REF,DELTD,AUTOID)
        VALUES
        (rec.txnum,v_t_1_date,rec.seacctno,'0041',rec.withdraw,NULL,'','N',seq_setran.nextval);
        end if;

        if rec.deposit>0 then
        INSERT INTO setrana
        (TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,REF,DELTD,AUTOID)
        VALUES
        (rec.txnum,v_t_1_date,rec.seacctno,'0050',rec.deposit,NULL,'','N',seq_setran.nextval);
        end if;

        if rec.blocked>0 then
        INSERT INTO setrana
        (TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,REF,DELTD,AUTOID)
        VALUES
        (rec.txnum,v_t_1_date,rec.seacctno,'0043',rec.blocked,NULL,'','N',seq_setran.nextval);
        end if;

        if rec.RECEIVING>0 then
        INSERT INTO setrana
        (TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,REF,DELTD,AUTOID)
        VALUES
        (rec.txnum,v_t_1_date,rec.seacctno,'0016',rec.RECEIVING,NULL,'','N',seq_setran.nextval);
        end if;

        if rec.senddeposit>0 then
        INSERT INTO setrana
        (TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,REF,DELTD,AUTOID)
        VALUES
        (rec.txnum,v_t_1_date,rec.seacctno,'0060',rec.senddeposit,NULL,'','N',seq_setran.nextval);
        end if;

        if rec.dtoclose>0 then
        INSERT INTO setrana
        (TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,REF,DELTD,AUTOID)
        VALUES
        (rec.txnum,v_t_1_date,rec.seacctno,'0074',rec.dtoclose,NULL,'','N',seq_setran.nextval);
        end if;

    END LOOP;


    -- Gen data giao dich phan he SE
    delete from setran_gen;
    INSERT INTO setran_gen (AUTOID,CUSTODYCD,CUSTID,TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,REF,DELTD,ACCTREF,TLTXCD,BUSDATE,TXDESC,TXTIME,BRID,TLID,OFFID,CHID,AFACCTNO,SYMBOL,SECTYPE,TRADEPLACE,TXTYPE,FIELD,CODEID,TLLOG_AUTOID,TRDESC)
    select tr.autoid, cf.custodycd, cf.custid, tr.txnum, tr.txdate, tr.acctno, tr.txcd, tr.namt, tr.camt, tr.ref, tr.deltd, tr.acctref,
        tl.tltxcd, tl.busdate,
        case when tl.tlid ='6868' then trim(tl.txdesc) || ' (Online)' else tl.txdesc end txdesc,
        tl.txtime, tl.brid, tl.tlid, tl.offid, tl.chid,
        se.afacctno, sb.symbol, sb.sectype, sb.tradeplace, ap.txtype, ap.field, sb.codeid ,tl.autoid,
        case when tr.trdesc is not null
            then (case when tl.tlid ='6868' then trim(tr.trdesc) || ' (Online)' else tr.trdesc end)
            else tr.trdesc end trdesc
    from setrana tr, tllogall tl, sbsecurities sb, semast se, cfmast cf, apptx ap
    where tr.txdate = tl.txdate and tr.txnum = tl.txnum
        and tr.acctno = se.acctno
        and sb.codeid = se.codeid
        and se.custid = cf.custid
        and tr.txcd = ap.txcd and ap.apptype = 'SE' and ap.txtype in ('D','C')
        and tr.deltd <> 'Y' and tr.namt <> 0;
commit;

EXCEPTION
    WHEN OTHERS THEN
    plog.error('CONVERT:' || SQLERRM || '.At:' || dbms_utility.format_error_backtrace);
END;

PROCEDURE pr_Do_FAMEMBERS
IS
l_loginpwd varchar2(10);
l_tradingpwd varchar2(10);
l_datasourcesql varchar2(1000);
BEGIN

    reset_sequence('SEQ_FAMEMBERS', 1);
    reset_sequence('seq_fabrokerage', 1);
    reset_sequence('seq_fabrokerage', 1);
    Delete from FAMEMBERS;
    INSERT INTO FAMEMBERS (AUTOID,SHORTNAME,FULLNAME,ROLES,BICCODE,BANKACCTNO,BANKNAME,BANKCITADCODE,BANKBICCODE,TAXCODE,STATUS,PSTATUS,ENGLISHNAME,
        TAXCODEDATE, TAXCCY,CIFNO,NATIONALITY,ADDRESS,CEONAME,EMAIL,TELEPHONE,FAXNO,INCDATE,INCORPORATION,LANGUAGE,OPENDATE,WEBSITE,DEPOSITMEMBER,BRANCHNAME,
        VALDATE,CONTRACTNO)
    SELECT SEQ_FAMEMBERS.NEXTVAL, SHORTNAME,FULLNAME,ROLES,BICCODE,BANKACCTNO,BANKNAME,null BANKCITADCODE,BANKBICCODE,TAXCODE, 'A', 'P',
           englistname, TAXCODEDATE, TAXCCY,CIFNO,NATIONALITY,ADDRESS,null CEONAME, EMAIL,TELEPHONE,FAXNO,INCDATE,INCORPORATION,LANGUAGE, NULL OPENDATE,
           NULL WEBSITE, PORTFOLIO DEPOSITMEMBER, NULL BRANCHNAME, NULL VALDATE, null CONTRACTNO
    FROM FAMEMBERSCV;

    Delete from fabrokerage;
    Insert into fabrokerage(autoid, brkid, custodycd)
    Select seq_fabrokerage.nextval, mst.autoid, mst.custodycd
    from
    (
        select DISTINCT fa.autoid, cf.custodycd
        from FAMEMBERS fa, fabrokeragecv fb, cfmast cf
        where roles='BRK' and  INSTR(fb.brkid ,fa.shortname)> 0
            and fb.cifno = cf.cifid
    ) mst;

    Delete from famembersextra;
    INSERT INTO famembersextra (AUTOID,MEMBERID,EXTRACD,EXTRAVAL,EMAIL,STATUS,BROKERNAME,PHONE)
    select seq_famembersextra.nextval, mst.autoid, mst.EXTRACD,mst.EXTRAVAL,mst.EMAIL,mst.STATUS, null BROKERNAME,null PHONE
    from
    (
        select DISTINCT fa.autoid, fb.extracd, fb.extraval, fb.sex, fb.status, fb.email
        from FAMEMBERS fa, famembersextracv fb
        where roles='BRK' and fb.brokerrid = fa.shortname
    )mst;


EXCEPTION
  WHEN others THEN
    plog.error('CONVERT:' || SQLERRM || '.At:' || dbms_utility.format_error_backtrace);
    rollback;
    RAISE errnums.E_SYSTEM_ERROR;
END;

PROCEDURE pr_Do_CFAUTH
IS
l_cfauthid number;
BEGIN
delete cfauth;
-- Tao thong tin UQ.


commit;
EXCEPTION
  WHEN others THEN
    plog.error('CONVERT:' || SQLERRM || '.At:' || dbms_utility.format_error_backtrace);
    rollback;
    RAISE errnums.E_SYSTEM_ERROR;
END;

PROCEDURE pr_Do_SBSECURITIES
IS
l_ISSUERID varchar2(20);
l_CODEID varchar2(6);
l_CODEIDWFT varchar2(6);
BEGIN

delete securities_info_log;

update sbsecuritiescv
set listingqtty = pks_data_conversion.tonumber(listingqtty);

-- Bo sung nhung ma thieu.
for rec in
(
select * from sbsecuritiescv
where symbol not in (select symbol from sbsecurities)
)
loop
select lpad(nvl(max(ISSUERID),0) + 1,10,'0') into l_ISSUERID from issuers;

INSERT INTO issuers (ISSUERID,SHORTNAME,FULLNAME,OFFICENAME,CUSTID,ADDRESS,PHONE,FAX,ECONIMIC,BUSINESSTYPE,BANKACCOUNT,BANKNAME,LICENSENO,LICENSEDATE,LINCENSEPLACE,OPERATENO,OPERATEDATE,OPERATEPLACE,LEGALCAPTIAL,SHARECAPITAL,MARKETSIZE,PRPERSON,INFOADDRESS,DESCRIPTION,STATUS,PSTATUS)
VALUES(l_ISSUERID ,trim(rec.symbol) ,rec.fullname,trim(rec.symbol),NULL,null,' ',' ','002','001','0','0',' ',TO_DATE('21/07/2000','DD/MM/RRRR'),' ',' ',TO_DATE('15/12/2006','DD/MM/RRRR'),'So KHDT',1,1,'001',NULL,NULL,NULL,'A',NULL);

SELECT lpad((MAX(TO_NUMBER(INVACCT)) + 1),6,'0') into l_CODEID FROM
(SELECT ROWNUM ODR, INVACCT
FROM (SELECT CODEID INVACCT FROM SBSECURITIES WHERE SUBSTR(CODEID, 1, 1) <> 9 ORDER BY CODEID) DAT
) INVTAB;
select lpad(to_number(l_CODEID) + 1, 6,'0') into l_CODEIDWFT from dual;

INSERT INTO sbsecurities (CODEID,ISSUERID,SYMBOL,SECTYPE,INVESTMENTTYPE,RISKTYPE,PARVALUE,FOREIGNRATE,STATUS,TRADEPLACE,DEPOSITORY,SECUREDRATIO,MORTAGERATIO,REPORATIO,ISSUEDATE,EXPDATE,INTPERIOD,INTRATE,HALT,SBTYPE,CAREBY,CHKRATE,REFCODEID,ISSQTTY,BONDTYPE,MARKETTYPE,ALLOWSESSION,ISSEDEPOFEE,INTCOUPON,TYPETERM,TERM,INTPAYMODE,ISBUYSELL)
VALUES(l_CODEID,l_ISSUERID,trim(rec.symbol),'001','002','001',10000,49,'Y','001','001',0,0,0,TO_DATE('27/10/2014','DD/MM/RRRR'),TO_DATE('27/10/2014','DD/MM/RRRR'),0,0,'N','001','0017',0,NULL,0,'000','000','AL','Y',0,'W',0,'000','B');
INSERT INTO sbsecurities (CODEID,ISSUERID,SYMBOL,SECTYPE,INVESTMENTTYPE,RISKTYPE,PARVALUE,FOREIGNRATE,STATUS,TRADEPLACE,DEPOSITORY,SECUREDRATIO,MORTAGERATIO,REPORATIO,ISSUEDATE,EXPDATE,INTPERIOD,INTRATE,HALT,SBTYPE,CAREBY,CHKRATE,REFCODEID,ISSQTTY,BONDTYPE,MARKETTYPE,ALLOWSESSION,ISSEDEPOFEE,INTCOUPON,TYPETERM,TERM,INTPAYMODE,ISBUYSELL)
VALUES(l_CODEIDWFT,l_ISSUERID,trim(rec.symbol) || '_WFT','001','002','001',10000,49,'Y','001','001',0,0,0,TO_DATE('27/10/2014','DD/MM/RRRR'),TO_DATE('27/10/2014','DD/MM/RRRR'),0,0,'N','001','0017',0,l_CODEID,0,'000','000','AL','Y',0,'W',0,'000','B');

if rec.tradeplace = '001' then

INSERT INTO securities_info (AUTOID,CODEID,SYMBOL,TXDATE,LISTINGQTTY,TRADEUNIT,LISTINGSTATUS,ADJUSTQTTY,LISTTINGDATE,REFERENCESTATUS,ADJUSTRATE,REFERENCERATE,REFERENCEDATE,STATUS,BASICPRICE,OPENPRICE,PREVCLOSEPRICE,CURRPRICE,CLOSEPRICE,AVGPRICE,CEILINGPRICE,FLOORPRICE,MTMPRICE,MTMPRICECD,INTERNALBIDPRICE,INTERNALASKPRICE,PE,EPS,DIVYEILD,DAYRANGE,YEARRANGE,TRADELOT,TRADEBUYSELL,TELELIMITMIN,TELELIMITMAX,ONLINELIMITMIN,ONLINELIMITMAX,REPOLIMITMIN,REPOLIMITMAX,ADVANCEDLIMITMIN,ADVANCEDLIMITMAX,MARGINLIMITMIN,MARGINLIMITMAX,SECURERATIOTMIN,SECURERATIOMAX,DEPOFEEUNIT,DEPOFEELOT,MORTAGERATIOMIN,MORTAGERATIOMAX,SECUREDRATIOMIN,SECUREDRATIOMAX,CURRENT_ROOM,BMINAMT,SMINAMT,MARGINPRICE,MARGINREFPRICE,ROOMLIMIT,ROOMLIMITMAX,DFREFPRICE,SYROOMLIMIT,SYROOMUSED,MARGINCALLPRICE,MARGINREFCALLPRICE,DFRLSPRICE,ROOMLIMITMAX_SET,SYROOMLIMIT_SET,ROOMUSED,AVGTRADING30)
VALUES(SEQ_SECURITIES_INFO.nextval,l_CODEID,trim(rec.symbol),TO_DATE('15/12/2006','DD/MM/RRRR'),1,1000,'N',1,TO_DATE('15/12/2006','DD/MM/RRRR'),'001',1,1,TO_DATE('15/12/2006','DD/MM/RRRR'),'001',0,0,0,0,0,0,0,0,1,'002',0,0,1,1,1,1,1,10,'Y',1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,102,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);

INSERT INTO securities_ticksize (AUTOID,CODEID,SYMBOL,TICKSIZE,FROMPRICE,TOPRICE,STATUS)
VALUES(seq_securities_ticksize.nextval,l_CODEID,trim(rec.symbol) ,100,0,49900,'Y');
INSERT INTO securities_ticksize (AUTOID,CODEID,SYMBOL,TICKSIZE,FROMPRICE,TOPRICE,STATUS)
VALUES(seq_securities_ticksize.nextval,l_CODEID,trim(rec.symbol) ,500,50000,99500,'Y');
INSERT INTO securities_ticksize (AUTOID,CODEID,SYMBOL,TICKSIZE,FROMPRICE,TOPRICE,STATUS)
VALUES(seq_securities_ticksize.nextval,l_CODEID,trim(rec.symbol) ,1000,100000,100000000,'Y');

INSERT INTO securities_info (AUTOID,CODEID,SYMBOL,TXDATE,LISTINGQTTY,TRADEUNIT,LISTINGSTATUS,ADJUSTQTTY,LISTTINGDATE,REFERENCESTATUS,ADJUSTRATE,REFERENCERATE,REFERENCEDATE,STATUS,BASICPRICE,OPENPRICE,PREVCLOSEPRICE,CURRPRICE,CLOSEPRICE,AVGPRICE,CEILINGPRICE,FLOORPRICE,MTMPRICE,MTMPRICECD,INTERNALBIDPRICE,INTERNALASKPRICE,PE,EPS,DIVYEILD,DAYRANGE,YEARRANGE,TRADELOT,TRADEBUYSELL,TELELIMITMIN,TELELIMITMAX,ONLINELIMITMIN,ONLINELIMITMAX,REPOLIMITMIN,REPOLIMITMAX,ADVANCEDLIMITMIN,ADVANCEDLIMITMAX,MARGINLIMITMIN,MARGINLIMITMAX,SECURERATIOTMIN,SECURERATIOMAX,DEPOFEEUNIT,DEPOFEELOT,MORTAGERATIOMIN,MORTAGERATIOMAX,SECUREDRATIOMIN,SECUREDRATIOMAX,CURRENT_ROOM,BMINAMT,SMINAMT,MARGINPRICE,MARGINREFPRICE,ROOMLIMIT,ROOMLIMITMAX,DFREFPRICE,SYROOMLIMIT,SYROOMUSED,MARGINCALLPRICE,MARGINREFCALLPRICE,DFRLSPRICE,ROOMLIMITMAX_SET,SYROOMLIMIT_SET,ROOMUSED,AVGTRADING30)
VALUES(SEQ_SECURITIES_INFO.nextval,l_CODEIDWFT,trim(rec.symbol)|| '_WFT',TO_DATE('15/12/2006','DD/MM/RRRR'),1,1000,'N',1,TO_DATE('15/12/2006','DD/MM/RRRR'),'001',1,1,TO_DATE('15/12/2006','DD/MM/RRRR'),'001',0,0,0,0,0,0,0,0,1,'002',0,0,1,1,1,1,1,10,'Y',1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,102,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);

INSERT INTO securities_ticksize (AUTOID,CODEID,SYMBOL,TICKSIZE,FROMPRICE,TOPRICE,STATUS)
VALUES(seq_securities_ticksize.nextval,l_CODEIDWFT,trim(rec.symbol)|| '_WFT' ,100,0,49900,'Y');
INSERT INTO securities_ticksize (AUTOID,CODEID,SYMBOL,TICKSIZE,FROMPRICE,TOPRICE,STATUS)
VALUES(seq_securities_ticksize.nextval,l_CODEIDWFT,trim(rec.symbol)|| '_WFT' ,500,50000,99500,'Y');
INSERT INTO securities_ticksize (AUTOID,CODEID,SYMBOL,TICKSIZE,FROMPRICE,TOPRICE,STATUS)
VALUES(seq_securities_ticksize.nextval,l_CODEIDWFT,trim(rec.symbol)|| '_WFT' ,1000,100000,100000000,'Y');


else
INSERT INTO securities_info (AUTOID,CODEID,SYMBOL,TXDATE,LISTINGQTTY,TRADEUNIT,LISTINGSTATUS,ADJUSTQTTY,LISTTINGDATE,REFERENCESTATUS,ADJUSTRATE,REFERENCERATE,REFERENCEDATE,STATUS,BASICPRICE,OPENPRICE,PREVCLOSEPRICE,CURRPRICE,CLOSEPRICE,AVGPRICE,CEILINGPRICE,FLOORPRICE,MTMPRICE,MTMPRICECD,INTERNALBIDPRICE,INTERNALASKPRICE,PE,EPS,DIVYEILD,DAYRANGE,YEARRANGE,TRADELOT,TRADEBUYSELL,TELELIMITMIN,TELELIMITMAX,ONLINELIMITMIN,ONLINELIMITMAX,REPOLIMITMIN,REPOLIMITMAX,ADVANCEDLIMITMIN,ADVANCEDLIMITMAX,MARGINLIMITMIN,MARGINLIMITMAX,SECURERATIOTMIN,SECURERATIOMAX,DEPOFEEUNIT,DEPOFEELOT,MORTAGERATIOMIN,MORTAGERATIOMAX,SECUREDRATIOMIN,SECUREDRATIOMAX,CURRENT_ROOM,BMINAMT,SMINAMT,MARGINPRICE,MARGINREFPRICE,ROOMLIMIT,ROOMLIMITMAX,DFREFPRICE,SYROOMLIMIT,SYROOMUSED,MARGINCALLPRICE,MARGINREFCALLPRICE,DFRLSPRICE,ROOMLIMITMAX_SET,SYROOMLIMIT_SET,ROOMUSED,AVGTRADING30)
VALUES(SEQ_SECURITIES_INFO.nextval,l_CODEID,trim(rec.symbol),TO_DATE('15/12/2006','DD/MM/RRRR'),1,1000,'N',1,TO_DATE('15/12/2006','DD/MM/RRRR'),'001',1,1,TO_DATE('15/12/2006','DD/MM/RRRR'),'001',26800,0,0,0,0,26800,28676,24924,1,'002',0,0,1,1,1,1,1,100,'Y',1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,102,167439,0,0,26800,26800,5167504,1000000,26800,2000000,0,26800,26800,26800,1000000,2000000,0,0);

INSERT INTO securities_ticksize (AUTOID,CODEID,SYMBOL,TICKSIZE,FROMPRICE,TOPRICE,STATUS)
VALUES(seq_securities_ticksize.nextval,l_CODEID,trim(rec.symbol) ,100,0,10000000,'Y');

INSERT INTO securities_info (AUTOID,CODEID,SYMBOL,TXDATE,LISTINGQTTY,TRADEUNIT,LISTINGSTATUS,ADJUSTQTTY,LISTTINGDATE,REFERENCESTATUS,ADJUSTRATE,REFERENCERATE,REFERENCEDATE,STATUS,BASICPRICE,OPENPRICE,PREVCLOSEPRICE,CURRPRICE,CLOSEPRICE,AVGPRICE,CEILINGPRICE,FLOORPRICE,MTMPRICE,MTMPRICECD,INTERNALBIDPRICE,INTERNALASKPRICE,PE,EPS,DIVYEILD,DAYRANGE,YEARRANGE,TRADELOT,TRADEBUYSELL,TELELIMITMIN,TELELIMITMAX,ONLINELIMITMIN,ONLINELIMITMAX,REPOLIMITMIN,REPOLIMITMAX,ADVANCEDLIMITMIN,ADVANCEDLIMITMAX,MARGINLIMITMIN,MARGINLIMITMAX,SECURERATIOTMIN,SECURERATIOMAX,DEPOFEEUNIT,DEPOFEELOT,MORTAGERATIOMIN,MORTAGERATIOMAX,SECUREDRATIOMIN,SECUREDRATIOMAX,CURRENT_ROOM,BMINAMT,SMINAMT,MARGINPRICE,MARGINREFPRICE,ROOMLIMIT,ROOMLIMITMAX,DFREFPRICE,SYROOMLIMIT,SYROOMUSED,MARGINCALLPRICE,MARGINREFCALLPRICE,DFRLSPRICE,ROOMLIMITMAX_SET,SYROOMLIMIT_SET,ROOMUSED,AVGTRADING30)
VALUES(SEQ_SECURITIES_INFO.nextval,l_CODEIDWFT,trim(rec.symbol)|| '_WFT',TO_DATE('15/12/2006','DD/MM/RRRR'),1,1000,'N',1,TO_DATE('15/12/2006','DD/MM/RRRR'),'001',1,1,TO_DATE('15/12/2006','DD/MM/RRRR'),'001',26800,0,0,0,0,26800,28676,24924,1,'002',0,0,1,1,1,1,1,100,'Y',1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,102,167439,0,0,26800,26800,5167504,1000000,26800,2000000,0,26800,26800,26800,1000000,2000000,0,0);

INSERT INTO securities_ticksize (AUTOID,CODEID,SYMBOL,TICKSIZE,FROMPRICE,TOPRICE,STATUS)
VALUES(seq_securities_ticksize.nextval,l_CODEIDWFT,trim(rec.symbol)|| '_WFT' ,100,0,10000000,'Y');

end if;

INSERT INTO securities_risk (CODEID,MRMAXQTTY,MRRATIORATE,MRRATIOLOAN,MRPRICERATE,MRPRICELOAN,ISMARGINALLOW,AFMAXAMT,AFMAXAMTT3,OPENDATE,MAKERID)
VALUES(l_CODEID,100000000,0,0,10000000,10000000,'Y',50000000000,50000000000,TO_DATE('25/12/2014','DD/MM/RRRR'),'0001');

INSERT INTO securities_rate (AUTOID,CODEID,SYMBOL,FROMPRICE,TOPRICE,MRRATIORATE,MRRATIOLOAN,STATUS)
VALUES(seq_securities_rate.nextval,l_CODEID,trim(rec.symbol),1,1000000,99,99,'Y');

INSERT INTO securities_rate (AUTOID,CODEID,SYMBOL,FROMPRICE,TOPRICE,MRRATIORATE,MRRATIOLOAN,STATUS)
VALUES(seq_securities_rate.nextval,l_CODEIDWFT,trim(rec.symbol) || '_WFT',1,1000000,99,99,'Y');

end loop;

-- Cap nhat lai cac thong tin ve san giao dich, gia, so niem yet
for rec in
(
select * from sbsecuritiescv
)
loop
    update securities_info
    set basicprice = pks_data_conversion.tonumber(rec.BASICPRICE) * 1000
    , listingqtty = case when pks_data_conversion.tonumber(rec.listingqtty) = 0 or pks_data_conversion.tonumber(rec.listingqtty) is null then
                         1 else pks_data_conversion.tonumber(rec.listingqtty) end,
  tradelot = case when rec.tradeplace = '001' then 10 when rec.tradeplace in ('002','005') then 100
           else tradelot end
    where trim(symbol) = trim(rec.symbol);

    update sbsecurities
    set tradeplace = rec.tradeplace,
      sectype = rec.sectype
    where trim(symbol) = trim(rec.symbol);

end loop;

for rec in
(
    select sb.codeid, sb.symbol, se.basicprice,
    se.basicprice * (1 - decode(sb.tradeplace,'001',0.07,0.1)) floorprice,
    se.basicprice * (1 + decode(sb.tradeplace,'001',0.07,0.1)) ceilingprice
    from sbsecurities sb, securities_info se
    where sb.codeid = se.codeid
)
loop

        update securities_info
        set  ceilingprice=rec.ceilingprice,
                floorprice=rec.floorprice,
                basicprice= rec.basicprice,
                avgprice= rec.basicprice,
                dfrlsprice =  rec.basicprice,
                dfrefprice  = rec.basicprice,
                marginprice = rec.basicprice,
                margincallprice =  rec.basicprice,
                marginrefcallprice =  rec.basicprice,
                marginrefprice =  rec.basicprice
        where codeid = rec.codeid;

        update HO_SEC_INFO
        set basic_price = rec.basicprice / 10,
        open_price = rec.basicprice / 10,
        ceiling_price = rec.ceilingprice / 10,
        floor_price = rec.floorprice / 10
        where code = rec.symbol;
end loop;

commit;
EXCEPTION
  WHEN others THEN
    plog.error('CONVERT:' || SQLERRM || '.At:' || dbms_utility.format_error_backtrace);
    rollback;
    RAISE errnums.E_SYSTEM_ERROR;
END;

PROCEDURE pr_Do_AfterConvert
IS
v_nextdate varchar2(20);
v_currdate varchar2(20);
v_prevdate varchar2(20);
l_MAXDEBTSE number;
BEGIN
v_nextdate:=cspks_system.fn_get_sysvar ('SYSTEM', 'NEXTDATE');
v_currdate:=cspks_system.fn_get_sysvar ('SYSTEM', 'CURRDATE');
v_prevdate:=cspks_system.fn_get_sysvar ('SYSTEM', 'PREVDATE');

-- khong can chay batch tiep nua o PHS
delete sbbatchsts;


delete SIGNATURE;
insert into SIGNATURE
select custodycd filename, 'G:\Working\FSS\Projects\PHS\WIP\Document\Data_Conversion\Signature\KH\' || custodycd || '.jpg' path, null path_uq,null path_kt, 0 deleted
from cfmast;

insert into SIGNATURE
select custodycd filename, null path,
'G:\Working\FSS\Projects\PHS\WIP\Document\Data_Conversion\Signature\UQ\' || custodycd || '.jpg' path_uq,null path_kt, 0 deleted
from cfmast cf, cfauth cfa
where cf.custid = cfa.cfcustid;
commit;




EXCEPTION
  WHEN others THEN
    plog.error('CONVERT:' || SQLERRM || '.At:' || dbms_utility.format_error_backtrace);
    rollback;
    RAISE errnums.E_SYSTEM_ERROR;
END;

PROCEDURE pr_Gen_AfterConvert
IS
v_nextdate varchar2(20);
v_currdate varchar2(20);
v_prevdate varchar2(20);
l_MAXDEBTSE number;
l_err_code varchar2(1000);
v_prinused number;
BEGIN
v_nextdate:=cspks_system.fn_get_sysvar ('SYSTEM', 'NEXTDATE');
v_currdate:=cspks_system.fn_get_sysvar ('SYSTEM', 'CURRDATE');
v_prevdate:=cspks_system.fn_get_sysvar ('SYSTEM', 'PREVDATE');

reset_sequence('seq_secbasket',1);

select to_number(varvalue) into l_MAXDEBTSE from sysvar where grname = 'MARGIN' and varname = 'MAXDEBTSE';







update sysvar
set varvalue = '1'
where varname = 'HOSTATUS';

begin
        for rec in
        (
        select * from user_objects where object_type = 'TRIGGER'
        )
        loop
                     execute immediate 'ALTER TRIGGER ' || rec.object_name || ' ENABLE';
        end loop;
end;


EXCEPTION
  WHEN others THEN
    plog.error('CONVERT:' || SQLERRM || '.At:' || dbms_utility.format_error_backtrace);
    rollback;
    RAISE errnums.E_SYSTEM_ERROR;
END;

function todate(p_date in varchar2)
return date is
begin
return to_date(nvl(p_date,'01/01/1900'),'DD/MM/RRRR');
exception when others then
return to_date('01/01/1900','DD/MM/RRRR');
end;

function tonumber(p_number in varchar2)
return number is
l_number varchar2(1000);
l_num number;
begin
l_number:= trim(replace(replace(p_number,',',''),'?',''));

select to_number(decode(l_number,null,'0','-','0',l_number)) into l_num from dual;
return l_num;

exception when others then
return null;
end;

begin
  for i in (select * from tlogdebug) loop
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  end loop;

  pkgctx := plog.init('pks_data_conversion',
                      plevel     => nvl(logrow.loglevel, 30),
                      plogtable  => (nvl(logrow.log4table, 'N') = 'Y'),
                      palert     => (nvl(logrow.log4alert, 'N') = 'Y'),
                      ptrace     => (nvl(logrow.log4trace, 'N') = 'Y'));
END;
/
