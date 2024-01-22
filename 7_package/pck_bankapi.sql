SET DEFINE OFF;
CREATE OR REPLACE PACKAGE pck_bankapi
  IS

PROCEDURE Bank_NostroToNostro(
        P_SENOSTROACCT IN VARCHAR2,  --- so tk nostro chuyen
        P_RENOSTROACCT IN VARCHAR2, --- so tk nostro nhan
        P_BANKTRANS  IN VARCHAR2, ---ma loai nghiep vu trong table BANKNOSTRO.BANKTRANS
        P_DORC    IN VARCHAR2,  -- Debit or credit (A = D, B = C)
        P_AMOUNT  IN  number,  --- so tien
        P_REQCODE IN  VARCHAR2, --request code cua nghiep vu trong allcode
        P_REQKEY  IN VARCHAR2,  --requestkey duy nhat de truy lai giao dich goc
        P_DESC  IN   VARCHAR2,  -- dien giai
        P_TLID  IN   VARCHAR2, -- nguoi tao giao dich
        P_ERR_CODE  OUT VARCHAR2);

PROCEDURE Bank_NostroWtransfer(
      P_DDACCTNO IN VARCHAR2,  --- tk ddmast tk doi ung (ca nhan)
      P_NOSTROBANKACCT IN VARCHAR2, --- so tk nostro (tu doanh )
      P_BANKTRANS  IN VARCHAR2, ---ma loai nghiep vu trong table BANKNOSTRO.BANKTRANS
      P_DORC    IN VARCHAR2,  -- Debit or credit
      P_AMOUNT  IN  number,  --- so tien
      P_REQCODE IN  VARCHAR2, --request code cua nghiep vu trong allcode
      P_REQKEY  IN VARCHAR2,  --requestkey duy nhat de truy lai giao dich goc
      P_DESC  IN   VARCHAR2,  -- dien giai
      P_TLID  IN   VARCHAR2, -- nguoi tao giao dich
      P_ERR_CODE  OUT VARCHAR2);

PROCEDURE Bank_NostroWtransfer_out(
      P_ACCOUNT IN VARCHAR2,  --- tk nhan
      P_NOSTROBANKACCT IN VARCHAR2, --- so tk nostro (tu doanh )
      P_BANKTRANS  IN VARCHAR2, ---
      P_RBANKCITAD IN VARCHAR2, --CITAD
      P_DORC    IN VARCHAR2,  -- Debit or credit
      P_AMOUNT  IN  number,  --- so tien
      P_REQCODE IN  VARCHAR2, --request code cua nghiep vu trong allcode
      P_REQKEY  IN VARCHAR2,  --requestkey duy nhat de truy lai giao dich goc
      P_DESC  IN   VARCHAR2,  -- dien giai
      P_TLID  IN   VARCHAR2, -- nguoi tao giao dich
      P_ERR_CODE  OUT VARCHAR2);

PROCEDURE Bank_Tranfer_Out(
      P_DDACCTNO IN VARCHAR2,  --- tk ddmast tk chuyen
      P_RBANKNAME IN VARCHAR2, ---ten tk nhan
      P_RBANKACCT IN VARCHAR2, --- so tk nhan
      P_RBANKCITAD IN VARCHAR2, --- so citad ngan hang nhan
      P_AMOUNT     number,  --- so tien
      P_REQCODE IN  VARCHAR2, --request code cua nghiep vu trong allcode
      P_REQKEY  IN VARCHAR2,  --requestkey duy nhat de truy lai giao dich goc
      P_DESC  IN   VARCHAR2,  -- dien giai
      P_TLID  IN   VARCHAR2, -- nguoi tao giao dich
      P_ERR_CODE  OUT VARCHAR2);

PROCEDURE Bank_Tranfer_Out_fa(
      P_DDACCTNO IN VARCHAR2,  --- tk ddmast tk chuyen
      P_RBANKNAME IN VARCHAR2, ---ten tk nhan
      P_RBANKACCT IN VARCHAR2, --- so tk nhan
      P_RBANKCITAD IN VARCHAR2, --- so citad ngan hang nhan
      P_feetype  IN VARCHAR2,---loai phi
      P_AMOUNT     number,  --- so tien
      P_REQCODE IN  VARCHAR2, --request code cua nghiep vu trong allcode
      P_REQKEY  IN VARCHAR2,  --requestkey duy nhat de truy lai giao dich goc
      P_DESC  IN   VARCHAR2,  -- dien giai
      P_TLID  IN   VARCHAR2, -- nguoi tao giao dich
      P_ERR_CODE  OUT VARCHAR2);

PROCEDURE Bank_Tranfer_Out_gbond(
      P_DDACCTNO IN VARCHAR2,  --- tk ddmast tk chuyen
      P_RBANKNAME IN VARCHAR2, ---ten tk nhan
      P_RBANKACCT IN VARCHAR2, --- so tk nhan
      P_RBANKCITAD IN VARCHAR2, --- so citad ngan hang nhan
      P_feetype  IN VARCHAR2,---loai phi
      P_AMOUNT     number,  --- so tien
      P_REQCODE IN  VARCHAR2, --request code cua nghiep vu trong allcode
      P_REQKEY  IN VARCHAR2,  --requestkey duy nhat de truy lai giao dich goc
      P_DESC  IN   VARCHAR2,  -- dien giai
      P_TLID  IN   VARCHAR2, -- nguoi tao giao dich
      P_IDENTITY IN VARCHAR2, -- so dinh danh GBOND
      P_ERR_CODE  OUT VARCHAR2);

PROCEDURE Bank_Internal_Tranfer(
      P_DDACCTNO IN VARCHAR2,  --- tk ddmast tk chuyen
      P_RBANKNAME IN VARCHAR2, ---ten tk nhan
      P_RBANKACCT IN VARCHAR2, --- so tk nhan
      P_AMOUNT     number,  --- so tien
      P_REQCODE IN  VARCHAR2, --request code cua nghiep vu trong allcode
      P_REQKEY  IN VARCHAR2,  --requestkey duy nhat de truy lai giao dich goc
      P_DESC  IN   VARCHAR2,  -- dien giai
      P_TLID  IN   VARCHAR2, -- nguoi tao giao dich
      P_ERR_CODE  OUT VARCHAR2);

PROCEDURE Bank_Internal_Tranfer_fa(
      P_DDACCTNO IN VARCHAR2,  --- tk ddmast tk chuyen
      P_RBANKNAME IN VARCHAR2, ---ten tk nhan
      P_RBANKACCT IN VARCHAR2, --- so tk nhan
      P_AMOUNT     number,  --- so tien
      P_REQCODE IN  VARCHAR2, --request code cua nghiep vu trong allcode
      P_REQKEY  IN VARCHAR2,  --requestkey duy nhat de truy lai giao dich goc
      P_DESC  IN   VARCHAR2,  -- dien giai
      P_TLID  IN   VARCHAR2, -- nguoi tao giao dich
      P_ERR_CODE  OUT VARCHAR2);

PROCEDURE Bank_Inquiry(
      P_DDACCTNO IN VARCHAR2,  --- tk ddmast
      P_REQCODE IN  VARCHAR2, --request code cua nghiep vu trong allcode
      P_REQKEY  IN VARCHAR2,  --requestkey duy nhat de truy lai giao dich goc
      P_DESC  IN   VARCHAR2,  -- dien giai
      P_TLID  IN   VARCHAR2, -- nguoi tao giao dich
      P_ERR_CODE  OUT VARCHAR2);

  PROCEDURE Bank_UNholdbalance(
      P_REFHOLDTXNUM IN VARCHAR2 ,  ---txnum cua giao dich hold
      P_DDACCTNO IN VARCHAR2,  --- tk ddmast
      P_AMOUNT  IN  NUMBER,  -- so tien
      P_REQCODE IN  VARCHAR2, --request code cua nghiep vu trong allcode
      P_REQKEY  IN VARCHAR2,  --requestkey duy nhat de truy lai giao dich goc
      P_DESC  IN   VARCHAR2,  -- dien giai
      P_TLID  IN   VARCHAR2, -- nguoi tao giao dich
      P_ERR_CODE  OUT VARCHAR2);

  PROCEDURE Bank_UNholdbalance_No_Broker(
      P_REFHOLDTXNUM IN VARCHAR2 ,  ---txnum cua giao dich hold
      P_DDACCTNO IN VARCHAR2,  --- tk ddmast
      P_AMOUNT  IN  NUMBER,  -- so tien
      P_REQCODE IN  VARCHAR2, --request code cua nghiep vu trong allcode
      P_REQKEY  IN VARCHAR2,  --requestkey duy nhat de truy lai giao dich goc
      P_DESC  IN   VARCHAR2,  -- dien giai
      P_TLID  IN   VARCHAR2, -- nguoi tao giao dich
      P_ERR_CODE  OUT VARCHAR2);


     PROCEDURE Bank_holdbalance(
     P_DDACCTNO IN VARCHAR2, -- tk ddmast
      P_MEMBERID IN VARCHAR2 default '', -- ctck dat lenh
      P_BRNAME  IN  VARCHAR2 default '', -- moi gioi dat lenh
      P_BRPHONE IN  VARCHAR2 default '', --- so dien thoai moi gioi dat lenh
      P_AMOUNT  IN  NUMBER,  --- so tien
      P_REQCODE IN  VARCHAR2, --- code nghiep vu cua giao dich , select tu alcode
      P_REQKEY  IN VARCHAR2, --request key --> key duy nhat de truy vet giao dich goc
      P_DESC  IN   VARCHAR2, -- dien giai
      P_TLID  IN   VARCHAR2, -- nguoi lap giao dich
      P_ERR_CODE  OUT VARCHAR2);

      --trung.luu: 23-03-2021 hold khong rollback
      PROCEDURE Bank_holdbalance_no_rollback(
     P_DDACCTNO IN VARCHAR2, -- tk ddmast
      P_MEMBERID IN VARCHAR2 default '', -- ctck dat lenh
      P_BRNAME  IN  VARCHAR2 default '', -- moi gioi dat lenh
      P_BRPHONE IN  VARCHAR2 default '', --- so dien thoai moi gioi dat lenh
      P_AMOUNT  IN  NUMBER,  --- so tien
      P_REQCODE IN  VARCHAR2, --- code nghiep vu cua giao dich , select tu alcode
      P_REQKEY  IN VARCHAR2, --request key --> key duy nhat de truy vet giao dich goc
      P_DESC  IN   VARCHAR2, -- dien giai
      P_TLID  IN   VARCHAR2, -- nguoi lap giao dich
      P_ERR_CODE  OUT VARCHAR2);

     PROCEDURE Bank_Inquiry_List(
      P_DDACCTNO IN VARCHAR2,  --- DS tk ddmast
      P_REQKEY  IN VARCHAR2,  --requestkey duy nhat de truy lai giao dich goc
      P_DESC  IN   VARCHAR2,  -- dien giai
      P_TLID  IN   VARCHAR2, -- nguoi tao giao dich
      P_ERR_CODE  OUT VARCHAR2
      ) ;

PROCEDURE se_hold(
     P_SEACCTNO IN VARCHAR2, -- tk semast
      P_MEMBERID IN VARCHAR2 default '', -- ctck dat lenh
      P_BRNAME  IN  VARCHAR2 default '', -- moi gioi dat lenh
      P_BRPHONE IN  VARCHAR2 default '', --- so dien thoai moi gioi dat lenh
      P_QTTY  IN  NUMBER,  --- so luong
      P_DESC  IN   VARCHAR2, -- dien giai
      P_TLID  IN   VARCHAR2, -- nguoi lap giao dich
      P_ERR_CODE  OUT VARCHAR2);

PROCEDURE se_unhold(
     P_SEACCTNO IN VARCHAR2, -- tk semast
      P_MEMBERID IN VARCHAR2 default '', -- ctck dat lenh
      P_BRNAME  IN  VARCHAR2 default '', -- moi gioi dat lenh
      P_BRPHONE IN  VARCHAR2 default '', --- so dien thoai moi gioi dat lenh
      P_QTTY  IN  NUMBER,  --- so luong
      P_DESC  IN   VARCHAR2, -- dien giai
      P_TLID  IN   VARCHAR2, -- nguoi lap giao dich
      P_ERR_CODE  OUT VARCHAR2);

