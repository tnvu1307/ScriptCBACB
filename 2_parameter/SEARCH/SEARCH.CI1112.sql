SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CI1112','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CI1112', 'Tra cứu nhanh bảng kê UNC cần từ chối (1112)', 'View payment order to cancel (1112)', 'SELECT distinct po.*, A1.CDCONTENT POSTATUS, tl.tltxcd
   FROM POMAST PO, ALLCODE A1,  vw_tllog_all tl, vw_tllogfld_all tf
    WHERE
        po.TXDATE=TO_DATE(''<$BUSDATE>'',''DD/MM/RRRR'')
        And tl.txnum = tf.txnum AND tl.txdate = tf.txdate
        AND tf.fldcd = ''99'' AND tf.cvalue = po.txnum
    AND
      PO.STATUS=A1.CDVAL AND A1.CDTYPE=''SA''
    AND A1.CDNAME=''POSTATUS'' AND POTYPE=''001'' AND STATUS=''A''
    AND (
            ''<$BRID>'' =''0001''   OR ''<$BRID>'' =tl.BRID
        )', 'CIMAST', '', '', '1112', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;