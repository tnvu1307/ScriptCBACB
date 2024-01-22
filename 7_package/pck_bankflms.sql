SET DEFINE OFF;
CREATE OR REPLACE PACKAGE pck_bankflms
  IS

 TYPE tltxfld_rectype IS RECORD (
      fldname           fldmaster.fldname%TYPE,
      defname           fldmaster.defname%TYPE,
      datatype            fldmaster.datatype%TYPE,
      value         varchar2(1000),
      length         number
   );

   TYPE tltxfld_arrtype IS TABLE OF tltxfld_rectype
      INDEX BY PLS_INTEGER;


    PROCEDURE transact_Exec(p_transactionnumber IN VARCHAR2, p_autoid IN number, p_err_code OUT VARCHAR2);
    PROCEDURE auto_call_txpks_6645(pv_reqid IN  number, pv_busdate in varchar2, p_err_code IN OUT varchar2);


    procedure sp_auto_gen_confirm_transact ;
    procedure sp_auto_gen_SCOA;
    -- procedure sp_auto_gen_fee_invoice;
    procedure sp_auto_gen_tax_invoice;
    procedure sp_auto_gen_fee_broker;
    procedure sp_auto_gen_fee_broker_IP;
    procedure sp_auto_gen_fee_broker_OP;
    procedure sp_auto_gen_CA3342_TD;
    procedure sp_auto_gen_payment_interest;
    procedure sp_auto_gen_payment_interest_in;
    procedure sp_auto_gen_payment_interest_out;
    procedure sp_auto_gen_ca3387_citad_result;
    function buildtltxdata (p_reqid IN number)  RETURN tltxfld_arrtype;

    procedure sp_auto_gen_fee_invoice(p_autoid VARCHAR2) ;

END;
/


CREATE OR REPLACE PACKAGE BODY pck_bankflms
IS
      -- declare log context
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;



PROCEDURE auto_call_txpks_6645(pv_reqid IN  number, pv_busdate in varchar2, p_err_code IN OUT varchar2) is
      l_txmsg       tx.msg_rectype;
      v_strcurrdate varchar2(20);
      l_strdesc     varchar2(400);
      l_tltxcd      varchar2(4);

      l_err_param   varchar2(1000);
      l_sqlerrnum   varchar2(200);
      l_codeid      varchar2(6);
      pv_funcname   varchar2(50);
      l_acctno      varchar2(10);
      l_symbol      varchar2(20);
      l_symboltype  varchar2(4);
      l_symbolclas  varchar2(1);
      l_count       number;
      l_SECTYPE varchar2(50);
      v_bankaccount varchar2(50);
v_amount varchar2(50);
v_ccycd varchar2(4);
v_desc varchar2(250);
v_custodycd varchar2(50);
v_transactionnumber varchar2(50);
v_afacctno varchar2(50);
v_acctno varchar2(50);
    begin

      --Lay thong tin dien confirm
      /*for rec0 in (select req.*
                     from vsdtxreq req
                    where req.msgstatus in ('C', 'W')
                      and req.reqid = pv_reqid) loop*/
        -- nap giao dich de xu ly
        l_tltxcd       := '6645';
        l_txmsg.tltxcd := l_tltxcd;

        l_txmsg.msgtype := 'T';
        l_txmsg.local   := 'N';
        l_txmsg.tlid    := systemnums.c_system_userid;
        select sys_context('USERENV', 'HOST'),
               sys_context('USERENV', 'IP_ADDRESS', 15)
          into l_txmsg.wsname, l_txmsg.ipaddress
          from dual;
        l_txmsg.off_line  := 'N';
        l_txmsg.deltd     := txnums.c_deltd_txnormal;
        l_txmsg.txstatus  := txstatusnums.c_txcompleted;
        l_txmsg.msgsts    := '0';
        l_txmsg.ovrsts    := '0';
        l_txmsg.batchname := 'DAY';
        l_txmsg.busdate   := to_date(pv_busdate,'DD/MM/RRRR');
        l_txmsg.txdate    := getcurrdate;
        l_txmsg.txtime    := to_char(sysdate,'hh24:mi:ss');
        select systemnums.c_batch_prefixed ||
                lpad(seq_batchtxnum.nextval, 8, '0')
          into l_txmsg.txnum
          from dual;
        select to_char(sysdate, 'hh24:mi:ss') into l_txmsg.txtime from dual;
        l_txmsg.brid := '0000'; -- can sua lai them brid trong vsdtxreq de fill lai gt vao day






                select systemnums.c_batch_prefixed ||
                        lpad(seq_batchtxnum.nextval, 8, '0')
                  into l_txmsg.txnum
                  from dual;
                select to_char(sysdate, 'hh24:mi:ss') into l_txmsg.txtime from dual;



select rbankaccount creditaccount, exchangevalue creditamount,tocurrency, refval, notes
into v_bankaccount,v_amount,v_ccycd,v_transactionnumber,v_desc
from crbtxreq where  objname = '1720' and reqid = pv_reqid and rownum=1;
 select afacctno,custodycd,acctno,ccycd into v_afacctno,v_custodycd,v_acctno,v_ccycd
                from ddmast where refcasaacct= trim(v_bankaccount) and status <>'C';

 for rec in (
           select f.fldname,f.defname , f.datatype,
                  case when fldname='90' then   (select c.fullname from cfmast c  where c.custodycd =v_custodycd )
                   when fldname='03' then  v_afacctno
                   when fldname='04' then  'TRFCIDAMT'
                   when fldname='05' then  v_acctno
                   when fldname='09' then  '023'
                   when fldname='10' then  v_amount
                   when fldname='21' then  v_ccycd
                   when fldname='30' then  v_desc
                   when fldname='88' then  v_custodycd
                   when fldname='02' then  v_transactionnumber
                end value ,1 length
              from fldmaster f where objname ='6645'
              )
              loop
                   l_txmsg.txfields (rec.fldname).defname   := rec.defname;
                   l_txmsg.txfields (rec.fldname).TYPE      := rec.datatype;
                   l_txmsg.txfields (rec.fldname).value      :=  rec.value;
              end loop;




             if txpks_#6645.fn_batchtxprocess(l_txmsg, p_err_code, l_err_param) <>              systemnums.c_success then

               rollback;
             else
              p_err_code:=0;
             end if;

end;

