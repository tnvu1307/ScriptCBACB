SET DEFINE OFF;
CREATE OR REPLACE TRIGGER TRG_CASCHD_BEFORE_FORSWIFT 
 BEFORE 
 INSERT
 ON CASCHD
 REFERENCING OLD AS OLD NEW AS NEWVAL
 FOR EACH ROW
DISABLE
declare
l_count number;
v_trfcode varchar2(500);
v_tltxcd varchar2(50);
v_catype varchar2(50);
pkgctx plog.log_ctx;
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
    
  if :newval.DELTD = 'N' and :newval.inbalance<=0 and :newval.inqtty<=0  THEN
      select catype into v_catype from camast where camastid = :NEWVAL.camastid;

   CASE 
      WHEN v_catype='023' THEN  ---   Chuy?n d?i TP ch?n nh?n ti?n ho?c CP
        v_trfcode:= '564.CORP.NOTF.BOND'; 
      WHEN v_catype='010' or v_catype='016' or v_catype='015' THEN  -- s? ki?n Chia c? t?c = ti?n, Tr? l?tr?phi?u, Tr? g?c v??TP (Gi?i th? TCPH):
        v_trfcode:= '564.CORP.NOTF.TIEN';
      WHEN v_catype='011'or v_catype='021' or v_catype='017' or v_catype='020' THEN --Chia c? t?c = CP, CP thu?ng, Ho?d?i TP th? CP, Ho?d?i CP th? CP
        v_trfcode:= '564.CORP.NOTF.CP';
     WHEN v_catype='014' THEN --quyen mua
        v_trfcode:= '564.CORP.NOTF.QM';
     ELSE
     ----   H?p d?i h?i c? d?(thu?ng ni? b?t thu?ng, l?y ? ki?n = van b?n),
     --Thay d?i th?tin ch?ng kho? ni?y?t ch?ng kho? chao mua, chao b? thau t0m
        v_trfcode:= '564.CORP.NOTF.ANN';
    eND case;
     
    SELECT COUNT(*) INTO L_COUNT FROM VSDTRFCODE VSD WHERE trfcode=v_trfcode AND VSD.STATUS='Y' AND VSD.TYPE ='REQ' and bankcode = 'CBP';
    
    IF L_COUNT >0 THEN
   
       FOR REC IN (
                  SELECT TRFCODE, BANKCODE,TLTXCD FROM VSDTRFCODE VSD 
                  WHERE trfcode=v_trfcode AND VSD.STATUS='Y' AND VSD.TYPE ='REQ' and bankcode = 'CBP')
       LOOP
           Insert into VSD_PROCESS_LOG(AUTOID,TRFCODE,TLTXCD,TXNUM,TXDATE,PROCESS,MSGACCT,BRID,TLID,BANKCODE,refobj)
           values (SEQ_VSD_PROCESS_LOG.NEXTVAL,REC.TRFCODE,REC.TLTXCD,:NEWVAL.AUTOID,GETCURRDATE,'N',:NEWVAL.afacctno,'0001','0001', REC.BANKCODE,'CASCHD');
           --update caschd set swiftclient='Y' where autoid =:NEWVAL.AUTOID;
           :NEWVAL.swiftclient:='N';
       END LOOP;
    END IF;
   
 END IF;
  plog.setEndSection(pkgctx, 'trg_caschd_after');
  
exception
  when others then
    plog.error(pkgctx, SQLERRM);
    plog.setEndSection(pkgctx, 'trg_caschd_after');
end;
/
