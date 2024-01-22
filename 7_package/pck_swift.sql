SET DEFINE OFF;
CREATE OR REPLACE PACKAGE pck_swift
  IS



 TYPE tltxfld_rectype IS RECORD (
      fldname           fldmaster.fldname%TYPE,
      defname           fldmaster.defname%TYPE,
      datatype            fldmaster.datatype%TYPE,
      value         varchar2(500),
      length         number
   );

   TYPE tltxfld_arrtype IS TABLE OF tltxfld_rectype
      INDEX BY PLS_INTEGER;


    PROCEDURE transact_Exec
    ( p_transactionnumber IN VARCHAR2,
      p_err_code OUT VARCHAR2);



 procedure sp_auto_gen_confirm_transact ;
function buildtltxdata (
     p_reqid       IN       varchar2
)  RETURN tltxfld_arrtype;


END;
/


CREATE OR REPLACE PACKAGE BODY pck_swift
IS
      -- declare log context
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;




   PROCEDURE transact_Exec_Pending
    ( p_transactionnumber IN VARCHAR2,
      p_err_code  OUT VARCHAR2)
    IS
      -- Enter the procedure variables here. As shown below
     p_sqlcommand VARCHAR2(4000);
     l_txmsg       tx.msg_rectype;
     l_err_param varchar2(300);
     v_strCURRDATE varchar2(20);
     v_tltxcd varchar2(20);
     v_status char(1);
     v_trnref varchar2(50);
     v_currencycode varchar2(20);
     v_bankobj varchar2(4);
     v_msgtype varchar2(2);
     v_reftxnum varchar2(30);
     L_txnum varchar2(30);
     v_ddacctno varchar2(50);
     v_reqid varchar2(50);
     v_bankbalance number;
     v_bankholdbalance number;
     v_tltxcd_revert varchar2(20);
     v_strstatus varchar2(1);
     v_errordescfrombank varchar2(1000);
     v_holdtxnum varchar2(50);
     v_ca_type varchar2(50);
     v_caid varchar2(50);
     v_cifid varchar2(50);
     v_qtty varchar2(50);
     v_senderbiccode varchar2(50);
     v_count number;
     v_mttype varchar2(20);
     v_BRBICCODE varchar2(50);
     v_ISIN varchar2(20);
     v_PRICE varchar2(50);
     v_AMT varchar2(50);
     v_TOTALAMT varchar2(50);
     v_FEEAMT varchar2(50);
     v_TAXAMT  varchar2(50);
     v_REQUESTTYPE  varchar2(50);
     v_REFID  varchar2(50);
     v_TRADEDATE varchar2(50);
     v_SETTLEMENT varchar2(50);
     v_xmldoc varchar2(32767);
     v_wsname varchar2(50);
     v_ipaddress varchar2(50);
     v_ccyusagefld varchar2(2);

     l_bors      VARCHAR2(100);
     l_reqdt     VARCHAR2(100);
     l_effdt     VARCHAR2(100);
     l_amount    VARCHAR2(100);
     l_ccycd     VARCHAR2(10);
     l_frccycd    VARCHAR2(10);
     v_caop      varchar2(10);
     v_intcount number;
     v_custodycd varchar2(50);
     v_pbalance number;
     v_cancel_qtty number;
     v_afacctno varchar2(50);
     v_msgerror varchar2(4000);
   BEGIN


 --plog.error (pkgctx,'begin transact exec'|| p_sqlcommand);
-- tu p_transactionnumber lay ra thong tin can thiet tu dien
select msgid,status,tltxcd,senderbiccode,mttype into v_reqid,v_status,v_tltxcd,v_senderbiccode,v_mttype
from swiftmsgmaplog
where msgid=p_transactionnumber
and status ='P'
and rownum = 1;


--###### khu vuc hardcode
--hardcode case cho truong hop 565