--trung.luu: hold(6603)/unhold(6604) cho tk tu doanh
    PROCEDURE TD_Hold(
      P_CUSTODYCD IN VARCHAR2,
      P_MEMBERID IN VARCHAR2 default '', -- ctck dat lenh
      P_BRNAME  IN  VARCHAR2 default '', -- moi gioi dat lenh
      P_BRPHONE IN  VARCHAR2 default '', --- so dien thoai moi gioi dat lenh
      P_QTTY  IN  NUMBER,  --- so luong
      P_TLID  IN   VARCHAR2, -- nguoi lap giao dich
      P_DESC  IN   VARCHAR2,
      P_ERR_CODE  OUT VARCHAR2
      );

    PROCEDURE TD_Unhold(
      P_CUSTODYCD IN VARCHAR2,
      P_QTTY  IN  NUMBER,  --- so luong
      P_TLID  IN   VARCHAR2, -- nguoi lap giao dich
      P_DESC  IN   VARCHAR2,
      P_ERR_CODE  OUT VARCHAR2);

    PROCEDURE Checkblacklist(
      P_NAME IN VARCHAR2,
      P_REQTXNUM  IN  VARCHAR2,  --- txnum
      P_REQTXDATE  IN  VARCHAR2,  --- txdate
      P_TLID  IN   VARCHAR2, -- nguoi lap giao dich
      P_DESC  IN   VARCHAR2,
      P_ERR_CODE  OUT VARCHAR2
        );

--trung.luu: tang/giam tien(6607) dau ngay cho tk tu doanh
    PROCEDURE C_D_Balance(
      P_CUSTODYCD IN VARCHAR2,
      P_DDACCTNO  IN VARCHAR2,
      P_WDRTYPE   IN VARCHAR2,
      P_AMOUNT  IN  NUMBER,
      P_TLID  IN   VARCHAR2,
      P_ERR_CODE  OUT VARCHAR2);
END;
/


CREATE OR REPLACE PACKAGE BODY pck_bankapi
IS
      -- declare log context
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

    PROCEDURE Bank_NostroToNostro(
        P_SENOSTROACCT IN VARCHAR2,  --- so tk nostro chuyen
        P_RENOSTROACCT IN VARCHAR2, --- so tk nostro nhan
        P_BANKTRANS  IN VARCHAR2, ---ma loai nghiep vu trong table BANKNOSTRO.BANKTRANS
        P_DORC    IN VARCHAR2,  -- Debit or credit (A = D, B = C)
        P_AMOUNT  IN  number,  --- so tien
        P_REQCODE IN  VARCHAR2, --request code cua nghiep vu trong allcode
        P_REQKEY  IN VARCHAR2,  --requestkey duy nhat de truy lai giao dich goc
        P_DESC  IN   VARCHAR2,  -- dien giai
        P_TLID  IN   VARCHAR2, -- nguoi tao giao dich
        P_ERR_CODE  OUT VARCHAR2)
    IS
        -- Enter the procedure variables here. As shown below
        l_err_param varchar2(300);
        v_strCURRDATE varchar2(20);
        L_txnum         VARCHAR2(20);
        l_txmsg         tx.msg_rectype;
        v_dorc        varchar2(4);
    BEGIN
        SELECT TO_DATE (varvalue, systemnums.c_date_format)
        INTO v_strCURRDATE
        FROM sysvar
        WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

        SELECT systemnums.C_BATCH_PREFIXED
        || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
        INTO L_txnum
        FROM DUAL;

        l_txmsg.msgtype:='T';
        l_txmsg.local:='N';
        l_txmsg.tlid        := P_TLID;

        SELECT SYS_CONTEXT ('USERENV', 'HOST'),
        SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
        INTO l_txmsg.wsname, l_txmsg.ipaddress
        FROM DUAL;

        SELECT BRID
        INTO l_txmsg.brid
        FROM TLPROFILES where TLID = P_TLID;
        l_txmsg.off_line    := 'N';
        l_txmsg.deltd       := txnums.c_deltd_txnormal;
        l_txmsg.txstatus    := txstatusnums.c_txcompleted;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        l_txmsg.batchname   := 'DAY';
        l_txmsg.txnum       := L_txnum;
        l_txmsg.txtime      := to_char(SYSdate,'hh24:mm:ss');
        l_txmsg.txdate      :=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.BUSDATE     :=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.tltxcd      :='6673';

        FOR rec IN
        (
            select d.fldname, d.defname, d.datatype,
            case when fldname='03' then  ''
            when fldname='06' then  ''
            when fldname='10' then  to_char(P_AMOUNT)
            when fldname='88' then  ''
            when fldname='89' then  P_BANKTRANS
            when fldname='90' then  P_RENOSTROACCT
            when fldname='91' then  P_DORC
            when fldname='92' then  'VND'
            when fldname='93' then  P_SENOSTROACCT
            when fldname='94' then  P_REQCODE
            when fldname='95' then  P_REQKEY
            when fldname='30' then  P_DESC
            else  '' end VALUE
            from fldmaster d
            where objname ='6673'
        )
        LOOP
            
            l_txmsg.txfields (rec.fldname).defname   := rec.defname;
            l_txmsg.txfields (rec.fldname).TYPE      := rec.datatype;
            l_txmsg.txfields (rec.fldname).value      :=  rec.value;
        END LOOP;
        p_err_code:=0;
        IF  txpks_#6673.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <> systemnums.c_success THEN
            
            ROLLBACK;
        else
            p_err_code:=systemnums.c_success;
        end if ;
   EXCEPTION when others THEN
        p_err_code := errnums.C_SYSTEM_ERROR;
        plog.error (pkgctx, SQLERRM);
        ROLLBACK;
   END;

PROCEDURE Bank_NostroWtransfer(
      P_DDACCTNO IN VARCHAR2,  --- tk ddmast tk doi ung (ca nhan)
      P_NOSTROBANKACCT IN VARCHAR2, --- so tk nostro (tu doanh )
      P_BANKTRANS  IN VARCHAR2, ---ma loai nghiep vu trong table BANKNOSTRO.BANKTRANS
      P_DORC    IN VARCHAR2,  -- Debit or credit
      P_AMOUNT  IN  number,  --- so tien
      P_REQCODE IN  VARCHAR2, --request code cua nghiep vu trong allcode
      P_REQKEY  IN VARCHAR2,  --requestkey duy nhat de truy lai giao dich goc
      P_DESC  IN   VARCHAR2,  -- dien giai
      P_TLID  IN   VARCHAR2, -- nguoi tao giao dich
      P_ERR_CODE  OUT VARCHAR2)
    IS
      -- Enter the procedure variables here. As shown below


     l_err_param varchar2(300);
     v_strCURRDATE varchar2(20);
     L_txnum         VARCHAR2(20);
     l_txmsg         tx.msg_rectype;
     v_dorc        varchar2(4);
   BEGIN

    



       SELECT TO_DATE (varvalue, systemnums.c_date_format)
                   INTO v_strCURRDATE
                   FROM sysvar
                   WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    SELECT systemnums.C_BATCH_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO L_txnum
              FROM DUAL;
        l_txmsg.msgtype:='T';
        l_txmsg.local:='N';
        l_txmsg.tlid        := P_TLID;
        SELECT SYS_CONTEXT ('USERENV', 'HOST'),
                 SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
          INTO l_txmsg.wsname, l_txmsg.ipaddress
        FROM DUAL;
        SELECT BRID
          INTO l_txmsg.brid
        FROM TLPROFILES where TLID=P_TLID;
        l_txmsg.off_line    := 'N';
        l_txmsg.deltd       := txnums.c_deltd_txnormal;
        l_txmsg.txstatus    := txstatusnums.c_txcompleted;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        l_txmsg.batchname   := 'DAY';
        l_txmsg.txnum    := L_txnum;
        l_txmsg.txtime    := to_char(SYSdate,'hh24:mm:ss');
        l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.BUSDATE:=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.tltxcd:='6673';



    FOR rec IN
    (
          select d.fldname,d.defname , d.datatype,
               case when fldname='03' then  AFACCTNO
               when fldname='06' then  ACCTNO
               when fldname='10' then  to_char(P_AMOUNT)
               when fldname='88' then  CUSTODYCD
               when fldname='89' then  P_BANKTRANS
               when fldname='90' then  P_NOSTROBANKACCT
               when fldname='91' then  P_DORC
               when fldname='92' then  CCYCD
               when fldname='93' then  REFCASAACCT
               when fldname='94' then  P_REQCODE
               when fldname='95' then  P_REQKEY
               when fldname='30' then  P_DESC
               else  '' end VALUE
      from ddmast dd, (select * from fldmaster where objname ='6673') d
       where dd.acctno = P_DDACCTNO
    )
    LOOP
         
                    l_txmsg.txfields (rec.fldname).defname   := rec.defname;
                    l_txmsg.txfields (rec.fldname).TYPE      := rec.datatype;
                    l_txmsg.txfields (rec.fldname).value      :=  rec.value;
    END LOOP;
    p_err_code:=0;
    IF  txpks_#6673.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <> systemnums.c_success THEN
        
        ROLLBACK;
    else
        p_err_code:=systemnums.c_success;
    end if ;



   EXCEPTION when others THEN
        p_err_code := errnums.C_SYSTEM_ERROR;
        plog.error (pkgctx, SQLERRM);
        ROLLBACK;
   END;

PROCEDURE Bank_NostroWtransfer_Out(
      P_ACCOUNT IN VARCHAR2,  --- tk nhan
      P_NOSTROBANKACCT IN VARCHAR2, --- so tk nostro (tu doanh )
      P_BANKTRANS  IN VARCHAR2, ---
      P_RBANKCITAD IN VARCHAR2, --CITAD
      P_DORC    IN VARCHAR2,  -- Debit or credit
      P_AMOUNT  IN  number,  --- so tien
      P_REQCODE IN  VARCHAR2, --request code cua nghiep vu trong allcode
      P_REQKEY  IN VARCHAR2,  --requestkey duy nhat de truy lai giao dich goc
      P_DESC  IN   VARCHAR2,  -- dien giai
      P_TLID  IN   VARCHAR2, -- nguoi tao giao dich
      P_ERR_CODE  OUT VARCHAR2)
    IS
      -- Enter the procedure variables here. As shown below


     l_err_param varchar2(300);
     v_strCURRDATE varchar2(20);
     L_txnum         VARCHAR2(20);
     l_txmsg         tx.msg_rectype;
     v_dorc        varchar2(4);
     V_BANKNAMECITAD VARCHAR2(100);
     V_BRANCHNAMECITAD VARCHAR2(100);
   BEGIN

--check tai khoan nostro
select decode(banktype,'002','C','D') DORC into v_dorc     ---002 = di tien (tu doanh) => tang tien (ca nhan)
from banknostro
where bankacctno =P_NOSTROBANKACCT;
 if (v_dorc <> P_DORC) then
     p_err_code := -200071;
     return;
 end if;

SELECT NVL(bankname,''),NVL(branchname,'') INTO V_BANKNAMECITAD, V_BRANCHNAMECITAD FROM crbbanklist WHERE CITAD = P_RBANKCITAD;

       SELECT TO_DATE (varvalue, systemnums.c_date_format)
                   INTO v_strCURRDATE
                   FROM sysvar
                   WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    SELECT systemnums.C_BATCH_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO L_txnum
              FROM DUAL;
        l_txmsg.msgtype:='T';
        l_txmsg.local:='N';
        l_txmsg.tlid        := P_TLID;
        SELECT SYS_CONTEXT ('USERENV', 'HOST'),
                 SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
          INTO l_txmsg.wsname, l_txmsg.ipaddress
        FROM DUAL;
        SELECT BRID
          INTO l_txmsg.brid
        FROM TLPROFILES where TLID=P_TLID;
        l_txmsg.off_line    := 'N';
        l_txmsg.deltd       := txnums.c_deltd_txnormal;
        l_txmsg.txstatus    := txstatusnums.c_txcompleted;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        l_txmsg.batchname   := 'DAY';
        l_txmsg.txnum    := L_txnum;
        l_txmsg.txtime    := to_char(SYSdate,'hh24:mi:ss');
        l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.BUSDATE:=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.tltxcd:='6622';



    FOR rec IN
    (
          select d.fldname,d.defname , d.datatype,
               case when fldname='10' then  to_char(P_AMOUNT)
               when fldname='04' then  P_BANKTRANS
               when fldname='18' then  P_NOSTROBANKACCT
               when fldname='91' then  P_DORC
               when fldname='13' then  P_RBANKCITAD
               when fldname='15' then  V_BANKNAMECITAD
               when fldname='16' then  V_BRANCHNAMECITAD
               when fldname='81' then  P_ACCOUNT
               when fldname='94' then  P_REQCODE
               when fldname='95' then  P_REQKEY
               when fldname='30' then  P_DESC
               else  '' end VALUE
      from (select * from fldmaster where objname ='6622') d
    )
    LOOP
         
                    l_txmsg.txfields (rec.fldname).defname   := rec.defname;
                    l_txmsg.txfields (rec.fldname).TYPE      := rec.datatype;
                    l_txmsg.txfields (rec.fldname).value      :=  rec.value;
    END LOOP;
    p_err_code:=0;
    IF  txpks_#6622.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <> systemnums.c_success THEN
        
        ROLLBACK;
    else
        p_err_code:=systemnums.c_success;
    end if ;



   EXCEPTION when others THEN
        p_err_code := errnums.C_SYSTEM_ERROR;
        plog.error (pkgctx, SQLERRM);
        ROLLBACK;
   END;



