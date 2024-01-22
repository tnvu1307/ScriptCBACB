SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE gen_confirmation_swift566_014( p_camastid varchar2, p_afacctno varchar2)
is

v_catype varchar2(10);
v_trfcode varchar2(100);
v_curdate date;
V_TRADEPLACE_CHECK number;
v_afacctno varchar2(20);
v_autoid number;
v_sendswift varchar2(10);
begin
v_curdate:=getcurrdate();
v_afacctno:=p_afacctno;

--check xem chung khoan co phai la OTC ko
    SELECT COUNT(1) INTO V_TRADEPLACE_CHECK
    FROM SBSECURITIES SB, CAMAST CA
    WHERE CA.CODEID = SB.CODEID
    AND SB.TRADEPLACE = '003'
    AND SB.DEPOSITORY <> '001'
    AND CA.CAMASTID = p_camastid;

    if V_TRADEPLACE_CHECK > 0 then
        return;  --neu la OTC thi ko swift ji ca
    end if;

    SELECT cd.autoid into v_autoid from caschd cd, camast ca
    WHERE cd.camastid =p_camastid and cd.deltd='N' and cd.status = 'M' and cd.camastid=ca.camastid and ca.catype = '014' and cd.afacctno=v_afacctno;

    select nvl(cf.sendswift,'N') into v_sendswift
    from cfmast cf, afmast af
    where cf.custid = af.custid and af.acctno =v_afacctno;

    --Ngay 29/02/2020 NamTv chinh lai xu ly tung tai khoan
    if  trim(v_sendswift)= 'Y' then
       FOR REC IN (
                  SELECT TRFCODE,BANKCODE,TLTXCD FROM VSDTRFCODE VSD
                  WHERE trfcode='566.CORP.CONF.QM' AND VSD.STATUS='Y' AND VSD.TYPE ='REQ' and bankcode = 'CBP')
       LOOP
           Insert into VSD_PROCESS_LOG(AUTOID,TRFCODE,TLTXCD,TXNUM,TXDATE,PROCESS,MSGACCT,BRID,TLID,BANKCODE,REFOBJ)
           values (SEQ_VSD_PROCESS_LOG.NEXTVAL,REC.TRFCODE,REC.TLTXCD,v_autoid,GETCURRDATE,'N',v_afacctno,'0001','0001', REC.BANKCODE,'CASCHD');
       END LOOP;
    end if;
    --NamTv End
/*    FOR caschslist IN (
              SELECT *  from caschd
              WHERE camastid =p_camastid and deltd='N' and status = 'M' )
    LOOP
       FOR REC IN (
                  SELECT TRFCODE,BANKCODE,TLTXCD FROM VSDTRFCODE VSD
                  WHERE trfcode='566.CORP.CONF.QM' AND VSD.STATUS='Y' AND VSD.TYPE ='REQ' and bankcode = 'CBP')
       LOOP
           Insert into VSD_PROCESS_LOG(AUTOID,TRFCODE,TLTXCD,TXNUM,TXDATE,PROCESS,MSGACCT,BRID,TLID,BANKCODE,REFOBJ)
           values (SEQ_VSD_PROCESS_LOG.NEXTVAL,REC.TRFCODE,REC.TLTXCD,caschslist.autoid,GETCURRDATE,'N',caschslist.afacctno,'0001','0001', REC.BANKCODE,'CASCHD');
       END LOOP;
    END LOOP;
*/
exception when others then
  dbms_output.put_line('no thing found');
end;
/
