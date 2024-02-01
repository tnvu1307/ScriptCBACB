SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('GL9900','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('GL9900', 'Thông tin tìm kiếm bảng GL', 'GL search information', 'select gl.ref,gl.txdate,gl.txnum,gl.busdate,gl.custid,gl.custodycd,gl.bankid,gl.trans_type,gl.amount,a2.cdcontent COUNTRY,gl.symbol,gl.symbol_qtty SYMBOL_QTTY,gl.symbol_price SYMBOL_PRICE
,gl.txbrid,a.cdcontent TRADEPLACE ,gl.iscorebank,a1.cdcontent CUSTTYPE,gl.note,gl.fullname,gl.acname,gl.apptype,af.typename ACTYPE,app.description,gl.autoid,gl.bridmg,gl.bussmg,gl.excutedate,gl.prinperiod,gl.afacctno
from gl_exp_tran gl , allcode a ,allcode a1, allcode a2 , aftype af, (SELECT tltxcd||subtx trans_type,description FROM appmapbravo) app
where 0=0
and gl.actype = af.actype
and gl.trans_type=app.trans_type(+)
and gl.tradeplace=a.cdval (+)
and gl.custtype = a1.cdval (+)
and gl.country = a2.cdval  (+)
and nvl(a.cdtype,''SA'')=''SA''
and nvl(a.cdname,''TRADEPLACE'')=''TRADEPLACE''
and nvl(a1.cdtype,''CF'')=''CF''
and nvl(a1.cdname,''CUSTTYPE'')=''CUSTTYPE''
and nvl(a2.cdtype,''GL'')=''GL''
and nvl(a2.cdname,''COUNTRY'')=''COUNTRY''
union all
select gl.ref,gl.txdate,gl.txnum,gl.busdate,gl.custid,gl.custodycd,gl.bankid,gl.trans_type,gl.amount,a2.cdcontent COUNTRY,gl.symbol,gl.symbol_qtty SYMBOL_QTTY,gl.symbol_price SYMBOL_PRICE
,gl.txbrid,a.cdcontent TRADEPLACE ,gl.iscorebank,a1.cdcontent CUSTTYPE,gl.note,gl.fullname,gl.acname,gl.apptype, '''' as actype,app.description,gl.autoid,gl.bridmg,gl.bussmg,gl.excutedate,gl.prinperiod,gl.afacctno
from gl_exp_tran gl, allcode a ,allcode a1, allcode a2,(SELECT tltxcd||subtx trans_type,description FROM appmapbravo) app
where 0=0
and gl.actype is null
and gl.trans_type=app.trans_type(+)
and gl.tradeplace=a.cdval (+)
and gl.custtype = a1.cdval (+)
and gl.country = a2.cdval (+)
and nvl(a.cdtype,''SA'')=''SA''
and nvl(a.cdname,''TRADEPLACE'')=''TRADEPLACE''
and nvl(a1.cdtype,''CF'')=''CF''
and nvl(a1.cdname,''CUSTTYPE'')=''CUSTTYPE''
and nvl(a2.cdtype,''GL'')=''GL''
and nvl(a2.cdname,''COUNTRY'')=''COUNTRY''', 'GL9900', NULL, NULL, NULL, NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;