PROCEDURE transact_Exec(p_transactionnumber IN VARCHAR2, p_autoid IN number, p_err_code  OUT VARCHAR2)
IS
    -- Enter the procedure variables here. As shown below
    p_sqlcommand VARCHAR2(4000);
    l_txmsg       tx.msg_rectype;
    l_err_param varchar2(300);
    v_strCURRDATE varchar2(20);
    v_strBUSDATE varchar2(20);
    v_tltxcd varchar2(20);
    v_txtime varchar2(50);
    v_status char(1);
    v_status2 varchar2(10);
    v_trnref varchar2(50);
    v_trnref2 varchar2(50);
    v_currencycode varchar2(20);
    v_bankobj varchar2(50);
    v_msgtype varchar2(2);
    v_reftxnum varchar2(30);
    v_reftxdate varchar2(30);
    v_reqtxnum varchar2(30);
    L_txnum varchar2(30);
    v_ddacctno varchar2(50);
    v_reqid number;
    v_bankbalance number;
    v_bankholdbalance number;
    v_tltxcd_revert varchar2(20);
    v_strstatus varchar2(1);
    v_errordescfrombank varchar2(1000);
    v_errordescdetail varchar2(1000);
    v_holdtxnum varchar2(50);
    v_txdate date;
    v_table varchar2(50);
    v_objname varchar2(30);
    v_objkey varchar2(30);
    v_repval varchar2(50);
    v_CANCEL varchar2(10);
    v_checkexist number;
    v_timestamp TIMESTAMP;
    v_desbankaccount varchar2(50);
    v_n01autoid number;
    v_seq_cashaccount number;
    v_type_SGDC0948B001 varchar2(10);
    v_acstatus_SGDC0948B001 varchar2(10);
    v_cif_SGDC0948B001 varchar2(30);
    v_action_type varchar2(10);
    v_ccycd_SGDC0948B001 varchar2(5);
    v_actype_SGDC0948B001 varchar2(10);
    v_actype_SGDC0948D001 varchar2(10);
    v_feetype varchar2(10);
    v_bankaccount_SGDC0948D001  varchar2(30);
    v_bankaccount_SGDC0948B001  varchar2(30);
    v_acstatus_SGDC0948D001 varchar2(30);
    v_cif_SGDC0948D001 varchar2(30);
    v_ccycd_SGDC0948D001 varchar2(30);
    v_frbr_SGDC0948D001 varchar2(30);
    v_tobr_SGDC0948D001 varchar2(30);
    v_type_SGDC0948D001 varchar2(30);
    v_count_SGDC0948D001 number;
    v_count_SGDC0948B001 number;
    v_trx_scrno varchar2(20);
    v_backlist varchar2(30);
    v_opendate date;
    v_branchdate date;
    v_crbtxreqreqid number;
    v_orgreqtxnum varchar2(100);
    v_typereq varchar2(100);
    v_cus_ac_acdnt_c  varchar2(100);
    v_trans_type varchar2(250);
    v_citad varchar2(250);
    v_bankcode  varchar2(250);
    v_branchname    varchar2(250);
    v_bankname  varchar2(250);
    v_regionname    varchar2(250);
    v_cfm_bankname  varchar2(250);
    v_bnk_bankname  varchar2(250);
    v_in_direct varchar2(250);
    v_TRANS_DATE date;
    v_autoid_process number;
    BEGIN
        -- tu p_transactionnumber lay ra thong tin can thiet tu dien
        SELECT AUTOID, TO_CHAR(TXDATE,'DD/MM/RRRR'), STATUS, SUBSTR(TRANSACTIONNUMBER,0,31)||'1', TRNREF, BANKOBJ, MSGTYPE, CBOBJ, ERRORDESC, DESBANKACCOUNT, (TRNREF || '01') TRNREF2
        INTO V_REQID, V_STRBUSDATE, V_STATUS, V_TRNREF, V_REPVAL, V_BANKOBJ, V_MSGTYPE, V_TLTXCD, V_ERRORDESCFROMBANK, V_DESBANKACCOUNT, V_TRNREF2
        FROM CRBBANKREQUEST
        WHERE TRANSACTIONNUMBER = P_TRANSACTIONNUMBER
        AND AUTOID = P_AUTOID
        AND ISCONFIRMED = 'N'
        AND ROWNUM = 1;

        --###### khu vuc hardcode

        --locpt tam thoi hardcode cho nay vi hien tai chua co cho khai
        --thong tin cho giao dich revert trong case fail

        if (v_status ='1' ) then
            CASE v_tltxcd
                WHEN '6696' THEN
                    v_tltxcd:= '6698';
                WHEN '6697' THEN
                    v_tltxcd:= '6699';
                WHEN '6626' THEN
                    v_tltxcd:= '6628';
                WHEN '6627' THEN
                    v_tltxcd:= '6629';
                WHEN '6674' THEN
                    v_tltxcd:= '6675';
                WHEN '6657' THEN
                    v_tltxcd:= '6659';
                WHEN '6653' THEN
                    v_tltxcd:= '6654';
            else
                v_tltxcd:= v_tltxcd;
            end case;
            v_strstatus:='R';

            begin
                select errdesc into v_errordescdetail  from bankdeferror where errorcode = v_errordescfrombank and rownum = 1;
            EXCEPTION when no_data_found THEN
                v_errordescdetail:=v_errordescfrombank;
            end;
        else
            v_strstatus:='C';
        end if;

        UPDATE crbtxreq SET ERRORDESC = v_errordescdetail, repval=v_repval ---gan loi o day vi hien tai ma loi len den 1000char so bi tran chuoi sql
        WHERE refval = v_trnref;

        if v_bankobj = '08' then
            select objname,objkey into v_objname,v_objkey
            from crbtxreq where refval = v_trnref;
            if v_objname='FEEBROKER' then
                UPDATE crbbankrequest SET isconfirmed='Y',cfstatus = 'C'  WHERE transactionnumber = p_transactionnumber;
                UPDATE crbtxreq SET pstatus = status ,status=v_strstatus  WHERE refval = v_trnref;
                update fee_broker_result set status = v_strstatus,bankglobalid =p_transactionnumber where autoid = v_objkey and refcode = v_objname;
                return;
            end if;

            if v_objname = 'CA3342_TD' then
                UPDATE crbbankrequest SET isconfirmed='Y',cfstatus = 'C'  WHERE transactionnumber = p_transactionnumber;
                UPDATE crbtxreq SET pstatus = status ,status=v_strstatus  WHERE refval = v_trnref;
                update CA3342_TD_result set status = v_strstatus,bankglobalid =p_transactionnumber where autoid = v_objkey;
                return;
            end if;

            if v_objname = 'PAYMENTINTEREST' then
                UPDATE crbbankrequest SET isconfirmed='Y',cfstatus = 'C'  WHERE transactionnumber = p_transactionnumber;
                UPDATE crbtxreq SET pstatus = status ,status=v_strstatus  WHERE refval = v_trnref;
                update PAYMENT_INTEREST set status = v_strstatus,bankglobalid =p_transactionnumber where autoid = v_objkey;
                return;
            end if;
        end if;

        if v_bankobj = '02' then
            select objname,objkey into v_objname,v_objkey
            from crbtxreq where refval = v_trnref;
            if v_objname='FEEBROKEROP' then
                UPDATE crbbankrequest SET isconfirmed='Y' ,cfstatus = 'C' WHERE transactionnumber = p_transactionnumber;
                UPDATE crbtxreq SET pstatus = status,status=v_strstatus  WHERE refval = v_trnref;
                update fee_broker_result set status = v_strstatus,bankglobalid =p_transactionnumber where autoid = v_objkey and refcode = v_objname;
                return;
            end if;

            if v_objname='CA3387_CITAD' then
                UPDATE crbbankrequest SET isconfirmed='Y',cfstatus = 'C'  WHERE transactionnumber = p_transactionnumber;
                UPDATE crbtxreq SET pstatus = status,status=v_strstatus  WHERE refval = v_trnref;
                update CA3387_CITAD_RESULT set pstatus = status,status = v_strstatus,bankglobalid =p_transactionnumber where autoid = v_objkey ;
                return;
            end if;

            if v_objname='PAYMENTINTEREST_OUT' then
                UPDATE crbbankrequest SET isconfirmed='Y',cfstatus = 'C'  WHERE transactionnumber = p_transactionnumber;
                UPDATE crbtxreq SET pstatus = status,status=v_strstatus  WHERE refval = v_trnref;
                update PAYMENT_INTEREST set pstatus = status,status = v_strstatus,bankglobalid =p_transactionnumber where autoid = v_objkey and refcode = v_objname;
                return;
            end if;
        end if;

        if v_bankobj = '01' then
            select objname,objkey into v_objname,v_objkey
            from crbtxreq where refval = v_trnref;
            if v_objname='FEEBROKERIP' then
                UPDATE crbbankrequest SET isconfirmed='Y',cfstatus = 'C'  WHERE transactionnumber = p_transactionnumber;
                UPDATE crbtxreq SET pstatus = status,status=v_strstatus  WHERE refval = v_trnref;
                update fee_broker_result set status = v_strstatus,bankglobalid =p_transactionnumber where autoid = v_objkey and refcode = v_objname;
                return;
            end if;

            if v_objname='6650' then
                if v_status ='1'  THEN
                    v_tltxcd:= '6658';
                else
                    v_tltxcd:= '6656';
                end if;
            end if;

            if v_objname = 'PAYMENTINTEREST_IN' then
                UPDATE crbbankrequest SET isconfirmed='Y',cfstatus = 'C'  WHERE transactionnumber = p_transactionnumber;
                UPDATE crbtxreq SET pstatus = status,status=v_strstatus  WHERE refval = v_trnref;
                update PAYMENT_INTEREST set pstatus = status,status = v_strstatus,bankglobalid =p_transactionnumber where autoid = v_objkey and refcode = v_objname;
                return;
            end if;
        end if;

        if v_bankobj = '11C' then
           select max(case when fldname = 'CANCEL' then cval else '' end) CANCEL
                    into  v_CANCEL
                    from crbbankrequestdtl
                    where reqid = v_reqid;
            if trim(v_CANCEL) <> '10' then -- khac 10 => gd cancel => goi gd hach toan nguoc lai
                UPDATE crbbankrequest SET cbobj = '6642' WHERE autoid = v_reqid;
                v_tltxcd := '6642';
            end if;
        end if;

        if v_bankobj = '11D' then
           select max(case when fldname = 'CANCEL' then cval else '' end) CANCEL
                    into  v_CANCEL
                    from crbbankrequestdtl
                    where reqid = v_reqid;
            if trim(v_CANCEL) <> '10' then -- khac 10 => gd cancel => goi gd hach toan nguoc lai
                UPDATE crbbankrequest SET cbobj = '6645' WHERE autoid = v_reqid;
                v_tltxcd := '6645';
            end if;
        end if;

        if v_bankobj = 'SGDC0948E001' then
            select max(case when fldname = 'dep_acdnt_regis_rls_d' then cval else '' end) typereq,
                    max(case when fldname = 'cus_ac_acdnt_c' then cval else '' end)
                    into  v_typereq,v_cus_ac_acdnt_c
                    from crbbankrequestdtl
                    where reqid = v_reqid;
            if v_cus_ac_acdnt_c = '62' then --62 la HOLD/UNHOLD BALANCE/   61 debit block(chua phat trien)
                if trim(v_typereq) = '1' then --=1 LA GIAO DICH HOLD/ 2 LA GIAO DICH UNHOLD
                    UPDATE crbbankrequest SET cbobj = '6603' WHERE autoid = v_reqid;
                    v_tltxcd := '6603';
                ELSE
                    UPDATE crbbankrequest SET cbobj = '6604' WHERE autoid = v_reqid;
                    v_tltxcd := '6604';
                end if;
            end if;
        end if;

        if v_bankobj ='SGCB0955F001' then
            select max(case when fldname ='trx_scrno' then cval else '' end) trx_scrno
            into  v_trx_scrno
            from crbbankrequestdtl
            where reqid = v_reqid;

            if trim(v_trx_scrno) = '4540010000' then     --4001 -> Chuyen tie`n ra nuo?c ngoa`i
                UPDATE crbbankrequest SET cbobj = '6702' WHERE autoid = v_reqid;
                v_tltxcd := '6702';
            elsif  trim(v_trx_scrno) = '4540110000' then  --4011 -> nhan tien tu nuoc ngoai
                UPDATE crbbankrequest SET cbobj = '6703' WHERE autoid = v_reqid;
                v_tltxcd := '6703';
            else    --4550110000  5011 ->  FX du`ng cho truo`ng ho?p ch?ty? gia? truo?c va` kh?co? ta`i khoa?n ti? hoa?c Ch?truo?c ty?
                UPDATE crbbankrequest SET cbobj = '6704' WHERE autoid = v_reqid;
                v_tltxcd := '6704';
            end if;
        end if;

        if v_bankobj = 'N06' then --- case cho N06 thi se gen giao dich hach toan giam tien 6642
            --lay ra so tk ddmast de xu ly
            select reqtxnum,objname,feetype into v_reqtxnum,v_objname,v_feetype from crbtxreq where refval = v_trnref;
            update tax_booking_result set pstatus =status, status= v_strstatus,bankrefid = p_transactionnumber where autoid = v_reqtxnum;
            if v_feetype = '50' and  v_strstatus='C' then
                --- gan lai de sinh hach toan thue vi thue thu ngay lap tuc
                UPDATE crbbankrequest SET cbobj = '6642' WHERE autoid = v_reqid;
                v_tltxcd := '6642';
            else
                UPDATE crbbankrequest SET isconfirmed='Y',cfstatus = 'C'  WHERE transactionnumber = p_transactionnumber;
                UPDATE crbtxreq SET status=v_strstatus WHERE refval = v_trnref;
                return;
            end if;
        end if;

        if v_bankobj = 'N10' then --- case cho N06 thi se gen giao dich hach toan giam tien 6642
            --lay ra so tk ddmast de xu ly
            select reqid,objkey into v_crbtxreqreqid, v_orgreqtxnum from crbtxreq where refval = v_trnref;
            if  v_strstatus='C' then
                --sinh hach toan tang tien
                auto_call_txpks_6645(v_crbtxreqreqid,v_strBUSDATE, p_err_code );
                --- gan lai de sinh hach toan giam ngay lap tuc
                if p_err_code = 0 then
                    UPDATE crbbankrequest SET cbobj = '6642' WHERE autoid = v_reqid;
                    v_tltxcd := '6642';
                else
                    UPDATE crbbankrequest SET isconfirmed='Y',cfstatus = 'E' ,ERRORDESC = 'Got error at CBPlus:'||p_err_code  WHERE transactionnumber = p_transactionnumber;
                    UPDATE crbtxreq SET status=v_strstatus WHERE refval = v_trnref;
                    return;
                end if;
                UPDATE tbl_mt380_inf SET status = 'C' WHERE reqid = (select cvalue from tllogfld where txnum =v_orgreqtxnum and fldcd = '99') AND status = 'A';
            else
                UPDATE crbbankrequest SET isconfirmed='Y',cfstatus = 'C'  WHERE transactionnumber = p_transactionnumber;
                UPDATE crbtxreq SET status=v_strstatus WHERE refval = v_trnref;
                UPDATE tbl_mt380_inf SET status = 'P' WHERE reqid = (select cvalue from tllogfld where txnum =v_orgreqtxnum and fldcd = '99') AND status = 'A';
                return;
            end if;
        end if;

    --###### end  khu vuc hardcode
   -- 
    --case ra xu ly cho tung truong hop
    CASE v_bankobj
    WHEN 'SGDC0948D001' THEN -- account change branchcode
    BEGIN
        select  max(case when d.fldname ='lcl_ac_no' then cval else '' end) BANKACCOUNT
            ,max(case when d.fldname ='dep_ac_s' then cval else '' end) ACCSTATUS   -- 99  close 10 open
            ,max(case when d.fldname ='cusno' then  cval else '' end) CIF
            ,max(case when d.fldname ='ccy_c' then  cval else '' end) CCYCD
            ,max(case when d.fldname ='trcl_brno' then  cval else '' end) FRBR
            ,max(case when d.fldname ='rcvin_brno' then  cval else '' end) TOBR
            ,max(case when d.fldname ='ACTYPE' then  cval else '' end) ACTYPE
            ,to_date(max(case when d.fldname ='dep_ac_new_dt' then  cval else '' end),'RRRRMMDD') OPENDATE
            ,max(txdate) branchdate
        into v_bankaccount_SGDC0948D001 ,v_acstatus_SGDC0948D001,v_cif_SGDC0948D001,v_ccycd_SGDC0948D001,v_frbr_SGDC0948D001,v_tobr_SGDC0948D001,v_actype_SGDC0948D001,v_opendate,v_branchdate
        from crbbankrequest c,crbbankrequestdtl d
        where c.autoid = d.reqid and c.transactionnumber =  p_transactionnumber;

        select seq_CASH_ACCOUNT_AITHER.nextval into v_seq_cashaccount from dual;
        if (v_acstatus_SGDC0948D001 = 10 and (v_tobr_SGDC0948D001 ='8146' or v_tobr_SGDC0948D001 ='7906') ) then
            v_acstatus_SGDC0948D001:= '10';
        else
            v_acstatus_SGDC0948D001:= '99';
        end if;

        select count(*) into v_count_SGDC0948D001
        from ddmast where refcasaacct =v_bankaccount_SGDC0948D001;
        if (v_count_SGDC0948D001 =0  ) then
            v_type_SGDC0948D001:= '01';
        else
            v_type_SGDC0948D001:= '02';
        end if;

        insert into CASH_ACCOUNT_AITHER(  AUTOID , TYPE , CIFID ,CUSTNAME,DDACCTNO,BANKACCOUNT ,CUSTODYCD, ACCOUNTTYPE,STATUS , TLID ,BANKREF , LASTCHANGE,ACCOUNTSTATUS,CCYCD,opendate,branchdate )
        select v_seq_cashaccount,v_type_SGDC0948D001,  v_cif_SGDC0948D001,'' fullname,'' acctno,
            v_bankaccount_SGDC0948D001,'' CUSTODYCD,v_actype_SGDC0948D001 ,'P','0001',p_transactionnumber,systimestamp
            ,v_acstatus_SGDC0948D001,v_ccycd_SGDC0948D001,v_opendate,v_branchdate
        from crbbankrequest c--,cfmast cf,ddmast  dd
        where  c.transactionnumber =  p_transactionnumber ;--and cf.cifid= v_cif_SGDC0948D001 and c.desbankaccount= dd.refcasaacct(+) ;


        UPDATE crbbankrequest SET isconfirmed='Y',cfstatus = 'C'  WHERE transactionnumber = p_transactionnumber;
        --  WHEN 'SGDC0948C001' then -- sgdc09408c_130withdraw_notification _new
        --      UPDATE crbbankrequest SET isconfirmed='Y',cfstatus = 'C'  WHERE transactionnumber = p_transactionnumber;
        --trung.luu: 28/04/2021 api add/edi/delete citad
    END;
    WHEN 'SGCB0955B001' THEN
    BEGIN
        select  max(case when d.fldname ='trx_type' then cval else '' end) trans_type --01:new /02:Update/04:Delete
            ,max(case when d.fldname ='gre_tadci_c' then cval else '' end) citad
            ,max(case when d.fldname ='ft_rcv_agc_bnk_no' then  cval else '' end) bankcode
            ,max(case when d.fldname ='vn_tadci_nm' then  cval else '' end) branchname
            ,max(case when d.fldname ='bnk_nm' then  cval else '' end) bankname
            ,max(case when d.fldname ='jurdt_rgt_regn_nm' then  cval else '' end) regionname
            ,max(case when d.fldname ='cfm_bnk_nm' then  cval else '' end) cfm_bankname
            ,max(case when d.fldname ='abrv_bnk_nm' then  cval else '' end) bnk_bankname
            ,max(case when d.fldname ='drt_idr_d' then  cval else '' end) in_direct
            ,MAX(TXDATE) TXDATE
        into v_trans_type ,v_citad,v_bankcode,v_branchname,v_bankname,v_regionname,v_cfm_bankname,v_bnk_bankname,v_in_direct,v_TRANS_DATE
        from crbbankrequest c,crbbankrequestdtl d
        where c.autoid = d.reqid and c.transactionnumber =  p_transactionnumber;

        v_autoid_process := seq_request_citad_aither.nextval;
        insert into  request_citad_aither ( autoid,reqid,trans_type,trans_date,citadcode,bankcode,branchname,bankname,region_name,cfm_bank_name,abbreviated_name,in_direct,status)
        values (v_autoid_process,v_reqid,v_trans_type,v_TRANS_DATE,v_citad,v_bankcode,v_branchname,v_bankname,v_regionname,v_cfm_bankname,v_bnk_bankname,v_in_direct,'P');

        UPDATE crbbankrequest SET isconfirmed='Y',cfstatus = 'C'  WHERE transactionnumber = p_transactionnumber;

        begin
            sp_process_request_citad_aither(v_autoid_process);
        end;
    END;
    WHEN 'SGDC0948B001' then -- cash account notification
    BEGIN
        select  max(case when d.fldname ='TRX_D' then cval else '' end) TYPE
            ,max(case when d.fldname ='ACCSTATUS' then cval else '' end) ACCSTATUS
            ,max(case when d.fldname ='CIFID' then  cval else '' end) CIF
            ,max(case when d.fldname ='CURRENCYCODE' then  cval else '' end) CCYCD
            ,max(case when d.fldname ='ACTYPE' then  cval else '' end) ACTYPE, max(c.desbankaccount)
        into v_type_SGDC0948B001 ,v_acstatus_SGDC0948B001,v_cif_SGDC0948B001,v_ccycd_SGDC0948B001,v_actype_SGDC0948B001,v_bankaccount_SGDC0948B001
        from crbbankrequest c,crbbankrequestdtl d
        where c.autoid = d.reqid and c.transactionnumber =  p_transactionnumber;

        select seq_CASH_ACCOUNT_AITHER.nextval into v_seq_cashaccount from dual;

        select count(*) into v_count_SGDC0948B001
        from ddmast where refcasaacct =v_bankaccount_SGDC0948B001;
        if (v_count_SGDC0948B001 =0  ) then
            v_type_SGDC0948D001:= '01';
        else
            v_type_SGDC0948D001:= '02';
        end if;

        insert into CASH_ACCOUNT_AITHER( AUTOID , TYPE , CIFID ,CUSTNAME,DDACCTNO,BANKACCOUNT ,CUSTODYCD,ACCOUNTTYPE,STATUS , TLID ,BANKREF , LASTCHANGE,ACCOUNTSTATUS,CCYCD,opendate )
        select v_seq_cashaccount,v_type_SGDC0948B001,  v_cif_SGDC0948B001,'' fullname,'' acctno,
            c.desbankaccount,'' CUSTODYCD,v_actype_SGDC0948B001,'P','0001',p_transactionnumber,systimestamp
            ,v_acstatus_SGDC0948B001,v_ccycd_SGDC0948B001,c.txdate
        from crbbankrequest c
        where  c.transactionnumber =  p_transactionnumber  ;

        --update trang thai nhan
        UPDATE crbbankrequest SET isconfirmed='Y',cfstatus = 'C'  WHERE transactionnumber = p_transactionnumber;
    END;
    WHEN 'SGCB0956A001' then  ---citad refund
    BEGIN
        insert into citad_revert(transactionnumber, txdate, status, errordesc, refno,
        addinfo, cardno, transactiondescription, theirrefno,
        trandate, currency, amount, benefitaccountname,
        applcaccountno, applcaccountname, interfacetype,
        sendingbankname, revbankname, valuedate,
        fundtranferfilename,benefitaccountno,transferorder)
        select max(c.TRANSACTIONNUMBER) TRANSACTIONNUMBER,
            max(c.txdate) TXDATE,
            'P' STATUS,
            max(c.errordesc) ERRORDESC,
            max(case when fldname = 'acno' then cval else '' end) refno,
            max(case when fldname = 'ft_aprv_rtrn_rsn_his' then cval else '' end) addinfo,
            max(case when fldname = 'oasis_ft_no' then cval else '' end) oasis_ft_no,
            max(case when fldname = 'TRANSACTIONDESCRIPTION' then cval else '' end) TRANSACTIONDESCRIPTION,
            max(case when fldname = 'thr_refno' then cval else '' end) thr_refno,
            max(case when fldname = 'trx_dt' then cval else '' end) trx_dt,
            max(case when fldname = 'ccy_c' then cval else '' end) ccy_c,
            max(case when fldname = 'trx_amt' then nval else 0 end) trx_amt,
            max(case when fldname = 'ft_bnfc_cus_nm' then cval else '' end) ft_bnfc_cus_nm,
            max(case when fldname = 'ft_aplct_cus_ac_no' then cval else '' end) ft_aplct_cus_ac_no,
            max(case when fldname = 'ft_aplct_cus_nm' then cval else '' end) ft_aplct_cus_nm,
            max(case when fldname = 'intf_t' then cval else '' end) intf_t,
            max(case when fldname = 'ft_snd_bnk_nm' then cval else '' end) ft_snd_bnk_nm,
            max(case when fldname = 'ft_rcvbnk_nm' then cval else '' end) ft_rcvbnk_nm,
            max(case when fldname = 'val_dt' then cval else '' end) val_dt,
            max(case when fldname = 'ft_msg_no' then cval else '' end) ft_msg_no,
            max(case when fldname = 'bnfc_ac_no1' then cval else '' end) bnfc_ac_no1,
            max(case when fldname = 'ft_msg_ord_ctt_210' then cval else '' end) ft_msg_ord_ctt_210
        from crbbankrequestdtl d,crbbankrequest c
        where d.reqid =c.autoid and c.autoid= v_reqid;
        --update trang thai nhan
        UPDATE crbbankrequest SET isconfirmed='Y',cfstatus = 'C'  WHERE transactionnumber = p_transactionnumber;
    END;
    WHEN '15' THEN  --dien tra ti gia SBV ko xai nua
       --update trang thai nhan
        UPDATE crbbankrequest SET isconfirmed='Y',cfstatus = 'C'  WHERE transactionnumber = p_transactionnumber;
    WHEN '07' THEN  --dien tra inquiry thi cap nhat lai data trong ddmast
        begin

            --lay ra so tk ddmast de xu ly
            select afacctno into v_ddacctno from crbtxreq where refval = v_trnref;

            --lay ra so lieu can cap nhat
            select max(case when fldname = 'AVLBALANCE' then nval else 0 end) bankbalance,
                max(case when fldname = 'RESTRICTAMT' then nval else 0 end) bankholdbalance
            into v_bankbalance, v_bankholdbalance
            from crbbankrequestdtl
            where reqid = v_reqid;

            update ddmast set bankbalance=v_bankbalance , bankholdbalance = v_bankholdbalance
            where acctno = v_ddacctno;
            --and (select count(1) from crbtxreq where refval = v_trnref and reqcode NOT IN ('INQACCTAUTO')) > 0;

            UPDATE crbbankrequest SET isconfirmed='Y',cfstatus = 'C'  WHERE transactionnumber = p_transactionnumber;
            UPDATE crbtxreq SET status=v_strstatus,txamt=v_bankbalance  WHERE refval = v_trnref;
        EXCEPTION when others THEN
            -- truong hop bi loi thi update crbtxreq --> hoan tat , update crbbankrequest --> xu ly loi tai cbplus
            UPDATE crbbankrequest SET isconfirmed='Y',cfstatus = 'E'   , ERRORDESC = 'Got error at CBPlus:'|| dbms_utility.format_error_backtrace WHERE transactionnumber = p_transactionnumber;
            UPDATE crbtxreq SET status=v_strstatus  WHERE refval = v_trnref;
        end;
        BEGIN
            DELETE FROM INQACCT_LOG WHERE (AFACCTNO, TXDATE) IN (SELECT AFACCTNO, TXDATE FROM CRBTXREQ WHERE REFVAL = V_TRNREF);

            INSERT INTO INQACCT_LOG (REQID, OBJTYPE, OBJNAME, TRFCODE, REQCODE, OBJKEY, TXDATE, BANKCODE, BANKACCT, AFACCTNO, TXAMT, NOTES, STATUS, REFTXNUM, REFTXDATE, REFVAL, AFFECTDATE, ERRORCODE, CREATEDATE, GRPREQID, VIA, RBANKACCOUNT, RBANKNAME, RBANKCITAD, RBANKACCNAME, TRNREF, ERRORDESC, PSTATUS, UNHOLD, REPVAL, CURRENCY, REQTXNUM, DORC, FEEAMT, TAXAMT, FEECODE, FEETYPE, EXCHANGERATE, EXCHANGEVALUE, TOCURRENCY, FEENAME, BRANCH, BUSDATE, BALANCE, BANKBALANCE, HOLDBALANCE, BANKHOLDBALANCE)
            SELECT REQID, OBJTYPE, OBJNAME, TRFCODE, REQCODE, OBJKEY, TXDATE, BANKCODE, BANKACCT, AFACCTNO, TXAMT, NOTES, STATUS, REFTXNUM, REFTXDATE, REFVAL, AFFECTDATE, ERRORCODE, CREATEDATE, GRPREQID, VIA, RBANKACCOUNT, RBANKNAME, RBANKCITAD, RBANKACCNAME, TRNREF, ERRORDESC, PSTATUS, UNHOLD, REPVAL, CURRENCY, REQTXNUM, DORC, FEEAMT, TAXAMT, FEECODE, FEETYPE, EXCHANGERATE, EXCHANGEVALUE, TOCURRENCY, FEENAME, BRANCH, BUSDATE, DD.BALANCE, V_BANKBALANCE, DD.HOLDBALANCE, V_BANKHOLDBALANCE
            FROM CRBTXREQ REQ,
            (
                SELECT ACCTNO, BALANCE, HOLDBALANCE FROM DDMAST WHERE ACCTNO = V_DDACCTNO
            ) DD
            WHERE REQ.REFVAL = V_TRNREF
            AND REQ.AFACCTNO = DD.ACCTNO;
        EXCEPTION WHEN OTHERS THEN
            plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
        END;
    WHEN '09' THEN  --dien tra COA thi cap nhat lai data trong gl_exp_results
        begin

            --lay ra so tk ddmast de xu ly
            select reqtxnum into v_reqtxnum from crbtxreq where refval = v_trnref;

            update gl_exp_results set pstatus =status, status= decode(v_strstatus,'C','Y','E') where bankreqid = v_reqtxnum;
            UPDATE crbbankrequest SET isconfirmed='Y',cfstatus = 'C'  WHERE transactionnumber = p_transactionnumber;
            UPDATE crbtxreq SET status=v_strstatus  WHERE refval = v_trnref;
        EXCEPTION when others THEN
            -- truong hop bi loi thi update crbtxreq --> hoan tat , update crbbankrequest --> xu ly loi tai cbplus
            UPDATE crbbankrequest SET isconfirmed='Y' ,cfstatus = 'E'  , ERRORDESC = 'Got error at CBPlus:'|| dbms_utility.format_error_backtrace WHERE transactionnumber = p_transactionnumber;
            UPDATE crbtxreq SET status='C'  WHERE refval = v_trnref;
        end;
    WHEN 'N01' THEN  -- dien cap nhat thong tin khach hang
        BEGIN
        v_n01autoid:= seq_cfmast_aither.nextval;

        insert into cfmast_aither
        select v_n01autoid,   v_reqid,
        max(case when fldname = 'action_t' then '0'||cval else '' end) ACTIONTYPE,
        max(case when fldname = 'cusno' then cval else '' end) CIFID,
        max(case when fldname = 'cus_t' then LPAD(cval,3,'00') else '' end) IDTYPE,
        max(case when fldname = 'cus_snm_nm' then cval else '' end) NAME,
        max(case when fldname = 'cus_sht_nm' then cval else '' end) SHORTNAME,
        max(case when fldname = 'cus_engstc_nm' then cval else '' end) EN_NAME,
        max(case when fldname = 'lcl_cus_rlnm_no' then cval else '' end) IDNO,
        max(case when fldname = 'lcl_cus_rlnm_no_issu_org_nm' then cval else '' end) IDPLACE,
        max(case when fldname = 'lcl_cus_rlnm_no_iss_dt' then cval else '' end) IDDATE,
        max(case when fldname = 'cus_bth_y4mm_dt' then cval else '' end) ESTABLISHDATE,
        max(case when fldname = 'cus_natnlt_nat_c' then cval else '' end) NATIONAL,
        max(case when fldname = 'rprgt_nm' then cval else '' end) CEONAME,
        max(case when fldname = 'cus_cell_no' then cval else '' end) MOBILE,
        max(case when fldname = 'cus_faxno' then cval else '' end) FAX,
        max(case when fldname = 'cus_email' then cval else '' end) EMAIL,
        max(case when fldname = 'cus_adr_telno' then cval else '' end) PHONE,
        max(case when fldname = 'cus_adr1' then cval else '' end) ADDR1,
        max(case when fldname = 'cus_adr2' then cval else '' end) ADDR2,
        max(case when fldname = 'cus_adr3' then cval else '' end) ADDR3,'P', systimestamp,
        max(case when fldname = 'lcl_cus_rlnm_no_due_dt' then cval else '' end) EXPIREDATE
        from crbbankrequestdtl where reqid = v_reqid;
        UPDATE crbbankrequest SET isconfirmed='Y',cfstatus = 'C'  WHERE transactionnumber = p_transactionnumber;
        END;
    WHEN 'SGCB0957A001' THEN -- dien check blacklist
        begin
            v_backlist:='';
            --lay ra so tk ddmast de xu ly
            select reqtxnum,objname into v_reqtxnum,v_objname from crbtxreq where refval = v_trnref;
            --lay ra so lieu can cap nhat
            select case when cval =1 then 'BLACKLIST - ' else '' end bankbalance
            into  v_backlist
            from crbbankrequestdtl
            where reqid = v_reqid and fldname = 'bklt_yn' ;
            v_n01autoid:= 0;
            select count(*) into v_n01autoid from tllog where txnum = v_reqtxnum;
        if v_n01autoid > 0 then
            UPDATE crbbankrequest SET isconfirmed='Y',cfstatus = 'C'  WHERE transactionnumber = p_transactionnumber;
            UPDATE crbtxreq SET status=v_strstatus  WHERE refval = v_trnref;
            update tllog set txdesc=v_backlist||txdesc where txnum =v_reqtxnum;
        else
            return;
        end if;

        EXCEPTION when others THEN
            -- truong hop bi loi thi update crbtxreq --> hoan tat , update crbbankrequest --> xu ly loi tai cbplus
            UPDATE crbbankrequest SET isconfirmed='Y' ,cfstatus = 'E'  , ERRORDESC = 'Got error at CBPlus:'|| dbms_utility.format_error_backtrace WHERE transactionnumber = p_transactionnumber;
            UPDATE crbtxreq SET status='C'  WHERE refval = v_trnref;
        end;
    WHEN 'SGCI0954A001' THEN -- dien request thong tin khach hang
        begin
            v_n01autoid:= seq_cfmast_aither.nextval;
            select decode(count(*),0,'01','02') into v_action_type -- 01 them moi, 02 sua
            from cfmast cf, ( select  cval from crbbankrequestdtl where reqid = v_reqid and fldname = 'AFACCTNO') a
            where cf.cifid = a.cval  ;

            insert into cfmast_aither
            select v_n01autoid, v_reqid, v_action_type ACTIONTYPE,
                max(case when fldname = 'AFACCTNO' then cval else '' end) CIFID,
                max(case when fldname = 'cus_t' then LPAD(cval,3,'00') else '' end) IDTYPE,
                max(case when fldname = 'cus_snm_nm' then cval else '' end) NAME,
                max(case when fldname = 'cus_sht_nm' then cval else '' end) SHORTNAME,
                max(case when fldname = 'cus_engstc_nm' then cval else '' end) EN_NAME,
                max(case when fldname = 'lcl_cus_rlnm_no' then cval else '' end) IDNO,
                max(case when fldname = 'lcl_cus_rlnm_no_issu_org_nm' then cval else '' end) IDPLACE,
                max(case when fldname = 'lcl_cus_rlnm_no_iss_dt' then cval else '' end) IDDATE,
                max(case when fldname = 'cus_bth_y4mm_dt' then cval else '' end) ESTABLISHDATE,
                max(case when fldname = 'cus_natnlt_nat_c' then cval else '' end) NATIONAL,
                max(case when fldname = 'rprgt_nm' then cval else '' end) CEONAME,
                max(case when fldname = 'cus_cell_no' then cval else '' end) MOBILE,
                max(case when fldname = 'cus_faxno' then cval else '' end) FAX,
                max(case when fldname = 'cus_email' then cval else '' end) EMAIL,
                max(case when fldname = 'cus_adr_telno' then cval else '' end) PHONE,
                max(case when fldname = 'cus_adr1' then cval else '' end) ADDR1,
                max(case when fldname = 'cus_adr2' then cval else '' end) ADDR2,
                max(case when fldname = 'cus_adr3' then cval else '' end) ADDR3,'P', systimestamp,
                max(case when fldname = 'lcl_cus_rlnm_no_due_dt' then cval else '' end) EXPIREDATE
            from crbbankrequestdtl where reqid = v_reqid;

            UPDATE crbbankrequest SET isconfirmed='Y',cfstatus = 'C'  WHERE transactionnumber = p_transactionnumber;


            UPDATE crbbankrequest SET isconfirmed='Y',cfstatus = 'C'  WHERE transactionnumber = p_transactionnumber;
            UPDATE crbtxreq SET status=v_strstatus  WHERE refval = v_trnref;
        EXCEPTION when others THEN
            -- truong hop bi loi thi update crbtxreq --> hoan tat , update crbbankrequest --> xu ly loi tai cbplus
            UPDATE crbbankrequest SET isconfirmed='Y' ,cfstatus = 'E'  , ERRORDESC = 'Got error at CBPlus:'|| dbms_utility.format_error_backtrace WHERE transactionnumber = p_transactionnumber;
            UPDATE crbtxreq SET status='C'  WHERE refval = v_trnref;
        end;
    WHEN 'N02' THEN  --dien tra ket qua book phi
          begin

                --lay ra so tk ddmast de xu ly
                SELECT REQTXNUM,OBJNAME INTO V_REQTXNUM,V_OBJNAME FROM CRBTXREQ WHERE REFVAL = V_TRNREF;

                UPDATE CRBBANKREQUEST SET ISCONFIRMED='Y',CFSTATUS = 'C'  WHERE TRANSACTIONNUMBER = P_TRANSACTIONNUMBER;
                UPDATE CRBTXREQ SET STATUS = V_STRSTATUS  WHERE REFVAL = V_TRNREF;

                UPDATE FEE_BOOKING_RESULT
                SET SPRACNO = V_DESBANKACCOUNT,
                PSTATUS = STATUS,
                STATUS = (CASE WHEN INSTR(BANKGLOBALID, 'FA.') > 0 THEN V_STRSTATUS ELSE DECODE(V_STRSTATUS, 'R', 'P', 'C') END),
                BANKREFID = P_TRANSACTIONNUMBER
                WHERE AUTOID = V_REQTXNUM AND STATUS NOT IN ('X');

          EXCEPTION when others THEN
             -- truong hop bi loi thi update crbtxreq --> hoan tat , update crbbankrequest --> xu ly loi tai cbplus
              UPDATE crbbankrequest SET isconfirmed='Y' ,cfstatus = 'E'  , ERRORDESC = 'Got error at CBPlus:'|| dbms_utility.format_error_backtrace WHERE transactionnumber = p_transactionnumber;
              UPDATE crbtxreq SET status='C'  WHERE refval = v_trnref;
          end;
    WHEN 'N03' THEN  --FEE/TAX Cancel
          begin

                --status : P:pending N: new C: complete R: reject E: error S: settle X: cancel booking U: cancel settle
                -- dieu kien  chi vao  1 trong 2 bang
                update fee_booking_result set pstatus =status, status= 'X',lastchange =SYSTIMESTAMP where substr(bankrefid,0,31) = substr(v_repval,0,31);
                update fee_booking_resulthist set pstatus =status, status= 'X',lastchange =SYSTIMESTAMP where substr(bankrefid,0,31) = substr(v_repval,0,31);

                update tax_booking_result set pstatus =status, status= 'X',lastchange =SYSTIMESTAMP where substr(bankrefid,0,31) = substr(v_repval,0,31);
                UPDATE crbbankrequest SET isconfirmed='Y' ,cfstatus = 'C' WHERE transactionnumber = p_transactionnumber;

          EXCEPTION when others THEN
             -- truong hop bi loi thi update crbtxreq --> hoan tat , update crbbankrequest --> xu ly loi tai cbplus
              UPDATE crbbankrequest SET isconfirmed='Y' ,cfstatus = 'E'  , ERRORDESC = 'Got error at CBPlus:'|| dbms_utility.format_error_backtrace WHERE transactionnumber = p_transactionnumber;

          end;
    WHEN 'N04' THEN  --FEE/TAX settle
        begin

            --status : P:pending N: new C: complete R: reject E: error S: settle X: cancel booking U: cancel settle
            -- dieu kien  chi vao  1 trong 2 bang
            UPDATE FEE_BOOKING_RESULT SET SETTLEDATE = GETCURRDATE, PSTATUS = STATUS, --SPRACNO = V_DESBANKACCOUNT,
            STATUS = 'S',LASTCHANGE = SYSTIMESTAMP
            WHERE SUBSTR(BANKREFID,0,31) = SUBSTR(V_REPVAL,0,31);

            UPDATE FEE_BOOKING_RESULTHIST SET SETTLEDATE = GETCURRDATE, PSTATUS = STATUS, --SPRACNO = V_DESBANKACCOUNT,
            STATUS = 'S',LASTCHANGE =SYSTIMESTAMP
            WHERE SUBSTR(BANKREFID,0,31) = SUBSTR(V_REPVAL,0,31);

            UPDATE TAX_BOOKING_RESULT SET PSTATUS = STATUS, --SPRACNO = V_DESBANKACCOUNT,
            STATUS = 'S', LASTCHANGE = SYSTIMESTAMP WHERE SUBSTR(BANKREFID,0,31) = SUBSTR(V_REPVAL,0,31);
            UPDATE TAX_BOOKING_RESULT SET PSTATUS = STATUS, --SPRACNO = V_DESBANKACCOUNT,
            STATUS = 'S', LASTCHANGE = SYSTIMESTAMP WHERE SUBSTR(BANKREFID,0,31) = SUBSTR(V_REPVAL,0,31);

            UPDATE CRBBANKREQUEST SET ISCONFIRMED = 'Y', CFSTATUS = 'C'  WHERE TRANSACTIONNUMBER = P_TRANSACTIONNUMBER;

        EXCEPTION when others THEN
            -- truong hop bi loi thi update crbtxreq --> hoan tat , update crbbankrequest --> xu ly loi tai cbplus
            UPDATE crbbankrequest SET isconfirmed='Y' ,cfstatus = 'E'  , ERRORDESC = 'Got error at CBPlus:'|| dbms_utility.format_error_backtrace WHERE transactionnumber = p_transactionnumber;
        END;
    WHEN 'N05' THEN  --FEE/TAX cancel settle
        begin

            --status : P:pending N: new C: complete R: reject E: error S: settle X: cancel booking U: cancel settle
            -- dieu kien  chi vao  1 trong 2 bang
            update fee_booking_result set pstatus =status, status= 'C',lastchange =SYSTIMESTAMP where substr(bankrefid,0,31) = substr(v_repval,0,31);
            update fee_booking_resulthist set pstatus =status, status= 'C',lastchange =SYSTIMESTAMP where substr(bankrefid,0,31) = substr(v_repval,0,31);
            update tax_booking_result set pstatus =status, status= 'C',lastchange =SYSTIMESTAMP where substr(bankrefid,0,31) = substr(v_repval,0,31);
            UPDATE crbbankrequest SET isconfirmed='Y',cfstatus = 'C'  WHERE transactionnumber = p_transactionnumber;

        EXCEPTION when others THEN
            -- truong hop bi loi thi update crbtxreq --> hoan tat , update crbbankrequest --> xu ly loi tai cbplus
            UPDATE crbbankrequest SET isconfirmed='Y' ,cfstatus = 'E'  , ERRORDESC = 'Got error at CBPlus:'|| dbms_utility.format_error_backtrace WHERE transactionnumber = p_transactionnumber;

        end;

 /* WHEN 'N10' THEN  --dien tra ket qua FX
          begin

                UPDATE crbbankrequest SET isconfirmed='Y',cfstatus = 'C'  WHERE transactionnumber = p_transactionnumber;
                UPDATE crbtxreq SET status=v_strstatus  WHERE refval = v_trnref;
          EXCEPTION when others THEN
             -- truong hop bi loi thi update crbtxreq --> hoan tat , update crbbankrequest --> xu ly loi tai cbplus
              UPDATE crbbankrequest SET isconfirmed='Y',cfstatus = 'E'   , ERRORDESC = 'Got error at CBPlus:'|| dbms_utility.format_error_backtrace WHERE transactionnumber = p_transactionnumber;
              UPDATE crbtxreq SET status='C'  WHERE refval = v_trnref;
          end;*/
    WHEN 'N09' THEN  --dien tra thong tin ti gia moi
        begin
            v_timestamp := SYSTIMESTAMP;
            FOR rate IN (
                select max(case when fldname = 'trx_ccy_c' then cval else '' end) CCYCD,
                    max(case when fldname = 'trx_exrt_c' then cval else '' end) RTYPE,
                    max(case when fldname = 'trx_exrt' then cval else '' end) VND,
                    max(case when fldname = 'trx_d' then cval else '' end) trx_d,
                    decode(max(case when fldname = 'trx_d' then cval else '' end),'18','SBV','SHV')  ITYPE
                    -- 'SHV' ITYPE
                from crbbankrequestdtl
                where reqid = v_reqid and fldcd <> 'NULL'
                group by fldcd
            )
            loop
                IF(trim(rate.trx_d) <> '15') THEN
                    SELECT COUNT (*)
                    INTO v_checkexist
                    FROM exchangerate
                    WHERE currency = rate.CCYCD
                    AND rtype = rate.RTYPE
                    AND itype = rate.ITYPE;

                    IF(v_checkexist > 0) THEN
                        INSERT INTO exchangerate_hist (autoid, tradedate, lastchange, currency, vnd, note, rtype, itype)
                        SELECT autoid, tradedate, lastchange, currency, vnd, note, rtype, itype
                        FROM exchangerate
                        WHERE currency = rate.CCYCD
                        AND rtype = rate.RTYPE
                        AND itype = rate.ITYPE;

                        DELETE FROM exchangerate
                        WHERE currency = rate.CCYCD
                        AND rtype = rate.RTYPE
                        AND itype = rate.ITYPE;
                    end if;
                    --- insert record moi
                    INSERT INTO exchangerate (autoid, tradedate, lastchange, currency, vnd, note, rtype, itype)
                    VALUES (seq_exchangerate.NEXTVAL, getcurrdate, v_timestamp, rate.CCYCD, TO_NUMBER (rate.VND), 'Update exchange rate from API N09 '||rate.ITYPE, rate.RTYPE, rate.ITYPE);
                END IF;
            end loop;
            UPDATE crbbankrequest SET isconfirmed='Y',cfstatus = 'C'  WHERE transactionnumber = p_transactionnumber;
        EXCEPTION when others THEN
            -- truong hop bi loi thi update crbtxreq --> hoan tat , update crbbankrequest --> xu ly loi tai cbplus
            UPDATE crbbankrequest SET isconfirmed='Y' ,cfstatus = 'C'  , ERRORDESC = 'Got error at CBPlus:'|| dbms_utility.format_error_backtrace WHERE transactionnumber = p_transactionnumber;
        end;
    WHEN 'N08' THEN  --dien tra thong tin ti gia xin de lam fx quote
        begin
            v_timestamp := SYSTIMESTAMP;
            FOR rate IN (
                select max(case when fldname = 'buy_ccy_c' then cval else '' end) CCYCD,
                    max(case when fldname = 'sel_ccy_c' then cval else '' end) CCYCD1,
                    max(case when fldname = 'trx_exrt' then nval else 0 end) VND,
                    max(case when fldname = 'hq_spec_rt_aprv_no' then cval else '' end) refcode,
                    'QUO' RTYPE,
                    'SHV'  ITYPE
                from crbbankrequestdtl
                where reqid = v_reqid
                group by fldcd
            )
            loop
                SELECT COUNT (*)
                INTO v_checkexist
                FROM exchangerate
                WHERE currency = decode(rate.CCYCD,'VND',rate.CCYCD1,rate.CCYCD)
                AND rtype = rate.RTYPE
                AND itype = rate.ITYPE;
                IF(v_checkexist > 0) THEN
                    -- day du lieu ve bang hist
                    INSERT INTO exchangerate_hist (autoid, tradedate, lastchange, currency, vnd, note, rtype, itype)
                    SELECT autoid, tradedate, lastchange, currency, vnd, note, rtype, itype
                    FROM exchangerate
                    WHERE currency = decode(rate.CCYCD,'VND',rate.CCYCD1,rate.CCYCD)
                    AND rtype = rate.RTYPE
                    AND itype = rate.ITYPE;

                    DELETE FROM exchangerate
                    WHERE currency = decode(rate.CCYCD,'VND',rate.CCYCD1,rate.CCYCD)
                    AND rtype = rate.RTYPE
                    AND itype = rate.ITYPE;
                end if;
                --- insert record moi
                INSERT INTO exchangerate (autoid, tradedate, lastchange, currency, vnd, note, rtype, itype)
                VALUES (seq_exchangerate.NEXTVAL, getcurrdate, v_timestamp, decode(rate.CCYCD,'VND',rate.CCYCD1,rate.CCYCD), TO_NUMBER (rate.VND), rate.refcode, rate.RTYPE, rate.ITYPE);
            end loop;
            UPDATE crbbankrequest SET isconfirmed='Y',cfstatus = 'C'  WHERE transactionnumber = p_transactionnumber;
        EXCEPTION when others THEN
            -- truong hop bi loi thi update crbtxreq --> hoan tat , update crbbankrequest --> xu ly loi tai cbplus
            UPDATE crbbankrequest SET isconfirmed='Y' ,cfstatus = 'C'  , ERRORDESC = 'Got error at CBPlus:'|| dbms_utility.format_error_backtrace WHERE transactionnumber = p_transactionnumber;
        end;
    WHEN 'N14' THEN
        BEGIN
            SELECT DT.OBJNAME, DT.OBJKEY, DT.TXDATE, DT.REFTXNUM, DT.REFTXDATE
            INTO V_OBJNAME, V_OBJKEY, V_TXDATE, V_REFTXNUM, V_REFTXDATE
            FROM (
                SELECT * FROM CRBTXREQ WHERE TRFCODE IN ('SETTLEFEE', 'CANCELSETTLEFEE')
                UNION ALL
                SELECT * FROM CRBTXREQHIST WHERE TRFCODE IN ('SETTLEFEE', 'CANCELSETTLEFEE')
            ) DT
            WHERE DT.REFVAL = V_TRNREF;

            IF V_STRSTATUS = 'C' THEN
                IF V_OBJNAME = '1207' THEN
                    FOR REC1207 IN (
                        SELECT
                            MAX(CASE WHEN FLDNAME = 'TRX_HIS_GLB_ID' THEN CVAL ELSE '' END) GLOBALID,
                            MAX(CASE WHEN FLDNAME = 'GISAN_DT' THEN CVAL ELSE '' END) TRN_DT,
                            MAX(CASE WHEN FLDNAME = 'DESBANKACCOUNT' THEN CVAL ELSE '' END) DESBANKACCOUNT,
                            MAX(CASE WHEN FLDNAME = 'CURRENCY' THEN CVAL ELSE '' END) CCYCD,
                            MAX(CASE WHEN FLDNAME = 'EXCHANGETYPE' THEN CVAL ELSE '' END) EXCHANGETYPE,
                            MAX(CASE WHEN FLDNAME = 'EXCHANGERATE' THEN CVAL ELSE '0' END) EXCHANGERATE,
                            MAX(CASE WHEN FLDNAME = 'TXAMT' THEN CVAL ELSE '0' END) AITHERTXAMT
                        FROM CRBBANKREQUESTDTL
                        WHERE REQID = V_REQID
                    ) LOOP
                        UPDATE SETTLE_FEE_LOG
                        SET GLOBALID = REC1207.GLOBALID, TRN_DT = REC1207.TRN_DT, STATUS = 'C',
                            CCYCD = REC1207.CCYCD, EXCHANGETYPE = REC1207.EXCHANGETYPE, EXCHANGERATE = TO_NUMBER(REC1207.EXCHANGERATE), AITHERTXAMT = TO_NUMBER(REC1207.AITHERTXAMT)
                        WHERE TXNUM = V_OBJKEY
                        AND TXDATE = V_TXDATE;

                        --case settle CB, sinh 6642 auto
                        FOR REC_FEE IN (
                            SELECT LOG.FEEBOOKINGAUOID AUTOID
                            FROM SETTLE_FEE_LOG LOG
                            WHERE LOG.TXNUM = V_OBJKEY
                            AND LOG.TXDATE = V_TXDATE
                        ) LOOP
                            PRC_AUTO_6642(REC_FEE.AUTOID, V_TRNREF, P_ERR_CODE);
                        END LOOP;
                    END LOOP;
                ELSIF V_OBJNAME = '1208' THEN
                    UPDATE SETTLE_FEE_LOG SET STATUS = 'D'
                    WHERE TXNUM = V_REFTXNUM
                    AND TXDATE = V_REFTXDATE;

                    --case cancel settle CB, sinh 6645 auto
                    FOR REC_FEE IN (
                        SELECT LOG.FEEBOOKINGAUOID AUTOID
                        FROM SETTLE_FEE_LOG LOG
                        WHERE LOG.TXNUM = V_REFTXNUM
                        AND LOG.TXDATE = V_REFTXDATE
                    ) LOOP
                        PRC_AUTO_6645(REC_FEE.AUTOID, V_TRNREF, P_ERR_CODE);
                    END LOOP;

                    DELETE FROM SETTLE_FEE_LOG WHERE TXNUM = V_REFTXNUM AND TXDATE = V_REFTXDATE;
                END IF;
            ELSE
                IF V_OBJNAME = '1207' THEN
                    DELETE FROM SETTLE_FEE_LOG WHERE TXNUM = V_OBJKEY AND TXDATE = V_TXDATE;
                ELSIF V_OBJNAME = '1208' THEN
                    UPDATE SETTLE_FEE_LOG
                    SET STATUS = 'C'
                    WHERE TXNUM = V_REFTXNUM
                    AND TXDATE = V_REFTXDATE;
                END IF;
            END IF;


            UPDATE CRBTXREQ SET PSTATUS = STATUS, STATUS = V_STRSTATUS  WHERE REFVAL = V_TRNREF;
            UPDATE CRBBANKREQUEST SET ISCONFIRMED = 'Y', CFSTATUS = 'C' WHERE TRANSACTIONNUMBER = P_TRANSACTIONNUMBER;

        EXCEPTION when others THEN
            -- truong hop bi loi thi update crbtxreq --> hoan tat , update crbbankrequest --> xu ly loi tai cbplus
            UPDATE crbbankrequest SET isconfirmed='Y' ,cfstatus = 'C'  , ERRORDESC = 'Got error at CBPlus:'|| dbms_utility.format_error_backtrace WHERE transactionnumber = p_transactionnumber;
        END;
    WHEN 'SGCB0955I001' THEN
        BEGIN
            FOR REC2 IN (
                SELECT * FROM CRBTXREQ WHERE REFVAL = V_TRNREF2
            )
            LOOP
                BEGIN
                    SELECT NVL(CVAL, '000') INTO V_STATUS2 FROM CRBBANKREQUESTDTL WHERE REQID = V_REQID AND FLDNAME = 'ERRCODE';
                EXCEPTION WHEN OTHERS THEN
                    V_STATUS2 := '000';
                END;
                FOR REC3 IN (
                    SELECT * FROM SYN_AITHER_REQ WHERE AUTOID = REC2.OBJKEY
                )
                LOOP
                    IF REC3.TYPEREQ = 'NAVINFO' THEN
                        UPDATE NAV_INFO
                        SET REQSTATUS = DECODE(V_STATUS2, '000', 'C', 'R')
                        WHERE AUTOID = REC3.OBJECTKEY;
                    ELSIF REC3.TYPEREQ = 'MARKETINFO' THEN
                        UPDATE MARKET_INFO
                        SET REQSTATUS = DECODE(V_STATUS2, '000', 'C', 'R')
                        WHERE AUTOID = REC3.OBJECTKEY;
                    ELSIF REC3.TYPEREQ = 'INDEXINFO' THEN
                        UPDATE INDEX_INFO
                        SET REQSTATUS = DECODE(V_STATUS2, '000', 'C', 'R')
                        WHERE AUTOID = REC3.OBJECTKEY;
                    END IF;

                    UPDATE SYN_AITHER_REQ
                    SET STATUS = DECODE(V_STATUS2, '000', 'C', 'R')
                    WHERE AUTOID = REC3.AUTOID;
                END LOOP;
                UPDATE CRBTXREQ SET PSTATUS = STATUS, STATUS = DECODE(V_STATUS2, '000', 'C', 'R')  WHERE REQID = REC2.REQID;
            END LOOP;
            UPDATE CRBBANKREQUEST SET ISCONFIRMED = 'Y', CFSTATUS = 'C' WHERE TRANSACTIONNUMBER = P_TRANSACTIONNUMBER;
        END;
    ELSE --truong hop mac dinh neu la goi giao dich hoan tat co cau truc giong voi giao dich yeu cau
    begin
        SELECT varvalue
        INTO v_strCURRDATE
        FROM sysvar
        WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

        --- case de hien thi len man hinh chinh cac giao dich nay
        if (v_tltxcd= '6702' or v_tltxcd= '6701' or v_tltxcd= '6703' or v_tltxcd= '6704' or v_tltxcd= '6604' or v_tltxcd= '6603') then
            SELECT '50' || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
            INTO L_txnum
            FROM DUAL;
        else
            SELECT systemnums.C_BATCH_PREFIXED || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
            INTO L_txnum
            FROM DUAL;
        end if;

        if v_msgtype ='RP' then
            select objkey,txdate into v_reftxnum, v_txdate
            from crbtxreq where refval = v_trnref;

            ---------case dac biet cho revert unhold
            if (v_tltxcd= '6699') then
                if(to_char(v_txdate,'DD/MM/RRRR') = v_strCURRDATE) then
                    select cvalue into v_holdtxnum   ---txnum cua hold request
                    from tllogfld
                    where fldcd = '91' and txnum  =v_reftxnum;
                else
                    select cvalue into v_holdtxnum   ---txnum cua hold request
                    from tllogfldall
                    where fldcd = '91' and txnum  =v_reftxnum and to_char(txdate,'DD/MM/RRRR')=to_char(v_txdate,'DD/MM/RRRR');
                end if;
                UPDATE crbtxreq SET unhold = 'N' --> bi tu choi thi se chuyen lai unhold ='N' de co the unhold lai
                WHERE objkey = v_holdtxnum;
            end if;
        end if;

        if (v_tltxcd = '6642' or v_tltxcd = '6645' ) then
            v_strBUSDATE:=v_strBUSDATE;
        else
            v_strBUSDATE:=v_strCURRDATE;
        end if;

        select  to_char(SYSdate,'hh24:mi:ss')  into v_txtime from dual;
        p_sqlcommand:='
          declare
                 pkgctx   plog.log_ctx;
                l_txmsg       tx.msg_rectype;
                l_err_param varchar2(300);
                p_err_code  VARCHAR2(300);
                V_REFCURSOR   PKG_REPORT.REF_CURSOR;
                l_i number;
                l_tltxfld_arrtype pck_bankflms.tltxfld_arrtype;
                l_tltxfld_rectype pck_bankflms.tltxfld_rectype;
           begin
                l_txmsg.msgtype:=''T'';
                l_txmsg.local:=''N'';
                l_txmsg.tlid        := ''0001'';
                SELECT SYS_CONTEXT (''USERENV'', ''HOST''),
                         SYS_CONTEXT (''USERENV'', ''IP_ADDRESS'', 15)
                  INTO l_txmsg.wsname, l_txmsg.ipaddress
                FROM DUAL;
                SELECT BRID  INTO l_txmsg.brid FROM TLPROFILES where TLID=l_txmsg.tlid;
                l_txmsg.off_line    := ''N'';  l_txmsg.deltd       := txnums.c_deltd_txnormal;
                l_txmsg.txstatus    := txstatusnums.c_txcompleted; l_txmsg.msgsts      := ''0''; l_txmsg.ovrsts      := ''0''; l_txmsg.batchname   := ''DAY'';
                l_txmsg.txnum    := '''||L_txnum||''';
                l_txmsg.txtime    := '''||v_txtime||''';
                l_txmsg.reftxnum    := '''||v_reftxnum||''';
                l_txmsg.txdate:=to_date('''||v_strCURRDATE||''',systemnums.c_date_format);
                l_txmsg.BUSDATE:=to_date('''||v_strBUSDATE||''',systemnums.c_date_format);
                l_txmsg.tltxcd:='''||v_tltxcd||'''; ';
        if v_msgtype ='RP' and v_bankobj not in ( 'N06','N10') then
            --> co giao dich request thi se sinh giao dich dua tren thong tin giao dich request
            --  
            --if(to_char(v_txdate,'DD/MM/RRRR') = to_char(v_strCURRDATE,'DD/MM/RRRR')) then
            if(to_date(v_txdate,'DD/MM/YYYY') = to_date(v_strCURRDATE,'DD/MM/YYYY')) then
                v_table:='vw_tllogfld_all';
            else
                v_table:='vw_tllogfld_all';
            end if;

            p_sqlcommand:=p_sqlcommand||' FOR rec IN
                (
                    select d.fldname,d.defname , d.datatype,nvl(CVALUE,NVALUE) VALUE
                    from (select * from '||v_table||' where to_char(txdate,''DD/MM/RRRR'') = '''|| to_char(v_txdate,'DD/MM/RRRR') ||'''  and txnum='''||v_reftxnum||''') f, (select * from fldmaster where objname ='''||v_tltxcd||''') d
                    where f.fldcd = d.fldname
                )
                LOOP
                              l_txmsg.txfields (rec.fldname).defname := rec.defname;
                              l_txmsg.txfields (rec.fldname).TYPE := rec.datatype;
                              l_txmsg.txfields (rec.fldname).value :=  rec.value;
                END LOOP;';
        else  --- case cho truong hop la dien y/c tang giam xuat phat tu bank, ko co dien yc tu cbplus
        ---viet 1 view de lay cac truong can thiet tu crbbankrequestdtl -->map voi fldcd cua giao dich
            p_sqlcommand:=p_sqlcommand||' l_tltxfld_arrtype := pck_bankflms.buildtltxdata('||v_reqid||');
                    l_tltxfld_rectype:= l_tltxfld_arrtype (0) ;
                    l_i := 0;
                LOOP
                    l_tltxfld_rectype:= l_tltxfld_arrtype (l_i) ;
                    l_txmsg.txfields (l_tltxfld_rectype.fldname).defname   := l_tltxfld_rectype.defname;
                    l_txmsg.txfields (l_tltxfld_rectype.fldname).TYPE      := l_tltxfld_rectype.datatype;
                    l_txmsg.txfields (l_tltxfld_rectype.fldname).value      :=  l_tltxfld_rectype.value;
                    l_i := l_i + 1;
                    EXIT WHEN l_i > l_tltxfld_arrtype.count-1;
                END LOOP;' ;
        end if;
        p_sqlcommand:=p_sqlcommand|| ' IF txpks_#'||v_tltxcd||'.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <> systemnums.c_success THEN
                    select en_errdesc  into l_err_param
                    from deferror where errnum = p_err_code;
                    UPDATE crbbankrequest SET isconfirmed=''Y'',cfstatus=''E'',  ERRORDESC = l_err_param WHERE transactionnumber = '''||p_transactionnumber||''';
                    UPDATE crbtxreq SET status=''E'', ERRORDESC= ''CBPlus: process confirm error:''||p_err_code   WHERE refval = '''||v_trnref||''';
                ELSE
                   UPDATE crbbankrequest SET isconfirmed=''Y'',cfstatus=''C'',reftxnum= '''||L_txnum||'''  WHERE transactionnumber = '''||p_transactionnumber||''';
                   UPDATE crbtxreq SET status='''||v_strstatus||'''  WHERE refval = '''||v_trnref||''';
                END IF;
            END;';

        --
        EXECUTE IMMEDIATE p_sqlcommand;
    EXCEPTION when others THEN
        plog.error (pkgctx, SQLERRM ||  dbms_utility.format_error_backtrace);
        -- truong hop bi loi thi update crbtxreq --> hoan tat , update crbbankrequest --> xu ly loi tai cbplus
        UPDATE crbbankrequest SET isconfirmed='Y' ,cfstatus = 'E'  , ERRORDESC = 'Got error at CBPlus:'|| p_transactionnumber WHERE transactionnumber = p_transactionnumber;
        UPDATE crbtxreq SET status='E', ERRORDESC= 'CBPlus: process confirm error '  WHERE refval = v_trnref;
    end;
    end case;

    plog.setendsection(pkgctx, 'Transact_exec');

    p_err_code:=0;
    commit;
