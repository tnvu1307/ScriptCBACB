SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_get_brid_bussid_broker (
        p_afacctno IN VARCHAR2,
        p_date in DATE,
        p_type IN NUMBER)
RETURN VARCHAR2
--Ham lay ra ma moi gioi cham soc
--Input: custid cua KH, ngay
--Output: AutoId cua NVMG co loai hinh la moi gioi
  IS
    l_result VARCHAR2(100);
    l_result1 VARCHAR2(100);
    l_count NUMBER;
BEGIN
    --DBMS_OUTPUT.Put_Line('p_type' || p_type);
    IF p_type=1 THEN

               SELECT DISTINCT DECODE(NVL(MN.BRID, NULL), NULL,TO_CHAR(CF.BRID),MN.BRID)
                  into l_result
                    from (
                            select recf.autoid,recf.custid , reaf.afacctno recfcustid, reaf.status, recf.brid
                            from recflnk recf, reaflnk reaf --, retype ret
                            where recf.autoid=reaf.refrecflnkid
                                 and reaf.frdate<=p_date and nvl(reaf.clstxdate,reaf.todate) > p_date
                                 and recf.effdate<=p_date and recf.expdate>p_date
                                 and reaf.afacctno=p_afacctno
                                 --and ret.rerole IN ( 'RM','BM','DG','RD','CM', 'TR')
                                 --and substr(reaf.reacctno,11) = ret.ACTYPE
                            )mn,cfmast cf
                    WHERE
                    cf.custid=mn.recfcustid(+)
                    and cf.custid=p_afacctno;

            SELECT count(1) INTO l_count FROM brgrp WHERE brid=l_result;

            IF l_count>0 THEN
               SELECT nvl(glbrid,brid) INTO l_result1 FROM brgrp WHERE brid=l_result;
            ELSE
                l_result1 := l_result;
            END IF;
    ELSE
            SELECT DISTINCT DECODE(NVL(MN.BRID, NULL), NULL,TO_CHAR(CF.BRID),MN.BRID) into l_result
                    from (
                            select recf.autoid,recf.custid , reaf.afacctno recfcustid, reaf.status, recf.brid
                            from recflnk recf, reaflnk reaf --, retype ret
                            where recf.autoid=reaf.refrecflnkid
                                 and reaf.frdate<=p_date and nvl(reaf.clstxdate,reaf.todate) > p_date
                                 and recf.effdate<=p_date and recf.expdate>p_date
                                 and reaf.afacctno=p_afacctno
                                 --and ret.rerole IN ( 'RM','BM','DG','RD','CM','TR')
                                 --and substr(reaf.reacctno,11) = ret.ACTYPE
                         )mn,cfmast cf
                    WHERE
                    cf.custid=mn.recfcustid(+)
                    and cf.custid=p_afacctno;

            --SELECT nvl(gldept,brid) INTO l_result1 FROM brgrp WHERE brid=l_result;
            SELECT count(1) INTO l_count FROM brgrp WHERE brid=l_result;

            IF l_count>0 THEN
               SELECT nvl(gldept,brid) INTO l_result1 FROM brgrp WHERE brid=l_result;
            ELSE
                l_result1 := l_result;
            END IF;
    END IF;
    RETURN l_result1;
    --DBMS_OUTPUT.Put_Line('l_result1' || l_result1);
EXCEPTION
    WHEN others THEN
        plog.error ('fn_get_brid_bussid_broker: ' || SQLERRM || dbms_utility.format_error_backtrace);
        return null;
END;
 
 
/
