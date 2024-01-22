SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_get_feebookingname(pv_feecode IN VARCHAR2,pv_custodycd IN VARCHAR2,pv_txdate IN VARCHAR2)
    RETURN varchar2 IS
    v_desc varchar2(2000);
    v_feecode varchar2(200);
    v_feetypes varchar2(200);
    v_subtypes varchar2(200);
    v_txdate  date;
BEGIN
    v_feecode:=trim(pv_feecode);
    v_txdate:=to_date(pv_txdate,'DD/MM/RRRR');
    SELECT mas.refcode,mas.subtype into v_feetypes,v_subtypes
    FROM   vw_feetran_all f,feemaster mas
    where f.status ='S' and  f.type='F' and mas.status='Y'
    and f.subtype =mas.subtype
    and f.feetypes =mas.refcode
    and f.feecode=pv_feecode
    and f.custodycd=pv_custodycd
    and f.txdate=v_txdate;

    SELECT en_display into v_desc FROM vw_feedetails_all
    WHERE filtercd = v_subtypes  and id=v_feetypes;

RETURN v_desc;
EXCEPTION
   WHEN OTHERS THEN
    RETURN '';
END;
/
