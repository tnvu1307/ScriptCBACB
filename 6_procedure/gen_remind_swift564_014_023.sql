SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE gen_remind_swift564_014_023
is
v_camastid varchar2(30);
v_catype varchar2(10);
v_trfcode varchar2(100);
v_curdate date;
v_sendswift varchar2(10);
V_TRADEPLACE_CHECK number;
begin
v_curdate:=getcurrdate();



  FOR camastlist IN (
            select ca.camastid , ca.catype
            from camast ca, SBSECURITIES SB
            where (v_curdate = getprevdate(ca.duedate,5) or v_curdate = getprevdate(ca.duedate,2) )
            and ca.catype in ('014','023')
            and ca.status in ('V', 'M')
            and CA.CODEID = SB.CODEID
            AND SB.TRADEPLACE = '003'
            AND SB.DEPOSITORY <> '001'
        )
 loop

    if camastlist.catype='014' THEN --quyen mua
        v_trfcode:= '564.CORP.NOTF.QM';
    else  ---   Chuy?n d?i TP ch?n nh?n ti?n ho?c CP
        v_trfcode:= '564.CORP.NOTF.BOND';
    end if;

     FOR caschslist IN (
                  SELECT *  from caschd
                  WHERE camastid =camastlist.camastid and deltd='N' and pqtty > 0)
       LOOP
            select nvl(cf.sendswift,'N') into v_sendswift
            from cfmast cf, afmast af
            where cf.custid = af.custid and af.acctno =caschslist.afacctno ;


        if  trim(v_sendswift)= 'Y' then
           FOR REC IN (
                      SELECT TRFCODE, BANKCODE,TLTXCD FROM VSDTRFCODE VSD
                      WHERE trfcode=v_trfcode AND VSD.STATUS='Y' AND VSD.TYPE ='REQ' and bankcode = 'CBP')
           LOOP
                UPDATE caschd set swiftclient = 'M' where camastid =camastlist.camastid and deltd='N';
               Insert into VSD_PROCESS_LOG(AUTOID,TRFCODE,TLTXCD,TXNUM,TXDATE,PROCESS,MSGACCT,BRID,TLID,BANKCODE,REFOBJ)
               values (SEQ_VSD_PROCESS_LOG.NEXTVAL,REC.TRFCODE,REC.TLTXCD,caschslist.AUTOID,GETCURRDATE,'N',caschslist.afacctno,'0001','0001', REC.BANKCODE,'CASCHD');
           END LOOP;
         end if;
     END LOOP;
end loop;
exception when others then
  dbms_output.put_line('no thing found');
end;
/
