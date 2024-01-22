SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_HOLDMT0_HOLDMT0
(ORDERID, REQCODE, CODEID, SYMBOL, ACCTNO, 
 DDACCTNO, REFCASAACCT, CUSTODYCD, CUSTNAME, EXECTYPE, 
 TXDATE, SETTLE_DATE, AMOUNT, QUANTITY, FEE, 
 TAX, SHORTNAME, CIFID, BALANCE, HOLDBALANCE, 
 BANKHOLDEDBYBROKER, MEMBERID, BRNAME, BRPHONE, CCYCD)
AS 
SELECT  OD.ORDERID,'HOLDOD' REQCODE,SB.CODEID , SB.SYMBOL,AF.ACCTNO, DD.ACCTNO DDACCTNO,DD.REFCASAACCT ,
                                    CF.CUSTODYCD,CF.FULLNAME CUSTNAME, A1.CDCONTENT EXECTYPE,
                                    OD.TXDATE,OD.CLEARDATE SETTLE_DATE,
                                    (CASE WHEN CF.FEEDAILY = 'Y' THEN OD.NETAMOUNT ELSE OD.EXECAMT END) AMOUNT, OD.EXECQTTY QUANTITY,NVL(OD.FEEAMT,0) FEE,NVL(OD.TAXAMT,0) TAX,FA.SHORTNAME,
                                    CF.CIFID,DD.BALANCE,DD.HOLDBALANCE,DD.HOLDBALANCE BANKHOLDEDBYBROKER,FA.AUTOID MEMBERID,
                                    VW_MBR.DISPLAY BRNAME,VW_MP.DISPLAY BRPHONE,dd.CCYCD
                        FROM  ODMAST OD,DDMAST DD,AFMAST AF,CFMAST CF,SBSECURITIES SB,FAMEMBERS FA,VW_CUSTODYCD_MEMBER MM,
                            VW_MEMBER_BROKER VW_MBR,VW_MEMBER_PHONE VW_MP,ALLCODE A1,
                            (select varvalue  from sysvar where varname = 'DEALINGCUSTODYCD')sys
                            WHERE   --TL.TXNUM = OD.TXNUM
                                    OD.ORSTATUS = '4'
                                --AND TL.TLTXCD = '8893'
                                AND DD.STATUS <> 'C' AND DD.CCYCD = 'VND' AND DD.ISDEFAULT = 'Y'
                                AND OD.CUSTODYCD = CF.CUSTODYCD
                                AND CF.CUSTODYCD = DD.CUSTODYCD
                                AND CF.CUSTODYCD = OD.CUSTODYCD
                                AND AF.CUSTID = CF.CUSTID
                                AND OD.CODEID = SB.CODEID
                                AND FA.AUTOID = OD.MEMBER
                                AND MM.VALUE = FA.AUTOID
                                AND MM.FILTERCD = OD.CUSTODYCD
                                AND OD.EXECTYPE = 'NB'
                                AND OD.ISHOLD = 'N'
                                AND FA.AUTOID = VW_MBR.FILTERCD (+)
                                AND MM.value = VW_MBR.value (+)
                                AND FA.AUTOID = VW_MP.FILTERCD (+)
                                AND MM.value = VW_MP.value (+)
                                --AND TL.TXDATE = OD.TXDATE
                                and od.trade_date = getcurrdate
                                AND OD.AFACCTNO = AF.ACCTNO
                                AND FA.ROLES = 'BRK'
                                AND DD.AFACCTNO = AF.ACCTNO
                                AND OD.DELTD <> 'Y'
                                AND A1.CDNAME = 'EXECTYPE' AND A1.CDTYPE = 'OD' AND A1.CDVAL = 'NB' AND A1.CDVAL  = OD.exectype
                                and SUBSTR(cf.custodycd,0,4) not like sys.varvalue
/
