SET DEFINE OFF;
CREATE OR REPLACE TRIGGER TRG_CASCHD_LIST_BF_FORSWIFT 
 BEFORE
  INSERT OR UPDATE
 ON caschd_list
REFERENCING NEW AS NEWVAL OLD AS OLD
 FOR EACH ROW
declare
l_count number;
v_trfcode varchar2(500);
v_tltxcd varchar2(50);
v_catype varchar2(50);
pkgctx plog.log_ctx;
v_sendswift varchar2(4);
V_TRADEPLACE_CHECK number;
logrow     tlogdebug%ROWTYPE;
begin

  FOR i IN (SELECT * FROM tlogdebug) LOOP
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  END LOOP;
  pkgctx := plog.init('trg_caschd_after',
                      plevel           => NVL(logrow.loglevel, 30),
                      plogtable        => (NVL(logrow.log4table, 'N') = 'Y'),
                      palert           => (NVL(logrow.log4alert, 'N') = 'Y'),
                      ptrace           => (NVL(logrow.log4trace, 'N') = 'Y'));

  plog.setbeginsection(pkgctx, 'trg_caschd_after');


  --check xem chung khoan co phai la OTC ko
    SELECT COUNT(1) INTO V_TRADEPLACE_CHECK
    FROM SBSECURITIES SB, CAMAST CA
    WHERE CA.CODEID = SB.CODEID
    AND SB.TRADEPLACE = '003'
    AND SB.DEPOSITORY <> '001'
    AND CA.CAMASTID = :NEWVAL.CAMASTID;

    if V_TRADEPLACE_CHECK > 0 then
        return;  --neu la OTC thi ko swift ji ca
    end if;


  --lay thong tin cau hinh gui swift
  select nvl(cf.sendswift,'N') into v_sendswift
         from cfmast cf, afmast af
       where cf.custid = af.custid and af.acctno = :newval.afacctno ;
         plog.error(pkgctx, :NEWVAL.camastid||'triger log: camastid v_sendswift:'|| v_sendswift);