PROCEDURE Bank_Tranfer_Out_old(
      P_DDACCTNO IN VARCHAR2,  --- tk ddmast tk chuyen
      P_RBANKNAME IN VARCHAR2, ---ten tk nhan
      P_RBANKACCT IN VARCHAR2, --- so tk nhan
      P_RBANKCITAD IN VARCHAR2, --- so citad ngan hang nhan
      P_AMOUNT     number,  --- so tien
      P_REQCODE IN  VARCHAR2, --request code cua nghiep vu trong allcode
      P_REQKEY  IN VARCHAR2,  --requestkey duy nhat de truy lai giao dich goc
      P_DESC  IN   VARCHAR2,  -- dien giai
      P_TLID  IN   VARCHAR2, -- nguoi tao giao dich
      P_ERR_CODE  OUT VARCHAR2)
    IS
      -- Enter the procedure variables here. As shown below


     l_err_param varchar2(300);
     v_strCURRDATE varchar2(20);
     L_txnum         VARCHAR2(20);
     l_txmsg         tx.msg_rectype;
   BEGIN
    

       SELECT TO_DATE (varvalue, systemnums.c_date_format)
                   INTO v_strCURRDATE
                   FROM sysvar
                   WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    SELECT systemnums.C_BATCH_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO L_txnum
              FROM DUAL;
        l_txmsg.msgtype:='T';
        l_txmsg.local:='N';
        l_txmsg.tlid        := P_TLID;
        SELECT SYS_CONTEXT ('USERENV', 'HOST'),
                 SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
          INTO l_txmsg.wsname, l_txmsg.ipaddress
        FROM DUAL;
        SELECT BRID
          INTO l_txmsg.brid
        FROM TLPROFILES where TLID=l_txmsg.tlid;
        l_txmsg.off_line    := 'N';
        l_txmsg.deltd       := txnums.c_deltd_txnormal;
        l_txmsg.txstatus    := txstatusnums.c_txcompleted;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        l_txmsg.batchname   := 'DAY';
        l_txmsg.txnum    := L_txnum;
         l_txmsg.txtime    := to_char(SYSdate,'hh24:mi:ss');
        l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.BUSDATE:=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.tltxcd:='6621';



    FOR rec IN
    (
         select d.fldname,d.defname , d.datatype,
               case when fldname='03' then  AFACCTNO
               when fldname='04' then  P_RBANKCITAD
               when fldname='06' then  P_DDACCTNO
               when fldname='18' then  REFCASAACCT
               when fldname='10' then  to_char(P_AMOUNT)
               when fldname='11' then  '0'
               when fldname='12' then  '0'
               when fldname='14' then  '0'
               when fldname='17' then  ACCTNO
               when fldname='20' then  v_strCURRDATE
               when fldname='65' then  ''
               when fldname='82' then  P_RBANKNAME
               when fldname='81' then  P_RBANKACCT
               when fldname='82' then  P_RBANKNAME
               when fldname='84' then  ''
               when fldname='85' then  ''
               when fldname='86' then  ''
               when fldname='87' then  ''
               when fldname='88' then  CUSTODYCD
               when fldname='89' then  ''
               when fldname='94' then  P_REQCODE
               when fldname='95' then  P_REQKEY
               when fldname='30' then  P_DESC
               else  defname end VALUE
      from ddmast dd, (select * from fldmaster where objname ='6621') d
       where dd.acctno = P_DDACCTNO
    )
    LOOP
         
                    l_txmsg.txfields (rec.fldname).defname   := rec.defname;
                    l_txmsg.txfields (rec.fldname).TYPE      := rec.datatype;
                    l_txmsg.txfields (rec.fldname).value      :=  rec.value;
    END LOOP;
    p_err_code:=0;
    IF  txpks_#6621.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <> systemnums.c_success THEN
        
        ROLLBACK;
    else
        p_err_code:=systemnums.c_success;
    end if ;



   EXCEPTION when others THEN
        p_err_code := errnums.C_SYSTEM_ERROR;
        plog.error (pkgctx, SQLERRM);
        ROLLBACK;
   END;

PROCEDURE Bank_Tranfer_Out(
      P_DDACCTNO IN VARCHAR2,  --- tk ddmast tk chuyen
      P_RBANKNAME IN VARCHAR2, ---ten tk nhan
      P_RBANKACCT IN VARCHAR2, --- so tk nhan
      P_RBANKCITAD IN VARCHAR2, --- so citad ngan hang nhan
  ---    P_feetype  IN VARCHAR2,---loai phi  --> ko fee tax thi de null cung dc, 1- applicant 2-waived, 3-benificiary
      P_AMOUNT     number,  --- so tien
      P_REQCODE IN  VARCHAR2, --request code cua nghiep vu trong allcode
      P_REQKEY  IN VARCHAR2,  --requestkey duy nhat de truy lai giao dich goc
      P_DESC  IN   VARCHAR2,  -- dien giai
      P_TLID  IN   VARCHAR2, -- nguoi tao giao dich
      P_ERR_CODE  OUT VARCHAR2)
 IS
      -- Enter the procedure variables here. As shown below

     v_supebank varchar2(10);
   BEGIN
     
     select trim(cf.supebank) into v_supebank
     from ddmast dd, cfmast cf
      where dd.custodycd = cf.custodycd and dd.acctno=P_DDACCTNO;
     if v_supebank ='Y' then
       Bank_Tranfer_Out_fa(P_DDACCTNO,  P_RBANKNAME ,P_RBANKACCT ,P_RBANKCITAD , '1' ,
                           P_AMOUNT, P_REQCODE,P_REQKEY, P_DESC,P_TLID ,P_ERR_CODE );
     else
       Bank_Tranfer_Out_old( P_DDACCTNO ,  P_RBANKNAME ,P_RBANKACCT, P_RBANKCITAD, P_AMOUNT,
                         P_REQCODE , P_REQKEY , P_DESC , P_TLID ,P_ERR_CODE );
     end if;

     EXCEPTION when others THEN
        p_err_code := errnums.C_SYSTEM_ERROR;
        plog.error (pkgctx, SQLERRM);
        --ROLLBACK;
   END;

