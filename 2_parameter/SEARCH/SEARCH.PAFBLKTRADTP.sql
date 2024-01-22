SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('PAFBLKTRADTP','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('PAFBLKTRADTP', 'Tra cứu cảnh báo trái phiếu', ' Bond alert monitoring', 'SELECT DISTINCT *
FROM
(
select (TRADE.BUY_VALUE - TRADE.SELL_VALUE + NAV.current_nav) TOTALNAV,PR.totalinvestlimit, HOLD.CurrentCount, PR.maxbondtype
from CFAFTRDLNK CF,
     (SELECT maxbondtype,totalinvestlimit 
      FROM CFTRDPOLICY WHERE LEVELCD=''S'' AND STATUS=''A''  
      and getcurrdate >= frdate and getcurrdate <= todate) PR,
      ( select count(*) CurrentCount
               FROM  (select sb.symbol
                    from CFAFTRDLNK CF, semast SE, sbsecurities sb
                    WHERE CF.afacctno = SE.afacctno AND CF.status = ''A''
                           and sb.codeid = se.codeid AND se.trade >0
                           and sb.tradeplace=''010'' and sb.sectype =''006'' and sb.bondtype =''001''  --- chi tinh trai phieu chinh phu

                    union
                    select sb.symbol
                    FROM ODMAST OD, CFAFTRDLNK AF,sbsecurities sb
                    WHERE OD.AFACCTNO=AF.AFACCTNO AND OD.DELTD <> ''Y''
                          and sb.codeid = od.codeid
                          and sb.tradeplace=''010'' and sb.sectype =''006'' and sb.bondtype =''001''
                          and od.exectype not in (''CB'',''CS'')
                                and od.execqtty + od.remainqtty >0
                             ))  HOLD,
              ( select SUM(SE.trade*SE.costprice) current_nav
                from CFAFTRDLNK CF, semast SE, sbsecurities sb
                WHERE CF.afacctno = SE.afacctno AND CF.status = ''A''
                       and sb.codeid = se.codeid
                        and sb.tradeplace=''010'' and sb.sectype =''006'' and sb.bondtype =''001'') NAV,
             (  SELECT NVL(SUM(DECODE(EXECTYPE,''NB'',(OD.ORDERQTTY-OD.CANCELQTTY-OD.EXECQTTY)*QUOTEPRICE+EXECAMT,0)),0) BUY_VALUE,
                  NVL(SUM(DECODE(EXECTYPE,''NS'',(OD.ORDERQTTY-OD.CANCELQTTY-OD.EXECQTTY)*QUOTEPRICE+EXECAMT,0)),0) SELL_VALUE
                 FROM ODMAST OD, CFAFTRDLNK AF,sbsecurities sb
                WHERE OD.AFACCTNO=AF.AFACCTNO AND OD.DELTD <> ''Y''
                      and sb.codeid = od.codeid  and od.exectype not in (''CB'',''CS'')
                      and od.execqtty + od.remainqtty >0
                      and sb.tradeplace=''010'' and sb.sectype =''006'' and sb.bondtype =''001'') TRADE
               
          
where (TRADE.BUY_VALUE - TRADE.SELL_VALUE + NAV.current_nav) > PR.totalinvestlimit
or HOLD.CurrentCount  > PR.maxbondtype
)
where 0=0', 'PAFBLKTRADTP', 'frmPAFBLKTRADTP', '', '', NULL, 5000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;