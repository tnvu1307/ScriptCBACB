SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('TBL_SHV_FEE_COLLECTION','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('TBL_SHV_FEE_COLLECTION', 'Lịch sử thu phí', 'Fee collection history', 'SELECT AUTOID,BILLING_MONTH,PORTFOLIO_NAME,PORTFOLIO_NO,NVL(TOTAL_FEE_AMOUNT,0)TOTAL_FEE_AMOUNT,NVL(TRANSACTION_FEE,0)TRANSACTION_FEE,NVL(REPAIR_FEE,0)REPAIR_FEE,
NVL(SAFE_CUSTODYCD_FEE,0)SAFE_CUSTODYCD_FEE,NVL(STC_APPLICATION_FEE,0),STC_APPLICATION_FEE,NVL(PROXY_VOTING_FEE,0)PROXY_VOTING_FEE,NVL(ADDHOC_FEE,0)ADDHOC_FEE,
TO_CHAR(AITHER_BOOKING,''DD/MM/RRRR'') AITHER_BOOKING,TO_CHAR(REALCOLLECTION,''DD/MM/RRRR'') REALCOLLECTION,A1.<@CDCONTENT> STATUS,REMARK
FROM TBL_SHV_FEE_COLLECTION ,(SELECT * from allcode where cdname = ''PAID_STATUS'' and cdtype = ''DD'') A1
WHERE   STATUS = A1.CDVAL(+)', 'TBL_SHV_FEE_COLLECTION', NULL, NULL, NULL, 0, 1000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;