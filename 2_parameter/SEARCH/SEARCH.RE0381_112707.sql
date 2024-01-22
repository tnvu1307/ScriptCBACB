SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('RE0381_112707','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('RE0381_112707', 'Tra cứu khách hàng của môi giới (Giao dịch 0381 để chuyển môi giới)', 'View customer belong to remiser (wait for 0381 to move to other remiser)', 'select recf.custid||ret.actype REACCT,
red.reactype ACTYPE,ret.typename,cf.fullname,A1.CDCONTENT DESC_REROLE,
RET.rerole,a2.cdcontent DESC_RETYPE,recf.effdate,recf.expdate,A3.CDCONTENT AFSTATUS
from recflnk recf,recfdef red,retype ret,cfmast cf,allcode a1,allcode a2,allcode a3
where recf.status=''A''
and nvl(red.status,''A'')=''A''
and recf.autoid=red.refrecflnkid
and ret.actype=red.reactype
and cf.custid=recf.custid
and a1.cdtype=''RE'' AND A1.CDNAME=''REROLE'' AND A1.CDVAL=RET.rerole
and a2.cdtype=''RE'' AND A2.CDNAME=''RETYPE'' AND A2.CDVAL=RET.RETYPE
and a3.cdtype=''RE'' AND A3.CDNAME=''AFSTATUS'' AND A3.CDVAL=RET.AFSTATUS', 'RE.REMAST', '', '', '', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;