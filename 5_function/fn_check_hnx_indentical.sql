SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_check_hnx_indentical
  (
    p_afacctno in varchar2,
    p_exectype in varchar2,
    p_symbol in varchar2,
    p_quantity in number,
    p_quoteprice in number,
    p_pricetype in varchar2,
    p_timetype in varchar2,
    p_quoteqtty in number,
    p_splopt  in  varchar2,
    p_splval  in  number
  )
  RETURN number IS
--
-- To modify this template, edit file FUNC.TXT in TEMPLATE
-- directory of SQL Navigator
--
-- Purpose: Check lenh vao co vuot qua so luong lenh trung cho phep cua so HNX hay khong
--
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- SONLT    28/12/2015 Create
-- ---------   ------  -------------------------------------------
    v_afacctno      varchar2(20);
    v_custodycd     varchar2(20);
    v_exectype      varchar2(20);
    v_symbol        varchar2(20);
    v_codeid        varchar2(20);
    v_quantity      number;
    v_quoteprice    number;
    v_pricetype     varchar2(20);
    v_timetype      varchar2(20);
    v_quoteqtty     number(20);
    v_splopt        varchar2(20);
    v_splval        number;
    v_ordernum      number;
    return_value    number;
    v_count         number;
    v_modqtty       number;
    v_txdate        date;
    v_tradeplace    varchar2(20);
    v_hnxidenical   number;
    v_hnxtradeplace   varchar2(20);
    v_HNX_MAX_QUANTITY  number;
    v_splvalexec    number;
    v_symbol_tmp    varchar2(20);
   -- Declare program variables as shown above
BEGIN
    return_value := 0; --0: OK -1: Trung lenh
    v_afacctno   := p_afacctno;
    v_exectype   := substr(p_exectype,2,1);
    v_symbol     := p_symbol;
    v_symbol_tmp     := p_symbol;
    v_quantity   := p_quantity;
    v_pricetype  := p_pricetype;
    v_timetype   := p_timetype;
    v_quoteqtty  := p_quoteqtty;
    v_splopt     := p_splopt;
    v_splval     := p_splval;
    v_txdate     := GETCURRDATE;

    --TruongLD Add, 18/032016, Xu ly truong hop truyen ma CK bi sai
    BEGIN
        SELECT SYMBOL INTO v_symbol FROM  SBSECURITIES WHERE SYMBOL = v_symbol_tmp;
    EXCEPTION
        WHEN OTHERS THEN
            SELECT SYMBOL INTO v_symbol FROM  SBSECURITIES WHERE CODEID = v_symbol_tmp;
    END;
    --End TruongLD

    BEGIN

        Select to_number(varvalue) into v_HNX_MAX_QUANTITY from sysvar where varname ='HNX_MAX_QUANTITY' and grname='BROKERDESK';
        SELECT CODEID,TRADEPLACE INTO v_codeid, v_tradeplace FROM SBSECURITIES SB
        WHERE SYMBOL = v_symbol;

        SELECT p_quoteprice*tradeunit INTO v_quoteprice FROM SECURITIES_INFO SB
        WHERE SYMBOL = v_symbol;

    EXCEPTION
        WHEN OTHERS THEN
            plog.error(sqlerrm || dbms_utility.format_error_backtrace);
            RETURN -1;
    END;
    BEGIN
        SELECT CF.CUSTODYCD INTO v_custodycd FROM AFMAST AF, CFMAST CF
        WHERE AF.CUSTID = CF.CUSTID
            AND AF.ACCTNO = v_afacctno;

        SELECT TO_NUMBER(VARVALUE) INTO v_hnxidenical
        FROM SYSVAR WHERE GRNAME = 'OD' AND VARNAME = 'HNXIDENICAL';

        SELECT VARVALUE INTO v_hnxtradeplace
        FROM SYSVAR WHERE GRNAME = 'OD' AND VARNAME = 'IDENICALPLACE';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            plog.error(sqlerrm || dbms_utility.format_error_backtrace);
            RETURN -1;
    END;
    IF INSTR(v_hnxtradeplace,v_tradeplace) <> 0 THEN
        IF v_splopt = 'N' and v_quantity <=  v_HNX_MAX_QUANTITY THEN --Check doi voi lenh khong che
            SELECT COUNT(1) INTO v_count
            FROM OOD ID
            WHERE
                --Nhom tieu chi check trung lenh
                ID.CUSTODYCD = v_custodycd
                AND ID.BORS = v_exectype
                AND ID.CODEID = v_codeid
                AND ID.PRICE = V_QUOTEPRICE
                AND ID.QTTY = V_QUANTITY
                --Nhom cac tieu chi bo xung
                AND ID.OODSTATUS IN ('N','B','S');

            plog.error('fn_check_hnx_indentical 1.1: v_symbol:'|| v_symbol||', price:'||V_QUOTEPRICE
                                                         ||', qtty:'||V_QUANTITY
                                                         ||', hnxidenical:'||v_hnxidenical
                                                         ||', count:'|| v_count);
            IF v_count >= v_hnxidenical THEN
                return_value := -1;
            END IF;
        ELSE --Case che lenh

            If v_splopt = 'N' then
                v_splvalexec := v_HNX_MAX_QUANTITY;
            Else
                v_splvalexec := v_splval;
            End If;

            --Xu ly doi voi cac lenh che tron lo
            select FLOOR(v_quantity / v_splvalexec) into v_ordernum from dual;
            SELECT COUNT(1) INTO v_count
            FROM OOD ID
            WHERE
                --Nhom tieu chi check trung lenh
                ID.CUSTODYCD = v_custodycd
                AND ID.BORS = v_exectype
                AND ID.CODEID = v_codeid
                AND ID.PRICE = V_QUOTEPRICE
                AND ID.QTTY = v_splvalexec
                --Nhom cac tieu chi bo xung
                AND ID.OODSTATUS IN ('N','B','S');
            --plog.error('fn_check_hnx_indentical 2: v_count:'|| v_count||', v_ordernum:'||v_ordernum||', v_hnxidenical:'||v_hnxidenical);

            IF v_count+v_ordernum-1 >= v_hnxidenical THEN --Doi voi lenh che thi cong them so luong lenh che vao
                return_value := -1;
            END IF;

            --Xu ly doi voi phan le con lai cua lenh
            select mod(v_quantity,v_splvalexec) into v_modqtty from dual;
            SELECT COUNT(1) INTO v_count
            FROM OOD ID
            WHERE
                --Nhom tieu chi check trung lenh
                ID.CUSTODYCD = v_custodycd
                AND ID.BORS = v_exectype
                AND ID.CODEID = v_codeid
                AND ID.PRICE = V_QUOTEPRICE
                AND ID.QTTY = V_MODQTTY
                --Nhom cac tieu chi bo xung
                AND ID.OODSTATUS IN ('N','B','S');


            --plog.error('fn_check_hnx_indentical 3: v_count:'|| v_count||', v_hnxidenical:'||v_hnxidenical||', V_MODQTTY:'||v_modqtty);
            IF v_count >= v_hnxidenical THEN
                return_value := -1;
            END IF;
        END IF;
    END IF;

    RETURN return_value ;
EXCEPTION
   WHEN OTHERS THEN
       plog.error(sqlerrm || dbms_utility.format_error_backtrace);
       RETURN -1;
END;
/
