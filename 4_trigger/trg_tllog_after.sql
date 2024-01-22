SET DEFINE OFF;
CREATE OR REPLACE TRIGGER TRG_TLLOG_AFTER 
 AFTER
  INSERT OR UPDATE
 ON TLLOG
REFERENCING NEW AS NEWVAL OLD AS OLDVAL
 FOR EACH ROW
declare
  -- local variables here
  -- l_datasource varchar2(1000);
  l_msg_type varchar2(200);
   l_search  varchar2(100);
  l_trtype  varchar2(100);
  l_ISTRFCA  varchar2(100);
  l_autoid  number;
  l_countsymbol number;
  l_count2247 number;
  l_count2244 number;
  l_count2255 number;
  l_catype varchar2(50);
  l_SENDTOVSD varchar2(10);
  l_status varchar2(10);
  l_count number;
  l_NSDSTATUS varchar2(4);
  l_issendtovsd varchar2(3);
  pkgctx     plog.log_ctx;
  v_status1710 varchar2(10);
  v_bankcode varchar2(10);
  v_tltxcd varchar2(10);
  v_trfcode varchar2(50);
  v_catype varchar2(50);
  v_camastid varchar2(50);
  v_tradeplace varchar2(10);
  V_TRADEPLACE_CHECK number;
  v_sendswift varchar2(10);
  v_custodycd3351 varchar2(20);
  logrow     tlogdebug%ROWTYPE;
  l_camastid   varchar2(50);
  l_custody  varchar2(20);
  l_qtty     number;
  v_msgid   varchar2(50);
  v_custid   varchar2(50);
  v_sectype varchar2(30);
  l_countm NUMBER;
  v_mcustodycd varchar2(250);
  l_countmcustodycd number;
  l_countcustodycd_con_khac number;
  l_isonline varchar2(10);
  l_appendixid varchar2(100);
