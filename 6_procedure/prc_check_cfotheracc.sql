SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE prc_check_cfotheracc(p_type in varchar2, p_cfcustid in varchar2, p_ciaccount in varchar2,
       p_custid in varchar2, p_bankacct in varchar2, p_err_param out varchar2, p_warning_message out varchar2)
IS
    v_recustid varchar2(20);
    v_idcode varchar2(100);
    l_count number;
--
-- To modify this template, edit file PKGBODY.TXT in TEMPLATE
-- directory of SQL Navigator
--
-- Purpose: Briefly explain the functionality of the package body
--
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- ---------   ------  ------------------------------------------
-- ANTB        13/02/2015   HAM KIEM TRA THONG TIN CHUYEN KHOAN
   -- Enter procedure, function bodies as shown below
BEGIN
    IF trim(p_type) = 0 THEN
    --Neu p_type = 0: chuyen khoan noi bo chan khong duoc chuyen cho moi gioi
        --check tieu khoan nhan co phai la tieu khoan cua moi gioi khong
        select count(*) into l_count
        from cfmast cf, afmast af, recflnk re
        where cf.custid = af.custid
              and cf.custid = re.custid
              and af.acctno = p_ciaccount;
        if l_count <> 0 then
            p_err_param := '-100149';
            p_warning_message := '';
            return;
        end if;
    /*ELSE
        --Neu p_type = 1: chuyen khoan ra ngoai thi kiem tra tai khoan NH lien ket co trong he thong phai thuoc tai khoan chuyen khong
        --Neu khong co thi khong check
        select count(*) into l_count from vw_afmast_custodycd where bankacctno = p_bankacct;
        if l_count > 0 then
            l_count := 0;
            select count(*) into l_count from vw_afmast_custodycd where bankacctno = p_bankacct and custid = p_cfcustid;
            if l_count = 0 then
                p_err_param := '-100152';
                p_warning_message := '';
                return;
            end if;
        end if;*/
    END IF;

    p_err_param := '0';
    p_warning_message:= '';
EXCEPTION WHEN OTHERS THEN
INSERT INTO log_err
        (id,date_log, POSITION, text
        )
 VALUES ( seq_log_err.NEXTVAL,SYSDATE, ' PRC_CHECK_CFOTHERACC ', dbms_utility.format_error_backtrace
        );

COMMIT;
END;
 
 
/