if  trim(v_sendswift)= 'Y' then


   plog.error(pkgctx, 'triger log: camastid:'||:NEWVAL.camastid||case when updating then 'true' else 'false' end||to_char(:newval.DELTD)||to_char(:old.swiftclient));
   IF updating=true and :newval.DELTD = 'N' and  :old.ISRECEIVE='N' and :newval.ISRECEIVE='Y' and :old.ACTIONTYPE='U' THEN  --- case update --> chi udate cho nhung thang da gui new

       select catype into v_catype from camast where camastid = :NEWVAL.camastid;

   CASE
      WHEN v_catype='023' THEN  ---   Chuy?n d?i TP ch?n nh?n ti?n ho?c CP
        v_trfcode:= '564.CORP.NOTF.BOND';
      WHEN v_catype='010' or v_catype='016' or v_catype='015' or v_catype='024' or v_catype='027' THEN  -- s? ki?n Chia c? t?c = ti?n, Tr? lãi trái phi?u, Tr? g?c và lãi TP (Gi?i th? TCPH):
        v_trfcode:= '564.CORP.NOTF.TIEN';
      WHEN v_catype='011'or v_catype='021' or v_catype='017' or v_catype='020' THEN --Chia c? t?c = CP, CP thu?ng, Hoán d?i TP thành CP, Hoán d?i CP thành CP
        v_trfcode:= '564.CORP.NOTF.CP';
     WHEN v_catype='014' THEN --quyen mua
        v_trfcode:= '564.CORP.NOTF.QM';
      WHEN v_catype='005'or v_catype='028' or v_catype='006' or v_catype='020' or v_catype='031'
          or v_catype='032' or v_catype='003' or v_catype='030' or v_catype='019' or v_catype='029' THEN
         v_trfcode:= '564.CORP.NOTF.ANN';
     ELSE
     ----   H?p d?i h?i c? dông (thu?ng niên, b?t thu?ng, l?y ý ki?n = van b?n),
     --Thay d?i thông tin ch?ng khoán, niêm y?t ch?ng khoán, chao mua, chao bán, thau t0m
        v_trfcode:= '';
    eND case;

    SELECT COUNT(*) INTO L_COUNT FROM VSDTRFCODE VSD WHERE trfcode=v_trfcode AND VSD.STATUS='Y' AND VSD.TYPE ='REQ' and bankcode = 'CBP';

    IF L_COUNT >0 THEN

       FOR REC IN (
                  SELECT TRFCODE, BANKCODE,TLTXCD FROM VSDTRFCODE VSD
                  WHERE trfcode=v_trfcode AND VSD.STATUS='Y' AND VSD.TYPE ='REQ' and bankcode = 'CBP')
       LOOP
           Insert into VSD_PROCESS_LOG(AUTOID,TRFCODE,TLTXCD,TXNUM,TXDATE,PROCESS,MSGACCT,BRID,TLID,BANKCODE,REFOBJ)
           values (SEQ_VSD_PROCESS_LOG.NEXTVAL,REC.TRFCODE,REC.TLTXCD,:NEWVAL.AUTOID,GETCURRDATE,'N',:NEWVAL.afacctno,'0001','0001', REC.BANKCODE,'CASCHD_LIST');
           --update caschd set swiftclient='Y' where autoid =:NEWVAL.AUTOID;
           :NEWVAL.swiftclient:='U';
       END LOOP;
    END IF;

  --case cho insert
  elsif INSERTING=true  and :newval.DELTD = 'N'     THEN
      select catype into v_catype from camast where camastid = :NEWVAL.camastid;

   CASE
      WHEN v_catype='023' THEN  ---   Chuy?n d?i TP ch?n nh?n ti?n ho?c CP
        v_trfcode:= '564.CORP.NOTF.BOND';
      WHEN v_catype='010' or v_catype='016' or v_catype='015' or v_catype='024' or v_catype='027' THEN  -- s? ki?n Chia c? t?c = ti?n, Tr? lãi trái phi?u, Tr? g?c và lãi TP (Gi?i th? TCPH):
        v_trfcode:= '564.CORP.NOTF.TIEN';
      WHEN v_catype='011'or v_catype='021' or v_catype='017' or v_catype='020' THEN --Chia c? t?c = CP, CP thu?ng, Hoán d?i TP thành CP, Hoán d?i CP thành CP
        v_trfcode:= '564.CORP.NOTF.CP';
     WHEN v_catype='014' THEN --quyen mua
        v_trfcode:= '564.CORP.NOTF.QM';
      WHEN v_catype='005'or v_catype='028' or v_catype='006' or v_catype='020' or v_catype='031'
          or v_catype='032' or v_catype='003' or v_catype='030' or v_catype='019' or v_catype='029' THEN
         v_trfcode:= '564.CORP.NOTF.ANN';
     ELSE
     ----   H?p d?i h?i c? dông (thu?ng niên, b?t thu?ng, l?y ý ki?n = van b?n),
     --Thay d?i thông tin ch?ng khoán, niêm y?t ch?ng khoán, chao mua, chao bán, thau t0m
        v_trfcode:= '';
    eND case;

    SELECT COUNT(*) INTO L_COUNT FROM VSDTRFCODE VSD WHERE trfcode=v_trfcode AND VSD.STATUS='Y' AND VSD.TYPE ='REQ' and bankcode = 'CBP';

    IF L_COUNT >0 THEN

       FOR REC IN (
                  SELECT TRFCODE, BANKCODE,TLTXCD FROM VSDTRFCODE VSD
                  WHERE trfcode=v_trfcode AND VSD.STATUS='Y' AND VSD.TYPE ='REQ' and bankcode = 'CBP')
       LOOP
           Insert into VSD_PROCESS_LOG(AUTOID,TRFCODE,TLTXCD,TXNUM,TXDATE,PROCESS,MSGACCT,BRID,TLID,BANKCODE,REFOBJ)
           values (SEQ_VSD_PROCESS_LOG.NEXTVAL,REC.TRFCODE,REC.TLTXCD,:NEWVAL.AUTOID,GETCURRDATE,'N',:NEWVAL.afacctno,'0001','0001', REC.BANKCODE,'CASCHD_LIST');
           --update caschd set swiftclient='Y' where autoid =:NEWVAL.AUTOID;
           :NEWVAL.swiftclient:='N';
       END LOOP;
    END IF;

 END IF;
EnD IF; -- end if cua  v_sendswift= 'Y'
  plog.setEndSection(pkgctx, 'trg_caschd_after');

exception
  when others then
    plog.error(pkgctx, SQLERRM);
    plog.setEndSection(pkgctx, 'trg_caschd_after');
end;
/
