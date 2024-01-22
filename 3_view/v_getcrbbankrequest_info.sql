SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW V_GETCRBBANKREQUEST_INFO
(AUTOID, TXDATE, TRANSACTIONNUMBER, STATUS, TRNREF, 
 TRN_DT, DESBANKACCOUNT, ACCNAME, ACCNUM, BANKCODE, 
 BRANCH, LOCATION, AMOUNT, KEYACCT1, KEYACCT2, 
 TRANSACTIONDESCRIPTION, ISCONFIRMED, ISMANUAL, USERCREATED, CREATEDT, 
 ERRORDESC, ORGSTATUS)
AS 
SELECT CRB.autoid, CRB.txdate, CRB.transactionnumber, A1.CDCONTENT status, CRB.trnref,  CRB.trn_dt, CRB.desbankaccount, CRB.accname,
    CRB.accnum, CRB.bankcode,   CRB.branch, CRB.location, CRB.amount, CRB.keyacct1, CRB.keyacct2,  CRB.transactiondescription,
    CRB.isconfirmed, CRB.ismanual, CRB.usercreated, CRB.createdt, CRB.errordesc, CRB.status ORGSTATUS
FROM crbbankrequest CRB, ALLCODE A1
where CRB.STATUS =A1.CDVAL AND A1.CDTYPE = 'RM' AND A1.CDNAME = 'CRBRQDSTS' AND CRB.status <> 'C' order by autoid
/