if v_tltxcd= '3384' and v_mttype = '565' then
    select max(case when fldcd = '06' then defvalue else '' end ) CATYPE,
         max(case when fldcd = '02' then defvalue else '' end ) CAID,
         max(case when fldcd = '03' then defvalue else '' end ) CIFID,
         max(case when fldcd = '05' then defvalue else '' end ) CAOP,
         max(case when fldcd = '10' then replace(substr(defvalue,instr(defvalue,'/')+1),',','.') else '' end ) QTTY
    into  v_ca_type ,v_caid,v_cifid,v_caop,v_qtty
    from swiftmsgmaplogdtl where msgid = v_reqid;

    if v_ca_type = 'RHTS' and v_caop='EXER' then   --dang ki quyen mua
        v_count := 0;
        select count (*) into v_count
        from vw_strade_ca_rightoff_3384 r, cfmast cf
        where r.custodycd = cf.custodycd
        and replace(camastid,'.') = v_caid and cf.cifid = v_cifid ;

        if v_count <=0 then  --verify error --> hien ko lam j het
            UPDATE swiftmsgmaplog SET status='E', ERRORDESC= 'CA ID not found: '||v_caid  WHERE msgid = p_transactionnumber;
            return ;
        end if;

        v_count:=0;
        select count (*) into v_count
        from vw_strade_ca_rightoff_3384 r, cfmast cf
        where r.custodycd = cf.custodycd
        and replace(camastid,'.') = v_caid and cf.cifid = v_cifid and avlqtty >=v_qtty;
        if v_count <=0 then  --verify error --> hien ko lam j het
            UPDATE swiftmsgmaplog SET status='E', ERRORDESC= 'Register quantity is greater than available quantity: '||v_qtty  WHERE msgid = p_transactionnumber;
            return ;
        end if;
    elsif v_ca_type = 'RHTS' and v_caop='LAPS' then
        v_count:=0;

        SELECT COUNT(1) INTO v_count
        FROM CAMAST CA, CASCHD CS, CFMAST CF, AFMAST AF
        WHERE CA.CAMASTID = CS.CAMASTID
        AND CS.AFACCTNO = AF.ACCTNO
        AND AF.CUSTID = CF.CUSTID
        AND CA.CAMASTID = V_CAID
        AND CF.CIFID =V_CIFID
        AND CA.STATUS IN ('V','M','S','I','J','C')
        AND GETCURRDATE <= CA.DEBITDATE;

        if v_count <=0 then  --verify error --> hien ko lam j het
            UPDATE swiftmsgmaplog SET status='E', ERRORDESC= 'Data not found: camastid - ' || v_caid || ', cifid - ' || V_CIFID  WHERE msgid = p_transactionnumber;
            return ;
        end if;

        BEGIN
            SELECT CUSTODYCD, AF.ACCTNO INTO V_CUSTODYCD, V_AFACCTNO FROM CFMAST CF, AFMAST AF WHERE CF.CUSTID = AF.CUSTID AND CIFID = V_CIFID;
        EXCEPTION WHEN OTHERS THEN
            UPDATE SWIFTMSGMAPLOG SET STATUS='E', ERRORDESC= 'Data not found: CAMASTID - ' || V_CAID || ', CIFID - ' || V_CIFID  WHERE MSGID = P_TRANSACTIONNUMBER;
            RETURN ;
        END;

        BEGIN
            SELECT SUM(QTTY) into v_cancel_qtty FROM CACANCEL WHERE CAMASTID = V_CAID AND CUSTODYCD = V_CUSTODYCD GROUP BY CAMASTID, CUSTODYCD;
        EXCEPTION WHEN OTHERS THEN
            v_cancel_qtty := 0;
        END;

        SELECT BALANCE + PBALANCE + OUTBALANCE - INBALANCE - v_cancel_qtty INTO V_PBALANCE FROM CASCHD WHERE CAMASTID = V_CAID AND AFACCTNO = V_AFACCTNO;

        IF V_PBALANCE < V_QTTY THEN
            UPDATE SWIFTMSGMAPLOG SET STATUS = 'E', ERRORDESC = 'The quantity of rights to be cancelled is bigger than the quantity of remaining rights'  WHERE MSGID = P_TRANSACTIONNUMBER;
            RETURN ;
        END IF;

        v_tltxcd := '3300';
        UPDATE SWIFTMSGMAPLOG SET TLTXCD = v_tltxcd WHERE MSGID = P_TRANSACTIONNUMBER;

    else -- khong phai quyen mua thi khong lam j ca

        v_count := 0;
        select count(*) into v_count
        from camast
        where camastid = v_caid AND deltd = 'N';

        if v_count <=0 then
            UPDATE swiftmsgmaplog SET status='E', ERRORDESC= 'Camastid not found: camastid - ' || v_caid  WHERE msgid = p_transactionnumber;
            return ;
        end if;

        v_count := 0;
        select count(*) into v_count
        from cfmast
        where cifid = v_cifid and status <> 'C';

        if v_count <=0 then
            UPDATE swiftmsgmaplog SET status='E', ERRORDESC= 'Cifid not found: cifid - ' || v_cifid  WHERE msgid = p_transactionnumber;
            return ;
        end if;

        BEGIN
            SELECT CUSTODYCD, AF.ACCTNO INTO V_CUSTODYCD, V_AFACCTNO FROM CFMAST CF, AFMAST AF WHERE CF.CUSTID = AF.CUSTID AND CIFID = V_CIFID;
        EXCEPTION WHEN OTHERS THEN
            UPDATE SWIFTMSGMAPLOG SET STATUS='E', ERRORDESC= 'Data not found: cifid - ' || V_CIFID  WHERE MSGID = P_TRANSACTIONNUMBER;
            RETURN ;
        END;

        v_count := 0;
        select count(*) into v_count
        from caschd
        where camastid = v_caid and afacctno = V_AFACCTNO and deltd = 'N';

        if v_count <=0 then
            UPDATE swiftmsgmaplog SET status='E', ERRORDESC= 'Data not found (CASCHD): cifid - ' || v_cifid  WHERE msgid = p_transactionnumber;
            return ;
        end if;

        UPDATE swiftmsgmaplog SET status='C' , CFNSTATUS = 'P'  WHERE msgid = p_transactionnumber;
        return;
    end if;
else
    if v_mttype in( '540','599','568') then
        UPDATE swiftmsgmaplog SET status='C'  WHERE msgid = p_transactionnumber;
        return ;
    end if;
end if;

---xu ly cho ccyusage
if v_tltxcd ='3384' then
    v_ccyusagefld:='24';
ELSif v_tltxcd ='3300'  then
    v_ccyusagefld:='01';
ELSif v_tltxcd ='2244'  then
    v_ccyusagefld:='01';
end if;


--###### end  khu vuc hardcode

