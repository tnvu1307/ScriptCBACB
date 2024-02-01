SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CRBTXREQOD','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CRBTXREQOD', 'Quản lý Hold', 'Hold management', 'SELECT *FROM(
SELECT OD.ORDERID,SB.CODEID , SB.SYMBOL, CF.CUSTODYCD,AF.acctno ACCOUNTNO, DD.ACCTNO DDACCTNO,CF.fullname CUSTNAME,DD.refcasaacct REFCASAACCT,
                                CF.CIFID,
                                DD.balance BALANCE,
                                DD.holdbalance HOLDBALANCE,
                                buf.holdbalance BANKHOLDEDBYBROKER,
                                FA.autoid MEMBERID,
                                VW_MBR.display BRNAME,
                                VW_MP.display BRPHONE,
                                A1.CDCONTENT EXECTYPE,
                                OD.EXECTYPE CDVAL,
                                OD.TXDATE,
                                NVL(OD.EXECAMT  * OD.EXECQTTY,0) AMOUNT,NVL(OD.FEEAMT,0) FEE,NVL(OD.TAXAMT,0) TAX,FA.SHORTNAME CTCK
                    FROM TLLOG TL, ODMAST OD,DDMAST DD,AFMAST AF,CFMAST CF,SBSECURITIES SB,FAMEMBERS FA,VW_CUSTODYCD_MEMBER MM,
                        ALLCODE A1,vw_member_broker VW_MBR,vw_member_phone VW_MP,buf_dd_member buf
                        WHERE   DD.STATUS <> ''C'' AND DD.CCYCD = ''VND'' AND DD.ISDEFAULT = ''Y''
                            AND OD.CUSTODYCD = CF.CUSTODYCD
                            AND CF.CUSTODYCD = DD.CUSTODYCD
                            AND CF.CUSTODYCD = OD.CUSTODYCD
                            AND AF.CUSTID = CF.CUSTID
                            AND OD.CODEID = SB.CODEID
                            AND FA.AUTOID = OD.MEMBER
                            AND MM.VALUE = FA.AUTOID
                            AND MM.FILTERCD = OD.CUSTODYCD
                            AND OD.EXECTYPE = ''NB''
                            AND OD.ISHOLD = ''N''
                            AND A1.CDNAME = ''EXECTYPE'' AND A1.CDTYPE = ''OD'' AND A1.CDVAL = OD.EXECTYPE
                            AND VW_MBR.filtercd = FA.AUTOID
                            AND VW_MP.filtercd  = FA.AUTOID
                            AND buf.DDACCTNO = DD.ACCTNO and buf.memberid = FA.AUTOID
                            and not exists ( select f.cvalue from
                                    tllog tl, tllogfld f where tl.txnum = f.txnum and
                                    tl.txdate = f.txdate and tl.tltxcd = ''6690'' and f.fldcd
                                    = ''10'' and tl.txstatus in(''1'', ''4'') and f.cvalue =  NVL(OD.EXECAMT  * OD.EXECQTTY,0))
) GROUP BY CTCK,EXECTYPE,TXDATE,AMOUNT,FEE,TAX,ORDERID,CODEID , SYMBOL, CUSTODYCD,ACCOUNTNO, DDACCTNO,CUSTNAME,REFCASAACCT,BALANCE,HOLDBALANCE,MEMBERID,BRNAME,BRPHONE,CDVAL,BANKHOLDEDBYBROKER,CIFID', 'CRBTXREQOD', NULL, NULL, '6690', NULL, 5000, 'N', 1, 'NNNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;