EXCEPTION when others THEN
    p_err_code := errnums.C_SYSTEM_ERROR;
    plog.error (pkgctx,'Trace: ' || SQLERRM || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'Transact_exec');
    ROLLBACK;
END;
-- Enter further code below as specified in the Package spec.


procedure sp_auto_gen_confirm_transact as
    p_err_code  VARCHAR2(50);
    l_count number;
    cursor v_cursor is
    select autoid, transactionnumber from crbbankrequest where isconfirmed = 'N' ORDER BY autoid;
    v_row v_cursor%rowtype;
begin
    plog.setbeginsection(pkgctx, 'sp_auto_gen_confirm_transact');

    SELECT count(*) INTO l_count
    FROM SYSVAR
    WHERE GRNAME='SYSTEM' AND VARNAME='HOSTATUS'  AND VARVALUE= systemnums.C_OPERATION_ACTIVE;
    IF l_count = 0 THEN
        p_err_code := errnums.C_HOST_OPERATION_ISINACTIVE;
        plog.setendsection (pkgctx, 'fn_txProcess');
        RETURN ;
    END IF;


    open v_cursor;
    loop
    fetch v_cursor
    into v_row;
    exit when v_cursor%notfound;
        if (v_row.transactionnumber is null or v_row.transactionnumber='') then
            update crbbankrequest set isconfirmed = 'Y',cfstatus = 'C' where autoid =v_row.autoid;
        else
            transact_Exec(v_row.transactionnumber, v_row.autoid, p_err_code);
        end if;
    end loop;


    plog.setendsection(pkgctx, 'sp_auto_gen_confirm_transact');

  exception
    when others then
      plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'sp_auto_gen_confirm_transact');
  end sp_auto_gen_confirm_transact;


 procedure sp_auto_gen_SCOA as
    p_err_code  VARCHAR2(50);
    cursor v_cursor is --trung.luu 11-03-2021 SHBVNEX-2074 di qua bank theo tai khoan me neu co
                    --TRUNG.LUU: 17-03-2021 SHBVNEX-2158 thay doi di theo master cifid
      select gl.txdate,gl.bankreqid,gl.custodycd,gl.mcifid CIFID,gl.amount,gl.debitacct,gl.creditacct,gl.ccycd,gl.note,gl.busdate from gl_exp_results gl
            where gl.status = 'N'   ;
    v_row v_cursor%rowtype;
  begin

  --bankreqid = to_char(txdate,'DDMMRRRR')||LPAD (seq_BATCHTXNUM.NEXTVAL, 10, '0')
    plog.setbeginsection(pkgctx, 'sp_auto_gen_SCOA');

    open v_cursor;
    loop
      fetch v_cursor
        into v_row;
      exit when v_cursor%notfound;

       INSERT INTO crbtxreq (reqid,
                      objtype,
                      objname,
                      trfcode,
                      reqcode,
                      reqtxnum,
                      objkey,
                      txdate,
                      affectdate,
                      bankcode,
                      bankacct,
                      afacctno,
                      txamt,
                      status,
                      reftxnum,
                      reftxdate,
                      refval,
                      notes,
                      RBANKACCOUNT, --recieve bank account
                      RBANKCITAD, --recieve bankname
                      CURRENCY,RBANKNAME)
  VALUES   (seq_crbtxreq.NEXTVAL,
            'T',
            'SCOA',
            'SCOA',
            'SCOA',
            v_row.bankreqid,
            null,
            TO_DATE (v_row.txdate, systemnums.c_date_format),
            TO_DATE (v_row.txdate, systemnums.c_date_format),
            'SHV',
            v_row.creditacct,
            v_row.cifid,
            v_row.amount,
            'P',
            NULL,
            NULL,
            NULL,
            v_row.note,
            v_row.debitacct,
            NULL,
            v_row.ccycd,to_char(v_row.busdate,'RRRRMMDD'));

        --A: cho ngan hang
        update gl_exp_results set status = 'A' where bankreqid = v_row.bankreqid;

    end loop;
