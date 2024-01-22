SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_DDMAST_ALL
(AUTOID, ACTYPE, CUSTID, AFACCTNO, CUSTODYCD, 
 ACCTNO, CCYCD, REFCASAACCT, BALANCE, HOLDBALANCE, 
 BANKBALANCE, BANKHOLDBALANCE, RECEIVING, NETTING, PENDINGHOLD, 
 PENDINGUNHOLD, STATUS, EN_STATUS, STATUSCODE)
AS 
(
SELECT a.autoid, a.actype, a.custid, a.afacctno, a.custodycd, a.acctno,
       a.ccycd, a.refcasaacct, a.balance, a.holdbalance, a.bankbalance, a.bankholdbalance, a.receiving, a.netting,
         a.pendinghold, a.pendingunhold, c.cdcontent status, c.EN_cdcontent en_status,a.status statuscode
  FROM ddmast a, (select * from allcode  where cdname = 'STATUS' and cdtype ='CI') c
  where a.status =c.cdval
)
/
