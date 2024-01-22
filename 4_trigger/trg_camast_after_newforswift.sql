SET DEFINE OFF;
CREATE OR REPLACE TRIGGER TRG_CAMAST_AFTER_NEWFORSWIFT 
 AFTER
  UPDATE
 ON camast
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
declare
    -- local variables here
    v_catype varchar2(4);
    v_count number;
    L_COUNT number;
    v_bankcode varchar2(10);
    v_tltxcd varchar2(10);
    v_trfcode varchar2(50);
    v_currentdate date;
    v_sendswift varchar2(4);
    v_tradeplace_check number;
    pkgctx     plog.log_ctx;
    logrow     tlogdebug%ROWTYPE;
begin

  v_currentdate:=GETCURRDATE;


/*  if (((:new.status = 'N' and :old.status = 'P') or :new.DUEDATE <> :old.DUEDATE
  or :new.BEGINDATE <> :old.BEGINDATE or :new.TODATETRANSFER <> :old.TODATETRANSFER
  or :new.FRDATETRANSFER <> :old.FRDATETRANSFER or :new.ACTIONDATE <> :old.ACTIONDATE)
          AND :new.deltd = 'N' ) then --update
    v_catype:=:new.catype;


                          CASE
                          WHEN v_catype='023' THEN  ---   Chuy?n d?i TP ch?n nh?n ti?n ho?c CP
                            v_trfcode:= '564.CORP.NOTF.BOND';
                         WHEN v_catype='010' or v_catype='016' or v_catype='015' or v_catype='024' or v_catype='027' THEN  -- s? ki?n Chia c? t?c = ti?n, Tr? lãi trái phi?u, Tr? g?c và lãi TP (Gi?i th? TCPH):
                            v_trfcode:= '564.CORP.NOTF.TIEN';
                         WHEN v_catype='011'or v_catype='021' or v_catype='017' or v_catype='020' THEN --Chia c? t?c = CP, CP thu?ng, Hoán d?i TP thành CP, Hoán d?i CP thành CP
                            v_trfcode:= '564.CORP.NOTF.CP';
                         WHEN v_catype='014' THEN --quyen mua
                            v_trfcode:= '564.CORP.NOTF.QM';
                        WHEN v_catype='005'or v_catype='028' or v_catype='006' THEN
                             v_trfcode:= '564.CORP.NOTF.ANN';
                         ELSE
                             v_trfcode:= '';
                        eND case;


                     SELECT COUNT(*), max(BANKCODE),max(TLTXCD)
                    INTO L_COUNT,v_bankcode,v_tltxcd
                    FROM VSDTRFCODE VSD WHERE trfcode=v_trfcode AND VSD.STATUS='Y' AND VSD.TYPE ='REQ' and bankcode = 'CBP';
   plog.error(pkgctx, 'trg_camast_after_newforswift :L_COUNT,v_bankcode,v_tltxcd'||L_COUNT||v_bankcode||v_tltxcd);
                    IF L_COUNT >0 THEN

                       FOR REC IN (
                                  SELECT * FROM caschd_list
                                  WHERE camastid =:new.camastid and swiftclient in ('N','U')  and deltd='N')
                       LOOP
                           Insert into VSD_PROCESS_LOG(AUTOID,TRFCODE,TLTXCD,TXNUM,TXDATE,PROCESS,MSGACCT,BRID,TLID,BANKCODE,REFOBJ)
                           values (SEQ_VSD_PROCESS_LOG.NEXTVAL,v_trfcode,v_tltxcd,rec.AUTOID,v_currentdate,'N',rec.afacctno,'0001','0001', v_bankcode,'CASCHD_LIST');
                           update caschd_list set swiftclient='U' where autoid =rec.AUTOID;
                       END LOOP;
                    END IF;
              --else caschd_list
  els*/

  if  :new.deltd = 'Y' and  :old.deltd <> 'Y' then -- upprove deltd

  --check xem chung khoan co phai la OTC ko

    SELECT COUNT(1) INTO V_TRADEPLACE_CHECK
    FROM SBSECURITIES
    WHERE CODEID = :NEW.CODEID
    AND TRADEPLACE = '003'
    AND DEPOSITORY <> '001';

    IF V_TRADEPLACE_CHECK > 0 THEN
        RETURN;  --NEU LA OTC VA K LUU KI VSD THI KO SWIFT
    END IF;

      v_catype:= :new.catype;

                           CASE
                          WHEN v_catype='023' THEN  ---   Chuy?n d?i TP ch?n nh?n ti?n ho?c CP
                            v_trfcode:= '564.CORP.NOTF.BOND';
                         WHEN v_catype='010' or v_catype='016' or v_catype='015' or v_catype='024' or v_catype='027' THEN  -- s? ki?n Chia c? t?c = ti?n, Tr? lãi trái phi?u, Tr? g?c và lãi TP (Gi?i th? TCPH):
                            v_trfcode:= '564.CORP.NOTF.TIEN';
                         WHEN v_catype='011'or v_catype='021' or v_catype='017' or v_catype='020' THEN --Chia c? t?c = CP, CP thu?ng, Hoán d?i TP thành CP, Hoán d?i CP thành CP
                            v_trfcode:= '564.CORP.NOTF.CP';
                         WHEN v_catype='014' THEN --quyen mua
                            v_trfcode:= '564.CORP.NOTF.QM';
                        WHEN v_catype='005'or v_catype='028' or v_catype='006' THEN
                             v_trfcode:= '564.CORP.NOTF.ANN';
                         ELSE
                             v_trfcode:= '';
                        eND case;

                     SELECT COUNT(*), max(BANKCODE),max(TLTXCD)
                    INTO L_COUNT,v_bankcode,v_tltxcd
                    FROM VSDTRFCODE VSD WHERE trfcode=v_trfcode AND VSD.STATUS='Y' AND VSD.TYPE ='REQ' and bankcode = 'CBP';

                    IF L_COUNT >0 THEN

                       FOR REC IN (
                                  SELECT * FROM caschd_list
                                  WHERE camastid =:new.camastid and swiftclient in ('N','U') and deltd='N')
                       LOOP
                           select nvl(cf.sendswift,'N') into v_sendswift
                           from cfmast cf, afmast af
                           where cf.custid = af.custid and af.acctno = rec.afacctno ;

                          if  trim(v_sendswift)= 'Y' then

                               Insert into VSD_PROCESS_LOG(AUTOID,TRFCODE,TLTXCD,TXNUM,TXDATE,PROCESS,MSGACCT,BRID,TLID,BANKCODE,REFOBJ)
                               values (SEQ_VSD_PROCESS_LOG.NEXTVAL,v_trfcode,v_tltxcd,rec.AUTOID,v_currentdate,'N',rec.afacctno,'0001','0001', v_bankcode,'CASCHD_LIST');
                               update caschd_list set swiftclient='D' where autoid =rec.AUTOID;
                           end if;
                       END LOOP;
                    END IF;

  end if;


end trg_camast_after_newforswift;
/