commit;

    plog.setendsection(pkgctx, 'sp_auto_gen_SCOA');
  exception
    when others then
      plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'sp_auto_gen_SCOA');
  end sp_auto_gen_SCOA;

procedure sp_auto_gen_fee_invoice(p_autoid VARCHAR2) as
    p_err_code  VARCHAR2(50);
    v_autoid VARCHAR2(100);
    v_currdate date;
    v_remark varchar(500);
    cursor v_cursor(v_autoid VARCHAR2) is
      select * from fee_booking_result where status = 'N' and to_char(autoid) like v_autoid ;
        v_row v_cursor%rowtype;

  begin
    dbms_output.put_line('v_autoid:' || v_autoid);
    If upper(p_autoid)='ALL' or p_autoid is null then
        v_autoid := '%';
    Else
        v_autoid := p_autoid;
    End If;
    dbms_output.put_line('v_autoid:' || v_autoid);
  --bankreqid = to_char(txdate,'DDMMRRRR')||LPAD (seq_BATCHTXNUM.NEXTVAL, 10, '0')
    plog.setbeginsection(pkgctx, 'sp_auto_gen_fee_invoice');

    v_currdate := getcurrdate;

    open v_cursor(v_autoid);
    loop
      fetch v_cursor
        into v_row;
      exit when v_cursor%notfound;

       dbms_output.put_line('v_row.autoid0:' || v_row.autoid);

        v_remark := '<Einvoice> ' || SUBSTR(REPLACE(v_row.remark, '<Einvoice> ', ''),1,88);

       INSERT INTO crbtxreq (reqid, objtype, objname, trfcode, reqcode, objkey,
       txdate, bankcode, bankacct, afacctno, txamt, notes,
       status, reftxnum, reftxdate, affectdate, createdate, via,
       rbankaccount, unhold, currency, reqtxnum, dorc, feeamt,
       taxamt, feecode, feetype, feename, branch)
       VALUES  (seq_crbtxreq.NEXTVAL, 'T', 'FEEINVOICE', 'FEEINVOICE', 'FEEINVOICE', v_row.autoid,
       v_currdate, 'SHV', v_row.bankaccount, nvl(v_row.mcifid,v_row.cifid) /*trung.luu:SHBVNEX-2067 19-02-2021 lay cifid tai khoan me, neu khong co thi thoi */, v_row.feeamount, v_remark,
       'P', v_row.autoid, to_date(v_row.txdate,'DD/MM/RRRR'), to_date(v_row.txdate,'DD/MM/RRRR'), sysdate, 'CBP',
       v_row.nostroaccount, 'N', v_row.currency, v_row.autoid, '', v_row.feeamount,
       v_row.taxamount, v_row.feecode, v_row.settletype, v_row.feename, v_row.branch);

        --A: cho ngan hang
        dbms_output.put_line('v_row.autoid1:' || v_row.autoid);

        update fee_booking_result set status = 'A',
        transdate = v_currdate,
        settledate = NULL
        where autoid = v_row.autoid
        and status NOT IN ('X');

        dbms_output.put_line('v_row.autoid2:' || v_row.autoid);
    end loop;

    --commit;

    plog.setendsection(pkgctx, 'sp_auto_gen_fee_invoice');
  exception
    when others then
      plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'sp_auto_gen_fee_invoice');
