SET DEFINE OFF;
CREATE OR REPLACE PACKAGE gwpks_auto
  IS
--
-- To modify this template, edit file PKGSPEC.TXT in TEMPLATE
-- directory of SQL Navigator
--
-- Purpose: Briefly explain the functionality of the package
--
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- ---------   ------  ------------------------------------------
   -- Enter package declarations as shown below


     PROCEDURE prCARightOffRegister;

END; -- Package spec
/


CREATE OR REPLACE PACKAGE BODY gwpks_auto
IS
--
-- To modify this template, edit file PKGBODY.TXT in TEMPLATE
-- directory of SQL Navigator
--
-- Purpose: Briefly explain the functionality of the package body
--
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- ---------   ------  ------------------------------------------
   -- Enter procedure, function bodies as shown below

   PROCEDURE prCARightOffRegister
   IS
        v_rqsautoid varchar2(30);
        v_count integer;
        v_errcode varchar2(30);
        v_errmsg varchar(250);
        v_custodycd varchar(20);
        v_subaccount varchar(20);
        v_caid varchar(20);
        v_txdate varchar(20);
        v_txnum varchar(10);
        v_rqssrc varchar(3);
        v_rqstyp varchar(3);
        v_status varchar(3);
        v_newafacctno varchar2(30);
        v_timeallow NUMBER;
        v_remark varchar2(500);
        v_symbol varchar(30);
   BEGIN
        FOR rec IN
        (
            SELECT mst.*, rqs_ISSUBACCT.cvalue ISSUBACCT, rqs_REFACCTNO.cvalue REFACCTNO, rqs_CAMASTID.cvalue REFID,
                    rqs_QTTY.nvalue QTTY
            FROM borqslog mst, borqslogdtl  rqs_ISSUBACCT, borqslogdtl  rqs_REFACCTNO,
                                borqslogdtl  rqs_CAMASTID, borqslogdtl rqs_QTTY
            WHERE rqstyp = 'CAR' AND status = 'P' AND rqssrc = 'ONL'
            AND rqs_ISSUBACCT.autoid = mst.autoid AND rqs_ISSUBACCT.varname = 'ISSUBACCT'
            AND rqs_REFACCTNO.autoid = mst.autoid AND rqs_REFACCTNO.varname = 'REFACCTNO'
            AND rqs_CAMASTID.autoid = mst.autoid AND rqs_CAMASTID.varname = 'CAMASTID'
            AND rqs_QTTY.autoid = mst.autoid AND rqs_QTTY.varname = 'QTTY'
            AND ROWNUM <= 10
            ORDER BY mst.autoid
        )
        LOOP
            v_rqsautoid:= rec.AUTOID;
            --Kiem tra thoi gian cho phep thuc hien chuyen tien.
            SELECT CASE WHEN max(case WHEN grname = 'SYSTEM' AND varname = 'HOSTATUS' THEN varvalue END) = 1
                AND to_date(to_char(SYSDATE,'hh24:mi:ss'),'hh24:mi:ss') >= to_date(max(case WHEN grname = 'STRADE' AND varname = 'CA_FRTIME' THEN varvalue END),'hh24:mi:ss')
                AND to_date(to_char(SYSDATE,'hh24:mi:ss'),'hh24:mi:ss') <= to_date(max(case WHEN grname = 'STRADE' AND varname = 'CA_TOTIME' THEN varvalue END),'hh24:mi:ss')
                THEN 1 ELSE 0 END
            INTO v_timeallow
            FROM sysvar;
            if v_timeallow = 0 then
                v_errcode:=-6;  --nam ngoai thoi gian cho phep thuc hien chuyen tien qua strade.
                v_errmsg:='OUT OF operation time';
                EXIT;
            end if;

            BEGIN
            --nhan yeu cau xu ly
            v_rqssrc:='ONL';
            v_rqstyp:='CAR';
            v_status:='P';

            BEGIN
                -- Neu truyen vao custodycd, thuc hien chuyen lai thanh afacctno voi tradeonline = Y
                IF rec.ISSUBACCT='N' THEN
                    BEGIN
                        SELECT AF.ACCTNO INTO v_newafacctno FROM AFMAST AF, CFMAST CF WHERE CF.CUSTID=AF.CUSTID AND AF.STATUS <> 'C' AND CF.TRADEONLINE='Y' AND CF.CUSTODYCD=rec.REFACCTNO;
                    EXCEPTION
                    WHEN OTHERS THEN
                        v_newafacctno:= rec.REFACCTNO;
                    END;
                ELSE
                    v_newafacctno:= rec.REFACCTNO;
                END IF;

                SELECT AFMAST.ACCTNO, CFMAST.CUSTODYCD INTO v_subaccount, v_custodycd FROM AFMAST, CFMAST WHERE AFMAST.CUSTID=CFMAST.CUSTID AND AFMAST.STATUS <> 'C' AND AFMAST.ACCTNO=v_newafacctno;
            EXCEPTION
                WHEN no_data_found THEN
                v_errcode:=-3;  --khong thay subaccount
                v_errmsg:='Cannot FOUND subaccount!';
                RAISE errnums.E_BIZ_RULE_INVALID;
            END;

            -- Format camastid
            v_caid:=replace(rec.REFID,'.','');
            -- Kiem tra trang thai quyen. Co cho phep thuc hien tiep dang ky quyen mua hay khong.
            BEGIN
                SELECT camastid INTO v_caid FROM camast WHERE status IN ('A','M') AND camastid = v_caid and deltd <> 'Y';
            EXCEPTION
                WHEN no_data_found THEN
                v_errcode:=-4;  --Trang thai ma quyen ko hop le: chi dang ki quyen mua khi trang thai camast la A, M
                v_errmsg:='CA status IS invalid!';
                RAISE errnums.E_BIZ_RULE_INVALID;
            END;
                -- Lay thong tin ma chung khoan de lam dien giai.
            BEGIN
                select s.symbol into v_symbol from camast c, sbsecurities s where s.codeid = c.codeid and c.status IN ('A','M') AND c.camastid = v_caid and c.deltd <> 'Y';
            EXCEPTION
                WHEN others THEN
                v_errcode:=-6;  --ma chung khoan khong ton tai.
                v_errmsg:='Symbol does NOT exists!';
                RAISE errnums.E_BIZ_RULE_INVALID;
            END;
                -- Kiem tra trang thai quyen. Co cho phep thuc hien tiep dang ky quyen mua hay khong.
            BEGIN
                SELECT camastid INTO v_caid FROM caschd WHERE status IN ('A','M') AND camastid = v_caid AND afacctno = v_subaccount and deltd <> 'Y';
            EXCEPTION
                WHEN no_data_found THEN
                v_errcode:=-4;  --Trang thai ma quyen ko hop le: chi dang ki quyen mua khi trang thai camast la A, M
                v_errmsg:='CA status IS invalid!';
                RAISE errnums.E_BIZ_RULE_INVALID;
            END;

            BEGIN
                -- Kiem tra: So luong dang ki mua co cho phep hay khong? PBALANCE > 0 AND PQTTY > 0
                SELECT camastid INTO v_caid
                FROM caschd
                WHERE status IN ('A','M') AND camastid = v_caid AND afacctno = v_subaccount AND PBALANCE > 0 AND PQTTY > 0 AND PQTTY >= rec.QTTY and deltd <> 'Y';
            EXCEPTION
                WHEN no_data_found THEN
                v_errcode:=-5;  --Khoi luong chung khoan dk quyen mua khong hop le.
                v_errmsg:='Over availble register qtty!';
                RAISE errnums.E_BIZ_RULE_INVALID;
            END;

                -- desc dang ky quyen mua:
                v_remark:='[STRADE]Dang ky quyen mua cp ' || v_symbol;
                --GOI HAM DANG KY QUYEN MUA
                txpks_auto.pr_RightoffRegiter(v_caid, v_subaccount, rec.QTTY, v_remark, v_errcode, v_txdate, v_txnum);

                --XU LY LOI
                IF v_errcode=0 THEN
                    v_status:='A';
                ELSE
                    begin
                        SELECT ERRDESC INTO v_errmsg FROM DEFERROR WHERE ERRNUM=v_errcode;
                    exception
                    when no_data_found then
                        v_errcode:= -10;
                        v_errmsg:='UNDEFINED ERROR!';
                    end;
                    v_status:='E';
                END IF;

                UPDATE BORQSLOG
                SET ERRNUM = v_errcode, ERRMSG = v_errmsg, STATUS = v_status, txdate = v_txdate, txnum = v_txnum
                WHERE autoid = v_rqsautoid;
            END;
        END LOOP;
        COMMIT;
   EXCEPTION
      WHEN errnums.E_BIZ_RULE_INVALID THEN
          UPDATE BORQSLOG
          SET ERRNUM = v_errcode, ERRMSG = v_errmsg, STATUS = 'E'
          WHERE autoid = v_rqsautoid;
      WHEN OTHERS THEN
        v_errmsg:= SQLERRM;
          UPDATE BORQSLOG
          SET ERRNUM = '-1', ERRMSG = 'Error in process: ' || v_errmsg, STATUS = 'E'
          WHERE autoid = v_rqsautoid;
   END;

   -- Enter further code below as specified in the Package spec.
END;
/
