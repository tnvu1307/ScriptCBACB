SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE auto_call_txpks_6645(pv_reqid IN  number, p_err_code IN OUT varchar2) is
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
        l_txmsg.busdate   := getcurrdate;
        l_txmsg.txdate    := getcurrdate;
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
                from ddmast where refcasaacct= trim(v_bankaccount);

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
             end if;

end;
/