--      raise errnums.C_SYSTEM_ERROR;
  end sp_auto_gen_fee_invoice;

procedure sp_auto_gen_tax_invoice as
    p_err_code  VARCHAR2(50);
    cursor v_cursor is
      select * from tax_booking_result where status = 'N'  ;
    v_row v_cursor%rowtype;
  begin

  --bankreqid = to_char(txdate,'DDMMRRRR')||LPAD (seq_BATCHTXNUM.NEXTVAL, 10, '0')
    plog.setbeginsection(pkgctx, 'sp_auto_gen_tax_invoice');

    open v_cursor;
    loop
      fetch v_cursor
        into v_row;
      exit when v_cursor%notfound;

      INSERT INTO crbtxreq (reqid, objtype, objname, trfcode, reqcode, objkey,
       txdate, bankcode, bankacct, afacctno, txamt, notes,
       status, reftxnum, reftxdate, affectdate,
       createdate, via, rbankaccount,unhold,currency, reqtxnum, dorc,
       feeamt, taxamt, feecode, feetype)
       VALUES   (seq_crbtxreq.NEXTVAL,'T','TAXINVOICE','TAXINVOICE','TAXINVOICE',v_row.autoid,
       TO_DATE (v_row.transdate, systemnums.c_date_format),'SHV',v_row.bankaccount,v_row.cifid,v_row.vatamount,v_row.remark,
       'P',v_row.autoid,TO_DATE (v_row.transdate, systemnums.c_date_format),TO_DATE (v_row.paymentdate, systemnums.c_date_format),
        sysdate,'CBP',v_row.nostroaccount,'N',v_row.currency,v_row.autoid,'',0,v_row.vatamount,'',v_row.settletype);

        --A: cho ngan hang
        update tax_booking_result set status = 'A' where autoid = v_row.autoid;
    end loop;

