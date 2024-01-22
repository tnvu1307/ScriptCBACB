SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_get_broker(PV_afACCTNO IN VARCHAR2, PV_TYPE  IN VARCHAR2)
    RETURN varchar2 IS

-- MODIFICATION HISTORY
-- Person      Date         Comments
-- ---------   ------       -------------------------------------------
-- longnh
    V_cfcustid    varchar2(10);
    V_RESULT      varchar2(20);

BEGIN
IF PV_TYPE = 'CUSTID' THEN--LAY MA MOI GIOI THEO CUSTID HAY AFACCTNO
    V_cfcustid := PV_afACCTNO;
ELSE
    select max(custid) into V_cfcustid from afmast where acctno = PV_afACCTNO;
END IF;


        SELECT --LNK.afacctno cfcustodycd, LNK.reacctno,RET.actype, RET.rerole, REGL.refrecflnkid,REG.autoid,
        --REG.custid,
        max(case when ret.rerole = 'RM' then substr(LNK.reacctno,1,10)
             when ret.rerole = 'RD' then nvl(REG.custid,substr(LNK.reacctno,1,10))
        end||'&'||recf.brid) --,
        --recf.brid
        into V_RESULT
        FROM REAFLNK LNK,   RETYPE RET, regrplnk REGL, regrp REG, recflnk recf
        WHERE LNK.afacctno like V_cfcustid
        AND substr(lnk.reacctno,11,4) = RET.actype
        AND LNK.reacctno = REGL.reacctno(+)
        AND REGL.refrecflnkid = REG.autoid(+)
        and getcurrdate between TO_DATE(LNK.frdate,'DD/MM/YYYY') and nvl(lnk.clstxdate,LNK.todate)
        and recf.status='A'
        and case when ret.rerole = 'RM' then substr(LNK.reacctno,1,10)
                 when ret.rerole = 'RD' then nvl(REG.custid,substr(LNK.reacctno,1,10))
        end = recf.custid;

RETURN V_RESULT;
EXCEPTION
   WHEN OTHERS THEN
    RETURN '';
END;
 
 
/
