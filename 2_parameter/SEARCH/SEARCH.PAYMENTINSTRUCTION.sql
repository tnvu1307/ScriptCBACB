SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('PAYMENTINSTRUCTION','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('PAYMENTINSTRUCTION', 'Chỉ thị thanh toán duyệt từ SB', 'Payment instruction status from SB', 'SELECT T.AUTOID,T.OBJNAME,T.KEYNAME,T.KEYVALUE,T.ACTION,T.STATUS,T.LOGTIME,T.APPLYTIME,
       T.TXNUM,T.TXDATE,T.TLTXCD,T.GLOBALID,T.ERR_CODE,
       E.EN_ERRDESC ERR_MSG, A1.EN_CDCONTENT EN_STATUSCONTENT, A2.EN_CDCONTENT ACTIONCONTENT 
FROM SYN_FACB_LOG_NOTIFY T, ALLCODE A1, ALLCODE A2, DEFERROR E
WHERE A1.CDTYPE = ''FA''
      AND A1.CDNAME = ''SYNSTATUS''
      AND A1.CDVAL = T.STATUS
      AND A2.CDTYPE = ''SB''
      AND A2.CDNAME = ''SYNSTATUS''
      AND A2.CDVAL = T.ACTION
      AND T.ERR_CODE = E.ERRNUM(+)', 'PAYMENTINSTRUCTION', 'frmPAYMENTINSTRUCTION', NULL, NULL, 0, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;