--commit;
    plog.setendsection(pkgctx, 'sp_auto_gen_tax_invoice');
  exception
    when others then
      plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'sp_auto_gen_tax_invoice');
  end sp_auto_gen_tax_invoice;

procedure sp_auto_gen_fee_broker as
    p_err_code  VARCHAR2(50);
    cursor v_cursor is
      select * from fee_broker_result where status = 'N' and refcode = 'FEEBROKER' ;
    v_row v_cursor%rowtype;
  begin

  --bankreqid = to_char(txdate,'DDMMRRRR')||LPAD (seq_BATCHTXNUM.NEXTVAL, 10, '0')
    plog.setbeginsection(pkgctx, 'sp_auto_gen_fee_broker');

    open v_cursor;
    loop
      fetch v_cursor
        into v_row;
      exit when v_cursor%notfound;

       INSERT INTO crbtxreq (reqid, objtype, objname, trfcode, reqcode, objkey,
       txdate, bankcode, bankacct, afacctno, txamt, notes,
       status, reftxnum, reftxdate, affectdate,
       createdate, via, rbankaccount,unhold,currency, reqtxnum, dorc,
       feeamt, taxamt, feecode, feetype)
       VALUES  (seq_crbtxreq.NEXTVAL,'T','FEEBROKER','FEEBROKER','FEEBROKER',v_row.autoid,
       to_date(v_row.transdate,'RRRRMMDD'),'SHV',v_row.bankaccount,null,v_row.feeamount,v_row.remark,
       'P',v_row.autoid,to_date(v_row.transdate,'RRRRMMDD'),to_date(v_row.settledate,'RRRRMMDD'),
        sysdate,'CBP',v_row.nostroaccount,'N',v_row.currency,v_row.autoid,'C',0,0,null,null);

        --A: cho ngan hang
        update fee_broker_result set status = 'A' where autoid = v_row.autoid and refcode = 'FEEBROKER';
    end loop;

    plog.setendsection(pkgctx, 'sp_auto_gen_fee_broker');
  exception
    when others then
      plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'sp_auto_gen_fee_broker');
      RAISE errnums.E_SYSTEM_ERROR;
  end sp_auto_gen_fee_broker;

--thanh toan phi broker trong SHV
procedure sp_auto_gen_fee_broker_IP as
    p_err_code  VARCHAR2(50);
    cursor v_cursor is
      select * from fee_broker_result where status = 'N' and refcode = 'FEEBROKERIP' ;
    v_row v_cursor%rowtype;
  begin

  --bankreqid = to_char(txdate,'DDMMRRRR')||LPAD (seq_BATCHTXNUM.NEXTVAL, 10, '0')
    plog.setbeginsection(pkgctx, 'sp_auto_gen_fee_broker_IP');

    open v_cursor;
    loop
      fetch v_cursor
        into v_row;
      exit when v_cursor%notfound;

       INSERT INTO crbtxreq (reqid, objtype, objname, trfcode, reqcode, objkey,
       txdate, bankcode, bankacct, afacctno, txamt, notes,
       status, reftxnum, reftxdate, affectdate,
       createdate, via, rbankaccount,unhold,currency, reqtxnum, dorc,
       feeamt, taxamt, feecode, feetype)
       VALUES  (seq_crbtxreq.NEXTVAL,'T','FEEBROKERIP','FEEBROKERIP','FEEBROKERIP',v_row.autoid,
       to_date(v_row.transdate,'RRRRMMDD'),'SHV',v_row.nostroaccount,null,v_row.feeamount,v_row.remark,
       'P',v_row.autoid,to_date(v_row.transdate,'RRRRMMDD'),to_date(v_row.settledate,'RRRRMMDD'),
        sysdate,'CBP',v_row.bankaccount,'N',v_row.currency,v_row.autoid,'',0,0,null,null);

        --A: cho ngan hang
        update fee_broker_result set status = 'A' where autoid = v_row.autoid and refcode = 'FEEBROKERIP';
    end loop;


    plog.setendsection(pkgctx, 'sp_auto_gen_fee_broker_IP');
  exception
    when others then
      plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'sp_auto_gen_fee_broker_IP');
  end sp_auto_gen_fee_broker_IP;

--thanh toan phi broker ngoai SHV
procedure sp_auto_gen_fee_broker_OP as
    p_err_code  VARCHAR2(50);
    v_branchname varchar2(250);
    v_bankname varchar2(250);
    v_bankaccname varchar2(250);
    cursor v_cursor is
      select * from fee_broker_result where status = 'N' and refcode = 'FEEBROKEROP' ;
    v_row v_cursor%rowtype;
  begin

  --bankreqid = to_char(txdate,'DDMMRRRR')||LPAD (seq_BATCHTXNUM.NEXTVAL, 10, '0')
    plog.setbeginsection(pkgctx, 'sp_auto_gen_fee_broker_OP');

    open v_cursor;
    loop
      fetch v_cursor
        into v_row;
      exit when v_cursor%notfound;
        --trung.luu 09/06/2020 SHBVNEX-1136 thay fullname =>BENEFICIARY
       select branchname,bankname,BENEFICIARY into v_branchname,v_bankname,v_bankaccname from famembers where bankacctno = v_row.BANKACCOUNT;

       INSERT INTO crbtxreq (reqid, objtype, objname, trfcode, reqcode, objkey,
       txdate, bankcode, bankacct, afacctno, txamt, notes,
       status, reftxnum, reftxdate, affectdate,
       createdate, via, rbankaccount,rbankname,rbankcitad,rbankaccname,unhold,currency, reqtxnum, dorc,
       feeamt, taxamt, feecode, feetype)
       VALUES  (seq_crbtxreq.NEXTVAL,'T','FEEBROKEROP','FEEBROKEROP','FEEBROKEROP',v_row.autoid,
       to_date(v_row.transdate,'RRRRMMDD'),'SHV',v_row.nostroaccount,null,v_row.feeamount,v_row.remark,
       'P',v_row.autoid,to_date(v_row.transdate,'RRRRMMDD'),to_date(v_row.settledate,'RRRRMMDD'),
        sysdate,'CBP',v_row.bankaccount,v_bankname,v_row.citad,v_bankaccname,'N',v_row.currency,v_row.autoid,'',0,0,null,null);

        --A: cho ngan hang
        update fee_broker_result set status = 'A' where autoid = v_row.autoid and refcode = 'FEEBROKEROP';
    end loop;


    plog.setendsection(pkgctx, 'sp_auto_gen_fee_broker_OP');
  exception
    when others then
      plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'sp_auto_gen_fee_broker_OP');
  end sp_auto_gen_fee_broker_OP;

