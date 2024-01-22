SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE sp_process_sedepobal_report

IS
    v_maxautoid number;
BEGIN
    BEGIN
        select nvl(max(idse),0) into v_maxautoid from sedepobal_report;
    EXCEPTION
    WHEN OTHERS
    THEN
        v_maxautoid:=0;
    END;
for rec in(
    select * from sedepobal where autoid > v_maxautoid and days is not null
    )
    loop
     if REC.DAYS =1 then
       insert INTO sedepobal_report(idse,acctno,txdate,days,qtty,deltd,id,amt,iscallfee)
       VALUES(rec.autoid,rec.acctno,rec.txdate,rec.days,rec.qtty,rec.deltd,rec.id,rec.amt,rec.iscallfee);
     else
       FOR TMP IN 0..REC.days-1
       LOOP
        insert INTO sedepobal_report(idse,acctno,txdate,days,qtty,deltd,id,amt,iscallfee)
        VALUES(rec.autoid,rec.acctno,rec.txdate+TMP,1,rec.qtty,rec.deltd,rec.id,REC.amt/REC.DAYS,rec.iscallfee);
       END LOOP;
     end if;
    end loop;
EXCEPTION
    WHEN OTHERS
    THEN
        BEGIN
            RAISE;
            RETURN;
        END;
END;
/
