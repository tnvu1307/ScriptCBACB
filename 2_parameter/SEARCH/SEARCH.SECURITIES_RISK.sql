SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SECURITIES_RISK','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SECURITIES_RISK', 'Tham số hệ thống chứng khoán ký quỹ tài khoản', 'System parameter Securities for credit line', '
select sb.symbol, sb.codeid, risk.mrmaxqtty,sb.roomlimit roomlimit74, risk.mrpricerate, risk.mrpriceloan,
    rm.mrmaxqtty - rm.seqtty avlmrqtty, rm.seqtty,  c1.cdcontent ismarginallow , sb.listingqtty, rm.afmaxamt, rm.afmaxamtt3
from securities_info sb, v_getmarginroominfo rm, securities_risk risk, allcode c1
where sb.codeid = risk.codeid and sb.codeid = rm.codeid
and c1.cdtype = ''SY'' and c1.cdname = ''YESNO'' and c1.cdval = risk.ismarginallow
and 0=0', 'SECURITIES_RISK', 'frmSECURITIES_RISK', NULL, NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;