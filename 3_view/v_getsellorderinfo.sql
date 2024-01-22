SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW V_GETSELLORDERINFO
(SEACCTNO, SECUREAMT, SECUREMTG, SERECEIVING, EXECQTTY)
AS 
(

SELECT A.SEACCTNO, A.SECUREAMT + NVL(B.absecured,0) SECUREAMT, A.SECUREMTG, A.SERECEIVING, A.EXECQTTY FROM
    (
        SELECT SEACCTNO, SUM(SECUREAMT) SECUREAMT, SUM(SECUREMTG) SECUREMTG, SUM(RECEIVING) SERECEIVING, SUM(EXECQTTY) EXECQTTY
         FROM (
            SELECT OD.SEACCTNO,
                   CASE WHEN OD.EXECTYPE IN ('NS', 'SS') THEN to_number(nvl(varvalue,0))*NVL(REMAINQTTY,0) + NVL(EXECQTTY,0) ELSE 0 END SECUREAMT,
                   CASE WHEN OD.EXECTYPE = 'MS'  THEN to_number(nvl(varvalue,0)) * NVL(REMAINQTTY,0) + NVL(EXECQTTY,0) ELSE 0 END SECUREMTG,
                   0 RECEIVING, CASE WHEN OD.EXECTYPE IN ('NS', 'SS') THEN NVL(OD.EXECQTTY,0) ELSE 0 END EXECQTTY
               FROM ODMAST OD, SYSVAR SY
               WHERE OD.EXECTYPE IN ('NS', 'SS','MS')
                   and not(nvl(od.grporder,'N')='Y' and od.matchtype='P')
                   and sy.grname='SYSTEM' and sy.varname='HOSTATUS'
                   AND OD.TXDATE =(select to_date(VARVALUE,'DD/MM/YYYY') from sysvar where grname='SYSTEM' and varname='CURRDATE')
                   AND NVL(OD.GRPORDER,'N')<>'Y'
                   AND OD.orstatus <> '7'
				   and od.deltd <> 'Y' 
            )
        GROUP BY SEACCTNO
    ) A,
    (select od.SEACCTNO,
        sum(greatest(od.ORDERQTTY-org.ORDERQTTY,0)) absecured
         from odmast od,odmast org, ood
        where od.orderid=ood.orgorderid
            and OODSTATUS='N' and od.exectype ='AS'
            and od.deltd <> 'Y' and org.deltd <>'Y'
    group by od.SEACCTNO
    ) B
    WHERE A.SEACCTNO = B.SEACCTNO (+)
)



-- End of DDL Script for View HOST.V_GETSELLORDERINFO
/