--trung.luu: GD 3342 tai khoan tu doanh
procedure sp_auto_gen_CA3342_TD as
    p_err_code  VARCHAR2(50);
    v_branchname varchar2(250);
    cursor v_cursor is
      select * from CA3342_TD_result where status = 'N' ;
    v_row v_cursor%rowtype;
  begin

  --bankreqid = to_char(txdate,'DDMMRRRR')||LPAD (seq_BATCHTXNUM.NEXTVAL, 10, '0')
    plog.setbeginsection(pkgctx, 'sp_auto_gen_CA3342_TD');

    open v_cursor;
    loop
      fetch v_cursor
        into v_row;
      exit when v_cursor%notfound;



       INSERT INTO crbtxreq (reqid, objtype, objname, trfcode, reqcode, objkey,
       txdate, bankcode, bankacct, afacctno, txamt, notes,
       status, reftxnum, reftxdate, affectdate,
       createdate, via, rbankaccount,rbankcitad,rbankaccname,unhold,currency, reqtxnum, dorc,
       feeamt, taxamt, feecode, feetype)
       VALUES  (seq_crbtxreq.NEXTVAL,'T','CA3342_TD','CA3342_TD','CA3342_TD',v_row.autoid,
       v_row.txdate,'SHV',v_row.BANKACCOUNT,null,v_row.amount,v_row.remark,
       'P',v_row.autoid,null,v_row.txdate,
        sysdate,'CBP',v_row.nostroaccount,'',v_branchname,'N',v_row.currency,v_row.reqtxnum,'C',0,0,null,null);

        --A: cho ngan hang
        update CA3342_TD_result set status = 'A' where autoid = v_row.autoid;
    end loop;


    plog.setendsection(pkgctx, 'sp_auto_gen_CA3342_TD');

  exception
    when others then
      plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'sp_auto_gen_CA3342_TD');
  end sp_auto_gen_CA3342_TD;

--trung.luu: sp_auto_gen_payment_interest
procedure sp_auto_gen_payment_interest as
    p_err_code  VARCHAR2(50);
    v_branchname varchar2(250);
    cursor v_cursor is
      select * from PAYMENT_INTEREST where status = 'N' and refcode ='PAYMENTINTEREST' ;
    v_row v_cursor%rowtype;
  begin

    plog.setbeginsection(pkgctx, 'sp_auto_gen_payment_interest');

    open v_cursor;
    loop
      fetch v_cursor
        into v_row;
      exit when v_cursor%notfound;



       INSERT INTO crbtxreq (reqid, objtype, objname, trfcode, reqcode, objkey,
       txdate, bankcode, bankacct, afacctno, txamt, notes,
       status, reftxnum, reftxdate, affectdate,
       createdate, via, rbankaccount,rbankcitad,rbankaccname,unhold,currency, reqtxnum, dorc,
       feeamt, taxamt, feecode, feetype)
       VALUES  (seq_crbtxreq.NEXTVAL,'T','PAYMENTINTEREST','PAYMENTINTEREST','PAYMENTINTEREST',v_row.autoid,
       to_date(v_row.transdate,'RRRRMMDD'),'SHV',v_row.nostroaccount,null,v_row.amount,v_row.remark,
       'P',v_row.autoid,null,to_date(v_row.settledate,'RRRRMMDD'),
        sysdate,'CBP',v_row.BANKACCOUNT,'',v_branchname,'N',v_row.currency,v_row.autoid,'D',0,0,null,null);

        --A: cho ngan hang
        update PAYMENT_INTEREST set status = 'A' where autoid = v_row.autoid;
    end loop;


    plog.setendsection(pkgctx, 'sp_auto_gen_payment_interest');

  exception
    when others then
      plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'sp_auto_gen_payment_interest');
  end sp_auto_gen_payment_interest;

--tri.bui: sp_auto_gen_payment_interest_in
procedure sp_auto_gen_payment_interest_in as
    p_err_code  VARCHAR2(50);
    v_branchname varchar2(250);
    cursor v_cursor is
      select * from PAYMENT_INTEREST where status = 'N' and refcode ='PAYMENTINTEREST_IN' ;
    v_row v_cursor%rowtype;
  begin

    plog.setbeginsection(pkgctx, 'sp_auto_gen_payment_interest_in');

    open v_cursor;
    loop
      fetch v_cursor
        into v_row;
      exit when v_cursor%notfound;



       INSERT INTO crbtxreq (reqid, objtype, objname, trfcode, reqcode, objkey,
       txdate, bankcode, bankacct, afacctno, txamt, notes,
       status, reftxnum, reftxdate, affectdate,
       createdate, via, rbankaccount,rbankcitad,rbankaccname,unhold,currency, reqtxnum, dorc,
       feeamt, taxamt, feecode, feetype)
       VALUES  (seq_crbtxreq.NEXTVAL,'T','PAYMENTINTEREST_IN','PAYMENTINTEREST_IN','PAYMENTINTEREST_IN',v_row.autoid,
       to_date(v_row.transdate,'RRRRMMDD'),'SHV',v_row.nostroaccount,null,v_row.amount,v_row.remark,
       'P',v_row.autoid,null,to_date(v_row.settledate,'RRRRMMDD'),
        sysdate,'CBP',v_row.BANKACCOUNT,'',v_branchname,'N',v_row.currency,v_row.autoid,'C',0,0,null,null);

        --A: cho ngan hang
        update PAYMENT_INTEREST set status = 'A' where autoid = v_row.autoid;
    end loop;


    plog.setendsection(pkgctx, 'sp_auto_gen_payment_interest_in');

  exception
    when others then
      plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'sp_auto_gen_payment_interest_in');
  end sp_auto_gen_payment_interest_in;

--tri.bui: sp_auto_gen_payment_interest_out
procedure sp_auto_gen_payment_interest_out as
    p_err_code  VARCHAR2(50);
    v_branchname varchar2(250);
    cursor v_cursor is
      select * from PAYMENT_INTEREST where status = 'N' and refcode ='PAYMENTINTEREST_OUT' ;
    v_row v_cursor%rowtype;
  begin

    plog.setbeginsection(pkgctx, 'sp_auto_gen_payment_interest_out');

    open v_cursor;
    loop
      fetch v_cursor
        into v_row;
      exit when v_cursor%notfound;



       INSERT INTO crbtxreq (reqid, objtype, objname, trfcode, reqcode, objkey,
       txdate, bankcode, bankacct, afacctno, txamt, notes,
       status, reftxnum, reftxdate, affectdate,
       createdate, via, rbankaccount,rbankcitad,rbankaccname,unhold,currency, reqtxnum, dorc,
       feeamt, taxamt, feecode, feetype)
       VALUES  (seq_crbtxreq.NEXTVAL,'T','PAYMENTINTEREST_OUT','PAYMENTINTEREST_OUT','PAYMENTINTEREST_OUT',v_row.autoid,
       to_date(v_row.transdate,'RRRRMMDD'),'SHV',v_row.nostroaccount,null,v_row.amount,v_row.remark,
       'P',v_row.autoid,null,to_date(v_row.settledate,'RRRRMMDD'),
        sysdate,'CBP',v_row.BANKACCOUNT,v_row.citad,v_row.rbankaccname,'N',v_row.currency,v_row.autoid,'C',0,0,null,null);

        --A: cho ngan hang
        update PAYMENT_INTEREST set status = 'A' where autoid = v_row.autoid;
    end loop;


    plog.setendsection(pkgctx, 'sp_auto_gen_payment_interest_out');

  exception
    when others then
      plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'sp_auto_gen_payment_interest_out');
  end sp_auto_gen_payment_interest_out;
--trung.luu : sp_auto_gen_ca3387_citad_result
procedure sp_auto_gen_ca3387_citad_result as
    p_err_code  VARCHAR2(50);
    v_branchname varchar2(250);
    cursor v_cursor is
      select * from ca3387_citad_result where status = 'N' ;
    v_row v_cursor%rowtype;
  begin

    plog.setbeginsection(pkgctx, 'sp_auto_gen_ca3387_citad_result');

    open v_cursor;
    loop
      fetch v_cursor
        into v_row;
      exit when v_cursor%notfound;



       INSERT INTO crbtxreq (reqid, objtype, objname, trfcode, reqcode, objkey,
       txdate, bankcode, bankacct, afacctno, txamt, notes,
       status, reftxnum, reftxdate, affectdate,
       createdate, via, rbankaccount,rbankcitad,rbankaccname,unhold,currency, reqtxnum, dorc,
       feeamt, taxamt, feecode, feetype)
       VALUES  (seq_crbtxreq.NEXTVAL,'T','CA3387_CITAD','CA3387_CITAD','CA3387_CITAD',v_row.autoid,
       to_date(v_row.txdate,systemnums.C_DATE_FORMAT),'SHV',v_row.bankacct,v_row.afacctno,v_row.txamt,v_row.notes,
       'P',v_row.autoid,to_date(v_row.createdate,systemnums.C_DATE_FORMAT),to_date(v_row.createdate,systemnums.C_DATE_FORMAT),
        sysdate,'CBP',v_row.rbankaccount,v_row.rbankcitad,v_row.rbankaccname,'N',v_row.currency,v_row.autoid,'',0,0,null,null);

        --A: cho ngan hang
        update ca3387_citad_result set status = 'A' where autoid = v_row.autoid ;
    end loop;


    plog.setendsection(pkgctx, 'sp_auto_gen_ca3387_citad_result');
  exception
    when others then
      plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'sp_auto_gen_ca3387_citad_result');
  end sp_auto_gen_ca3387_citad_result;

function buildtltxdata (
     p_reqid       IN       number
)  RETURN tltxfld_arrtype
IS
PV_REFCURSOR    PKG_REPORT.REF_CURSOR;
v_tltxcd number;
v_afacctno varchar2(50);
v_custodycd varchar2(50);
v_acctno varchar2(50);
v_ccycd varchar2(50);
v_transactionnumber varchar2(50);
v_bankaccount varchar2(50);
v_amount  varchar2(50);
v_bankobj varchar2(50);
v_cbobj varchar2(20);
v_refautoid number;
v_CURRENCY varchar2(10);
v_RATETYPE varchar2(10);
v_vnd number;
v_txdate date;
v_desc varchar2(1000);
l_i                     NUMBER (10);
l_tltxfld_arrtype tltxfld_arrtype;
l_tltxfld_rectype tltxfld_rectype;
v_HOLDAMT VARCHAR2(250);
v_account varchar2(100);
v_desc_6603 varchar2(250);
v_fullname varchar2(250);
v_cifid varchar2(250);
v_address varchar2(250);
V_DDACCTNO VARCHAR2(250);
v_trnref varchar2(50);

BEGIN
select transactionnumber,desbankaccount,amount,bankobj,cbobj,autoid,txdate,transactiondescription,substr(transactionnumber,0,31)||'1'
into v_transactionnumber,v_bankaccount,v_amount,v_bankobj,v_cbobj,v_refautoid,v_txdate,v_desc,v_trnref
from crbbankrequest
where autoid= p_reqid;

--
case v_cbobj
when '6645'  then  -- truong hop goi giao dich tang tien
 begin

                select afacctno,custodycd,acctno,ccycd into v_afacctno,v_custodycd,v_acctno,v_ccycd
                from ddmast where refcasaacct= trim(v_bankaccount) and status <>'C';

            OPEN PV_REFCURSOR
                 FOR
                 select f.fldname,f.defname , f.datatype,
                  case when fldname='90' then   (select c.fullname from cfmast c  where c.custodycd =v_custodycd )
                   when fldname='03' then  v_afacctno
                   when fldname='04' then  'TRFCIDAMT'
                   when fldname='05' then  v_acctno
                   when fldname='09' then  '023'
                   when fldname='10' then  v_amount
                   when fldname='21' then  v_ccycd
                   when fldname='30' then  v_desc
                   when fldname='88' then  v_custodycd
                   when fldname='02' then  v_transactionnumber
                end value ,1 length
              from fldmaster f where objname =v_cbobj;


    --end case 6645---------------------------------------------------------

   end ;
