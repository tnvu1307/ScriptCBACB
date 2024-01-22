SET DEFINE OFF;
CREATE OR REPLACE TRIGGER TRG_BRGRP_INSERT_AFTER 
 AFTER
  INSERT
 ON BRGRP
REFERENCING NEW AS NEWVAL OLD AS OLDVAL
 FOR EACH ROW
DISABLE
declare
  
  pkgctx     plog.log_ctx;
  logrow     tlogdebug%ROWTYPE;
  l_count    number;
begin

  FOR i IN (SELECT * FROM tlogdebug) LOOP
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  END LOOP;
  pkgctx := plog.init('trg_brgrp_insert_after',
                      plevel           => NVL(logrow.loglevel, 30),
                      plogtable        => (NVL(logrow.log4table, 'N') = 'Y'),
                      palert           => (NVL(logrow.log4alert, 'N') = 'Y'),
                      ptrace           => (NVL(logrow.log4trace, 'N') = 'Y'));

  plog.setbeginsection(pkgctx, 'trg_brgrp_insert_after');
  
  select count(*) into l_count
  from VSDBICCODE
  where BRID = :NEWVAL.BRID;
  
  IF l_count = 0 THEN
      INSERT into VSDBICCODE (BRID, BICCODE, VSDBICCODE, VSDPLACE)
        values (:NEWVAL.BRID, 'VSDSBSXX', 'VSDSVN01', '001');
  END IF;
  
  plog.setEndSection(pkgctx, 'trg_brgrp_insert_after');
exception
  when others then
    plog.error(pkgctx, SQLERRM);
    plog.setEndSection(pkgctx, 'trg_brgrp_insert_after');
end;
/