begin

  FOR i IN (SELECT * FROM tlogdebug) LOOP
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  END LOOP;
  pkgctx := plog.init('trg_tllog_after',
                      plevel           => NVL(logrow.loglevel, 30),
                      plogtable        => (NVL(logrow.log4table, 'N') = 'Y'),
                      palert           => (NVL(logrow.log4alert, 'N') = 'Y'),
                      ptrace           => (NVL(logrow.log4trace, 'N') = 'Y'));

  plog.setbeginsection(pkgctx, 'trg_tllog_after');
  ---locpt test nhac viec
  /*begin
  if :newval.txstatus = '4' then
     INSERT INTO payschedule
     --VALUES(seq_payschedule.NEXTVAL,:newval.tltxcd,'Hold cash','M',NULL,20,0,0,0,'Y',NULL,'MECNC','P','P','N',NULL,sysdate,'Y','3','N',:newval.txnum)
     select seq_payschedule.NEXTVAL,:newval.tltxcd,tll.en_txdesc,'M',NULL,20,0,0,0,'Y',NULL,'MECNC','P','P','N',NULL,sysdate,'Y','3','N',:newval.txnum
        from tltx tll where tll.tltxcd = :newval.tltxcd;
  elsif :newval.txstatus in( '1','2','5','8','9') then
     delete from payschedule where objlogid = :newval.txnum;
  end if;
  exception
  when others then
    plog.error(pkgctx, SQLERRM);
  end;*/
  --
  -----------------------------------------------
  ---------XU LY DONG BO DU LIEU SANG FA---------
  if :newval.txstatus = '1' and (:oldval.txstatus is null or :oldval.txstatus <> '1') then

    if  :newval.tltxcd IN ('3322','3376') THEN
         insert into log_notify_cbfa(GLOBALID,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime,busdate)
          values
            ('CB.'||TO_CHAR(:newval.txdate,'YYYYMMDD')||'.'||:newval.txnum,seq_log_notify_cbfa.nextval,'CAMAST','CAMASTID',:newval.msgacct,:newval.txdate,:newval.txnum,:newval.txdate,:newval.tltxcd,sysdate,:newval.busdate);
    ELSIF :NEWVAL.TLTXCD= '3370' OR :NEWVAL.TLTXCD= '3340' THEN
      select catype into v_catype from camast where camastid = :NEWVAL.msgacct;
      IF (v_catype IN ('014','023') AND :newval.tltxcd = '3370')
       OR (v_catype NOT IN ('014','023') AND :newval.tltxcd = '3340') THEN
        insert into log_notify_cbfa(GLOBALID,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime,busdate)
        VALUES ('CB.'||TO_CHAR(:newval.txdate,'YYYYMMDD')||'.'||:newval.txnum,seq_log_notify_cbfa.nextval,'CAMAST','CAMASTID',:newval.msgacct,:newval.txdate,:newval.txnum,:newval.txdate,:newval.tltxcd,sysdate,:newval.busdate);
      END IF;

    ELSIF  :newval.tltxcd IN ('1400') THEN
         select sb.tradeplace into v_tradeplace from sbsecurities sb
         where sb.codeid in (select cvalue from tllogfld where txnum = :newval.txnum and txdate = :newval.txdate and fldcd ='04');
         if v_tradeplace = '003' then
             insert into log_notify_cbfa(globalid,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime,busdate)
              values
                ('CB.'||to_char(:newval.txdate,'YYYYMMDD')||'.'||:newval.txnum,seq_log_notify_cbfa.nextval,'OTCODMAST','AUTOID',:newval.autoid,:newval.txdate,:newval.txnum,:newval.txdate,:newval.tltxcd,sysdate,:newval.busdate);
         end if;

    ELSIF :newval.tltxcd IN ('1444') THEN
        begin
            select FN_GET_TLLOGFLD_VALUE(:newval.txnum,:newval.txdate,'08','C') into l_appendixid from dual;
        exception
          when others then
            l_appendixid:= '0' ;
          end;
        insert into log_notify_cbfa(globalid,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime,busdate)
        values('CB.'||to_char(:newval.txdate,'YYYYMMDD')||'.'||:newval.txnum,seq_log_notify_cbfa.nextval,'CBFA_CANCELOTC','AUTOID',l_appendixid,:newval.txdate,:newval.txnum,:newval.txdate,:newval.tltxcd,sysdate,:newval.busdate);

    ELSIF  :newval.tltxcd IN ('2227','2228') THEN
         insert into log_notify_cbfa(GLOBALID,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime,busdate)
          values
            ('CB.'||TO_CHAR(:newval.txdate,'YYYYMMDD')||'.'||:newval.txnum,seq_log_notify_cbfa.nextval,'OTCCONFIRM','AUTOID',:newval.autoid,:newval.txdate,:newval.txnum,:newval.txdate,:newval.tltxcd,sysdate,:newval.busdate);
    ELSIF  :newval.tltxcd IN ('8893') THEN
         insert into log_notify_cbfa(GLOBALID,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime,busdate)
          values
            ('CB.'||TO_CHAR(:newval.txdate,'YYYYMMDD')||'.'||:newval.txnum,seq_log_notify_cbfa.nextval,'ODMAST','ORDERID',:newval.autoid,:newval.txdate,:newval.txnum,:newval.txdate,:newval.tltxcd,sysdate,:newval.busdate);
    ELSIF  :newval.tltxcd IN ('8894') THEN
         insert into log_notify_cbfa(GLOBALID,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime,busdate)
          values
            ('CB.'||TO_CHAR(:newval.txdate,'YYYYMMDD')||'.'||:newval.txnum,seq_log_notify_cbfa.nextval,'ODMASTETF','AUTOID',:newval.autoid,:newval.txdate,:newval.txnum,:newval.txdate,:newval.tltxcd,sysdate,:newval.busdate);
         insert into log_notify_cbfa(GLOBALID,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime,busdate)
          values
            ('CB.'||TO_CHAR(:newval.txdate,'YYYYMMDD')||'.'||:newval.txnum,seq_log_notify_cbfa.nextval,'AUTOCALL3322','AUTOID',:newval.autoid,:newval.txdate,:newval.txnum,:newval.txdate,:newval.tltxcd,sysdate,:newval.busdate);
    ELSIF  :newval.tltxcd IN ('8895') THEN --Huy ETF
         insert into log_notify_cbfa(GLOBALID,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime,busdate)
          values
            ('CB.'||TO_CHAR(:newval.txdate,'YYYYMMDD')||'.'||:newval.txnum,seq_log_notify_cbfa.nextval,'CANCELETF','AUTOID',:newval.autoid,:newval.txdate,:newval.txnum,:newval.txdate,:newval.tltxcd,sysdate,:newval.busdate);
         insert into log_notify_cbfa(GLOBALID,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime,busdate)
          values
            ('CB.'||TO_CHAR(:newval.txdate,'YYYYMMDD')||'.'||:newval.txnum,seq_log_notify_cbfa.nextval,'AUTOCALL3322','AUTOID',:newval.autoid,:newval.txdate,:newval.txnum,:newval.txdate,:newval.tltxcd,sysdate,:newval.busdate);
    ---cbfaconfimca
    ELSIF  :newval.tltxcd IN ('3333','3337','3385','3356','3341','3345') THEN
         insert into log_notify_cbfa(GLOBALID,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime,busdate)
          values
            ('CB.'||TO_CHAR(:newval.txdate,'YYYYMMDD')||'.'||:newval.txnum,seq_log_notify_cbfa.nextval,'CAALLOCATE','AUTOID',:newval.autoid,:newval.txdate,:newval.txnum,:newval.txdate,:newval.tltxcd,sysdate,:newval.busdate);
    ELSIF  :newval.tltxcd IN ('3384') THEN
         insert into log_notify_cbfa(GLOBALID,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime,busdate)
          values
            ('CB.'||TO_CHAR(:newval.txdate,'YYYYMMDD')||'.'||:newval.txnum,seq_log_notify_cbfa.nextval,'RIGHT_CAALLOCATE','AUTOID',:newval.autoid,:newval.txdate,:newval.txnum,:newval.txdate,:newval.tltxcd,sysdate,:newval.busdate);
    ELSIF  :newval.tltxcd IN ('3300') THEN
         insert into log_notify_cbfa(GLOBALID,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime,busdate)
          values
            ('CB.'||TO_CHAR(:newval.txdate,'YYYYMMDD')||'.'||:newval.txnum,seq_log_notify_cbfa.nextval,'RIGHT_CAALLOCATE','AUTOID',:newval.autoid,:newval.txdate,:newval.txnum,:newval.txdate,:newval.tltxcd,sysdate,:newval.busdate);
    ELSIF  :newval.tltxcd IN ('3386') THEN -- cancel right ca
         select cvalue into l_camastid from tllogfld where txnum = :newval.txnum and txdate = :newval.txdate and fldcd ='02';
         select cvalue into l_custody from tllogfld where txnum = :newval.txnum and txdate = :newval.txdate and fldcd ='96';
         select nvalue into l_qtty from tllogfld where txnum = :newval.txnum and txdate = :newval.txdate and fldcd ='21';
         insert into log_notify_cbfa(GLOBALID,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime,busdate)
          values
            ('CB.'||TO_CHAR(:newval.txdate,'YYYYMMDD')||'.'||:newval.txnum,seq_log_notify_cbfa.nextval,'RIGHT_CANCEL','AUTOID','CAMASTID.'||l_camastid||'.CUSTODYCD.'||l_custody||'.QTTY: '||l_qtty ,:newval.txdate,:newval.txnum,:newval.txdate,:newval.tltxcd,sysdate,:newval.busdate);
    ---H?p d?ng chuy?n nhu?ng quy?n mua
    ELSIF  :newval.tltxcd IN ('3383', '3303') THEN
         insert into log_notify_cbfa(GLOBALID,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime,busdate)
          values
            ('CB.'||TO_CHAR(:newval.txdate,'YYYYMMDD')||'.'||:newval.txnum,seq_log_notify_cbfa.nextval,'CATRANSFERCONFIRM','AUTOID',:newval.autoid,:newval.txdate,:newval.txnum,:newval.txdate,:newval.tltxcd,sysdate,:newval.busdate);
    ELSIF  :newval.tltxcd IN ('1407') THEN
        select sb.sectype, sb.tradeplace into v_sectype, v_tradeplace from sbsecurities sb
         where sb.codeid in (select cvalue from tllogfld where txnum = :newval.txnum and txdate = :newval.txdate and fldcd ='15');
         if v_sectype in ('009','013') then
             insert into log_notify_cbfa(globalid,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime,busdate)
              values
                ('CB.'||to_char(:newval.txdate,'YYYYMMDD')||'.'||:newval.txnum,seq_log_notify_cbfa.nextval,'CDGLMAST','AUTOID',:newval.autoid,:newval.txdate,:newval.txnum,:newval.txdate,:newval.tltxcd,sysdate,:newval.busdate);
         elsif v_tradeplace = '003' then
             insert into log_notify_cbfa(globalid,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime,busdate)
              values
                ('CB.'||to_char(:newval.txdate,'YYYYMMDD')||'.'||:newval.txnum,seq_log_notify_cbfa.nextval,'OTCODMAST','AUTOID',:newval.autoid,:newval.txdate,:newval.txnum,:newval.txdate,:newval.tltxcd,sysdate,:newval.busdate);
         end if;
    ELSIF  :newval.tltxcd IN ('1405','1406') THEN
         insert into log_notify_cbfa(GLOBALID,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime,busdate)
          values
            ('CB.'||TO_CHAR(:newval.txdate,'YYYYMMDD')||'.'||:newval.txnum,seq_log_notify_cbfa.nextval,'DOCSTRANFER','AUTOID',:newval.autoid,:newval.txdate,:newval.txnum,:newval.txdate,:newval.tltxcd,sysdate,:newval.busdate);
    ELSIF  :newval.tltxcd IN ('2208') THEN
         insert into log_notify_cbfa(GLOBALID,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime,busdate)
          values
            ('CB.'||TO_CHAR(:newval.txdate,'YYYYMMDD')||'.'||:newval.txnum,seq_log_notify_cbfa.nextval,'CBFA_CANCELOTC','AUTOID',:newval.autoid,:newval.txdate,:newval.txnum,:newval.txdate,:newval.tltxcd,sysdate,:newval.busdate);
    ELSIF  :newval.tltxcd IN ('8803') THEN
         insert into log_notify_cbfa(GLOBALID,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime,busdate)
          values
            ('CB.'||TO_CHAR(:newval.txdate,'YYYYMMDD')||'.'||:newval.txnum,seq_log_notify_cbfa.nextval,'CBFA_CANCELLISTED','AUTOID',:newval.autoid,:newval.txdate,:newval.txnum,:newval.txdate,:newval.tltxcd,sysdate,:newval.busdate);
    ELSIF  :newval.tltxcd IN ('2245','2266','2242') THEN --oddlot-exchange
         insert into log_notify_cbfa(GLOBALID,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime,busdate)
          values
            ('CB.'||TO_CHAR(:newval.txdate,'YYYYMMDD')||'.'||:newval.txnum,seq_log_notify_cbfa.nextval,'CBFAODDEXCHANGE','AUTOID',:newval.autoid,:newval.txdate,:newval.txnum,:newval.txdate,:newval.tltxcd,sysdate,:newval.busdate);
    ELSIF  :newval.tltxcd IN ('6615') THEN --trung.luu: 07-08-2020  Revert CITAD
         insert into log_notify_cbfa(GLOBALID,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime,busdate)
          values
            ('CB.'||TO_CHAR(:newval.txdate,'YYYYMMDD')||'.'||:newval.txnum,seq_log_notify_cbfa.nextval,'CRBTXREQ_CITAD_REVERT','REQID',:newval.msgacct,:newval.txdate,:newval.txnum,:newval.txdate,:newval.tltxcd,sysdate,:newval.busdate);
    /*ELSIF :newval.busdate < getcurrdate THEN
         insert into log_notify_cbfa(GLOBALID,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime,busdate)
          values
            ('CB.'||TO_CHAR(:newval.txdate,'YYYYMMDD')||'.'||:newval.txnum,seq_log_notify_cbfa.nextval,'CBFA_BUSDATE','AUTOID',:newval.autoid,:newval.txdate,:newval.txnum,:newval.txdate,:newval.tltxcd,sysdate,:newval.busdate);*/
  end if;
  end if;

  -- for revert
  IF :oldval.deltd ='N' AND :newval.deltd ='Y' and :oldval.txstatus = 1 and :oldval.tltxcd not in ('2212','2213') then
         insert into log_notify_cbfa(GLOBALID,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime,busdate)
          values
            ('CB.'||TO_CHAR(:newval.txdate,'YYYYMMDD')||'.'||:newval.txnum,seq_log_notify_cbfa.nextval,'REVERTTRAN','AUTOID',:newval.autoid,:newval.txdate,:newval.txnum,:newval.txdate,:newval.tltxcd,sysdate,:newval.busdate);
  end if;

    --XOA GIAO DICH
  ----------------------
  --Bo bat trigger DDTRAN luong dong bo
 /* if :newval.txstatus = '7' and :newval.deltd = 'Y' and :oldval.deltd = 'N' then
    if  :newval.tltxcd LIKE '66%' THEN
        --Giao dich lien quan den bao no bao co ddtran
        SELECT COUNT(*) INTO l_count FROM ddtran d, v_appmap_by_tltxcd v
        WHERE d.txnum = :newval.txnum AND d.txdate= :newval.txdate
        AND d.tltxcd = v.tltxcd AND v.field ='BALANCE' AND v.tblname ='DDMAST';
        IF l_count >0 THEN
          insert into log_notify_cbfa(GLOBALID,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd)
          values
            ('CB.'||TO_CHAR(:newval.txdate,'YYYYMMDD')||'.'||:newval.txnum,seq_log_notify_cbfa.nextval,'BANKADVICETX','TXNUM',:newval.txnum,'DELETE',:newval.txnum,:newval.txdate,:newval.tltxcd);
        END IF;
    end if;
  end if;*/
  ----------------------
    if :newval.txstatus = '7' and :newval.deltd = 'Y' and :oldval.deltd = 'N' then
        if :newval.tltxcd in ('1407','1400') then
            insert into log_notify_cbfa(globalid,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime,busdate)
            values('CB.'||to_char(:newval.txdate,'YYYYMMDD')||'.'||:newval.txnum,seq_log_notify_cbfa.nextval,'CBFA_CANCELOTC','AUTOID',:newval.autoid,:newval.txdate,:newval.txnum,:newval.txdate,:newval.tltxcd,sysdate,:newval.busdate);
        ELSIF :newval.tltxcd IN ('2245','2266','2242') THEN
            insert into log_notify_cbfa(GLOBALID,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime,busdate)
            values ('CB.'||TO_CHAR(:newval.txdate,'YYYYMMDD')||'.'||:newval.txnum,seq_log_notify_cbfa.nextval,'CBFAODDEXCHANGE_DELETE','AUTOID',:newval.autoid,:newval.txdate,:newval.txnum,:newval.txdate,:newval.tltxcd,sysdate,:newval.busdate);
        END IF;
    end if;
  -------------------KET THUC XU LY DONG BO SANG FA---------
   --------------------------------------------------------

  if :newval.txstatus = '1' and (:oldval.txstatus is null or :oldval.txstatus <> '1') then
    begin
      select msgtype
        into l_msg_type
        from tltx
       where tltxcd = :newval.tltxcd;
    exception
      when NO_DATA_FOUND then
        l_msg_type := '';
    end;

    --if length(l_msg_type) > 0 AND (:newval.tltxcd NOT IN ('2242','1120','1130', '8868') OR :newval.tltxcd IN ('1131','1132','1101','1104', '1111','1179')) then
    --26/08/2015 DieuNDA Cap nhat them 1 so giao dich duoc gui SMS
    if length(l_msg_type) > 0
            AND :newval.tltxcd IN ('1293','2244','2257','2200','2242','2245','2246')
    then
      insert into log_notify_event
        (autoid,
         msgtype,
         keyvalue,
         status,
         CommandType,
         CommandText,
         logtime)
      values
        (seq_log_notify_event.nextval,
         'TRANSACT',
         :newval.txnum,
         'A',
         'P',
         'GENERATE_TEMPLATES',
         sysdate);

      nmpks_ems.pr_transferwarning(:newval.tltxcd, :newval.txnum);
    end if;
  end if;
  --------------------------------------------------------
   --------------------------------------------------------
    --VSD MSG
  if :NEWVAL.deltd <> 'Y' and :newval.txstatus = '1' and (:oldval.txstatus is null or :oldval.txstatus <> '1')
    THEN
      -- PHuongHT edit for VSD  --> locpt add bankcode = VSD --> doan nay chi sinh dien cho VSD
    SELECT COUNT(*) INTO L_COUNT FROM VSDTRFCODE VSD WHERE VSD.TLTXCD=:NEWVAL.TLTXCD AND VSD.STATUS='Y' AND VSD.TYPE IN ('REQ','EXREQ') and bankcode = 'VSD';

    IF L_COUNT >0 THEN
    l_search := '%';
        -- VuTN xu ly rieng cho gd 2255
        if instr('/2255/', :newval.tltxcd) > 0 then
            select nvalue into l_autoid
            from tllogfld
            where txnum = :newval.txnum and fldcd = '18';


           select trtype into l_trtype from sesendout where AUTOID = l_autoid;
            -- l_trtype = '014': chuyen khoan khong tat toan tai khoan
            if l_trtype = '014'  then
                select count(1) into l_count2244 from v_se2244 where custodycd = :newval.cfcustodycd;

                SELECT COUNT(1) into l_count2255
                FROM SESENDOUT SEO, CFMAST CF, AFMAST AF, SBSECURITIES SEC,SEMAST SE
                WHERE SUBSTR(SEO.ACCTNO,0,10)=AF.ACCTNO
                AND AF.CUSTID=CF.CUSTID
                AND SEC.CODEID=SEO.CODEID
                AND SE.ACCTNO=SEO.ACCTNO
                AND SEO.TRADE+SEO.BLOCKED+SEO.CAQTTY>0
                AND DELTD ='N' AND CF.CUSTODYCD = :newval.cfcustodycd;

                if l_count2244 = 0 and l_count2255 = 0 then
                    l_search:= '598.NEWM.ACCT//TWAC';
                else
                    l_search:='';
                end if;
            else
                select case
                       when instr(symbol, '_WFT') > 0 then
                        '%CLAS//PEND%'
                       else
                        '%CLAS//NORM%'
                     end
                into l_search
                from sbsecurities
               where codeid = :newval.ccyusage;
            end if;

            --29/01/2018 DieuNDA: Them truong co sinh dien gui VSD hay khong
               select SENDTOVSD into l_issendtoVSD
               from SE2255_LOG
               where txdate = :newval.txdate and txnum = :newval.txnum and deltd <> 'Y';

               if nvl(l_issendtoVSD,'N') <> 'Y' then
                    l_search := '';
               end if;
               --End 29/01/2018 DieuNDA

        -- Neu la cac giao dich Gui, Rut, Chuyen khoan CK WFT
        elsif instr('/2241/2292/8815/', :newval.tltxcd) > 0 then
            begin
              select case
                       when instr(symbol, '_WFT') > 0 then
                        '%CLAS//PEND%'
                       else
                        '%CLAS//NORM%'
                     end
                into l_search
                from sbsecurities
               where codeid = :newval.ccyusage;
            exception
              when no_data_found then
                l_search := '%CLAS//NORM%';
            end;
        elsif instr('/2247/', :newval.tltxcd) > 0 then



            --so luong dong da lam tren 2247
            select count(1) into l_count2247
            from V_SE2290
            where custodycd = :newval.cfcustodycd;

            --so luong dong con lai tren 2247
            --:newval.cfcustodycd la tai khoan con
            select count(1) into l_count from v_se2247 where custodycd = :newval.cfcustodycd;
            --TRUNG.LUU: 24-02-2021 TRUONG HOP  :newval.cfcustodycd LA TAI KHOAN ME
            select  count(1) into l_countm from v_se2247 where MCUSTODYCD = :newval.cfcustodycd;


            --truong hop :newval.cfcustodycd la tai khoan con nhung thuoc tai khoan me( co nhieu con)
            select custodycd into v_mcustodycd From vw_cfmast_m where custodycd_org = :newval.cfcustodycd;
            SELECT COUNT(1) INTO l_countcustodycd_con_khac from v_se2247 where MCUSTODYCD = v_mcustodycd;
            --count chinh tai khoan me
            SELECT COUNT(1) INTO l_countmcustodycd from v_se2247 where CUSTODYCD = v_mcustodycd;

            if l_count2247 >0 and l_count = 0 and l_countm = 0 and l_countcustodycd_con_khac = 0 and l_countmcustodycd = 0 then
                l_search:= '598.NEWM.ACCT//TBAC';
            else
                l_search:= '';
            end if;
        /*elsif instr('/3340/', :newval.tltxcd) > 0 then
            select catype into l_catype from camast where camastid = :newval.msgacct;
            --l_catype = '014': quyen mua, neu la quyen mua thi k sinh dien xac nhan
            if l_catype = '014' then
                l_search:= '';
            end if;
        elsif instr('/3376/', :newval.tltxcd) > 0 then
            select status into l_status from camast where camastid = :newval.msgacct;
            --l_status <> 'A': da lam buoc xac nhan 3370 hoan 3340 thi luc huy khong sinh dien huy
            if l_status <> 'A' then
                l_search:= '';
            end if;*/
        elsif instr('/0059/', :newval.tltxcd) > 0 then
            select nsdstatus into l_NSDSTATUS
            from cfmast
            where custid = :newval.msgacct;
            if l_NSDSTATUS = 'C' then
                l_search:= '';
            else
                update cfmast set nsdstatus = 'S' where custodycd = :newval.msgacct;
            end if;
        -- Thoai.tran 30/05/2022 -- SHBVNEX-2678
        -- Gui VSD 2236, 2237
        elsif instr('/2236/2237/', :newval.tltxcd) > 0 then
            l_issendtoVSD:= FN_GET_TLLOGFLD_VALUE(:newval.txnum,:newval.txdate,'72','C');
            if l_issendtoVSD = 'N' then
                l_search:= '';
            end if;
        end if;
        -- neu la ca giao dich mo, dong, kich hoat lai tk thi chuyen trang thai tk thanh da sinh dien
        if instr('/0035/0167/', :newval.tltxcd) > 0 then
            update cfmast set nsdstatus = 'S' where custodycd = :newval.msgacct;
        end if;
       FOR REC IN (
                  SELECT TRFCODE, BANKCODE FROM VSDTRFCODE WHERE TLTXCD=:NEWVAL.TLTXCD AND STATUS='Y' AND (TYPE = 'REQ'
                   AND TRFCODE LIKE L_SEARCH) OR (TYPE = 'EXREQ' AND TLTXCD=:NEWVAL.TLTXCD))
       LOOP
           Insert into VSD_PROCESS_LOG(AUTOID,TRFCODE,TLTXCD,TXNUM,TXDATE,PROCESS,MSGACCT,BRID,TLID,BANKCODE)
           values (SEQ_VSD_PROCESS_LOG.NEXTVAL,REC.TRFCODE,:NEWVAL.TLTXCD,:NEWVAL.TXNUM,GETCURRDATE,'N',nvl(:NEWVAL.CFCUSTODYCD, :NEWVAL.MSGACCT),:NEWVAL.BRID,:NEWVAL.TLID, REC.BANKCODE);
       END LOOP;
    END IF;
    -- end of PhuongHT edit
    END IF;

    ----locpt add doan xu ly rieng cho dien CBP gui qua corebank=============================================================
    ---- doan nay se chia ra lam 2 case : accept vs reject
    --BANK MSG

 if     (:newval.txstatus = '1' and (:oldval.txstatus is null or :oldval.txstatus <> '1' or (:oldval.deltd = 'N' AND :newval.deltd = 'Y' and :newval.tltxcd in ('3350','3354'))))
    or  (:newval.txstatus = '5' and (:oldval.txstatus is null or :oldval.txstatus <> '5'))
 THEN
         --> locpt add bankcode = CBP --> doan nay chi sinh dien cho CBP
    SELECT COUNT(*) INTO L_COUNT FROM VSDTRFCODE VSD WHERE VSD.TLTXCD=:NEWVAL.TLTXCD AND VSD.STATUS='Y' AND VSD.TYPE IN ('REQ','REJ') and bankcode = 'CBP';

    if (:NEWVAL.TLTXCD= '3389') then  ---update
        select cvalue into v_camastid
        from tllogfld where txnum= :NEWVAL.TXNUM and fldcd = '03';
        --check xem chung khoan co phai la OTC ko

        SELECT COUNT(1) INTO V_TRADEPLACE_CHECK
        FROM SBSECURITIES SB, CAMAST CA
        WHERE CA.CODEID = SB.CODEID
        AND SB.TRADEPLACE = '003'
        AND SB.DEPOSITORY <> '001'
        AND CA.CAMASTID = v_camastid;

        if V_TRADEPLACE_CHECK > 0 then
            return;  --neu la OTC thi ko swift ji ca
        end if;

        select catype into v_catype from camast where camastid = v_camastid;

        if  v_catype='023' THEN  ---   Chuy?n d?i TP ch?n nh?n ti?n ho?c CP
            v_trfcode:= '564.CORP.NOTF.BOND';
        elsif v_catype='014' THEN --quyen mua
            v_trfcode:= '564.CORP.NOTF.QM';
        ELSE
            v_trfcode:= '';
        end if;


              FOR caschslist IN (
                          SELECT *  from caschd
                          WHERE camastid =v_camastid and deltd='N' and pqtty > 0)
               LOOP
                    select trim(nvl(cf.sendswift,'N')) into v_sendswift
                    from cfmast cf, afmast af
                    where cf.custid = af.custid and af.acctno =caschslist.afacctno ;


                if  trim(v_sendswift)= 'Y' then
                   FOR REC IN (
                              SELECT TRFCODE, BANKCODE,TLTXCD FROM VSDTRFCODE VSD
                              WHERE trfcode=v_trfcode AND VSD.STATUS='Y' AND VSD.TYPE ='REQ' and bankcode = 'CBP')
                   LOOP
                        UPDATE caschd set swiftclient = 'U' where camastid =v_camastid and deltd='N';
                       Insert into VSD_PROCESS_LOG(AUTOID,TRFCODE,TLTXCD,TXNUM,TXDATE,PROCESS,MSGACCT,BRID,TLID,BANKCODE,REFOBJ)
                       values (SEQ_VSD_PROCESS_LOG.NEXTVAL,REC.TRFCODE,REC.TLTXCD,caschslist.AUTOID,GETCURRDATE,'N',caschslist.afacctno,'0001','0001', REC.BANKCODE,'CASCHD');
                   END LOOP;
                 end if;
             END LOOP;

    -- xu ly rieng cho giao dich 3370 va 3340
    elsif (:NEWVAL.TLTXCD= '3370'  or  :NEWVAL.TLTXCD= '3340'  ) then
        --check xem chung khoan co phai la OTC ko
        SELECT COUNT(1) INTO V_TRADEPLACE_CHECK
        FROM SBSECURITIES SB, CAMAST CA
        WHERE CA.CODEID = SB.CODEID
        AND SB.TRADEPLACE = '003'
        AND SB.DEPOSITORY <> '001'
        AND CA.CAMASTID = :NEWVAL.msgacct;

        if V_TRADEPLACE_CHECK > 0 then
            return;  --neu la OTC thi ko swift ji ca
        end if;

            select catype into v_catype from camast where camastid = :NEWVAL.msgacct;
                 CASE
                          WHEN v_catype='023' and :NEWVAL.TLTXCD= '3370'  THEN  ---   Chuy?n d?i TP ch?n nh?n ti?n ho?c CP
                            v_trfcode:= '564.CORP.REPE.BOND';
                          WHEN v_catype='010' or v_catype='016' or v_catype='015' or v_catype='027' or v_catype='024' THEN  -- s? ki?n Chia c? t?c = ti?n, Tr? l¿tr¿phi?u, Tr? g?c v¿¿TP (Gi?i th? TCPH):
                            v_trfcode:= '564.CORP.REPE.TIEN';
                          WHEN v_catype='011'or v_catype='021' or v_catype='017' or v_catype='020' THEN --Chia c? t?c = CP, CP thu?ng, Ho¿d?i TP th¿ CP, Ho¿d?i CP th¿ CP
                            v_trfcode:= '564.CORP.REPE.CP';
                         WHEN v_catype='014' and :NEWVAL.TLTXCD= '3370' THEN --quyen mua
                            v_trfcode:= '564.CORP.REPE.QM';
                         WHEN v_catype='005'or v_catype='028' or v_catype='006' THEN
                            v_trfcode:= '564.CORP.REPE.ANN';
                         ELSE
                            v_trfcode:= '';
                        eND case;


         SELECT COUNT(*)
                    INTO L_COUNT
                    FROM VSDTRFCODE VSD WHERE trfcode=v_trfcode AND VSD.STATUS='Y' AND VSD.TYPE ='REQ' and bankcode = 'CBP';

                    IF L_COUNT >0 THEN

                     SELECT  max(BANKCODE),max(TLTXCD)
                    INTO v_bankcode,v_tltxcd
                    FROM VSDTRFCODE VSD WHERE trfcode=v_trfcode AND VSD.STATUS='Y' AND VSD.TYPE ='REQ' and bankcode = 'CBP';

                       FOR REC IN (
                                  SELECT * FROM caschd
                                  WHERE camastid =:NEWVAL.msgacct  and deltd = 'N')
                       LOOP

                          select trim(nvl(cf.sendswift,'N')) into v_sendswift
                          from cfmast cf, afmast af
                          where cf.custid = af.custid and af.acctno =REC.afacctno ;
                      if  trim(v_sendswift)= 'Y' then
                           Insert into VSD_PROCESS_LOG(AUTOID,TRFCODE,TLTXCD,TXNUM,TXDATE,PROCESS,MSGACCT,BRID,TLID,BANKCODE,refobj)
                           values (SEQ_VSD_PROCESS_LOG.NEXTVAL,v_trfcode,v_tltxcd,rec.AUTOID,GETCURRDATE,'N',rec.afacctno,'0001','0001', v_bankcode,'CASCHD');
                           update caschd set swiftclient='R' where autoid =rec.AUTOID;
                       end if;
                       END LOOP;
                    END IF;


    L_COUNT:=0; --- gan de phia sau ko xu ly nua

     ---end xu ly rieng ch0 3370 3340===============================


    elsif (:NEWVAL.TLTXCD= '3350'  or :NEWVAL.TLTXCD= '3354')   then
        select cvalue into v_camastid
        from tllogfld where txnum= :NEWVAL.TXNUM and fldcd = '02';

        --check xem chung khoan co phai la OTC ko
        SELECT COUNT(1) INTO V_TRADEPLACE_CHECK
        FROM SBSECURITIES SB, CAMAST CA
        WHERE CA.CODEID = SB.CODEID
        AND SB.TRADEPLACE = '003'
        AND SB.DEPOSITORY <> '001'
        AND CA.CAMASTID = v_camastid;

        if V_TRADEPLACE_CHECK > 0 then
            return;  --neu la OTC thi ko swift ji ca
        end if;

                 ----------------xu ly rieng cho 3350 3354 --> mac dinh di tien    MT566: Corporate Action Confirmation====================
         v_trfcode:= '566.CORP.CONF.TIEN';
           select trim(nvl(cf.sendswift,'N')), cf.custid into v_sendswift, v_custid
           from cfmast cf
           where custodycd in (select cvalue from tllogfld where txnum= :NEWVAL.TXNUM and fldcd = '19');


                if  trim(v_sendswift)= 'Y' then

                   FOR REC IN ( SELECT TRFCODE,TLTXCD, BANKCODE FROM VSDTRFCODE WHERE trfcode = v_trfcode AND STATUS='Y' and bankcode = 'CBP' and vsdmt = '566')
                LOOP

                INSERT INTO vsd_process_log (autoid,
                                             trfcode,
                                             tltxcd,
                                             txnum,
                                             txdate,
                                             process,
                                             msgacct,
                                             brid,
                                             tlid,
                                             bankcode)
                  VALUES   (seq_vsd_process_log.NEXTVAL,
                            rec.trfcode,
                            rec.tltxcd,
                            :newval.txnum,
                            getcurrdate,
                            'N',
                            v_custid,
                            :newval.brid,
                            :newval.tlid,
                            rec.bankcode);

                END LOOP;
            end if;
                L_COUNT:=0;

     elsif  :NEWVAL.TLTXCD= '3351'    then

        select cvalue into v_camastid
        from tllogfld where txnum= :NEWVAL.TXNUM and fldcd = '02';

        select cvalue into v_custodycd3351
        from tllogfld where txnum= :NEWVAL.TXNUM and fldcd = '19';
        --check xem chung khoan co phai la OTC ko

        SELECT COUNT(1) INTO V_TRADEPLACE_CHECK
        FROM SBSECURITIES SB, CAMAST CA
        WHERE CA.CODEID = SB.CODEID
        AND SB.TRADEPLACE = '003'
        AND SB.DEPOSITORY <> '001'
        AND CA.CAMASTID = v_camastid;

        if V_TRADEPLACE_CHECK > 0 then
            return;  --neu la OTC thi ko swift ji ca
        end if;

            select trim(nvl(cf.sendswift,'N')), cf.custid into v_sendswift, v_custid
            from cfmast cf
            where cf.custodycd = v_custodycd3351 ;
          if v_sendswift='N' then
            return;  -- ko swift ji ca
          end if;

            select cvalue into v_catype
            from tllogfld where txnum= :NEWVAL.TXNUM and fldcd = '22';
                 ----------------xu ly rieng cho 3351     MT566: Corporate Action Confirmation====================
                        CASE
                          WHEN v_catype='011' or v_catype='021'  THEN  -- s? ki?n Chia c? t?c = ti?n, Tr? l¿tr¿phi?u, Tr? g?c v¿¿TP (Gi?i th? TCPH):
                            v_trfcode:= '566.CORP.CONF.CP';
                          WHEN v_catype='016' or v_catype='017'or v_catype='020' or v_catype='014' or v_catype='023' or v_catype='027' THEN --Chia c? t?c = CP, CP thu?ng, Ho¿d?i TP th¿ CP, Ho¿d?i CP th¿ CP
                            v_trfcode:= '566.CORP.CONF.BOND';
                          eND case;

                FOR REC IN ( SELECT TRFCODE,TLTXCD, BANKCODE FROM VSDTRFCODE WHERE trfcode = v_trfcode AND STATUS='Y' and bankcode = 'CBP' and vsdmt = '566')
                LOOP

                INSERT INTO vsd_process_log (autoid,
                                             trfcode,
                                             tltxcd,
                                             txnum,
                                             txdate,
                                             process,
                                             msgacct,
                                             brid,
                                             tlid,
                                             bankcode)
                  VALUES   (seq_vsd_process_log.NEXTVAL,
                            rec.trfcode,
                            rec.tltxcd,
                            :newval.txnum,
                            getcurrdate,
                            'N',
                            v_custid,
                            :newval.brid,
                            :newval.tlid,
                            rec.bankcode);

                END LOOP;
                L_COUNT:=0;

    end if;  ---end xu ly rieng ch0 3351 ===============================



         IF L_COUNT >0 THEN
              IF :NEWVAL.TLTXCD='1710' THEN  -- giao dich 1710 xu ly dac biet vi rat nhiu truong hop
                 l_search:= '%';
                 v_trfcode:='%';
                 select cvalue into v_status1710  -- trang thai xac nhan cua giao dich 1710
                 from tllogfld where txnum = :NEWVAL.txnum and fldcd = '10';

                 select cvalue into v_msgid  -- msgid cua giao dich 1710
                 from tllogfld where txnum = :NEWVAL.txnum and fldcd = '01';

                 case  :NEWVAL.msgamt
                    when '565' then
                        select defvalue into l_catype
                        from swiftmsgmaplogdtl where msgid = v_msgid and rownum = 1 and defname = 'GENL.22F.CAEV';
                        l_search:= '567';
                        case l_catype
                            when 'CONV' then
                                v_trfcode:='567.NEWM.CAEV//BOND';
                                v_status1710:='C';
                            when 'RHTS' then
                                v_trfcode:='';
                                l_search:= '';
                            else
                                v_trfcode:='567.NEWM.CAEV//PROXY.VOTING';
                                v_status1710:='C';
                       end case;
                    when '540' then
                        if v_status1710 = 'C' then
                           l_search:= '544';
                        else
                           l_search:= '548';
                           v_trfcode:='548.SET.STATUS1710';
                        end if;
                    when '541' then
                        if v_status1710 = 'R' then
                           l_search:= '548';
                           v_trfcode:='548.SET.STATUS.BSR.EJECT';
                        else
                           l_search:= '545';
                        end if;
                    when '542' then
                        if v_status1710 = 'R' then
                           l_search:= '548';
                           v_trfcode:='548.SET.STATUS1710';
                        end if;
                    when '543' then
                        if v_status1710 = 'R' then
                           l_search:= '548';
                           v_trfcode:='548.SET.STATUS.BSR.EJECT';
                        else
                           l_search:= '547';
                        end if;
                    when '380' then
                        if v_status1710 = 'R' then
                           l_search:= '599';
                           v_trfcode:='599.FREE';
                           UPDATE tbl_mt380_inf SET status = 'R' WHERE reqid = :NEWVAL.MSGACCT AND status = 'P';
                        end if;
                 end case;

                 FOR REC IN (
                              SELECT TRFCODE, BANKCODE FROM VSDTRFCODE WHERE TLTXCD=:NEWVAL.TLTXCD AND STATUS='Y'
                              AND ((TYPE = 'REQ' and v_status1710 = 'C')  OR (TYPE = 'REJ' AND v_status1710 = 'R')) --confirm voi status C va rej voi status R
                              and TLTXCD=:NEWVAL.TLTXCD and vsdmt = l_search and trfcode like v_trfcode)
                   LOOP
                       Insert into VSD_PROCESS_LOG(AUTOID,TRFCODE,TLTXCD,TXNUM,TXDATE,PROCESS,MSGACCT,BRID,TLID,BANKCODE)
                       values (SEQ_VSD_PROCESS_LOG.NEXTVAL,REC.TRFCODE,:NEWVAL.TLTXCD,:NEWVAL.TXNUM,GETCURRDATE,'N',nvl(:NEWVAL.CFCUSTODYCD, :NEWVAL.MSGACCT),:NEWVAL.BRID,:NEWVAL.TLID, REC.BANKCODE);
                 END LOOP;
              ELSIF :newval.tltxcd = '1720' THEN
                 FOR REC IN (SELECT TRFCODE, BANKCODE FROM VSDTRFCODE WHERE TLTXCD=:NEWVAL.TLTXCD AND STATUS='Y' AND TYPE = 'REQ')
                 LOOP
                    select cvalue into l_isonline
                    from tllogfld
                    where txnum = :newval.txnum
                    and fldcd = '11';

                    IF l_isonline = 'N' THEN
                        Insert into VSD_PROCESS_LOG(AUTOID,TRFCODE,TLTXCD,TXNUM,TXDATE,PROCESS,MSGACCT,BRID,TLID,BANKCODE)
                        values (SEQ_VSD_PROCESS_LOG.NEXTVAL,REC.TRFCODE,:NEWVAL.TLTXCD,:NEWVAL.TXNUM,GETCURRDATE,'N',nvl(:NEWVAL.CFCUSTODYCD, :NEWVAL.MSGACCT),:NEWVAL.BRID,:NEWVAL.TLID, REC.BANKCODE);
                    END IF;
                 END LOOP;
             ELSE  --- cac giao dich con lai
              --update swiftmsgmaplog
                if ( :NEWVAL.TLTXCD in ('3384','3300')) or (:NEWVAL.TLTXCD= '2244' and :newval.txstatus = '1') then
                    L_COUNT:=0;
                    SELECT COUNT(*) INTO L_COUNT
                    FROM swiftmsgmaplog VSD
                    WHERE VSD.reftxnum = :NEWVAL.txnum;

                    if L_COUNT >0 then
                        FOR REC IN (
                            SELECT TRFCODE, BANKCODE
                            FROM VSDTRFCODE
                            WHERE TLTXCD=:NEWVAL.TLTXCD AND STATUS='Y'
                            AND (TYPE = 'REQ' and (:newval.txstatus = '1' OR :newval.txstatus = '5')) --confirm voi status 1 va rej voi status 5
                            and TLTXCD=:NEWVAL.TLTXCD
                        )
                        LOOP
                            Insert into VSD_PROCESS_LOG(AUTOID,TRFCODE,TLTXCD,TXNUM,TXDATE,PROCESS,MSGACCT,BRID,TLID,BANKCODE)
                            values (SEQ_VSD_PROCESS_LOG.NEXTVAL,REC.TRFCODE,:NEWVAL.TLTXCD,:NEWVAL.TXNUM,GETCURRDATE,'N',nvl(:NEWVAL.CFCUSTODYCD, :NEWVAL.MSGACCT),:NEWVAL.BRID,:NEWVAL.TLID, REC.BANKCODE);
                        END LOOP;

                        update swiftmsgmaplog set cfnstatus = case when :newval.txstatus = '1'  then 'C' else 'R' end
                        where reftxnum = :newval.txnum;
                    end if;
                end if;
              END IF;
         end if;
    end if;  ---end locpt add doan xu ly rieng cho dien CBP gui qua corebank
exception
  when others then
    plog.error(pkgctx, SQLERRM);
    plog.setEndSection(pkgctx, 'trg_tllog_after');
end;
/