--SHBVNEX-2658
 when '6701'  then  -- -- transaction detail 130
     begin

           OPEN PV_REFCURSOR
                 FOR
                 select f.fldname,f.defname , f.datatype,
                  case when fldname='01' then  d.trx_d
                   when fldname='02' then  TXDATE
                   when fldname='04' then  SCREEN
                   when fldname='05' then  CIFID
                   when fldname='06' then  WACCOUNT
                   when fldname='07' then  WCCYCD
                   when fldname='08' then  RACCOUNT
                   when fldname='09' then  RCCYCD
                   when fldname='10' then  AMOUNT
                   when fldname='11' then  EXCHANGERATE
                   when fldname='12' then  RAMOUNT
                   when fldname='30' then  'Domestic inward remittance'
                end value ,1 length
              from fldmaster f , ( select max(case when d.fldname ='trx_d' then cval else '' end) trx_d -- 01: Withdrawal is Custody Account  is not Custody Account; 02: Withdrawal is not Custody Account  is Custody Account; 03: Withdrawal is Custody Account  is Custody Account too
 ,max(case when d.fldname ='trx_dt' then to_char(to_date(cval,'RRRRMMDD'),'dd/MM/RRRR') else '' end) TXDATE --Transaction Date
,max(case when d.fldname ='scrno' then  cval else '' end) SCREEN --Sceen number
,max(case when d.fldname ='ac_cusno' then  cval else '' end) CIFID --Portfolio No
,max(case when d.fldname ='lcl_ac_no' then  cval else '' end) WACCOUNT  --Withdraw account number
,max(case when d.fldname ='mn_lkg_ccy_c' then  cval else '' end) WCCYCD   --Withdraw account number currency
,max(case when d.fldname ='acno' then  cval else '' end) RACCOUNT  --Receiving account number
,max(case when d.fldname ='lkd_stmt_ccy_c' then  cval else '' end) RCCYCD --Receiving account number currency
,max(case when d.fldname ='mn_lkg_ccy_trx_amt' then  cval else '' end) AMOUNT --Credit amount
,max(case when d.fldname ='stmt_ccy_cvs_exrt' then  cval else '' end) EXCHANGERATE  --Exchange rate
,max(case when d.fldname ='lkd_stmt_ccy_amt' then  cval else '' end) RAMOUNT --Cash Amount (After exchange)
                 from crbbankrequest c,crbbankrequestdtl d
                  where c.autoid = d.reqid and c.autoid= p_reqid) d
              where objname =v_cbobj;
   end ;


 when '6702'  then  -- -- --4001 -> Chuyen tie`n ra nuo?c ngoa`i
     begin

           OPEN PV_REFCURSOR
                 FOR
                 select f.fldname,f.defname , f.datatype,
                  case when fldname='01' then  TXDATE
                   when fldname='02' then  SCREEN
                   when fldname='04' then  AMT
                   when fldname='05' then  CCYCD
                   when fldname='06' then  BACCTNO
                   when fldname='07' then  BNAME
                   when fldname='08' then  VNDAMOUNT
                   when fldname='09' then  EXRATE
                   when fldname='10' then  NOTE
                   when fldname='11' then  WACCTNO
                   when fldname='30' then  'Overseas outward remittance'
                end value ,1 length
              from fldmaster f , ( select   max(case when d.fldname ='trx_dt' then to_char(to_date(cval,'RRRRMMDD'),'dd/MM/RRRR') else '' end) TXDATE --Transaction Date
                                           ,max(case when d.fldname ='trx_scrno' then  cval else '' end) SCREEN --Sceen number
                                           ,max(case when d.fldname ='trx_amt' then  cval else '' end) AMT --Total foreign amount sending
                                           ,max(case when d.fldname ='trx_ccy_c' then  cval else '' end) CCYCD  --Currency
                                           ,max(case when d.fldname ='bnfc_ac_no' then  cval else '' end) BACCTNO   --Beneficiary account
                                           ,max(case when d.fldname ='cus_snm_nm1' then  cval else '' end) BNAME  --Beneficiary name
                                           ,max(case when d.fldname ='lkg_amt2' then  cval else '' end) VNDAMOUNT --Cash Amount (After exchange)
                                           ,max(case when d.fldname ='apl_exrt1' then  cval else '' end) EXRATE --Exchange rate
                                           ,max(case when d.fldname ='memo_ctt' then  cval else '' end) NOTE  --Memo
                                           ,max(case when d.fldname ='remit_aplct_cus_ac_no' then  cval else '' end) WACCTNO
                  from crbbankrequest c,crbbankrequestdtl d
                  where c.autoid = d.reqid and c.autoid= p_reqid) d
              where objname =v_cbobj;
   end ;

   when '6703'  then   --4011 -> nhan tien tu nuoc ngoai
     begin

           OPEN PV_REFCURSOR
                 FOR
                 select f.fldname,f.defname , f.datatype,
                  case when fldname='01' then  TXDATE
                   when fldname='02' then  SCREEN
                   when fldname='04' then  AMT
                   when fldname='05' then  CCYCD
                   when fldname='06' then  SACCTNO
                   when fldname='07' then  SNAME
                   when fldname='08' then  RACCTNO
                   when fldname='09' then  EXRATE
                   when fldname='10' then  EXAMT
                   when fldname='11' then  NOTE
                   when fldname='30' then  'Domestic outward remittance'
                end value ,1 length
              from fldmaster f , ( select   max(case when d.fldname ='trx_dt' then to_char(to_date(cval,'RRRRMMDD'),'dd/MM/RRRR') else '' end) TXDATE --Transaction Date
                                           ,max(case when d.fldname ='trx_scrno' then  cval else '' end) SCREEN --Sceen number
                                           ,max(case when d.fldname ='trx_amt' then  cval else '' end) AMT --Total foreign amount sending
                                           ,max(case when d.fldname ='trx_ccy_c' then  cval else '' end) CCYCD  --Currency
                                           ,max(case when d.fldname ='remit_aplct_cus_ac_no' then  cval else '' end) SACCTNO   --Account sender
                                           ,max(case when d.fldname ='cus_snm_nm' then  cval else '' end) SNAME  --Name sender
                                           ,max(case when d.fldname ='bnfc_ac_no' then  cval else '' end) RACCTNO --Account Receiver
                                           ,max(case when d.fldname ='apl_exrt1' then  cval else '' end) EXRATE --Exchange rate
                                           ,max(case when d.fldname ='lkg_amt2' then  cval else '' end) EXAMT  --Cash Amount (After exchange)
                                           ,max(case when d.fldname ='memo_ctt' then  cval else '' end) NOTE  --Memo
                  from crbbankrequest c,crbbankrequestdtl d
                  where c.autoid = d.reqid and c.autoid= p_reqid) d
              where objname =v_cbobj;
   end ;

 when '6704'  then   --4011 -> nhan tien tu nuoc ngoai
     begin

           OPEN PV_REFCURSOR
                 FOR
                 select f.fldname,f.defname , f.datatype,
                  case when fldname='01' then  TXDATE
                   when fldname='02' then  SCREEN
                   when fldname='04' then  CIFID
                   when fldname='05' then  BUYAMT
                   when fldname='06' then  BCCYCD
                   when fldname='07' then  SELLAMT
                   when fldname='08' then  SCCYCD
                   when fldname='09' then  EXRATE
                   when fldname='10' then  DACCTNO
                   when fldname='11' then  CACCTNO
                    when fldname='30' then  'Overseas inward remittance'
                end value ,1 length
              from fldmaster f , ( select   max(case when d.fldname ='trx_dt' then to_char(to_date(cval,'RRRRMMDD'),'dd/MM/RRRR') else '' end) TXDATE --Transaction Date
                                           ,max(case when d.fldname ='trx_scrno' then  cval else '' end) SCREEN --Sceen number
                                           ,max(case when d.fldname ='cusno' then  cval else '' end) CIFID --Portfolio No
                                           ,max(case when d.fldname ='buy_amt' then  cval else '' end) BUYAMT  --Debit amount
                                           ,max(case when d.fldname ='buy_ccy_c' then  cval else '' end) BCCYCD   --Debit currency
                                           ,max(case when d.fldname ='sel_amt' then  cval else '' end) SELLAMT  --Credit amount
                                           ,max(case when d.fldname ='sel_ccy_c' then  cval else '' end) SCCYCD --Credit currency
                                           ,max(case when d.fldname ='vn_fx_ctrt_rt' then  cval else '' end) EXRATE --Contract exchange rate
                                           ,max(case when d.fldname ='lkg_acno' then  cval else '' end) DACCTNO  --Debit account no
                                           ,max(case when d.fldname ='lkg_acno1' then  cval else '' end) CACCTNO  --Crebit account no
                  from crbbankrequest c,crbbankrequestdtl d
                  where c.autoid = d.reqid and c.autoid= p_reqid) d
              where objname =v_cbobj;
   end ;

 when '6642'  then  -- truong hop goi giao dich giam tien
     begin

                select afacctno,custodycd,acctno,ccycd into v_afacctno,v_custodycd,v_acctno,v_ccycd
                from ddmast where refcasaacct= trim(v_bankaccount)  and status <>'C';

                BEGIN
                    SELECT NOTES
                    INTO V_DESC
                    FROM (
                        SELECT * FROM CRBTXREQ
                        UNION ALL
                        SELECT * FROM CRBTXREQHIST
                    )
                    WHERE REFVAL = V_TRNREF;
                EXCEPTION WHEN OTHERS THEN
                    V_DESC := V_DESC;
                END;

            OPEN PV_REFCURSOR
                 FOR
                 select f.fldname,f.defname , f.datatype,
                  case when fldname='90' then   (select c.fullname from cfmast c  where c.custodycd =v_custodycd )
                   when fldname='03' then  v_afacctno
                   when fldname='04' then  v_acctno
                   when fldname='05' then  v_acctno
                   when fldname='06' then  'TRFCIDAMT'
                   when fldname='09' then  '001'
                   when fldname='10' then  v_amount
                   when fldname='21' then  v_ccycd
                   when fldname='30' then  V_DESC
                   when fldname='88' then  v_custodycd
                   when fldname='02' then  v_transactionnumber
                end value ,1 length
              from fldmaster f where objname =v_cbobj;


    --end case 6642---------------------------------------------------------

   end ;
when '6603'  then  -- truong hop goi giao dich HOLD(DA HOLD TAI AITHER, KHONG GOI API)
     begin

               select max(case when fldname = 'cus_acdnt_reltd_hold_blc' then cval else '' end) HOLDAMT,
                        max(case when fldname = 'lcl_ac_no' then cval else '' end) v_account,
                       max(case when fldname = 'cus_acdnt_his_ctt' then cval else '' end) v_desc
                into  v_HOLDAMT, v_account,v_desc_6603
                from crbbankrequestdtl
                where reqid = v_refautoid;

                SELECT ACCTNO INTO V_DDACCTNO FROM DDMAST WHERE REFCASAACCT = v_account AND STATUS <> 'C';
                SELECT CF.CUSTODYCD,CF.FULLNAME,CF.CIFID,CF.ADDRESS
                    INTO v_custodycd,v_fullname,v_cifid,v_address
                        FROM CFMAST CF, DDMAST DD
                            WHERE   CF.CUSTODYCD = DD.CUSTODYCD
                                AND DD.REFCASAACCT= v_account
                                AND DD.STATUS <> 'C'
                ;

                 OPEN PV_REFCURSOR
                 FOR

                 select f.fldname,f.defname , f.datatype,
                  case when fldname='88' then v_custodycd
                   when fldname='03' then  V_DDACCTNO
                   when fldname='90' then  v_fullname
                   when fldname='89' then  v_cifid
                   when fldname='91' then  v_address
                   when fldname='92' then  ''
                   when fldname='93' then  v_account
                   when fldname='95' then  ''
                   when fldname='05' then  ''
                   when fldname='06' then  ''
                   when fldname='07' then  ''
                   when fldname='10' then  v_HOLDAMT
                   when fldname='30' then  v_desc_6603
                  end value ,1 length
        from fldmaster f where objname =v_cbobj;


    --end case 1291---------------------------------------------------------
   end ;
when '6604'  then  -- truong hop goi giao dich UNHOLD(DA UNHOLD TAI AITHER, KHONG GOI API)
     begin

               select max(case when fldname = 'cus_acdnt_reltd_hold_blc' then cval else '' end) HOLDAMT,
                        max(case when fldname = 'lcl_ac_no' then cval else '' end) v_account,
                       max(case when fldname = 'cus_acdnt_his_ctt' then cval else '' end) v_desc
                into  v_HOLDAMT, v_account,v_desc_6603
                from crbbankrequestdtl
                where reqid = v_refautoid;


                SELECT ACCTNO INTO V_DDACCTNO FROM DDMAST WHERE REFCASAACCT = v_account AND STATUS <> 'C';
                SELECT CF.CUSTODYCD,CF.FULLNAME,CF.CIFID,CF.ADDRESS
                    INTO v_custodycd,v_fullname,v_cifid,v_address
                        FROM CFMAST CF, DDMAST DD
                            WHERE   CF.CUSTODYCD = DD.CUSTODYCD
                                AND DD.REFCASAACCT= v_account
                                AND DD.STATUS <> 'C'
                ;


                 OPEN PV_REFCURSOR
                 FOR

                 select f.fldname,f.defname , f.datatype,
                  case when fldname='88' then v_custodycd
                   when fldname='03' then  V_DDACCTNO
                   when fldname='90' then  v_fullname
                   when fldname='89' then  v_cifid
                   when fldname='91' then  v_address
                   when fldname='92' then  ''
                   when fldname='93' then  v_account
                   when fldname='95' then  ''
                   when fldname='05' then  ''
                   when fldname='06' then  ''
                   when fldname='07' then  ''
                   when fldname='10' then  v_HOLDAMT
                   when fldname='30' then  v_desc_6603
                  end value ,1 length
        from fldmaster f where objname =v_cbobj;


    --end case 1291---------------------------------------------------------
   end ;
when '1291'  then  -- truong hop goi giao dich ty gia
     begin

               select max(case when fldname = 'CURRENCY' then cval else '' end) CURRENCY,
       max(case when fldname = 'RATETYPE' then cval else '' end) RATETYPE,
       max(case when fldname = 'VND' then nval else 0 end) VND
                into  v_CURRENCY, v_RATETYPE,v_vnd
                from crbbankrequestdtl
                where reqid = v_refautoid;

                 OPEN PV_REFCURSOR
                 FOR

                 select f.fldname,f.defname , f.datatype,
                  case when fldname='30' then  'Update exchange rate from bank'
                   when fldname='33' then  v_CURRENCY
                   when fldname='34' then  v_RATETYPE
                   when fldname='35' then  decode(v_bankobj,'12','SHV','SBV')
                   when fldname='44' then  to_char(v_vnd)
                   when fldname='93' then  to_char(v_txdate,'DD/MM/RRRR')
                  end value ,1 length
        from fldmaster f where objname =v_cbobj;


    --end case 1291---------------------------------------------------------
   end ;
else ---default
 OPEN PV_REFCURSOR
     FOR select '' defname ,'C' datatype, '0' value ,1 length from dual;
end case ;



 l_i := 0;
      LOOP
         FETCH pv_refcursor
          INTO l_tltxfld_rectype;

         l_tltxfld_arrtype (l_i) := l_tltxfld_rectype;
         EXIT WHEN pv_refcursor%NOTFOUND;
         l_i := l_i + 1;
      END LOOP;
     l_tltxfld_arrtype (0).length:=l_i-1;

 return l_tltxfld_arrtype;
EXCEPTION
   WHEN OTHERS
   THEN
    plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
       if pv_refcursor%ISOPEN THEN
            CLOSE pv_refcursor;
         END IF;
         return l_tltxfld_arrtype;
END buildtltxdata;

END;
/
