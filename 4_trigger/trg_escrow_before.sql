SET DEFINE OFF;
CREATE OR REPLACE TRIGGER TRG_ESCROW_BEFORE 
 BEFORE
  INSERT OR UPDATE
 ON escrow
REFERENCING NEW AS NEWVAL OLD AS OLDVAL
 FOR EACH ROW
DECLARE
    l_BDDacctno VARCHAR2(100);
BEGIN
    IF NVL(:NEWVAL.BBANKACCTNO_IICA,'?!') <> NVL(:OLDVAL.BBANKACCTNO_IICA,'?!') THEN
        select max(dd.acctno)into l_BDDacctno 
        from ddmast dd 
        where trim(dd.refcasaacct) = :NEWVAL.BBANKACCTNO_IICA and status not in ('P','C')
            and dd.custodycd = :NEWVAL.BCUSTODYCD;
        :NEWVAL.BDDACCTNO_IICA  := nvl(l_BDDacctno,'');
    END IF;
    
END;
/
