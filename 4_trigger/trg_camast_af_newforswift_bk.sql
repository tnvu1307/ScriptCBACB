SET DEFINE OFF;
CREATE OR REPLACE TRIGGER TRG_CAMAST_AF_NEWFORSWIFT_BK 
 AFTER
  UPDATE
 ON camast
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DISABLE
declare
  -- local variables here
  v_catype varchar2(4);
  v_count number;
   L_COUNT number;
   v_bankcode varchar2(10);
   v_tltxcd varchar2(10);
  v_trfcode varchar2(50);
  v_currentdate date;
 pkgctx     plog.log_ctx;
 logrow     tlogdebug%ROWTYPE;
begin

  v_currentdate:=GETCURRDATE;
 

  if :new.status = 'N' and :old.status = 'P' AND :new.deltd = 'N' then --update
    v_catype:=:new.catype;
    select count(*) into v_count from caschd where camastid =:new.camastid and deltd='N';
     plog.error(pkgctx, 'trg_camast_after_newforswift :catype'||v_catype||v_count);
        if v_count > 0 then --sau 3375

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

                    SELECT COUNT(*), max(nvl(BANKCODE,'')),max(nvl(TLTXCD,''))
                    INTO L_COUNT,v_bankcode,v_tltxcd
                    FROM VSDTRFCODE VSD WHERE trfcode=v_trfcode AND VSD.STATUS='Y' AND VSD.TYPE ='REQ' and bankcode = 'CBP';

                    IF L_COUNT >0 THEN

                       FOR REC IN (
                                  SELECT * FROM caschd
                                  WHERE camastid =:new.camastid and swiftclient = 'N')
                       LOOP
                           Insert into VSD_PROCESS_LOG(AUTOID,TRFCODE,TLTXCD,TXNUM,TXDATE,PROCESS,MSGACCT,BRID,TLID,BANKCODE,REFOBJ)
                           values (SEQ_VSD_PROCESS_LOG.NEXTVAL,v_trfcode,v_tltxcd,rec.AUTOID,GETCURRDATE,'N',rec.afacctno,'0001','0001', v_bankcode,'CASCHD');
                           update caschd set swiftclient='U' where autoid =rec.AUTOID;
                       END LOOP;
                    END IF;
        else --truoc 3375
         plog.error(pkgctx, 'trg_camast_after_newforswift :vao trong trc 3375');
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

                     SELECT COUNT(*), max(BANKCODE),max(TLTXCD)
                    INTO L_COUNT,v_bankcode,v_tltxcd
                    FROM VSDTRFCODE VSD WHERE trfcode=v_trfcode AND VSD.STATUS='Y' AND VSD.TYPE ='REQ' and bankcode = 'CBP';
   plog.error(pkgctx, 'trg_camast_after_newforswift :L_COUNT,v_bankcode,v_tltxcd'||L_COUNT||v_bankcode||v_tltxcd);
                    IF L_COUNT >0 THEN

                       FOR REC IN (
                                  SELECT * FROM caschd_list
                                  WHERE camastid =:new.camastid and swiftclient in ('N','U'))
                       LOOP
                           Insert into VSD_PROCESS_LOG(AUTOID,TRFCODE,TLTXCD,TXNUM,TXDATE,PROCESS,MSGACCT,BRID,TLID,BANKCODE,REFOBJ)
                           values (SEQ_VSD_PROCESS_LOG.NEXTVAL,v_trfcode,v_tltxcd,rec.AUTOID,v_currentdate,'N',rec.afacctno,'0001','0001', v_bankcode,'CASCHD_LIST');
                           update caschd_list set swiftclient='U' where autoid =rec.AUTOID;
                       END LOOP;
                    END IF;
        end if;         --else caschd_list
  elsif  :new.deltd = 'Y'  then -- upprove deltd
      select catype into v_catype from camast where camastid = :new.camastid;
    select count(*) into v_count from caschd where camastid =:new.camastid and deltd='N';
        if v_count > 0 then --sau 3375

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

                    SELECT COUNT(*), max(BANKCODE),max(TLTXCD)
                    INTO L_COUNT,v_bankcode,v_tltxcd
                    FROM VSDTRFCODE VSD WHERE trfcode=v_trfcode AND VSD.STATUS='Y' AND VSD.TYPE ='REQ' and bankcode = 'CBP';

                    IF L_COUNT >0 THEN

                       FOR REC IN (
                                  SELECT * FROM caschd
                                  WHERE camastid =:new.camastid and swiftclient in('U','N'))
                       LOOP
                           Insert into VSD_PROCESS_LOG(AUTOID,TRFCODE,TLTXCD,TXNUM,TXDATE,PROCESS,MSGACCT,BRID,TLID,BANKCODE,REFOBJ)
                           values (SEQ_VSD_PROCESS_LOG.NEXTVAL,v_trfcode,v_tltxcd,rec.AUTOID,v_currentdate,'N',rec.afacctno,'0001','0001', v_bankcode,'CASCHD');
                           update caschd set swiftclient='D' where autoid =rec.AUTOID;
                       END LOOP;
                    END IF;
        else --truoc 3375
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

                        SELECT COUNT(*), max(BANKCODE),max(TLTXCD)
                    INTO L_COUNT,v_bankcode,v_tltxcd
                    FROM VSDTRFCODE VSD WHERE trfcode=v_trfcode AND VSD.STATUS='Y' AND VSD.TYPE ='REQ' and bankcode = 'CBP';

                    IF L_COUNT >0 THEN

                       FOR REC IN (
                                  SELECT * FROM caschd_list
                                  WHERE camastid =:new.camastid and swiftclient in ('N','U'))
                       LOOP
                           Insert into VSD_PROCESS_LOG(AUTOID,TRFCODE,TLTXCD,TXNUM,TXDATE,PROCESS,MSGACCT,BRID,TLID,BANKCODE,REFOBJ)
                           values (SEQ_VSD_PROCESS_LOG.NEXTVAL,v_trfcode,v_tltxcd,rec.AUTOID,v_currentdate,'N',rec.afacctno,'0001','0001', v_bankcode,'CASCHD_LIST');
                           update caschd_list set swiftclient='D' where autoid =rec.AUTOID;
                       END LOOP;
                    END IF;
     end if;
  end if;
   
  
end trg_camast_after_newforswift;
/
