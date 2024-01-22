SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_FAMEMBERS
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
                                      )
                                    FA
                                WHERE   FA.CUSTID IN (SELECT CUSTID fROM emailreport)


-- End of DDL Script for View HOSTSHVTEST.V_COMPARE_BROKERVSD
/
