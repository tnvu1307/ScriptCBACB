SET DEFINE OFF;
CREATE OR REPLACE PACKAGE nmpks_ems is

  -- Author  : THONGPM
  -- Created : 29/02/2012 4:55:43 PM
  -- Purpose : Lay thong tin cho email, sms template

  -- Public type declarations
  --type <TypeName> is <Datatype>;

  -- Public constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
  --<VariableName> <Datatype>;

  -- Public function and procedure declarations
  --function <FunctionName>(<Parameter> <Datatype>) return <Datatype>;
  procedure GenNotifyEvent(p_message_type varchar2, p_key_value varchar2);
  procedure GenTemplates(p_message_type varchar2, p_key_value varchar2);
  procedure GenTemplate0215(p_template_id varchar2);
  procedure GenTemplate0216(p_ca_id varchar2);
  procedure GenTemplate105E(p_ca_id varchar2);
  procedure GenTemplate112E(p_ca_id varchar2);
  procedure GenTemplate0326(p_template_id varchar2);
  procedure GenTemplate105S(p_ca_id varchar2);
  procedure GenTemplate0320(p_ca_id varchar2);
  procedure GenTemplateTransaction(p_transaction_number varchar2);
  procedure GenTemplateScheduler(p_template_id varchar2);
  procedure UpdateBodySms(P_autoid varchar2, p_smsbody varchar2) ;
  procedure CheckEarlyDay;
  procedure CheckSystem;
  procedure CheckKhopLenh;
  procedure CheckKLCuoiNgay;
  procedure CheckTLCuoiNgay;
  procedure EmailsmsAuto;
  PROCEDURE CheckNotifyEvent;
  PROCEDURE pr_transferWarning (p_tltxcd VARCHAR2, p_txnum VARCHAR2);
  function CheckEmail(p_email varchar2) return boolean;
  procedure InsertEmailsms (p_template_id varchar2,p_custodycd varchar2,p_status varchar2);
  procedure InsertEmailLog(p_email       varchar2,
                           p_template_id varchar2,
                           p_data_source varchar2,
                           p_account     varchar2);
  function fn_convert_to_vn(strinput in nvarchar2) return nvarchar2;
  function fn_GetNextRunDate(p_last_start_date in date, cycle in char)
    return date;
  PROCEDURE pr_GenTemplateCS23 (p_custid    IN VARCHAR2,
                               p_subType    IN VARCHAR2,
                               p_ccycd      IN VARCHAR2,
                               p_feeAmt     IN VARCHAR2,
                               p_feetype    IN VARCHAR2);
  PROCEDURE pr_GenTemplateEM09;
  PROCEDURE GenCallMailRequire(p_template_id varchar2);
  PROCEDURE pr_GenTemplateEM12 (p_ticker      VARCHAR2,
                             p_paidDate     VARCHAR2,p_ver VARCHAR2);
  PROCEDURE pr_GenTemplateEM20 (p_ticker      VARCHAR2,
                               p_paidDate     VARCHAR2);
  PROCEDURE pr_GenTemplateEM21 (p_ticker      VARCHAR2,
                               p_paidDate     VARCHAR2);
  PROCEDURE pr_GenTemplateEM14 (p_ticker      VARCHAR2,
                               p_paidDate     VARCHAR2);
  PROCEDURE pr_GenTemplateEM15 (p_camastId     VARCHAR2,
                               p_txdate        VARCHAR2,
                               p_custodycd     VARCHAR2,
                               p_quantity      NUMBER,
                               p_amount        NUMBER,
                               p_benefit_acct  VARCHAR2,
                               p_desc          VARCHAR2);
  PROCEDURE pr_GenTemplateWarningLtv (p_issuesid          VARCHAR2,
                                     p_txdate           DATE,
                                     p_ltvRate          NUMBER,
                                     p_ltvWarningRate   NUMBER,
                                     p_template_id      VARCHAR2,
                                     p_email_subject    VARCHAR2);
  PROCEDURE pr_GenTemplateEM23 (p_date  DATE);
  PROCEDURE pr_GenTemplateEM24 (p_codeid      IN VARCHAR2,
                               p_custid       IN VARCHAR2,
                               p_acctno       IN VARCHAR2,
                               p_qtty         IN NUMBER,
                               p_buyQtty      IN NUMBER,
                               p_buyAmt       IN NUMBER,
                               p_interestAmt  IN NUMBER,
                               p_settleDate   IN DATE,
                               p_desc         IN VARCHAR2);
  PROCEDURE pr_GenTemplateUnlistedCAExec (p_camastId     VARCHAR2,
                               p_caschdId                VARCHAR2,
                               p_date                    DATE,
                               p_custId                  VARCHAR2,
                               p_acctno                  VARCHAR2,
                               p_taxamt                  NUMBER,
                               p_amt                     NUMBER,
                               p_isTax                   VARCHAR2,
                               p_desc                    VARCHAR2,
                               p_txmsg in tx.msg_rectype);
  PROCEDURE pr_GenTemplateE281 (p_camastId    VARCHAR2);
  PROCEDURE pr_GenTemplateE282 (p_camastId    VARCHAR2,
                               p_txdate       DATE);
  PROCEDURE pr_GenTemplateCashSec (P_DDACCTNO  IN  VARCHAR2 DEFAULT '',
                                   P_SEACCTNO IN VARCHAR2 DEFAULT '',
                                   P_MEMBERID IN VARCHAR2 DEFAULT '',
                                   P_AMOUNT IN NUMBER DEFAULT '0',
                                   P_QTTY IN NUMBER DEFAULT '0',
                                   P_MessageError IN NUMBER default '0' );
  PROCEDURE pr_GenTemplateEM30 (p_camastId    VARCHAR2,
                               p_afacctno     VARCHAR2);
  PROCEDURE pr_GenTemplateEM31 (p_camastId    VARCHAR2,
                               p_custid       VARCHAR2,
                               p_afacctno     VARCHAR2);
  PROCEDURE pr_GenTemplateEM33 (p_codeid       VARCHAR2,
                                p_scustodycd   VARCHAR2,
                                p_rcustodycd   VARCHAR2,
                                p_qtty         NUMBER);
  PROCEDURE pr_GenTemplate202E (p_date_from DATE,
                                p_date_to DATE);
  PROCEDURE pr_GenTemplate206E (p_report_date DATE);
  PROCEDURE pr_GenTemplate201E;
  PROCEDURE pr_sendInternalEmail (p_datasource IN VARCHAR2,
                                 p_template_id IN VARCHAR2,
                                 p_afacctno    IN VARCHAR2 DEFAULT '',
                                 p_sendTemplateLnk IN VARCHAR2 DEFAULT 'N');

  procedure prc_EmailReq2API(
      p_account IN VARCHAR2,
      p_email IN VARCHAR2,
      p_subject IN VARCHAR2,
      p_datasource IN VARCHAR2,
      p_EmailContent IN clob,
      p_return_code in out VARCHAR2,
      P_return_msg in out VARCHAR2
  );
  procedure prc_EmailReq2API_NEW(
    p_account IN VARCHAR2,
    p_email IN VARCHAR2,
    p_subject IN VARCHAR2,
    p_datasource IN VARCHAR2,
    p_EmailContent IN clob,
     p_template_id IN varchar2,
    p_return_code in out VARCHAR2,
    P_return_msg in out VARCHAR2
);
    PROCEDURE CREATE_RPT_REQUEST(p_report_id IN VARCHAR2, p_datasource IN VARCHAR2, p_template_id IN VARCHAR2, p_account IN VARCHAR2, p_refrptlogs IN OUT VARCHAR2, p_datasource_ref IN OUT VARCHAR2);
end NMPKS_EMS;
/


CREATE OR REPLACE PACKAGE BODY nmpks_ems is
  pkgctx plog.log_ctx;
  logrow tlogdebug%rowtype;
procedure EmailsmsAuto is
    l_datasource  varchar2(2000);
    l_hour        varchar2(20);

    v_currdate    DATE ;
    v_t1_date     DATE ;
    v_type_001    NUMBER;
    v_type_002    NUMBER;
    v_type_003    NUMBER;
    v_type_004    NUMBER;
    v_type_006    NUMBER;
    v_type_007    NUMBER;
    v_type_009    NUMBER;
    v_type_001cn    NUMBER;
    v_type_002cn    NUMBER;
    v_type_003cn    NUMBER;
    v_type_004cn    NUMBER;
    v_type_006cn    NUMBER;
    v_type_007cn    NUMBER;
    v_type_009cn    NUMBER;
 begin

/* select TO_CHAR(SYSDATE,'hh.AM') into l_hour from dual;
 v_currdate := to_date( to_char( SYSDATE,'DD/MM/YYYY'),'dd/mm/yyyy');
 SELECT get_t_date ( v_currdate,1 ) INTO v_t1_date  FROM dual ;

 plog.setBeginSection(pkgctx, 'GenTemplate0551');

--CHI TIEU 1.1  MO tai khoan nhung chua duoc duyet
BEGIN

SELECT count( *) INTO v_type_001  FROM (
SELECT max(af.brid) brid,'001' TYPE,'CFMAST' TLTXCD, cf.custodycd, maker_dt,maker_time,approve_dt,approve_time ,tlp1.tlname maker,tlp2.tlname checker
from maintain_log m,tlprofiles tlp1, tlprofiles tlp2, afmast af, cfmast cf
WHERE maker_dt = v_currdate and child_table_name ='AFMAST' AND column_name ='ACCTNO'
AND action_flag ='ADD' and m.maker_id =tlp1.tlid(+) and m.approve_id =tlp2.tlid(+)
AND to_value = af.acctno AND af.custid = cf.custid
AND (TO_NUMBER( nvl( SUBSTR(approve_time,4,2),to_char(SYSDATE,'mi')))- TO_NUMBER(SUBSTR(maker_time,4,2))>45
     OR
     TO_NUMBER( nvl( SUBSTR(approve_time,1,2),to_char(SYSDATE,'hh')))- TO_NUMBER(SUBSTR(maker_time,1,2))>1)
AND maker_time < '16:00:00'
and af.brid ='0001'
GROUP BY  cf.custodycd, maker_dt,maker_time,approve_dt,approve_time ,tlp1.tlname ,tlp2.tlname

UNION ALL
--m? sau 5h th?h?i duy?t tru?c 9h h?au
SELECT max(af.brid) brid,'001' TYPE, 'CFMAST' TLTXCD,cf.custodycd, maker_dt,maker_time,approve_dt,approve_time ,tlp1.tlname maker,tlp2.tlname checker
from maintain_log m,tlprofiles tlp1, tlprofiles tlp2, afmast af, cfmast cf
where maker_dt <  v_currdate
and child_table_name ='AFMAST' AND column_name ='ACCTNO'
AND action_flag ='ADD' and m.maker_id =tlp1.tlid(+) and m.approve_id =tlp2.tlid(+)
AND to_value = af.acctno AND af.custid = cf.custid
AND approve_time IS NULL
AND maker_dt >=  '01-MAR-2014'
and af.brid ='0001'
GROUP BY  cf.custodycd, maker_dt,maker_time,approve_dt,approve_time ,tlp1.tlname ,tlp2.tlname

UNION
--m? sau 5h th?h?i duy?t tru?c 9h h?au
SELECT max(af.brid) brid,'001' TYPE, 'CFMAST' TLTXCD,cf.custodycd, maker_dt,maker_time,approve_dt,approve_time ,tlp1.tlname maker,tlp2.tlname checker
from maintain_log m,tlprofiles tlp1, tlprofiles tlp2, afmast af, cfmast cf
where approve_dt = v_currdate AND maker_dt = v_t1_date
and child_table_name ='AFMAST' AND column_name ='ACCTNO'
AND action_flag ='ADD' and m.maker_id =tlp1.tlid(+) and m.approve_id =tlp2.tlid(+)
AND to_value = af.acctno AND af.custid = cf.custid
AND maker_time >= '16:00:00' AND  approve_time >'09:00:00'
and af.brid ='0001'
GROUP BY  cf.custodycd, maker_dt,maker_time,approve_dt,approve_time ,tlp1.tlname ,tlp2.tlname
) ;

 exception
    when others THEN
    v_type_001:=0;

 END ;


BEGIN

SELECT count( *) INTO v_type_002  FROM (
SELECT (af.brid) brid,'002' TYPE,'CFMAST' TLTXCD, cf.custodycd, maker_dt,maker_time,approve_dt,approve_time ,tlp1.tlname maker,tlp2.tlname checker
from maintain_log m,tlprofiles tlp1, tlprofiles tlp2, afmast af, cfmast cf
where approve_dt = v_currdate and child_table_name ='AFMAST' AND column_name ='ACCTNO'
AND action_flag ='ADD' and m.maker_id =tlp1.tlid(+) and m.approve_id =tlp2.tlid(+)
AND to_value = af.acctno AND af.custid = cf.custid
AND cf.custid NOT IN (SELECT custid FROM cfsign )
and af.brid ='0001'
) ;

 exception
    when others THEN
    v_type_002:=0;

 END ;


BEGIN

SELECT count( *) INTO v_type_003  FROM (
SELECT (af.brid) brid,'003' TYPE,'CFMAST' TLTXCD, cf.custodycd, maker_dt,maker_time,approve_dt,approve_time ,tlp1.tlname maker,tlp2.tlname checker
from maintain_log m,tlprofiles tlp1, tlprofiles tlp2, afmast af, cfmast cf
where approve_dt =v_currdate  and child_table_name ='AFMAST' AND column_name ='ACCTNO'
AND action_flag ='ADD' and m.maker_id =tlp1.tlid(+) and m.approve_id =tlp2.tlid(+)
AND to_value = af.acctno AND af.custid = cf.custid
AND af. bankacctno is  null
AND AF.corebank ='Y'
and af.brid ='0001'
) ;

 exception
    when others THEN
    v_type_003:=0;
 END ;

BEGIN
SELECT count( *) INTO v_type_004  FROM (
SELECT (af.brid) brid,'004' TYPE,'CFMAST' TLTXCD, cf.custodycd, maker_dt,maker_time,approve_dt,approve_time ,tlp1.tlname maker,tlp2.tlname checker
from maintain_log m,tlprofiles tlp1, tlprofiles tlp2, afmast af, cfmast cf
where maker_dt =v_currdate and child_table_name ='AFMAST' AND column_name ='ACCTNO'
AND action_flag ='ADD' and m.maker_id =tlp1.tlid and m.approve_id =tlp2.tlid
AND to_value = af.acctno AND af.custid = cf.custid
AND cf.activests ='N' AND maker_time < '16:00:00'
and af.brid ='0001'

UNION ALL
SELECT (af.brid) brid,'004' TYPE,'CFMAST' TLTXCD, cf.custodycd, maker_dt,maker_time, approve_dt, approve_time ,tlp1.tlname maker,tlp2.tlname checker
from maintain_log m,tlprofiles tlp1, tlprofiles tlp2, afmast af, cfmast cf
where maker_dt < v_currdate
and child_table_name ='AFMAST' AND column_name ='ACCTNO'
AND action_flag ='ADD' and m.maker_id =tlp1.tlid and m.approve_id =tlp2.tlid
AND to_value = af.acctno AND af.custid = cf.custid
AND cf.activests ='N'
and af.brid ='0001'
UNION ALL

SELECT (af.brid) brid, '004' TYPE,'CFMAST' TLTXCD, cf.custodycd, maker_dt,maker_time, TXDATE approve_dt,txtime approve_time ,tlp1.tlname maker,tlp2.tlname checker
from maintain_log m,tlprofiles tlp1, tlprofiles tlp2, afmast af, cfmast cf,
(SELECT msgacct ,txtime,TXDATE  FROM vw_tllog_all WHERE  TXDATE = v_currdate AND TLTXCD ='0012') TL
where maker_dt = v_t1_date
and child_table_name ='AFMAST' AND column_name ='ACCTNO'
AND action_flag ='ADD' and m.maker_id =tlp1.tlid and m.approve_id =tlp2.tlid
AND to_value = af.acctno AND af.custid = cf.custid
AND AF.acctno = TL.msgacct
AND txtime >'09:00:00'
and af.brid ='0001'

) ;

 exception
    when others THEN
    v_type_004:=0;
 END ;



BEGIN
SELECT count( *) INTO v_type_006  FROM (
SELECT (af.brid) brid, '006' TYPE , '2240' TLTXCD, cf.custodycd, tl.txdate maker_dt , tl.txtime maker_time, tl.txdate approve_dt  , '' approve_time , tlp1.tlname maker,tlp2.tlname checker
from sedeposit se, vw_tllog_all tl, afmast af, cfmast cf ,tlprofiles tlp1, tlprofiles tlp2,tllogfldall tlfld
 where se.txnum = tl.txnum
 AND se.txdate = tl.txdate
 AND TL.TXDATE = TLFLD.TXDATE
 AND TL.TXNUM = TLFLD.TXNUM
 AND tl.tltxcd ='2240'
 AND tlfld.fldcd ='99'
 AND v_currdate   >  getduedate(depodate ,'B' , '000' ,  3)
 AND SE.DELTD <>'Y'
 AND se.STATUS NOT IN ('C')
 AND substr(se.acctno,1,10)=af.acctno
 AND af.custid = cf.custid
 AND tl.tlid = tlp1.tlid(+) and tl.offid =tlp2.tlid(+)
 AND cvalue ='N'
 and af.brid ='0001')
;
 exception
    when others THEN
    v_type_006:=0;
 END ;

BEGIN
SELECT count( *) INTO v_type_007  FROM (
SELECT (af.brid) brid,'007' TYPE,'CFMAST' TLTXCD, cf.custodycd, maker_dt,maker_time,approve_dt,approve_time ,tlp1.tlname maker,tlp2.tlname checker
from maintain_log m,tlprofiles tlp1, tlprofiles tlp2, afmast af, cfmast cf
where  child_table_name ='AFMAST' AND column_name ='ACCTNO'
AND action_flag ='ADD' and m.maker_id =tlp1.tlid(+) and m.approve_id =tlp2.tlid(+)
AND to_value = af.acctno AND af.custid = cf.custid
and cf.custodycd in (Select custodycd from CFBankstatus where banksts ='N' )
AND af.corebank='Y'
and af.brid ='0001'
AND CASE WHEN approve_dt = v_currdate THEN   maker_time ELSE '15:00:00' END  < '16:00:00'
) ;
 exception
    when others THEN
    v_type_007:=0;
 END ;

BEGIN
SELECT count( *) INTO v_type_009  FROM (
SELECT  tl.brid ,
'009' TYPE , TLTXCD TLTXCD, cfcustodycd TXNUM, tl.txdate maker_dt , tl.txtime maker_time, tl.txdate approve_dt  , '' approve_time , tlp1.tlname maker,tlp2.tlname checker
FROM  (SELECT * FROM tllog4dr UNION ALL SELECT * FROM tllog4drall) tl,tlprofiles tlp1, tlprofiles tlp2
WHERE txstatus in('5','8')
AND   tl.tlid = tlp1.tlid(+) and tl.offid =tlp2.tlid(+)
AND tl.tlid <> tl.offid
AND tl.txdate = v_currdate
and tl.brid ='0001'
) ;
 exception
    when others THEN
    v_type_009:=0;
 END ;




begin
SELECT count( *) INTO v_type_001cn  FROM (
SELECT max(af.brid) brid,'001' TYPE,'CFMAST' TLTXCD, cf.custodycd, maker_dt,maker_time,approve_dt,approve_time ,tlp1.tlname maker,tlp2.tlname checker
from maintain_log m,tlprofiles tlp1, tlprofiles tlp2, afmast af, cfmast cf
WHERE maker_dt = v_currdate and child_table_name ='AFMAST' AND column_name ='ACCTNO'
AND action_flag ='ADD' and m.maker_id =tlp1.tlid(+) and m.approve_id =tlp2.tlid(+)
AND to_value = af.acctno AND af.custid = cf.custid
AND (TO_NUMBER( nvl( SUBSTR(approve_time,4,2),to_char(SYSDATE,'mi')))- TO_NUMBER(SUBSTR(maker_time,4,2))>45
     OR
     TO_NUMBER( nvl( SUBSTR(approve_time,1,2),to_char(SYSDATE,'hh')))- TO_NUMBER(SUBSTR(maker_time,1,2))>1)
AND maker_time < '16:00:00'
and af.brid <>'0001'
GROUP BY  cf.custodycd, maker_dt,maker_time,approve_dt,approve_time ,tlp1.tlname ,tlp2.tlname

UNION ALL
--m? sau 5h th?h?i duy?t tru?c 9h h?au
SELECT max(af.brid) brid,'001' TYPE, 'CFMAST' TLTXCD,cf.custodycd, maker_dt,maker_time,approve_dt,approve_time ,tlp1.tlname maker,tlp2.tlname checker
from maintain_log m,tlprofiles tlp1, tlprofiles tlp2, afmast af, cfmast cf
where maker_dt <  v_currdate
and child_table_name ='AFMAST' AND column_name ='ACCTNO'
AND action_flag ='ADD' and m.maker_id =tlp1.tlid(+) and m.approve_id =tlp2.tlid(+)
AND to_value = af.acctno AND af.custid = cf.custid
AND approve_time IS NULL
AND maker_dt >=  '01-MAR-2014'
and af.brid <>'0001'
GROUP BY  cf.custodycd, maker_dt,maker_time,approve_dt,approve_time ,tlp1.tlname ,tlp2.tlname

UNION
--m? sau 5h th?h?i duy?t tru?c 9h h?au
SELECT max(af.brid) brid,'001' TYPE, 'CFMAST' TLTXCD,cf.custodycd, maker_dt,maker_time,approve_dt,approve_time ,tlp1.tlname maker,tlp2.tlname checker
from maintain_log m,tlprofiles tlp1, tlprofiles tlp2, afmast af, cfmast cf
where approve_dt = v_currdate AND maker_dt = v_t1_date
and child_table_name ='AFMAST' AND column_name ='ACCTNO'
AND action_flag ='ADD' and m.maker_id =tlp1.tlid(+) and m.approve_id =tlp2.tlid(+)
AND to_value = af.acctno AND af.custid = cf.custid
AND maker_time >= '16:00:00' AND  approve_time >'09:00:00'
and af.brid <>'0001'
GROUP BY  cf.custodycd, maker_dt,maker_time,approve_dt,approve_time ,tlp1.tlname ,tlp2.tlname
) ;

 exception
    when others THEN
    v_type_001cn:=0;

 END ;


BEGIN

SELECT count( *) INTO v_type_002cn  FROM (
SELECT (af.brid) brid,'002' TYPE,'CFMAST' TLTXCD, cf.custodycd, maker_dt,maker_time,approve_dt,approve_time ,tlp1.tlname maker,tlp2.tlname checker
from maintain_log m,tlprofiles tlp1, tlprofiles tlp2, afmast af, cfmast cf
where approve_dt = v_currdate and child_table_name ='AFMAST' AND column_name ='ACCTNO'
AND action_flag ='ADD' and m.maker_id =tlp1.tlid(+) and m.approve_id =tlp2.tlid(+)
AND to_value = af.acctno AND af.custid = cf.custid
AND cf.custid NOT IN (SELECT custid FROM cfsign )
and af.brid <>'0001'
) ;

 exception
    when others THEN
    v_type_002cn :=0;

 END ;


BEGIN

SELECT count( *) INTO v_type_003cn  FROM (
SELECT (af.brid) brid,'003' TYPE,'CFMAST' TLTXCD, cf.custodycd, maker_dt,maker_time,approve_dt,approve_time ,tlp1.tlname maker,tlp2.tlname checker
from maintain_log m,tlprofiles tlp1, tlprofiles tlp2, afmast af, cfmast cf
where approve_dt =v_currdate  and child_table_name ='AFMAST' AND column_name ='ACCTNO'
AND action_flag ='ADD' and m.maker_id =tlp1.tlid(+) and m.approve_id =tlp2.tlid(+)
AND to_value = af.acctno AND af.custid = cf.custid
AND af. bankacctno is  null
AND AF.corebank ='Y'
and af.brid <>'0001'
) ;

 exception
    when others THEN
    v_type_003cn :=0;
 END ;

BEGIN
SELECT count( *) INTO v_type_004cn  FROM (
SELECT (af.brid) brid,'004' TYPE,'CFMAST' TLTXCD, cf.custodycd, maker_dt,maker_time,approve_dt,approve_time ,tlp1.tlname maker,tlp2.tlname checker
from maintain_log m,tlprofiles tlp1, tlprofiles tlp2, afmast af, cfmast cf
where maker_dt =v_currdate and child_table_name ='AFMAST' AND column_name ='ACCTNO'
AND action_flag ='ADD' and m.maker_id =tlp1.tlid and m.approve_id =tlp2.tlid
AND to_value = af.acctno AND af.custid = cf.custid
AND cf.activests ='N' AND maker_time < '16:00:00'
and af.brid <>'0001'

UNION ALL
SELECT (af.brid) brid,'004' TYPE,'CFMAST' TLTXCD, cf.custodycd, maker_dt,maker_time, approve_dt, approve_time ,tlp1.tlname maker,tlp2.tlname checker
from maintain_log m,tlprofiles tlp1, tlprofiles tlp2, afmast af, cfmast cf
where maker_dt < v_currdate
and child_table_name ='AFMAST' AND column_name ='ACCTNO'
AND action_flag ='ADD' and m.maker_id =tlp1.tlid and m.approve_id =tlp2.tlid
AND to_value = af.acctno AND af.custid = cf.custid
AND cf.activests ='N'
and af.brid <>'0001'
UNION ALL

SELECT (af.brid) brid, '004' TYPE,'CFMAST' TLTXCD, cf.custodycd, maker_dt,maker_time, TXDATE approve_dt,txtime approve_time ,tlp1.tlname maker,tlp2.tlname checker
from maintain_log m,tlprofiles tlp1, tlprofiles tlp2, afmast af, cfmast cf,
(SELECT msgacct ,txtime,TXDATE  FROM vw_tllog_all WHERE  TXDATE = v_currdate AND TLTXCD ='0012') TL
where maker_dt = v_t1_date
and child_table_name ='AFMAST' AND column_name ='ACCTNO'
AND action_flag ='ADD' and m.maker_id =tlp1.tlid and m.approve_id =tlp2.tlid
AND to_value = af.acctno AND af.custid = cf.custid
AND AF.acctno = TL.msgacct
AND txtime >'09:00:00'
and af.brid <>'0001'

) ;

 exception
    when others THEN
    v_type_004cn :=0;
 END ;



BEGIN
SELECT count( *) INTO v_type_006cn  FROM (
SELECT (af.brid) brid, '006' TYPE , '2240' TLTXCD, cf.custodycd, tl.txdate maker_dt , tl.txtime maker_time, tl.txdate approve_dt  , '' approve_time , tlp1.tlname maker,tlp2.tlname checker
from sedeposit se, vw_tllog_all tl, afmast af, cfmast cf ,tlprofiles tlp1, tlprofiles tlp2,tllogfldall tlfld
 where se.txnum = tl.txnum
 AND se.txdate = tl.txdate
 AND TL.TXDATE = TLFLD.TXDATE
 AND TL.TXNUM = TLFLD.TXNUM
 AND tl.tltxcd ='2240'
 AND tlfld.fldcd ='99'
 AND v_currdate   >  getduedate(depodate ,'B' , '000' ,  3)
 AND SE.DELTD <>'Y'
 AND se.STATUS NOT IN ('C')
 AND substr(se.acctno,1,10)=af.acctno
 AND af.custid = cf.custid
 AND tl.tlid = tlp1.tlid(+) and tl.offid =tlp2.tlid(+)
 AND cvalue ='N'
 and af.brid <>'0001') ;
 exception
    when others THEN
    v_type_006cn:=0;
 END ;

BEGIN
SELECT count( *) INTO v_type_007cn  FROM (
SELECT (af.brid) brid,'007' TYPE,'CFMAST' TLTXCD, cf.custodycd, maker_dt,maker_time,approve_dt,approve_time ,tlp1.tlname maker,tlp2.tlname checker
from maintain_log m,tlprofiles tlp1, tlprofiles tlp2, afmast af, cfmast cf
where  child_table_name ='AFMAST' AND column_name ='ACCTNO'
AND action_flag ='ADD' and m.maker_id =tlp1.tlid(+) and m.approve_id =tlp2.tlid(+)
AND to_value = af.acctno AND af.custid = cf.custid
and cf.custodycd in (Select custodycd from CFBankstatus where banksts ='N' )
AND af.corebank='Y'
and af.brid <>'0001'
AND CASE WHEN approve_dt = v_currdate THEN   maker_time ELSE '15:00:00' END  < '16:00:00'
) ;
 exception
    when others THEN
    v_type_007cn :=0;
 END ;

BEGIN
SELECT count( *) INTO v_type_009cn  FROM (
SELECT  tl.brid ,
'009' TYPE , TLTXCD TLTXCD, cfcustodycd TXNUM, tl.txdate maker_dt , tl.txtime maker_time, tl.txdate approve_dt  , '' approve_time , tlp1.tlname maker,tlp2.tlname checker
FROM  (SELECT * FROM tllog4dr UNION ALL SELECT * FROM tllog4drall) tl,tlprofiles tlp1, tlprofiles tlp2
WHERE txstatus in('5','8')
AND   tl.tlid = tlp1.tlid(+) and tl.offid =tlp2.tlid(+)
AND tl.tlid <> tl.offid
AND tl.txdate = v_currdate
and tl.brid <>'0001'
) ;
 exception
    when others THEN
    v_type_009cn :=0;
 END ;










for
   rec IN (select mobilesms , custodycd from smsServiceTemplates smst,smsserviceuser smss
    where smst.codeid = smss.codeid  and smss.codeid ='4'
          )
loop

  l_datasource:= 'select  '''|| rec.custodycd ||''' custodycd, ''' || v_type_001 || ''' TYPE001 , ''' || v_type_002 || ''' TYPE002 ,'''
   || v_type_003 || ''' TYPE003 , ''' || v_type_004 || ''' TYPE004 ,''' || v_type_006 || ''' TYPE006 ,''' || v_type_007 || ''' TYPE007 ,'''
   || v_type_009 || ''' TYPE009 ,'''
   || v_type_001cn || ''' TYPE001cn , ''' || v_type_002cn || ''' TYPE002cn ,''' || v_type_003cn || ''' TYPE003cn ,''' || v_type_004cn || ''' TYPE004cn ,'''
   || v_type_006cn || ''' TYPE006cn , ''' || v_type_007cn || ''' TYPE007cn ,''' || v_type_009cn || ''' TYPE009cn , TO_CHAR(SYSDATE,''DD/MM/YYYY'') txdate from  dual';
  InsertEmailLog(rec.mobilesms, '0222', l_datasource, rec.custodycd);
end loop;*/


  plog.setEndSection(pkgctx, 'GenTemplate0551');
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setEndSection(pkgctx, 'GenTemplate0551');
 end;

  procedure GenNotifyEvent(p_message_type varchar2, p_key_value varchar2) is
  begin
    plog.setBeginSection(pkgctx, 'GenNotifyEvent');

    insert into log_notify_event
      (AUTOID,
       MSGTYPE,
       KEYVALUE,
       STATUS,
       LOGTIME,
       APPLYTIME,
       COMMANDTYPE,
       COMMANDTEXT)
    values
      (seq_log_notify_event.nextval,
       p_message_type,
       p_key_value,
       'A',
       sysdate,
       null,
       'P',
       'GENERATE_TEMPLATES');

    plog.setEndSection(pkgctx, 'GenNotifyEvent');
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setEndSection(pkgctx, 'GenNotifyEvent');
  end;

  procedure GenTemplates(p_message_type varchar2, p_key_value varchar2) is
  begin
    plog.setBeginSection(pkgctx, 'GenTemplates');
    plog.debug(pkgctx,
               '[message_type]: ' || p_message_type || ' - [key_value]: ' ||
               p_key_value);

    if p_message_type = 'CAMAST_A' then
      -- Mau thu thong bao thuc hien quyen mua phat hanh them
      GenTemplate105E(p_key_value);
      GenTemplate112E(p_key_value);
    elsif  p_message_type = 'CAMAST_S' then
      -- Mau thu thong bao thuc hien quyen
      GenTemplate0216(p_key_value);
    elsif p_message_type = 'TRANSACT' then
      GenTemplateTransaction(p_key_value);
    elsif p_message_type = 'SCHD0320' then
      GenTemplate0320(p_key_value);
    elsif substr(p_message_type, 1, 4) = 'SCHD' then
      GenTemplateScheduler(p_key_value);
    elsif substr(p_message_type, 1, 6) = 'CAMAST' then
      if substr(p_message_type, 7, 4)='BATC' then
            GenCallMailRequire(p_key_value);
      else
            sendmailall(p_key_value,substr(p_message_type, 7, 4));
      end if;
    end if;

    plog.setEndSection(pkgctx, 'GenTemplates');
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setEndSection(pkgctx, 'GenTemplates');
  end;

  procedure GenTemplate0215(p_template_id varchar2) is

    --l_next_run_date date;
    l_data_source   varchar2(4000);
    l_template_id   templates.code%type;
    l_afacctno      afmast.acctno%type;
    l_address       varchar2(100);
    l_fullname      cfmast.fullname%type;
    l_custody_code  cfmast.custodycd%type;

    type scheduler_cursor is ref cursor;

    type scheduler_record is record(
      template_id templates.code%type,
      afacctno    afmast.acctno%type,
      address     varchar2(100));

    c_scheduler   scheduler_cursor;
    scheduler_row scheduler_record;

    type ty_scheduler is table of scheduler_record index by binary_integer;

    scheduler_list         ty_scheduler;
    l_scheduler_cache_size number(23) := 1000;
    l_row                  pls_integer;
  begin
    plog.setBeginSection(pkgctx, 'GenTemplate0215');

    open c_scheduler for
      select t.code,
             mst.acctno,
             decode(t.type, 'E', cf.email, 'S', cf.mobilesms) address
        from templates t,
             --aftemplates a,
             afmast mst,
             vw_cfmast_sms cf,
             (select afacctno
                from odmast
               where txdate =
                     to_date(cspks_system.fn_get_sysvar('SYSTEM', 'PREVDATE'),
                             'DD/MM/RRRR')
                 and deltd <> 'Y'
                 and execqtty > 0
               group by afacctno) od
       where mst.acctno = od.afacctno and mst.custid = cf.custid
         and t.isactive = 'Y'
         and t.code = p_template_id;

    loop
      fetch c_scheduler bulk collect
        into scheduler_list limit l_scheduler_cache_size;

      plog.DEBUG(pkgctx, 'CNT: ' || scheduler_list.COUNT);

      exit when scheduler_list.COUNT = 0;
      l_row := scheduler_list.FIRST;

      while (l_row is not null)

       loop
        scheduler_row := scheduler_list(l_row);
        l_template_id := scheduler_row.template_id;
        l_afacctno    := scheduler_row.afacctno;
        l_address     := scheduler_row.address;

        begin
          select a.custodycd, a.fullname
            into l_custody_code, l_fullname
            from cfmast a, afmast b
           where a.custid = b.custid
             and b.acctno = l_afacctno;
        exception
          when NO_DATA_FOUND then
            plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
            l_custody_code := 'No Data Found';
            l_fullname     := 'No Data Found';
        end;

        l_data_source := 'select ''' || l_custody_code ||
                         ''' custodycode, ''' || l_fullname ||
                         ''' fullname, ''' || l_afacctno ||
                         ''' account, ''' ||
                         fn_get_sysvar_for_report('SYSTEM', 'PREVDATE') ||
                         ''' daily from dual;';

        InsertEmailLog(l_address, l_template_id, l_data_source, l_afacctno);

        l_row := scheduler_list.NEXT(l_row);
      end loop;
    end loop;

    insert into templates_scheduler_log
      (template_id, log_date)
    values
      (p_template_id, getcurrdate);

    update templates_scheduler
       set last_start_date = getcurrdate,
           next_run_date   = fn_GetNextRunDate(getcurrdate, repeat_interval)
     where template_id = p_template_id;

    plog.setEndSection(pkgctx, 'GenTemplate0215');
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setEndSection(pkgctx, 'GenTemplate0215');
  end;

  -- Mau thu thong bao thuc hien quyen
  procedure GenTemplate0216(p_ca_id varchar2) is
    l_custodycd  cfmast.custodycd%type;
    l_fullname   cfmast.fullname%type;
    l_email      cfmast.email%type;
    l_mobilesms      cfmast.mobilesms%type;
    l_templateid varchar2(6);
    l_templateidSMS varchar2(6);
    l_datasource varchar2(2000);
    l_datasourceSMS varchar2(2000);
    l_symbol     sbsecurities.symbol%type;
    l_tocodeid   camast.tocodeid%type;
    l_to_symbol  sbsecurities.symbol%type;

    l_catype camast.catype%type;

    l_report_date     date;
    --l_trade_date      date ;
    l_begin_date      date;
    l_due_date        date ;
    l_frdate_transfer varchar2(10);
    l_todate_transfer varchar2(10);

    l_rate            varchar2(10);
    l_smsrate            varchar2(15);
    l_devident_shares varchar2(10);
    l_devident_value  varchar2(10);
    l_exrate          varchar2(10);
    l_gia            varchar2(10);

    l_right_off_rate varchar2(10);
    l_devident_rate  varchar2(10);
    l_interest_rate  varchar2(10);
    l_trade_place    varchar2(10);
    l_to_floor_code  varchar2(10);
    l_fr_floor_code  varchar2(10);
    l_fr_trade_place varchar2(10);
    l_to_trade_place varchar2(10);
    l_issuer         varchar2(250);
    l_tradeplace_desc varchar2(250);
    l_inaction_date  date ;
    l_typerate       char(1);
    l_exprice        camast.exprice%type;
    l_advdesc        camast.advdesc%type;
    l_purpose_desc   camast.purposedesc%type;
    l_en_purpose_desc   camast.purposedesc%type;
    l_en_issuer        varchar2(500);
    l_rate_left        varchar2(50);
    l_rate_right        varchar2(40);

    --l_to_codeid       varchar2(10);
    --l_to_symbol       varchar2(10);
    --l_catype_desc     varchar2(100);
    --l_floor_code      varchar2(10);

    type caschd_cursor is ref cursor;

    c_caschd  caschd_cursor;
    caschdrow caschd%rowtype;


    type ty_caschd is table of caschd%rowtype index by binary_integer;

    caschd_list         ty_caschd;
    l_caschd_cache_size number(23) := 1000000;
    l_row               pls_integer;
    V_REALAMT NUMBER;
    v_CompanyPhone varchar2(30);
  begin
    plog.setBeginSection(pkgctx, 'GenTemplate0216');
    l_templateid := '0216';
    l_templateidSMS := 'xxxx';

    select varvalue into v_CompanyPhone from sysvar where grname = 'SYSTEM' and  varname like 'CONTACTPHONE' and rownum<= 1;

    select s.symbol,
           s.tradeplace,
           nvl(i.fullname, i.shortname) issuer,
           nvl(i.en_fullname, i.shortname) issuer,
           ca.catype,
           ca.devidentrate,
           ca.devidentshares,
           ca.rightoffrate,
           ca.reportdate,
           nvl(ca.actiondate, ca.actiondate) actiondate,
           ca.advdesc,
           a.cdcontent,
           a2.cdcontent purposedesc, --ca.purposedesc,
           a2.en_cdcontent en_purposedesc,
           ca.interestrate,
           ca.typerate,
           ca.exrate,
           ca.exprice,
           ca.tocodeid,
           ca.totradeplace,
           ca.begindate,
           ca.duedate,
           ca.frdatetransfer,
           ca.todatetransfer,
           ca.devidentvalue,
           ca.frtradeplace,
           SUBSTR(ca.devidentshares,1,instr(ca.devidentshares,'/')-1) , SUBSTR(ca.devidentshares,instr(ca.devidentshares,'/')+1)
      into l_symbol,
           l_trade_place,
           l_issuer,
           l_en_issuer,
           l_catype,
           l_devident_rate,
           l_devident_shares,
           l_right_off_rate,
           l_report_date,
           l_inaction_date,
           l_advdesc,
           l_tradeplace_desc,
           l_purpose_desc,
           l_en_purpose_desc,
           l_interest_rate,
           l_typerate,
           l_exrate,
           l_exprice,
           l_tocodeid,
           l_to_floor_code,
           l_begin_date,
           l_due_date,
           l_frdate_transfer,
           l_todate_transfer,
           l_devident_value,
           l_fr_floor_code, l_rate_left, l_rate_right
      from camast ca, sbsecurities s, issuers i, allcode a, allcode a2
     where ca.codeid = s.codeid
       and s.issuerid = i.issuerid
       and a.cdval = s.tradeplace
       and a.cdtype = 'SE'
       and a.cdname = 'TRADEPLACE'
       and ca.catype = a2.cdval and a2.cdtype='CA' and a2.cdname='CATYPE'
       and ca.camastid = p_ca_id;
    --
    -- CATYPE : 011, 014
    /*
    001 ?u gi    002 T?m ng?ng giao d?ch
    003 H?y ni?y?t
    004 Mua l?i
    005 Tham d? d?i h?i c? d?    006 L?y ? ki?n c? d?    007 B?c? phi?u qu?
    008 C?p nh?t t.tin
    009 Tr? c? t?c b?ng c? phi?u kh?    010 Chia c? t?c b?ng ti?n
    011 Chia c? t?c b?ng c? phi?u
    012 T? c? phi?u
    013 G?p c? phi?u
    014 Quy?n mua
    015 Tr? l?tr?phi?u
    016 Tr? g?c v??tr?phi?u
    017 Chuy?n d?i tr?phi?u th? c? phi?u
    018 Chuy?n quy?n th? c? phi?u
    019 Chuy?n s?    020 Chuy?n d?i c? phi?u th? c? phi?u
    021 C? phi?u thu?ng
    022 Quy?n b? phi?u
    026 Chuy?n c? phi?u ch? giao d?ch th? giao d?ch
    */

    if l_catype = '005' then
      l_rate       := l_devident_shares;
      l_templateid := '109E';
    elsif l_catype = '006' then
      l_rate       := l_devident_shares;
      l_templateid := '109E';
    elsif l_catype = '010' then
      if l_typerate = 'R' then
        l_rate := l_devident_rate;
        l_gia := l_devident_rate*100;
        l_smsrate := l_rate||'%';
      elsif l_typerate = 'V' then
        l_rate := l_devident_value || ' d/CP';
        l_gia := l_devident_value;
        l_smsrate := l_rate;
      end if;

      l_templateid := '104E';
      l_templateidSMS := '104S';
    elsif l_catype = '011' then
      --l_rate := l_devident_rate||'%';
      --l_rate       := substr(nvl(l_exrate,l_devident_shares),instr(nvl(l_exrate,l_devident_shares),'/')+1)||'%';
      if l_devident_rate <> 0 then
        l_rate := l_devident_rate||'%';
      else
        l_rate := l_devident_shares ;
      end if;
      l_templateid := '110E';
      l_templateidSMS := '110S';
    /*elsif l_catype = '023' then
      l_rate       := l_right_off_rate;
      l_exrate     := l_exrate;
      l_templateid := '112E';*/
    elsif l_catype = '010' then
      l_rate := l_right_off_rate;
    elsif l_catype in ('015', '016') then
      l_rate       := l_interest_rate || '%';
      l_templateid := '111E';
    /*elsif l_catype IN ('017','023') then
      l_rate       := l_exrate;
      l_templateid := '112E';*/

      select symbol
        into l_to_symbol
        from sbsecurities
       where codeid = l_tocodeid;
    elsif l_catype = '019' then
      l_templateid := '113E';
      l_rate       := '0';
      select cdcontent
        into l_to_trade_place
        from allcode
       where cdtype = 'SE'
         and cdname = 'TRADEPLACE'
         and cdval = l_to_floor_code;

      select cdcontent
        into l_fr_trade_place
        from allcode
       where cdtype = 'SE'
         and cdname = 'TRADEPLACE'
         and cdval = l_fr_floor_code;

    elsif l_catype = '020' then --Chia co tuc, co phieu
        GenTemplate112E(p_ca_id); --10/07/2018 DieuNDA: theo yeu cau chi Thuy chuyen sang su dung mau 112E
        return;

      l_rate       := l_devident_shares;
      l_templateid := '112E';

      select symbol
        into l_to_symbol
        from sbsecurities
       where codeid = l_tocodeid;
    elsif l_catype = '021' then
      --l_rate       := substr(nvl(l_exrate,l_devident_shares),instr(nvl(l_exrate,l_devident_shares),'/')+1)||'%';
      --l_rate := l_devident_rate||'%';
      if l_devident_rate <> 0 then
        l_rate := l_devident_rate||'%';
      else
        l_rate := l_exrate ;
      end if;
      l_templateid := '110E';
      l_templateidSMS := '110S';
    elsif l_catype = '022' then
      l_rate       := l_devident_shares;
      l_templateid := '109E';
    end if;

    open c_caschd for
      select * from caschd where camastid = p_ca_id and deltd <> 'Y';


    loop
      fetch c_caschd bulk collect
        into caschd_list limit l_caschd_cache_size;

      plog.DEBUG(pkgctx, 'count ' || caschd_list.COUNT);
      exit when caschd_list.COUNT = 0;
      l_row := caschd_list.FIRST;

      while (l_row is not null)

       loop
        caschdrow := caschd_list(l_row);

        -- Thong tin khach hang
        select c.custodycd, c.email, c.fullname , c.mobilesms
          into l_custodycd, l_email, l_fullname , l_mobilesms
          from vw_cfmast_sms c, afmast a
         where c.custid = a.custid
           and a.acctno = caschdrow.afacctno;

           SELECT  (
            CASE WHEN (CASE WHEN cs.PITRATEMETHOD <> '##' THEN cs.PITRATEMETHOD ELSE ca.PITRATEMETHOD END) = 'SC' OR CF.VAT='N' THEN
                    (
                           CASE WHEN CA.CATYPE IN ('016','023')
                                        THEN ROUND(CS.AMT)
                                        --31/08/2016, SUA LAI LAY THEO TY LE, FIX LOI LAM TRON
                                        WHEN CA.CATYPE = '010'
                                        THEN (CASE WHEN CA.TYPERATE ='R'
                                                       THEN ROUND(CS.BALANCE * SB.PARVALUE * CA.DEVIDENTRATE /100)
                                                    ELSE ROUND(CS.BALANCE * CA.DEVIDENTVALUE)
                                               END)
                                        ELSE ROUND(CS.AMT) END
                       )
                   ELSE (
                        CASE WHEN CA.CATYPE IN ('016','023')
                            THEN ROUND(CS.AMT-ROUND(CS.INTAMT*CA.PITRATE/100))
                            --31/08/2016, SUA LAI LAY THEO TY LE, FIX LOI LAM TRON
                            WHEN CA.CATYPE = '010'
                            THEN (CASE WHEN CA.TYPERATE ='R'
                                           THEN ROUND(CS.BALANCE * SB.PARVALUE * CA.DEVIDENTRATE /100)
                                               - ROUND(CS.BALANCE * SB.PARVALUE * CA.DEVIDENTRATE /100 * CA.PITRATE/100)
                                        ELSE ROUND(CS.BALANCE * CA.DEVIDENTVALUE)
                                               - ROUND(CS.BALANCE * CA.DEVIDENTVALUE * CA.PITRATE/100)
                                   END)
                            ELSE ROUND(CS.AMT-ROUND(CS.AMT*CA.PITRATE/100)) END
                   )
                   END

         )  REALAMT INTO V_REALAMT
         from camast ca, caschd cs, sbsecurities sb, cfmast cf, afmast af
         where ca.camastid = cs.camastid
            and ca.codeid = sb.codeid
            and cs.afacctno = af.acctno
            and cf.custid = af.custid
            and cs.deltd <> 'Y'
            and ca.camastid = p_ca_id
            AND cs.afacctno = caschdrow.afacctno
            AND ROWNUM <= 1;

        if  /*CheckEmail(l_email) and*/ length(l_rate) > 0 then

          l_datasource := 'select ''' || l_fullname || ''' fullname, ''' ||
                          l_custodycd || ''' custodycode, ''' ||
                          caschdrow.afacctno || ''' account, ''' ||
                          l_symbol || ''' symbol, ''' || l_issuer ||
                          ''' issuer, ''' || l_en_issuer || ''' en_issuer, ''' ||
                          to_char(l_tradeplace_desc) ||
                          ''' tradeplace, ''' || ltrim(to_char(caschdrow.trade, '9,999,999,999')) ||
                          ''' trade, ''' ||
                          to_char(l_report_date, 'DD/MM/RRRR') ||
                          ''' reportdate, ''' || l_advdesc ||
                          ''' advdesc, ''' || l_rate || ''' rate, ''' ||
                          to_char(l_inaction_date, 'DD/MM/RRRR') || ''' inactiondate, ''' ||
                          l_purpose_desc || ''' purpose, ''' ||l_en_purpose_desc || ''' en_purpose, ''' || l_exrate ||
                          ''' exrate, ''' || l_to_symbol ||
                          ''' tosymbol, ''' ||
                           to_char(l_begin_date, 'DD/MM/RRRR') ||
                          ''' begindate, ''' ||
                          to_char(l_due_date, 'DD/MM/RRRR') ||
                          ''' duedate, ''' ||
                          to_char(l_frdate_transfer, 'DD/MM/RRRR') ||
                          ''' frdatetransfer, ''' ||
                          to_char(l_todate_transfer, 'DD/MM/RRRR') ||
                          ''' todatetransfer, ''' ||
                          ltrim(to_char(l_exprice, '9,999,999,999')) ||
                          ''' exprice, ''' || caschdrow.pqtty ||
                          ''' pqtty, ''' ||
                           ltrim(to_char(l_gia, '9,999,999,999')) ||
                           ''' gia, ''' ||
                           l_rate_left ||
                           ''' rate_left, ''' ||
                           l_rate_right ||
                           ''' rate_right, ''' ||
                          l_to_trade_place ||
                          ''' totradeplace, ''' || l_fr_trade_place ||
                          ''' frtradeplace from dual';

          plog.debug(pkgctx, 'EMAIL DATA: ' || l_datasource);

          /*          insert into emaillog
            (autoid, email, templateid, datasource, status, createtime)
          values
            (seq_emaillog.nextval,
             l_email,
             l_templateid,
             l_datasource,
             'A',
             sysdate);*/
          InsertEmailLog(l_email,
                         l_templateid,
                         l_datasource,
                         caschdrow.afacctno);

          if l_templateidSMS = '104S' then
                l_datasourceSMS := 'PHS TB: TK '||l_custodycd||' huong quyen co tuc tien ma '||l_symbol||'. '
                    ||'Ty le '||l_smsrate||'. '
                    ||'So tien duoc nhan la '||ltrim(to_char(round(V_REALAMT), '9,999,999,999'))||'VND. '
                    ||'Du kien thanh toan '||to_char(l_inaction_date, 'DD/MM/RRRR')||'. '
                    ||'Chi tiet LH '||v_CompanyPhone||'.';
          ELSIF l_templateidSMS = '110S' and l_catype = '011' then
                l_datasourceSMS := 'PHS TB: TK '||l_custodycd||' huong quyen co tuc co phieu ma '||l_symbol||'. '
                    ||'Ty le '||l_rate||'. '
                    --||'So tien duoc nhan la '||ltrim(to_char(round(caschdrow.amt), '9,999,999,999'))||'VND. '
                    ||'Du kien thanh toan '||to_char(l_inaction_date, 'DD/MM/RRRR')||'. '
                    ||'Chi tiet LH '||v_CompanyPhone||'.';
          ELSIF l_templateidSMS = '110S' and l_catype = '021' then
                l_datasourceSMS := 'PHS TB: TK '||l_custodycd||' huong quyen co phieu thuong ma '||l_symbol||'. '
                    ||'Ty le '||l_rate||'. '
                    --||'So tien duoc nhan la '||ltrim(to_char(round(caschdrow.amt), '9,999,999,999'))||'VND. '
                    ||'Du kien thanh toan '||to_char(l_inaction_date, 'DD/MM/RRRR')||'. '
                    ||'Chi tiet LH '||v_CompanyPhone||'.';
          end if;

          if l_templateidSMS <> 'xxxx' then
            InsertEmailLog(l_mobilesms,
                         l_templateidSMS,
                         l_datasourceSMS,
                         caschdrow.afacctno);
          end if;

        end if;

        l_row := caschd_list.NEXT(l_row);
      end loop;

    end loop;

    plog.setEndSection(pkgctx, 'GenTemplate0216');
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setEndSection(pkgctx, 'GenTemplate0216');
  end;

  -- Mau thu thong bao thuc hien quyen mua phat hanh them
  procedure GenTemplate105E(p_ca_id varchar2) is

    l_custodycd   cfmast.custodycd%type;
    l_fullname    cfmast.fullname%type;
    l_email       cfmast.email%type;
    l_datasource  varchar2(2000);
    l_idcode      cfmast.idcode%type;
    l_iddate      varchar2(10);
    l_phone       cfmast.mobilesms%type;
    l_address     cfmast.address%type;
    l_symbol      sbsecurities.symbol%type;
    l_exprice     camast.exprice%type;
    l_duedate     varchar2(10);
    l_parvalue    sbsecurities.parvalue%type;
    l_issuer_name issuers.fullname%type;
    l_count NUMBER;

    type caschd_cursor is ref cursor;

    c_caschd  caschd_cursor;
    caschdrow caschd%rowtype;

    type ty_caschd is table of caschd%rowtype index by binary_integer;

    caschd_list         ty_caschd;
    l_caschd_cache_size number(23) := 1000000;
    l_row               pls_integer;
    l_catype        camast.catype%type;
  begin
    plog.setBeginSection(pkgctx, 'GenTemplate105E');

    select se.symbol,
           ca.exprice,
           to_char(ca.duedate, 'DD/MM/RRRR'),
           se.parvalue,
           i.fullname, ca.catype
      into l_symbol, l_exprice, l_duedate, l_parvalue, l_issuer_name, l_catype
      from camast ca, sbsecurities se, issuers i
     where ca.camastid = p_ca_id
       and ca.codeid = se.codeid
       and se.issuerid = i.issuerid;
    if l_catype = '014' then

        open c_caschd for
          select * from caschd where camastid = p_ca_id and deltd <> 'Y';

        loop
          fetch c_caschd bulk collect
            into caschd_list limit l_caschd_cache_size;

          plog.DEBUG(pkgctx, 'count ' || caschd_list.COUNT);
          exit when caschd_list.COUNT = 0;
          l_row := caschd_list.FIRST;

          while (l_row is not null)

           loop
            caschdrow := caschd_list(l_row);
            select count(1) INTO l_count
              from vw_cfmast_sms c, afmast a, templates tl --, aftemplates aft
             where c.custid = a.custid
               AND tl.isactive = 'Y'
               AND tl.code = '105E'
               --AND tl.code = aft.template_code
               --AND aft.custid = c.custid
               and a.acctno = caschdrow.afacctno;
            IF l_count > 0 THEN
            -- Thong tin khach hang
                select c.custodycd,
                       c.email,
                       c.fullname,
                       c.idcode,
                       to_char(c.iddate, 'DD/MM/RRRR'),
                       c.mobilesms,
                       c.address
                  into l_custodycd,
                       l_email,
                       l_fullname,
                       l_idcode,
                       l_iddate,
                       l_phone,
                       l_address
                  from vw_cfmast_sms c, afmast a, templates tl --, aftemplates aft
                 where c.custid = a.custid
                   AND tl.isactive = 'Y'
                   AND tl.code = '105E'
                   --AND tl.code = aft.template_code
                   --AND aft.custid = c.custid
                   and a.acctno = caschdrow.afacctno;

            l_datasource := 'select ''' || l_fullname || ''' fullname, ''' ||
                            l_custodycd || ''' custodycode, ''' ||
                            caschdrow.afacctno || ''' account, ''' || p_ca_id ||
                            ''' cacode, ''' || l_symbol || ''' symbol, ''' ||
                            l_fullname || ''' p_custname, ''' || l_idcode ||
                            ''' p_license, ''' || l_iddate || ''' p_iddate, ''' ||
                            l_phone || ''' p_phone, ''' || l_address ||
                            ''' p_address, ''' || l_symbol || ''' p_symbol, ''' ||
                            ltrim(to_char(l_exprice, '9,999,999,999')) ||
                            ''' p_price, ''' || l_duedate || ''' p_duedate, ''' ||
                            ltrim(to_char(caschdrow.trade, '9,999,999,999')) ||
                            ''' p_balance, ''' ||
                            ltrim(to_char(caschdrow.pqtty, '9,999,999,999')) ||
                            ''' p_mqtty, ''' ||
                            ltrim(to_char(l_parvalue, '9,999,999,999')) ||
                            ''' p_parvalue, ''' || l_custodycd ||
                            ''' p_custodycd, ''' || caschdrow.afacctno ||
                            ''' p_afacctno, ''' || l_issuer_name ||
                            ''' p_issname, ''dang ky mua co phieu phat hanh them'' p_desc from dual';

            --

                InsertEmailLog(l_email, '105E', l_datasource, caschdrow.afacctno);
            END IF;
            l_row := caschd_list.NEXT(l_row);
          end loop;

        end loop;
    end if;

    plog.setEndSection(pkgctx, 'GenTemplate105E');
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setEndSection(pkgctx, 'GenTemplate105E');
  end;

 --Gen mau Email SKQ Trai phieu chuyen doi
  procedure GenTemplate112E(p_ca_id varchar2) is

    l_custodycd   cfmast.custodycd%type;
    l_fullname    cfmast.fullname%type;
    l_email       cfmast.email%type;
    l_datasource  varchar2(2000);
    l_idcode      cfmast.idcode%type;
    l_iddate      varchar2(10);
    l_phone       cfmast.mobilesms%type;
    l_address     cfmast.address%type;
    l_symbol      sbsecurities.symbol%type;
    l_exprice     camast.exprice%type;
    l_duedate     varchar2(10);
    l_parvalue    sbsecurities.parvalue%type;
    l_issuer_name issuers.fullname%type;
    l_en_issuer_name issuers.en_fullname%type;
    l_tradeplace  varchar2(60);
    l_count NUMBER;
    l_reportdate date;
    l_exrate VARCHAR2(20);
    l_actiondate date;
    l_purposedesc varchar2(500);
    l_en_purposedesc varchar2(500);
    l_symbol2      sbsecurities.symbol%type;
    l_tradeplace2  varchar2(60);
    l_issuer_name2 issuers.fullname%type;
    l_en_issuer_name2 issuers.en_fullname%type;
    l_devidentshares varchar2(60);
    l_isidcode varchar(100);
    l_event_type varchar(100);

    type caschd_cursor is ref cursor;

    c_caschd  caschd_cursor;
    caschdrow caschd%rowtype;

    type ty_caschd is table of caschd%rowtype index by binary_integer;

    caschd_list         ty_caschd;
    l_caschd_cache_size number(23) := 1000000;
    l_row               pls_integer;
    l_catype            camast.catype%type;
  begin
    plog.setBeginSection(pkgctx, 'GenTemplate112E');

    select se.symbol, catype,
           ca.exprice,
           to_char(ca.duedate, 'DD/MM/RRRR'),
           se.parvalue,
           i.fullname, i.en_fullname, a.cdcontent tradeplace, ca.reportdate, ca.exrate,
           ca.actiondate actiondate, a2.cdcontent purposedesc, a2.en_cdcontent en_purposedesc,
           nvl(se2.symbol,'') symbol2, nvl(se2.tradeplace,'') tradeplace2, nvl(se2.fullname,'') issuer_name2, nvl(se2.en_fullname,'') en_issuer_name2,ca.devidentshares
           ,a4.isincode,a6.en_cdcontent encdcontent    --thangpv SHBVNEX-2672
      into l_symbol, l_catype, l_exprice, l_duedate, l_parvalue, l_issuer_name, l_en_issuer_name, l_tradeplace, l_reportdate, l_exrate, l_actiondate,
        l_purposedesc, l_en_purposedesc, l_symbol2, l_tradeplace2, l_issuer_name2, l_en_issuer_name2, l_devidentshares
        ,l_isidcode, l_event_type
      from camast ca, sbsecurities se, issuers i, allcode a, allcode a2,
        (
             select sb.codeid, sb.symbol, iss.fullname,iss.en_fullname, a0.cdcontent tradeplace
             from sbsecurities sb, issuers iss, allcode a0
             where sb.issuerid=iss.issuerid
                 and a0.cdname='TRADEPLACE' and a0.cdtype='OD' and sb.tradeplace=a0.cdval
         ) se2,
         (
            select sb.codeid, sb.symbol, iss.fullname,iss.en_fullname, a0.cdcontent tradeplace,sb.isincode
            from sbsecurities sb, issuers iss, allcode a0
            where sb.issuerid=iss.issuerid
            and a0.cdname='TRADEPLACE' and a0.cdtype='OD' and sb.tradeplace=a0.cdval
        ) a4,
        (
            select cdval, cdcontent,en_cdcontent from allcode where cdname='CATYPE' and cduser='Y'
        ) a6
     where ca.camastid = p_ca_id
       and ca.codeid = se.codeid
       and a.cdval = se.tradeplace
       and nvl(ca.TOCODEID,' ')=se2.codeid(+)
       and a.cdtype = 'SE'
       and a.cdname = 'TRADEPLACE'
       and a2.cdname = 'CATYPE' and a2.cdtype = 'CA' and a2.cdval=ca.catype
       and se.issuerid = i.issuerid
       and nvl(ca.TOCODEID,' ')=a4.codeid(+)
       and ca.catype =a6.cdval(+);
    if l_catype in ('017','023') then
        open c_caschd for
          select * from caschd where camastid = p_ca_id and deltd <> 'Y';

        loop
          fetch c_caschd bulk collect
            into caschd_list limit l_caschd_cache_size;

          --plog.DEBUG(pkgctx, 'count ' || caschd_list.COUNT);
          exit when caschd_list.COUNT = 0;
          l_row := caschd_list.FIRST;

          while (l_row is not null)

           loop
            caschdrow := caschd_list(l_row);
            select count(1) INTO l_count
              from vw_cfmast_sms c, afmast a, templates tl --, aftemplates aft
             where c.custid = a.custid
               AND tl.isactive = 'Y'
               AND tl.code = '112E'
               --AND tl.code = aft.template_code
               --AND aft.custid = c.custid
               and a.acctno = caschdrow.afacctno;
            IF l_count > 0 THEN
            -- Thong tin khach hang
                select c.custodycd,
                       c.email,
                       c.fullname,
                       c.idcode,
                       to_char(c.iddate, 'DD/MM/RRRR'),
                       c.mobilesms,
                       c.address
                  into l_custodycd,
                       l_email,
                       l_fullname,
                       l_idcode,
                       l_iddate,
                       l_phone,
                       l_address
                  from vw_cfmast_sms c, afmast a, templates tl --, aftemplates aft
                 where c.custid = a.custid
                   AND tl.isactive = 'Y'
                   AND tl.code = '112E'
                   --AND tl.code = aft.template_code
                   --AND aft.custid = c.custid
                   and a.acctno = caschdrow.afacctno;

            l_datasource :=  'select ''' || l_fullname || ''' fullname, ''' ||
                              l_custodycd || ''' custodycode, ''' ||
                              caschdrow.afacctno || ''' account, ''' ||
                              l_symbol || ''' symbol, ''' || l_issuer_name ||
                              ''' issuer, '''|| l_en_issuer_name || ''' en_issuer, ''' ||
                              l_tradeplace || ''' tradeplace, ''' ||l_tradeplace2 || ''' tradeplace2, ''' || caschdrow.trade ||
                              ''' trade, ''' ||
                              to_char(l_reportdate, 'DD/MM/RRRR') ||
                              ''' reportdate, '''|| l_exrate || ''' rate, ''' ||
                              to_char(l_actiondate, 'DD/MM/RRRR') || ''' inactiondate, ''' ||
                              l_purposedesc || ''' purpose, ''' || l_en_purposedesc || ''' en_purpose, ''' ||
                              l_duedate ||
                              ''' duedate,'''||l_event_type||''' p_event_type,'''||l_isidcode||''' p_isincode  from dual';



                InsertEmailLog(l_email, '112E', l_datasource, caschdrow.afacctno);
            END IF;
            l_row := caschd_list.NEXT(l_row);
          end loop;
        end loop;

    elsif l_catype = '020' then
            open c_caschd for
          select * from caschd where camastid = p_ca_id and deltd <> 'Y';

        loop
          fetch c_caschd bulk collect
            into caschd_list limit l_caschd_cache_size;

          --plog.DEBUG(pkgctx, 'count ' || caschd_list.COUNT);
          exit when caschd_list.COUNT = 0;
          l_row := caschd_list.FIRST;

          while (l_row is not null)

           loop
            caschdrow := caschd_list(l_row);
            select count(1) INTO l_count
              from vw_cfmast_sms c, afmast a, templates tl --, aftemplates aft
             where c.custid = a.custid
               AND tl.isactive = 'Y'
               AND tl.code = '119E'
               --AND tl.code = aft.template_code
               --AND aft.custid = c.custid
               and a.acctno = caschdrow.afacctno;
            IF l_count > 0 THEN
            -- Thong tin khach hang
                select c.custodycd,
                       c.email,
                       c.fullname,
                       c.idcode,
                       to_char(c.iddate, 'DD/MM/RRRR'),
                       c.mobilesms,
                       c.address
                  into l_custodycd,
                       l_email,
                       l_fullname,
                       l_idcode,
                       l_iddate,
                       l_phone,
                       l_address
                  from vw_cfmast_sms c, afmast a, templates tl --, aftemplates aft
                 where c.custid = a.custid
                   AND tl.isactive = 'Y'
                   AND tl.code = '119E'
                   --AND tl.code = aft.template_code
                   --AND aft.custid = c.custid
                   and a.acctno = caschdrow.afacctno;


            l_datasource :=  'select ''' || l_fullname || ''' fullname, ''' ||
                              l_custodycd || ''' custodycd, ''' ||
                              caschdrow.afacctno || ''' acctno, ''' ||
                              l_symbol || ''' symbol, ''' ||l_symbol2 || ''' symbol2, ''' || l_issuer_name ||
                              ''' SYMBOLNAME, '''|| l_en_issuer_name || ''' EN_SYMBOLNAME, ''' || l_issuer_name2 ||
                              ''' SYMBOLNAME2, '''|| l_en_issuer_name2 || ''' EN_SYMBOLNAME2, ''' ||
                              l_tradeplace || ''' tradeplace, ''' ||l_tradeplace2 || ''' tradeplace2, ''' || caschdrow.trade ||
                              ''' trade, ''' ||
                              to_char(l_reportdate, 'DD/MM/RRRR') ||
                              ''' reportdate, '''|| l_exrate || ''' EXRATE, ''' || l_devidentshares || ''' devidentshares, ''' ||
                              to_char(l_actiondate, 'DD/MM/RRRR') || ''' ACTIONDATE, ''' ||
                              l_purposedesc || ''' purpose, ''' || l_en_purposedesc || ''' en_purpose, ''' ||
                              l_duedate ||
                              ''' duedate  from dual';



                InsertEmailLog(l_email, '119E', l_datasource, caschdrow.afacctno);
            END IF;
            l_row := caschd_list.NEXT(l_row);
          end loop;
        end loop;
    end if;

    plog.setEndSection(pkgctx, 'GenTemplate112E');
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setEndSection(pkgctx, 'GenTemplate112E');
  end;

  procedure GenTemplate0326(p_template_id varchar2) is

    l_datasource varchar2(4000);

    type ca_cursor is ref cursor;

    type ca_record is record(
      camastid       camast.camastid%type,
      duedate        camast.duedate%type,
      todatetransfer camast.todatetransfer%type,
      exprice        camast.exprice%type,
      symbol         sbsecurities.symbol%type,
      custodycd      cfmast.custodycd%type,
      afacctno       afmast.acctno%type,
      pqtty          caschd.pqtty%type,
      mobile         cfmast.mobilesms%type);

    c_ca   ca_cursor;
    ca_row ca_record;

    type ty_ca is table of ca_record index by binary_integer;

    ca_list         ty_ca;
    l_ca_cache_size number(23) := 1000;
    l_row           pls_integer;

  begin
    plog.setBeginSection(pkgctx, 'GenTemplate0326');

    open c_ca for
      select mst.camastid,
             mst.duedate,
             mst.todatetransfer,
             mst.exprice,
             s.symbol,
             cf.custodycd,
             schd.afacctno,
             schd.pqtty,
             cf.mobilesms mobile
        from camast mst, caschd schd, sbsecurities s, afmast af, vw_cfmast_sms cf
       where mst.camastid = schd.camastid
         and mst.codeid = s.codeid
         and schd.afacctno = af.acctno
         and af.custid = cf.custid
         and schd.pqtty > 0
         and getprevdate(mst.duedate, 3) = getcurrdate
         and mst.catype = '014';

    loop
      fetch c_ca bulk collect
        into ca_list limit l_ca_cache_size;

      plog.DEBUG(pkgctx, 'count ' || ca_list.COUNT);
      exit when ca_list.COUNT = 0;
      l_row := ca_list.FIRST;

      while (l_row is not null)

       loop
        ca_row := ca_list(l_row);

        l_datasource := 'select ''' || ca_row.custodycd ||
                        ''' custodycode, ''' || ca_row.pqtty ||
                        ''' pqtty, ''' || ca_row.symbol || ''' symbol, ''' ||
                        ltrim(to_char( ca_row.exprice, '9,999,999,999'))
                        || ''' exprice, ''' ||
                        to_char(ca_row.todatetransfer, 'DD/MM/RRRR')
                         || ''' todatetransfer, ''' ||
                         to_char(ca_row.duedate, 'DD/MM/RRRR')
                         || ''' duedate from dual';

        plog.debug(pkgctx, 'DATA: ' || l_datasource);

        InsertEmailLog(ca_row.mobile,
                       p_template_id,
                       l_datasource,
                       ca_row.afacctno);

        l_row := ca_list.NEXT(l_row);
      end loop;

    end loop;

    update templates_scheduler
       set last_start_date = getcurrdate,
           next_run_date   = fn_GetNextRunDate(getcurrdate, repeat_interval)
     where template_id = p_template_id;

    plog.setEndSection(pkgctx, 'GenTemplate0326');
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setEndSection(pkgctx, 'GenTemplate0326');
  end;

 /* procedure GenTemplate0323(p_account varchar2) is
    type smsmatched_cursor is ref cursor;

    type smsmatch is record(
      autoid     smsmatched.autoid%type,
      custodycd  smsmatched.custodycd%type,
      orderid    smsmatched.orderid%type,
      txdate     smsmatched.txdate%type,
      matchprice smsmatched.matchprice%type,
      header     smsmatched.header%type,
      detail     varchar2(300),
      footer     varchar2(1000));

    c_smsmatched  smsmatched_cursor;
    smsmatchedrow smsmatch;

    type ty_smsmatched is table of smsmatch index by binary_integer;

    smsmatched_list         ty_smsmatched;
    l_smsmatched_cache_size number(23) := 1000;
    l_row                   pls_integer;

    l_message_template varchar2(240) := cspks_system.fn_get_sysvar('SYSTEM','COMPANYSHORTNAME') || ' thong bao KQKL  ngay [txdate]: TK [custodycode] da dat lenh [detail]';
    l_template_id      char(4) := '0323';
    l_prefix_message   varchar2(160) := '';
    l_message          varchar2(300) := '';
    l_message_temp     varchar2(300) := '';
    l_previous_message varchar2(160) := '';
    l_detail           varchar2(300) := '';
    l_custodycd        varchar2(10) := '';
    l_smsmobile        varchar2(20) := '';
    l_datasource       varchar2(1000) := '';
    l_previous_header  varchar2(20) := '';
    l_header           varchar2(20) := '';
    l_orderid          varchar2(20) := '';
    l_previous_orderid varchar2(20) := '';
    l_footer           varchar2(1000) := '';
    l_previous_footer  varchar2(1000) := '';
    l_autoid           number(20);
    l_status           char(1) := 'L'; -- L: Less than, E: equal, G: greater than
  begin
    plog.setBeginSection(pkgctx, 'GenTemplate0323');

    select c.custodycd, c.mobilesms
      into l_custodycd, l_smsmobile
      from cfmast c, afmast a
     where c.custid = a.custid
       and a.acctno = p_account;

    -- Init prefix message
    l_prefix_message := replace(l_message_template,
                                '[custodycode]',
                                l_custodycd);
    l_prefix_message := replace(l_prefix_message,
                                '[txdate]',
                                to_char(getcurrdate,
                                        systemnums.C_DATE_FORMAT));
    l_prefix_message := replace(l_prefix_message, '[detail]');

    plog.debug(pkgctx, 'SMS prefix: ' || l_prefix_message);

    \*    open c_smsmatched for
    select max(autoid) autoid, custodycd, orderid, txdate, header,
           listagg(detail, ',') within group(order by detail) || ', ' || max(footer) as detail
      from (select a.*, rownum top
               from (select max(autoid) autoid, txdate, custodycd, orderid, header,
                             max(footer) footer,
                             'KL ' || sum(matchqtty) || ' GIA ' || matchprice as detail
                        from smsmatched
                       where status = 'N'
                         and custodycd = l_custodycd
                       group by txdate, custodycd, orderid, header, matchprice
                       order by autoid) a)
     group by custodycd, orderid, txdate, header
     order by autoid;*\

    --l_prefix_message := l_message_template;
    --plog.debug(pkgctx, 'Template: ' || l_message);

    open c_smsmatched for
         --vu sua
       select max(autoid) autoid, custodycd, orderid, txdate, header,
          'KL ' || MAX(ORDERQTTY) || ' gia ' || price as detail,
          listagg(detail, ',') within group(order by detail)  as footer,
          (MAX(ORDERQTTY) - max(TOTALQTTY)) as KLCL
          from (select a.*, rownum top
                   from (select max(autoid) autoid, txdate,
                   custodycd,orderid, header,TOTALQTTY,ORDERQTTY,price,
                  ' KHOP ' || sum(matchqtty) || ' GIA ' || matchprice as detail
                   from smsmatched
                   where status = 'N'
                   and afacctno = p_account
                   group by txdate, custodycd, orderid,
                   header, matchprice ,TOTALQTTY,ORDERQTTY,price
                   order by autoid) a)
      group by custodycd, orderid, txdate, header ,price
      having MAX(ORDERQTTY) = max(TOTALQTTY)
      order by autoid;

      \*select max(autoid) autoid,
             custodycd,
             orderid,
             txdate,
             matchprice,
             header,
             'KL ' || MAX(ORDERQTTY) || ' gia ' || price as detail,
             ' da khop ' || sum(matchqtty)  || ' gia ' || matchprice
             --|| '. Tong khop: ' || max(TOTALQTTY)
             || '. KL con lai: ' || (MAX(ORDERQTTY) - max(TOTALQTTY))
             as footer
        from smsmatched
       where status = 'N'
         and afacctno = p_account
       group by txdate, custodycd, orderid, header, matchprice, price
       order by orderid, autoid;*\

    loop
      fetch c_smsmatched bulk collect
        into smsmatched_list limit l_smsmatched_cache_size;

      plog.DEBUG(pkgctx, 'CNT: ' || smsmatched_list.COUNT);

      exit when smsmatched_list.COUNT = 0;
      l_row := smsmatched_list.FIRST;

      while (l_row is not null)

       loop
        smsmatchedrow := smsmatched_list(l_row);

        plog.DEBUG(pkgctx, 'Round [' || l_row || ']');

        l_detail  := smsmatchedrow.detail;
        l_header  := smsmatchedrow.header;
        l_orderid := smsmatchedrow.orderid;
        l_footer  := smsmatchedrow.footer;
        l_autoid  := smsmatchedrow.autoid;

        plog.debug(pkgctx, 'Previous SMS: ' || l_previous_message);
        if l_previous_message = '' or l_previous_message is null then
          l_message_temp := l_prefix_message || l_header || l_detail;
        else
          l_message_temp := l_previous_message; -- || ',' || l_header || l_detail;
        end if;

        plog.debug(pkgctx, 'orderid: ' || l_orderid);

        if l_previous_orderid <> '' or l_previous_orderid is not null then
          plog.debug(pkgctx, 'prev. orderid: ' || l_previous_orderid);
          if l_orderid = l_previous_orderid then
            l_message      := l_message_temp || ', ' || l_detail || ', ' ||
                              l_footer;
            l_message_temp := l_message_temp || ', ' || l_detail;
          else
            l_message_temp := l_message_temp || ', ' || l_previous_footer;

            if l_previous_header <> l_header then
              l_message_temp := l_message_temp || ', ' || l_header ||
                                l_detail;
            else
              l_message_temp := l_message_temp || ', ' || l_detail;
            end if;

            l_message := l_message_temp || ', ' || l_footer;
          end if;
        else
          l_message := l_message_temp || ', ' || l_footer;
        end if;

        plog.debug(pkgctx, 'Message temp: ' || l_message_temp);
        plog.debug(pkgctx,
                   'SMS message: ' || l_message || ' [' ||
                   length(l_message) || ']');

        if length(l_message) < 160 then
          l_previous_message := l_message_temp;
          l_previous_orderid := l_orderid;
          l_previous_footer  := l_footer;
          l_previous_header  := l_header;
          l_status           := 'L';

        elsif length(l_message) = 160 then

          plog.debug(pkgctx, 'SMS length equal 160');

          l_datasource := 'SELECT ''' || l_custodycd ||
                          ''' custodycode, ''' ||
                          to_char(smsmatchedrow.txdate, 'DD/MM/RRRR') ||
                          ''' txdate, ''' || l_message ||
                          ''' detail FROM DUAL';

          if l_smsmobile is not null and length(l_smsmobile) > 0 then

            InsertEmailLog(l_smsmobile,
                           l_template_id,
                           l_datasource,
                           p_account);

            \*            insert into emaillog
              (autoid, email, templateid, datasource, status, createtime)
            values
              (seq_emaillog.nextval,
               l_smsmobile,
               l_template_id,
               l_datasource,
               'A',
               sysdate);*\
          end if;

          l_previous_message := '';
          l_previous_orderid := '';
          l_previous_footer  := '';
          l_previous_header  := '';
          l_status           := 'E';

        else

          plog.debug(pkgctx, 'SMS length greater than 160');

          l_datasource := 'SELECT ''' || l_custodycd ||
                          ''' custodycode, ''' ||
                          to_char(smsmatchedrow.txdate, 'DD/MM/RRRR') ||
                          ''' txdate, ''' || l_previous_message || ', ' ||
                          l_previous_footer || ''' detail FROM DUAL';

          if l_smsmobile is not null and length(l_smsmobile) > 0 then
            InsertEmailLog(l_smsmobile,
                           l_template_id,
                           l_datasource,
                           p_account);
            \*            insert into emaillog
              (autoid, email, templateid, datasource, status, createtime)
            values
              (seq_emaillog.nextval,
               l_smsmobile,
               l_template_id,
               l_datasource,
               'A',
               sysdate);*\
          end if;

          l_message          := l_prefix_message || l_header || l_detail;
          l_previous_message := l_message;
          l_previous_orderid := l_orderid;
          l_previous_footer  := l_footer;
          l_previous_header  := l_header;
          l_status           := 'G';
          plog.debug(pkgctx, 'NEW SMS: ' || l_message);

        end if;

        if l_row = smsmatched_list.COUNT and l_status <> 'E' then

          if l_status = 'G' then
            l_message := l_message || ', ' || l_footer;
          end if;

          l_datasource := 'SELECT ''' || l_custodycd ||
                          ''' custodycode, ''' ||
                          to_char(smsmatchedrow.txdate, 'DD/MM/RRRR') ||
                          ''' txdate, ''' || l_message || --', ' || l_footer ||
                          ''' detail FROM DUAL';

          if l_smsmobile is not null and length(l_smsmobile) > 0 then

            InsertEmailLog(l_smsmobile,
                           l_template_id,
                           l_datasource,
                           p_account);
            \*            insert into emaillog
              (autoid, email, templateid, datasource, status, createtime)
            values
              (seq_emaillog.nextval,
               l_smsmobile,
               l_template_id,
               l_datasource,
               'A',
               sysdate);*\
          end if;

        end if;

        --Danh dau lenh khop
        plog.debug(pkgctx,
                   'AUTOID: [' || l_autoid || '] - ORDERID: [' || l_orderid ||
                   '] MATCHED PRICE: [' || smsmatchedrow.matchprice || ']');
        update smsmatched
           set status = 'M', sentdate = sysdate
         where orderid = l_orderid
           and matchprice = smsmatchedrow.matchprice
           and autoid <= l_autoid;

        l_row := smsmatched_list.NEXT(l_row);
      end loop;

    end loop;

    update smsmatched
       set status = 'S'
     where afacctno = p_account
       and status = 'M';

    plog.setEndSection(pkgctx, 'GenTemplate0323');
  exception
    when others then
      update smsmatched set status = 'R' where afacctno = p_account;
      plog.error(pkgctx, sqlerrm);
      plog.setEndSection(pkgctx, 'GenTemplate0323');
  end;
*/

--mau sms thong bao quyen mua, trai phieu chuyen doi
  procedure GenTemplate105S(p_ca_id varchar2) is

    l_custodycd   cfmast.custodycd%type;
    l_fullname    cfmast.fullname%type;
    l_mobilesms   varchar2(100);
    l_datasource  varchar2(4000);
    l_idcode      cfmast.idcode%type;
    l_iddate      varchar2(10);
    l_phone       cfmast.mobilesms%type;
    l_address     cfmast.address%type;
    l_symbol      sbsecurities.symbol%type;
    l_exprice     camast.exprice%type;
    l_duedate     varchar2(10);
    l_parvalue    sbsecurities.parvalue%type;
    l_issuer_name issuers.fullname%type;
    l_reportdate                    varchar2(100);
    l_exrate                        varchar2(100);
    l_rightoffrate                  varchar2(100);
    l_todatetransfer                varchar2(100);
    l_frdatetransfer                varchar2(100);
    l_begindate                     varchar2(100);
    l_catype                        varchar2(10);
    l_toSymbol                      varchar2(100);

    type caschd_cursor is ref cursor;

    c_caschd  caschd_cursor;
    caschdrow caschd%rowtype;

    type ty_caschd is table of caschd%rowtype index by binary_integer;

    caschd_list         ty_caschd;
    l_caschd_cache_size number(23) := 1000000;
    l_row               pls_integer;
    l_temp       varchar2(300);
    v_CompanyPhone varchar2(30);
  begin
    plog.setBeginSection(pkgctx, 'GenTemplate105S');
    select varvalue into v_CompanyPhone from sysvar where grname = 'SYSTEM' and  varname like 'CONTACTPHONE' and rownum<= 1;
    begin
    select se.symbol, nvl(se2.symbol,'') toSymbol,
           ca.exprice,
           to_char(ca.duedate, 'DD/MM/RRRR'),
           se.parvalue,
           i.fullname,

           to_char(ca.reportdate, 'DD/MM/RRRR') ,
           ca.exrate ,
           ca.rightoffrate  ,
           to_char(ca.todatetransfer, 'DD/MM/RRRR'),
           to_char(ca.frdatetransfer, 'DD/MM/RRRR'),
           to_char(ca.begindate, 'DD/MM/RRRR'),
           ca.catype
      into l_symbol, l_toSymbol, l_exprice, l_duedate, l_parvalue, l_issuer_name,
      l_reportdate, l_exrate, l_rightoffrate, l_todatetransfer,l_frdatetransfer,l_begindate, l_catype

      from camast ca, sbsecurities se, issuers i, sbsecurities se2
     where ca.camastid = p_ca_id
       and ca.codeid = se.codeid
       and se.issuerid = i.issuerid
       and ca.tocodeid = se2.codeid(+);
     exception
        when others then
        l_symbol:='';l_exprice:=''; l_duedate:=''; l_parvalue:=''; l_issuer_name:='';
      l_reportdate:=''; l_exrate:=''; l_rightoffrate:=''; l_todatetransfer:=''; l_catype:= '';
    end;

FOR  c_caschd  IN (
      select cf.custodycd, max(af.acctno) afacctno from caschd ca, afmast af, cfmast cf
      WHERE ca.afacctno = af.acctno AND af.custid = cf.custid and camastid = p_ca_id AND cf.mobilesms IS NOT NULL
        and ca.deltd <> 'Y'
      GROUP BY cf.custodycd)
loop
       -- Thong tin khach hang
       select c.custodycd,
               c.mobilesms,
               c.fullname,
               c.idcode,
               to_char(c.iddate, 'DD/MM/RRRR'),
               c.mobilesms,
               c.address
          into l_custodycd,
               l_mobilesms,
               l_fullname,
               l_idcode,
               l_iddate,
               l_phone,
               l_address
          from vw_cfmast_sms c
         where c.custodycd = c_caschd.custodycd;

        /*l_temp := '';
        FOR rec IN (SELECT ca.*,decode(UPPER(aftype.mnemonic),'T3','MaginT3','MARGIN','Margin','Thuong') mnemonic FROM caschd  ca,cfmast cf,afmast af,aftype
                    WHERE ca.afacctno = af.acctno AND af.custid = cf.custid
                    AND cf.custodycd = c_caschd.custodycd
                    AND aftype.actype = af.actype and af.isfixaccount ='N'
                 )
        LOOP

       l_temp:= l_temp  ||'TK'|| rec.mnemonic ||' ' || rec.pqtty ||'; ';

        END LOOP;*/

       /*l_datasource :='Select ''BSC thong bao: TK '||l_custodycd||' duoc mua them co phieu ' || l_symbol ||' gia '||l_exprice || '. So luong CP duoc mua: ' || l_temp
                 ||' Ngay chot: '|| l_reportdate||', Ty le: ' ||l_rightoffrate || '. Thoi gian dang ky: Tu '|| l_begindate ||' den ' || l_duedate||', Thoi gian chuyen nhuong tu '||l_frdatetransfer||' den ' ||l_todatetransfer||'.'' detail from dual';
*/
        /*InsertEmailLog(l_mobilesms, '0321', l_datasource, caschdrow.afacctno);*/
        --l_datasource :='PHS tran trong TB: TK '||l_custodycd||' cua quy khach duoc thuc hien quyen mua ' || l_symbol || ', ty le: ' || l_rightoffrate || ', gia '|| l_exprice ||
        -- '. Thoi gian dang ky toi 16h30 ngay ' ||l_todatetransfer|| '. Chi tiet LH PHS (08) 5413 5488';
        if (l_catype IN ('017','023')) then
             l_datasource :='PHS TB: '||l_custodycd||' TH quyen dang ky chuyen doi trai phieu ma '|| l_symbol
                /*|| ' thanh ma '|| l_toSymbol*/||'. '
                ||'Ty le ' || l_exrate || '. Gia '|| ltrim(to_char(l_parvalue, '9,999,999,999')) ||'d. '
                ||'Han dang ky toi 16h30 ngay ' ||l_duedate|| '. '
                ||'LH: '||v_CompanyPhone||'';
             InsertEmailLog(l_mobilesms, '105S', l_datasource, c_caschd.afacctno);

        ELSIF (l_catype IN ('014')) then
            l_datasource :='PHS TB: TK '||l_custodycd||' thuc hien quyen mua ma '|| l_symbol || '. '
                ||'Ty le ' || l_rightoffrate || '. Gia '|| ltrim(to_char(l_exprice, '9,999,999,999')) ||'VND. '
                ||'Han dang ky toi 16h30 ngay ' ||l_duedate|| '. '
                ||'Chi tiet LH: '||v_CompanyPhone||'';
            InsertEmailLog(l_mobilesms, '105S', l_datasource, c_caschd.afacctno);

        end if;


      end loop;



    plog.setEndSection(pkgctx, 'GenTemplate105S');
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setEndSection(pkgctx, 'GenTemplate105S');
  end;

 -- Mau sms thong bao thuc hien quyen
  procedure GenTemplate0320(p_ca_id varchar2) is
    l_custodycd  cfmast.custodycd%type;
    l_fullname   cfmast.fullname%type;
    l_mobilesms   varchar2(100);
    l_templateid varchar2(6);
    l_datasource varchar2(2000);
    l_symbol     sbsecurities.symbol%type;
    l_tocodeid   camast.tocodeid%type;
    l_to_symbol  sbsecurities.symbol%type;

    l_catype camast.catype%type;

    l_report_date     date;
    --l_trade_date      date ;
    l_begin_date      date;
    l_due_date        date ;
    l_frdate_transfer varchar2(10);
    l_todate_transfer varchar2(10);

    l_rate            varchar2(10);
    l_devident_shares varchar2(10);
    l_devident_value  varchar2(10);
    l_exrate          varchar2(10);
    l_gia             varchar2(10);
    l_right_off_rate varchar2(10);
    l_devident_rate  varchar2(10);
    l_interest_rate  varchar2(10);
    l_trade_place    varchar2(10);
    l_to_floor_code  varchar2(10);
    l_fr_floor_code  varchar2(10);
    l_fr_trade_place varchar2(10);
    l_to_trade_place varchar2(10);
    l_issuer         varchar2(250);
    l_tradeplace_desc varchar2(250);
    l_inaction_date  date ;
    l_typerate       char(1);
    l_exprice        camast.exprice%type;
    l_advdesc        camast.advdesc%type;
    l_purpose_desc   camast.purposedesc%type;

    --l_to_codeid       varchar2(10);
    --l_to_symbol       varchar2(10);
    --l_catype_desc     varchar2(100);
    --l_floor_code      varchar2(10);

    type caschd_cursor is ref cursor;

    c_caschd  caschd_cursor;
    caschdrow caschd%rowtype;

    type ty_caschd is table of caschd%rowtype index by binary_integer;

    caschd_list         ty_caschd;
    l_caschd_cache_size number(23) := 1000000;
    l_row               pls_integer;
  begin
    plog.setBeginSection(pkgctx, 'GenTemplate0320');
    l_templateid := '320A';

    select s.symbol,
           s.tradeplace,
           nvl(i.fullname, i.shortname) issuer,
           ca.catype,
           ca.devidentrate,
           ca.devidentshares,
           ca.rightoffrate,
           ca.reportdate,
           nvl(ca.actiondate, ca.actiondate) actiondate,
           ca.advdesc,
           a.cdcontent,
           ca.purposedesc,
           ca.interestrate,
           ca.typerate,
           ca.exrate,
           ca.exprice,
           ca.tocodeid,
           ca.totradeplace,
           ca.begindate,
           ca.duedate,
           ca.frdatetransfer,
           ca.todatetransfer,
           ca.devidentvalue,
           ca.frtradeplace
      into l_symbol,
           l_trade_place,
           l_issuer,
           l_catype,
           l_devident_rate,
           l_devident_shares,
           l_right_off_rate,
           l_report_date,
           l_inaction_date,
           l_advdesc,
           l_tradeplace_desc,
           l_purpose_desc,
           l_interest_rate,
           l_typerate,
           l_exrate,
           l_exprice,
           l_tocodeid,
           l_to_floor_code,
           l_begin_date,
           l_due_date,
           l_frdate_transfer,
           l_todate_transfer,
           l_devident_value,
           l_fr_floor_code
      from camast ca, sbsecurities s, issuers i, allcode a
     where ca.codeid = s.codeid
       and s.issuerid = i.issuerid
       and a.cdval = s.tradeplace
       and a.cdtype = 'SE'
       and a.cdname = 'TRADEPLACE'
       and ca.camastid = p_ca_id;


    if l_catype = '010' then
      if l_typerate = 'R' then
        l_rate := l_devident_rate || '%';
        l_gia := l_devident_rate * 100;
      elsif l_typerate = 'V' then
        l_rate := l_devident_value || ' d/CP';
      end if;

      l_templateid := '320A';

    elsif l_catype = '011' then
      l_rate       := l_devident_shares;
      l_templateid := '320B';

    begin
      select symbol
        into l_to_symbol
        from sbsecurities
        where codeid = l_tocodeid;

         exception
        when others then
        l_to_symbol:='';
    end;

    elsif l_catype = '021' then
      l_rate       := l_exrate;
      l_templateid := '320B';

    end if;

    open c_caschd for
      select * from caschd where camastid = p_ca_id;

    loop
      fetch c_caschd bulk collect
        into caschd_list limit l_caschd_cache_size;

      plog.DEBUG(pkgctx, 'count ' || caschd_list.COUNT);
      exit when caschd_list.COUNT = 0;
      l_row := caschd_list.FIRST;

      while (l_row is not null)

       loop
        caschdrow := caschd_list(l_row);

        -- Thong tin khach hang
        select c.custodycd, c.mobilesms, c.fullname
          into l_custodycd, l_mobilesms, l_fullname
          from cfmast c, afmast a
         where c.custid = a.custid
           and a.acctno = caschdrow.afacctno;

        if length(l_rate) > 0 then

         l_datasource := 'select ''' || l_fullname || ''' fullname, ''' ||
                          l_custodycd || ''' custodycode, ''' ||
                          caschdrow.afacctno || ''' account, ''' ||
                          l_symbol || ''' symbol, ''' || l_issuer ||
                          ''' issuer, ''' ||
                          to_char(l_tradeplace_desc) ||
                          ''' tradeplace, ''' || caschdrow.trade ||
                          ''' trade, ''' ||
                          to_char(l_report_date, 'DD/MM/RRRR') ||
                          ''' reportdate, ''' || l_advdesc ||
                          ''' advdesc, ''' || l_rate || ''' rate, ''' ||
                          to_char(l_inaction_date, 'DD/MM/RRRR') || ''' inactiondate, ''' ||
                          l_purpose_desc || ''' purpose, ''' || l_exrate ||
                          ''' exrate, ''' || l_to_symbol ||
                          ''' tosymbol, ''' ||
                           to_char(l_begin_date, 'DD/MM/RRRR') ||
                          ''' begindate, ''' ||
                          to_char(l_due_date, 'DD/MM/RRRR') ||
                          ''' duedate, ''' ||
                          to_char(l_frdate_transfer, 'DD/MM/RRRR') ||
                          ''' frdatetransfer, ''' ||
                          to_char(l_todate_transfer, 'DD/MM/RRRR') ||
                          ''' todatetransfer, ''' ||
                          ltrim(to_char(l_exprice, '9,999,999,999')) ||
                          ''' exprice, ''' || caschdrow.pqtty ||
                          ''' pqtty, ''' ||
                           ltrim(to_char(l_gia, '9,999,999,999')) ||
                           ''' gia, ''' ||
                          l_to_trade_place || ''' totradeplace, ''' || l_fr_trade_place ||
                          ''' frtradeplace from dual';

          /*          insert into emaillog
            (autoid, email, templateid, datasource, status, createtime)
          values
            (seq_emaillog.nextval,
             l_email,
             l_templateid,
             l_datasource,
             'A',
             sysdate);*/
          InsertEmailLog(l_mobilesms,
                         l_templateid,
                         l_datasource,
                         caschdrow.afacctno);

        end if;

        l_row := caschd_list.NEXT(l_row);
      end loop;

    end loop;

    plog.setEndSection(pkgctx, 'GenTemplate0320');
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setEndSection(pkgctx, 'GenTemplate0320');
  end;


  procedure GenTemplateTransaction(p_transaction_number varchar2) is

    type transaction_cursor is ref cursor;

    type transaction_record is record(
      apptype apptx.apptype%type,
      TXTYPE  apptx.txtype%type,
      namt    ddtran.namt%type,
      acctno  ddtran.acctno%type,
      trdesc  ddtran.trdesc%type,
      balance ddmast.balance%type);

    c_transaction   transaction_cursor;
    transaction_row transaction_record;

    type ty_transaction is table of transaction_record index by binary_integer;

    transaction_list         ty_transaction;
    l_transaction_cache_size number(23) := 1000;
    l_row                    pls_integer;

    l_message_type     tltx.msgtype%type;
    l_message_content  allcode.cdcontent%type;
    l_message_account  tllog.msgacct%type;
    l_message_amount   tllog.msgamt%type;
    l_transaction_date tllog.txdate%type;
    l_custody_code     cfmast.custodycd%type;
    l_txtype           apptx.txtype%type;
    l_amount           number(20);
    l_account          varchar2(20);
    l_transaction_desc appmap.trdesc%type;
    l_balance          ddmast.balance%type;
    --l_trade            semast.trade%type;
    l_sms_number cfmast.mobilesms%type;
    l_symbol     sbsecurities.symbol%type;

    l_app_type          char(2);
    l_template_id       char(4);
    l_message_ci_credit char(4) := '300S';
    l_message_ci_dedit  char(4) := '301S';
    l_message_se_credit char(4) := '305S';
    l_message_se_dedit  char(4) := '306S';
    l_datasource        varchar2(1000);
    l_custid            varchar2(20);
    l_currtrade number(20);
    l_transaction_tltxcd tltx.tltxcd%type;

  begin
    plog.setBeginSection(pkgctx, 'GenTemplateTransaction');

    plog.info(pkgctx, 'PROCESS: [TXNUM: ' || p_transaction_number || ']');

    select t.msgtype,
           t.txdesc,--a.cdcontent,
           l.msgamt,
           l.msgacct, /*c.custodycd, */
           l.txdate,
           t.tltxcd --, m.fax1
      into l_message_type,
           l_message_content,
           l_message_amount,
           l_message_account, --l_custody_code,
           l_transaction_date, --, l_sms_number
           l_transaction_tltxcd
      from tllog l, tltx t, allcode a --, afmast m--, cfmast c
     where t.tltxcd = l.tltxcd
       and a.cdtype = 'NM'
       and a.cdname = 'MSGTYPE'
       and a.cdval = t.msgtype --and m.custid = c.custid
          --and substr(l.msgacct,1,10) = m.acctno
       and l.txnum = p_transaction_number;

    plog.info(pkgctx,
              'TYPE: [' || l_message_type || '] CONTENT: [' ||
              l_message_content || '] AMOUNT: [' || l_message_amount ||
              '] ACCOUNT: [' || l_message_account || '] TRANS. DATE [' ||
              to_char(l_transaction_date, 'DD/MM/RRRR') || ']');

    open c_transaction for
      select a.apptype,
             a.txtype,
             t.namt,
             t.acctno acctno,
             case when t.tltxcd in ('2242') then trdesc else l.txdesc end  trdesc,
             m.trade balance
        from setran t,tllog l, semast m, apptx a
       where t.txcd = a.txcd
         and a.apptype = 'SE'
         and a.field = 'TRADE'
         and a.txtype in ('C', 'D')
         and t.namt > 0
         and t.txnum=l.txnum and t.txdate=l.txdate
         and t.acctno = m.acctno
         and t.txdate = l_transaction_date
         and t.txnum = p_transaction_number
      union all
      select a.apptype, a.txtype, t.namt, t.acctno, case when t.tltxcd in ('1120','1130','1133') then trdesc else l.txdesc end trdesc, m.balance
        from ddtran t,tllog l, ddmast m, apptx a
       where t.txcd = a.txcd
         and a.apptype = 'CI'
         and a.field = 'BALANCE'
         and a.txtype in ('C', 'D')
         and t.namt > 0
         and t.txnum=l.txnum and t.txdate=l.txdate
         and t.acctno = m.acctno
         and t.txdate = l_transaction_date
         and t.txnum = p_transaction_number;

    loop
      fetch c_transaction bulk collect
        into transaction_list limit l_transaction_cache_size;

      plog.DEBUG(pkgctx, 'CNT: ' || transaction_list.COUNT);

      exit when transaction_list.COUNT = 0;
      l_row := transaction_list.FIRST;

      while (l_row is not null)

       loop

        transaction_row    := transaction_list(l_row);
        l_app_type         := transaction_row.apptype;
        l_txtype           := transaction_row.TXTYPE;
        l_amount           := transaction_row.namt;
        l_account          := substr(transaction_row.acctno, 1, 10);
        l_transaction_desc := transaction_row.trdesc;
        l_balance          := transaction_row.balance;

        plog.info(pkgctx,
                  'TXTYPE: [' || l_txtype || '] AMT: [' || l_amount ||
                  '] ACCT: [' || l_account || '] TRANS. DESC. [' ||
                  l_transaction_desc || '] BAL. [' || l_balance || ']');

        select c.custodycd, c.mobilesms
          into l_custody_code, l_sms_number
          from afmast a, vw_cfmast_sms c
         where a.custid = c.custid
           and a.acctno = l_account;

        plog.info(pkgctx,
                  'CUSTODY CODE: [' || l_custody_code || '] SMS NO: [' ||
                  l_sms_number || ']');

        IF l_sms_number = '' OR l_sms_number IS NULL THEN
            RETURN;
        END IF;

        if l_transaction_desc <> '' or l_transaction_desc is not null then
          l_message_content := fn_convert_to_vn(l_transaction_desc);
        end if;

        if l_app_type = 'CI' then
          if l_txtype = 'C' then
            l_template_id := l_message_ci_credit;
          else
            l_template_id := l_message_ci_dedit;
          end if;
          IF l_template_id = '300S' THEN
            l_datasource := 'PHS-TB: So du tien TK ' || l_custody_code || ' - ' || l_account || ' hien la ' ||
            ltrim(replace(to_char(l_balance, '9,999,999,999,999'),',','.')) || 'd; phat sinh ' ||
            ltrim(replace(to_char(l_amount, '9,999,999,999,999'),',','.')) || 'd; ND: ' || l_message_content || '.';
          ELSE
            l_datasource := 'PHS-TB: So du tien TK ' || l_custody_code || ' - ' || l_account || ' hien la ' ||
            ltrim(replace(to_char(l_balance, '9,999,999,999,999'),',','.')) || 'd; phat sinh -' ||
            ltrim(replace(to_char(l_amount, '9,999,999,999,999'),',','.')) || 'd; ND: ' || l_message_content || '.';
          END IF;
          /*l_datasource := 'select ''' || l_custody_code || '-' || l_account ||
                          ''' custodycode, ''' || to_char(l_transaction_date, 'DD/MM/RRRR') ||
                          ''' txdate, ''' || l_message_content ||
                          ''' txdesc, ''' ||
                          ltrim(replace(to_char(l_amount,
                                                '9,999,999,999,999'),
                                        ',',
                                        '.')) || ''' amount, ''' ||
                          ltrim(replace(to_char(l_balance,
                                                '9,999,999,999,999'),
                                        ',',
                                        '.')) || ''' balance from dual';*/

        elsif l_app_type = 'SE' then
          if l_txtype = 'C' then
            l_template_id := l_message_se_credit;
          else
            l_template_id := l_message_se_dedit;
          end if;

          plog.info(pkgctx,
                  'SMS TXTYPE: [' || l_txtype || '] AMT: [' || l_amount ||
                  '] ACCT: [' || l_account || '] TRANS. DESC. [' ||
                  l_message_content || '] BAL. [' || l_balance || ']');

          if(l_transaction_tltxcd = '2257')
          then
            select b.symbol, 0
                into l_symbol,l_currtrade
                from sbsecurities b
               where b.codeid = substr(transaction_row.acctno,-6);
          else
              select b.symbol, a.trade
                into l_symbol,l_currtrade
                from semast a, sbsecurities b
               where a.codeid = b.codeid
                 and a.acctno = transaction_row.acctno;
           end if;

          IF l_template_id = '305S' THEN
            l_datasource := 'PHS-TB: TK ' || l_custody_code || ' - ' || l_account || ' ngay ' || to_char(l_transaction_date, 'DD/MM/RRRR') || ' P/S tang '
                            || ltrim(replace(to_char(l_amount,'9,999,999,999,999'),',','.')) || ' ' || l_symbol ||
                            ', so du hien tai ' || ltrim(replace(to_char(l_currtrade, '9,999,999,999,999'),',','.')) || ', ' || l_message_content || '.';
          ELSE
            l_datasource := 'PHS-TB: TK ' || l_custody_code || ' - ' || l_account || ' ngay ' || to_char(l_transaction_date, 'DD/MM/RRRR') || ' P/S giam '
                            || ltrim(replace(to_char(l_amount,'9,999,999,999,999'),',','.')) || ' ' || l_symbol ||
                            ', so du hien tai ' || ltrim(replace(to_char(l_currtrade, '9,999,999,999,999'),',','.')) || ', ' || l_message_content || '.';
          END IF;
          /*l_datasource := 'select ''' || l_custody_code || '-' || l_account ||
                          ''' custodycode, ''' || to_char(l_transaction_date, 'DD/MM/RRRR') ||
                          ''' txdate, ''' || l_message_content ||
                          ''' txdesc, ''' ||
                          ltrim(replace(to_char(l_amount,
                                                '9,999,999,999,999'),
                                        ',',
                                        '.')) || ''' amount, ''' ||
                          ltrim(replace(to_char(l_balance,
                                                '9,999,999,999,999'),
                                        ',',
                                        '.')) || ''' trade, ''' || l_symbol ||
                          ''' symbol from dual';*/
        end if;

        
        begin
            SELECT cf.custid
            INTO l_custid
            FROM templates t, cfmast cf, afmast af
            WHERE  af.custid = cf.custid
                AND af.acctno = l_account
                AND t.code IN l_template_id
                and t.isactive = 'Y';
        exception
            when others then
                l_custid := '';
        end;
        
        IF l_custid <> '' OR l_custid IS NOT null THEN

            if l_template_id <> '' or l_template_id is not null then

              InsertEmailLog(l_sms_number,
                             l_template_id,
                             l_datasource,
                             l_account);
            end if;
        ELSE
            RETURN;
        END IF;

        l_row := transaction_list.NEXT(l_row);
      end loop;
    end loop;

    plog.setEndSection(pkgctx, 'GenTemplateTransaction');
  exception
    when others then
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setEndSection(pkgctx, 'GenTemplateTransaction');
  end;

  procedure GenTemplateScheduler(p_template_id varchar2) is
    --l_next_run_date date;
    l_data_source   varchar2(4000);
    l_template_id   templates.code%type;
    l_afacctno      afmast.acctno%type;
    l_address       varchar2(100);
    l_fullname      cfmast.fullname%type;
    l_custody_code  cfmast.custodycd%type;

    type scheduler_cursor is ref cursor;

    type scheduler_record is record(
      template_id templates.code%type,
      afacctno    afmast.acctno%type,
      address     varchar2(100));

    c_scheduler   scheduler_cursor;
    scheduler_row scheduler_record;

    type ty_scheduler is table of scheduler_record index by binary_integer;

    scheduler_list         ty_scheduler;
    l_scheduler_cache_size number(23) := 1000;
    l_row                  pls_integer;
  begin
    plog.setBeginSection(pkgctx, 'GenTemplateScheduler');

    /*    insert into emaillog
    (autoid, templateid, afacctno, email, status, createtime)*/
    open c_scheduler for
      select t.code,
             mst.acctno afacctno,
             decode(t.type, 'E', cf.email, 'S', cf.mobilesms) address
        from templates t,  afmast mst, vw_cfmast_sms cf
       where  cf.custid = mst.custid
         and decode(t.type, 'E', cf.email, 'S', cf.mobilesms) is not null
         and t.code = p_template_id
         and t.isactive = 'Y';

    loop
      fetch c_scheduler bulk collect
        into scheduler_list limit l_scheduler_cache_size;

      plog.DEBUG(pkgctx, 'CNT: ' || scheduler_list.COUNT);

      exit when scheduler_list.COUNT = 0;
      l_row := scheduler_list.FIRST;

      while (l_row is not null)

       loop
        scheduler_row := scheduler_list(l_row);
        l_template_id := scheduler_row.template_id;
        l_afacctno    := scheduler_row.afacctno;
        l_address     := scheduler_row.address;

        begin
          select a.custodycd, a.fullname
            into l_custody_code, l_fullname
            from vw_cfmast_sms a, afmast b
           where a.custid = b.custid
             and b.acctno = l_afacctno;
        exception
          when NO_DATA_FOUND then
            plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
            l_custody_code := 'No Data Found';
            l_fullname     := 'No Data Found';
        end;

        if p_template_id = '0214' then
          l_data_source := 'select ''' || l_custody_code ||
                           ''' custodycode, ''' || l_fullname ||
                           ''' fullname, ''' || l_afacctno ||
                           ''' account, ''' ||
                           to_char(to_date(fn_get_sysvar_for_report(p_sys_grp  => 'SYSTEM',
                                                                    p_sys_name => 'PREVDATE'),
                                           'DD/MM/RRRR'),
                                   'MM/RRRR') || ''' monthly from dual;';
        elsif p_template_id = '0215' then
          l_data_source := 'select ''' || l_custody_code ||
                           ''' custodycode, ''' || l_fullname ||
                           ''' fullname, ''' || l_afacctno ||
                           ''' account, ''' ||
                           fn_get_sysvar_for_report('SYSTEM', 'PREVDATE') ||
                           ''' daily from dual;';
        else

          l_data_source := 'select ''' || l_custody_code ||
                           ''' custodycode, ''' || l_fullname ||
                           ''' fullname, ''' || l_afacctno ||
                           ''' account from dual;';

        end if;

        InsertEmailLog(l_address, l_template_id, l_data_source, l_afacctno);

        l_row := scheduler_list.NEXT(l_row);
      end loop;
    end loop;

    insert into templates_scheduler_log
      (template_id, log_date)
    values
      (p_template_id, getcurrdate);

    update templates_scheduler
       set last_start_date = getcurrdate,
           next_run_date   = fn_GetNextRunDate(getcurrdate, repeat_interval)
     where template_id = p_template_id;

    plog.setEndSection(pkgctx, 'GenTemplateScheduler');
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setEndSection(pkgctx, 'GenTemplateScheduler');
  end;

  procedure GenCallMailRequire (p_template_id varchar2) is
    l_data_source  varchar2(2000);
    v_prevdate5 date;
    v_currdate date;
    v_prevdate2 date;
    v_count number;
    v_datemail varchar(20);
    v_camastid varchar2(30);
    begin
  /*======================================================*/
  --creater------------lasttime-----------desc-------------
  --thunt              09/04/2020         sendmail chaser
  /*======================================================*/
    plog.setBeginSection(pkgctx, 'GenCallMailRequire');
    v_currdate := getcurrdate();
    v_prevdate5 := getnextbusinessdate(v_currdate,5);
    v_prevdate2 := getnextbusinessdate(v_currdate,2);

    select max(ca.STATUS),trim(ca.camastid) into v_count,v_camastid from (
    select ca.camastid, ca.codeid,
         (case when ca.catype in ('005','028') and ( v_prevdate5=to_date(ca.INSTRUCTION,'DD/MM/RRRR')  or v_prevdate2=to_date(ca.INSTRUCTION,'DD/MM/RRRR') ) then 1
        when ca.catype in ('006') and ( v_prevdate5=to_date(ca.INSTRUCTION,'DD/MM/RRRR')  or v_prevdate2=to_date(ca.INSTRUCTION,'DD/MM/RRRR') ) then 1
        when ca.catype in ('014') and (v_prevdate5=ca.INSDEADLINE or v_prevdate2=ca.INSDEADLINE) then 1
        when ca.catype in ('023') and ( v_prevdate5=ca.INSDEADLINE or v_prevdate2=ca.INSDEADLINE) then 1
        else 0 end )  STATUS, ca.catype
        from camast ca, caschd cas
        where ca.catype in ('005','028','022','006','014','023')
        and ca.camastid=cas.camastid
        and ca.camastid=p_template_id
    )ca where ca.STATUS <> 0 group by ca.camastid;

   if v_count = 1 and v_camastid=p_template_id then
        begin
            sendmailall(v_camastid,'BATC');
        end;
   end if;
    plog.setEndSection(pkgctx, 'GenCallMailRequire');
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setEndSection(pkgctx, 'GenCallMailRequire');
  end;
  procedure CheckEarlyDay is
    l_data_source  varchar2(2000);
    p_count varchar2(5);
    p_hour varchar2(5);
    p_hoursend varchar2(10);
    begin
    plog.setBeginSection(pkgctx, 'CheckEarlyDay');

    select TO_CHAR(SYSDATE,'hh.AM') into p_hour from dual;
    begin
    select hours into p_hoursend from smsServiceTemplates where codeid='1';
    exception
    when others then
       p_hoursend:= '';
    end ;
    --if  p_hour = '08.AM' then
    if  p_hour = p_hoursend then
            begin
                 SELECT COUNT(acctno) into p_count  from sedeposit
                 where (SELECT TO_DATE(VARVALUE,'DD/MM/YYYY') CURRDATE
                 FROM SYSVAR WHERE GRNAME = 'SYSTEM' AND VARNAME ='CURRDATE') - TXDATE >= 3
                 and STATUS not in ('C');
                 exception
            when others then
                 p_count:=0;
            end ;

       for rec in (
        --select EmailSms,templateid from fixtemp where status ='LK'
        select st.templates, su.mobilesms
        from smsServiceUser su, smsServiceTemplates st
        where st.codeid = su.codeid
        and st.codeid = '1'
        )
        loop
        l_data_source := 'select ''' || p_count ||
                           ''' count from dual;';

        InsertEmailLog(rec.mobilesms, rec.templates , l_data_source, '');

        /*insert into emaillog
          (autoid, email, templateid, datasource, status, createtime, note)
         values
          (seq_emaillog.nextval,
           v_mobile,
           '0340',
           l_data_source,
           'A',
           sysdate,
           '---');*/

        end loop;

    end if;
    plog.setEndSection(pkgctx, 'CheckEarlyDay');
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setEndSection(pkgctx, 'CheckEarlyDay');
  end;

  procedure CheckSystem is
    l_data_source  varchar2(2000);
    p_hour varchar2(100);
    p_sysdate varchar2(100);
    p_daydate varchar2(100);
    p_status varchar2(100);
    p_hoursend varchar2(10);

    begin
    plog.setBeginSection(pkgctx, 'CheckSystem');

    select TO_CHAR(SYSDATE,'hh.AM') into p_hour from dual;
    select TO_CHAR(SYSDATE,'DD/MM/YYYY') into p_daydate from dual;
    SELECT VARVALUE into p_sysdate FROM SYSVAR WHERE GRNAME = 'SYSTEM' AND VARNAME ='CURRDATE';
    begin
    SELECT STATUS into p_status FROM brgrp where brid='0001';
    exception
    when others then
       p_status:= '';
    end ;
    if p_status = 'A' then
        p_status := 'MO';
    else
        p_status := 'DONG';
    end if;
    begin
    select hours into p_hoursend from smsServiceTemplates where codeid='2';
    exception
    when others then
       p_hoursend:= '';
    end ;
    --if p_hour = '10.PM' then
    if p_hour = p_hoursend then
      for rec in (
          --select EmailSms,templateid from fixtemp where status ='IT'
          select st.templates, su.mobilesms
          from smsServiceUser su, smsServiceTemplates st
          where st.codeid = su.codeid
          and st.codeid = '2'
          )
          loop
          l_data_source := 'select ''' || p_daydate ||
           ''' presentdate,''' || p_sysdate ||
           ''' systemdate,''' || p_status ||
           ''' status from dual;';

          InsertEmailLog(rec.mobilesms, rec.templates , l_data_source, '');

          end loop;
    end if;

    exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setEndSection(pkgctx, 'CheckSystem');
  end;

  ------------VU THEM
  procedure CheckKhopLenh is
    l_data_source varchar2(2000);
    l_mobile varchar2(20);
  begin
    for rec in (
       /*select max(autoid) autoid, custodycd, orderid, txdate, header,ltrim(MAX(ORDERQTTY)) as slck,mck,
   (MAX(ORDERQTTY) - max(TOTALQTTY)) as KLCL ,
    'gia ' || price as detaildl,
    listagg(detail, ', ') within group(order by detail)  as detail
        from (select a.*, rownum top
             from (select max(autoid) autoid, txdate,
             custodycd, orderid, lower(substr(header,1,3)) header, ltrim(substr(header,4)) mck,max(TOTALQTTY) TOTALQTTY,ORDERQTTY,price,
             sum(matchqtty) || ' gia ' || matchprice as detail
             from smsmatched
             where status = 'N'
             group by txdate, custodycd, orderid,
             header, matchprice ,ORDERQTTY,price
             order by autoid) a)
        group by custodycd, orderid, txdate, header ,price, MCK
        order by autoid
      )
   loop
     if rec.KLCL = 0 then
        select mobilesms into l_mobile
        from vw_cfmast_sms where custodycd=rec.custodycd;

        l_data_source := 'select ''' ||
           rec.custodycd ||''' custodycd,''' ||
           to_char(rec.txdate,'DD/MM/YYYY') ||''' txdate,''' ||
           rec.header || ''' header,''' ||
           rec.SLCK || ''' slck,''' ||
           rec.mck || ''' mck,''' ||
           rec.detaildl || ''' detaildl,''' ||
           rec.detail || ''' detail from dual;';
        InsertEmailLog(l_mobile, '0337', l_data_source, '');*/

        /*SELECT   a.*, ROWNUM top
        FROM   (  SELECT   sms.txdate,
                          sms.detail norp,
                          sms.custodycd,
                          sms.orderid,
                          LOWER (SUBSTR (sms.header, 1, 3)) header,
                          LTRIM (SUBSTR (sms.header, 4)) mck,
                          SUM (sms.matchqtty) || ' gia ' || sms.matchprice
                              AS detail
                   FROM   smsmatchedm sms, odmast od
                  WHERE   sms.status = 'N' AND od.orderid = sms.orderid
               GROUP BY   sms.txdate,
                          sms.detail,
                          sms.custodycd,
                          sms.orderid,
                          sms.header,
                          sms.matchprice
               ORDER BY   sms.custodycd, sms.orderid) a*/
        select a.*, rownum top
             from (select sms.txdate, od.txtime,
             sms.custodycd, od.orderid, substr(sms.header,1,3) l_bors, ltrim(substr(sms.header,4)) symbol, max(od.afacctno) afacctno, --sms.price,
             sum(sms.matchqtty) matchqtty, sms.matchprice matchprice, sms.price, sms.orderqtty
             from smsmatched sms, odmast od
             where sms.status = 'N'
             AND od.orderid = sms.orderid
             group by sms.txdate, od.txtime, sms.custodycd, od.orderid, sms.orderqtty,
             sms.header, sms.matchprice, sms.price, sms.orderqtty
             order by sms.custodycd, od.orderid) a
      )
   loop
     --if rec.KLCL = 0 then

        select case when
             LENGTH(cf.mobilesms)>=10 and substr(cf.mobilesms,1,2) in ('09','08') then REGEXP_REPLACE(substr(regexp_replace(cf.mobilesms, '[^[:digit:]]', ''),1,10), '[^[:digit:]]', '' )
              else (case when LENGTH(cf.mobilesms)>=10 and substr(cf.mobilesms,1,2) in ('01') then REGEXP_REPLACE(substr(regexp_replace(cf.mobilesms, '[^[:digit:]]', ''),1,11), '[^[:digit:]]', '' )
              WHEN LENGTH(cf.mobilesms)>=10 and substr(cf.mobilesms,1,2) in ('84') THEN '0' || REGEXP_REPLACE(substr(regexp_replace(cf.mobilesms, '[^[:digit:]]', ''),3,length(cf.mobilesms)), '[^[:digit:]]', '' )
               else '' end ) end mobilesms  into l_mobile
        from cfmast cf
         where custodycd=rec.custodycd;


    --IF rec.norp = 'P' THEN
        --l_data_source := 'SBS: ['|| rec.custodycd ||'] ['|| rec.mck ||'] Khop TT '|| UPPER(rec.header) ||' '||rec.detail;
   -- ELSE
     --   l_data_source := 'SBS: ['|| rec.custodycd ||'] ['|| rec.mck ||'] Khop '|| UPPER(rec.header) ||' '||rec.detail;
   -- END IF;
       -- 
        --prc_sbs_sendsms(l_mobile,l_data_source);

        l_data_source := 'PHS-KQKL ' || to_char(rec.txdate,'DD/MM/YYYY') || '-' || rec.txtime || '. TK ' || rec.custodycd || ' ' ||
        rec.l_bors || ' ' || rec.orderqtty || ' ' || rec.symbol || ' ' || ' gia ' || rec.price || ' khop ' || rec.matchqtty || ' gia ' || rec.matchprice || '.';
        /*l_data_source := 'select ''' ||
           rec.custodycd ||''' custodycd,''' ||
           to_char(rec.txdate,'DD/MM/YYYY') ||''' txdate,''' ||
           rec.txtime || ''' txtime,''' ||
           rec.l_bors || ''' l_bors,''' ||
           rec.orderqtty || ''' orderqtty,''' ||
           rec.symbol || '''symbol,''' ||
           rec.price || ''' price, ''' ||
           rec.matchqtty || ''' matchqtty, ''' ||
           rec.matchprice || ''' matchprice from dual;';*/
    IF l_mobile is not null or length(l_mobile) <> '' THEN
       /*insert into emaillog
          (autoid, email, templateid, datasource, status, createtime, note)
         values
          (seq_emaillog.nextval,
           l_mobile,
           '303S',
           l_data_source,
           'A',
           sysdate,
           '---');*/
       InsertEmailLog(l_mobile, '303S', l_data_source, rec.afacctno);


        update smsmatched
        set status = 'S'
        where orderid = rec.orderid
        and status = 'N' ;

     end if;
   end loop;
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setEndSection(pkgctx, 'CheckKhopLenh');
  end;
  ------------------------------------------
 procedure CheckTLCuoiNgay is
    l_data_source varchar2(2000);
    l_email varchar2(20);
    l_hour varchar2(10);
  begin
    for rec in (
selecT se.afacctno ,se.trade p_quantity,sb.codeid p_securities_name,nvl((se.trade/sb.parvalue)*100,0) p_current_holding_ratio from semast se, sbsecurities sb
where se.codeid=sb.codeid and nvl(se.trade/sb.parvalue,0) < 0.04 and lastdate = getcurrdate-1
union all
selecT se.afacctno ,(se.trade+se.netting+se.receiving) p_quantity,sb.codeid p_securities_name,nvl(((se.trade+se.netting+se.receiving)/sb.parvalue)*100,0) p_current_holding_ratio From semast se, sbsecurities sb
where se.codeid=sb.codeid and  nvl((se.trade+se.netting+se.receiving)/sb.parvalue,0) < 0.04 and lastdate = getcurrdate
      )
   loop
      begin
            select email into l_email
            from vw_cfmast_sms sms, afmast af where af.custid=sms.custid and af.acctno=rec.afacctno;
      exception
      when others then
            l_email:= '';
      end ;

        select TO_CHAR(SYSDATE,'hh.AM') into l_hour from dual;
        if l_hour = '04.PM' then

           l_data_source := 'select ''' ||
           rec.p_quantity ||''' p_quantity,''' ||
           rec.p_securities_name ||''' p_securities_name,''' ||
           rec.p_current_holding_ratio || ''' p_current_holding_ratio from dual;';


           InsertEmailLog(l_email, 'CS08', l_data_source, '');

/*            update smsmatched
            set status = 'S'
            where  status = 'N'
            and custodycd=rec.custodycd;*/

        end if;
   end loop;
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setEndSection(pkgctx, 'CheckTLCuoiNgay');
  end;
  procedure CheckKLCuoiNgay is
    l_data_source varchar2(2000);
    l_mobile varchar2(20);
    l_hour varchar2(10);
  begin
    /*for rec in (
       select custodycd, listagg(detail, ', ') within group(order by detail)  as detail ,txdate
       from (
            select max(autoid) autoid, custodycd, orderid, txdate,
            (MAX(ORDERQTTY) - max(TOTALQTTY)) as KLCL ,
            lower(substr(header,1,3)) || ' ' || MAX(ORDERQTTY) || ' ' ||  ltrim(substr(header,4))  || 'gia ' || price || ' da khop ' ||
            listagg(detail, ', ') within group(order by detail)  as detail
            from (select a.*, rownum top
                 from (select max(autoid) autoid, txdate, custodycd, orderid, header,max(TOTALQTTY) TOTALQTTY,ORDERQTTY,price,
                   sum(matchqtty) || ' gia ' || matchprice as detail
                   from smsmatched
                   where status = 'N'
                   group by txdate, custodycd, orderid, header, matchprice ,ORDERQTTY,price
                   order by autoid) a)
                   group by custodycd, orderid, txdate, header ,price
                   order by autoid)
            group by custodycd, txdate
      )
   loop
      begin
            select mobilesms into l_mobile
            from vw_cfmast_sms where custodycd=rec.custodycd;
      exception
      when others then
            l_mobile:= '';
      end ;

        select TO_CHAR(SYSDATE,'hh.AM') into l_hour from dual;
        if l_hour = '04.PM' then

           l_data_source := 'select ''' ||
           rec.custodycd ||''' custodycd,''' ||
           to_char(rec.txdate,'DD/MM/YYYY') ||''' txdate,''' ||
           rec.detail || ''' detail from dual;';


           InsertEmailLog(l_mobile, '0338', l_data_source, '');

            update smsmatched
            set status = 'S'
            where  status = 'N'
            and custodycd=rec.custodycd;

        end if;
   end loop;
  exception
    when others then
      plog.error(pkgctx, sqlerrm);*/
      plog.setEndSection(pkgctx, 'CheckKLCuoiNgay');
  end;
  ------------------------------------------
  function CheckEmail(p_email varchar2) return boolean as

    l_is_email_valid boolean;
  begin

    plog.setBeginSection(pkgctx, 'CheckEmail');

    if owa_pattern.match(p_email,
                         '^\w{1,}[.,0-9,a-z,A-Z,_]\w{1,}[.,0-9,a-z,A-Z,_]\w{1,}' ||
                         '@\w{1,}[.,0-9,a-z,A-Z,_]\w{1,}[.,0-9,a-z,A-Z,_]\w{1,}$') then
      l_is_email_valid := true;
    else
      l_is_email_valid := false;
    end if;

    /*IF( ( REPLACE( p_email, ' ','') IS NOT NULL ) AND
         ( NOT owa_pattern.match(
                   p_email, '^[a-z]+[\.\_\-[a-z0-9]+]*[a-z0-9]@[a-z0-9]+\-?[a-z0-9]{1,63}\.?[a-z0-9]{0,6}\.?[a-z0-9]{0,6}\.[a-z]{0,6}$') ) ) THEN
        RETURN FALSE;
    ELSE
        RETURN TRUE;
    END IF;*/

    plog.setEndSection(pkgctx, 'CheckEmail');

    return l_is_email_valid;

  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setEndSection(pkgctx, 'CheckEmail');
  end;
procedure InsertEmailsms (p_template_id varchar2, p_custodycd varchar2, p_status varchar2
) is

    l_status             char(1) := 'A';
    l_reject_status      char(1) := 'R';
    l_receiver_address   emaillog.email%type;
    l_template_id        emaillog.templateid%type;
    l_datasource         emaillog.datasource%type;
    l_account            emaillog.afacctno%type;
    l_message_type       templates.type%type;
    l_is_required        templates.require_register%type;
    l_aftemplates_autoid aftemplates.autoid%type;
    l_can_create_message boolean := true;
    l_typesms             emaillog.typesms%type;
    l_is_active          templates.isactive%type;
    l_is_CC_Broker       templates.isccbroker%type;
    l_multilang         templates.multilang%type;
    l_LANGUAGE_TYPE     varchar2(5);
    l_autoid number;

  begin
    plog.setBeginSection(pkgctx, 'InsertEmailLog');
    
/*-------------------------------------------------------------------------------------------------------------------*/

    l_template_id:=p_template_id;

    select cf.email
    into l_receiver_address
    from cfmast cf where cf.custodycd like p_custodycd;

    select  max(autoid) into l_autoid from emaillog where email=l_receiver_address and templateid=l_template_id and status ='P';
/*-------------------------------------------------------------------------------------------------------------------*/
    update emaillog set status = 'A' where email=l_receiver_address and templateid=l_template_id and autoid=l_autoid and status = 'P';

    plog.setEndSection(pkgctx, 'InsertEmailsms');

  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setEndSection(pkgctx, 'InsertEmailsms');
  end;

  procedure InsertEmailLog(p_email       varchar2,
                           p_template_id varchar2,
                           p_data_source varchar2,
                           p_account     varchar2) is

    l_status             char(1) := 'A';
    l_reject_status      char(1) := 'R';
    l_receiver_address   varchar2(3000);
    l_template_id        emaillog.templateid%type;
    l_datasource         emaillog.datasource%type;
    l_account            emaillog.afacctno%type;
    l_message_type       templates.type%type;
    l_is_required        templates.require_register%type;
    l_aftemplates_autoid aftemplates.autoid%type;
    l_can_create_message boolean := true;
    l_typesms             emaillog.typesms%type;
    l_is_active          templates.isactive%type;
    l_isinternal      templates.isinternal%type;
    l_multilang         templates.multilang%type;
    l_LANGUAGE_TYPE     varchar2(5);


    l_EmailContent      CLOB;
    v_subject       VARCHAR2(1000);
    v_sendstatus    VARCHAR2(10);
    v_fromemail     VARCHAR2(100);
    v_return_code   VARCHAR2(100);
    v_return_msg    VARCHAR2(1000);
    v_err_code      VARCHAR2(100);
    v_SEQ           VARCHAR2(1000);
    v_fullname      VARCHAR2(1000);
    v_emailmode     VARCHAR2(10);
    v_isincode      VARCHAR2(100);
    v_catype        VARCHAR2(400);
  begin

    plog.setBeginSection(pkgctx, 'InsertEmailLog');

    plog.info(pkgctx, 'DATA [' || p_data_source || ']');
    l_receiver_address := p_email;
    l_template_id      := p_template_id;
    l_account          := p_account;

    --start SHBVNEX-2496
    IF P_TEMPLATE_ID IN ('201E', '207E', '208E') THEN
        BEGIN
            SELECT LISTAGG(T.EMAIL, ',') WITHIN GROUP (ORDER BY T.EMAIL) EMAIL INTO L_RECEIVER_ADDRESS
            FROM
            (
                SELECT DISTINCT TRIM(REGEXP_SUBSTR(EMAILCS,'[^,]+',1,LEVEL)) EMAIL
                FROM
                (
                    SELECT * FROM TEMPLATES WHERE CODE = P_TEMPLATE_ID
                )
                CONNECT BY INSTR(EMAILCS ,',',1,LEVEL -1) > 0
            ) T,
            (
                SELECT DISTINCT TRIM(REGEXP_SUBSTR(EMAILCS,'[^,]+',1,LEVEL)) EMAIL
                FROM (
                    SELECT P_EMAIL EMAILCS FROM DUAL
                )
                CONNECT BY INSTR(EMAILCS ,',',1,LEVEL -1) > 0
            ) E
            WHERE T.EMAIL = E.EMAIL;
        EXCEPTION WHEN OTHERS THEN
            L_RECEIVER_ADDRESS := 'ZZZ';
        END;

        IF NVL(L_RECEIVER_ADDRESS,'ZZZ') = 'ZZZ' THEN
            RETURN;
        END IF;
    END IF;
    --end SHBVNEX-2496

    if l_message_type = 'S' AND p_template_id<>'0321'  then
        l_datasource := fn_convert_to_vn(p_data_source);
    else
        l_datasource := p_data_source;
    end if;

    Begin
        select t.type, t.require_register, t.isactive, t.multilang, t.isinternal, t.emailcontent, en_subject
            into l_message_type, l_is_required, l_is_active, l_multilang, l_isinternal, l_EmailContent, v_subject
        from templates t
        where code = l_template_id;
    EXCEPTION
        WHEN OTHERS
           THEN
            l_message_type := 'E';
            l_is_required :='N';
            l_is_active := 'N';
            l_multilang :='Y';
            l_isinternal := 'Y';
            l_EmailContent := '';
    End;
    -- Thoai.tran 29/06/2022
    -- SHBVNEX-2672
    IF l_template_id IN ('210E', '211E', '212E', '213E', '214E', '215E', '216E', '217E', '218E', '264E', '250E','251E',
        '252E','253E','254E','255E','256E','257E', '258E', '265E', '230E', '234E', '235E', '238E','220E','221E','222E','223E','224E','225E','226E','227E','266E',
        '240E','241E','242E','243E','244E','245E','246E','267E','119E','129E','260E','261E','262E','263E','130E') THEN
        select v_subject||' - '||substr(ISINCODE,instr(ISINCODE,',',-1)+3,20)||' - '|| substr(EVENTTYPE,instr(EVENTTYPE,',',-1)+3,50)  INTO v_subject
        from (
         select substr(l_datasource, 0, instr(l_datasource,'p_isincode,')-3) ISINCODE,
         substr(l_datasource, 0, instr(l_datasource,'p_event_type,')-3) EVENTTYPE
        from dual);
    elsif l_template_id in ('EM31', 'E281','E282', 'EM30') then
        select v_subject||' - '||substr(ISINCODE,instr(ISINCODE,',',-1)+3,20)||' - '|| substr(EVENTTYPE,instr(EVENTTYPE,',',-1)+3,50)  INTO v_subject
        from (
         select substr(l_datasource, 0, instr(l_datasource,'isincode,')-3) ISINCODE,
         substr(l_datasource, 0, instr(l_datasource,'catype,')-3) EVENTTYPE
        from dual);
    elsif l_template_id in ('EM24', 'EM25','EM26','EM27') then
        select v_subject||' - '||substr(ISINCODE,instr(ISINCODE,',',-1)+3,20)||' - '|| substr(EVENTTYPE,instr(EVENTTYPE,',',-1)+3,50)  INTO v_subject
        from (
         select substr(l_datasource, 0, instr(l_datasource,'isincode,')-3) ISINCODE,
         substr(l_datasource, 0, instr(l_datasource,'cacontent,')-3) EVENTTYPE
        from dual);
    END IF;
    --
    --12/02/2020, TruongLD add, xu ly khi tich hop voi he thong email cua SHB
    If l_isinternal ='N' then
        prc_EmailReq2API_NEW(
                          l_account,
                          l_receiver_address,
                          v_subject,
                          l_datasource,
                          l_EmailContent,
                          p_template_id,
                          v_return_code,
                          v_return_msg

                      );
        return;
    End If;
    --End TruongLD



    IF l_message_type = 'S' THEN

      BEGIN
      SELECT nvl( typesms,'GAPIT') INTO l_typesms FROM smsmap WHERE prmobile = substr(p_email,1,3);
       exception
        when others then
      l_typesms:='GAPIT';
      END ;

    END IF;


    l_can_create_message:=true;
    if l_can_create_message then
      if l_receiver_address is not null and length(l_receiver_address) > 0 then
      --
        insert into emaillog
          (autoid,
           email,
           templateid,
           datasource,
           status,
           createtime,
           afacctno,typesms, txdate,language_type)
        values
          (seq_emaillog.nextval,
           l_receiver_address,
           l_template_id,
           l_datasource,
           l_status,
           sysdate,
           l_account,l_typesms, getcurrdate,l_language_type);
      else
        insert into emaillog
          (autoid, email, templateid, datasource, status, createtime, note,afacctno,typesms, txdate,language_type)
        values
          (seq_emaillog.nextval,
           l_receiver_address,
           l_template_id,
           l_datasource,
           l_reject_status,
           sysdate,
           '---',l_account,l_typesms, getcurrdate,l_language_type);
      end if;
    ELSIF l_is_active = 'Y' then
      insert into emaillog
        (autoid, email, templateid, datasource, status, createtime, note,afacctno,typesms, txdate, language_type)
      values
        (seq_emaillog.nextval,
         l_receiver_address,
         l_template_id,
         l_datasource,
         l_reject_status,
         sysdate,
         'This template not registed yet',l_account,l_typesms, getcurrdate,l_language_type);
    end if;

    plog.setEndSection(pkgctx, 'InsertEmailLog');

  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setEndSection(pkgctx, 'InsertEmailLog');
  end;

  procedure UpdateBodySms(p_autoid varchar2, p_smsbody varchar2) is
  BEGIN

  UPDATE emaillog SET note =p_smsbody||'AAAA' WHERE autoid =p_autoid;

 exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setEndSection(pkgctx, 'GenTemplates');
  end;

  function fn_convert_to_vn(strinput in nvarchar2) return nvarchar2 is
    strconvert nvarchar2(32527);
  begin
    strconvert := translate(strinput,
                            utf8nums.c_FindText,
                            utf8nums.c_ReplText);
                  ---'???????a?????d????????i??????o????????u?u???????????????????A????????????????I?????????O???????U?U?????????',
                     ----       'aaaaaaaaaaaaaaaaadeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyyAAAAAAAAAAAAAAAAADEEEEEEEEEEEIIIIIOOOOOOOOOOOOOOOOOUUUUUUUUUUUYYYYY');

    return strconvert;
  end;

  function fn_GetNextRunDate(p_last_start_date in date, cycle in char)
    return date is
    l_next_run_date date;
  begin

    if cycle = 'D' then
      l_next_run_date := p_last_start_date + 1;
      /*          update templates_scheduler
        set repeat_interval = :new.cycle,
            next_run_date   = last_start_date + 1
      where template_id = l_template_id;*/
    elsif cycle = 'M' then

      l_next_run_date := add_months(p_last_start_date, 1);
      /*          update templates_scheduler
        set repeat_interval = :new.cycle,
            next_run_date   = add_months(last_start_date, 1)
      where template_id = l_template_id;*/
    elsif cycle = 'Y' then
      l_next_run_date := add_months(p_last_start_date, 12);
      /*          update templates_scheduler
        set repeat_interval = :new.cycle,
            next_run_date   =  add_months(last_start_date, 12)
      where template_id = l_template_id;*/
    end if;

    return l_next_run_date;
  end;

PROCEDURE CheckNotifyEvent
IS
    l_msgtype varchar2(50);
    l_keyvalue varchar2(100);
BEGIN
    plog.setbeginsection(pkgctx, 'CheckNotifyEvent');
    FOR rec IN (
        SELECT autoid, msgtype, keyvalue FROM log_notify_event WHERE status = 'A' ORDER BY autoid DESC
    )
    LOOP
        
        GenTemplates(rec.msgtype, rec.keyvalue);
        UPDATE log_notify_event SET status = 'E' WHERE autoid = rec.autoid;
    END LOOP;
    plog.setendsection(pkgctx, 'CheckNotifyEvent');
EXCEPTION
  WHEN OTHERS
    THEN
        plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
        plog.setendsection(pkgctx, 'CheckNotifyEvent');
        RAISE errnums.E_SYSTEM_ERROR;
END CheckNotifyEvent;



PROCEDURE pr_transferWarning (p_tltxcd VARCHAR2, p_txnum VARCHAR2)
IS
    l_warninglimit NUMBER;
    l_transferlimit Number;
    l_email VARCHAR2(100);
    l_mobile VARCHAR2(100);
    l_datasourcesms varchar2(200);
    l_riskemail VARCHAR2 (200);
    l_risksms VARCHAR2 (200);
    l_amt varchar2(200);
    l_keyvalue varchar2(200);
    l_type varchar2(200);
    l_bank varchar2(200);
    l_custname varchar2(200);
    l_custodycd varchar2(200);
    l_custemail varchar2(200);
    l_custsms varchar2(200);
    l_sendemail varchar2(200);
    l_sendsms varchar2(200);
    l_brname varchar2(150);
    l_currdate date;
 BEGIN
    plog.setbeginsection(pkgctx, 'pr_transferWarning');

    IF p_tltxcd IN ('1101','1179') THEN
        l_currdate:=getcurrdate;
        SELECT bo.msgamt, bo.keyvalue, bo.msgqtty, bodtl.bankref, bodtl.custname, bodtl.custodycd, cf.email, cf.mobilesms, bodtl.mobile sendmobile, bodtl.email sendemail, br.brname
        into l_amt, l_keyvalue, l_type, l_bank, l_custname, l_custodycd, l_custemail, l_custsms, l_sendsms, l_sendemail, l_brname
        FROM borqslog bo,
        (
            SELECT REQUESTID ,
                              MAX(CASE WHEN VARNAME = 'BANKREF' THEN CVALUE ELSE '' END) BANKREF ,
                              MAX(CASE WHEN VARNAME = 'CUSTNAME' THEN CVALUE ELSE '' END) CUSTNAME ,
                              MAX(CASE WHEN VARNAME = 'CUSTODYCD' THEN CVALUE ELSE '' END) CUSTODYCD,
                              MAX(CASE WHEN VARNAME = 'MOBILESMS' THEN CVALUE ELSE '' END) MOBILE,
                              MAX(CASE WHEN VARNAME = 'EMAIL' THEN CVALUE ELSE '' END) EMAIL
                        FROM BORQSLOGDTL
                        GROUP BY REQUESTID
        ) bodtl, vw_cfmast_sms cf,(
            select ra.afacctno, max(rc.brid) brid
            from reaflnk ra, recflnk rc
            where ra.status='A' and rc.status='A'
                and substr(ra.reacctno,1,10)=rc.custid and ra.frdate <= l_currdate and nvl(ra.clstxdate,ra.todate) > l_currdate
            group by ra.afacctno
        ) re, brgrp br, cfmast cf1
        WHERE bodtl.requestid = bo.requestid
        AND bo.rqstyp = 'WRN'
        AND bo.status = 'A'
        AND cf.custodycd = bodtl.custodycd
        And cf.custid = cf1.custid
        and cf.custid=re.afacctno(+)
        AND br.brid=nvl(re.brid, cf1.brid)
        --22/12/2015, TruongLD Add chi lay cac GD phat sinh trong ngay.
        and to_date(bo.txdate,systemnums.C_DATE_FORMAT) = l_currdate
        AND bo.keyvalue = p_txnum;

        IF to_char(l_type) = '0' THEN -- 1 ty
            FOR MOBILE IN (
                        SELECT REGEXP_SUBSTR (l_sendsms,
                                         '[^,]+',
                                         1,
                                         LEVEL)
                             TXT
                        FROM DUAL
                        CONNECT BY REGEXP_SUBSTR (l_sendsms,
                                         '[^,]+',
                                         1,
                                         LEVEL)
                             IS NOT NULL)
            LOOP
                l_datasourcesms:='PHS thong bao: KH '|| l_custname ||', TK CK '
                                  || l_custodycd ||' chuyen so tien '|| ltrim(to_char(l_amt, '9,999,999,999,999,999'))
                                  ||' den NH ' || l_bank;
                nmpks_ems.InsertEmailLog(trim(MOBILE.TXT), '308S', l_datasourcesms, '');
            END LOOP;

            FOR EMAIL IN (
                        SELECT REGEXP_SUBSTR (l_sendemail,
                                         '[^,]+',
                                         1,
                                         LEVEL)
                             TXT
                        FROM DUAL
                        CONNECT BY REGEXP_SUBSTR (l_sendemail,
                                         '[^,]+',
                                         1,
                                         LEVEL)
                             IS NOT NULL)
            LOOP
                /*l_datasourcesms:='select ''Thong bao chuyen tien vuot han muc: KH '|| l_custname ||', TK CK '
                                  || l_custodycd ||' chuyen so tien '|| ltrim(to_char(l_amt, '9,999,999,999,999,999'))
                                  ||' den ngan hang ' || l_bank || ' '' detail from dual';*/
                l_datasourcesms:='select '''||l_custname||''' custname, '''||l_brname||''' brname, '''||l_custodycd||''' custodycd, '
                                ||' '''||ltrim(to_char(l_amt, '9,999,999,999,999,999'))||''' amt, '
                                ||' '''||l_bank||''' bank from dual';
              nmpks_ems.InsertEmailLog(trim(EMAIL.TXT), '115E', l_datasourcesms, '');
            END LOOP;
        END IF;

        IF to_char(l_type) = '1' THEN -- 5 ty
            FOR MOBILE IN (
                        SELECT REGEXP_SUBSTR (l_sendsms,
                                         '[^,]+',
                                         1,
                                         LEVEL)
                             TXT
                        FROM DUAL
                        CONNECT BY REGEXP_SUBSTR (l_sendsms,
                                         '[^,]+',
                                         1,
                                         LEVEL)
                             IS NOT NULL)
            LOOP
                l_datasourcesms:='PHS notice: Customer '||l_custname||', securities account No. '
                                  ||l_custodycd||' transfer money '|| ltrim(to_char(l_amt, '9,999,999,999,999,999'))
                                  ||' to ' || l_bank || ' bank';
                nmpks_ems.InsertEmailLog(trim(MOBILE.TXT), '308S', l_datasourcesms, '');
            END LOOP;

            FOR EMAIL IN (
                        SELECT REGEXP_SUBSTR (l_sendemail,
                                         '[^,]+',
                                         1,
                                         LEVEL)
                             TXT
                        FROM DUAL
                        CONNECT BY REGEXP_SUBSTR (l_sendemail,
                                         '[^,]+',
                                         1,
                                         LEVEL)
                             IS NOT NULL)
            LOOP
                /*l_datasourcesms:='select ''Customer '|| l_custname ||', securities account No. '
                                  || l_custodycd ||' transfer money '|| ltrim(to_char(l_amt, '9,999,999,999,999,999'))
                                  ||' to ' || l_bank || ' bank '' detail from dual';*/
                l_datasourcesms:='select '''||l_custname||''' custname, '''||l_brname||''' brname, '''||l_custodycd||''' custodycd, '
                                ||' '''||ltrim(to_char(l_amt/1000000000, '9,999,999,999.999'))||' billion'' amt, '
                                ||' '''||l_bank||''' bank from dual';
              nmpks_ems.InsertEmailLog(trim(EMAIL.TXT), '115E', l_datasourcesms, '');
            END LOOP;
        END IF;

        UPDATE borqslog set status = 'E' WHERE keyvalue = p_txnum and to_date(txdate,systemnums.C_DATE_FORMAT) = l_currdate;
    END IF;

    plog.setendsection(pkgctx, 'pr_transferWarning');

  EXCEPTION
  WHEN OTHERS
    THEN
        plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
        plog.setendsection(pkgctx, 'pr_transferWarning');
        RAISE errnums.E_SYSTEM_ERROR;
  END pr_transferWarning;

  PROCEDURE pr_GenTemplateCS23 (p_custid    IN VARCHAR2,
                               p_subType    IN VARCHAR2,
                               p_ccycd      IN VARCHAR2,
                               p_feeAmt     IN VARCHAR2,
                               p_feetype    IN VARCHAR2)
  IS
  l_templateId    CHAR(4) := 'CS23';
  l_emptyData     VARCHAR2(10) := '---';
  l_datasource    VARCHAR2(1000);
  l_dateps    VARCHAR2(20);
  l_email         cfmast.email%TYPE;
  l_tradingCode   cfmast.tradingcode%TYPE;
  l_tradingCodeDt cfmast.tradingcodedt%TYPE;
  l_cifid         cfmast.cifid%TYPE;
  l_gcbId         cfmast.gcbid%TYPE;
  l_gcbName       famembers.shortname%TYPE;
  l_trusteeId     cfmast.trusteeid%TYPE;
  l_trusteeName   famembers.fullname%TYPE;
  l_fullName      cfmast.fullname%TYPE;
  l_custodycd      cfmast.custodycd%TYPE;
  l_acname        VARCHAR2(2000);
  l_iica          ddmast.refcasaacct%TYPE;
  l_dda           ddmast.refcasaacct%TYPE;
  l_subType       allcode.en_cdcontent%TYPE;
  l_emailSubject   VARCHAR2(1000);
  BEGIN
    plog.setBeginSection (pkgctx, 'pr_GenTemplateCS23');
    SELECT fullName,custodycd, tradingcode, tradingcodedt, cifid, gcbid, trusteeid
    INTO l_fullName,l_custodycd, l_tradingCode, l_tradingCodeDt, l_cifid, l_gcbId, l_trusteeId
    FROM cfmast WHERE custid = p_custid;
    BEGIN
      SELECT f.shortname
      INTO l_gcbName
      FROM famembers f
      WHERE f.autoid = l_gcbId;
    EXCEPTION
      WHEN OTHERS THEN
        l_gcbName := l_emptyData;
    END;
    BEGIN
      SELECT f.shortname
      INTO l_trusteeName
      FROM famembers f
      WHERE f.autoid = l_trusteeId;
    EXCEPTION
      WHEN OTHERS THEN
        l_trusteeName := l_emptyData;
    END;
    l_acname := CASE WHEN l_gcbName = l_emptyData AND l_trusteeName = l_emptyData THEN l_fullName
                     WHEN l_gcbName = l_trusteeName THEN l_gcbName || '-' || l_fullName
                     ELSE l_gcbName || '-' || l_trusteeName || '-' || l_fullName END;

    BEGIN
      SELECT f.refcasaacct
      INTO l_iica
      FROM ddmast f
      WHERE f.custid = p_custid AND f.accounttype = 'IICA';
      l_iica := substr(l_iica, 1, 3) || '-' || substr(l_iica, 4, 3) || '-' || substr(l_iica, 7);
    EXCEPTION
      WHEN OTHERS THEN
        l_iica := '';
    END;

    BEGIN
      SELECT f.refcasaacct
      INTO l_dda
      FROM ddmast f
      WHERE f.custid = p_custid AND f.accounttype = 'DDA';
      l_dda := substr(l_dda, 1, 3) || '-' || substr(l_dda, 4, 3) || '-' || substr(l_dda, 7);
    EXCEPTION
      WHEN OTHERS THEN
        l_dda := '';
    END;

    BEGIN
      SELECT to_char(getcurrdate,'dd/mm/rrrr')
      INTO l_dateps
      FROM dual;
    EXCEPTION
      WHEN OTHERS THEN
        l_dateps := '';
    END;

    SELECT subject INTO l_emailSubject FROM templates t WHERE code = 'CS23';
    l_emailSubject := replace(l_emailSubject, '[p_dateps]', l_dateps);


    SELECT EN_CDCONTENT INTO l_subType FROM  ALLCODE WHERE CDNAME = p_feetype AND CDTYPE = 'SA' AND cdval = p_subType;

    l_datasource := 'SELECT ''' || l_fullName || ''' p_fundName, '
                        || '''' || l_custodycd || ''' p_custodycd, '
                        || '''' || l_tradingCode || ''' idcode, '
                        || '''' || l_tradingCodeDt || ''' iddate, '
                        || '''' || l_cifid || ''' cifid, '
                        || '''' || l_acname || ''' acname, '
                        || '''' || l_iica || ''' iica, '
                        || '''' || l_dda || ''' dda, '
                        || '''' || l_subType || ''' p_subtype, '
                        || '''' || p_ccycd || ''' p_currency, '
                        || '''' || l_dateps || ''' p_dateps, '
                        || '''' || to_char(UTILS.SO_THANH_CHU(TO_NUMBER(p_feeAmt,'99999999999999'))) || ''' p_feeamount, '
                        || '''' || l_emailSubject || ''' emailsubject from dual';
    pr_sendInternalEmail(l_datasource,
                        l_templateId,
                        '',
                        'Y');
    plog.setEndSection (pkgctx, 'pr_GenTemplateCS23');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_GenTemplateCS23');
  END;

  PROCEDURE pr_GenTemplateEM09
  IS
  l_template_id    CHAR(4) := 'EM09';
  l_datasource     VARCHAR2(2000);
  l_month          VARCHAR2(100);
  l_frDate         DATE;
  l_toDate         DATE;
  l_trader_fee     NUMBER;
  l_customer_fee   NUMBER;
  l_prevDate       VARCHAR2(20);
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_GenTemplateEM09');
    l_prevDate := CSPKS_SYSTEM.fn_get_sysvar('SYSTEM', 'PREVDATE');
    l_month := TO_CHAR(TO_DATE(l_prevDate, systemnums.C_DATE_FORMAT), 'Mon-RRRR');
    l_frDate := trunc(TO_DATE(l_prevDate, systemnums.C_DATE_FORMAT), 'MM');
    l_toDate := ADD_MONTHS(trunc(TO_DATE(l_prevDate, systemnums.C_DATE_FORMAT), 'MM'), 1) - 1;

    SELECT SUM(CASE WHEN substr(cf.custodycd, 4, 1) = 'A' THEN depo.amt ELSE 0 END),
           SUM(CASE WHEN substr(cf.custodycd, 4, 1) != 'A' THEN depo.amt ELSE 0 END)
    INTO l_trader_fee, l_customer_fee
    FROM sedepobal depo, semast sem, cfmast cf
    WHERE depo.txdate BETWEEN l_frDate AND l_toDate
    AND depo.acctno = sem.acctno AND sem.custid = cf.custid
    AND depo.deltd <> 'Y';

    l_datasource := 'SELECT ''' || l_month || ''' month, '
                        || '''' || TRIM(TO_CHAR(NVL(l_trader_fee,0), '9,999,999,999,999,999')) || ''' feetreasury, '
                        || '''' || TRIM(TO_CHAR(NVL(l_customer_fee,0), '9,999,999,999,999,999')) || ''' feessd, '
                        || '''' || TRIM(TO_CHAR(NVL(l_customer_fee,0) + NVL(l_trader_fee,0), '9,999,999,999,999,999')) || ''' total from dual';
    pr_sendInternalEmail(l_datasource,
                        l_template_id,
                        '',
                        'Y');
    plog.setEndSection(pkgctx, 'pr_GenTemplateEM09');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_GenTemplateEM09');
  END;

  PROCEDURE pr_GenTemplateEM12 (p_ticker      VARCHAR2,
                               p_paidDate     VARCHAR2,
                               p_ver          VARCHAR2)
  IS
  l_template_id    CHAR(6) := 'EM12';
  l_datasource     VARCHAR2(2000);
  l_contractDate   DATE; -- sbsecurities.contractDate
  l_bondName       issuers.fullname%TYPE;
  l_bondNameeng    issuers.en_fullname%TYPE;
  L_paymentdate    DATE;
  l_recordDate     DATE; -- bondtype.recordDate
  l_emailSubject   VARCHAR2(1000) /*:= utf8nums.c_EMAIL_EM12_BONDHOLDER*/;
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_GenTemplateEM12');

/*    SELECT sb.contractdate, iss.Fullname,  fn_get_nextdate(bt.recorddate, 3)
    INTO l_contractDate, l_bondName, l_recordDate
    FROM issuers iss, bondtype bt, sbsecurities sb
    WHERE bt.bondcode = sb.codeid AND sb.issuerid = iss.issuerid
    AND .tickerlist = p_ticker AND bt.paymentdate = TO_DATE(p_paidDate, 'DD/MM/RRRR');*/
    --Thoai.tran 19/04/2021
    -- Them template EM12 version English
    if p_ver='ENG' then
        l_template_id:= 'EM12EN';
        l_emailSubject := utf8nums.c_EMAIL_EM12EN_BONDHOLDER;
    end if;
    --NAM.LY 21/02/2020
    SELECT DISTINCT sb.contractdate, iss.Fullname, iss.en_fullname, fn_get_nextdate(bt.recorddate, 3),BT.actualpaydate
    INTO l_contractDate, l_bondName,l_bondNameeng, l_recordDate,L_paymentdate
    FROM issuers iss, bondtypepay bt, sbsecurities sb
    WHERE bt.bondcode = sb.codeid AND sb.issuerid = iss.issuerid
    AND SB.SYMBOL = p_ticker
    AND bt.paymentdate = TO_DATE(p_paidDate, 'DD/MM/RRRR');

    l_emailSubject := replace(l_emailSubject, '[p_issuername]', l_bondName);
    l_emailSubject := replace(l_emailSubject, '[p_issuernameeng]', l_bondNameeng);
    l_emailSubject := replace(l_emailSubject, '[p_paymentdate]', l_paymentdate);

    l_datasource := 'SELECT ''' || p_ticker || ''' ticker, '
                        || '''' || p_paidDate || ''' paidDate, '
                        || '''' || l_bondName || ''' p_issuername, '
                        || '''' || l_bondNameeng || ''' p_issuernameeng, '
                        || '''' || TO_CHAR(l_paymentdate, 'DD.MM.RRRR') || ''' p_paymentdate, '
                        || '''' || TO_CHAR(l_contractDate, 'DD/MM/RRRR') || ''' contractDate, '
                        || '''' || trim(to_char(l_contractDate,'Month'))||' '||
                        trim(to_char(l_contractDate,'dd, RRRR'))|| ''' contractdate_eng, '
                        || '''' || l_bondName || ''' bondName, '
                        || '''' || l_bondNameeng || ''' bondname_eng, '
                        || '''' || TO_CHAR(l_recordDate, 'DD/MM/RRRR') || ''' recordDate, '
                        || '''' || trim(to_char(l_recordDate,'Month'))||' '||
                        trim(to_char(l_recordDate,'dd, RRRR'))|| ''' recorddate_eng, '
                        || '''' || l_emailSubject || ''' emailsubject from dual';

    pr_sendInternalEmail(l_datasource,
                        trim(l_template_id),
                        '');
    plog.setEndSection(pkgctx, 'pr_GenTemplateEM12');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_GenTemplateEM12');
  END;


  PROCEDURE pr_GenTemplateEM20 (p_ticker      VARCHAR2,
                               p_paidDate     VARCHAR2)
  IS
  l_template_id    CHAR(4) := 'EM20';
  l_datasource     VARCHAR2(2000);
  l_contractDate   DATE; -- sbsecurities.contractDate
  l_bondName       issuers.fullname%TYPE;
  l_expdate        DATE; --SBSECURITIES.expdate
  l_total_value    NUMBER; --sbsecurities.issqtty * sbsecurities.parvalue
  l_term           varchar2(200);
  l_prev_paidDate  DATE;
  l_senddate       DATE;
  l_intcoupon      sbsecurities.intcoupon%TYPE;
  l_emailSubject   VARCHAR2(1000);
  l_symbol         varchar2(20);
  l_paiddate       DATE;
  l_issuername     VARCHAR2(1000);
  l_officename     VARCHAR2(1000);
  l_LICENSENO      VARCHAR2(1000);
  l_qtty        number;
  l_typebank    varchar2(100);
  l_bankacc     varchar2(100);
  l_bankname    VARCHAR2(1000);
  l_periodinterest  VARCHAR2(200);
  l_tax         number;
  l_amount   number;
  l_begindate   date;
  l_paymentdate date;
  l_reportdate  date;
  l_shortname    varchar2(100);
  l_ISSUEDATE   date;
  l_valueofissue number;
  l_ccycd   varchar2(100);
  l_parvalue    number;
  l_totalvalue  number;
  l_cpdate number;
  l_nextdate date;
  l_contractdt DATE;
  ---
  L_LTP VARCHAR2(1000);
  L_GLTP  VARCHAR2(1000);
  L_TTLTP VARCHAR2(1000);
  L_TTGLTP VARCHAR2(1000);
  L_MLTP  VARCHAR2(1000);
  L_DK  VARCHAR2(1000);
  L_TT  VARCHAR2(1000);
  L_D  VARCHAR2(1000);
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_GenTemplateEM20');
    l_paiddate := TO_DATE(p_paidDate,'DD/MM/RRRR');
    --
    SELECT MAX("'LTP'"),MAX("'GLTP'"),MAX("'TTLTP'"),MAX("'TTGLTP'"),MAX("'MLTP'"),MAX("'DK'"),MAX("'TT'"),MAX("'D'")
    INTO L_LTP,L_GLTP,L_TTLTP,L_TTGLTP,L_MLTP,L_DK,L_TT,L_D
    FROM (
    SELECT *
    FROM ALLCODE
    WHERE CDNAME ='EM20'
        )
    PIVOT
    (
    MAX(CDCONTENT)
    FOR CDVAL IN ('LTP','GLTP','TTLTP','TTGLTP','MLTP','DK','TT','D')
    )
    GROUP BY CDNAME ;
    --
    FOR REC IN
    (
        SELECT DISTINCT BO.CAMASTID
        FROM BONDTYPEPAY BT, BONDCASCHD BO
        WHERE BT.AUTOID = BO.PERIODINTEREST
        AND BONDSYMBOL = P_TICKER
        AND BT.PAYMENTDATE = TO_DATE(P_PAIDDATE, 'DD/MM/RRRR')
    ) LOOP
        for REC1 IN (
    SELECT DISTINCT  CA.OPTSYMBOL SHORTNAME,CA.REPORTDATE,IC.CONTRACTDATE,ISS.EN_FULLNAME ISSNAME,ISS.FULLNAME OFFICENAME
         ,BOP.BEGINDATE
         ,BOP.PAYMENTDATE
         ,SB.ISSUEDATE
         ,SB.EXPDATE
         ,SB.VALUEOFISSUE
         ,SB.intcoupon
         ,BO.FULLNAME
         ,CASE WHEN CF.COUNTRY <> '234' THEN CF.TRADINGCODE ELSE CF.IDCODE END IDNO
         ,BO.QUANTITY
         ,SBCD.SHORTCD CCYCD
         ,SB.PARVALUE
         ,BO.QUANTITY * SB.PARVALUE TOTALVALUE
         ,BOP.PAYMENTDATE-BOP.BEGINDATE CPDATE
         ,ROUND(BO.QUANTITY * SB.PARVALUE *((BOP.PAYMENTDATE-BOP.BEGINDATE)/365)*SB.intcoupon/100) AMOUNT
         ,utils.fnc_number2work(MONTHS_BETWEEN(TO_DATE(TO_CHAR(BOP.PAYMENTDATE,'MM/RRRR'),'MM/RRRR'),
            TO_DATE(TO_CHAR(BOP.BEGINDATE,'MM/RRRR'),'MM/RRRR')))||'-month' PERIODINTEREST
         ,A3.EN_CDCONTENT BANKACCTYPE
         ,CTH.BANKACC
         ,CTH.BANKNAME
         ,getnextworkingdate(CA.REPORTDATE) NEXTDATE
    --into l_shortname,l_reportdate,l_contractdt,l_issuername,l_officename,l_begindate,l_paymentdate,l_issuedate,l_expdate,l_valueofissue,l_intcoupon
    --,l_bondName,l_LICENSENO,L_QTTY,l_ccycd,l_parvalue,l_totalvalue,l_cpdate,l_amount,l_periodinterest,l_typebank,l_bankacc,l_bankname,l_nextdate
    FROM BONDCASCHD BO, ALLCODE A1,CFMAST CF, CFOTHERACC CTH, CRBBANKLIST CRB,ISSUERS ISS,issues IR,BONDISSUE BI,issuer_contractno IC
        , CAMAST CA, SBSECURITIES SB, ALLCODE A2,BONDTYPEPAY BOP, ALLCODE A3,SBCURRENCY SBCD
    WHERE BO.STATUS = 'P' AND BO.DELTD ='N'
    AND A1.CDTYPE = 'SY' AND A1.CDNAME = 'YESNO' AND A1.CDVAL = BO.DEPOSITARY
    AND BO.CUSTODYCD = CF.CUSTODYCD
    AND SB.ISSUERID = ISS.ISSUERID
    AND CF.CUSTID = CTH.CFCUSTID(+) AND CTH.DEFAULTACCT(+) = 'Y' AND CTH.DELTD(+) <> 'Y'
    AND CTH.BANKCODE = CRB.CITAD(+)
    AND CTH.DEFAULTACCT='Y'
    AND BO.CAMASTID = CA.CAMASTID
    AND BO.CAMASTID=REC.CAMASTID
    AND CA.OPTSYMBOL = SB.SYMBOL
    AND A2.CDTYPE = 'CB' AND A2.CDNAME = 'PERIODINTEREST' AND A2.CDVAL = SB.PERIODINTEREST
    AND BO.PERIODINTEREST = BOP.AUTOID
    AND A3.CDNAME = 'TYPE'
    AND A3.CDTYPE = 'AF'
    AND CTH.TYPE=A3.CDVAL
    AND SB.CCYCD=SBCD.CCYCD
    AND IR.AUTOID = BI.ISSUESID
    AND IR.AUTOID = IC.ISSUESID
    AND BI.BONDCODE = BOP.BONDCODE
    AND IC.contracttype='001')
    LOOP
        select REC1.SHORTNAME,REC1.REPORTDATE,REC1.CONTRACTDATE,REC1.ISSNAME,REC1.OFFICENAME
         ,REC1.BEGINDATE
         ,REC1.PAYMENTDATE
         ,REC1.ISSUEDATE
         ,REC1.EXPDATE
         ,REC1.VALUEOFISSUE
         ,REC1.intcoupon
         ,REC1.FULLNAME
         ,REC1.IDNO
         ,REC1.QUANTITY
         ,REC1.CCYCD
         ,REC1.PARVALUE
         ,REC1.TOTALVALUE
         ,REC1.CPDATE
         ,REC1.AMOUNT
         ,REC1.PERIODINTEREST
         ,REC1.BANKACCTYPE
         ,REC1.BANKACC
         ,REC1.BANKNAME
         ,REC1.NEXTDATE
        into l_shortname,l_reportdate,l_contractdt,l_issuername,l_officename,l_begindate,l_paymentdate,l_issuedate,l_expdate,l_valueofissue,l_intcoupon
        ,l_bondName,l_LICENSENO,L_QTTY,l_ccycd,l_parvalue,l_totalvalue,l_cpdate,l_amount,l_periodinterest,l_typebank,l_bankacc,l_bankname,l_nextdate
        from dual;
        SELECT MAX(bt.paymentdate) INTO l_prev_paidDate
        FROM bondtypepay bt,  sbsecurities sb
        WHERE bt.bondcode = sb.codeid
        AND sb.symbol = p_ticker AND bt.paymentdate < TO_DATE(p_paidDate, 'DD/MM/RRRR');

        IF l_prev_paidDate IS NULL THEN
          SELECT s.issuedate
          INTO l_prev_paidDate
          FROM sbsecurities s
          WHERE s.symbol = p_ticker;
        END IF;

        l_emailSubject := utf8nums.c_EMAIL_EM20_BONDHOLDER;
        l_emailSubject := replace(l_emailSubject, '[p_officename]', l_officename);
        l_emailSubject := replace(l_emailSubject, '[p_reportdate]', TO_CHAR(l_reportdate,'DD/MM/RRRR'));
        l_datasource := 'SELECT ''' || l_shortname || ''' p_shortname, '
                            || '''' || TO_CHAR(l_reportdate,'DD/MM/RRRR') || ''' p_reportdate, '
                            || '''' || TO_CHAR(l_contractdt,'Mon MM, RRRR') || ''' p_contractdt, '
                            || '''' || l_issuername || ''' p_issname, '
                            || '''' || l_officename || ''' p_officename, '
                            || '''' || lower(l_periodinterest) || ''' p_periodinterest, '
                            || '''' || TO_CHAR(l_paymentdate,'DD/MM/RRRR') || ''' p_paymentdate, '
                            || '''' || TO_CHAR(l_begindate,'DD/MM/RRRR') || ''' p_begindate, '
                            || '''' || TO_CHAR(L_issuedate,'DD/MM/RRRR') || ''' p_issuedate, '
                            || '''' || TO_CHAR(l_expdate,'DD/MM/RRRR') || ''' p_expdate, '
                            || '''' || TRIM(TO_CHAR(l_valueofissue, '9,999,999,999,999,999,999,999')) || ''' p_valueofissue, '
                            || '''' || UTILS.fnc_number2work(l_valueofissue) || ''' p_value_vchar, '
                            || '''' || l_intcoupon || ''' p_intcoupon, '
                            || '''' || l_bondName || ''' p_bondname, '
                            || '''' || l_LICENSENO || ''' p_licenseno, '
                            || '''' || TRIM(TO_CHAR(l_qtty, '9,999,999,999,999,999,999,999')) || ''' p_qtty, '
                            || '''' || l_ccycd || ''' p_currency, '
                            || '''' || TRIM(TO_CHAR(l_parvalue, '9,999,999,999,999,999,999,999')) || ''' p_parvalue, '
                            || '''' || TRIM(TO_CHAR(l_totalvalue, '9,999,999,999,999,999,999,999')) || ''' p_totalvalue, '
                            || '''' || TO_CHAR(l_begindate, 'DD-Mon-RRRR') || ''' p_begindt, '
                            || '''' || TO_CHAR(l_paymentdate, 'DD-Mon-RRRR') || ''' p_paymentdt, '
                            || '''' || l_cpdate || ''' p_countdate, '
                            || '''' || l_typebank || ''' p_bankacctype, '
                            || '''' || TO_CHAR(l_nextdate,'Month dd RRRR') || ''' p_nextpayment, '
                            || '''' || l_bankacc || ''' p_bankacc, '
                            || '''' || l_bankname || ''' p_bankname, '
                            || '''' || l_emailSubject || ''' emailsubject, '
                            || '''' || TRIM(TO_CHAR(l_amount, '9,999,999,999,999,999,999,999')) || ''' p_amount from dual';

                            pr_sendInternalEmail(l_datasource,
                                                l_template_id,
                                                '');
                        END LOOP;
   END LOOP;
    plog.setEndSection(pkgctx, 'pr_GenTemplateEM20');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_GenTemplateEM20');
  END;

  PROCEDURE pr_GenTemplateEM21 (p_ticker      VARCHAR2,
                               p_paidDate     VARCHAR2)
  IS
  l_template_id    CHAR(4) := 'EM21';
  l_datasource     VARCHAR2(2000);
  l_contractDate   DATE; -- sbsecurities.contractDate
  l_bondName       issuers.fullname%TYPE;
  l_expdate        DATE; --SBSECURITIES.expdate
  l_total_value    NUMBER; --sbsecurities.issqtty * sbsecurities.parvalue
  l_term           varchar2(200);
  l_prev_paidDate  DATE;
  l_senddate       DATE;
  l_intcoupon      sbsecurities.intcoupon%TYPE;
  l_emailSubject   VARCHAR2(1000);
  l_symbol         varchar2(20);
  l_paiddate       DATE;
  l_issuername           VARCHAR2(1000);
  l_LICENSENO           VARCHAR2(1000);
  l_qtty        number;
  l_typebank    varchar2(100);
  l_bankacc     varchar2(100);
  l_bankname    VARCHAR2(1000);
  l_periodinterest  VARCHAR2(200);
  l_tax         number;
  l_netamount   number;
  l_begindate   varchar2(100);
  l_paymentdate varchar2(100);
  l_desc        VARCHAR2(1000);
  ---
  L_LTP VARCHAR2(1000);
  L_GLTP  VARCHAR2(1000);
  L_TTLTP VARCHAR2(1000);
  L_TTGLTP VARCHAR2(1000);
  L_MLTP  VARCHAR2(1000);
  L_DK  VARCHAR2(1000);
  L_TT  VARCHAR2(1000);
  L_D  VARCHAR2(1000);
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_GenTemplateEM21');
    l_paiddate := TO_DATE(p_paidDate,'DD/MM/RRRR');
    --
    SELECT MAX("'LTP'"),MAX("'GLTP'"),MAX("'TTLTP'"),MAX("'TTGLTP'"),MAX("'MLTP'"),MAX("'DK'"),MAX("'TT'"),MAX("'D'")
    INTO L_LTP,L_GLTP,L_TTLTP,L_TTGLTP,L_MLTP,L_DK,L_TT,L_D
    FROM (
    SELECT *
    FROM ALLCODE
    WHERE CDNAME ='EM20'
        )
    PIVOT
    (
    MAX(CDCONTENT)
    FOR CDVAL IN ('LTP','GLTP','TTLTP','TTGLTP','MLTP','DK','TT','D')
    )
    GROUP BY CDNAME ;
    --
    FOR REC IN
    (
        SELECT DISTINCT BO.CAMASTID
        FROM BONDTYPEPAY BT, BONDCASCHD BO
        WHERE BT.AUTOID = BO.PERIODINTEREST
        AND BONDSYMBOL = P_TICKER
        AND BT.PAYMENTDATE = TO_DATE(P_PAIDDATE, 'DD/MM/RRRR')
    ) LOOP
        for rec1 in (
    SELECT DISTINCT  --BO.CAMASTID, BO.CUSTODYCD,
    utils.fnc_number2work(MONTHS_BETWEEN(TO_DATE(TO_CHAR(BOP.PAYMENTDATE,'MM/RRRR'),'MM/RRRR'),
    TO_DATE(TO_CHAR(BOP.BEGINDATE,'MM/RRRR'),'MM/RRRR')))||'-month' PERIODINTEREST
    ,BO.FULLNAME, BO.QUANTITY,ISS.LICENSENO,ISS.fullname SHORTNAME, A3.EN_CDCONTENT BANKACCTYPE,CTH.BANKACC,CTH.BANKNAME
         , BO.AMOUNT
         , CASE WHEN CA.PITRATEMETHOD='IS' THEN BO.TAX ELSE 0 END TAX
         , BO.AMOUNT - (CASE WHEN CA.PITRATEMETHOD='SC' THEN 0 ELSE BO.TAX END) NETAMOUNT
         , SB.SYMBOL
         ,TO_CHAR(BOP.BEGINDATE,'DD/MM/RRRR') BEGINDATE
         ,TO_CHAR(BOP.PAYMENTDATE,'DD/MM/RRRR') PAYMENTDATE
         , CASE
                     WHEN CA.CATYPE ='015' THEN L_TTLTP
                     WHEN CA.CATYPE ='016' THEN L_TTGLTP
                     ELSE L_MLTP
           END ||CA.OPTSYMBOL||' '||L_DK||' '||MONTHS_BETWEEN(TO_DATE(TO_CHAR(BOP.PAYMENTDATE,'MM/RRRR'),'MM/RRRR'),TO_DATE(TO_CHAR(BOP.BEGINDATE,'MM/RRRR'),'MM/RRRR'))
           ||' '||L_TT||' '||TO_CHAR(BOP.BEGINDATE,'DD/MM/RRRR')||' '||L_D||' '||TO_CHAR(BOP.PAYMENTDATE,'DD/MM/RRRR') TXDESC
    /*INTO l_periodinterest,l_bondName, l_qtty,l_LICENSENO,l_issuername,l_typebank,l_bankacc,l_bankname,
         l_total_value, l_tax, l_netamount,l_symbol,l_begindate,l_paymentdate,l_desc*/
    FROM BONDCASCHD BO, ALLCODE A1,CFMAST CF, CFOTHERACC CTH, CRBBANKLIST CRB,ISSUERS ISS
        , CAMAST CA, SBSECURITIES SB, ALLCODE A2,BONDTYPEPAY BOP, ALLCODE A3
    WHERE BO.STATUS = 'P' AND BO.DELTD ='N'
    AND A1.CDTYPE = 'SY' AND A1.CDNAME = 'YESNO' AND A1.CDVAL = BO.DEPOSITARY
    AND BO.CUSTODYCD = CF.CUSTODYCD
    AND SB.ISSUERID = ISS.ISSUERID
    AND CF.CUSTID = CTH.CFCUSTID(+) AND CTH.DEFAULTACCT(+) = 'Y' AND CTH.DELTD(+) <> 'Y'
    AND CTH.BANKCODE = CRB.CITAD(+)
    AND CTH.DEFAULTACCT='Y'
    AND BO.CAMASTID = CA.CAMASTID
    AND BO.CAMASTID=REC.CAMASTID
    AND CA.OPTSYMBOL = SB.SYMBOL
    AND A2.CDTYPE = 'CB' AND A2.CDNAME = 'PERIODINTEREST' AND A2.CDVAL = SB.PERIODINTEREST
    AND BO.PERIODINTEREST = BOP.AUTOID
    AND A3.CDNAME = 'TYPE'
    AND A3.CDTYPE = 'AF'
    AND CTH.TYPE=A3.CDVAL)
    loop
        SELECT rec1.PERIODINTEREST
    ,rec1.FULLNAME, rec1.QUANTITY,rec1.LICENSENO,rec1.SHORTNAME, rec1.BANKACCTYPE,rec1.BANKACC,rec1.BANKNAME
         , rec1.AMOUNT
         , rec1.TAX
         ,rec1.NETAMOUNT
         ,rec1.SYMBOL
         ,rec1.BEGINDATE
         ,rec1.PAYMENTDATE
         , rec1.TXDESC
    INTO l_periodinterest,l_bondName, l_qtty,l_LICENSENO,l_issuername,l_typebank,l_bankacc,l_bankname,
         l_total_value, l_tax, l_netamount,l_symbol,l_begindate,l_paymentdate,l_desc
         from dual;


    SELECT MAX(bt.paymentdate) INTO l_prev_paidDate
    FROM bondtypepay bt,  sbsecurities sb
    WHERE bt.bondcode = sb.codeid
    AND sb.symbol = p_ticker AND bt.paymentdate < TO_DATE(p_paidDate, 'DD/MM/RRRR');

    IF l_prev_paidDate IS NULL THEN
      SELECT s.issuedate
      INTO l_prev_paidDate
      FROM sbsecurities s
      WHERE s.symbol = p_ticker;
    END IF;

    l_emailSubject := utf8nums.c_EMAIL_EM21_BONDHOLDER;
    l_emailSubject := replace(l_emailSubject, '[p_issuername]', l_issuername);
    l_emailSubject := replace(l_emailSubject, '[p_paymentdate]', l_paymentdate);
    l_datasource := 'SELECT ''' || l_issuername || ''' p_issuername, '
                        || '''' || lower(l_periodinterest) || ''' p_periodinterest, '
                        || '''' || l_begindate || ''' p_begindate, '
                        || '''' || l_paymentdate || ''' p_paymentdate, '
                        || '''' || l_bondname || ''' p_bondname, '
                        || '''' || l_licenseno || ''' p_licenseno, '
                        || '''' || TRIM(TO_CHAR(l_qtty, '9,999,999,999,999,999,999,999')) || ''' p_qtty, '
                        || '''' || l_typebank || ''' p_bankacctype, '
                        || '''' || l_bankacc || ''' p_bankacc, '
                        || '''' || l_bankname || ''' p_bankname, '
                        || '''' || TRIM(TO_CHAR(l_netamount, '9,999,999,999,999,999,999,999')) || ''' p_amount, '
                        || '''' || l_desc || ''' p_remark from dual';

    pr_sendInternalEmail(l_datasource,
                        l_template_id,
                        '');
            end loop;
   END LOOP;
    plog.setEndSection(pkgctx, 'pr_GenTemplateEM21');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_GenTemplateEM21');
  END;


  PROCEDURE pr_GenTemplateEM14 (p_ticker      VARCHAR2,
                               p_paidDate     VARCHAR2)
  IS
  l_template_id    CHAR(4) := 'EM14';
  l_datasource     VARCHAR2(2000);
  l_contractDate   DATE; -- sbsecurities.contractDate
  l_bondName       issuers.fullname%TYPE;
  l_expdate        DATE; --SBSECURITIES.expdate
  l_total_value    NUMBER; --sbsecurities.issqtty * sbsecurities.parvalue
  l_term           varchar2(200);
  l_prev_paidDate  DATE;
  l_senddate       DATE;
  l_begindate      DATE;
  l_intcoupon      sbsecurities.intcoupon%TYPE;
  l_emailSubject   VARCHAR2(1000);
  l_symbol         varchar2(20);
  l_paiddate       DATE;
  l_gltpp           VARCHAR2(1000);
  l_nd           VARCHAR2(1000);
  ---
  L_LTP VARCHAR2(1000);
  L_GLTP  VARCHAR2(1000);
  L_TTLTP VARCHAR2(1000);
  L_TTGLTP VARCHAR2(1000);
  L_MLTP  VARCHAR2(1000);
  L_DK  VARCHAR2(1000);
  L_TT  VARCHAR2(1000);
  L_D  VARCHAR2(1000);
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_GenTemplateEM14');
    l_paiddate := TO_DATE(p_paidDate,'DD/MM/RRRR');
    --
    SELECT MAX("'LTP'"),MAX("'GLTP'"),MAX("'TTLTP'"),MAX("'TTGLTP'"),MAX("'MLTP'"),MAX("'DK'"),MAX("'TT'"),MAX("'D'")
    INTO L_LTP,L_GLTP,L_TTLTP,L_TTGLTP,L_MLTP,L_DK,L_TT,L_D
    FROM (
    SELECT *
    FROM ALLCODE
    WHERE CDNAME ='EM14'
        )
    PIVOT
    (
    MAX(CDCONTENT)
    FOR CDVAL IN ('LTP','GLTP','TTLTP','TTGLTP','MLTP','DK','TT','D')
    )
    GROUP BY CDNAME ;
    --
    FOR REC IN
    (
        SELECT DISTINCT BO.CAMASTID
        FROM BONDTYPEPAY BT, BONDCASCHD BO
        WHERE BT.AUTOID = BO.PERIODINTEREST
        AND BONDSYMBOL = P_TICKER
        AND BT.PAYMENTDATE = TO_DATE(P_PAIDDATE, 'DD/MM/RRRR')
    ) LOOP
    SELECT DISTINCT sb.ISSUEDATE, sb.expdate, sb.VALUEOFISSUE, Lower(al.cdcontent) periodinterest, sb.intcoupon,
           iss.Fullname, fn_get_prevdate(bt.paymentdate, 2),bt.BEGINDATE,sb.symbol,
           case  when ca.catype ='015' then L_LTP else L_GLTP end,
           case
                 when ca.catype ='015' then L_TTLTP
                 when ca.catype ='016' then L_TTGLTP
                 else L_MLTP
           end ||sb.symbol||L_DK||MONTHS_BETWEEN(TO_DATE(TO_CHAR(bt.PAYMENTDATE,'MM/RRRR'),'MM/RRRR'),TO_DATE(TO_CHAR(bt.BEGINDATE,'MM/RRRR'),'MM/RRRR')) ||L_TT||TO_CHAR(bt.BEGINDATE,'DD/MM/RRRR')||L_D||TO_CHAR(bt.PAYMENTDATE,'DD/MM/RRRR')
    INTO l_contractDate, l_expdate, l_total_value, l_term, l_intcoupon,
         l_bondName, l_senddate,l_begindate,l_symbol,l_gltpp,l_nd
    FROM issuers iss, bondtypepay bt, sbsecurities sb, allcode al, bondcaschd bo, camast ca
    WHERE bt.bondcode = sb.codeid
        AND sb.issuerid = iss.issuerid
        --AND sb.symbol = p_ticker
        --AND bt.paymentdate = TO_DATE(p_paidDate, 'DD/MM/RRRR')
        and al.cdname='PERIODINTEREST'
        and sb.periodinterest = al.cdval (+)
        and bt.autoid = bo.periodinterest
        and bo.camastid = ca.camastid
        and bo.camastid =rec.camastid
        AND BT.PAYMENTDATE = TO_DATE(P_PAIDDATE, 'DD/MM/RRRR');

    SELECT MAX(bt.paymentdate) INTO l_prev_paidDate
    FROM bondtypepay bt,  sbsecurities sb
    WHERE bt.bondcode = sb.codeid
    AND sb.symbol = p_ticker AND bt.paymentdate < TO_DATE(p_paidDate, 'DD/MM/RRRR');

    IF l_prev_paidDate IS NULL THEN
      SELECT s.issuedate
      INTO l_prev_paidDate
      FROM sbsecurities s
      WHERE s.symbol = p_ticker;
    END IF;

    l_emailSubject := utf8nums.c_EMAIL_EM14_BONDHOLDER;
    l_emailSubject := replace(l_emailSubject, '[ticker]', p_ticker);
    l_emailSubject := replace(l_emailSubject, '[paiddate]', p_paidDate);

    l_datasource := 'SELECT ''' || p_ticker || ''' ticker, '
                        || '''' || p_paidDate || ''' paidDate, '
                        || '''' || TO_CHAR(l_contractDate, 'DD/MM/RRRR') || ''' contractDate, '
                        || '''' || l_bondName || ''' bondName, '
                        || '''' || l_symbol || ''' symbol, '
                        || '''' || l_gltpp || ''' coupons_and_redemption, '
                        || '''' || l_nd || ''' contain, '
                        || '''' || TO_CHAR(l_expdate, 'DD/MM/RRRR') || ''' expdate, '
                        || '''' || TO_CHAR(l_begindate, 'DD/MM/RRRR') || ''' prevpaidDate, '
                        || '''' || TO_CHAR(l_senddate, 'DD/MM/RRRR') || ''' senddate, '
                        || '''' || TRIM(TO_CHAR(l_total_value, '9,999,999,999,999,999,999,999')) || ''' issvalue, '
                        || '''' || MONTHS_BETWEEN(TO_DATE(TO_CHAR(l_paiddate,'MM/RRRR'),'MM/RRRR'),TO_DATE(TO_CHAR(l_begindate,'MM/RRRR'),'MM/RRRR')) || ''' term, ' --NAMLY 27/03/2020 SHBVNEX-798
                        || '''' || utils.fnc_number2vie(l_total_value) || ''' strvalue, '
                        || '''' || l_intcoupon || ''' intcoupon, '
                        || '''' || l_emailSubject || ''' emailsubject from dual';

    pr_sendInternalEmail(l_datasource,
                        l_template_id,
                        '',
                        'Y');
   END LOOP;
    plog.setEndSection(pkgctx, 'pr_GenTemplateEM14');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_GenTemplateEM14');
  END;

  PROCEDURE pr_GenTemplateEM15 (p_camastId     VARCHAR2,
                               p_txdate        VARCHAR2,
                               p_custodycd     VARCHAR2,
                               p_quantity      NUMBER,
                               p_amount        NUMBER,
                               p_benefit_acct  VARCHAR2,
                               p_desc          VARCHAR2)
  IS
  l_template_id    CHAR(4) := 'EM15';
  l_datasource     VARCHAR2(2000);
  l_reportDate     DATE; -- camast.reportdate
  l_bondsymbol     VARCHAR2(1000); -- camast.symbol
  l_fullName       cfmast.fullname%TYPE;
  l_idCode         VARCHAR2(1000); -- idcode or tradingcode
  l_beginDate      DATE; -- bondtype.begindate
  l_codeid         VARCHAR2(100);
  l_emailSubject   VARCHAR2(1000);
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_GenTemplateEM15');

/*    SELECT reportDate, codeid INTO l_reportDate, l_codeid FROM camast WHERE camastId = p_camastId;
    SELECT fullName, NVL(tradingcode, idcode)
    INTO l_fullName, l_idCode
    FROM cfmast WHERE custodycd = p_custodycd;
    SELECT begindate, bondsymbol INTO l_beginDate, l_bondsymbol FROM bondtype WHERE  bondcode = l_codeid AND actualpaydate = l_reportDate;*/
    --NAM.LY 21/02/2020
    SELECT reportDate, codeid INTO l_reportDate, l_codeid FROM camast WHERE camastId = p_camastId;
    SELECT fullName, NVL(tradingcode, idcode)
    INTO l_fullName, l_idCode
    FROM cfmast WHERE custodycd = p_custodycd;

    begin
        SELECT bt.begindate, sb.symbol bondsymbol
        INTO l_beginDate, l_bondsymbol
        FROM bondtypepay bt, sbsecurities sb
        WHERE  bt.bondcode = sb.codeid
        AND bt.bondcode = l_codeid
        AND bt.actualpaydate = l_reportDate;
    EXCEPTION WHEN OTHERS THEN
        l_beginDate := getcurrdate;
        l_bondsymbol := '';
    end;
    SELECT subject INTO l_emailSubject FROM templates t WHERE code = l_template_id;
    l_emailSubject := replace(l_emailSubject, '[ticker]', l_bondsymbol);
    l_emailSubject := replace(l_emailSubject, '[reportdate]', TO_CHAR(l_reportDate, 'DD/MM/RRRR'));

    l_datasource := 'SELECT ''' || l_bondsymbol || ''' bondsymbol, '
                        || '''' || TO_CHAR(l_reportDate, 'DD/MM/RRRR') || ''' reportdate, '
                        || '''' || TO_CHAR(l_beginDate, 'DD/MM/RRRR') || ''' beginDate, '
                        || '''' || p_txdate || ''' txdate, '
                        || '''' || l_fullName || ''' fullname, '
                        || '''' || l_idCode || ''' idcode, '
                        || '''' || TRIM(TO_CHAR(p_quantity, '9,999,999,999,999,999')) || ''' quantity, '
                        || '''' || p_benefit_acct || ''' benefitacct, '
                        || '''' || TRIM(TO_CHAR(p_amount, '9,999,999,999,999,999')) || ''' amount, '
                        || '''' || p_desc || ''' description, '
                        || '''' || l_emailSubject || ''' emailsubject from dual';

    pr_sendInternalEmail(l_datasource,
                        l_template_id,
                        '',
                        'Y');
    plog.setEndSection(pkgctx, 'pr_GenTemplateEM15');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_GenTemplateEM12');
  END;

  PROCEDURE pr_GenTemplateUnlistedCAExec (p_camastId     VARCHAR2,
                               p_caschdId                VARCHAR2,
                               p_date                    DATE,
                               p_custId                  VARCHAR2,
                               p_acctno                  VARCHAR2,
                               p_taxamt                  NUMBER,
                               p_amt                     NUMBER,
                               p_isTax                   VARCHAR2,
                               p_desc                    VARCHAR2,
                               p_txmsg in tx.msg_rectype)
  IS
  l_template_id    VARCHAR2(10);
  l_datasource     VARCHAR2(2000);
  l_emailSubject   VARCHAR2(1000);
  l_codeid         camast.codeid%TYPE;
  l_catype         camast.catype%TYPE;
  l_symbol         sbsecurities.isincode%TYPE;
  l_issueDate      DATE;
  l_maturitydate   DATE;
  l_rate           NUMBER; --010DEVIDENTRATE 015INTERESTRATE
  l_cifid          cfmast.cifid%TYPE;
  l_cfFullName     cfmast.fullname%TYPE;
  l_refcasaacct    ddmast.refcasaacct%TYPE;
  l_secName        issuers.fullname%TYPE;
  l_periodinterest sbsecurities.periodinterest%TYPE;
  l_periodinterestText VARCHAR2(1000);
  l_tradePlace     sbsecurities.tradeplace%TYPE;
  l_parvalue       sbsecurities.parvalue%TYPE;
  l_interestAmt    NUMBER;
  l_interestdate   sbsecurities.interestdate%TYPE;
  l_intCoupon      sbsecurities.intcoupon%TYPE;
  l_caschdBalance  caschd.balance%TYPE;
  l_caschdQtty     caschd.qtty%TYPE;
  l_caschdAmt      caschd.amt%TYPE;
  l_caschdIntAmt   caschd.intamt%TYPE;
  l_amt     NUMBER;
  l_typeterm VARCHAR2(20);
  l_payment date;
  l_splitrate varchar2(5);
  l_trade number;
  l_depository VARCHAR2(5);
  l_pitrate number;
  l_pitratemethod varchar2(3);
  l_intcash number;
  l_makerid VARCHAR2(20);
  l_apprvid VARCHAR2(20);
  l_maker_name VARCHAR2(100);
  l_apprv_name VARCHAR2(100);
  l_catype_content VARCHAR2(200);
  l_custodycd varchar2(100);
  l_tocodeid VARCHAR2(100);
  l_isincode varchar2(100);
  l_deltd varchar(1);
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_GenTemplateUnlistedCAExec');

    select ca.codeid, ca.catype, decode(ca.catype, '010', ca.devidentrate, ca.interestrate), ca.actiondate,ca.splitrate,ca.pitrate,ca.pitratemethod,
           ca.makerid, ca.apprvid, ca.tocodeid, ca.deltd
    INTO l_codeid, l_catype, l_rate, l_payment,l_splitrate,l_pitrate,l_pitratemethod, l_makerid, l_apprvid, l_tocodeid, l_deltd
    FROM camast ca
    WHERE ca.camastid = p_camastId;

    BEGIN
        SELECT UPPER(EN_CDCONTENT) INTO l_catype_content FROM ALLCODE WHERE CDNAME = 'CATYPE' AND CDTYPE = 'CA' AND CDVAL = l_catype;
    EXCEPTION WHEN OTHERS THEN
        l_catype_content := '';
    END;

    BEGIN
        select sb.isincode into l_isincode
        from sbsecurities sb, issuers iss, allcode a0
        where sb.issuerid=iss.issuerid
        and a0.cdname='TRADEPLACE' and a0.cdtype='OD' and sb.tradeplace=a0.cdval
        and nvl(l_codeid,' ')=sb.codeid(+);   --THANGPV SHBVNEX-2672    l_tocodeid
    EXCEPTION WHEN OTHERS THEN
        l_isincode := '';
    END;

    BEGIN
        SELECT TLFULLNAME INTO l_maker_name FROM TLPROFILES WHERE TLID = p_txmsg.tlid;
    EXCEPTION WHEN OTHERS THEN
        l_maker_name := '  ';
    END;

    BEGIN
        SELECT TLFULLNAME INTO l_apprv_name FROM TLPROFILES WHERE TLID = p_txmsg.offid;
    EXCEPTION WHEN OTHERS THEN
        l_apprv_name := '  ';
    END;

   /* SELECT schd.balance, schd.qtty, schd.amt, schd.intamt, schd.trade,schd.intamt intcash
    INTO l_caschdBalance, l_caschdQtty, l_caschdAmt, l_caschdIntAmt,l_trade,l_intcash
    FROM caschd schd
    WHERE schd.autoid = p_caschdId; */
    --thangpv
    BEGIN
        SELECT schd.balance, schd.qtty, schd.amt, schd.intamt, schd.trade,
        CASE WHEN l_catype = '010' THEN ROUND(NVL(CAD.AMT, schd.AMT)) ELSE ROUND(schd.AMT) END intcash
        INTO l_caschdBalance, l_caschdQtty, l_caschdAmt, l_caschdIntAmt,l_trade,l_intcash
        FROM caschd schd,
        (SELECT CSD1.* FROM CASCHDDTL CSD1 WHERE CSD1.DELTD <> 'Y' AND CSD1.STATUS ='P') CAD
        WHERE schd.AUTOID = CAD.autoid_caschd (+)
        AND schd.afacctno = CAD.afacctno (+)
        and schd.autoid = p_caschdId;
    EXCEPTION WHEN OTHERS THEN
        l_caschdBalance := 0;
        l_caschdQtty := 0;
        l_caschdAmt := 0;
        l_caschdIntAmt := 0;
        l_trade := 0;
        l_intcash := 0;
    END;

    --Thoai.tran 25/01/2020
    --SHBVNEX-1885
    SELECT sb.isincode, iss.fullname, sb.issuedate, sb.expdate, sb.periodinterest,sb.term||' '||al.en_cdcontent,
           sb.tradeplace, sb.parvalue, sb.interestdate, sb.intcoupon,depository
    INTO l_symbol, l_secName, l_issueDate, l_maturitydate, l_periodinterest,l_typeterm,
         l_tradePlace, l_parvalue, l_interestdate, l_intCoupon,l_depository
    FROM sbsecurities sb
    left join
    (select * from allcode where cdname='TYPETERM' and cdtype='SA') al on sb.typeterm=al.cdval
    , issuers iss
    WHERE sb.issuerid = iss.issuerid AND sb.codeid = l_codeid;
    BEGIN
        SELECT dd.refcasaacct, cf.fullname, cf.cifid, cf.custodycd
        INTO l_refcasaacct, l_cfFullName, l_cifid, l_custodycd
        FROM ddmast dd, cfmast cf
        WHERE cf.custid = p_custId AND dd.afacctno = p_acctno
        AND dd.custid = cf.custid AND dd.isdefault='Y';
    EXCEPTION WHEN OTHERS THEN
            l_refcasaacct := ' ';
            l_cfFullName := ' ';
            l_cifid := ' ';
            l_custodycd := ' ';
        END;

    IF l_periodinterest is not null THEN
        SELECT en_cdcontent INTO l_periodinterestText
        FROM allcode
        WHERE CDTYPE = 'CB' AND CDNAME = 'PERIODINTEREST' AND CDUSER='Y'
        AND cdval = l_periodinterest;
        IF l_periodinterest = '001' THEN --   Daily
            l_interestAmt := l_rate * l_parvalue / l_interestdate;
        ELSIF l_periodinterest = '002' THEN -- Monthly
            l_interestAmt := l_rate * l_parvalue * 30 / l_interestdate;
        ELSIF l_periodinterest = '003' THEN -- Every three months
            l_interestAmt := l_rate * l_parvalue * 3 * 30 / l_interestdate;
        ELSIF l_periodinterest = '004' THEN -- Every six months
            l_interestAmt := l_rate * l_parvalue * 6 * 30 / l_interestdate;
        ELSIF l_periodinterest = '005' THEN -- Once a year
            l_interestAmt := l_rate * l_parvalue * 12 * 30 / l_interestdate;
        END IF;
    ELSE
        l_periodinterest:=l_typeterm;
        l_interestAmt:=l_caschdQtty*l_parvalue;
    END IF;

    l_datasource := '';

    --SHBVNEX-1885
    IF NVL(l_tradePlace, '000') = '003' AND NVL(l_depository,'001') <> '001' AND l_deltd = 'N' THEN         --NVL(l_tradePlace, '000') = '003'
        IF NVL(l_catype,'000') IN ('010', '015') AND NVL(l_tradePlace, '000') = '003' THEN
            if l_pitratemethod='IS' then
                l_amt := Round(p_amt);
                l_caschdIntAmt:=Round(l_pitrate*l_caschdIntAmt/100,0);
                --l_amt := p_amt+l_caschdIntAmt;
            else
                l_amt := Round(p_amt);
                --l_caschdIntAmt:=p_taxamt;
                l_caschdIntAmt:=Round(l_pitrate*l_caschdIntAmt/100,0);
            end if;
            IF l_catype = '010' and l_periodinterest is not null and l_rate is not null THEN
                l_template_id := 'EM27';
            ELSE
                l_template_id := 'EM26';
            END IF;

            if l_amt > 0 then

                l_datasource := 'SELECT ''' || l_symbol || ''' symbol, '
                                  || '''' || l_secName || ''' secname, '
                                  || '''' || TO_CHAR(TO_DATE(l_issueDate, 'DD/MM/RRRR'), 'DD/MM/RRRR') || ''' issuedate, '
                                  || '''' || TO_CHAR(TO_DATE(l_maturitydate, 'DD/MM/RRRR'), 'DD/MM/RRRR') || ''' maturitydate, '
                                  || '''' || l_rate || ''' rate, '
                                  || '''' || l_periodinterestText || ''' periodinterest, '
                                  || '''' || TO_CHAR(UTILS.SO_THANH_CHU(l_parvalue)) || ''' parvalue, '
                                  || '''' || l_cifid || ''' cifid, '
                                  || '''' || l_cfFullName || ''' cffullname, '
                                  || '''' || TO_CHAR(UTILS.SO_THANH_CHU(l_caschdBalance)) || ''' quantity, '
                                  || '''' || TO_CHAR(UTILS.SO_THANH_CHU(l_amt)) || ''' interestamt, '
                                  || '''' || TO_CHAR(UTILS.SO_THANH_CHU(l_caschdBalance*l_parvalue)) || ''' intcash, '
                                  || '''' || TO_CHAR(UTILS.SO_THANH_CHU(l_caschdIntAmt)) || ''' taxamt, '
                                  || '''' || TO_CHAR(UTILS.SO_THANH_CHU(l_caschdBalance*l_parvalue)) || ''' buyamt, '
                                  || '''' || TO_CHAR(UTILS.SO_THANH_CHU(l_amt-l_caschdIntAmt)) || ''' receiveamt, '
                                  || '''' || l_refcasaacct || ''' refcasaacct, '
                                  || '''' || TO_CHAR(TO_DATE(p_date, 'DD/MM/RRRR'), 'DD/MM/RRRR') || ''' p_date, '
                                  || '''' || l_maker_name || ''' l_maker_name, '
                                  || '''' || l_apprv_name || ''' l_apprv_name, '
                                  || '''' || l_isincode || ''' isincode, '
                                  || '''' || l_catype_content || ''' cacontent, '
                                  || '''' || p_desc || ''' p_desc '
                                  || ' from dual';
            end if;
        ELSIF l_catype = '033' AND l_tradePlace = '003'  THEN  --AND l_tradePlace = '003'
            l_template_id := 'EM24';
            if l_pitratemethod='IS' then
                l_caschdIntAmt:=Round(l_pitrate*l_caschdIntAmt/100,0);
                l_amt := Round(p_amt)+l_caschdIntAmt;
            else
                l_amt := Round(p_amt);
                --l_caschdIntAmt:=p_taxamt;
                l_caschdIntAmt:=Round(l_pitrate*l_caschdIntAmt/100,0);
            end if;

            l_intcash := ROUND(l_intcash);
            l_caschdAmt := ROUND(l_caschdAmt);
            if l_intcash > 0 then
                l_datasource := 'SELECT ''' || l_symbol || ''' symbol, '
                                  || '''' || l_secName || ''' issuername, '
                                  || '''' || TO_CHAR(TO_DATE(l_issueDate, 'DD/MM/RRRR'), 'DD/MM/RRRR') || ''' issuerdate, '
                                  || '''' || TO_CHAR(TO_DATE(l_maturitydate, 'DD/MM/RRRR'), 'DD/MM/RRRR') || ''' maturitydate, '
                                  || '''' || l_splitrate || ''' intcoupon, '
                                  || '''' || l_periodinterestText || ''' periodinterest, '
                                  || '''' || TO_CHAR(UTILS.SO_THANH_CHU(l_parvalue)) || ''' parvalue, '
                                  || '''' || l_cifid || ''' cifid, '
                                  || '''' || l_cfFullName || ''' fullname, '
                                  || '''' || TO_CHAR(UTILS.SO_THANH_CHU(l_caschdIntAmt)) || ''' taxamt, '
                                  || '''' || TO_CHAR(UTILS.SO_THANH_CHU(l_intcash-l_caschdIntAmt)) || ''' receiveamt, '
                                  || '''' || TO_CHAR(UTILS.SO_THANH_CHU(l_caschdBalance)) || ''' totalquantity, '
                                  || '''' || TO_CHAR(UTILS.SO_THANH_CHU(l_trade)) || ''' buypackqtty, '
                                  || '''' || TO_CHAR(UTILS.SO_THANH_CHU(l_caschdAmt-l_intcash)) || ''' buyamt, '
                                  || '''' || TO_CHAR(UTILS.SO_THANH_CHU(l_intcash)) || ''' interestamt, '
                                  || '''' || TO_CHAR(UTILS.SO_THANH_CHU(l_caschdAmt-l_caschdIntAmt)) || ''' totalamt, '
                                  || '''' || l_refcasaacct || ''' refcasaacct, '
                                  || '''' || TO_CHAR(TO_DATE(p_date, 'DD/MM/RRRR'), 'DD/MM/RRRR') || ''' p_date, '
                                  || '''' || l_maker_name || ''' l_maker_name, '
                                  || '''' || l_apprv_name || ''' l_apprv_name, '
                                  || '''' || l_isincode || ''' isincode, '
                                  || '''' || l_catype_content || ''' cacontent, '
                                  || '''' || p_desc || ''' p_desc '
                                  || ' from dual';
              end if;
        ELSIF l_catype = '016' AND l_tradePlace = '003' THEN
            l_template_id := 'EM25';
            if l_pitratemethod='IS' then
                l_caschdIntAmt:=Round(l_pitrate*l_caschdIntAmt/100,0);
                l_amt := Round(p_amt)+l_caschdIntAmt;
            else
                l_amt := Round(p_amt);
                l_caschdIntAmt:=Round(l_pitrate*l_caschdIntAmt/100,0);
                --l_caschdIntAmt:=p_taxamt;
            end if;
            l_caschdAmt := ROUND(l_caschdAmt);

            if l_intcash > 0 then
                l_datasource := 'SELECT ''' || l_symbol || ''' symbol, '
                                || '''' || l_secName || ''' secname, '
                                || '''' || TO_CHAR(TO_DATE(l_issueDate, 'dd/mm/rrrr'), 'DD/MM/RRRR') || ''' issuedate, '
                                || '''' || TO_CHAR(TO_DATE(l_maturitydate, 'dd/mm/rrrr'), 'DD/MM/RRRR') || ''' maturitydate, '
                                || '''' || l_rate || ''' rate, '
                                || '''' || l_periodinterestText || ''' periodinterest, '
                                || '''' || TO_CHAR(UTILS.SO_THANH_CHU(l_parvalue)) || ''' parvalue, '
                                || '''' || l_cifid || ''' cifid, '
                                || '''' || l_cfFullName || ''' cffullname, '
                                || '''' || TO_CHAR(UTILS.SO_THANH_CHU(l_caschdBalance)) || ''' quantity, '
                                || '''' || TO_CHAR(UTILS.SO_THANH_CHU(l_caschdBalance * l_parvalue)) || ''' orgamount, '
                                || '''' || TO_CHAR(UTILS.SO_THANH_CHU(l_intcash)) || ''' interestamt, '
                                || '''' || TO_CHAR(UTILS.SO_THANH_CHU(l_caschdIntAmt)) || ''' taxamt, '
                                || '''' || TO_CHAR(UTILS.SO_THANH_CHU(l_caschdAmt-l_intcash)) || ''' buyamt, '
                                || '''' || TO_CHAR(UTILS.SO_THANH_CHU(l_intcash-l_caschdIntAmt)) || ''' receiveamt, '
                                || '''' || TO_CHAR(UTILS.SO_THANH_CHU(l_caschdBalance * l_parvalue)) || ''' redemptionamt, '
                                || '''' || TO_CHAR(UTILS.SO_THANH_CHU(l_caschdAmt-l_caschdIntAmt)) || ''' totalamount, '
                                || '''' || l_refcasaacct || ''' refcasaacct, '
                                || '''' || TO_CHAR(TO_DATE(p_date, 'DD/MM/RRRR'), 'DD/MM/RRRR') || ''' p_date, '
                                || '''' || l_emailSubject || ''' emailsubject, '
                                || '''' || l_maker_name || ''' l_maker_name, '
                                || '''' || l_apprv_name || ''' l_apprv_name, '
                                || '''' || l_catype_content || ''' cacontent, '
                                || '''' || l_isincode || ''' isincode, '
                                || '''' || p_desc || ''' p_desc '
                                || ' from dual';
            end if;
        END IF;
    END IF;
    IF length(l_datasource) > 0 THEN
        pr_sendInternalEmail(l_datasource, l_template_id, p_acctno, 'Y');
    END IF;
    plog.setEndSection(pkgctx, 'pr_GenTemplateUnlistedCAExec '|| p_caschdId);
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_GenTemplateUnlistedCAExec ' || p_caschdId);
  END;

  PROCEDURE pr_GenTemplateWarningLtv (p_issuesid        VARCHAR2,
                                     p_txdate           DATE,
                                     p_ltvRate          NUMBER,
                                     p_ltvWarningRate   NUMBER,
                                     p_template_id      VARCHAR2,
                                     p_email_subject    VARCHAR2)
  IS
  l_template_id    CHAR(6) := p_template_id;
  l_datasource     VARCHAR2(4000);
  l_emailSubject   VARCHAR2(1000);
  l_symbol         sbsecurities.symbol%TYPE;
  l_issuerName     issuers.fullname%TYPE;
  l_issuerName_eng issuers.fullname%TYPE;
  l_issuerDate     DATE;
  l_maturityDate   DATE;
  l_issAmt         NUMBER;
  l_intcoupon      sbsecurities.intcoupon%TYPE;
  l_list_bond      CLOB;
  l_typerate       VARCHAR2(20);
  l_numcheck       number;
  l_idprice          VARCHAR2(20);
  l_idrate      VARCHAR2(2000);
  l_LTVCCR      VARCHAR2(2000);
  l_LTCR      VARCHAR2(20);
  l_LTVCCR_ENG      VARCHAR2(2000);
  l_LTCR_ENG     VARCHAR2(2000);
  l_TP      VARCHAR2(2000);
  l_CP      VARCHAR2(2000);
  l_listsymbol  VARCHAR2(2000);
  l_listsymbol_eng  VARCHAR2(2000);
  V_CHECK   NUMBER;
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_GenTemplateWarningLtv');
    --KIEM TRA LOAI TEMPLATE
    l_template_id := trim(l_template_id);
    IF l_template_id IN ('EM16','EM17') THEN-----------------------------------------------------------------------------------------------------------------

    SELECT T.FULLNAME, LISTAGG(T.CONTENT, '<br/>') WITHIN GROUP (ORDER BY T.AUTOID, T.ISSUERID, T.ISSUECODE, T.FULLNAME, T.LTVRATE, T.WARNINGLTVRATE) LIST_BOND
    INTO l_issuerName, l_list_bond
    FROM (
            SELECT ISS.AUTOID, ISS.ISSUERID,ISS.ISSUECODE, ISR.FULLNAME, TO_CHAR(ISS.LTVRATE,'99990D99') LTVRATE, TO_CHAR(ISS.WARNINGLTVRATE,'99990D99') WARNINGLTVRATE, BI.BONDSYMBOL,
                '<div class="boldcss">' || MAX(CASE WHEN A1.CDVAL = 'SYMBOL' THEN A1.CDCONTENT || ' ' || BI.BONDSYMBOL ELSE '' END)||'</div>'
                || '<table>'
                || '<tr>' || '<td>' ||'- '|| MAX(CASE WHEN A1.CDVAL = 'ISSUEDATE' THEN A1.CDCONTENT ELSE '' END) || ':' || '</td>'
                          || '<td>' || MAX(TO_CHAR(ISS.ISSUEDATE,'DD/MM/RRRR')) || '</td>' || '</tr>'
                || '<tr>' || '<td>' ||'- '|| MAX(CASE WHEN A1.CDVAL = 'MATURITYDATE' THEN A1.CDCONTENT ELSE '' END) || ':' || '</td>'
                          || '<td>' || MAX(TO_CHAR(SB.EXPDATE,'DD/MM/RRRR')) || '</td>' || '</tr>'
                || '<tr>' || '<td>' ||'- '|| MAX(CASE WHEN A1.CDVAL = 'AMOUNT' THEN A1.CDCONTENT ELSE '' END) || ':' || '</td>'
                          || '<td>' || MAX(REPLACE(TO_CHAR(UTILS.SO_THANH_CHU(NVL(BI.ISSUEVAL,0))),',','.'))
                || ' ('||MAX(utils.fnc_number2vie(NVL(BI.ISSUEVAL,0))) || ')</td>' || '</tr>'
                || '<tr>' || '<td>' ||'- '|| MAX(CASE WHEN A1.CDVAL = 'INTRATE' THEN A1.CDCONTENT ELSE '' END) || ':' || '</td>'
                          || '<td>' || MAX(REPLACE(TO_CHAR(BI.INTRATE,'99990D99'),'.',','))
                || ' ' || MAX(CASE WHEN A1.CDVAL = 'INTRATE_UNIT' THEN A1.CDCONTENT ELSE '' END) || '</td>' || '</tr>'
                || '</table>' CONTENT
            FROM ISSUES ISS
                 JOIN (SELECT * FROM ALLCODE WHERE CDNAME='EM16') A1 ON 1=1
                 JOIN BONDISSUE BI ON ISS.AUTOID = BI.ISSUESID
                 JOIN SBSECURITIES SB ON SB.CODEID = BI.BONDCODE
                 JOIN ISSUERS ISR ON ISR.ISSUERID = ISS.ISSUERID
            WHERE  ISS.AUTOID = p_issuesid --filter
            GROUP BY ISS.AUTOID, ISS.ISSUERID,ISS.ISSUECODE, ISR.FULLNAME, ISS.LTVRATE, ISS.WARNINGLTVRATE, BI.BONDSYMBOL
         ) T
    GROUP BY T.AUTOID, T.ISSUERID, T.ISSUECODE, T.FULLNAME, T.LTVRATE, T.WARNINGLTVRATE;
    -- TriBui 27/07/2020 Them de check tang/giam :
    SELECT
            ISS.TYPERATE,
            CASE
                WHEN ISS.TYPERATE ='002' THEN ISS.WARNINGLTVRATE - 3
                WHEN ISS.TYPERATE ='003' THEN ISS.MAXLTVRATE +3
                ELSE 0
            END NUM_CHECK
    INTO L_TYPERATE,L_NUMCHECK
    FROM ISSUES ISS
    WHERE  ISS.AUTOID = p_issuesid ;--filter
    --Kiem tra tang giam
    IF L_TYPERATE = '002' AND P_LTVRATE >= L_NUMCHECK THEN
    --GIA GIAM, LTV TANG
        SELECT CDCONTENT INTO l_idprice FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='0021PRICE';
        SELECT CDCONTENT INTO l_idrate FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='0021RATE';
    ELSIF L_TYPERATE = '002' AND P_LTVRATE < L_NUMCHECK THEN
    --GIA TANG, LTV GIAM
        SELECT CDCONTENT INTO l_idprice FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='0022PRICE';
        SELECT CDCONTENT INTO l_idrate FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='0022RATE';
    ELSIF L_TYPERATE = '003' AND P_LTVRATE >= L_NUMCHECK THEN
    --GIA TANG, CCR TANG
        SELECT CDCONTENT INTO l_idprice FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='0031PRICE';
        SELECT CDCONTENT INTO l_idrate FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='0031RATE';
    ELSIF L_TYPERATE = '003' AND P_LTVRATE < L_NUMCHECK THEN
    --GIA GIAM, CCR GIAM
        SELECT CDCONTENT INTO l_idprice FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='0032PRICE';
        SELECT CDCONTENT INTO l_idrate FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='0032RATE';
    END IF;
    --Loai LTV/CCR--------------------------------------------------------------------------------
    IF L_TYPERATE = '002' THEN
        SELECT CDCONTENT,EN_CDCONTENT INTO l_LTVCCR,l_LTVCCR_ENG FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='002';
        SELECT CDCONTENT INTO l_LTCR FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='LTV';
    ELSIF L_TYPERATE = '003' THEN
        SELECT CDCONTENT,EN_CDCONTENT INTO l_LTVCCR,l_LTVCCR_ENG FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='003';
        SELECT CDCONTENT,EN_CDCONTENT INTO l_LTCR,l_LTCR_ENG FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='CCR';
    END IF;
    --LIST SYMBOL TP,CP--------------------------------------------------------------------------------
    SELECT NVL("'TP'",'X') ,NVL("'CP'",'X')
    INTO L_TP,L_CP
    FROM
    (
    SELECT SECTYPE,LISTAGG(SYMBOL, ', ') WITHIN GROUP (ORDER BY SECTYPE) LISTSYMBOL
    FROM
    (
        SELECT SB.SYMBOL,CASE WHEN SB.SECTYPE IN ('003','006') THEN 'TP' ELSE 'CP' END SECTYPE
        FROM
        (
            SELECT DISTINCT TRIM(REGEXP_SUBSTR(BO.TICKERLIST,'[^,]+', 1, LEVEL)) BOTICKER
            FROM BONDTYPE BO
            WHERE BO.ISSUESID = p_issuesid
            CONNECT BY REGEXP_SUBSTR(BO.TICKERLIST, '[^,]+', 1, LEVEL) IS NOT NULL
        )BO , SBSECURITIES SB
        WHERE BO.BOTICKER =SB.SYMBOL
    )
    GROUP BY SECTYPE
    )
    PIVOT
    (
        MAX (LISTSYMBOL)
        FOR SECTYPE IN ('TP','CP')
    );
    
    -- CHECK CP/TP
    IF LENGTH(L_CP) > 1 AND LENGTH(L_TP) > 1 THEN
        SELECT A1.CDCONTENT||' '|| L_CP||'/'||A2.CDCONTENT||' '|| L_TP
        INTO l_listsymbol
        FROM ALLCODE A1, ALLCODE A2
        WHERE A1.CDNAME ='EM17' AND A1.CDVAL IN ('CP') AND A2.CDNAME ='EM17' AND A2.CDVAL IN ('TP');
     ELSIF LENGTH(L_TP) = 1 AND LENGTH(L_CP) > 1 THEN
        SELECT A1.CDCONTENT||' '|| L_CP
        INTO l_listsymbol
        FROM ALLCODE A1
        WHERE A1.CDNAME ='EM17' AND A1.CDVAL IN ('CP');
     ELSIF LENGTH(L_TP) > 1 AND LENGTH(L_CP) = 1 THEN
        SELECT A1.CDCONTENT||' '|| L_TP
        INTO l_listsymbol
        FROM ALLCODE A1
        WHERE A1.CDNAME ='EM17' AND A1.CDVAL IN ('TP');
     END IF;
     
    --end TriBui 27/07/2020:
    l_emailSubject := p_email_subject;
    l_emailSubject := replace(l_emailSubject, '[issuername]', l_issuerName);
    l_emailSubject := replace(l_emailSubject, '[txdate]', p_txdate);

    l_datasource := 'SELECT ''' || l_issuerName || ''' issuername, '
                        || '''' || TO_CHAR(p_txdate, 'DD/MM/RRRR') || ''' txdate, '
                        || '''' || TO_CHAR(p_txdate, 'DD') || ''' dd, '
                        || '''' || TO_CHAR(p_txdate, 'MM') || ''' mm, '
                        || '''' || TO_CHAR(p_txdate, 'RRRR') || ''' yyyy, '
                        || '''' || l_list_bond || ''' list_bond, '
                        || '''' || REPLACE(TO_CHAR(p_ltvRate),'.',',') || ''' ltvrate, '
                        || '''' || REPLACE(TO_CHAR(p_ltvWarningRate),'.',',') || ''' warningrate, '
                        || '''' || l_idprice || ''' idprice, '
                        || '''' || l_idrate || ''' idrate, '
                        || '''' || l_LTVCCR || ''' ltvccr, '
                        || '''' || l_LTCR || ''' ltcr, '
                        || '''' || l_listsymbol || ''' list_symbol, '
                        || '''' || l_emailSubject || ''' emailsubject from dual';

    pr_sendInternalEmail(l_datasource,
                        trim(l_template_id),
                        '',
                        'Y');
    ELSIF l_template_id IN ('EM16EN','EM17EN') THEN-----------------------------------------------------------------------------------------------------------------

    SELECT T.FULLNAME,T.EN_FULLNAME, LISTAGG(T.CONTENT, '<br/>') WITHIN GROUP (ORDER BY T.AUTOID, T.ISSUERID, T.ISSUECODE, T.FULLNAME, T.LTVRATE, T.WARNINGLTVRATE) LIST_BOND
    INTO l_issuerName,l_issuerName_ENG, l_list_bond
    FROM (
            SELECT ISS.AUTOID, ISS.ISSUERID,ISS.ISSUECODE, ISR.FULLNAME,ISR.EN_FULLNAME, TO_CHAR(ISS.LTVRATE,'99990D99') LTVRATE, TO_CHAR(ISS.WARNINGLTVRATE,'99990D99') WARNINGLTVRATE, BI.BONDSYMBOL,
                '<div class="boldcss">' || MAX(CASE WHEN A1.CDVAL = 'SYMBOL' THEN A1.CDCONTENT || ' ' || BI.BONDSYMBOL || '</div>'
                ||'<div class="boldcss">' || BI.BONDSYMBOL || ' ' || A1.EN_CDCONTENT ELSE '' END)||'</div>'
                ||'<table>'
                ||'<tr>'
                    ||'<td>'
                        ||'<div class="margintopcontent">- ' || MAX(CASE WHEN A1.CDVAL = 'ISSUEDATE' THEN A1.CDCONTENT || ':</div>'
                        ||'<div>- '||A1.EN_CDCONTENT  ELSE '' END) || ':' ||'</td>'
                    ||'<td>'||MAX(TO_CHAR(ISS.ISSUEDATE,'DD/MM/RRRR'))||'</td>'
                ||'</tr>'
                ||'<tr>'
                    ||'<td>'
                        ||'<div class="margintopcontent">- ' || MAX(CASE WHEN A1.CDVAL = 'MATURITYDATE' THEN A1.CDCONTENT|| ':</div>'
                        ||'<div>- '||A1.EN_CDCONTENT ELSE '' END) || ':</div>'
                    ||'</td>'
                    ||'<td>'|| MAX(TO_CHAR(SB.EXPDATE,'DD/MM/RRRR')) ||'</td>'
                ||'</tr>'
                ||'<tr>'
                    ||'<td><div class="margintopcontent">- Par value:</div></td>'
                    ||'<td><div>VND 1.000.000.000 per bond</div></td>'
                ||'</tr>'
                ||'<tr>'
                    ||'<td>'
                        ||'<div class="margintopcontent">- ' || MAX(CASE WHEN A1.CDVAL = 'AMOUNT' THEN A1.CDCONTENT || ':</div>'
                        ||'<div>- '||A1.EN_CDCONTENT ELSE '' END) || ':</div>'
                    ||'</td>'
                    ||'<td>'
                        ||'<div class="margintopcontent">' || MAX(REPLACE(TO_CHAR(UTILS.SO_THANH_CHU(NVL(BI.ISSUEVAL,0))),',','.')) || MAX(CASE WHEN A1.CDVAL = 'AMOUNT_UNIT' THEN ' ' || A1.CDCONTENT ELSE '' END) || ' (' ||MAX(utils.fnc_number2vie(NVL(BI.ISSUEVAL,0))) || ')' || '</div>'
                        ||'<div>VND ' || MAX(utils.SO_THANH_CHU2(NVL(BI.ISSUEVAL,0))) || ' (' ||MAX(utils.fnc_number2work(NVL(BI.ISSUEVAL,0))) || ' dong)</div>'
                    ||'</td>'
                ||'</tr>'
                ||'<tr>'
                    ||'<td>'
                        ||'<div class="margintopcontent">- ' || MAX(CASE WHEN A1.CDVAL = 'INTRATE' THEN A1.CDCONTENT|| ':</div>'
                        ||'<div>- '||A1.EN_CDCONTENT ELSE '' END) || ':</div>'
                    ||'</td>'
                    ||'<td>'
                        ||'<div class="margintopcontent">' || MAX(REPLACE(TO_CHAR(BI.INTRATE,'99990D99'),'.',','))|| ' ' || MAX(CASE WHEN A1.CDVAL = 'INTRATE_UNIT' THEN A1.CDCONTENT ELSE '' END) ||'</div>'
                        ||'<div>' || MAX(REPLACE(TO_CHAR(BI.INTRATE,'99990D99'),',','.'))|| ' ' || MAX(CASE WHEN A1.CDVAL = 'INTRATE_UNIT' THEN A1.EN_CDCONTENT ELSE '' END) ||'</div>'
                    ||'</td>'
                || '</tr>'
                || '</table>' CONTENT
            FROM ISSUES ISS
                 JOIN (SELECT * FROM ALLCODE WHERE CDNAME='EM16') A1 ON 1=1
                 JOIN BONDISSUE BI ON ISS.AUTOID = BI.ISSUESID
                 JOIN SBSECURITIES SB ON SB.CODEID = BI.BONDCODE
                 JOIN ISSUERS ISR ON ISR.ISSUERID = ISS.ISSUERID
            WHERE  ISS.AUTOID = p_issuesid --filter
            GROUP BY ISS.AUTOID, ISS.ISSUERID,ISS.ISSUECODE, ISR.FULLNAME,ISR.EN_FULLNAME, ISS.LTVRATE, ISS.WARNINGLTVRATE, BI.BONDSYMBOL
         ) T
    GROUP BY T.AUTOID, T.ISSUERID, T.ISSUECODE, T.FULLNAME,T.EN_FULLNAME, T.LTVRATE, T.WARNINGLTVRATE;
    -- TriBui 27/07/2020 Them de check tang/giam :
    SELECT
            ISS.TYPERATE,
            CASE
                WHEN ISS.TYPERATE ='002' THEN ISS.WARNINGLTVRATE - 3
                WHEN ISS.TYPERATE ='003' THEN ISS.MAXLTVRATE +3
                ELSE 0
            END NUM_CHECK
    INTO L_TYPERATE,L_NUMCHECK
    FROM ISSUES ISS
    WHERE  ISS.AUTOID = p_issuesid ;--filter
    --Kiem tra tang giam
    IF L_TYPERATE = '002' AND P_LTVRATE >= L_NUMCHECK THEN
    --GIA GIAM, LTV TANG
        SELECT CDCONTENT INTO l_idprice FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='0021PRICE';
        SELECT CDCONTENT INTO l_idrate FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='0021RATE';
    ELSIF L_TYPERATE = '002' AND P_LTVRATE < L_NUMCHECK THEN
    --GIA TANG, LTV GIAM
        SELECT CDCONTENT INTO l_idprice FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='0022PRICE';
        SELECT CDCONTENT INTO l_idrate FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='0022RATE';
    ELSIF L_TYPERATE = '003' AND P_LTVRATE >= L_NUMCHECK THEN
    --GIA TANG, CCR TANG
        SELECT CDCONTENT INTO l_idprice FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='0031PRICE';
        SELECT CDCONTENT INTO l_idrate FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='0031RATE';
    ELSIF L_TYPERATE = '003' AND P_LTVRATE < L_NUMCHECK THEN
    --GIA GIAM, CCR GIAM
        SELECT CDCONTENT INTO l_idprice FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='0032PRICE';
        SELECT CDCONTENT INTO l_idrate FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='0032RATE';
    END IF;
    --Loai LTV/CCR--------------------------------------------------------------------------------
    IF L_TYPERATE = '002' THEN
        SELECT CDCONTENT,EN_CDCONTENT INTO l_LTVCCR,l_LTVCCR_ENG FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='002';
        SELECT CDCONTENT INTO l_LTCR FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='LTV';
        SELECT EN_CDCONTENT INTO l_LTCR_ENG FROM ALLCODE WHERE CDNAME =l_template_id AND CDVAL ='LTV';
    ELSIF L_TYPERATE = '003' THEN
        SELECT CDCONTENT,EN_CDCONTENT INTO l_LTVCCR,l_LTVCCR_ENG FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='003';
        SELECT CDCONTENT INTO l_LTCR FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='CCR';
        SELECT EN_CDCONTENT INTO l_LTCR_ENG FROM ALLCODE WHERE CDNAME =l_template_id AND CDVAL ='CCR';
    END IF;
    --LIST SYMBOL TP,CP--------------------------------------------------------------------------------
    SELECT NVL("'TP'",'X') ,NVL("'CP'",'X')
    INTO L_TP,L_CP
    FROM
    (
    SELECT SECTYPE,LISTAGG(SYMBOL, ', ') WITHIN GROUP (ORDER BY SECTYPE) LISTSYMBOL
    FROM
    (
        SELECT SB.SYMBOL,CASE WHEN SB.SECTYPE IN ('003','006') THEN 'TP' ELSE 'CP' END SECTYPE
        FROM
        (
            SELECT DISTINCT TRIM(REGEXP_SUBSTR(BO.TICKERLIST,'[^,]+', 1, LEVEL)) BOTICKER
            FROM BONDTYPE BO
            WHERE BO.ISSUESID = p_issuesid
            CONNECT BY REGEXP_SUBSTR(BO.TICKERLIST, '[^,]+', 1, LEVEL) IS NOT NULL
        )BO , SBSECURITIES SB
        WHERE BO.BOTICKER =SB.SYMBOL
    )
    GROUP BY SECTYPE
    )
    PIVOT
    (
        MAX (LISTSYMBOL)
        FOR SECTYPE IN ('TP','CP')
    );
    
    -- CHECK CP/TP
    IF LENGTH(L_CP) > 1 AND LENGTH(L_TP) > 1 THEN
        SELECT A1.CDCONTENT||' '|| L_CP||'/'||A2.CDCONTENT||' '|| L_TP,
        L_CP||' '||A1.EN_CDCONTENT|| '/ '|| L_TP||' '||A2.EN_CDCONTENT
        INTO l_listsymbol,l_listsymbol_eng
        FROM ALLCODE A1, ALLCODE A2
        WHERE A1.CDNAME ='EM17' AND A1.CDVAL IN ('CP') AND A2.CDNAME ='EM17' AND A2.CDVAL IN ('TP');
     ELSIF LENGTH(L_TP) = 1 AND LENGTH(L_CP) > 1 THEN
        SELECT A1.CDCONTENT||' '|| L_CP,L_CP||' '||A1.EN_CDCONTENT
        INTO l_listsymbol,l_listsymbol_eng
        FROM ALLCODE A1
        WHERE A1.CDNAME ='EM17' AND A1.CDVAL IN ('CP');
     ELSIF LENGTH(L_TP) > 1 AND LENGTH(L_CP) = 1 THEN
        SELECT A1.CDCONTENT||' '|| L_TP,L_TP||' '||A1.EN_CDCONTENT
        INTO l_listsymbol,l_listsymbol_eng
        FROM ALLCODE A1
        WHERE A1.CDNAME ='EM17' AND A1.CDVAL IN ('TP');
     END IF;
     
    --end TriBui 27/07/2020:
    l_emailSubject := p_email_subject;
    l_emailSubject := replace(l_emailSubject, '[issuername]', l_issuerName);
    l_emailSubject := replace(l_emailSubject, '[issuername_en]', l_issuerName_eng);
    l_emailSubject := replace(l_emailSubject, '[txdate]', to_char(p_txdate,'dd.MM.RRRR'));

        l_datasource := 'SELECT ''' || l_issuerName || ''' issuername, '
                        || '''' || l_issuerName_eng || ''' issuername_en, '
                        || '''' || TO_CHAR(p_txdate, 'DD/MM/RRRR') || ''' txdate, '
                        || '''' || TO_CHAR(p_txdate, 'DD') || ''' dd, '
                        || '''' || TO_CHAR(p_txdate, 'MM') || ''' mm, '
                        || '''' || TO_CHAR(p_txdate, 'RRRR') || ''' yyyy, '
                        || '''' || TRIM(TO_CHAR(p_txdate, 'Month'))||' '||Trim(TO_CHAR(p_txdate, 'dd, RRRR')) || ''' date_en, '
                        || '''' || l_list_bond || ''' list_bond, '
                        || '''' || REPLACE(TO_CHAR(p_ltvRate),'.',',') || ''' ltvrate, '
                        || '''' || REPLACE(TO_CHAR(p_ltvRate),',','.') || ''' ltvrate_en, '
                        || '''' || REPLACE(TO_CHAR(p_ltvWarningRate),'.',',') || ''' warningrate, '
                        || '''' || REPLACE(TO_CHAR(p_ltvWarningRate),',','.') || ''' warningrate_en, '
                        || '''' || l_idprice || ''' idprice, '
                        || '''' || l_idrate || ''' idrate, '
                        || '''' || l_LTVCCR || ''' ltvccr, '
                        || '''' || l_LTVCCR_ENG || ''' ltvccr_en, '
                        || '''' || l_LTCR || ''' ltcr, '
                        || '''' || l_LTCR_ENG || ''' ltcr_en, '
                        || '''' || l_listsymbol || ''' list_symbol, '
                        || '''' || l_listsymbol_eng || ''' list_symbol_en, '
                        || '''' || l_emailSubject || ''' emailsubject from dual';

    pr_sendInternalEmail(l_datasource,
                        trim(l_template_id),
                        '',
                        'Y');
     ELSIF l_template_id IN ('EM18EN') THEN--------------------------------------------------------------------------------------------------------------------
    --KIEM TRA NEU NGAY DINH KY GUI MAIL >= NGAY DAO HAN TRAI PHIEU THI KH?NG GUI MAIL
    SELECT COUNT(*) INTO V_CHECK
    FROM ISSUES ISS
        JOIN (SELECT * FROM ALLCODE WHERE CDNAME='EM16') A1 ON 1=1
        JOIN BONDISSUE BI ON ISS.AUTOID = BI.ISSUESID
        JOIN SBSECURITIES SB ON SB.CODEID = BI.BONDCODE
        JOIN ISSUERS ISR ON ISR.ISSUERID = ISS.ISSUERID
    WHERE  ISS.AUTOID = p_issuesid AND GETCURRDATE < SB.EXPDATE;

    IF V_CHECK > 0 THEN

        SELECT T.FULLNAME,T.EN_FULLNAME, LISTAGG(T.CONTENT, '<br/>') WITHIN GROUP (ORDER BY T.AUTOID, T.ISSUERID, T.ISSUECODE, T.FULLNAME, T.LTVRATE, T.WARNINGLTVRATE) LIST_BOND
        INTO l_issuerName,l_issuerName_eng, l_list_bond
        FROM (
                SELECT ISS.AUTOID, ISS.ISSUERID,ISS.ISSUECODE, ISR.FULLNAME,ISR.EN_FULLNAME, TO_CHAR(ISS.LTVRATE,'99990D99') LTVRATE, TO_CHAR(ISS.WARNINGLTVRATE,'99990D99') WARNINGLTVRATE, BI.BONDSYMBOL,
                  '<div class="boldcss">' || MAX(CASE WHEN A1.CDVAL = 'SYMBOL' THEN A1.CDCONTENT || ' ' || BI.BONDSYMBOL || '</div>'
                ||'<div class="boldcss">' || BI.BONDSYMBOL || ' ' || A1.EN_CDCONTENT ELSE '' END)||'</div>'
                ||'<table>'
                ||'<tr>'
                    ||'<td>'
                        ||'<div class="margintopcontent">- ' || MAX(CASE WHEN A1.CDVAL = 'ISSUEDATE' THEN A1.CDCONTENT || ':</div>'
                        ||'<div>- '||A1.EN_CDCONTENT  ELSE '' END) || ':' ||'</td>'
                    ||'<td>'||MAX(TO_CHAR(ISS.ISSUEDATE,'DD/MM/RRRR'))||'</td>'
                ||'</tr>'
                ||'<tr>'
                    ||'<td>'
                        ||'<div class="margintopcontent">- ' || MAX(CASE WHEN A1.CDVAL = 'MATURITYDATE' THEN A1.CDCONTENT|| ':</div>'
                        ||'<div>- '||A1.EN_CDCONTENT ELSE '' END) || ':</div>'
                    ||'</td>'
                    ||'<td>'|| MAX(TO_CHAR(SB.EXPDATE,'DD/MM/RRRR')) ||'</td>'
                ||'</tr>'
                ||'<tr>'
                    ||'<td><div class="margintopcontent">- Par value:</div></td>'
                    ||'<td><div>VND 1.000.000.000 per bond</div></td>'
                ||'</tr>'
                ||'<tr>'
                    ||'<td>'
                        ||'<div class="margintopcontent">- ' || MAX(CASE WHEN A1.CDVAL = 'AMOUNT' THEN A1.CDCONTENT || ':</div>'
                        ||'<div>- '||A1.EN_CDCONTENT ELSE '' END) || ':</div>'
                    ||'</td>'
                    ||'<td>'
                        ||'<div class="margintopcontent">' || MAX(REPLACE(TO_CHAR(UTILS.SO_THANH_CHU(NVL(BI.ISSUEVAL,0))),',','.')) || MAX(CASE WHEN A1.CDVAL = 'AMOUNT_UNIT' THEN ' ' || A1.CDCONTENT ELSE '' END) || ' (' ||MAX(utils.fnc_number2vie(NVL(BI.ISSUEVAL,0))) || ')' || '</div>'
                        ||'<div>VND ' || MAX(utils.SO_THANH_CHU2(NVL(BI.ISSUEVAL,0))) || ' (' ||MAX(utils.fnc_number2work(NVL(BI.ISSUEVAL,0))) || ' dong)</div>'
                    ||'</td>'
                ||'</tr>'
                ||'<tr>'
                    ||'<td>'
                        ||'<div class="margintopcontent">- ' || MAX(CASE WHEN A1.CDVAL = 'INTRATE' THEN A1.CDCONTENT|| ':</div>'
                        ||'<div>- '||A1.EN_CDCONTENT ELSE '' END) || ':</div>'
                    ||'</td>'
                    ||'<td>'
                        ||'<div class="margintopcontent">' || MAX(REPLACE(TO_CHAR(BI.INTRATE,'99990D99'),'.',','))|| ' ' || MAX(CASE WHEN A1.CDVAL = 'INTRATE_UNIT' THEN A1.CDCONTENT ELSE '' END) ||'</div>'
                        ||'<div>' || MAX(REPLACE(TO_CHAR(BI.INTRATE,'99990D99'),',','.'))|| ' ' || MAX(CASE WHEN A1.CDVAL = 'INTRATE_UNIT' THEN A1.EN_CDCONTENT ELSE '' END) ||'</div>'
                    ||'</td>'
                || '</tr>'
                || '</table>' CONTENT
                FROM ISSUES ISS
                     JOIN (SELECT * FROM ALLCODE WHERE CDNAME='EM16') A1 ON 1=1
                     JOIN BONDISSUE BI ON ISS.AUTOID = BI.ISSUESID
                     JOIN SBSECURITIES SB ON SB.CODEID = BI.BONDCODE
                     JOIN ISSUERS ISR ON ISR.ISSUERID = ISS.ISSUERID
                WHERE  ISS.AUTOID = p_issuesid AND GETCURRDATE < SB.EXPDATE
                GROUP BY ISS.AUTOID, ISS.ISSUERID,ISS.ISSUECODE, ISR.FULLNAME,ISR.EN_FULLNAME, ISS.LTVRATE, ISS.WARNINGLTVRATE, BI.BONDSYMBOL
             ) T
        GROUP BY T.AUTOID, T.ISSUERID, T.ISSUECODE, T.FULLNAME,T.EN_FULLNAME, T.LTVRATE, T.WARNINGLTVRATE;
        -- TriBui 27/07/2020 Them de check tang/giam :
        SELECT
                ISS.TYPERATE,
                CASE
                    WHEN ISS.TYPERATE ='002' THEN ISS.WARNINGLTVRATE - 3
                    WHEN ISS.TYPERATE ='003' THEN ISS.MAXLTVRATE +3
                    ELSE 0
                END NUM_CHECK
        INTO L_TYPERATE,L_NUMCHECK
        FROM ISSUES ISS
        WHERE  ISS.AUTOID = p_issuesid ;--filter
        --Kiem tra tang giam
        IF L_TYPERATE = '002' AND P_LTVRATE >= L_NUMCHECK THEN
        --GIA GIAM, LTV TANG
            SELECT CDCONTENT INTO l_idprice FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='0021PRICE';
            SELECT CDCONTENT INTO l_idrate FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='0021RATE';
        ELSIF L_TYPERATE = '002' AND P_LTVRATE < L_NUMCHECK THEN
        --GIA TANG, LTV GIAM
            SELECT CDCONTENT INTO l_idprice FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='0022PRICE';
            SELECT CDCONTENT INTO l_idrate FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='0022RATE';
        ELSIF L_TYPERATE = '003' AND P_LTVRATE >= L_NUMCHECK THEN
        --GIA TANG, CCR TANG
            SELECT CDCONTENT INTO l_idprice FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='0031PRICE';
            SELECT CDCONTENT INTO l_idrate FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='0031RATE';
        ELSIF L_TYPERATE = '003' AND P_LTVRATE < L_NUMCHECK THEN
        --GIA GIAM, CCR GIAM
            SELECT CDCONTENT INTO l_idprice FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='0032PRICE';
            SELECT CDCONTENT INTO l_idrate FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='0032RATE';
        END IF;
        --Loai LTV/CCR--------------------------------------------------------------------------------
        IF L_TYPERATE = '002' THEN
            SELECT CDCONTENT,EN_CDCONTENT INTO l_LTVCCR,l_LTVCCR_ENG FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='002';
            SELECT CDCONTENT INTO l_LTCR FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='LTV';
            SELECT EN_CDCONTENT INTO l_LTCR_ENG FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='LTV';
        ELSIF L_TYPERATE = '003' THEN
            SELECT CDCONTENT,EN_CDCONTENT INTO l_LTVCCR,l_LTVCCR_ENG FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='003';
            SELECT CDCONTENT INTO l_LTCR FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='CCR';
            SELECT EN_CDCONTENT INTO l_LTCR_ENG FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='CCR';
        END IF;
        --LIST SYMBOL TP,CP--------------------------------------------------------------------------------
        SELECT NVL("'TP'",'X') ,NVL("'CP'",'X')
        INTO L_TP,L_CP
        FROM
        (
        SELECT SECTYPE,LISTAGG(SYMBOL, ', ') WITHIN GROUP (ORDER BY SECTYPE) LISTSYMBOL
        FROM
        (
            SELECT SB.SYMBOL,CASE WHEN SB.SECTYPE IN ('003','006') THEN 'TP' ELSE 'CP' END SECTYPE
            FROM
            (
                SELECT DISTINCT TRIM(REGEXP_SUBSTR(BO.TICKERLIST,'[^,]+', 1, LEVEL)) BOTICKER
                FROM BONDTYPE BO
                WHERE BO.ISSUESID = p_issuesid
                CONNECT BY REGEXP_SUBSTR(BO.TICKERLIST, '[^,]+', 1, LEVEL) IS NOT NULL
            )BO , SBSECURITIES SB
            WHERE BO.BOTICKER =SB.SYMBOL
        )
        GROUP BY SECTYPE
        )
        PIVOT
        (
            MAX (LISTSYMBOL)
            FOR SECTYPE IN ('TP','CP')
        );
        
        -- CHECK CP/TP
        IF LENGTH(L_CP) > 1 AND LENGTH(L_TP) > 1 THEN
            SELECT A1.CDCONTENT||' '|| L_CP||'/'||A2.CDCONTENT||' '|| L_TP,
            L_CP||' '||A1.EN_CDCONTENT||'/'||L_TP||' '||A2.EN_CDCONTENT
            INTO l_listsymbol,l_listsymbol_eng
            FROM ALLCODE A1, ALLCODE A2
            WHERE A1.CDNAME ='EM17' AND A1.CDVAL IN ('CP') AND A2.CDNAME ='EM17' AND A2.CDVAL IN ('TP');
         ELSIF LENGTH(L_TP) = 1 AND LENGTH(L_CP) > 1 THEN
            SELECT A1.CDCONTENT||' '|| L_CP,L_CP||' '||A1.EN_CDCONTENT
            INTO l_listsymbol,l_listsymbol_eng
            FROM ALLCODE A1
            WHERE A1.CDNAME ='EM17' AND A1.CDVAL IN ('CP');
         ELSIF LENGTH(L_TP) > 1 AND LENGTH(L_CP) = 1 THEN
            SELECT A1.CDCONTENT||' '|| L_TP,L_TP||' '||A1.EN_CDCONTENT
            INTO l_listsymbol,l_listsymbol_eng
            FROM ALLCODE A1
            WHERE A1.CDNAME ='EM17' AND A1.CDVAL IN ('TP');
         END IF;
         
        --end TriBui 27/07/2020:
    l_emailSubject := p_email_subject;
    l_emailSubject := replace(l_emailSubject, '[issuername]', l_issuerName);
    l_emailSubject := replace(l_emailSubject, '[issuername_en]', l_issuerName_eng);
    l_emailSubject := replace(l_emailSubject, '[txdate]', to_char(p_txdate,'dd.MM.RRRR'));

        l_datasource := 'SELECT ''' || l_issuerName || ''' issuername, '
                        || '''' || l_issuerName_eng || ''' issuername_en, '
                        || '''' || TO_CHAR(p_txdate, 'DD/MM/RRRR') || ''' txdate, '
                        || '''' || TO_CHAR(p_txdate, 'DD') || ''' dd, '
                        || '''' || TO_CHAR(p_txdate, 'MM') || ''' mm, '
                        || '''' || TO_CHAR(p_txdate, 'RRRR') || ''' yyyy, '
                        || '''' || TRIM(TO_CHAR(p_txdate, 'Month'))||' '||Trim(TO_CHAR(p_txdate, 'dd, RRRR')) || ''' date_en, '
                        || '''' || l_list_bond || ''' list_bond, '
                        || '''' || REPLACE(TO_CHAR(p_ltvRate),'.',',') || ''' ltvrate, '
                        || '''' || REPLACE(TO_CHAR(p_ltvRate),',','.') || ''' ltvrate_en, '
                        || '''' || REPLACE(TO_CHAR(p_ltvWarningRate),'.',',') || ''' warningrate, '
                        || '''' || REPLACE(TO_CHAR(p_ltvWarningRate),',','.') || ''' warningrate_en, '
                        || '''' || l_idprice || ''' idprice, '
                        || '''' || l_idrate || ''' idrate, '
                        || '''' || l_LTVCCR || ''' ltvccr, '
                        || '''' || l_LTVCCR_ENG || ''' ltvccr_en, '
                        || '''' || l_LTCR || ''' ltcr, '
                        || '''' || l_LTCR_ENG || ''' ltcr_en, '
                        || '''' || l_listsymbol || ''' list_symbol, '
                        || '''' || l_listsymbol_eng || ''' list_symbol_en, '
                        || '''' || l_emailSubject || ''' emailsubject from dual';

        pr_sendInternalEmail(l_datasource,
                            trim(l_template_id),
                            '',
                            'Y');
      END IF; -- END IF V_CHECK > 0

    ELSIF l_template_id IN ('EM18') THEN--------------------------------------------------------------------------------------------------------------------
    --KIEM TRA NEU NGAY DINH KY GUI MAIL >= NGAY DAO HAN TRAI PHIEU THI KH?NG GUI MAIL
    SELECT COUNT(*) INTO V_CHECK
    FROM ISSUES ISS
        JOIN (SELECT * FROM ALLCODE WHERE CDNAME='EM16') A1 ON 1=1
        JOIN BONDISSUE BI ON ISS.AUTOID = BI.ISSUESID
        JOIN SBSECURITIES SB ON SB.CODEID = BI.BONDCODE
        JOIN ISSUERS ISR ON ISR.ISSUERID = ISS.ISSUERID
    WHERE  ISS.AUTOID = p_issuesid AND GETCURRDATE < SB.EXPDATE;

    IF V_CHECK > 0 THEN

        SELECT T.FULLNAME, LISTAGG(T.CONTENT, '<br/>') WITHIN GROUP (ORDER BY T.AUTOID, T.ISSUERID, T.ISSUECODE, T.FULLNAME, T.LTVRATE, T.WARNINGLTVRATE) LIST_BOND
        INTO l_issuerName, l_list_bond
        FROM (
                SELECT ISS.AUTOID, ISS.ISSUERID,ISS.ISSUECODE, ISR.FULLNAME, TO_CHAR(ISS.LTVRATE,'99990D99') LTVRATE, TO_CHAR(ISS.WARNINGLTVRATE,'99990D99') WARNINGLTVRATE, BI.BONDSYMBOL,
                    '<div class="boldcss">' || MAX(CASE WHEN A1.CDVAL = 'SYMBOL' THEN A1.CDCONTENT || ' ' || BI.BONDSYMBOL ELSE '' END)||'</div>'
                    || '<table>'
                    || '<tr>' || '<td>' ||'- '|| MAX(CASE WHEN A1.CDVAL = 'ISSUEDATE' THEN A1.CDCONTENT ELSE '' END) || ':' || '</td>'
                              || '<td>' || MAX(TO_CHAR(ISS.ISSUEDATE,'DD/MM/RRRR')) || '</td>' || '</tr>'
                    || '<tr>' || '<td>' ||'- '|| MAX(CASE WHEN A1.CDVAL = 'MATURITYDATE' THEN A1.CDCONTENT ELSE '' END) || ':' || '</td>'
                              || '<td>' || MAX(TO_CHAR(SB.EXPDATE,'DD/MM/RRRR')) || '</td>' || '</tr>'
                    || '<tr>' || '<td>' ||'- '|| MAX(CASE WHEN A1.CDVAL = 'AMOUNT' THEN A1.CDCONTENT ELSE '' END) || ':' || '</td>'
                              || '<td>' || MAX(REPLACE(TO_CHAR(UTILS.SO_THANH_CHU(NVL(BI.ISSUEVAL,0))),',','.'))
                    || ' ('||MAX(utils.fnc_number2vie(NVL(BI.ISSUEVAL,0))) || ')</td>' || '</tr>'
                    || '<tr>' || '<td>' ||'- '|| MAX(CASE WHEN A1.CDVAL = 'INTRATE' THEN A1.CDCONTENT ELSE '' END) || ':' || '</td>'
                              || '<td>' || MAX(REPLACE(TO_CHAR(BI.INTRATE,'99990D99'),'.',','))
                    || ' ' || MAX(CASE WHEN A1.CDVAL = 'INTRATE_UNIT' THEN A1.CDCONTENT ELSE '' END) || '</td>' || '</tr>'
                    || '</table>' CONTENT
                FROM ISSUES ISS
                     JOIN (SELECT * FROM ALLCODE WHERE CDNAME='EM16') A1 ON 1=1
                     JOIN BONDISSUE BI ON ISS.AUTOID = BI.ISSUESID
                     JOIN SBSECURITIES SB ON SB.CODEID = BI.BONDCODE
                     JOIN ISSUERS ISR ON ISR.ISSUERID = ISS.ISSUERID
                WHERE  ISS.AUTOID = p_issuesid AND GETCURRDATE < SB.EXPDATE
                GROUP BY ISS.AUTOID, ISS.ISSUERID,ISS.ISSUECODE, ISR.FULLNAME, ISS.LTVRATE, ISS.WARNINGLTVRATE, BI.BONDSYMBOL
             ) T
        GROUP BY T.AUTOID, T.ISSUERID, T.ISSUECODE, T.FULLNAME, T.LTVRATE, T.WARNINGLTVRATE;
        -- TriBui 27/07/2020 Them de check tang/giam :
        SELECT
                ISS.TYPERATE,
                CASE
                    WHEN ISS.TYPERATE ='002' THEN ISS.WARNINGLTVRATE - 3
                    WHEN ISS.TYPERATE ='003' THEN ISS.MAXLTVRATE +3
                    ELSE 0
                END NUM_CHECK
        INTO L_TYPERATE,L_NUMCHECK
        FROM ISSUES ISS
        WHERE  ISS.AUTOID = p_issuesid ;--filter
        --Kiem tra tang giam
        IF L_TYPERATE = '002' AND P_LTVRATE >= L_NUMCHECK THEN
        --GIA GIAM, LTV TANG
            SELECT CDCONTENT INTO l_idprice FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='0021PRICE';
            SELECT CDCONTENT INTO l_idrate FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='0021RATE';
        ELSIF L_TYPERATE = '002' AND P_LTVRATE < L_NUMCHECK THEN
        --GIA TANG, LTV GIAM
            SELECT CDCONTENT INTO l_idprice FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='0022PRICE';
            SELECT CDCONTENT INTO l_idrate FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='0022RATE';
        ELSIF L_TYPERATE = '003' AND P_LTVRATE >= L_NUMCHECK THEN
        --GIA TANG, CCR TANG
            SELECT CDCONTENT INTO l_idprice FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='0031PRICE';
            SELECT CDCONTENT INTO l_idrate FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='0031RATE';
        ELSIF L_TYPERATE = '003' AND P_LTVRATE < L_NUMCHECK THEN
        --GIA GIAM, CCR GIAM
            SELECT CDCONTENT INTO l_idprice FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='0032PRICE';
            SELECT CDCONTENT INTO l_idrate FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='0032RATE';
        END IF;
        --Loai LTV/CCR--------------------------------------------------------------------------------
        IF L_TYPERATE = '002' THEN
            SELECT CDCONTENT INTO l_LTVCCR FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='002';
            SELECT CDCONTENT INTO l_LTCR FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='LTV';
        ELSIF L_TYPERATE = '003' THEN
            SELECT CDCONTENT INTO l_LTVCCR FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='003';
            SELECT CDCONTENT INTO l_LTCR FROM ALLCODE WHERE CDNAME ='EM17' AND CDVAL ='CCR';
        END IF;
        --LIST SYMBOL TP,CP--------------------------------------------------------------------------------
        SELECT NVL("'TP'",'X') ,NVL("'CP'",'X')
        INTO L_TP,L_CP
        FROM
        (
        SELECT SECTYPE,LISTAGG(SYMBOL, ', ') WITHIN GROUP (ORDER BY SECTYPE) LISTSYMBOL
        FROM
        (
            SELECT SB.SYMBOL,CASE WHEN SB.SECTYPE IN ('003','006') THEN 'TP' ELSE 'CP' END SECTYPE
            FROM
            (
                SELECT DISTINCT TRIM(REGEXP_SUBSTR(BO.TICKERLIST,'[^,]+', 1, LEVEL)) BOTICKER
                FROM BONDTYPE BO
                WHERE BO.ISSUESID = p_issuesid
                CONNECT BY REGEXP_SUBSTR(BO.TICKERLIST, '[^,]+', 1, LEVEL) IS NOT NULL
            )BO , SBSECURITIES SB
            WHERE BO.BOTICKER =SB.SYMBOL
        )
        GROUP BY SECTYPE
        )
        PIVOT
        (
            MAX (LISTSYMBOL)
            FOR SECTYPE IN ('TP','CP')
        );
        
        -- CHECK CP/TP
        IF LENGTH(L_CP) > 1 AND LENGTH(L_TP) > 1 THEN
            SELECT A1.CDCONTENT||' '|| L_CP||'/'||A2.CDCONTENT||' '|| L_TP
            INTO l_listsymbol
            FROM ALLCODE A1, ALLCODE A2
            WHERE A1.CDNAME ='EM17' AND A1.CDVAL IN ('CP') AND A2.CDNAME ='EM17' AND A2.CDVAL IN ('TP');
         ELSIF LENGTH(L_TP) = 1 AND LENGTH(L_CP) > 1 THEN
            SELECT A1.CDCONTENT||' '|| L_CP
            INTO l_listsymbol
            FROM ALLCODE A1
            WHERE A1.CDNAME ='EM17' AND A1.CDVAL IN ('CP');
         ELSIF LENGTH(L_TP) > 1 AND LENGTH(L_CP) = 1 THEN
            SELECT A1.CDCONTENT||' '|| L_TP
            INTO l_listsymbol
            FROM ALLCODE A1
            WHERE A1.CDNAME ='EM17' AND A1.CDVAL IN ('TP');
         END IF;
         
        --end TriBui 27/07/2020:
        l_emailSubject := p_email_subject;
        l_emailSubject := replace(l_emailSubject, '[issuername]', l_issuerName);
        l_emailSubject := replace(l_emailSubject, '[txdate]', p_txdate);

        l_datasource := 'SELECT ''' || l_issuerName || ''' issuername, '
                            || '''' || TO_CHAR(p_txdate, 'DD/MM/RRRR') || ''' txdate, '
                            || '''' || TO_CHAR(p_txdate, 'DD') || ''' dd, '
                            || '''' || TO_CHAR(p_txdate, 'MM') || ''' mm, '
                            || '''' || TO_CHAR(p_txdate, 'RRRR') || ''' yyyy, '
                            || '''' || l_list_bond || ''' list_bond, '
                            || '''' || REPLACE(TO_CHAR(p_ltvRate),'.',',') || ''' ltvrate, '
                            || '''' || REPLACE(TO_CHAR(p_ltvWarningRate),'.',',') || ''' warningrate, '
                            || '''' || l_idprice || ''' idprice, '
                            || '''' || l_idrate || ''' idrate, '
                            || '''' || l_LTVCCR || ''' ltvccr, '
                            || '''' || l_LTCR || ''' ltcr, '
                            || '''' || l_listsymbol || ''' list_symbol, '
                            || '''' || l_emailSubject || ''' emailsubject from dual';

        pr_sendInternalEmail(l_datasource,
                            trim(l_template_id),
                            '',
                            'Y');
      END IF; -- END IF V_CHECK > 0
    END IF; ----END IF EM18
    plog.setEndSection(pkgctx, 'pr_GenTemplateWarningLtv');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_GenTemplateWarningLtv');
  END;

  PROCEDURE pr_GenTemplateEM23 (p_date  DATE)
  IS
  l_template_id   CHAR(4) := 'EM23';
  l_datasource   emaillog.datasource%TYPE;
  -- CK goc
  l_codeid        sbsecurities.codeid%TYPE;
  l_symbol        sbsecurities.symbol%TYPE;
  l_isin_Code     sbsecurities.isincode%TYPE;
  -- CK chuyen doi
  l_opt_codeid    sbsecurities.codeid%TYPE;
  l_opt_symbol    sbsecurities.symbol%TYPE;
  l_opt_isin_code sbsecurities.isincode%TYPE;
  -- CK quyen nhan
  l_to_codeid     sbsecurities.codeid%TYPE;
  l_to_symbol     sbsecurities.symbol%TYPE;
  l_to_isin_code  sbsecurities.isincode%TYPE;

  l_reportdate    DATE; --camast.reportdate
  l_caisincode    camast.isincode%TYPE;
  l_caType        camast.catype%TYPE;
  l_caTypeTxt     VARCHAR2(1000);
  l_exRate        camast.exrate%TYPE;
  l_rightOffRate  camast.rightoffrate%TYPE;
  l_exprice       camast.exprice%TYPE;
  l_BeginDate     DATE;
  l_dueDate       DATE;
  l_insDeadLine   DATE;
  l_debitDate     DATE;
  l_actionDate    DATE;
  l_holding       caschd.balance%TYPE;
  l_rights        caschd.qtty%TYPE;
  l_qtty          caschd.pqtty%TYPE;

  l_cifid         cfmast.cifid%TYPE;
  l_fullname      cfmast.fullname%TYPE;
  l_buy           NUMBER;
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_GenTemplateEM23');
    FOR rec IN (
      select mst.camastid,
             mst.trfacctno,
             mst.msgstatus,
             mst.afacctno
      from caregister mst, camast ca
      where mst.camastid = ca.camastid
      and MST.msgstatus = 'E' AND mst.errcode='-400101' and CA.debitdate = p_date
      --AND substr(mst.reqtxnum,1,10) = TO_CHAR(p_date, 'dd/mm/rrrr')
      --group by mst.camastid, mst.trfacctno, mst.msgstatus
    ) LOOP
      SELECT ca.codeid, ca.optcodeid, ca.tocodeid, ca.reportdate, ca.isincode, ca.catype,
             ca.rightoffrate, ca.exrate, ca.exprice, ca.begindate, ca.duedate, ca.insdeadline, ca.debitdate,
             ca.actiondate
      INTO l_codeid, l_opt_codeid, l_to_codeid, l_reportdate, l_caisincode, l_caType,
           l_rightOffRate, l_exRate, l_exprice, l_BeginDate, l_dueDate, l_insDeadLine, l_debitDate,
           l_actionDate
      FROM camast ca WHERE ca.camastid = rec.camastid;

      SELECT trade,
             balance,
             qtty
      INTO l_holding,
           l_rights,
           l_buy
      FROM caschd c WHERE camastid = rec.camastid AND afacctno = rec.afacctno AND codeid = l_codeid;

      SELECT en_cdcontent INTO l_caTypeTxt FROM allcode WHERE cdname = 'CATYPE' AND cdtype = 'CA' AND cdval = l_caType;

      SELECT symbol, isincode INTO l_symbol, l_isin_code FROM sbsecurities WHERE codeid = l_codeid;
      SELECT symbol, isincode INTO l_opt_symbol, l_opt_isin_code FROM sbsecurities WHERE codeid = l_opt_codeid;
      SELECT symbol, isincode INTO l_to_symbol, l_to_isin_code FROM sbsecurities WHERE codeid = l_to_codeid;
      SELECT cifid, fullname INTO l_cifid, l_fullname FROM cfmast cf, afmast af WHERE cf.custid = af.custid AND af.acctno = rec.afacctno;

      l_datasource := 'SELECT ''' || l_symbol || ''' symbol, '
                          || '''' || l_isin_Code || ''' isincode, '
                          || '''' || l_opt_symbol || ''' optsymbol, '
                          || '''' || l_opt_isin_code || ''' optisincode, '
                          || '''' || l_to_symbol || ''' tosymbol, '
                          || '''' || l_caTypeTxt || ''' catype, '
                          || '''' || rec.camastid || ''' p_event_ref_no, '
                          || '''' || l_exRate || ''' p_distribution_ratio, '
                          || '''' || l_rightOffRate || ''' p_exercise_ratio, '
                          || '''' || l_exprice || ''' p_conversion_price, '
                          || '''' || TO_CHAR(l_reportdate, 'DD/MM/RRRR') || ''' p_report_date, '
                          || '''' || TO_CHAR(l_BeginDate, 'DD/MM/RRRR') || ''' p_sub_period, '
                          || '''' || TO_CHAR(l_dueDate, 'DD/MM/RRRR') || ''' p_deadline_sub, '
                          || '''' || TO_CHAR(l_insDeadLine, 'DD/MM/RRRR') || ''' insdeadline, '
                          || '''' || TO_CHAR(l_debitDate, 'DD/MM/RRRR') || ''' p_debit_date, '
                          || '''' || TO_CHAR(l_actionDate, 'DD/MM/RRRR') || ''' p_exp_payment_date, '
                          || '''' || TO_CHAR(UTILS.SO_THANH_CHU(l_holding)) || ''' p_curr_holding, '
                          || '''' || TO_CHAR(UTILS.SO_THANH_CHU(l_rights)) || ''' p_rights, '
                          || '''' || TO_CHAR(UTILS.SO_THANH_CHU(l_buy*l_exprice)) || ''' p_amount, '
                          || '''' || TO_CHAR(UTILS.SO_THANH_CHU(l_buy)) || ''' p_no_of_share, '
                          || '''' || l_cifid || ''' cifid, '
                          || '''' || l_fullname || ''' fullname, '
                          || '''' || 'a' || ''' a  from dual';
       pr_sendInternalEmail(l_datasource,
                        l_template_id,
                        rec.afacctno,
                        'Y');
       --
    END LOOP;
    plog.setEndSection(pkgctx, 'pr_GenTemplateEM23');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setEndSection(pkgctx, 'pr_GenTemplateEM23');
  END;

  PROCEDURE pr_GenTemplateEM24 (p_codeid      IN VARCHAR2,
                               p_custid       IN VARCHAR2,
                               p_acctno       IN VARCHAR2,
                               p_qtty         IN NUMBER,
                               p_buyQtty      IN NUMBER,
                               p_buyAmt       IN NUMBER,
                               p_interestAmt  IN NUMBER,
                               p_settleDate   IN DATE,
                               p_desc         IN VARCHAR2)
  IS
  l_template_id    CHAR(4) := 'EM24';
  l_datasource     VARCHAR2(2000);
  l_symbol         sbsecurities.symbol%TYPE;
  l_issuerName     issuers.fullname%TYPE;
  l_issuerDate     DATE;
  l_maturityDate   DATE;
  l_intcoupon      sbsecurities.intcoupon%TYPE;
  l_periodinterest sbsecurities.periodinterest%TYPE;
  l_periodinterestText VARCHAR2(1000);
  l_parvalue           sbsecurities.parvalue%TYPE;
  l_cifid              cfmast.cifid%TYPE;
  l_fullname           cfmast.fullname%TYPE;
  l_catypetext    VARCHAR2(1000);
  l_isin_Code     sbsecurities.isincode%TYPE;
  BEGIN
    plog.setBeginSection (pkgctx, 'pr_GenTemplateEM24');
    SELECT sb.symbol, iss.Fullname, sb.issuedate, sb.maturitydate, sb.intcoupon, sb.periodinterest,
           sb.parvalue
    INTO l_symbol, l_issuerName, l_issuerDate, l_maturityDate, l_intcoupon, l_periodinterest,
         l_parvalue
    FROM sbsecurities sb, issuers iss
    WHERE sb.issuerid = iss.issuerid
    AND sb.codeid = p_codeid;

    SELECT cifid, fullname
    INTO l_cifid, l_fullname
    FROM cfmast WHERE custid = p_custid;

    SELECT en_cdcontent INTO l_periodinterestText
    FROM allcode
    WHERE CDTYPE = 'CB' AND CDNAME = 'PERIODINTEREST' AND CDUSER='Y'
    AND cdval = l_periodinterest;

    SELECT isincode INTO  l_isin_Code FROM sbsecurities
    WHERE codeid = p_codeid;

    SELECT en_cdcontent INTO l_catypetext FROM allcode
    WHERE cdname = 'CATYPE' AND cdval = '033';

    l_datasource := 'SELECT ''' || l_issuerName || ''' issuername, '
                        || '''' || l_symbol || ''' symbol, '
                        || '''' || TO_CHAR(l_issuerDate, 'DD/MM/RRRR') || ''' issuerdate, '
                        || '''' || TO_CHAR(l_maturityDate, 'DD/MM/RRRR') || ''' maturitydate, '
                        || '''' || l_intcoupon || ''' intcoupon, '
                        || '''' || l_periodinterestText || ''' periodinterest, '
                        || '''' || l_parvalue || ''' parvalue, '
                        || '''' || l_cifid || ''' cifid, '
                        || '''' || l_fullname || ''' fullname, '
                        || '''' || TO_CHAR(p_qtty,'9,999,999,999,999,999,999,999') || ''' qtty, '
                        || '''' || TO_CHAR(p_buyQtty,'9,999,999,999,999,999,999,999') || ''' buyqtty, '
                        || '''' || TO_CHAR(p_buyAmt,'9,999,999,999,999,999,999,999') || ''' buyamt, '
                        || '''' || TO_CHAR(p_interestAmt,'9,999,999,999,999,999,999,999') || ''' interestAmt, '
                        || '''' || TO_CHAR(p_buyAmt + p_interestAmt,'9,999,999,999,999,999,999,999') || ''' total, '
                        || '''' || p_acctno || ''' acctno, '
                        || '''' || TO_CHAR(p_settleDate,'dd/mm/rrrr') || ''' settledate, '
                        || '''' || l_isin_Code || ''' isincode, '
                        || '''' || l_catypetext || ''' cacontent, '
                        || '''' || p_desc || ''' desc1  from dual';

    pr_sendInternalEmail(l_datasource,
                        l_template_id,
                        '',
                        'Y');

    plog.setEndSection (pkgctx, 'pr_GenTemplateEM24');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setEndSection(pkgctx, 'pr_GenTemplateEM24');
  END;


  PROCEDURE pr_GenTemplateE281 (p_camastId    VARCHAR2)
  IS
  l_template_id   CHAR(4) := 'E281';
  l_datasource   emaillog.datasource%TYPE;
  l_codeid        sbsecurities.codeid%TYPE;
  l_symbol        sbsecurities.symbol%TYPE;
  l_isin_Code     sbsecurities.isincode%TYPE;

  l_tocodeid      sbsecurities.codeid%TYPE;
  l_tosymbol      sbsecurities.symbol%TYPE;
  l_toisin_code   sbsecurities.isincode%TYPE;

  l_reportDate    DATE;
  l_catype        camast.catype%TYPE;
  l_catypetext    VARCHAR2(1000);
  l_caisincode    camast.isincode%TYPE;
  l_exrate        camast.exrate%TYPE;
  l_exprice       camast.exprice%TYPE;
  l_actionDate    camast.actiondate%TYPE;

  l_trade         caschd.trade%TYPE;
  l_qtty          caschd.qtty%TYPE;
  l_fullName      cfmast.fullname%TYPE;
  l_cifid         cfmast.cifid%TYPE;
  l_isSE          caschd.isse%TYPE;
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_GenTemplateE281');
    FOR rec IN (
      SELECT ca.reportdate, ca.catype, ca.codeid, ca.tocodeid, ca.isincode caisincode,
             ca.exrate, ca.exprice, ca.actiondate, sc.qtty, sc.trade, sc.afacctno
      FROM camast ca, caschd sc
      WHERE ca.camastid = sc.camastid
      AND ca.camastid = p_camastId AND ca.catype = '023' AND sc.isse = 'Y'
      AND sc.deltd = 'N' AND sc.status = 'S'
    ) LOOP
        /*SELECT ca.reportdate, ca.catype, ca.codeid, ca.tocodeid, ca.isincode, ca.exrate, ca.exprice, ca.actiondate
        INTO l_reportDate, l_catype, l_codeid, l_tocodeid, l_caisincode, l_exrate, l_exprice, l_actionDate
        FROM camast ca
        WHERE ca.camastid = p_camastid;
        SELECT ca.qtty, ca.trade, ca.isse INTO l_qtty, l_trade, l_isSE FROM caschd ca WHERE ca.camastid = p_camastId AND ca.afacctno = p_afacctno;*/
        --IF l_catype = '023' AND l_isSE = 'Y' THEN
          SELECT symbol, isincode INTO l_symbol, l_isin_Code FROM sbsecurities WHERE codeid = rec.codeid;
          SELECT symbol, isincode INTO l_tosymbol, l_toisin_Code FROM sbsecurities WHERE codeid = rec.tocodeid;
          SELECT en_cdcontent INTO l_catypetext FROM allcode WHERE cdname = 'CATYPE' AND cdval = rec.catype;

          SELECT fullname, cifid INTO l_fullName, l_cifid
          FROM cfmast cf, afmast af
          WHERE cf.custid = af.custid AND af.acctno = rec.afacctno;

          l_datasource := 'SELECT ''' || l_symbol || ''' symbol, '
                              || '''' || l_isin_Code || ''' isincode, '
                              || '''' || l_tosymbol || ''' tosymbol, '
                              || '''' || l_toisin_Code || ''' toisincode, '
                              || '''' || TO_CHAR(rec.reportDate, 'dd/mm/rrrr') || ''' reportdate, '
                              || '''' || l_catypetext || ''' catype, '
                              || '''' || rec.caisincode || ''' caisincode, '
                              || '''' || rec.exrate || ''' exrate, '
                              || '''' || rec.exprice || ''' exprice, '
                              || '''' || TO_CHAR(rec.actionDate, 'dd/mm/rrrr') || ''' actiondate, '
                              || '''' || l_cifid || ''' cifid, '
                              || '''' || l_fullName || ''' fullname, '
                              || '''' || TO_CHAR(rec.qtty, '9,999,999,999,999,999,999,999') || ''' qtty, '
                              || '''' || TO_CHAR(rec.trade, '9,999,999,999,999,999,999,999') || ''' trade, '
                              || '''' || 'a' || ''' a  from dual';
            pr_sendInternalEmail(l_datasource,
                            l_template_id,
                            '',
                            'Y');
         -- END IF;
    END LOOP;

    plog.setEndSection(pkgctx, 'pr_GenTemplateE281');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setEndSection(pkgctx, 'pr_GenTemplateE281');
  END;

  PROCEDURE pr_GenTemplateE282 (p_camastId    VARCHAR2,
                               p_txdate       DATE)
  IS
  l_template_id   CHAR(4) := 'E282';
  l_datasource   emaillog.datasource%TYPE;
  l_codeid        sbsecurities.codeid%TYPE;
  l_symbol        sbsecurities.symbol%TYPE;
  l_isin_Code     sbsecurities.isincode%TYPE;

  l_tocodeid      sbsecurities.codeid%TYPE;
  l_tosymbol      sbsecurities.symbol%TYPE;
  l_toisin_code   sbsecurities.isincode%TYPE;

  l_reportDate    DATE;
  l_catype        camast.catype%TYPE;
  l_catypetext    VARCHAR2(1000);
  l_caisincode    camast.isincode%TYPE;
  l_exrate        camast.exrate%TYPE;
  l_exprice       camast.exprice%TYPE;
  l_actionDate    camast.actiondate%TYPE;

  l_trade         caschd.trade%TYPE;
  l_qtty          caschd.qtty%TYPE;
  l_fullName      cfmast.fullname%TYPE;
  l_cifid         cfmast.cifid%TYPE;
  l_isSE          caschd.isse%TYPE;
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_GenTemplateE281');
    FOR rec IN (
      SELECT ca.reportdate, ca.catype, ca.codeid, ca.tocodeid, ca.isincode caisincode, ca.parvalue,
             ca.exrate, ca.exprice, ca.actiondate, sc.qtty, sc.trade, sc.afacctno, sc.amt
      FROM camast ca, caschd sc
      WHERE ca.camastid = sc.camastid
      AND ca.camastid = p_camastId AND ca.catype = '023' AND sc.isse = 'N'
      AND sc.deltd = 'N' AND sc.status = 'S'
    ) LOOP
        /*SELECT ca.reportdate, ca.catype, ca.codeid, ca.tocodeid, ca.isincode, ca.exrate, ca.exprice, ca.actiondate
        INTO l_reportDate, l_catype, l_codeid, l_tocodeid, l_caisincode, l_exrate, l_exprice, l_actionDate
        FROM camast ca
        WHERE ca.camastid = p_camastid;
        SELECT ca.qtty, ca.trade, ca.isse INTO l_qtty, l_trade, l_isSE FROM caschd ca WHERE ca.camastid = p_camastId AND ca.afacctno = p_afacctno;*/
        --IF l_catype = '023' AND l_isSE = 'Y' THEN
          SELECT symbol, isincode INTO l_symbol, l_isin_Code FROM sbsecurities WHERE codeid = rec.codeid;
          SELECT symbol, isincode INTO l_tosymbol, l_toisin_Code FROM sbsecurities WHERE codeid = rec.tocodeid;
          SELECT en_cdcontent INTO l_catypetext FROM allcode WHERE cdname = 'CATYPE' AND cdval = rec.catype;

          SELECT fullname, cifid INTO l_fullName, l_cifid
          FROM cfmast cf, afmast af
          WHERE cf.custid = af.custid AND af.acctno = rec.afacctno;

          l_datasource := 'SELECT ''' || l_symbol || ''' symbol, '
                              || '''' || l_isin_Code || ''' isincode, '
                              || '''' || l_tosymbol || ''' tosymbol, '
                              || '''' || l_toisin_Code || ''' toisincode, '
                              || '''' || TO_CHAR(rec.reportDate, 'dd/mm/rrrr') || ''' reportdate, '
                              || '''' || l_catypetext || ''' catype, '
                              || '''' || rec.caisincode || ''' caisincode, '
                              || '''' || rec.exrate || ''' exrate, '
                              || '''' || TRIM(TO_CHAR(rec.parvalue, '9,999,999,999,999,999,999')) || ''' price, '
                              || '''' || TO_CHAR(rec.actionDate, 'dd/mm/rrrr') || ''' actiondate, '
                              || '''' || l_cifid || ''' cifid, '
                              || '''' || l_fullName || ''' fullname, '
                              || '''' || TO_CHAR(rec.qtty, '9,999,999,999,999,999,999,999') || ''' qtty, '
                              || '''' || TO_CHAR(rec.parvalue, '9,999,999,999,999,999,999,999') || ''' parvalue, '
                              || '''' || TO_CHAR(rec.amt, '9,999,999,999,999,999,999,999') || ''' amount, '
                              || '''' || TO_CHAR(p_txdate, 'dd/mm/rrrr') || ''' txdate, '
                              || '''' || 'a' || ''' a  from dual';
          pr_sendInternalEmail(l_datasource,
                            l_template_id,
                            '',
                            'Y');
         -- END IF;
    END LOOP;

    plog.setEndSection(pkgctx, 'pr_GenTemplateE281');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setEndSection(pkgctx, 'pr_GenTemplateE281');
  END;

  PROCEDURE pr_GenTemplateCashSec (P_DDACCTNO  IN  VARCHAR2 default '',
                                   P_SEACCTNO IN VARCHAR2 default '',
                                   P_MEMBERID IN VARCHAR2 default '',
                                   P_AMOUNT IN NUMBER default '0',
                                   P_QTTY IN NUMBER default '0',
                                   P_MessageError IN NUMBER default '0' )
  IS
  /*=============================================================
  CREATER               CREATEDATE                 REASON
  THUNT                 20/01/2020                 SENDIND MAIL
  =============================================================*/
    L_SECUSTODYCD VARCHAR2(20);
    L_BROKERNAME VARCHAR2(500);
    L_SEFULLNAME VARCHAR2(200);
    L_SEACCTNO VARCHAR2(20);
    L_SESYMBOL VARCHAR2(20);
    L_DDCUSTODYCD VARCHAR2(20);
    L_DDFULLNAME VARCHAR2(200);
    L_DDACCTNO VARCHAR2(20);
    L_ISERNAME VARCHAR2(500);
    L_DATASOURCE VARCHAR2(4000);
    L_TEMPLATE_ID VARCHAR2(4);
    L_TEMPLATE_ID2 VARCHAR2(4);
    L_HOLDBR NUMBER;
    L_BALANCE NUMBER;
    L_TRADE NUMBER;
    L_SEACCTNO_CHK NUMBER;
    L_DDACCTNO_CHK NUMBER;

  BEGIN
    plog.setBeginSection(pkgctx, 'pr_GenTemplateCashSec');
    SELECT SHORTNAME||'-'||FULLNAME INTO L_BROKERNAME FROM FAMEMBERS WHERE AUTOID=P_MEMBERID;
    SELECT COUNT(*) INTO L_SEACCTNO_CHK FROM SEMAST WHERE ACCTNO=P_SEACCTNO;
    SELECT COUNT(*) INTO L_DDACCTNO_CHK FROM DDMAST WHERE ACCTNO=P_DDACCTNO;
    IF L_SEACCTNO_CHK <> 0 AND L_DDACCTNO_CHK <> 0 THEN
        SELECT CF.TRADINGCODE,CF.FULLNAME, SE.ACCTNO , SB.SYMBOL , ISER.FULLNAME ISERNAME, SE.TRADE
        INTO L_SECUSTODYCD, L_SEFULLNAME,L_SEACCTNO,L_SESYMBOL,L_ISERNAME,L_TRADE
        FROM SEMAST SE,SBSECURITIES SB, CFMAST CF, ISSUERS ISER
        WHERE SE.ACCTNO = P_SEACCTNO AND SB.CODEID =SE.CODEID AND CF.CUSTID =SE.CUSTID AND SB.ISSUERID=ISER.ISSUERID;

        SELECT CF.TRADINGCODE,CF.FULLNAME, DD.ACCTNO, DD.BALANCE
        INTO L_DDCUSTODYCD,L_DDFULLNAME,L_DDACCTNO,L_BALANCE
        FROM DDMAST DD, CFMAST CF
        WHERE DD.ACCTNO=P_DDACCTNO AND DD.STATUS <> 'C' AND DD.ISDEFAULT='Y' AND CF.TRADINGCODE IS NOT NULL AND DD.CUSTODYCD=CF.CUSTODYCD;
    ELSE
        IF L_SEACCTNO_CHK <> 0  THEN
            SELECT CF.TRADINGCODE,CF.FULLNAME, SE.ACCTNO , SB.SYMBOL , ISER.FULLNAME ISERNAME, SE.TRADE
            INTO L_SECUSTODYCD, L_SEFULLNAME,L_SEACCTNO,L_SESYMBOL,L_ISERNAME,L_TRADE
            FROM SEMAST SE,SBSECURITIES SB, CFMAST CF, ISSUERS ISER
            WHERE SE.ACCTNO = P_SEACCTNO AND SB.CODEID =SE.CODEID AND CF.CUSTID =SE.CUSTID AND SB.ISSUERID=ISER.ISSUERID;
        ELSE
            SELECT CF.TRADINGCODE,CF.FULLNAME, DD.ACCTNO, DD.BALANCE
            INTO L_DDCUSTODYCD,L_DDFULLNAME,L_DDACCTNO,L_BALANCE
            FROM DDMAST DD, CFMAST CF
            WHERE DD.ACCTNO=P_DDACCTNO AND DD.ISDEFAULT='Y' AND DD.STATUS <> 'C' AND CF.TRADINGCODE IS NOT NULL AND DD.CUSTODYCD=CF.CUSTODYCD;
        END IF;
    END IF ;
    L_DATASOURCE := 'SELECT ''' || L_DDCUSTODYCD || ''' l_ddcustodycd, '
                      || '''' || L_DDFULLNAME || ''' l_ddfullname, '
                      || '''' || L_DDACCTNO || ''' l_ddacctno, '
                      || '''' || TO_CHAR(UTILS.SO_THANH_CHU(P_AMOUNT)) || ''' l_amount, '
                      || '''' || L_BROKERNAME || ''' l_brokername, '
                      || '''' || L_SECUSTODYCD || ''' l_secustodycd, '
                      || '''' || L_SEFULLNAME || ''' l_sefullname, '
                      || '''' || L_SEACCTNO || ''' l_seacctno, '
                      || '''' || L_SESYMBOL || ''' l_sesymbol, '
                      || '''' || TO_CHAR(UTILS.SO_THANH_CHU(P_QTTY)) || ''' l_qtty, '
                      || '''' || L_ISERNAME || ''' l_isername, '
                      || '''' || 'a' || ''' a  from dual';
    IF P_AMOUNT > L_BALANCE AND P_QTTY > L_TRADE  THEN
        L_TEMPLATE_ID:='120E';--CASH
        nmpks_ems.pr_sendInternalEmail(L_DATASOURCE, L_TEMPLATE_ID, L_DDCUSTODYCD,'Y');
        L_TEMPLATE_ID:='121E';--SEC
        nmpks_ems.pr_sendInternalEmail(L_DATASOURCE, L_TEMPLATE_ID, L_SECUSTODYCD,'Y');
    ELSE
        IF P_AMOUNT > L_BALANCE AND nvl(P_QTTY,0) <= nvl(L_TRADE,0) THEN
            L_TEMPLATE_ID:='120E';--CASH
            nmpks_ems.pr_sendInternalEmail(L_DATASOURCE, L_TEMPLATE_ID, L_DDCUSTODYCD,'Y');
        ELSIF  P_QTTY > L_TRADE AND P_AMOUNT <= L_BALANCE THEN
            L_TEMPLATE_ID:='121E';--SEC
            nmpks_ems.pr_sendInternalEmail(L_DATASOURCE, L_TEMPLATE_ID, L_SECUSTODYCD,'Y');
        ELSE
            RETURN;
        END IF;
    END IF;

    plog.setEndSection(pkgctx, 'pr_GenTemplateCashSec');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setEndSection(pkgctx, 'pr_GenTemplateE281');
  END;

  PROCEDURE pr_GenTemplateEM30 (p_camastId    VARCHAR2,
                               p_afacctno     VARCHAR2)
  IS
  l_template_id   CHAR(4) := 'EM30';
  l_datasource   emaillog.datasource%TYPE;
  l_codeid        sbsecurities.codeid%TYPE;
  l_symbol        sbsecurities.symbol%TYPE;
  l_isin_Code     sbsecurities.isincode%TYPE;

  l_reportDate    DATE;
  l_catype        camast.catype%TYPE;
  l_catypetext    VARCHAR2(1000);
  l_caisincode    camast.isincode%TYPE;
  l_exrate        camast.exrate%TYPE;
  l_exprice       camast.exprice%TYPE;
  l_actionDate    camast.actiondate%TYPE;

  l_trade         caschd.trade%TYPE;
  l_qtty          caschd.qtty%TYPE;
  l_fullName      cfmast.fullname%TYPE;
  l_cifid         cfmast.cifid%TYPE;

  l_rightCodeId   camast.optcodeid%TYPE;
  l_rightCode     VARCHAR2(100);
  l_rightIsinCode VARCHAR2(100);
  l_sendQtty      NUMBER;
  l_remainQtty    NUMBER;
  l_toCodeId      camast.tocodeid%TYPE;
  l_buySymbol     sbsecurities.symbol%TYPE;
  l_remainRight   NUMBER;
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_GenTemplateEM30');
    SELECT ca.reportdate, ca.catype, ca.codeid, ca.isincode, ca.exrate, ca.exprice, ca.actiondate,
           ca.optcodeid, ca.tocodeid
    INTO l_reportDate, l_catype, l_codeid, l_caisincode, l_exrate, l_exprice, l_actionDate,
         l_rightCodeId, l_toCodeId
    FROM camast ca
    WHERE ca.camastid = p_camastid;
    IF l_catype = '014' THEN
      SELECT symbol, isincode INTO l_symbol, l_isin_Code FROM sbsecurities WHERE codeid = l_codeid;
      SELECT symbol, isincode INTO l_rightCode, l_rightIsinCode FROM sbsecurities WHERE codeid = l_rightCodeId;
      SELECT symbol INTO l_buySymbol FROM sbsecurities WHERE codeid = l_toCodeId;
      SELECT en_cdcontent INTO l_catypetext FROM allcode WHERE cdname = 'CATYPE' AND cdval = l_catype;
      SELECT ca.retailbal, ca.trade, ca.outbalance
      INTO l_remainRight, l_trade, l_sendQtty
      FROM caschd ca WHERE ca.camastid = p_camastId AND ca.afacctno = p_afacctno;
      SELECT fullname, cifid INTO l_fullName, l_cifid FROM cfmast cf, afmast af
      WHERE cf.custid = af.custid AND af.acctno = p_afacctno;

      l_datasource := 'SELECT ''' || l_symbol || ''' symbol, '
                          || '''' || l_isin_Code || ''' isincode, '
                          || '''' || p_camastId || ''' camastid, '
                          || '''' || l_rightCode || ''' rightcode, '
                          || '''' || l_rightIsinCode || ''' rightIsinCode, '
                          || '''' || l_buySymbol || ''' buysymbol, '
                          || '''' || TO_CHAR(l_reportDate, 'dd/mm/rrrr') || ''' actiondate, '
                          || '''' || l_catypetext || ''' catype, '
                          || '''' || l_caisincode || ''' caisincode, '
                          || '''' || l_cifid || ''' cifid, '
                          || '''' || l_fullName || ''' fullname, '
                          || '''' || TRIM(TO_CHAR(l_remainRight + l_sendQtty, '9,999,999,999,999,999,999,999')) || ''' qtty, '
                          || '''' || TRIM(TO_CHAR(l_sendQtty, '9,999,999,999,999,999,999,999')) || ''' sendqtty, '
                          || '''' || TRIM(TO_CHAR(l_remainRight, '9,999,999,999,999,999,999,999')) || ''' remainqtty, '
                          || '''' || 'a' || ''' a  from dual';
      pr_sendInternalEmail(l_datasource,
                        l_template_id,
                        p_afacctno,
                        'Y');
    END IF;
    plog.setEndSection(pkgctx, 'pr_GenTemplateEM30');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setEndSection(pkgctx, 'pr_GenTemplateEM30');
  END;

  PROCEDURE pr_GenTemplateEM31 (p_camastId    VARCHAR2,
                               p_custid       VARCHAR2,
                               p_afacctno     VARCHAR2)
  IS
  l_template_id   CHAR(4) := 'EM31';
  l_datasource   emaillog.datasource%TYPE;
  l_codeid        sbsecurities.codeid%TYPE;
  l_symbol        sbsecurities.symbol%TYPE;
  l_isin_Code     sbsecurities.isincode%TYPE;

  l_reportDate    DATE;
  l_catype        camast.catype%TYPE;
  l_catypetext    VARCHAR2(1000);
  l_caisincode    camast.isincode%TYPE;
  l_exrate        camast.exrate%TYPE;
  l_exprice       camast.exprice%TYPE;
  l_actionDate    camast.actiondate%TYPE;
  l_rightOffRate  camast.rightoffrate%TYPE;

  l_trade         caschd.trade%TYPE;
  l_qtty          caschd.qtty%TYPE;
  l_fullName      cfmast.fullname%TYPE;
  l_cifid         cfmast.cifid%TYPE;

  l_rightCodeId   camast.optcodeid%TYPE;
  l_rightCode     VARCHAR2(100);
  l_rightIsinCode VARCHAR2(100);
  l_sendQtty      NUMBER;
  l_remainQtty    NUMBER;
  l_buyCodeid     camast.tocodeid%TYPE;
  l_buySymbol     sbsecurities.symbol%TYPE;
  l_debitdate     DATE;
  l_rights        NUMBER;
  l_retailbal     NUMBER;
  l_amount        NUMBER;
  l_pqtty         NUMBER;
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_GenTemplateEM31');
    SELECT ca.reportdate, ca.catype, ca.codeid, ca.isincode, ca.exrate, ca.exprice, NVL(ca.INACTIONDATE, ca.actiondate) actiondate,
           ca.optcodeid, ca.tocodeid, ca.debitdate, ca.rightoffrate
    INTO l_reportDate, l_catype, l_codeid, l_caisincode, l_exrate, l_exprice, l_actionDate,
         l_rightCodeId, l_buyCodeid, l_debitdate, l_rightOffRate
    FROM camast ca
    WHERE ca.camastid = p_camastid;
    IF l_catype = '014' THEN
      SELECT symbol, isincode INTO l_symbol, l_isin_Code FROM sbsecurities WHERE codeid = l_codeid;
      SELECT symbol, isincode INTO l_rightCode, l_rightIsinCode FROM sbsecurities WHERE codeid = l_rightCodeId;
      SELECT symbol INTO l_buySymbol FROM sbsecurities WHERE codeid = l_buyCodeid;
      SELECT en_cdcontent INTO l_catypetext FROM allcode WHERE cdname = 'CATYPE' AND cdval = l_catype;
      SELECT ca.qtty, ca.trade, ca.balance + ca.pbalance,ca.qtty + ca.aqtty,ca.amt + ca.aamt --ca.qtty + ca.pqtty, ca.aamt + ca.paamt
      INTO l_qtty, l_trade, l_rights, l_qtty, l_amount
      FROM caschd ca WHERE ca.camastid = p_camastId AND afacctno = p_afacctno;
      SELECT fullname, cifid INTO l_fullName, l_cifid FROM cfmast WHERE custid = p_custid;

      l_datasource := 'SELECT ''' || l_symbol || ''' symbol, '
                          || '''' || l_isin_Code || ''' isincode, '
                          || '''' || p_camastId || ''' camastid, '
                          || '''' || l_rightCode || ''' rightcode, '
                          || '''' || l_rightIsinCode || ''' rightIsinCode, '
                          || '''' || l_buySymbol || ''' buysymbol, '
                          || '''' || TO_CHAR(l_reportDate, 'dd/mm/rrrr') || ''' reportdate, '
                          || '''' || l_catypetext || ''' catype, '
                          || '''' || l_caisincode || ''' caisincode, '
                          || '''' || l_exrate || ''' distribution_ratio, '
                          || '''' || l_rightOffRate || ''' exercise_ratio, '
                          || '''' || TRIM(TO_CHAR(UTILS.SO_THANH_CHU(l_exprice))) || ''' exprice, '
                          || '''' || TO_CHAR(l_debitdate, 'dd/mm/rrrr') || ''' debitdate, '
                          || '''' || TO_CHAR(l_actionDate, 'dd/mm/rrrr') || ''' actiondate, '
                          || '''' || l_cifid || ''' cifid, '
                          || '''' || l_fullName || ''' fullname, '
                          || '''' || trim(TO_CHAR(UTILS.SO_THANH_CHU(l_trade))) || ''' holding, '
                          || '''' || trim(TO_CHAR(UTILS.SO_THANH_CHU(l_rights))) || ''' retailbal, '
                          || '''' || trim(TO_CHAR(UTILS.SO_THANH_CHU(l_qtty))) || ''' qtty, '
                          || '''' || trim(TO_CHAR(UTILS.SO_THANH_CHU(l_amount))) || ''' amount, '
                          || '''' || 'a' || ''' a  from dual';

      pr_sendInternalEmail(l_datasource,l_template_id,p_afacctno,'Y');
    END IF;
    plog.setEndSection(pkgctx, 'pr_GenTemplateEM31');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setEndSection(pkgctx, 'pr_GenTemplateEM31');
  END;

  PROCEDURE pr_GenTemplateEM33 (p_codeid       VARCHAR2,
                                p_scustodycd   VARCHAR2,
                                p_rcustodycd   VARCHAR2,
                                p_qtty         NUMBER)
IS
    --nam.ly 14/02/2020
    l_template_id       CHAR(4) := 'EM33';
    l_datasource        emaillog.datasource%TYPE;
    l_bondsymbol        sbsecurities.symbol%TYPE;
    l_contractno        sbsecurities.contractno%TYPE;
    l_dd_contractdate   CHAR(2);
    l_mm_contractdate   CHAR(2);
    l_yy_contractdate   CHAR(4);
    l_issfullname       issuers.fullname%TYPE;
    l_sectype_name      allcode.cdcontent%TYPE;
    l_sfullname         cfmast.fullname%TYPE;
    l_stradingcode      cfmast.tradingcode%TYPE;
    l_sidplace          cfmast.idplace%TYPE;
    l_rfullname         cfmast.fullname%TYPE;
    l_rtradingcode      cfmast.tradingcode%TYPE;
    l_ridplace          cfmast.idplace%TYPE;
    l_staxcodedate      varchar2(10);
    l_rtaxcodedate      varchar2(10);

BEGIN
    plog.setBeginSection(pkgctx, 'pr_GenTemplateEM33');
    --
    SELECT SB.SYMBOL BONDSYMBOL, SB.CONTRACTNO, TO_CHAR(SB.CONTRACTDATE,'DD') DD_CONTRACTDATE, TO_CHAR(SB.CONTRACTDATE,'MM') MM_CONTRACTDATE,
           TO_CHAR(SB.CONTRACTDATE,'RRRR') YY_CONTRACTDATE, ISS.FULLNAME ISSFULLNAME, A1.CDCONTENT SECTYPE_NAME
    INTO l_bondsymbol, l_contractno, l_dd_contractdate, l_mm_contractdate, l_yy_contractdate, l_issfullname, l_sectype_name
    FROM SBSECURITIES SB, ISSUERS ISS, ALLCODE A1
    WHERE SB.ISSUERID = ISS.ISSUERID AND
          SB.SECTYPE = A1.CDVAL AND A1.CDNAME ='SECTYPE' AND A1.CDTYPE ='SA' AND
          SB.CODEID = p_codeid;
    --
    SELECT FULLNAME,
           CASE
                WHEN CUSTATCOM='N' THEN IDCODE
                ELSE
                    CASE WHEN COUNTRY ='234' THEN IDCODE ELSE TRADINGCODE END
            END
           ,
           IDPLACE,
           CASE
                WHEN CUSTATCOM='N' THEN TO_CHAR(IDDATE,'DD/MM/RRRR')
                ELSE
                    CASE WHEN COUNTRY ='234' THEN TO_CHAR(IDDATE,'DD/MM/RRRR') ELSE TO_CHAR(TRADINGCODEDT,'DD/MM/RRRR') END
            END
    INTO l_sfullname, l_stradingcode, l_sidplace,l_staxcodedate
    FROM CFMAST
    WHERE CUSTODYCD = p_scustodycd;
    --
    SELECT FULLNAME,
           CASE
                WHEN CUSTATCOM='N' THEN IDCODE
                ELSE
                    CASE WHEN COUNTRY ='234' THEN IDCODE ELSE TRADINGCODE END
            END
           ,
           IDPLACE,
           CASE
                WHEN CUSTATCOM='N' THEN TO_CHAR(IDDATE,'DD/MM/RRRR')
                ELSE
                    CASE WHEN COUNTRY ='234' THEN TO_CHAR(IDDATE,'DD/MM/RRRR') ELSE TO_CHAR(TRADINGCODEDT,'DD/MM/RRRR') END
            END
    INTO l_rfullname, l_rtradingcode, l_ridplace, l_rtaxcodedate
    FROM CFMAST
    WHERE CUSTODYCD = p_rcustodycd;
    --
    l_datasource := 'SELECT ''' || l_bondsymbol || ''' bondsymbol, '
                  || '''' || to_char(UTILS.SO_THANH_CHU(p_qtty)) || ''' qtty, '
                  || '''' || l_contractno || ''' contractno, '
                  || '''' || l_staxcodedate || ''' staxcodedate, '
                  || '''' || l_rtaxcodedate || ''' rtaxcodedate, '
                  || '''' || l_dd_contractdate || ''' dd_contractdate, '
                  || '''' || l_mm_contractdate || ''' mm_contractdate, '
                  || '''' || l_yy_contractdate || ''' yy_contractdate, '
                  || '''' || l_issfullname || ''' issfullname, '
                  || '''' || l_sectype_name || ''' sectype_name, '
                  || '''' || l_sfullname || ''' sfullname, '
                  || '''' || l_stradingcode || ''' stradingcode, '
                  || '''' || l_sidplace || ''' sidplace, '
                  || '''' || l_rfullname || ''' rfullname, '
                  || '''' || l_rtradingcode || ''' rtradingcode, '
                  || '''' || l_ridplace || ''' ridplace from dual';
    dbms_output.put_line(l_datasource);
      pr_sendInternalEmail(l_datasource,
                        l_template_id,
                        '',
                        'Y');
    plog.setEndSection(pkgctx, 'pr_GenTemplateEM33');
EXCEPTION
WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
    plog.setEndSection(pkgctx, 'pr_GenTemplateEM33');
END;

    PROCEDURE pr_GenTemplate202E( p_date_from date, p_date_to date)
    IS
        l_template_id   CHAR(4) := '202E';
        l_datasource   emaillog.datasource%TYPE;
        v_date_from    DATE;
        v_date_to      DATE;
    BEGIN
        v_date_from  := p_date_from;
        v_date_to  := p_date_to;

        plog.setBeginSection(pkgctx, 'pr_GenTemplate202E');
        l_datasource:='select '''||v_date_to||''' T_DATE, '''||v_date_from||''' F_DATE from dual ';
        NMPKS_EMS.PR_SENDINTERNALEMAIL(l_datasource, l_template_id, '','Y');
        plog.setEndSection(pkgctx, 'pr_GenTemplate202E');
      EXCEPTION
        WHEN OTHERS THEN
          plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
          plog.setEndSection(pkgctx, 'pr_GenTemplate202E');
     END;


PROCEDURE pr_GenTemplate206E( p_report_date date)
IS
    l_template_id   CHAR(4) := '206E';
    l_datasource   emaillog.datasource%TYPE;
    v_report_date    VARCHAR2(50);
    l_emailSubject   VARCHAR2(1000);
BEGIN
    v_report_date  := TO_CHAR(p_report_date,'DD/MM/RRRR');
    SELECT subject INTO l_emailSubject FROM templates t WHERE code = l_template_id;
    l_emailSubject := replace(l_emailSubject, '[p_txdate]', v_report_date);
    plog.setBeginSection(pkgctx, 'pr_GenTemplate206E');
    l_datasource:='select '''||v_report_date||''' p_txdate, '''
                             ||v_report_date||''' R_DATE,'''
                             ||l_emailSubject||''' emailsubject from dual ';
    NMPKS_EMS.PR_SENDINTERNALEMAIL(l_datasource, l_template_id, '','Y');
    plog.setEndSection(pkgctx, 'pr_GenTemplate206E');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setEndSection(pkgctx, 'pr_GenTemplate206E');
  END;

  PROCEDURE pr_GenTemplate201E
IS
    l_template_id   CHAR(4) := '201E';
    l_datasource    emaillog.datasource%TYPE;
    v_countEmail    NUMBER := 0;
BEGIN
    plog.setBeginSection(pkgctx, 'pr_GenTemplate201E');

    FOR REC IN(
SELECT TMP.QTTY , TMP.SYMBOL, TMP.HOLDING_RATIO,TMP.AFACCTNO
            FROM (
                    SELECT CF.FULLNAME,
                           SE.CUSTID,
                           SE.AFACCTNO,
                           (CASE WHEN SB.REFSYMBOL IS NULL THEN SB.SYMBOL ELSE SB.REFSYMBOL END) SYMBOL,
                           (CASE WHEN SB.REFCODEID IS NULL THEN SB.CODEID ELSE SB.REFCODEID END) CODEID,
                           SUM(SE.TRADE + SE.NETTING + SE.BLOCKED + NVL(OD_PREV.BUY_QTTY,0) - NVL(TR.NAMT,0)) QTTY_PREV, --SLCK SO HUU KY TRUOC
                           SUM(SE.TRADE + SE.NETTING + SE.BLOCKED + NVL(OD.BUY_QTTY,0)) QTTY, -- SLCK SO HUU KY NAY
                           SUM(NVL(SI_PREV.NEWCIRCULATINGQTTY,0)) NEWCIRCULATINGQTTY_PREV, --KHOI LUONG LUU HANH MOI TAI NGAY TRUOC
                           SUM(NVL(SI.NEWCIRCULATINGQTTY,0)) NEWCIRCULATINGQTTY, --KHOI LUONG LUU HANH MOI TAI NGAY SINH EMAIL (NGAY HIEN TAI)
                           CASE WHEN SUM(NVL(SI_PREV.NEWCIRCULATINGQTTY,0)) <> 0 THEN
                                    SUM(SE.TRADE + SE.NETTING + SE.BLOCKED + NVL(OD_PREV.BUY_QTTY,0) - NVL(TR.NAMT,0))/SUM(SI_PREV.NEWCIRCULATINGQTTY)*100
                                ELSE 0 END HOLDING_RATIO_PREV, --TY LE SO HUU KY TRUOC
                           CASE WHEN SUM(NVL(SI.NEWCIRCULATINGQTTY,0)) <> 0 THEN
                                    SUM(SE.TRADE + SE.NETTING + SE.BLOCKED + NVL(OD.BUY_QTTY,0))/SUM(SI.NEWCIRCULATINGQTTY)*100
                                ELSE 0 END HOLDING_RATIO --TY LE SO HUU KY NAY
                    FROM SEMAST SE
                             JOIN (
                                SELECT SB.CODEID, SB.SECTYPE, SB.SYMBOL, SB1.CODEID REFCODEID, SB1.SYMBOL REFSYMBOL, SB.EXPDATE, SB.PARVALUE
                                    , (CASE WHEN SB.REFCODEID IS NULL THEN SB.TRADEPLACE ELSE SB1.TRADEPLACE END) TRADEPLACE
                                FROM SBSECURITIES SB, SBSECURITIES SB1
                                WHERE SB.REFCODEID = SB1.CODEID(+) AND SB.SECTYPE <> '004'
                              ) SB ON SE.CODEID = SB.CODEID
                         LEFT JOIN (
                                   SELECT CUSTODYCD, ACCTNO, SYMBOL,
                                   SUM(CASE WHEN TXTYPE='C' THEN NAMT ELSE -NAMT END) NAMT
                                   FROM VW_SETRAN_GEN
                                   WHERE BUSDATE  > GETPREVDATE(GETCURRDATE,1) AND FIELD IN ('TRADE','NETTING','BLOCKED')
                                   GROUP BY CUSTODYCD, ACCTNO, SYMBOL
                                   )TR ON SE.ACCTNO = TR.ACCTNO
                         LEFT JOIN  (
                                        SELECT CUSTODYCD, AFACCTNO, SYMBOL, CODEID, TXDATE, SEACCTNO,
                                               SUM(CASE WHEN EXECTYPE='NB' THEN EXECQTTY ELSE 0 END) BUY_QTTY
                                        FROM VW_ODMAST_ALL
                                        WHERE TXDATE = GETPREVDATE(GETCURRDATE,1)
                                        GROUP BY CUSTODYCD, AFACCTNO, SYMBOL, CODEID, TXDATE, SEACCTNO
                                        HAVING SUM(CASE WHEN EXECTYPE='NB' THEN EXECQTTY ELSE 0 END) <> 0
                                     )OD_PREV ON SE.ACCTNO = OD_PREV.SEACCTNO
                         LEFT JOIN  (
                                        SELECT CUSTODYCD, AFACCTNO, SYMBOL, CODEID, TXDATE, SEACCTNO,
                                               SUM(CASE WHEN EXECTYPE='NB' THEN EXECQTTY ELSE 0 END) BUY_QTTY
                                        FROM VW_ODMAST_ALL
                                        WHERE TXDATE = GETCURRDATE
                                        GROUP BY CUSTODYCD, AFACCTNO, SYMBOL, CODEID, TXDATE, SEACCTNO
                                        HAVING SUM(CASE WHEN EXECTYPE='NB' THEN EXECQTTY ELSE 0 END) <> 0
                                     )OD ON SE.ACCTNO = OD.SEACCTNO
                         LEFT JOIN VW_SECURITIES_INFO_HIST SI ON SE.CODEID = SI.CODEID AND SI.HISTDATE =GETCURRDATE
                         LEFT JOIN VW_SECURITIES_INFO_HIST SI_PREV ON SE.CODEID = SI_PREV.CODEID AND SI_PREV.HISTDATE =GETPREVDATE(GETCURRDATE,1)
                         JOIN CFMAST CF ON SE.CUSTID = CF.CUSTID
                    GROUP BY SE.CUSTID,CF.FULLNAME,SE.AFACCTNO,
                             (CASE WHEN SB.REFSYMBOL IS NULL THEN SB.SYMBOL ELSE SB.REFSYMBOL END),
                             (CASE WHEN SB.REFCODEID IS NULL THEN SB.CODEID ELSE SB.REFCODEID END)
                    ORDER BY SE.CUSTID
                 ) TMP
            WHERE TMP.HOLDING_RATIO_PREV < 4 AND HOLDING_RATIO >= 4
           )
    LOOP
            l_datasource:='select '''||TO_CHAR(REC.QTTY, '999G999G999G999G999', 'NLS_NUMERIC_CHARACTERS=","')||''' p_quantity, '''
                                     ||REC.SYMBOL||''' p_securities_name, '''
                                     ||ROUND(REC.HOLDING_RATIO,2)||''' p_current_holding_ratio  from dual ';
            nmpks_ems.pr_sendInternalEmail(l_datasource, l_template_id, rec.afacctno,'Y');
    END LOOP;
    plog.setEndSection(pkgctx, 'pr_GenTemplate201E');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setEndSection(pkgctx, 'pr_GenTemplate201E');
  END;

  PROCEDURE pr_sendInternalEmail (p_datasource IN VARCHAR2,
                                 p_template_id IN VARCHAR2,
                                 p_afacctno    IN VARCHAR2 DEFAULT '',
                                 p_sendTemplateLnk IN VARCHAR2 DEFAULT 'N')
  IS
  l_email   VARCHAR2(2000);
  l_custodycd varchar2(100);
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_sendInternalEmail');
    if trim(p_template_id) <> 'EM10' then
        --------Send mail cho khach hang-----------
        BEGIN
            SELECT TRIM(EMAIL) EMAIL, CUSTODYCD
            INTO  L_EMAIL, L_CUSTODYCD
            FROM CFMAST CF, AFMAST AF
            WHERE CF.CUSTID = AF.CUSTID
            AND AF.ACCTNO = P_AFACCTNO;
        EXCEPTION
          WHEN OTHERS THEN
            l_email := '';
            l_custodycd := p_afacctno;
        END;
        -------------------------------------------
    else
        select substr(p_datasource, instr(p_datasource,'FEEAMT,')+8, instr(p_datasource,'EMAIL,') - instr(p_datasource,'FEEAMT,')-10)
        into l_email
        from dual;
    end if;

    FOR rec IN (
            SELECT email
            FROM tlprofiles tl, templateslnk lnk WHERE tl.tlid = lnk.tlid AND lnk.templateid = trim(p_template_id) AND p_sendTemplateLnk = 'Y'
            UNION
            SELECT emailcs email FROM templates WHERE code = trim(p_template_id) AND emailcs IS NOT NULL
    ) LOOP
       --IF nmpks_ems.CheckEmail(rec.email) THEN
         IF (l_email IS NULL and p_template_id not in ('EM24','EM25','EM26','EM27')) OR length(l_email) <= 0 THEN
           l_email := rec.email;
         ELSE
           l_email := l_email || ', ' || rec.email;
         END IF;
       --END IF;

    END LOOP;
    --
    --
    InsertEmailLog(p_email       => l_email,
                   p_template_id => p_template_id,
                   p_data_source => p_datasource,
                   p_account     => l_custodycd);
    plog.setEndSection(pkgctx, 'pr_sendInternalEmail');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_sendInternalEmail');
  END;


procedure prc_EmailReq2API(
    p_account IN VARCHAR2,
    p_email IN VARCHAR2,
    p_subject IN VARCHAR2,
    p_datasource IN VARCHAR2,
    p_EmailContent IN clob,
    p_return_code in out VARCHAR2,
    P_return_msg in out VARCHAR2
)
IS
    l_fullname      VARCHAR2(500);
    l_email         VARCHAR2(500);
    l_datasource    VARCHAR2(3800);
    l_EmailContent  clob;
    l_emailmode     VARCHAR2(10);
    l_SEQ           VARCHAR2(1000);
    l_sendstatus    VARCHAR2(100);
    l_err_code      VARCHAR2(100);
BEGIN

    plog.setbeginsection (pkgctx, 'prc_EmailReq2API');
    Begin
        select max(nvl(fa.fullname,mst.username))
            into l_fullname
        from userlogin mst, famembers fa
        where mst.username  = p_account
            and to_char(mst.reffamemberid) = fa.shortname (+);
    exception
        when others then
            l_fullname := '';
    End;

    l_SEQ           := TO_CHAR(SYSTIMESTAMP,'YYYYMMDDHH24MISSFF8');
    l_email         := p_email;
    l_datasource    := p_datasource; /*String SQL*/
    l_EmailContent  := p_EmailContent; /*String HTML */

    -- Fill data from SQL to string HTML
    --
    --
    cspks_saproc.prc_FillValueFromSQL(l_datasource,l_EmailContent);

    SELECT varvalue INTO l_emailmode FROM sysvar WHERE varname ='EMAILMODE';
    --

    IF l_emailmode = 'Y' THEN
        Begin
            gwpkg_sendemail.prc_sendHTMLemail(l_SEQ,
                                             nvl(l_fullname,'N/A'),                               l_email,
                                            p_subject,
                                            l_EmailContent,
                                            p_return_code,
                                            P_return_msg,
                                            l_err_code);
        exception
        when others then
            
            
            plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
            INSERT INTO emaillog (autoid,email,datasource,status,createtime,note, refid)
            VALUES(seq_emaillog.NEXTVAL,l_email,l_EmailContent,'E',systimestamp, 'Error:' || p_return_msg, l_SEQ);
            plog.setEndSection(pkgctx, 'InsertEmailLog');
            return;
        End;

        IF p_return_code ='S' THEN
            --sending
            l_sendstatus :='S';
        ELSE
             --Error
            l_sendstatus :='E';
        END IF;

        INSERT INTO emaillog (autoid,email,datasource,status,createtime,note, refid)
        VALUES(seq_emaillog.NEXTVAL,l_email,l_EmailContent,l_sendstatus,systimestamp,p_return_code, l_SEQ);

    Else
        --Cap nhat emaillog
        INSERT INTO emaillog (autoid,email,datasource,status,createtime,note, refid)
        VALUES(seq_emaillog.NEXTVAL,l_email,l_EmailContent,'R',systimestamp,'Emailmode:' || l_emailmode, l_SEQ);
    End If;

    plog.setendsection (pkgctx, 'prc_EmailReq2API');
EXCEPTION WHEN OTHERS THEN
      plog.error (pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'prc_EmailReq2API');
      raise errnums.e_system_error;
END;

procedure prc_EmailReq2API_NEW(
    p_account IN VARCHAR2,
    p_email IN VARCHAR2,
    p_subject IN VARCHAR2,
    p_datasource IN VARCHAR2,
    p_EmailContent IN clob,
    p_template_id IN varchar2,
    p_return_code in out VARCHAR2,
    P_return_msg in out VARCHAR2

)
IS
    l_fullname      VARCHAR2(500);
    l_email         VARCHAR2(3000);
    l_datasource    VARCHAR2(3800);
    l_datasource_ref VARCHAR2(3800);
    l_subject    VARCHAR2(3800);
    l_EmailContent  clob;
    l_emailmode     VARCHAR2(10);
    l_SEQ           VARCHAR2(1000);
    l_sendstatus    VARCHAR2(100);
    l_err_code      VARCHAR2(100);
    l_refrptlogs    number;
BEGIN

    plog.setbeginsection (pkgctx, 'prc_EmailReq2API_NEW');

    l_email         := trim(p_email);
    l_datasource    := p_datasource; /*String SQL*/
    l_EmailContent  := p_EmailContent; /*String HTML */
    l_subject       := p_subject;

    BEGIN
        SELECT MAX(NVL(FA.FULLNAME,MST.USERNAME))
        INTO L_FULLNAME
        FROM USERLOGIN MST, FAMEMBERS FA
        WHERE MST.USERNAME = P_ACCOUNT
        AND TO_CHAR(MST.REFFAMEMBERID) = FA.SHORTNAME(+);
    EXCEPTION WHEN OTHERS THEN
        L_FULLNAME := L_EMAIL;
    END;

    -- Fill data from SQL to string HTML
    --
    --
    cspks_saproc.prc_FillValueFromSQL(l_datasource,l_EmailContent);

    cspks_saproc.prc_FillValueFromSQL(l_datasource,l_subject);

    SELECT varvalue INTO l_emailmode FROM sysvar WHERE varname ='EMAILMODE';
    IF l_emailmode = 'Y' THEN

        l_refrptlogs := null;
        FOR RECAT IN (
            SELECT * FROM ATTACHMENTS WHERE attachment_id = p_template_id AND ROWNUM = 1
        ) LOOP
            l_datasource_ref := 'SELECT * FROM DUAL';
            CREATE_RPT_REQUEST(RECAT.REPORT_ID, l_datasource, p_template_id, p_account, l_refrptlogs, l_datasource_ref);
            BEGIN
                cspks_saproc.prc_FillValueFromSQL(l_datasource_ref,l_subject);
            EXCEPTION WHEN OTHERS THEN
                l_subject := l_subject;
            END;
        END LOOP;

        for rec in (
            select REGEXP_SUBSTR(l_email,'[^,]+',1,LEVEL) email
            from dual connect by  REGEXP_SUBSTR(l_email,'[^,]+',1,LEVEL) is not null
        )
        loop
            l_SEQ           := TO_CHAR(SYSTIMESTAMP,'YYYYMMDDHH24MISSFF8');
            INSERT INTO emaillog (autoid,email,templateid,datasource,status,createtime,note, refid,emailcontent,fullname,subject,processtatus, refrptlogs)
            VALUES(seq_emaillog.NEXTVAL,trim(rec.email),p_template_id,p_datasource,'N',systimestamp,p_return_code, l_SEQ,l_EmailContent,l_fullname,l_subject,'N', l_refrptlogs);
        end loop;
    Else
        --Cap nhat emaillog
        l_SEQ           := TO_CHAR(SYSTIMESTAMP,'YYYYMMDDHH24MISSFF8');
        INSERT INTO emaillog (autoid,email,datasource,status,createtime,note, refid, refrptlogs)
        VALUES(seq_emaillog.NEXTVAL,l_email,l_EmailContent,'R',systimestamp,'Emailmode:' || l_emailmode, l_SEQ, l_refrptlogs);
    End If;

    plog.setendsection (pkgctx, 'prc_EmailReq2API_NEW');
EXCEPTION WHEN OTHERS THEN
      plog.error (pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'prc_EmailReq2API_NEW');
      raise errnums.e_system_error;
END;

    PROCEDURE CREATE_RPT_REQUEST(p_report_id IN VARCHAR2, p_datasource IN VARCHAR2, p_template_id IN VARCHAR2, p_account IN VARCHAR2, p_refrptlogs IN OUT VARCHAR2, p_datasource_ref IN OUT VARCHAR2)
    IS
        l_rptParam  VARCHAR2(2000) := '(:l_refcursor, ''A'', ''0001''';
        l_rebuild   NUMBER;
        l_shortname VARCHAR2(500);
        l_filename  VARCHAR2(1000);
        l_createtime TIMESTAMP;
        l_passzip varchar2(100);
        l_getcurrdate date;
        l_iszip varchar2(1);
    BEGIN
        plog.setbeginsection (pkgctx, 'CREATE_RPT_REQUEST');

        l_createtime := SYSTIMESTAMP;
        l_shortname := '';
        l_passzip := '';
        l_iszip := 'N';
        l_getcurrdate := getcurrdate();

        BEGIN
            SELECT VARVALUE INTO l_iszip
            FROM SYSVAR
            WHERE GRNAME = 'SYSTEM'
            AND VARNAME = 'ISZIPFILE';
        EXCEPTION WHEN OTHERS THEN
            l_iszip := 'N';
        END;

        FOR R1 IN (
            SELECT SHORTNAME FROM FAMEMBERS WHERE AUTOID = TO_NUMBER((CASE WHEN IS_NUMBER(P_ACCOUNT) = 0 THEN '-1' ELSE P_ACCOUNT END))
        )
        LOOP
            l_shortname := R1.SHORTNAME;
            l_passzip := R1.SHORTNAME || TO_CHAR(l_getcurrdate,'RRRR') || '#Shinhan';
        END LOOP;

        FOR R2 IN (
            SELECT SHORTNAME FROM CFMAST WHERE CUSTODYCD = (CASE WHEN IS_NUMBER(P_ACCOUNT) = 0 THEN P_ACCOUNT ELSE '-1' END)
        )
        LOOP
            l_shortname := R2.SHORTNAME;
            l_passzip := P_ACCOUNT || '#' || TO_CHAR(l_getcurrdate,'RRRR');
        END LOOP;

        IF p_report_id IN ('OD6008_1','OD6008_2','OD6008_3') THEN
            l_filename := 'SHBVN_Position_report_[RPTLOGID]_' || l_shortname || '_[p_txdate]';
            p_datasource_ref := 'SELECT ''[SHBVN] Position report ' || l_shortname || ' [p_txdate]'' p_subject206e FROM DUAL';

            cspks_saproc.prc_FillValueFromSQL(p_datasource, l_filename);
            cspks_saproc.prc_FillValueFromSQL(p_datasource, p_datasource_ref);
        ELSE
            l_filename := 'CB_[RPTLOGID]_' || l_shortname || '_' || TO_CHAR(l_createtime, 'DDMMRRRR');
        END IF;



        FOR RECRPT IN (
                SELECT CF.RPTID, CF.FILETYPE
                FROM RPTGENCFG CF, RPTMASTER RPT
                WHERE CF.RPTID = RPT.RPTID
                AND CF.CYCLE_CRET = 'M'
                AND RPT.RPTID = p_report_id
        ) LOOP
            l_rebuild := 0;
            FOR REC IN (
                    SELECT * FROM RPTFIELDS WHERE OBJNAME = RECRPT.RPTID ORDER BY ODRNUM
            ) LOOP
                IF REC.FLDNAME = 'P_DATASOURCE' THEN
                    l_rptParam := l_rptParam || ',''' || REPLACE(p_datasource,'''','''''') || '''';
                    EXIT;
                ELSE
                    l_rebuild := 1;
                    l_rptParam := l_rptParam || ',''[' || lower(REC.FLDNAME) || ']''';
                END IF;
            END LOOP;
            l_rptParam := l_rptParam || ')';

            IF l_rebuild = 1 THEN
                cspks_saproc.prc_FillValueFromSQL(p_datasource, l_rptParam);
            END IF;
            p_refrptlogs := seq_rptlogs.NEXTVAL;

            l_filename := REPLACE(l_filename, '[RPTLOGID]', p_refrptlogs);
            l_filename := REGEXP_REPLACE(l_filename, '[\/:*?"<>|.'']', '_');

            if p_report_id in ('CAEM24','CAEM25','CAEM26','CAEM27') then   --thangpv  SHBVNEX-2752
                INSERT INTO  rptlogs(autoid,rptid,rptparam,status,subuserid,priority,txdate,exptype,isauto,emailtempid,crtdatetime,filename,iszip,passzip)
                VALUES(p_refrptlogs,p_report_id,l_rptParam,'P','0000','Y',getcurrdate,RECRPT.FILETYPE,'Y',p_template_id,l_createtime,l_filename,'N',l_passzip);
            else
                INSERT INTO  rptlogs(autoid,rptid,rptparam,status,subuserid,priority,txdate,exptype,isauto,emailtempid,crtdatetime,filename,iszip,passzip)
                VALUES(p_refrptlogs,p_report_id,l_rptParam,'P','0000','Y',getcurrdate,RECRPT.FILETYPE,'Y',p_template_id,l_createtime,l_filename,l_iszip,l_passzip);
            end if;

            /*INSERT INTO  rptlogs(autoid,rptid,rptparam,status,subuserid,priority,txdate,exptype,isauto,emailtempid,crtdatetime,filename,iszip,passzip)
            VALUES(p_refrptlogs,p_report_id,l_rptParam,'P','0000','Y',getcurrdate,RECRPT.FILETYPE,'Y',p_template_id,l_createtime,l_filename,l_iszip,l_passzip);*/
        END LOOP;
        plog.setendsection (pkgctx, 'CREATE_RPT_REQUEST');
    EXCEPTION WHEN OTHERS THEN
        plog.error (pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
        plog.setendsection (pkgctx, 'CREATE_RPT_REQUEST');
        raise errnums.e_system_error;
    END;

begin
  -- Initialization
  -- <Statement>;
  for i in (select * from tlogdebug) loop
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  end loop;

  pkgctx := plog.init('NMPKS_EMS',
                      plevel     => nvl(logrow.loglevel, 30),
                      plogtable  => (nvl(logrow.log4table, 'N') = 'Y'),
                      palert     => (nvl(logrow.log4alert, 'N') = 'Y'),
                      ptrace     => (nvl(logrow.log4trace, 'N') = 'Y'));
end NMPKS_EMS;
/
