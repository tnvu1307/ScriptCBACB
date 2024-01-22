SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE sp_process_request_citad_aither (p_autoid number)
IS
    v_trans_type varchar2(250);
    v_citad varchar2(250);
    v_bankcode  varchar2(250);
    v_branchname    varchar2(250);
    v_bankname  varchar2(250);
    v_regionname    varchar2(250);
    v_cfm_bankname  varchar2(250);
    v_bnk_bankname  varchar2(250);
    v_in_direct varchar2(250);
    v_TRANS_DATE date;
    v_reqid varchar2(250);
    v_count number;
BEGIN
    select  trans_type,citadcode,bankcode,branchname,bankname,region_name,cfm_bank_name,abbreviated_name,in_direct,reqid
        into v_trans_type ,v_citad,v_bankcode,v_branchname,v_bankname,v_regionname,v_cfm_bankname,v_bnk_bankname,v_in_direct,v_reqid
            from request_citad_aither where autoid  = p_autoid;

    if v_trans_type = '01' then --01:new /02:Update/04:Delete
        select count(*) into v_count from crbbanklist where citad = v_citad;
        if v_count > 0  then
            update crbbankrequest
                set errordesc = 'Citad is duplicated!',
                cfstatus = 'E'
                where autoid = v_reqid;
        else
            insert into crbbanklist
            (bankcode, bankname, regional, createdt, branchname,citad, status, pstatus, bankbiccode, bankaccount)
            values
            ('',v_bankname,v_regionname,SYSTIMESTAMP,v_branchname,v_citad,'A','','','');

            --TRUNG.LUU: SHBVNEX-1924 BRANCH NAME KEY WORD 1
            INSERT INTO CRBBANKMAPKWORD
            (autoid, citad, keyword, createdate, lastchange,prioritize)
            VALUES
            (SEQ_CRBBANKMAPKWORD.NEXTVAL,v_citad,v_branchname,SYSDATE,SYSTIMESTAMP,'1');

            --TRUNG.LUU: SHBVNEX-1924 BRANCH NAME KEY WORD 2
            INSERT INTO CRBBANKMAPKWORD
            (autoid, citad, keyword, createdate, lastchange,prioritize)
            VALUES
            (SEQ_CRBBANKMAPKWORD.NEXTVAL,v_citad,v_bankname,SYSDATE,SYSTIMESTAMP,'2');
            update request_citad_aither set status = 'A' where citadcode = v_citad;
        end if;
    elsif v_trans_type = '02' then
        select count(*) into v_count from crbbanklist where citad = v_citad;
        if v_count = 0  then
            insert into crbbanklist
            (bankcode, bankname, regional, createdt, branchname,citad, status, pstatus, bankbiccode, bankaccount)
            values
            ('',v_bankname,v_regionname,SYSTIMESTAMP,v_branchname,v_citad,'A','','','');

            --TRUNG.LUU: SHBVNEX-1924 BRANCH NAME KEY WORD 1
            INSERT INTO CRBBANKMAPKWORD
            (autoid, citad, keyword, createdate, lastchange,prioritize)
            VALUES
            (SEQ_CRBBANKMAPKWORD.NEXTVAL,v_citad,v_branchname,SYSDATE,SYSTIMESTAMP,'1');

            --TRUNG.LUU: SHBVNEX-1924 BRANCH NAME KEY WORD 2
            INSERT INTO CRBBANKMAPKWORD
            (autoid, citad, keyword, createdate, lastchange,prioritize)
            VALUES
            (SEQ_CRBBANKMAPKWORD.NEXTVAL,v_citad,v_bankname,SYSDATE,SYSTIMESTAMP,'2');
        else
            insert into crbbanklist_hist select *from crbbanklist where citad = v_citad;
            update crbbanklist
                set bankname = v_bankname,
                    regional = v_regionname,
                    createdt = SYSTIMESTAMP,
                    branchname = v_branchname,
                    citad = v_citad
                where citad = v_citad;

            UPDATE CRBBANKMAPKWORD
                SET keyword =v_branchname
                WHERE   CITAD = V_CITAD
                    AND prioritize = '1'; --TRUNG.LUU: BRANCH NAME LA KEYWORD 1

            UPDATE CRBBANKMAPKWORD
                SET keyword =v_bankname
                WHERE   CITAD = V_CITAD
                AND prioritize = '2'; --TRUNG.LUU: BANK NAME LA KEYWORD 2
        end if;
        update request_citad_aither set status = 'A' where citadcode = v_citad;
    elsif v_trans_type = '04' then
        insert into crbbanklist_hist select *from crbbanklist where citad = v_citad;
        delete crbbanklist where citad = v_citad;
        DELETE CRBBANKMAPKWORD WHERE CITAD = V_CITAD;
        update request_citad_aither set status = 'A' where citadcode = v_citad;
    end if;
EXCEPTION
  WHEN OTHERS THEN
      PLOG.ERROR(SQLERRM || dbms_utility.format_error_backtrace);
      RAISE ERRNUMS.E_SYSTEM_ERROR;
END;
/