PROCEDURE Bank_Tranfer_Out_fa(
      P_DDACCTNO IN VARCHAR2,  --- tk ddmast tk chuyen
      P_RBANKNAME IN VARCHAR2, ---ten tk nhan
      P_RBANKACCT IN VARCHAR2, --- so tk nhan
      P_RBANKCITAD IN VARCHAR2, --- so citad ngan hang nhan
      P_feetype  IN VARCHAR2,---loai phi
      P_AMOUNT     number,  --- so tien
      P_REQCODE IN  VARCHAR2, --request code cua nghiep vu trong allcode
      P_REQKEY  IN VARCHAR2,  --requestkey duy nhat de truy lai giao dich goc
      P_DESC  IN   VARCHAR2,  -- dien giai
      P_TLID  IN   VARCHAR2, -- nguoi tao giao dich
      P_ERR_CODE  OUT VARCHAR2)
    IS
      -- Enter the procedure variables here. As shown below


     l_err_param varchar2(300);
     v_strCURRDATE varchar2(20);
     L_txnum         VARCHAR2(20);
     l_txmsg         tx.msg_rectype;
     v_custodycd   varchar2(30);
     v_feecd   varchar2(30);
     v_feeamt number;
     v_nothing number;
     v_feerate number;
     v_ccycd varchar2(10);
     v_taxamt number;
     l_sysvar varchar2(100);
     l_bondagent varchar2(100);
     v_feecode varchar2(100);
     v_desc varchar2(1000);
     l_desc varchar2(1000);
     v_vatrate number;
     v_feetype VARCHAR2(10);
     v_count number;
   BEGIN
    

       SELECT TO_DATE (varvalue, systemnums.c_date_format)
                   INTO v_strCURRDATE
                   FROM sysvar
                   WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    SELECT systemnums.C_BATCH_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO L_txnum
              FROM DUAL;
        l_txmsg.msgtype:='T';
        l_txmsg.local:='N';
        l_txmsg.tlid        := P_TLID;
        SELECT SYS_CONTEXT ('USERENV', 'HOST'),
                 SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
          INTO l_txmsg.wsname, l_txmsg.ipaddress
        FROM DUAL;
        SELECT BRID
          INTO l_txmsg.brid
        FROM TLPROFILES where TLID=l_txmsg.tlid;
        l_txmsg.off_line    := 'N';
        l_txmsg.deltd       := txnums.c_deltd_txnormal;
        l_txmsg.txstatus    := txstatusnums.c_txcompleted;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        l_txmsg.batchname   := 'DAY';
        l_txmsg.txnum    := L_txnum;
        l_txmsg.txtime    := to_char(SYSdate,'hh24:mi:ss');
        l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.BUSDATE:=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.tltxcd:='6651';

        v_feetype := P_feetype;

        if P_feetype = '2' then -- khong thu phi mac dinh phi thue =0
            v_feeamt:=0;
            v_taxamt:=0;
        elsif P_feetype IN ('4', '5', '6') then -- tinh phi domestic cho Khach CB
            --trung.luu: 08/06/2020 SHBVNEX-1073 Kh?ng ti?nh d??i vo?i kha?ch ha`ng Bondagent = Yes
            select custodycd into v_custodycd from ddmast where acctno=P_DDACCTNO;
            select bondagent into l_bondagent from cfmast where custodycd = v_custodycd;

            --trung.luu: 08/06/2020 SHBVNEX-1158 b? t?nh ph? cho TK t? doanh
            SELECT varvalue into l_sysvar from sysvar where varname = 'DEALINGCUSTODYCD';
            if l_bondagent <> 'Y' and substr(v_custodycd,0,4) <> l_sysvar then
                v_nothing := cspks_feecalc.FN_CB_CITAD_CALC(v_custodycd, P_AMOUNT, 0, v_feecd, v_feeamt, v_feerate, v_ccycd);
                --
                --trung.luu: 21-09-2020  SHBVNEX-1569
                v_nothing := cspks_feecalc.fn_tax_calc ( v_custodycd, v_feeamt,v_ccycd,v_feecd,2/*pv_round in number*/,v_taxamt,v_vatrate);
                begin
                    SELECT feecode into v_feecode
                    from FEEMASTER
                    where feecd =v_feecd and status='Y';
                exception when NO_DATA_FOUND then
                    p_err_code := '-930026';
                    return;
                end;

                SELECT en_display into v_desc FROM vw_feedetails_all
                WHERE filtercd ='014' and id='OTHER';

                l_desc:=v_desc||' dated '||to_char(TO_DATE (v_strCURRDATE, systemnums.C_DATE_FORMAT),'DD Mon YYYY');
                -- v_vatamt:=round((v_vatrate/100)*v_feeamt,2);

                --
                INSERT INTO FEETRAN(TXDATE, TXNUM, DELTD, FEECD, GLACCTNO, TXAMT, FEEAMT, FEERATE, VATRATE, VATAMT, AUTOID, TRDESC, CCYCD, ORDERID, TYPE, DEDUCTEDPLACE, STATUS,PAIDDATE,PSTATUS,SUBTYPE,FEETYPES,CUSTODYCD,FEECODE)
                VALUES (TO_DATE(to_date(substr(P_REQKEY,4,8),'RRRR/MM/DD'),'DD/MM/RRRR'),substr(P_REQKEY,13,10),'N',v_feecd,NULL,P_AMOUNT,v_feeamt,v_feerate,v_vatrate,v_taxamt,SEQ_FEETRAN.NEXTVAL,l_desc,v_ccycd,NULL,'F', NULL, DECODE(P_feetype, '4', 'N', 'C'), NULL, NULL,'014','OTHER',v_custodycd,v_feecode);
            end if;

            SELECT (CASE WHEN V_FEETYPE = '5' THEN '1'
                        WHEN V_FEETYPE = '6' THEN '3'
                        ELSE '4'
                   END) INTO V_FEETYPE
            FROM DUAL;
        else
            select custodycd into v_custodycd from ddmast where acctno=P_DDACCTNO;
            v_nothing:=cspks_feecalc.fn_transfer_calc(v_custodycd,P_AMOUNT,0, v_feecd, v_feeamt , v_feerate, v_ccycd);

            begin
                select round(to_number(vatrate)*v_feeamt/100) into v_taxamt
                from feemaster where REFCODE='OTHER' and SUBTYPE='004' and ccycd='VND';
            exception when others then
                v_taxamt:=0;
            end;
            
        end if;

        SELECT COUNT(1) INTO v_count FROM ALLCODE WHERE CDNAME = 'IOROFEE' AND CDTYPE = 'SA' AND CDVAL = v_feetype;

        IF v_count = 0 THEN
            v_feetype := '2';
        END IF;

    FOR rec IN
    (
         select d.fldname,d.defname , d.datatype,
               case when fldname='03' then  AFACCTNO
               when fldname='04' then  P_RBANKCITAD
               when fldname='06' then  P_DDACCTNO
               when fldname='18' then  REFCASAACCT
               when fldname='10' then  to_char(P_AMOUNT)
               when fldname='11' then  to_char(v_feeamt)
               when fldname='12' then  to_char(v_taxamt) --tax amount
               when fldname='14' then  '0'
               when fldname='17' then  ACCTNO
               when fldname='20' then  v_strCURRDATE
               when fldname='65' then  ''
               when fldname='69' then  v_feetype
               when fldname='70' then  'DFTDO37'  ---hardcode
               when fldname='82' then  P_RBANKNAME
               when fldname='81' then  P_RBANKACCT
               when fldname='82' then  P_RBANKNAME
               when fldname='84' then  ''
               when fldname='85' then  ''
               when fldname='86' then  ''
               when fldname='87' then  ''
               when fldname='88' then  CUSTODYCD
               when fldname='89' then  ''
               when fldname='94' then  P_REQCODE
               when fldname='95' then  P_REQKEY
               when fldname='30' then  P_DESC
               else  defname end VALUE
      from ddmast dd, (select * from fldmaster where objname ='6651') d
       where dd.acctno = P_DDACCTNO
    )
    LOOP
         
                    l_txmsg.txfields (rec.fldname).defname   := rec.defname;
                    l_txmsg.txfields (rec.fldname).TYPE      := rec.datatype;
                    l_txmsg.txfields (rec.fldname).value      :=  rec.value;
    END LOOP;
    p_err_code:=0;
    IF  txpks_#6651.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <> systemnums.c_success THEN
        plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
        --ROLLBACK;
    else
        p_err_code:=systemnums.c_success;
    end if ;



   EXCEPTION when others THEN
        p_err_code := errnums.C_SYSTEM_ERROR;
        plog.error (pkgctx, SQLERRM);
        --ROLLBACK;
   END;

PROCEDURE Bank_Tranfer_Out_gbond(
      P_DDACCTNO IN VARCHAR2,  --- tk ddmast tk chuyen
      P_RBANKNAME IN VARCHAR2, ---ten tk nhan
      P_RBANKACCT IN VARCHAR2, --- so tk nhan
      P_RBANKCITAD IN VARCHAR2, --- so citad ngan hang nhan
      P_feetype  IN VARCHAR2,---loai phi
      P_AMOUNT     number,  --- so tien
      P_REQCODE IN  VARCHAR2, --request code cua nghiep vu trong allcode
      P_REQKEY  IN VARCHAR2,  --requestkey duy nhat de truy lai giao dich goc
      P_DESC  IN   VARCHAR2,  -- dien giai
      P_TLID  IN   VARCHAR2, -- nguoi tao giao dich
      P_IDENTITY IN VARCHAR2, -- so dinh danh GBOND
      P_ERR_CODE  OUT VARCHAR2)
    IS
      -- Enter the procedure variables here. As shown below


     l_err_param varchar2(300);
     v_strCURRDATE varchar2(20);
     L_txnum         VARCHAR2(20);
     l_txmsg         tx.msg_rectype;
     v_custodycd   varchar2(30);
     v_feecd   varchar2(30);
     v_feeamt number;
     v_nothing number;
     v_feerate number;
     v_ccycd varchar2(10);
     v_taxamt number;
   BEGIN
    

       SELECT TO_DATE (varvalue, systemnums.c_date_format)
                   INTO v_strCURRDATE
                   FROM sysvar
                   WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    SELECT systemnums.C_BATCH_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO L_txnum
              FROM DUAL;
        l_txmsg.msgtype:='T';
        l_txmsg.local:='N';
        l_txmsg.tlid        := P_TLID;
        SELECT SYS_CONTEXT ('USERENV', 'HOST'),
                 SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
          INTO l_txmsg.wsname, l_txmsg.ipaddress
        FROM DUAL;
        SELECT BRID
          INTO l_txmsg.brid
        FROM TLPROFILES where TLID=l_txmsg.tlid;
        l_txmsg.off_line    := 'N';
        l_txmsg.deltd       := txnums.c_deltd_txnormal;
        l_txmsg.txstatus    := txstatusnums.c_txcompleted;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        l_txmsg.batchname   := 'DAY';
        l_txmsg.txnum    := L_txnum;
         l_txmsg.txtime    := to_char(SYSdate,'hh24:mi:ss');
        l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.BUSDATE:=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.tltxcd:='6652';

        if P_feetype='2' then -- khong thu phi mac dinh phi thue =0
        v_feeamt:=0;
         v_taxamt:=0;
        else
        select custodycd into v_custodycd from ddmast where acctno=P_DDACCTNO;
        v_nothing:=cspks_feecalc.fn_transfer_calc(v_custodycd,P_AMOUNT,0, v_feecd, v_feeamt , v_feerate, v_ccycd);

                begin
                select round(to_number(vatrate)*v_feeamt/100) into v_taxamt
                from feemaster where REFCODE='OTHER' and SUBTYPE='004' and ccycd='VND';
                exception when others then
                v_taxamt:=0;
                end;
        
        end if;

    FOR rec IN
    (
         select d.fldname,d.defname , d.datatype,
               case when fldname='03' then  AFACCTNO
               when fldname='04' then  P_RBANKCITAD
               when fldname='06' then  P_DDACCTNO
               when fldname='18' then  REFCASAACCT
               when fldname='10' then  to_char(P_AMOUNT)
               when fldname='11' then  to_char(v_feeamt)
               when fldname='12' then  to_char(v_taxamt) --tax amount
               when fldname='14' then  '0'
               when fldname='17' then  ACCTNO
               when fldname='20' then  v_strCURRDATE
               when fldname='65' then  ''
               when fldname='69' then  P_feetype
               when fldname='70' then  'DFTDO37'  ---hardcode
               when fldname='82' then  P_RBANKNAME
               when fldname='81' then  P_RBANKACCT
               when fldname='82' then  P_RBANKNAME
               when fldname='84' then  P_IDENTITY   --ma dinh danh GBOND
               when fldname='85' then  ''
               when fldname='86' then  ''
               when fldname='87' then  ''
               when fldname='88' then  CUSTODYCD
               when fldname='89' then  ''
               when fldname='94' then  P_REQCODE
               when fldname='95' then  P_REQKEY
               when fldname='30' then  P_DESC
               else  defname end VALUE
      from ddmast dd, (select * from fldmaster where objname ='6652') d
       where dd.acctno = P_DDACCTNO
    )
    LOOP
         
                    l_txmsg.txfields (rec.fldname).defname   := rec.defname;
                    l_txmsg.txfields (rec.fldname).TYPE      := rec.datatype;
                    l_txmsg.txfields (rec.fldname).value      :=  rec.value;
    END LOOP;
    p_err_code:=0;
    IF  txpks_#6652.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <> systemnums.c_success THEN
        plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
        --ROLLBACK;
    else
        p_err_code:=systemnums.c_success;
    end if ;



   EXCEPTION when others THEN
        p_err_code := errnums.C_SYSTEM_ERROR;
        plog.error (pkgctx, SQLERRM);
        --ROLLBACK;
   END;

PROCEDURE Bank_Internal_Tranfer_fa(
      P_DDACCTNO IN VARCHAR2,  --- tk ddmast tk chuyen
      P_RBANKNAME IN VARCHAR2, ---ten tk nhan
      P_RBANKACCT IN VARCHAR2, --- so tk nhan
      P_AMOUNT     number,  --- so tien
      P_REQCODE IN  VARCHAR2, --request code cua nghiep vu trong allcode
      P_REQKEY  IN VARCHAR2,  --requestkey duy nhat de truy lai giao dich goc
      P_DESC  IN   VARCHAR2,  -- dien giai
      P_TLID  IN   VARCHAR2, -- nguoi tao giao dich
      P_ERR_CODE  OUT VARCHAR2)
    IS
      -- Enter the procedure variables here. As shown below


     l_err_param varchar2(300);
     v_strCURRDATE varchar2(20);
     L_txnum         VARCHAR2(20);
     l_txmsg         tx.msg_rectype;
   BEGIN
    

       SELECT TO_DATE (varvalue, systemnums.c_date_format)
                   INTO v_strCURRDATE
                   FROM sysvar
                   WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    SELECT systemnums.C_BATCH_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO L_txnum
              FROM DUAL;
        l_txmsg.msgtype:='T';
        l_txmsg.local:='N';
        l_txmsg.tlid        := P_TLID;
        SELECT SYS_CONTEXT ('USERENV', 'HOST'),
                 SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
          INTO l_txmsg.wsname, l_txmsg.ipaddress
        FROM DUAL;
        SELECT BRID
          INTO l_txmsg.brid
        FROM TLPROFILES where TLID=l_txmsg.tlid;
        l_txmsg.off_line    := 'N';
        l_txmsg.deltd       := txnums.c_deltd_txnormal;
        l_txmsg.txstatus    := txstatusnums.c_txcompleted;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        l_txmsg.batchname   := 'DAY';
        l_txmsg.txnum    := L_txnum;
        l_txmsg.txtime    := to_char(SYSdate,'hh24:mi:ss');
        l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.BUSDATE:=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.tltxcd:='6650';



    FOR rec IN
    (
         select d.fldname,d.defname , d.datatype,
               case when fldname='03' then  AFACCTNO
               when fldname='04' then  ACCTNO
               when fldname='06' then  ACCTNO
               when fldname='93' then  REFCASAACCT
               when fldname='10' then  to_char(P_AMOUNT)
               when fldname='14' then  '0'
               when fldname='20' then  v_strCURRDATE
               when fldname='88' then  CUSTODYCD
               when fldname='89' then  '0'
               when fldname='80' then  P_RBANKNAME
               when fldname='81' then  P_RBANKACCT
               when fldname='94' then  P_REQCODE
               when fldname='95' then  P_REQKEY
               when fldname='30' then  P_DESC
               else  defname end VALUE
      from ddmast dd, (select * from fldmaster where objname ='6650') d
       where dd.acctno = P_DDACCTNO
    )
    LOOP
        
                    l_txmsg.txfields (rec.fldname).defname   := rec.defname;
                    l_txmsg.txfields (rec.fldname).TYPE      := rec.datatype;
                    l_txmsg.txfields (rec.fldname).value      :=  rec.value;
    END LOOP;
    p_err_code:=0;
    IF  txpks_#6650.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <> systemnums.c_success THEN
        
        ROLLBACK;
    else
        p_err_code:=systemnums.c_success;
    end if ;



   EXCEPTION when others THEN
        p_err_code := errnums.C_SYSTEM_ERROR;
        plog.error (pkgctx, SQLERRM);
        ROLLBACK;
   END;


PROCEDURE Bank_Internal_Tranfer(
      P_DDACCTNO IN VARCHAR2,  --- tk ddmast tk chuyen
      P_RBANKNAME IN VARCHAR2, ---ten tk nhan
      P_RBANKACCT IN VARCHAR2, --- so tk nhan
      P_AMOUNT     number,  --- so tien
      P_REQCODE IN  VARCHAR2, --request code cua nghiep vu trong allcode
      P_REQKEY  IN VARCHAR2,  --requestkey duy nhat de truy lai giao dich goc
      P_DESC  IN   VARCHAR2,  -- dien giai
      P_TLID  IN   VARCHAR2, -- nguoi tao giao dich
      P_ERR_CODE  OUT VARCHAR2)
    IS
      -- Enter the procedure variables here. As shown below


     l_err_param varchar2(300);
     v_strCURRDATE varchar2(20);
     L_txnum         VARCHAR2(20);
     l_txmsg         tx.msg_rectype;
   BEGIN
    

       SELECT TO_DATE (varvalue, systemnums.c_date_format)
                   INTO v_strCURRDATE
                   FROM sysvar
                   WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    SELECT systemnums.C_BATCH_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO L_txnum
              FROM DUAL;
        l_txmsg.msgtype:='T';
        l_txmsg.local:='N';
        l_txmsg.tlid        := P_TLID;
        SELECT SYS_CONTEXT ('USERENV', 'HOST'),
                 SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
          INTO l_txmsg.wsname, l_txmsg.ipaddress
        FROM DUAL;
        SELECT BRID
          INTO l_txmsg.brid
        FROM TLPROFILES where TLID=l_txmsg.tlid;
        l_txmsg.off_line    := 'N';
        l_txmsg.deltd       := txnums.c_deltd_txnormal;
        l_txmsg.txstatus    := txstatusnums.c_txcompleted;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        l_txmsg.batchname   := 'DAY';
        l_txmsg.txnum    := L_txnum;
        l_txmsg.txtime    := to_char(SYSdate,'hh24:mi:ss');
        l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.BUSDATE:=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.tltxcd:='6620';



    FOR rec IN
    (
         select d.fldname,d.defname , d.datatype,
               case when fldname='03' then  AFACCTNO
               when fldname='04' then  ACCTNO
               when fldname='06' then  ACCTNO
               when fldname='93' then  REFCASAACCT
               when fldname='10' then  to_char(P_AMOUNT)
               when fldname='14' then  '0'
               when fldname='20' then  v_strCURRDATE
               when fldname='88' then  CUSTODYCD
               when fldname='89' then  '0'
               when fldname='80' then  P_RBANKNAME
               when fldname='81' then  P_RBANKACCT
               when fldname='94' then  P_REQCODE
               when fldname='95' then  P_REQKEY
               when fldname='30' then  P_DESC
               else  defname end VALUE
      from ddmast dd, (select * from fldmaster where objname ='6620') d
       where dd.acctno = P_DDACCTNO
    )
    LOOP
         
                    l_txmsg.txfields (rec.fldname).defname   := rec.defname;
                    l_txmsg.txfields (rec.fldname).TYPE      := rec.datatype;
                    l_txmsg.txfields (rec.fldname).value      :=  rec.value;
    END LOOP;
    p_err_code:=0;
    IF  txpks_#6620.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <> systemnums.c_success THEN
        
        ROLLBACK;
    else
        p_err_code:=systemnums.c_success;
    end if ;



   EXCEPTION when others THEN
        p_err_code := errnums.C_SYSTEM_ERROR;
        plog.error (pkgctx, SQLERRM);
        ROLLBACK;
   END;


PROCEDURE Bank_Inquiry(
      P_DDACCTNO IN VARCHAR2,  --- tk ddmast
      P_REQCODE IN  VARCHAR2, --request code cua nghiep vu trong allcode
      P_REQKEY  IN VARCHAR2,  --requestkey duy nhat de truy lai giao dich goc
      P_DESC  IN   VARCHAR2,  -- dien giai
      P_TLID  IN   VARCHAR2, -- nguoi tao giao dich
      P_ERR_CODE  OUT VARCHAR2)
    IS
      -- Enter the procedure variables here. As shown below


     l_err_param varchar2(300);
     v_strCURRDATE varchar2(20);
     L_txnum         VARCHAR2(20);
     l_txmsg         tx.msg_rectype;
   BEGIN

       SELECT TO_DATE (varvalue, systemnums.c_date_format)
                   INTO v_strCURRDATE
                   FROM sysvar
                   WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    SELECT systemnums.C_BATCH_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO L_txnum
              FROM DUAL;
        l_txmsg.msgtype:='T';
        l_txmsg.local:='N';
        l_txmsg.tlid        := P_TLID;
        SELECT SYS_CONTEXT ('USERENV', 'HOST'),
                 SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
          INTO l_txmsg.wsname, l_txmsg.ipaddress
        FROM DUAL;
        SELECT BRID
          INTO l_txmsg.brid
        FROM TLPROFILES where TLID=P_TLID;
        l_txmsg.off_line    := 'N';
        l_txmsg.deltd       := txnums.c_deltd_txnormal;
        l_txmsg.txstatus    := txstatusnums.c_txcompleted;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        l_txmsg.batchname   := 'DAY';
        l_txmsg.txnum    := L_txnum;
        l_txmsg.txtime    := to_char(SYSdate,'hh24:mi:ss');
        l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.BUSDATE:=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.tltxcd:='6671';



    FOR rec IN
    (
         select d.fldname,d.defname , d.datatype,
               case when fldname='03' then  AFACCTNO
               when fldname='04' then  P_DDACCTNO
               when fldname='10' then  '0'
               when fldname='88' then  CUSTODYCD
               when fldname='90' then  ''
               when fldname='93' then  REFCASAACCT
               when fldname='94' then  P_REQCODE
               when fldname='95' then  P_REQKEY
               when fldname='30' then  P_DESC
               else  '' end VALUE
      from ddmast dd, (select * from fldmaster where objname ='6671') d
      where dd.acctno = P_DDACCTNO
    )
    LOOP
         
                    l_txmsg.txfields (rec.fldname).defname   := rec.defname;
                    l_txmsg.txfields (rec.fldname).TYPE      := rec.datatype;
                    l_txmsg.txfields (rec.fldname).value      :=  rec.value;
    END LOOP;
    p_err_code:=0;
    IF  txpks_#6671.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <> systemnums.c_success THEN
        
        ROLLBACK;
    else
        p_err_code:=systemnums.c_success;
    end if ;



   EXCEPTION when others THEN
        p_err_code := errnums.C_SYSTEM_ERROR;
        plog.error (pkgctx, SQLERRM|| dbms_utility.format_error_backtrace);
        ROLLBACK;
   END;

   PROCEDURE Bank_Inquiry_List(
      P_DDACCTNO IN VARCHAR2,  --- DS tk ddmast
      P_REQKEY  IN VARCHAR2,  --requestkey duy nhat de truy lai giao dich goc
      P_DESC  IN   VARCHAR2,  -- dien giai
      P_TLID  IN   VARCHAR2, -- nguoi tao giao dich
      P_ERR_CODE  OUT VARCHAR2
   )

   IS
      -- Enter the procedure variables here. As shown below

     --P_ERR_CODE NUMBER;
     l_REQCODE varchar2(50);
     l_EXISTS number;
   BEGIN
    plog.setbeginsection (pkgctx, 'Bank_Inquiry_List');
    l_REQCODE := 'INQACCT';

    IF P_DDACCTNO = 'ALL' THEN
        FOR REC IN (
            SELECT * FROM DDMAST dd
            WHERE dd.STATUS <> 'C'
                and not EXISTS(select * from CRBTXREQ rq
                                WHERE AFACCTNO = TRIM(dd.ACCTNO)
                                    AND REQCODE = L_REQCODE
                                    AND STATUS NOT IN ( 'R','E','C')
                            )
        ) LOOP
            update DDMAST set INQBANKREQID = P_REQKEY
            where acctno =  trim(rec.ACCTNO)
            --update crbtxreq set notes = 'Old request'
            --where afacctno = REC.ACCTNO and reqcode = l_REQCODE --and reqtxnum = P_REQKEY
            ;
            Bank_Inquiry(
                      REC.ACCTNO,  --- tk ddmast
                      l_REQCODE, --request code cua nghiep vu trong allcode
                      P_REQKEY,  --requestkey duy nhat de truy lai giao dich goc
                      P_DESC,  -- dien giai
                      P_TLID, -- nguoi tao giao dich
                      P_ERR_CODE);
                if P_ERR_CODE <> systemnums.C_SUCCESS then
                    ROLLBACK;
                    plog.setendsection (pkgctx, 'Bank_Inquiry_List');
                    RETURN ;
                end if;
        END LOOP;
    ELSE
        --
            /*FOR DDACCTNO IN (
                    SELECT REGEXP_SUBSTR (P_DDACCTNO,
                                     '[^,]+',
                                     1,
                                     LEVEL)
                         TXT
                    FROM DUAL
                    CONNECT BY REGEXP_SUBSTR (P_DDACCTNO,
                                     '[^,]+',
                                     1,
                                     LEVEL)
                         IS NOT NULL)
            LOOP

                if length(to_char(DDACCTNO.txt)) > 0 then
                    update crbtxreq set notes = 'Old request'
                    where afacctno = to_char(DDACCTNO.txt) and reqcode = l_REQCODE and reqtxnum = P_REQKEY;

                    Bank_Inquiry(
                          to_char(trim(DDACCTNO.txt)),  --- tk ddmast
                          l_REQCODE, --request code cua nghiep vu trong allcode
                          P_REQKEY,  --requestkey duy nhat de truy lai giao dich goc
                          P_DESC,  -- dien giai
                          P_TLID, -- nguoi tao giao dich
                          P_ERR_CODE);
                    if P_ERR_CODE <> systemnums.C_SUCCESS then
                        ROLLBACK;
                        plog.setendsection (pkgctx, 'Bank_Inquiry_List');
                        RETURN ;
                    end if;
                end if;
            END LOOP;*/
            if length(trim(P_DDACCTNO)) > 0 then
                SELECT COUNT(*) INTO L_EXISTS FROM CRBTXREQ WHERE AFACCTNO = TRIM(P_DDACCTNO) AND REQCODE = L_REQCODE AND STATUS NOT IN ( 'R','E','C');
                if L_EXISTS = 0 then
                    update DDMAST set INQBANKREQID = P_REQKEY
                    where acctno =  trim(P_DDACCTNO)
                    --update crbtxreq set notes = 'Old request'
                    --where afacctno = trim(P_DDACCTNO) and reqcode = l_REQCODE --and reqtxnum = P_REQKEY
                    ;

                    Bank_Inquiry(
                          trim(P_DDACCTNO),  --- tk ddmast
                          l_REQCODE, --request code cua nghiep vu trong allcode
                          P_REQKEY,  --requestkey duy nhat de truy lai giao dich goc
                          P_DESC,  -- dien giai
                          P_TLID, -- nguoi tao giao dich
                          P_ERR_CODE);
                    if P_ERR_CODE <> systemnums.C_SUCCESS then
                        ROLLBACK;
                        plog.setendsection (pkgctx, 'Bank_Inquiry_List');
                        RETURN ;
                    end if;
                end if;
            end if;
        END IF;

        P_ERR_CODE := systemnums.C_SUCCESS;
        plog.setendsection (pkgctx, 'Bank_Inquiry_List');
        RETURN ;


   EXCEPTION when others THEN
        p_err_code := errnums.C_SYSTEM_ERROR;
        plog.error (pkgctx, SQLERRM|| dbms_utility.format_error_backtrace);
        plog.setendsection (pkgctx, 'Bank_Inquiry_List');
        ROLLBACK;
        RETURN ;
   END;



   PROCEDURE Bank_UNholdbalance(
      P_REFHOLDTXNUM IN VARCHAR2 ,  ---txnum cua giao dich hold
      P_DDACCTNO IN VARCHAR2,  --- tk ddmast
      P_AMOUNT  IN  NUMBER,  -- so tien
      P_REQCODE IN  VARCHAR2, --request code cua nghiep vu trong allcode
      P_REQKEY  IN VARCHAR2,  --requestkey duy nhat de truy lai giao dich goc
      P_DESC  IN   VARCHAR2,  -- dien giai
      P_TLID  IN   VARCHAR2, -- nguoi tao giao dich
      P_ERR_CODE  OUT VARCHAR2)
    IS
      -- Enter the procedure variables here. As shown below


     l_err_param varchar2(300);
     v_strCURRDATE varchar2(20);
     L_txnum         VARCHAR2(20);
     l_txmsg         tx.msg_rectype;
     l_6690holdtxnum varchar2(50);
     v_reftxdate varchar2(20);
   BEGIN
    

      select objkey, to_char(txdate,'DD/MM/RRRR') into l_6690holdtxnum,v_reftxdate
      from crbtxreq
      where reqtxnum = P_REFHOLDTXNUM and status = 'C' and trfcode = 'HOLD';

    --
    --
    --

       SELECT varvalue
                   INTO v_strCURRDATE
                   FROM sysvar
                   WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
        SELECT systemnums.C_BATCH_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO L_txnum
              FROM DUAL;
        l_txmsg.msgtype:='T';
        l_txmsg.local:='N';
        l_txmsg.tlid        := P_TLID;
        SELECT SYS_CONTEXT ('USERENV', 'HOST'),
                 SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
          INTO l_txmsg.wsname, l_txmsg.ipaddress
        FROM DUAL;
        SELECT BRID
          INTO l_txmsg.brid
        FROM TLPROFILES where TLID=P_TLID;
        if P_REQCODE = 'BANKUNHOLDEDBYBROKER' then
            l_txmsg.batchname   := 'BROKERCONFIRM';
        else
            l_txmsg.batchname   := 'DAY';
        end if;

        l_txmsg.off_line    := 'N';
        l_txmsg.deltd       := txnums.c_deltd_txnormal;
        l_txmsg.txstatus    := txstatusnums.c_txcompleted;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        --l_txmsg.batchname   := 'DAY';
        l_txmsg.txnum    := L_txnum;
         l_txmsg.txtime    := to_char(SYSdate,'hh24:mi:ss');
        l_txmsg.reftxnum    := l_6690holdtxnum;

        l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.BUSDATE:=to_date(v_reftxdate,systemnums.c_date_format);
        l_txmsg.tltxcd:='6691';

 if v_strCURRDATE = v_reftxdate then

    FOR rec IN
    (
         select d.fldname,d.defname , d.datatype,
               case when fldname='91' then  l_6690holdtxnum
               when fldname='04' then  P_DDACCTNO
               when fldname='03' then  to_char(P_AMOUNT)
               when fldname='94' then  P_REQCODE
               when fldname='95' then  P_REQKEY
               when fldname='30' then  P_DESC
               else  nvl(nvl(CVALUE,NVALUE),'0') end VALUE
      from (select * from tllogfld where txnum=l_6690holdtxnum) f, (select * from fldmaster where objname ='6691') d
      where d.fldname= f.fldcd(+)
    )
    LOOP
         --
                    l_txmsg.txfields (rec.fldname).defname   := rec.defname;
                    l_txmsg.txfields (rec.fldname).TYPE      := rec.datatype;
                    l_txmsg.txfields (rec.fldname).value      :=  rec.value;
    END LOOP;

 else
      FOR rec IN
    (
         select d.fldname,d.defname , d.datatype,
               case when fldname='91' then  l_6690holdtxnum
               when fldname='04' then  P_DDACCTNO
               when fldname='03' then  to_char(P_AMOUNT)
               when fldname='94' then  P_REQCODE
               when fldname='95' then  P_REQKEY
               when fldname='30' then  P_DESC
               else  nvl(nvl(CVALUE,NVALUE),'0') end VALUE
      from (select * from tllogfldall where txnum=l_6690holdtxnum and to_char(txdate,'DD/MM/RRRR') =v_reftxdate ) f, (select * from fldmaster where objname ='6691') d
      where d.fldname= f.fldcd(+)
    )
    LOOP
         --
                    l_txmsg.txfields (rec.fldname).defname   := rec.defname;
                    l_txmsg.txfields (rec.fldname).TYPE      := rec.datatype;
                    l_txmsg.txfields (rec.fldname).value      :=  rec.value;
    END LOOP;
 end if;

    p_err_code:=0;

    IF  txpks_#6691.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <> systemnums.c_success THEN
        
        --ROLLBACK;
        RAISE errnums.E_SYSTEM_ERROR;
    else
        --
        --
        --
        p_err_code:=systemnums.c_success;
    end if ;



   EXCEPTION when others THEN
        p_err_code := errnums.C_SYSTEM_ERROR;
        plog.error (pkgctx, SQLERRM|| dbms_utility.format_error_backtrace);
        ROLLBACK;
   END;

PROCEDURE Bank_UNholdbalance_No_Broker(
      P_REFHOLDTXNUM IN VARCHAR2 ,  ---txnum cua giao dich hold
      P_DDACCTNO IN VARCHAR2,  --- tk ddmast
      P_AMOUNT  IN  NUMBER,  -- so tien
      P_REQCODE IN  VARCHAR2, --request code cua nghiep vu trong allcode
      P_REQKEY  IN VARCHAR2,  --requestkey duy nhat de truy lai giao dich goc
      P_DESC  IN   VARCHAR2,  -- dien giai
      P_TLID  IN   VARCHAR2, -- nguoi tao giao dich
      P_ERR_CODE  OUT VARCHAR2)
    IS
      -- Enter the procedure variables here. As shown below


     l_err_param varchar2(300);
     v_strCURRDATE varchar2(20);
     L_txnum         VARCHAR2(20);
     l_txmsg         tx.msg_rectype;
     l_6690holdtxnum varchar2(50);
     v_reftxdate varchar2(20);
   BEGIN
    

  select objkey, to_char(txdate,'DD/MM/RRRR') into l_6690holdtxnum,v_reftxdate
  from crbtxreq
  where reqtxnum = P_REFHOLDTXNUM and status = 'C' and trfcode = 'HOLD' AND unhold = 'N' AND ROWNUM = 1;



       SELECT varvalue
                   INTO v_strCURRDATE
                   FROM sysvar
                   WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    SELECT systemnums.C_BATCH_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO L_txnum
              FROM DUAL;
        l_txmsg.msgtype:='T';
        l_txmsg.local:='N';
        l_txmsg.tlid        := P_TLID;
        SELECT SYS_CONTEXT ('USERENV', 'HOST'),
                 SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
          INTO l_txmsg.wsname, l_txmsg.ipaddress
        FROM DUAL;
        SELECT BRID
          INTO l_txmsg.brid
        FROM TLPROFILES where TLID=P_TLID;
        if P_REQCODE = 'BANKUNHOLDEDBYBROKER' then
            l_txmsg.batchname   := 'BROKERCONFIRM';
        else
            l_txmsg.batchname   := 'DAY';
        end if;

        l_txmsg.off_line    := 'N';
        l_txmsg.deltd       := txnums.c_deltd_txnormal;
        l_txmsg.txstatus    := txstatusnums.c_txcompleted;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        --l_txmsg.batchname   := 'DAY';
        l_txmsg.txnum    := L_txnum;
         l_txmsg.txtime    := to_char(SYSdate,'hh24:mi:ss');
        l_txmsg.reftxnum    := l_6690holdtxnum;

        l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.BUSDATE:=to_date(v_reftxdate,systemnums.c_date_format);
        l_txmsg.tltxcd:='6691';

 if v_strCURRDATE = v_reftxdate then

    FOR rec IN
    (
         select d.fldname,d.defname , d.datatype,
               case when fldname='91' then  l_6690holdtxnum
               when fldname='04' then  P_DDACCTNO
               when fldname='03' then  to_char(P_AMOUNT)
               when fldname='94' then  P_REQCODE
               when fldname='95' then  P_REQKEY
               when fldname='30' then  P_DESC
               when fldname ='05' then ''
               else  nvl(nvl(CVALUE,NVALUE),'0') end VALUE
      from (select * from tllogfld where txnum=l_6690holdtxnum ) f, (select * from fldmaster where objname ='6691' ) d
      where d.fldname= f.fldcd(+)
    )
    LOOP
         
                    l_txmsg.txfields (rec.fldname).defname   := rec.defname;
                    l_txmsg.txfields (rec.fldname).TYPE      := rec.datatype;
                    l_txmsg.txfields (rec.fldname).value      :=  rec.value;
    END LOOP;

 else
      FOR rec IN
    (
         select d.fldname,d.defname , d.datatype,
               case when fldname='91' then  l_6690holdtxnum
               when fldname='04' then  P_DDACCTNO
               when fldname='03' then  to_char(P_AMOUNT)
               when fldname='94' then  P_REQCODE
               when fldname='95' then  P_REQKEY
               when fldname='30' then  P_DESC
               when fldname ='05' then ''
               else  nvl(nvl(CVALUE,NVALUE),'0') end VALUE
      from (select * from tllogfldall where txnum=l_6690holdtxnum and to_char(txdate,'DD/MM/RRRR') =v_reftxdate ) f, (select * from fldmaster where objname ='6691') d
      where d.fldname= f.fldcd(+)
    )
    LOOP
         
                    l_txmsg.txfields (rec.fldname).defname   := rec.defname;
                    l_txmsg.txfields (rec.fldname).TYPE      := rec.datatype;
                    l_txmsg.txfields (rec.fldname).value      :=  rec.value;
    END LOOP;
 end if;

    p_err_code:=0;

    IF  txpks_#6691.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <> systemnums.c_success THEN
        
        --ROLLBACK;
        --p_err_code := -1;
        RAISE errnums.E_SYSTEM_ERROR;
    else
        
        p_err_code:=systemnums.c_success;
    end if ;



   EXCEPTION when others THEN
        p_err_code := errnums.C_SYSTEM_ERROR;
        plog.error (pkgctx, SQLERRM|| dbms_utility.format_error_backtrace);
        ROLLBACK;
   END;



   PROCEDURE Bank_holdbalance(
      P_DDACCTNO IN VARCHAR2, -- tk ddmast
      P_MEMBERID IN VARCHAR2 default '', -- ctck dat lenh
      P_BRNAME  IN  VARCHAR2 default '', -- moi gioi dat lenh
      P_BRPHONE IN  VARCHAR2 default '', --- so dien thoai moi gioi dat lenh
      P_AMOUNT  IN  NUMBER,  --- so tien
      P_REQCODE IN  VARCHAR2, --- code nghiep vu cua giao dich , select tu alcode
      P_REQKEY  IN VARCHAR2, --request key --> key duy nhat de truy vet giao dich goc
      P_DESC  IN   VARCHAR2, -- dien giai
      P_TLID  IN   VARCHAR2, -- nguoi lap giao dich
      P_ERR_CODE  OUT VARCHAR2)
    IS
      -- Enter the procedure variables here. As shown below


     l_err_param varchar2(300);
     v_strCURRDATE varchar2(20);
     L_txnum         VARCHAR2(20);
     l_txmsg         tx.msg_rectype;
   BEGIN
    

       SELECT TO_DATE (varvalue, systemnums.c_date_format)
                   INTO v_strCURRDATE
                   FROM sysvar
                   WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    SELECT systemnums.C_BATCH_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO L_txnum
              FROM DUAL;
        l_txmsg.msgtype:='T';
        l_txmsg.local:='N';
        l_txmsg.tlid        := P_TLID;
        SELECT SYS_CONTEXT ('USERENV', 'HOST'),
                 SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
          INTO l_txmsg.wsname, l_txmsg.ipaddress
        FROM DUAL;
        SELECT BRID
          INTO l_txmsg.brid
        FROM TLPROFILES where TLID=P_TLID;
        if P_MEMBERID = '' then
            l_txmsg.batchname   := 'DAY';
        else
            l_txmsg.batchname   := 'BROKERCONFIRM';
        end if;
        l_txmsg.off_line    := 'N';
        l_txmsg.deltd       := txnums.c_deltd_txnormal;
        l_txmsg.txstatus    := txstatusnums.c_txcompleted;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        --l_txmsg.batchname   := 'DAY';
        l_txmsg.txnum    := L_txnum;
        l_txmsg.txtime    := to_char(SYSdate,'hh24:mi:ss');
        l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.BUSDATE:=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.tltxcd:='6690';


    FOR rec IN
    (
        select f.fldname,f.defname , f.datatype,
              case when fldname='03' then  afacctno
                   when fldname='04' then  P_DDACCTNO
                   when fldname='05' then  P_memberid
                   when fldname='06' then  P_brname
                   when fldname='07' then  P_brphone
                   when fldname='10' then  to_char(P_AMOUNT)
                   when fldname='11' then  '0'
                   when fldname='12' then  '0'
                   when fldname='13' then  '0'
                   when fldname='22' then  '0'
                   when fldname='20' then  ccycd
                   when fldname='21' then  to_char(nvl(VND,1)*P_AMOUNT)
                   when fldname='88' then  CUSTODYCD
                   when fldname='90' then  CUSTNAME
                   when fldname='93' then  REFCASAACCT
                   when fldname='94' then  P_REQCODE
                   when fldname='95' then  P_REQKEY
                   when fldname='30' then  p_desc
                   else '0'
              end value
              from fldmaster f,
              (select * from exchangerate where rtype = 'TTM' and itype = 'SHV') g,
              (
                    select afacctno,acctno,ccycd,cf.custodycd, fullname custname,REFCASAACCT
                    from ddmast dd, cfmast cf
                    where dd.custid=cf.custid and dd.acctno =P_DDACCTNO
              )i
             where objname ='6690' and  i.ccycd =g.currency(+)
    )
    LOOP
         
                    l_txmsg.txfields (rec.fldname).defname   := rec.defname;
                    l_txmsg.txfields (rec.fldname).TYPE      := rec.datatype;
                    l_txmsg.txfields (rec.fldname).value      :=  rec.value;
    END LOOP;
    IF  txpks_#6690.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <> systemnums.c_success THEN
        
        ROLLBACK;
    else
        p_err_code:=systemnums.c_success;
    end if ;



   EXCEPTION when others THEN
        p_err_code := errnums.C_SYSTEM_ERROR;
        plog.error (pkgctx, SQLERRM|| dbms_utility.format_error_backtrace);
        ROLLBACK;
   END;


   PROCEDURE Bank_holdbalance_no_rollback(
      P_DDACCTNO IN VARCHAR2, -- tk ddmast
      P_MEMBERID IN VARCHAR2 default '', -- ctck dat lenh
      P_BRNAME  IN  VARCHAR2 default '', -- moi gioi dat lenh
      P_BRPHONE IN  VARCHAR2 default '', --- so dien thoai moi gioi dat lenh
      P_AMOUNT  IN  NUMBER,  --- so tien
      P_REQCODE IN  VARCHAR2, --- code nghiep vu cua giao dich , select tu alcode
      P_REQKEY  IN VARCHAR2, --request key --> key duy nhat de truy vet giao dich goc
      P_DESC  IN   VARCHAR2, -- dien giai
      P_TLID  IN   VARCHAR2, -- nguoi lap giao dich
      P_ERR_CODE  OUT VARCHAR2)
    IS
      -- Enter the procedure variables here. As shown below


     l_err_param varchar2(300);
     v_strCURRDATE varchar2(20);
     L_txnum         VARCHAR2(20);
     l_txmsg         tx.msg_rectype;
   BEGIN
    

       SELECT TO_DATE (varvalue, systemnums.c_date_format)
                   INTO v_strCURRDATE
                   FROM sysvar
                   WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    SELECT systemnums.C_BATCH_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO L_txnum
              FROM DUAL;
        l_txmsg.msgtype:='T';
        l_txmsg.local:='N';
        l_txmsg.tlid        := P_TLID;
        SELECT SYS_CONTEXT ('USERENV', 'HOST'),
                 SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
          INTO l_txmsg.wsname, l_txmsg.ipaddress
        FROM DUAL;
        SELECT BRID
          INTO l_txmsg.brid
        FROM TLPROFILES where TLID=P_TLID;
        if P_MEMBERID = '' then
            l_txmsg.batchname   := 'DAY';
        else
            l_txmsg.batchname   := 'BROKERCONFIRM';
        end if;
        l_txmsg.off_line    := 'N';
        l_txmsg.deltd       := txnums.c_deltd_txnormal;
        l_txmsg.txstatus    := txstatusnums.c_txcompleted;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        --l_txmsg.batchname   := 'DAY';
        l_txmsg.txnum    := L_txnum;
        l_txmsg.txtime    := to_char(SYSdate,'hh24:mi:ss');
        l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.BUSDATE:=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.tltxcd:='6690';


    FOR rec IN
    (
        select f.fldname,f.defname , f.datatype,
              case when fldname='03' then  afacctno
                   when fldname='04' then  P_DDACCTNO
                   when fldname='05' then  P_memberid
                   when fldname='06' then  P_brname
                   when fldname='07' then  P_brphone
                   when fldname='10' then  to_char(P_AMOUNT)
                   when fldname='11' then  '0'
                   when fldname='12' then  '0'
                   when fldname='13' then  '0'
                   when fldname='22' then  '0'
                   when fldname='20' then  ccycd
                   when fldname='21' then  to_char(nvl(VND,1)*P_AMOUNT)
                   when fldname='88' then  CUSTODYCD
                   when fldname='90' then  CUSTNAME
                   when fldname='93' then  REFCASAACCT
                   when fldname='94' then  P_REQCODE
                   when fldname='95' then  P_REQKEY
                   when fldname='30' then  p_desc
                   else '0'
              end value
              from fldmaster f,
              (select * from exchangerate where rtype = 'TTM' and itype = 'SHV') g,
              (
                    select afacctno,acctno,ccycd,cf.custodycd, fullname custname,REFCASAACCT
                    from ddmast dd, cfmast cf
                    where dd.custid=cf.custid and dd.acctno =P_DDACCTNO
              )i
             where objname ='6690' and  i.ccycd =g.currency(+)
    )
    LOOP
         
                    l_txmsg.txfields (rec.fldname).defname   := rec.defname;
                    l_txmsg.txfields (rec.fldname).TYPE      := rec.datatype;
                    l_txmsg.txfields (rec.fldname).value      :=  rec.value;
    END LOOP;
    IF  txpks_#6690.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <> systemnums.c_success THEN
        plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
    else
        p_err_code:=systemnums.c_success;
    end if ;



   EXCEPTION when others THEN
        p_err_code := errnums.C_SYSTEM_ERROR;
        plog.error (pkgctx, SQLERRM|| dbms_utility.format_error_backtrace);
        ROLLBACK;
   END;

    PROCEDURE se_hold(
      P_SEACCTNO IN VARCHAR2, -- tk semast
      P_MEMBERID IN VARCHAR2 default '', -- ctck dat lenh
      P_BRNAME  IN  VARCHAR2 default '', -- moi gioi dat lenh
      P_BRPHONE IN  VARCHAR2 default '', --- so dien thoai moi gioi dat lenh
      P_QTTY  IN  NUMBER,  --- so luong
      P_DESC  IN   VARCHAR2, -- dien giai
      P_TLID  IN   VARCHAR2, -- nguoi lap giao dich
      P_ERR_CODE  OUT VARCHAR2)
    IS
      -- Enter the procedure variables here. As shown below


     l_err_param varchar2(300);
     v_strCURRDATE varchar2(20);
     L_txnum         VARCHAR2(20);
     l_txmsg         tx.msg_rectype;
   BEGIN

       SELECT TO_DATE (varvalue, systemnums.c_date_format)
                   INTO v_strCURRDATE
                   FROM sysvar
                   WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    SELECT systemnums.C_BATCH_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO L_txnum
              FROM DUAL;
        l_txmsg.msgtype:='T';
        l_txmsg.local:='N';
        l_txmsg.tlid        := P_TLID;
        SELECT SYS_CONTEXT ('USERENV', 'HOST'),
                 SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
          INTO l_txmsg.wsname, l_txmsg.ipaddress
        FROM DUAL;
        SELECT BRID
          INTO l_txmsg.brid
        FROM TLPROFILES where TLID=P_TLID;
        l_txmsg.off_line    := 'N';
        l_txmsg.deltd       := txnums.c_deltd_txnormal;
        l_txmsg.txstatus    := txstatusnums.c_txcompleted;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        l_txmsg.batchname   := 'BROKERCONFIRM';
        l_txmsg.txnum    := L_txnum;
        l_txmsg.txtime    := to_char(SYSdate,'hh24:mi:ss');
        l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.BUSDATE:=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.tltxcd:='2212';




    FOR rec IN
    (

                select f.fldname,f.defname , f.datatype,
                              case when fldname='02' then  se.afacctno
                                   when fldname='03' then  se.acctno
                                   when fldname='04' then  se.codeid
                                   when fldname='05' then P_MEMBERID
                                   when fldname='06' then  P_brname
                                   when fldname='07' then  P_brphone
                                   when fldname='10' then  to_char(P_QTTY)
                                   when fldname='11' then  '0'
                                   when fldname='12' then  '0'
                                   when fldname='13' then  '0'
                                   when fldname='14' then  sb.symbol
                                   when fldname='88' then  cf.CUSTODYCD
                                   when fldname='90' then  cf.fullname
                                   when fldname='30' then  p_desc
                                   else '0'
                              end value
                from semast se, fldmaster f, sbsecurities sb, cfmast cf
                where se.acctno = P_SEACCTNO and f.objname = '2212' and sb.codeid =se.codeid and cf.custid =se.custid

    )
    LOOP

                    l_txmsg.txfields (rec.fldname).defname   := rec.defname;
                    l_txmsg.txfields (rec.fldname).TYPE      := rec.datatype;
                    l_txmsg.txfields (rec.fldname).value      :=  rec.value;
             if rec.fldname= '04' then
                 l_txmsg.ccyusage:=  rec.value;
             end if;
              
    END LOOP;

    IF  txpks_#2212.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <> systemnums.c_success THEN
        
        ROLLBACK;
    else
        p_err_code:=systemnums.c_success;
    end if ;



   EXCEPTION when others THEN
        p_err_code := errnums.C_SYSTEM_ERROR;
        plog.error (pkgctx, SQLERRM|| dbms_utility.format_error_backtrace);
        ROLLBACK;
   END;
   -- Enter further code below as specified in the Package spec.
PROCEDURE se_unhold(
     P_SEACCTNO IN VARCHAR2, -- tk semast
      P_MEMBERID IN VARCHAR2 default '', -- ctck dat lenh
      P_BRNAME  IN  VARCHAR2 default '', -- moi gioi dat lenh
      P_BRPHONE IN  VARCHAR2 default '', --- so dien thoai moi gioi dat lenh
      P_QTTY  IN  NUMBER,  --- so luong
      P_DESC  IN   VARCHAR2, -- dien giai
      P_TLID  IN   VARCHAR2, -- nguoi lap giao dich
      P_ERR_CODE  OUT VARCHAR2)
    IS
      -- Enter the procedure variables here. As shown below

     l_err_param varchar2(300);
     v_strCURRDATE varchar2(20);
     L_txnum         VARCHAR2(20);
     l_txmsg         tx.msg_rectype;
   BEGIN

       SELECT TO_DATE (varvalue, systemnums.c_date_format)
                   INTO v_strCURRDATE
                   FROM sysvar
                   WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    SELECT systemnums.C_BATCH_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO L_txnum
              FROM DUAL;
        l_txmsg.msgtype:='T';
        l_txmsg.local:='N';
        l_txmsg.tlid        := P_TLID;
        SELECT SYS_CONTEXT ('USERENV', 'HOST'),
                 SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
          INTO l_txmsg.wsname, l_txmsg.ipaddress
        FROM DUAL;
        SELECT BRID
          INTO l_txmsg.brid
        FROM TLPROFILES where TLID=P_TLID;
        if P_MEMBERID = '' then
            l_txmsg.batchname   := 'DAY';
        else
            l_txmsg.batchname   := 'BROKERCONFIRM';
        end if;
        l_txmsg.off_line    := 'N';
        l_txmsg.deltd       := txnums.c_deltd_txnormal;
        l_txmsg.txstatus    := txstatusnums.c_txcompleted;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        --l_txmsg.batchname   := 'BROKERCONFIRM';
        l_txmsg.txnum    := L_txnum;
        l_txmsg.txtime    := to_char(SYSdate,'hh24:mi:ss');
        l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.BUSDATE:=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.tltxcd:='2213';


    
    FOR rec IN
    (

                select f.fldname,f.defname , f.datatype,
                              case when fldname='02' then  se.afacctno
                                   when fldname='03' then  se.acctno
                                   when fldname='04' then  se.codeid
                                   when fldname='05' then P_MEMBERID
                                   when fldname='06' then  P_brname
                                   when fldname='07' then  P_brphone
                                   when fldname='10' then  to_char(P_QTTY)
                                   when fldname='11' then  '0'
                                   when fldname='12' then  '0'
                                   when fldname='13' then  '0'
                                   when fldname='14' then  sb.symbol
                                   when fldname='88' then  cf.CUSTODYCD
                                   when fldname='90' then  cf.fullname
                                   when fldname='30' then  p_desc
                                   else '0'
                              end value
                from semast se, fldmaster f, sbsecurities sb, cfmast cf
                where se.acctno = P_SEACCTNO and f.objname = '2213' and sb.codeid =se.codeid and cf.custid =se.custid

    )
    LOOP
         
                    l_txmsg.txfields (rec.fldname).defname   := rec.defname;
                    l_txmsg.txfields (rec.fldname).TYPE      := rec.datatype;
                    l_txmsg.txfields (rec.fldname).value      :=  rec.value;
                    if rec.fldname= '04' then
                        l_txmsg.ccyusage:=  rec.value;
                    end if;
    END LOOP;

    IF  txpks_#2213.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <> systemnums.c_success THEN
        plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
        --ROLLBACK;
    else
        p_err_code:=systemnums.c_success;
    end if ;



   EXCEPTION when others THEN
        p_err_code := errnums.C_SYSTEM_ERROR;
        plog.error (pkgctx, SQLERRM|| dbms_utility.format_error_backtrace);
        ROLLBACK;
   END;

--trung.luu: hold(6603)/unhold(6604) cho tk tu doanh
    PROCEDURE TD_Hold(
      P_CUSTODYCD IN VARCHAR2,
      P_MEMBERID IN VARCHAR2 default '', -- ctck dat lenh
      P_BRNAME  IN  VARCHAR2 default '', -- moi gioi dat lenh
      P_BRPHONE IN  VARCHAR2 default '',
      P_QTTY  IN  NUMBER,  --- so luong
      P_TLID  IN   VARCHAR2, -- nguoi lap giao dich
      P_DESC  IN   VARCHAR2,
      P_ERR_CODE  OUT VARCHAR2
        )
    IS
      -- Enter the procedure variables here. As shown below


     l_err_param varchar2(300);
     v_strCURRDATE varchar2(20);
     L_txnum         VARCHAR2(20);
     l_txmsg         tx.msg_rectype;
   BEGIN

       SELECT TO_DATE (varvalue, systemnums.c_date_format)
                   INTO v_strCURRDATE
                   FROM sysvar
                   WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    SELECT systemnums.C_BATCH_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO L_txnum
              FROM DUAL;
        l_txmsg.msgtype:='T';
        l_txmsg.local:='N';
        l_txmsg.tlid        := P_TLID;
        SELECT SYS_CONTEXT ('USERENV', 'HOST'),
                 SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
          INTO l_txmsg.wsname, l_txmsg.ipaddress
        FROM DUAL;
        SELECT BRID
          INTO l_txmsg.brid
        FROM TLPROFILES where TLID=P_TLID;
        l_txmsg.off_line    := 'N';
        l_txmsg.deltd       := txnums.c_deltd_txnormal;
        l_txmsg.txstatus    := txstatusnums.c_txcompleted;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        l_txmsg.batchname   := 'DAY';
        l_txmsg.txnum    := L_txnum;
        l_txmsg.txtime    := to_char(SYSdate,'hh24:mi:ss');
        l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.BUSDATE:=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.tltxcd:='6603';




    FOR rec IN
    (

                select f.fldname,f.defname , f.datatype,
                              case when fldname='88' then  P_CUSTODYCD
                                   when fldname='03' then  dd.acctno
                                   when fldname='05' then  P_memberid
                                   when fldname='06' then  P_brname
                                   when fldname='07' then  P_brphone
                                   when fldname='90' then  cf.fullname
                                   when fldname='89' then  cf.cifid
                                   when fldname='91' then  cf.address
                                   when fldname='92' then  cf.idcode
                                   when fldname='93' then  dd.refcasaacct
                                   when fldname='10' then  to_char(P_QTTY)
                                   when fldname='30' then  P_DESC
                                   else '0'
                              end value
                from fldmaster f, cfmast cf,ddmast dd
                where cf.custodycd = P_CUSTODYCD and f.objname = '6603' and cf.custodycd = dd.custodycd and dd.status <> 'C' and dd.isdefault = 'Y'
    )
    LOOP
                    l_txmsg.txfields (rec.fldname).defname   := rec.defname;
                    l_txmsg.txfields (rec.fldname).TYPE      := rec.datatype;
                    l_txmsg.txfields (rec.fldname).value      :=  rec.value;
              
    END LOOP;

    IF  txpks_#6603.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <> systemnums.c_success THEN
        
        ROLLBACK;
    else
        p_err_code:=systemnums.c_success;
    end if ;



   EXCEPTION when others THEN
        p_err_code := errnums.C_SYSTEM_ERROR;
        plog.error (pkgctx, SQLERRM|| dbms_utility.format_error_backtrace);
        ROLLBACK;
   END;

   PROCEDURE TD_Unhold(
      P_CUSTODYCD IN VARCHAR2,
      P_QTTY  IN  NUMBER,  --- so luong
      P_TLID  IN   VARCHAR2, -- nguoi lap giao dich
      P_DESC  IN   VARCHAR2,
      P_ERR_CODE  OUT VARCHAR2
        )
    IS
      -- Enter the procedure variables here. As shown below


     l_err_param varchar2(300);
     v_strCURRDATE varchar2(20);
     L_txnum         VARCHAR2(20);
     l_txmsg         tx.msg_rectype;
   BEGIN

       SELECT TO_DATE (varvalue, systemnums.c_date_format)
                   INTO v_strCURRDATE
                   FROM sysvar
                   WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    SELECT systemnums.C_BATCH_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO L_txnum
              FROM DUAL;
        l_txmsg.msgtype:='T';
        l_txmsg.local:='N';
        l_txmsg.tlid        := P_TLID;
        SELECT SYS_CONTEXT ('USERENV', 'HOST'),
                 SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
          INTO l_txmsg.wsname, l_txmsg.ipaddress
        FROM DUAL;
        SELECT BRID
          INTO l_txmsg.brid
        FROM TLPROFILES where TLID=P_TLID;
        l_txmsg.off_line    := 'N';
        l_txmsg.deltd       := txnums.c_deltd_txnormal;
        l_txmsg.txstatus    := txstatusnums.c_txcompleted;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        l_txmsg.batchname   := 'DAY';
        l_txmsg.txnum    := L_txnum;
        l_txmsg.txtime    := to_char(SYSdate,'hh24:mi:ss');
        l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.BUSDATE:=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.tltxcd:='6604';




    FOR rec IN
    (

                select f.fldname,f.defname , f.datatype,
                              case when fldname='88' then  P_CUSTODYCD
                                   when fldname='03' then  dd.acctno
                                   when fldname='90' then  cf.fullname
                                   when fldname='89' then  cf.cifid
                                   when fldname='91' then  cf.address
                                   when fldname='92' then  cf.idcode
                                   when fldname='93' then  dd.refcasaacct
                                   when fldname='10' then  to_char(P_QTTY)
                                   when fldname='30' then P_DESC
                                   else '0'
                              end value
                from fldmaster f, cfmast cf,ddmast dd
                where cf.custodycd = P_CUSTODYCD and f.objname = '6604' and cf.custodycd = dd.custodycd and dd.status <> 'C' and dd.isdefault = 'Y'
    )
    LOOP
                    l_txmsg.txfields (rec.fldname).defname   := rec.defname;
                    l_txmsg.txfields (rec.fldname).TYPE      := rec.datatype;
                    l_txmsg.txfields (rec.fldname).value      :=  rec.value;
              
    END LOOP;

    IF  txpks_#6604.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <> systemnums.c_success THEN
        
        ROLLBACK;
    else
        p_err_code:=systemnums.c_success;
    end if ;



   EXCEPTION when others THEN
        p_err_code := errnums.C_SYSTEM_ERROR;
        plog.error (pkgctx, SQLERRM|| dbms_utility.format_error_backtrace);
        ROLLBACK;
   END;

   PROCEDURE Checkblacklist(
      P_NAME IN VARCHAR2,
      P_REQTXNUM  IN  VARCHAR2,  --- txnum
      P_REQTXDATE  IN  VARCHAR2,  --- txdate
      P_TLID  IN   VARCHAR2, -- nguoi lap giao dich
      P_DESC  IN   VARCHAR2,
      P_ERR_CODE  OUT VARCHAR2
        )
    IS
      -- Enter the procedure variables here. As shown below


     l_err_param varchar2(300);

   BEGIN
        
        P_ERR_CODE:=0;
        INSERT INTO crbtxreq (reqid, objtype, objname, trfcode, reqcode, objkey,
       txdate, bankcode, bankacct, afacctno, txamt, notes,
       status, reftxnum, reftxdate, affectdate,
       createdate, via, rbankaccount,unhold,currency, reqtxnum, dorc,
       feeamt, taxamt, feecode, feetype,rbankaccname,busdate)
       VALUES  (seq_crbtxreq.NEXTVAL,'T','BLACKLIST','BLACKLIST','BLACKLIST',P_REQTXNUM,
       to_date(P_REQTXDATE,'DD/MM/RRRR'),'SHV','',null,'','',
       'P',P_REQTXNUM,to_date(P_REQTXDATE,'DD/MM/RRRR'),to_date(P_REQTXDATE,'DD/MM/RRRR'),
        sysdate,'CBP','','N','',P_REQTXNUM,'C',0,0,null,null,P_NAME,to_date(P_REQTXDATE,'DD/MM/RRRR'));



   EXCEPTION when others THEN
        p_err_code := errnums.C_SYSTEM_ERROR;
        plog.error (pkgctx, SQLERRM|| dbms_utility.format_error_backtrace);
        ROLLBACK;
   END;

--trung.luu: tang/giam tien(6607) dau ngay cho tk tu doanh
    PROCEDURE C_D_Balance(
      P_CUSTODYCD IN VARCHAR2,
      P_DDACCTNO  IN VARCHAR2,
      P_WDRTYPE   IN VARCHAR2,
      P_AMOUNT  IN  NUMBER,
      P_TLID  IN   VARCHAR2,
      P_ERR_CODE  OUT VARCHAR2
        )
    IS
      -- Enter the procedure variables here. As shown below


     l_err_param varchar2(300);
     v_strCURRDATE varchar2(20);
     L_txnum         VARCHAR2(20);
     l_txmsg         tx.msg_rectype;
     v_desc varchar2(1000);
     WDRTYPE varchar2(10);
   BEGIN

       SELECT TO_DATE (varvalue, systemnums.c_date_format)
                   INTO v_strCURRDATE
                   FROM sysvar
                   WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    SELECT systemnums.C_BATCH_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO L_txnum
              FROM DUAL;
        l_txmsg.msgtype:='T';
        l_txmsg.local:='N';
        l_txmsg.tlid        := P_TLID;
        SELECT SYS_CONTEXT ('USERENV', 'HOST'),
                 SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
          INTO l_txmsg.wsname, l_txmsg.ipaddress
        FROM DUAL;
        SELECT BRID
          INTO l_txmsg.brid
        FROM TLPROFILES where TLID=P_TLID;
        l_txmsg.off_line    := 'N';
        l_txmsg.deltd       := txnums.c_deltd_txnormal;
        l_txmsg.txstatus    := txstatusnums.c_txcompleted;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        l_txmsg.batchname   := 'DAY';
        l_txmsg.txnum    := L_txnum;
        l_txmsg.txtime    := to_char(SYSdate,'hh24:mi:ss');
        l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.BUSDATE:=to_date(v_strCURRDATE,systemnums.c_date_format);
        l_txmsg.tltxcd:='6607';

--lay dien giai gd
select en_txdesc into v_desc from tltx where tltxcd = '6607';



    FOR rec IN
    (

                select f.fldname,f.defname , f.datatype,
                              case when fldname='88' then  P_CUSTODYCD
                                   when fldname='05' then  P_DDACCTNO
                                   when fldname='09' then  P_WDRTYPE
                                   when fldname='10' then  to_char(P_AMOUNT)
                                   when fldname='30' then  v_desc
                                   else '0'
                              end value
                from fldmaster f
                where f.objname = '6607'
    )
    LOOP
                    l_txmsg.txfields (rec.fldname).defname   := rec.defname;
                    l_txmsg.txfields (rec.fldname).TYPE      := rec.datatype;
                    l_txmsg.txfields (rec.fldname).value      :=  rec.value;
              
    END LOOP;

    IF  txpks_#6607.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <> systemnums.c_success THEN
        
        ROLLBACK;
    else
        p_err_code:=systemnums.c_success;
    end if ;



   EXCEPTION when others THEN
        p_err_code := errnums.C_SYSTEM_ERROR;
        plog.error (pkgctx, SQLERRM|| dbms_utility.format_error_backtrace);
        ROLLBACK;
   END;

END;
/
