SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_FAMEMBERS_GCB
(ID)
AS 
SELECT FA.ID 
                                 FROM
                                      (
                                      SELECT CUSTID , amcid ID
                                       FROM CFMAST where amcid<>0
                                       UNION ALL
                                       SELECT CUSTID , gcbid ID
                                        FROM CFMAST where amcid<>0
                                        UNION ALL
                                        SELECT CUSTID , trusteeid ID
                                        FROM CFMAST where amcid<>0
                                        UNION ALL
                                       SELECT CUSTID , lcbid ID
                                        FROM CFMAST where amcid<>0
                                        union all
                                        select Cf.CUSTID , fa.brkid ID from cfmast cf, fabrokerage fa where cf.custodycd = fa.custodycd
                                        union all
                                        select Cf.CUSTID , ap.refid ID from cfmast cf, cflnkap ap where cf.custid = ap.custid
                                      )
                                    FA
                                WHERE   FA.CUSTID IN (SELECT CUSTID fROM emailreport)


-- End of DDL Script for View HOSTSHVTEST.V_COMPARE_BROKERVSD
/