--case ra xu ly cho tung truong hop
CASE v_tltxcd
    WHEN 'TABLE' then
         begin
            if v_mttype = '541' or v_mttype = '543' then
                --- doan nay insert vao table import cua client tuong ung file import I069
                select  max(case when fldcd = '07' then defvalue else '' end ) BRBICCODE,
                        max(case when fldcd = '04' then SUBSTR(defvalue,INSTR (defvalue,' ')+1,12) else '' end ) ISIN,
                        max(case when fldcd = '06' then defvalue else '' end ) CIFID,
                        max(case when fldcd = '05' then replace(substr(defvalue,instr(defvalue,'/')+1),',','.') else '' end ) QTTY,
                        max(case when fldcd = '03' then replace(substr(defvalue,instr(defvalue,'/')+1+3),',','.') else '' end ) PRICE,  ---+ 3 = currency :VND..
                        max(case when fldcd = '08' then replace(substr(defvalue,4),',','.') else '0' end ) AMT,
                        max(case when fldcd = '09' then replace(substr(defvalue,4),',','.') else '0' end ) TOTALAMT,
                        max(case when fldcd = '10' then replace(substr(defvalue,4),',','.') else '0' end ) FEEAMT,
                        max(case when fldcd = '12' then replace(substr(defvalue,4),',','.') else '0' end ) TAXAMT,
                        max(case when fldcd = '13' then defvalue else '' end ) REQUESTTYPE,
                        max(case when fldcd = '14' then defvalue else '' end ) REFID,
                        max(case when fldcd = '22' then defvalue else '' end ) TRADEDATE,
                        max(case when fldcd = '02' then defvalue else '' end ) SETTLEMENT

                        into v_BRBICCODE, v_ISIN,v_CIFID, v_QTTY, v_PRICE,v_AMT,v_TOTALAMT,v_FEEAMT,v_TAXAMT,v_REQUESTTYPE,v_REFID,v_TRADEDATE,v_SETTLEMENT
                from swiftmsgmaplogdtl where  msgid = v_reqid;
                --verify data before process
                begin

                    v_msgerror := NULL;
                    v_intcount := 0;
                    SELECT count(depositid) into v_intcount from deposit_member d where interbiccode = v_BRBICCODE;
                    if v_intcount=0 then
                        v_msgerror := 'Sai BICCODE. ';
                    end if;

                    v_intcount := 0;
                    select count(custodycd) into v_intcount  from cfmast where cifid =v_CIFID;
                    if v_intcount=0 then
                        v_msgerror := v_msgerror || 'Sai trading account/ Portfolio No. ';
                    end if;

                    v_intcount := 0;
                    select count(symbol)  into v_intcount  from sbsecurities where isincode =v_ISIN and tradeplace <> '006';
                    if v_intcount=0 then
                        v_msgerror := v_msgerror || 'Sai ISINCODE. ';
                    end if;

                    if v_msgerror IS NOT NULL then
                        
                        update  swiftmsgmaplog set status = 'E', CFNSTATUS = 'P', cfndesc = v_msgerror where msgid = v_reqid and status = 'P';
                        return;
                    end if;
                end;

                if v_REQUESTTYPE = 'NEWM' THEN
                    --Chuan Hoa du lieu date
                    --Trung.luu => doi thanh dd/mm/rrrr
                    --v_TRADEDATE := TO_CHAR(TO_DATE(v_TRADEDATE,'rrrrmmdd'), 'ddmmrrrr');
                    --v_SETTLEMENT := TO_CHAR(TO_DATE(v_SETTLEMENT,'rrrrmmdd'), 'ddmmrrrr');
                    v_TRADEDATE := TO_CHAR(TO_DATE(v_TRADEDATE,'rrrrmmdd'), 'dd/mm/rrrr');
                    v_SETTLEMENT := TO_CHAR(TO_DATE(v_SETTLEMENT,'rrrrmmdd'), 'dd/mm/rrrr');

                    IF v_FEEAMT = v_AMT THEN
                        v_FEEAMT := 0;
                    END IF;

                    INSERT INTO odmastcust (BROKER_CODE,TRANS_TYPE,ST_CODE,CUSTODYCD,SEC_ID,TRADE_DATE,SETTLE_DATE,QUANTITY,PRICE,GROSS_AMOUNT,COMMISSION_FEE,TAX,NET_AMOUNT,DELTD,STATUS,ERRMSG,FILEID,TLIDIMP,autoid,TXTIME)
                    select d.depositid,decode(v_mttype,'541','NB','NS'),null,c.custodycd,sb.symbol,v_TRADEDATE,v_SETTLEMENT,v_QTTY,v_PRICE,v_AMT,v_FEEAMT,v_TAXAMT,v_TOTALAMT,'N',null,null,v_reqid,'SWIFT',seq_imp_temp.nextval,sysdate
                    from (SELECT depositid from deposit_member d where interbiccode = v_BRBICCODE) d,
                         (select custodycd from cfmast where cifid =v_CIFID) c ,
                         (select symbol from sbsecurities where isincode =v_ISIN and tradeplace <> '006') sb ;

                    update  swiftmsgmaplog set status = 'C' ,cfnstatus = 'P'
                    where msgid=v_reqid and status ='P' ;
                else
                    v_intcount :=0;
                    select count(*) into v_intcount
                    from odmastcust
                    where fileid =v_REFID and TLIDIMP = 'SWIFT' and isodmast='N';
                    if v_intcount > 0 then
                        update  odmastcust set deltd = 'Y' where fileid =v_REFID and TLIDIMP = 'SWIFT' and isodmast='N';
                        update  swiftmsgmaplog set status = 'C' ,cfnstatus = 'P', cfndesc='Cancelled' where msgid=v_reqid and status ='P' ;
                    else
                        update  swiftmsgmaplog set status = 'C' ,cfnstatus = 'P' where msgid=v_reqid and status ='P' ;
                    end if;
                end if;
            ELSIF v_mttype = '380' THEN
                SELECT MAX(DECODE(fldcd, '02', defvalue, ''))  bors,
                       MAX(DECODE(fldcd, '03', defvalue, ''))  reqdt,
                       MAX(DECODE(fldcd, '04', defvalue, ''))  effdt,
                       replace(MAX(DECODE(fldcd, '05', defvalue, '')),',','.') amount,
                       MAX(DECODE(fldcd, '06', defvalue, '')) ccycd,
                       MAX(DECODE(fldcd, '07', defvalue, '')) cif_no
                INTO l_bors, l_reqdt, l_effdt, l_amount, l_ccycd, v_cifid
                FROM swiftmsgmaplogdtl
                where  msgid = v_reqid;

                l_bors := CASE WHEN l_bors = 'BUYI' THEN 'B' WHEN l_bors = 'SELL' THEN 'S' ELSE '' END;

                l_frccycd := substr(l_amount,1,3);
                 l_amount := substr(l_amount,4);


                INSERT INTO tbl_mt380_inf (autoid, reqid, bors, reqdt, effdt, amount,framount, ccycd, cifid, frccycd)
                SELECT seq_mt380.nextval,
                       v_reqid,
                       l_bors,
                       TO_DATE(l_reqdt, 'rrrrmmdd'),
                       TO_DATE(l_effdt, 'rrrrmmdd'),
                       CASE WHEN l_bors = 'B' THEN l_amount  ELSE null END,
                       CASE WHEN l_bors = 'S' THEN l_amount  ELSE null END,
                       CASE WHEN l_bors = 'S' THEN l_ccycd  ELSE l_frccycd END,
                       v_cifid, CASE WHEN l_bors = 'B' THEN l_ccycd  ELSE l_frccycd END
                FROM dual;

                update  swiftmsgmaplog set status = 'C' where msgid = v_reqid and status ='P' ;
            end if;

         end;


    ELSE --truong hop mac dinh neu la goi giao dich hoan tat co cau truc giong voi giao dich yeu cau
        begin

      -- plog.error (pkgctx,'begin transact exec '||v_tltxcd||':'||p_transactionnumber);


            SELECT TO_DATE (varvalue, systemnums.c_date_format)
            INTO v_strCURRDATE
            FROM sysvar
            WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

            SELECT  LPAD (seq_BATCHTXNUM.NEXTVAL, 10, '0')
            INTO L_txnum
            FROM DUAL;

            SELECT SYS_CONTEXT ('USERENV', 'HOST'), SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
            INTO v_wsname, v_ipaddress
            FROM DUAL;

            v_xmldoc:='<TransactMessage MSGTYPE="T" ACTIONFLAG="TXN" TLTXCD="'||v_tltxcd||'" BRID="0001" TLID="0001" IPADDRESS="127.0.0.1" WSNAME="'||v_wsname||'" TXTYPE="M" NOSUBMIT="1" STATUS="4" DELTD="N" DELALLOW="Y" OVRRQD="@00" UPDATEMODE="" LOCAL="N" OFFID="" CHKID="" CHID="" IBT="" BRID2="" TLID2="" TXDATE="'||v_strCURRDATE||'" TXTIME="'||to_char(sysdate,'hh24:mm:ss')||'" TXNUM="'||L_txnum||'" BRDATE="" BUSDATE="'||v_strCURRDATE||'" CCYUSAGE="$CCYUSAGE$" OFFLINE="N" MSGSTS="0" OVRSTS="0" PRETRAN="N" BATCHNAME="DAY" MSGAMT="" MSGACCT="" CHKTIME="" OFFTIME="" TXDESC="" FEEAMT="0" VATAMT="" VOUCHER="" PAGENO="1" TOTALPAGE="1" LATE="0" GLGP="N" HOSTTIME="" CAREBY="" REFERENCE="" WARNING="Y"><fields>';
            p_sqlcommand:=' declare
                            pkgctx   plog.log_ctx; l_txmsg       tx.msg_rectype; l_err_param varchar2(300);
                            p_err_code  VARCHAR2(300); V_REFCURSOR   PKG_REPORT.REF_CURSOR;  l_i number;
                            l_tltxfld_arrtype pck_swift.tltxfld_arrtype;l_tltxfld_rectype pck_swift.tltxfld_rectype;
                            p_xmlmsg varchar2(20000);
                            begin                                ';

                           p_sqlcommand:=p_sqlcommand||' l_tltxfld_arrtype := pck_swift.buildtltxdata('''||v_reqid||''');
                           p_xmlmsg:='''||v_xmldoc||''';
                            l_tltxfld_rectype:= l_tltxfld_arrtype (0) ;
                                  l_i := 0;
                                  LOOP
                                      l_tltxfld_rectype:= l_tltxfld_arrtype (l_i) ;
                                      if l_tltxfld_rectype.fldname = '''||v_ccyusagefld||''' then
                                        p_xmlmsg:=replace(p_xmlmsg,''$CCYUSAGE$'',l_tltxfld_rectype.value);
                                      end if;
                                  p_xmlmsg:=p_xmlmsg || ''<entry fldname="''||l_tltxfld_rectype.fldname||''" fldtype="''||l_tltxfld_rectype.datatype||''" defname="''||l_tltxfld_rectype.defname||''">''||l_tltxfld_rectype.value||''</entry>'';
                                    l_i := l_i + 1;
                                    EXIT WHEN l_i > l_tltxfld_arrtype.count-1;
                                  END LOOP;
                                  p_xmlmsg:=p_xmlmsg || ''</fields></TransactMessage>'';
                                    ' ;


                           p_sqlcommand:=p_sqlcommand|| ' IF txpks_#'||v_tltxcd||'.fn_txProcess(p_xmlmsg, p_err_code, l_err_param) <> systemnums.c_success THEN

                                                    UPDATE swiftmsgmaplog SET status=''E'', ERRORDESC= ''CBPlus:error:''||p_err_code||l_err_param   WHERE msgid = '''||v_reqid||''';
                                                    select en_errdesc  into l_err_param
                                                   from deferror where errnum = p_err_code;
                                              ELSE
                                                   UPDATE swiftmsgmaplog SET status=''C'' , reftxnum ='''||L_txnum||''', cftxnum ='''||L_txnum||''', cftxdate = to_date('''||v_strCURRDATE||''',systemnums.c_date_format) WHERE msgid = '''||v_reqid||''';
                                              END IF;
                        END;';

--plog.error (pkgctx,' transact exec:'|| p_sqlcommand);
       EXECUTE IMMEDIATE p_sqlcommand;
       EXCEPTION when others THEN
              UPDATE swiftmsgmaplog SET status='E', ERRORDESC= p_transactionnumber||'CBPlus: process confirm error :'|| dbms_utility.format_error_backtrace  WHERE msgid = p_transactionnumber;
      end;
  end case;








 

    --plog.setbeginsection(pkgctx, p_sqlcommand);

    p_err_code:=0;
  commit;
   EXCEPTION when others THEN
        p_err_code := errnums.C_SYSTEM_ERROR;
        plog.error (pkgctx,p_transactionnumber || SQLERRM);
        UPDATE swiftmsgmaplog SET status='E', ERRORDESC= p_transactionnumber||'CBPlus: process confirm error :'|| dbms_utility.format_error_backtrace  WHERE msgid = p_transactionnumber;
   END;
   -- Enter further code below as specified in the Package spec.




   PROCEDURE transact_Exec
    ( p_transactionnumber IN VARCHAR2,
      p_err_code  OUT VARCHAR2)
    IS
      -- Enter the procedure variables here. As shown below
     p_sqlcommand VARCHAR2(4000);
     l_txmsg       tx.msg_rectype;
     l_err_param varchar2(300);
     v_strCURRDATE varchar2(20);
     v_tltxcd varchar2(20);
     v_status char(1);
     v_trnref varchar2(50);
     v_currencycode varchar2(20);
     v_bankobj varchar2(4);
     v_msgtype varchar2(2);
     v_reftxnum varchar2(30);
     L_txnum varchar2(30);
     v_ddacctno varchar2(50);
     v_reqid varchar2(50);
     v_bankbalance number;
     v_bankholdbalance number;
     v_tltxcd_revert varchar2(20);
     v_strstatus varchar2(1);
     v_errordescfrombank varchar2(1000);
     v_holdtxnum varchar2(50);
     v_ca_type varchar2(50);
     v_caid varchar2(50);
     v_cifid varchar2(50);
     v_qtty varchar2(50);
     v_senderbiccode varchar2(50);
     v_count number;
     v_mttype varchar2(20);
     v_BRBICCODE varchar2(50);
     v_ISIN varchar2(20);
     v_PRICE varchar2(50);
     v_AMT varchar2(50);
     v_TOTALAMT varchar2(50);
     v_FEEAMT varchar2(50);
     v_TRADEDATE varchar2(50);
     v_SETTLEMENT varchar2(50);
   BEGIN


 
-- tu p_transactionnumber lay ra thong tin can thiet tu dien
select msgid,status,tltxcd,senderbiccode,mttype into  v_reqid,v_status,v_tltxcd,v_senderbiccode,v_mttype
from swiftmsgmaplog
where msgid=p_transactionnumber and status ='P' ;

--###### khu vuc hardcode
--hardcode case cho truong hop 565
if v_tltxcd= '3384' and v_mttype = '565' then
  select max(case when fldcd = '06' then defvalue else '' end ) CATYPE,
         max(case when fldcd = '02' then defvalue else '' end ) CAID,
         max(case when fldcd = '03' then defvalue else '' end ) CIFID,
         max(case when fldcd = '10' then replace(substr(defvalue,instr(defvalue,'/')+1),',','.') else '' end ) QTTY
  into  v_ca_type ,v_caid,v_cifid,v_qtty
  from swiftmsgmaplogdtl where  msgid = v_reqid;

  if v_ca_type = 'RHTS' then   -- quyen mua
     v_count:=0;
     select count (*) into v_count
     from vw_strade_ca_rightoff_3384 r, cfmast cf
     where r.custodycd = cf.custodycd
           and replace(camastid,'.') = v_caid and cf.cifid = v_cifid and avlqtty >=v_qtty;
      if v_count <=0 then  --verify error --> hien ko lam j het
        return ;
      end if;
  else -- khong phai quyen mua thi khong lam j ca
      return;
  end if;

end if;



--###### end  khu vuc hardcode

--case ra xu ly cho tung truong hop
CASE v_tltxcd
    WHEN 'TABLE' then
         begin
            if v_mttype = '541' or v_mttype = '543' then
                    --- doan nay insert vao table import cua client tuong ung file import I069
                    select max(case when fldcd = '07' then defvalue else '' end ) BRBICCODE,
                             max(case when fldcd = '04' then SUBSTR(defvalue,INSTR (defvalue,' ')+1,12) else '' end ) ISIN,
                             max(case when fldcd = '06' then defvalue else '' end ) CIFID,
                             max(case when fldcd = '05' then substr(defvalue,instr(defvalue,'/')+1) else '' end ) QTTY,
                             max(case when fldcd = '03' then substr(defvalue,instr(defvalue,'/')+1+3) else '' end ) PRICE,  ---+ 3 = currency :VND..
                             max(case when fldcd = '08' then substr(defvalue,4) else '' end ) AMT,
                             max(case when fldcd = '09' then substr(defvalue,4) else '' end ) TOTALAMT,
                             max(case when fldcd = '10' then substr(defvalue,4) else '' end ) FEEAMT,
                              max(case when fldcd = '22' then defvalue else '' end ) TRADEDATE,
                               max(case when fldcd = '02' then defvalue else '' end ) SETTLEMENT

                      into v_BRBICCODE, v_ISIN,v_CIFID, v_QTTY, v_PRICE,v_AMT,v_TOTALAMT,v_FEEAMT,v_TRADEDATE,v_SETTLEMENT
                      from swiftmsgmaplogdtl where  msgid = v_reqid;

--Chuan Hoa du lieu date
--Trung.luu => doi thanh dd/mm/rrrr
--v_TRADEDATE := TO_CHAR(TO_DATE(v_TRADEDATE,'rrrrmmdd'), 'ddmmrrrr');
--v_SETTLEMENT := TO_CHAR(TO_DATE(v_SETTLEMENT,'rrrrmmdd'), 'ddmmrrrr');
v_TRADEDATE := TO_CHAR(TO_DATE(v_TRADEDATE,'rrrrmmdd'), 'dd/mm/rrrr');
v_SETTLEMENT := TO_CHAR(TO_DATE(v_SETTLEMENT,'rrrrmmdd'), 'dd/mm/rrrr');
                       INSERT INTO odmastcust (BROKER_CODE,TRANS_TYPE,ST_CODE,CUSTODYCD,SEC_ID,TRADE_DATE,SETTLE_DATE,QUANTITY,PRICE,GROSS_AMOUNT,COMMISSION_FEE,TAX,NET_AMOUNT,DELTD,STATUS,ERRMSG,FILEID,TLIDIMP,autoid,TXTIME)
                       select d.shortname,decode(v_mttype,'541','NB','NS'),null,c.custodycd,sb.symbol,v_TRADEDATE,v_SETTLEMENT,v_QTTY,v_PRICE,v_AMT,v_FEEAMT,null,v_TOTALAMT,'N',null,null,'SWIFT','0000',seq_imp_temp.nextval,sysdate
                        from (select shortname from deposit_member d where biccode = v_BRBICCODE) d,
                          (select custodycd from cfmast where cifid =v_CIFID) c ,
                          (select symbol from sbsecurities where isincode =v_ISIN and tradeplace <> '006') sb ;
               update  swiftmsgmaplog set status = 'C'
                where msgid=v_reqid and status ='P' ;
            end if;

         end;
    WHEN '07' THEN  --dien tra inquiry thi cap nhat lai data trong ddmast
          begin
                  
                --lay ra so tk ddmast de xu ly
                select afacctno into v_ddacctno from crbtxreq where refval = v_trnref;

               --lay ra so lieu can cap nhat
                select max(case when fldname = 'AVLBALANCE' then nval else 0 end) bankbalance,
                      max(case when fldname = 'RESTRICTAMT' then nval else 0 end) bankholdbalance
                into  v_bankbalance, v_bankholdbalance
                from crbbankrequestdtl
                where reqid = v_reqid;

                update ddmast set bankbalance=v_bankbalance , bankholdbalance = v_bankholdbalance where acctno = v_ddacctno;
                UPDATE crbbankrequest SET isconfirmed='Y'  WHERE transactionnumber = p_transactionnumber;
                UPDATE crbtxreq SET status='C'  WHERE refval = v_trnref;
          EXCEPTION when others THEN
             -- truong hop bi loi thi update crbtxreq --> hoan tat , update crbbankrequest --> xu ly loi tai cbplus
              UPDATE crbbankrequest SET isconfirmed='Y'   , ERRORDESC = 'Got error at CBPlus:'|| dbms_utility.format_error_backtrace WHERE transactionnumber = p_transactionnumber;
              UPDATE crbtxreq SET status='C'  WHERE refval = v_trnref;
          end;
  --  WHEN e2 THEN
 --         r2

    ELSE --truong hop mac dinh neu la goi giao dich hoan tat co cau truc giong voi giao dich yeu cau
      begin

       


           SELECT TO_DATE (varvalue, systemnums.c_date_format)
                                           INTO v_strCURRDATE
                                           FROM sysvar
                                           WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
                            SELECT  LPAD (seq_BATCHTXNUM.NEXTVAL, 10, '0')
                                      INTO L_txnum
                                      FROM DUAL;



                            p_sqlcommand:=' declare
                                pkgctx   plog.log_ctx; l_txmsg       tx.msg_rectype; l_err_param varchar2(300);
                                p_err_code  VARCHAR2(300); V_REFCURSOR   PKG_REPORT.REF_CURSOR;  l_i number;
                                l_tltxfld_arrtype pck_swift.tltxfld_arrtype;l_tltxfld_rectype pck_swift.tltxfld_rectype;
                                 p_xmlmsg varchar2(10000);
                           begin
                                l_txmsg.msgtype:=''T'';
                                l_txmsg.local:=''N'';
                                l_txmsg.tlid        := ''0001'';
                                SELECT SYS_CONTEXT (''USERENV'', ''HOST''),
                                         SYS_CONTEXT (''USERENV'', ''IP_ADDRESS'', 15)
                                  INTO l_txmsg.wsname, l_txmsg.ipaddress
                                FROM DUAL;
                                SELECT BRID
                                  INTO l_txmsg.brid
                                FROM TLPROFILES where TLID=l_txmsg.tlid;
                                l_txmsg.off_line    := ''N'';
                                l_txmsg.deltd       := txnums.c_deltd_txnormal;
                                l_txmsg.txstatus    := txstatusnums.c_txpending;
                                l_txmsg.msgsts      := ''0''; l_txmsg.ovrsts      := ''0''; l_txmsg.ovrrqd      := ''@00'';
                                l_txmsg.batchname   := ''DAY'';
                                l_txmsg.txtime := to_char(sysdate,''hh24:mm:ss'');
                                l_txmsg.txnum    := '''||L_txnum||''';
                                l_txmsg.txdate:=to_date('''||v_strCURRDATE||''',systemnums.c_date_format);
                                l_txmsg.BUSDATE:=to_date('''||v_strCURRDATE||''',systemnums.c_date_format);
                                l_txmsg.tltxcd:='''||v_tltxcd||'''; ';


                           p_sqlcommand:=p_sqlcommand||' l_tltxfld_arrtype := pck_swift.buildtltxdata('||v_reqid||');
                            l_tltxfld_rectype:= l_tltxfld_arrtype (0) ;
                                  l_i := 0;
                                  LOOP

                                      l_tltxfld_rectype:= l_tltxfld_arrtype (l_i) ;
                                  
                                     l_txmsg.txfields (l_tltxfld_rectype.fldname).defname   := l_tltxfld_rectype.defname;
                                     l_txmsg.txfields (l_tltxfld_rectype.fldname).TYPE      := l_tltxfld_rectype.datatype;
                                     l_txmsg.txfields (l_tltxfld_rectype.fldname).value      :=  l_tltxfld_rectype.value;
                     
                                    l_i := l_i + 1;
                                    EXIT WHEN l_i > l_tltxfld_arrtype.count-1;

                                  END LOOP;    ' ;


                           p_sqlcommand:=p_sqlcommand|| ' IF txpks_#'||v_tltxcd||'.fn_txProcess(p_xmlmsg, p_err_code, l_err_param) <> systemnums.c_success THEN

                                                    UPDATE swiftmsgmaplog SET status=''E'', ERRORDESC= ''CBPlus:error:''||p_err_code||l_err_param   WHERE msgid = '''||v_reqid||''';
                                                    select en_errdesc  into l_err_param
                                                   from deferror where errnum = p_err_code;
                                              ELSE
                                                   UPDATE swiftmsgmaplog SET status=''C'' , reftxnum ='''||L_txnum||''', cftxnum ='''||L_txnum||''', cftxdate = to_date('''||v_strCURRDATE||''',systemnums.c_date_format) WHERE msgid = '''||v_reqid||''';
                                              END IF;

                        END;';


       EXECUTE IMMEDIATE p_sqlcommand;
       EXCEPTION when others THEN
              UPDATE swiftmsgmaplog SET status='E', ERRORDESC= 'CBPlus: process confirm error '  WHERE msgid = p_transactionnumber;
      end;
  end case;










    --plog.setbeginsection(pkgctx, p_sqlcommand);

    p_err_code:=0;
  commit;
   EXCEPTION when others THEN
        p_err_code := errnums.C_SYSTEM_ERROR;
        plog.error (pkgctx,p_transactionnumber || SQLERRM);
        UPDATE swiftmsgmaplog SET status='E', ERRORDESC= 'CBPlus: process confirm error '  WHERE msgid = p_transactionnumber;
   END;
   -- Enter further code below as specified in the Package spec.



 procedure sp_auto_gen_confirm_transact as
    p_err_code  VARCHAR2(50);
    cursor v_cursor is
      select msgid from swiftmsgmaplog where status = 'P' and rownum=1;
    v_row v_cursor%rowtype;
  begin
    plog.setbeginsection(pkgctx, 'sp_auto_gen_confirm_transact');

    open v_cursor;
    loop
      fetch v_cursor
        into v_row;
      exit when v_cursor%notfound;

      transact_Exec_Pending(v_row.msgid, p_err_code);
    end loop;


    plog.setendsection(pkgctx, 'sp_auto_gen_confirm_transact');
  exception
    when others then
      plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'sp_auto_gen_confirm_transact');
  end sp_auto_gen_confirm_transact;


function buildtltxdata (
     p_reqid       IN       varchar2
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
v_bankobj varchar2(10);
v_cbobj varchar2(10);
l_i                     NUMBER (10);
 l_tltxfld_arrtype tltxfld_arrtype;
 l_tltxfld_rectype tltxfld_rectype;
 v_isin varchar2(150);
 v_qtty varchar2(50);
 v_cifidfracct varchar2(50);
 v_toacct varchar2(50);
 v_biccodetoacct varchar2(50);
  v_ca_type varchar2(50);
 v_caid varchar2(50);
 v_cifid varchar2(50);
  v_senderbiccode varchar2(50);
  v_receivername varchar2(150);
BEGIN



select msgid,tltxcd
into v_transactionnumber,v_cbobj
from swiftmsgmaplog
where msgid= p_reqid;

case v_cbobj
when '2244'  then  -- truong hop goi giao dich chuyen khoan
 begin

                select
                        max(case when fldcd = '02' then defvalue else '' end ) isin ,
                        replace(max(case when fldcd = '03' then defvalue else '' end ),',','.') qtty,
                        max(case when fldcd = '05' then defvalue else '' end )cifidfracct,
                        max(case when fldcd = '06' then defvalue else '' end )toacct,
                        max(case when fldcd = '04' then defvalue else '' end )biccodetoacct,
                        max(case when fldcd = '08' then defvalue else '' end )receivername
                into  v_isin,v_qtty,v_cifidfracct,v_toacct,v_biccodetoacct,v_receivername
                from swiftmsgmaplogdtl
                where msgid = v_transactionnumber ;

--xu ly cat got du lieu
v_isin:=SUBSTR(v_isin,INSTR (v_isin,' ')+1,12);
v_qtty:=SUBSTR(v_qtty,INSTR (v_qtty,'/')+1);


           OPEN PV_REFCURSOR
                 FOR
                 select f.fldname,f.defname , f.datatype,
                  case when fldname='01' then  sb.codeid
                   when fldname='69' then  sb.symbol
                   when fldname='68' then  sb.symbol
                   when fldname='99' then  '001'
                   when fldname='16' then  sb.tradeplace
                   when fldname='02' then  cf.custid
                   when fldname='15' then  cf.custodycd
                   when fldname='03' then  se.acctno
                   when fldname='90' then  cf.fullname
                   when fldname='91' then  cf.address
                   when fldname='92' then  cf.idcode
                   when fldname='93' then  to_char(cf.iddate,'DD/MM/RRRR')
                   when fldname='94' then  cf.idplace
                   when fldname='78' then  cf.phone
                   when fldname='05' then  (select depositid from deposit_member where interbiccode = v_biccodetoacct and rownum=1)
                   when fldname='24' then  (select fullname from deposit_member where interbiccode = v_biccodetoacct and rownum=1)
                   when fldname='19' then  to_char(vs.ORGAMT)
                    when fldname='17' then  to_char(vs.BLOCKED)
                    when fldname='06' then  '0'
                    when fldname='21' then  to_char(vs.TRADE)
                     when fldname='10' then  trim(v_qtty)
                     when fldname='20' then  to_char(vs.ORGTRADEWTF)
                      when fldname='22' then  '0'
                      when fldname='13' then  to_char(vs.TRADEWTF)
                      when fldname='13' then  to_char(vs.PARVALUE)
                       when fldname='09' then  to_char(vs.PARVALUEE)
                        when fldname='12' then  v_qtty
                         when fldname='31' then  '013'
                          when fldname='44' then  '0'
                           when fldname='18' then  '0'
                            when fldname='66' then  '0'
                             when fldname='45' then  '0'
                              when fldname='67' then  'Y'
                               when fldname='46' then  '10'
                               when fldname='89' then  '0'
                               when fldname='47' then  '0'
                                when fldname='30' then  'Stock tranfer request from swift'
                               when fldname='88' then  v_toacct
                                when fldname='49' then  v_receivername
                              else '0'
                      end value ,1 length
              from fldmaster f,cfmast cf , semast se, sbsecurities sb, v_se2244 vs
              where objname =v_cbobj and cf.custid = se.custid and se.codeid = sb.codeid and cf.cifid = v_cifidfracct
              and sb.isincode =v_isin and  sb.tradeplace <> '006' and vs.codeid =se.codeid and vs.custodycd =cf.custodycd  ;


    --end case 2244---------------------------------------------------------

   end ;

when '3384'  then  -- truong hop goi giao dich dang ki quyen mua
 begin

                 select max(case when fldcd = '06' then defvalue else '' end ) CATYPE,
                        max(case when fldcd = '02' then defvalue else '' end ) CAID,
                        max(case when fldcd = '03' then defvalue else '' end ) CIFID,
                        replace(max(case when fldcd = '10' then substr(defvalue,instr(defvalue,'/')+1) else '' end ),',','.') QTTY
                 into  v_ca_type ,v_caid,v_cifid,v_qtty
                 from swiftmsgmaplogdtl where  msgid = v_transactionnumber;

  OPEN PV_REFCURSOR
                 FOR
                 select f.fldname,f.defname , f.datatype,
                  case when fldname='01' then  to_char(ca.AUTOID)
                       when fldname='02' then  v_caid
                       when fldname='03' then  ca.AFACCTNO
                       when fldname='04' then  ca.SYMBOL
                       when fldname='05' then  to_char(ca.EXPRICE)
                       when fldname='06' then  ca.SEACCTNO
                       when fldname='07' then  to_char(ca.MAXBALANCE)
                       when fldname='08' then  replace(ca.FULLNAME,'&','')
                       when fldname='09' then  ca.OPTSEACCTNO
                       when fldname='10' then  to_char(FN_GET_AMT_3384(v_caid,v_qtty,ca.EXPRICE))
                       when fldname='16' then  '3384'
                       when fldname='20' then  to_char(ca.MAXQTTY)
                       when fldname='21' then  to_char(FN_GET_QTTY_3384(v_caid,v_qtty))
                       when fldname='22' then  to_char(ca.PARVALUE)
                       when fldname='23' then  to_char(ca.REPORTDATE,'DD/MM/RRRR')
                       when fldname='24' then  ca.CODEID
                       when fldname='25' then  to_char(ca.AVLQTTY)
                       when fldname='26' then  to_char(ca.SUQTTY)
                       when fldname='30' then  FN_GEN_DESC_3384(ca.DESCRIPTION || ' by client', FN_GET_QTTY_3384(v_caid,v_qtty))
                       when fldname='31' then  dd.AFACCTNO
                       when fldname='40' then  'M'
                       when fldname='60' then  to_char(ca.ISCOREBANK)
                       when fldname='70' then  ca.PHONE
                       when fldname='71' then  ca.SYMBOL_ORG
                       when fldname='80' then  to_char(ca.BALANCE)
                       when fldname='81' then  v_qtty
                       when fldname='90' then  replace(ca.CUSTNAME,'&','')
                       when fldname='91' then  replace(ca.ADDRESS,'&','')
                       when fldname='92' then  ca.IDCODE
                       when fldname='93' then  to_char(ca.IDDATE,'DD/MM/RRRR')
                       when fldname='94' then  ca.IDPLACE
                       when fldname='95' then  ca.ISSNAME
                       when fldname='96' then  ca.CUSTODYCD
                       when fldname='97' then  cf.CIFID
                              else '0'
                      end value ,1 length
              from fldmaster f,cfmast cf , ddmast dd, vw_strade_ca_rightoff_3384 ca
              where objname =v_cbobj and cf.custodycd = ca.custodycd and cf.cifid = v_cifid
              and replace(ca.camastid,'.') =v_caid and dd.custodycd = cf.custodycd and dd.isdefault= 'Y'  ;


    --end case 2244---------------------------------------------------------

   end ;

when '3300' then
    begin

        select max(case when fldcd = '06' then defvalue else '' end ) CATYPE,
               max(case when fldcd = '02' then defvalue else '' end ) CAID,
               max(case when fldcd = '03' then defvalue else '' end ) CIFID,
               replace(max(case when fldcd = '10' then substr(defvalue,instr(defvalue,'/')+1) else '' end ),',','.') QTTY
        into  v_ca_type ,v_caid,v_cifid,v_qtty
        from swiftmsgmaplogdtl
        where msgid = v_transactionnumber;

    OPEN PV_REFCURSOR
    FOR
    select f.fldname, f.defname, f.datatype,
        case
        when fldname='01' then  sb1.codeid
        when fldname='03' then  v_caid
        when fldname='04' then  sb1.symbol
        when fldname='10' then  v_qtty
        when fldname='12' then  sb2.symbol
        when fldname='14' then  to_char(cs.balance + cs.pbalance + cs.OUTBALANCE - cs.INBALANCE)
        when fldname='15' then  to_char(cs.balance + cs.pbalance + cs.OUTBALANCE - cs.INBALANCE - NVL(CAN.QTTY, 0))
        when fldname='30' then  ca.DESCRIPTION || ' by client'
        when fldname='83' then  cf.cifid
        when fldname='88' then  cf.custodycd
        when fldname='90' then  cf.fullname
        else '0'
        end value, 1 length
    from fldmaster f, cfmast cf, afmast af, camast ca, caschd cs, sbsecurities sb1, sbsecurities sb2,
    (
        SELECT CAMASTID, CUSTODYCD, SUM(QTTY) QTTY FROM CACANCEL GROUP BY CAMASTID,CUSTODYCD
    ) CAN
    where ca.camastid = cs.camastid
    and cs.afacctno = af.acctno
    and af.custid = cf.custid
    and ca.tocodeid = sb1.codeid
    and ca.codeid = sb2.codeid
    and ca.camastid = v_caid
    and f.objname = v_cbobj
    and cf.cifid = v_cifid
    AND CA.CAMASTID = CAN.CAMASTID(+)
    AND CF.CUSTODYCD = CAN.CUSTODYCD(+);



    --end case 2244---------------------------------------------------------

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
    UPDATE swiftmsgmaplog SET status='E', ERRORDESC= p_reqid||'CBPlus: process confirm error when build data:'|| dbms_utility.format_error_backtrace  WHERE msgid = p_reqid;
       if pv_refcursor%ISOPEN THEN
            CLOSE pv_refcursor;
         END IF;
         return l_tltxfld_arrtype;
END buildtltxdata;
END;
/
