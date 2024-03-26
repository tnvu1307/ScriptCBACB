SET DEFINE OFF;
CREATE OR REPLACE PACKAGE fopks_sa IS

  /** ----------------------------------------------------------------------------------------------------
  ** (c) 2019 by Financial Software Solutions. JSC.
  ** for web cb,sb,fa
  ----------------------------------------------------------------------------------------------------*/


  Procedure PRC_FOCMDCODE(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     p_err_code      in out varchar2,
                     p_err_param     in out varchar2);
  Procedure PRC_check_holidate(
                     p_date      varchar2,
                     p_holiday       IN out varchar2,
                     p_err_code      in out varchar2,
                     p_err_param     in out varchar2
                   );
  Procedure PRC_USERS(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     p_user      varchar2,
                     p_err_code      in out varchar2,
                     p_err_param     in out varchar2);
  Procedure PRC_USER_FUNC(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     p_tlid      varchar2,
                     p_err_code      in out varchar2,
                     p_err_param     in out varchar2);
  PROCEDURE sp_login(p_username      varchar2,
                     p_password      varchar2,
                     p_ipaddress      varchar2,
                     p_browser      varchar2,
                     p_os      varchar2,
                     p_ismobile      varchar2,
                     p_tlid   in out varchar2,
                     p_tlfullname in out varchar2,
                     p_err_code      in out varchar2,
                     p_err_param     in out varchar2);
  PROCEDURE sp_deactive_account(
                     p_username      varchar2,
                     p_err_code      in out varchar2,
                     p_err_param     in out varchar2);

   PROCEDURE  PRC_FOCMDCODE4REPORT(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     p_TLID IN  varchar2,
                     p_role          in varchar2,
                     p_Reflogid in varchar2,
                     p_err_code      in out varchar2,
                     p_err_param     in out varchar2);
   Procedure PRC_ALLCODE(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     p_cdtype      varchar2,
                     p_cdname      varchar2,
                     p_err_code      in out varchar2,
                     p_err_param     in out varchar2);
   procedure PRC_DEFERROR(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     p_errnum in number,
                     p_err_code      in out varchar2,
                     p_err_param     in out varchar2);
                     procedure pr_do_resetpass( p_id in varchar2,p_newpass in varchar2, p_err_code in out varchar2, p_err_param in out varchar2);
procedure pr_update_loginpass( p_username in varchar2, p_oldpass in varchar2, p_newpass in varchar2,p_action in varchar2, p_err_code in out varchar2, p_err_param in out varchar2);
   procedure pr_check_confirm_resetpass( p_id in varchar2,p_username out varchar2, p_err_code in out varchar2, p_err_param in out varchar2);
   PROCEDURE pr_forgot_password(p_username in VARCHAR2,p_email in VARCHAR2,p_action in varchar2, err_code in out varchar2, err_msg in out varchar2);
   procedure pr_verify_totp( p_objname in varchar2, p_keyval in varchar2, p_otpvalue in varchar2, p_strdata in varchar2,p_tlid IN VARCHAR2, p_role IN VARCHAR2, p_err_code in out varchar2, p_err_param in out varchar2);
PROCEDURE PR_AUTO_8894_WEB(
    p_custodycd varchar2,
    p_etfid varchar2,
    p_type varchar2,
    p_txdate varchar2,
    p_stdate varchar2,
    p_tvlq varchar2,
    p_nav number,
    p_amount number,
    p_etfqtty number,
    p_fee number,
    p_tax number,
    p_desc varchar2,
    p_stringvalue varchar2,
    p_diff number,
    tlid varchar2,
    p_reftransid  out varchar2,
    err_code in out varchar2,
    err_msg in out varchar2);
PROCEDURE PRC_GET_LIST_trading_resultETF(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     P_CUSTODYCD    IN   VARCHAR2,
                     P_TRADINGDATE     IN  VARCHAR2,
                     P_TYPE IN  VARCHAR2,
                     p_tlid IN VARCHAR2,
                     p_role IN VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2);
PROCEDURE PR_AUTO_6639_WEB(P_TXDATE VARCHAR2,P_CUSTODYCD VARCHAR2,P_ACCTNO VARCHAR2,P_PORFOLIO VARCHAR2,P_INSTRUCTION VARCHAR2,P_TRANSFER VARCHAR2,P_AMT NUMBER,P_BANK VARCHAR2,P_BANKBRANCH VARCHAR2,P_BANKACCTNO VARCHAR2,P_NAME VARCHAR2,P_REFCONTRACT VARCHAR2,P_DESC VARCHAR2,P_CITAD VARCHAR2,P_FEETYPE varchar2,P_VALUEDATE VARCHAR2,P_BALANCE NUMBER,P_FEE NUMBER,P_NETAMT NUMBER,TLID VARCHAR2,p_reftransid OUT VARCHAR2, err_code in out varchar2, err_msg in out varchar2);
PROCEDURE PRC_GET_LIST_trading_PAYMENTINSTRUCTION(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     P_CUSTODYCD    IN   VARCHAR2,
                     P_TRADINGDATE     IN  VARCHAR2,
                     p_tlid IN VARCHAR2,
                     p_role IN VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2);
PROCEDURE PRC_GET_ACCTNO_BY_CUSTODYCD(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     P_CUSTODYCD    IN   VARCHAR2,
                     P_STATUS       IN   VARCHAR2,
                      p_tlid         IN   VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2);
PROCEDURE PRC_GET_SYMBOL_SBSECURITIES (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     P_CODEID     IN  VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2);
Procedure PRC_TXPROCESS4FUND(p_updatemode varchar2,
                          p_txnum varchar2 ,
                          p_txdate varchar2,
                          p_tlid varchar2,
                          P_level VARCHAR2,
                          p_err_code in out varchar2,
                          p_err_param out varchar2);
PROCEDURE PRC_GET_TICKER_SBSECURITIES (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2);
PROCEDURE PRC_GET_DEBIT_FROM_CUSTODYCD (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                    P_CUSTODYCD    IN   VARCHAR2,
                     P_TLID    IN   VARCHAR2,
                      P_ROLE    IN   VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2);
procedure PRC_GET_CITAD_LISTSOURCES (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2);
PROCEDURE PRC_GET_BROKERCODE_FROM_CUSTODYCD (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                    P_CUSTODYCD    IN   VARCHAR2,
                    P_TLID IN   VARCHAR2,
                    P_ROLE IN   VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2);
PROCEDURE PRC_GET_LIST_8864(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     P_CUSTODYCD IN  VARCHAR2,
                     P_TRADINGDATE     IN  VARCHAR2,
                     p_tlid IN VARCHAR2,
                     p_role IN VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2);
PROCEDURE PRC_GET_LISTED_TRADING_RESULT_FOR_BROKER(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     P_CUSTODYCD IN  VARCHAR2,
                     P_TRADINGDATE     IN  VARCHAR2,
                     p_tlid IN VARCHAR2,
                     p_role IN VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2);
PROCEDURE PRC_GET_TRANSACTIONTYPE_6639 (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2);
PROCEDURE PRC_GET_CIFID_FROM_CUSTODYCD (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                    P_CUSTODYCD    IN   VARCHAR2,
                    P_TLID IN   VARCHAR2,
                    P_ROLE IN   VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2);
PROCEDURE PRC_GET_ETFFUND_8894 (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2);

procedure pr_auto_8864_web(p_codeid varchar2, p_kqgd varchar2, p_desacctno varchar2,
                        p_amt varchar2, p_parvalue varchar2, p_qtty varchar2,
                        p_citad varchar2, p_grossamount varchar2, p_tradedate varchar2,
                        p_settledate varchar2, p_exectype varchar2, p_feeamt varchar2,
                        p_vatamt varchar2, p_identity varchar2, p_ap varchar2,
                        p_clearday varchar2, p_symbol varchar2, p_custodycd varchar2, p_transtype varchar2,
                        p_memberid varchar2, p_desc varchar2,P_APACCT varchar2,P_ETFDATE varchar2,  tlid varchar2,
                        p_reftransid  out varchar2, err_code in out varchar2, err_msg in out varchar2);

procedure pr_generate_otp( p_objname in varchar2,
        p_keyval in varchar2,
        p_username in varchar2,
        p_account varchar2,
        p_strdata in varchar2,
        p_isauto in varchar2,
        p_err_code in out varchar2,
        p_err_param in out varchar2);
PROCEDURE PRC_GET_IMP_TRANS_DETAIL(PV_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     p_txnum    IN   VARCHAR2,
                     p_txdate      IN  VARCHAR2,
                     p_tlid IN VARCHAR2,
                     p_role IN VARCHAR2,
                     p_err_code      IN OUT VARCHAR2,
                     p_err_param     IN OUT VARCHAR2);
PROCEDURE PRC_GET_AUTTHORIZED_8894 (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                    P_CUSTODYCD    IN   VARCHAR2,
                    p_tlid IN VARCHAR2,
                     p_role IN VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2);
PROCEDURE PRC_GET_SETTLMENTDATE_8864 (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                    p_tradingdate in varchar2,
                    p_clearday in varchar2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2);
PROCEDURE PRC_GET_BANKINFO_6639 (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                    p_type in varchar2,
                    p_bankname in varchar2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2);
procedure prc_get_list_right_transfer(p_refcursor   in out pkg_report.ref_cursor,
                                      p_fundsymbol  in varchar2,
                                      p_tradingdate in varchar2,
                                      p_camastid    in varchar2,
                                      p_type        in varchar2,
                                      p_tlid        in varchar2,
                                      p_role        in varchar2,
                                      p_err_code    in out varchar2,
                                      p_err_msg     in out varchar2);
procedure prc_get_camastid (p_refcursor in out pkg_report.ref_cursor,
                            p_fundcode  in varchar2,
                            p_tltxcd    in varchar2,
                            p_err_code  in out varchar2,
                            p_err_msg   in out varchar2);
procedure prc_get_info_account(p_refcursor   in out pkg_report.ref_cursor,
                               p_custodycd   in varchar2,
                               p_err_code    in out varchar2,
                               p_err_msg     in out varchar2);
procedure prc_get_info_from_camastid(p_refcursor   in out pkg_report.ref_cursor,
                                     p_camastid    in varchar2,
                                     p_fundcode    in varchar2,
                                     p_tltxcd      in varchar2,
                                     p_err_code    in out varchar2,
                                     p_err_msg     in out varchar2);
procedure prc_get_right_transfer_citad (p_refcursor in out pkg_report.ref_cursor,
                                        p_err_code  in out varchar2,
                                        p_err_msg   in out varchar2);
procedure prc_get_right_transfer_fromcusadd (p_refcursor in out pkg_report.ref_cursor,
                                             p_trantype  in varchar2,
                                             p_err_code  in out varchar2,
                                             p_err_msg   in out varchar2);
procedure prc_get_right_transfer_feecd (p_refcursor in out pkg_report.ref_cursor,
                                        p_err_code  in out varchar2,
                                        p_err_msg   in out varchar2);
procedure pr_auto_3383_3303_web( p_valuedate varchar2, p_camastid varchar2, p_trantype varchar2,
          p_sellaccount varchar2, p_fullname varchar2,p_licenesid varchar2,
          p_address varchar2, p_issuedate varchar2, p_issueplace varchar2,
          p_country varchar2, p_fromcusadd varchar2, p_buyaccount varchar2,
          p_fullname2 varchar2, p_licenesid2 varchar2, p_address2 varchar2,
          p_issuedate2 varchar2, p_issueplace2 varchar2, p_country2 varchar2,
          p_citad varchar2, p_symbolbuy varchar2, p_issnamebuy varchar2,
          p_symbolsell varchar2, p_issnamesell varchar2, p_qttyen number,
          p_outptrade number, p_outpblocked number,p_qttyex number,
          p_remainqtty number, p_feecode varchar2, p_transferprice number,
          p_transferamt number, p_feeamt number, p_taxrate number,
          p_taxamt number, p_desc varchar2, p_autoid varchar2, p_remoaccount varchar2,
          p_tlid varchar2, p_reftransid out varchar2, p_err_code in out varchar2, p_err_msg in out varchar2);
procedure prc_get_cash_balance_currency (p_refcursor in out pkg_report.ref_cursor,
                                         p_err_code  in out varchar2,
                                         p_err_msg   in out varchar2);
procedure prc_get_list_cash_balance(p_refcursor   in out pkg_report.ref_cursor,
                                    p_fundcode    in varchar2,
                                    p_currency    in varchar2,
                                    p_tlid        in varchar2,
                                    p_role        in varchar2,
                                    p_err_code    in out varchar2,
                                    p_err_msg     in out varchar2);
procedure prc_get_list_securities_balance(p_refcursor   in out pkg_report.ref_cursor,
                                          p_fundcode    in varchar2,
                                          p_stocktype   in varchar2,
                                          p_stockcode   in varchar2,
                                          p_tlid        in varchar2,
                                          p_role        in varchar2,
                                          p_err_code    in out varchar2,
                                          p_err_msg     in out varchar2);
procedure prc_get_ca_catype (p_refcursor in out pkg_report.ref_cursor,
                             p_err_code  in out varchar2,
                             p_err_msg   in out varchar2);
procedure prc_get_ca_status (p_refcursor in out pkg_report.ref_cursor,
                             p_err_code  in out varchar2,
                             p_err_msg   in out varchar2);
procedure prc_get_list_ca(p_refcursor   in out pkg_report.ref_cursor,
                          p_fundcode    in varchar2,
                          p_stockcode   in varchar2,
                          p_catype      in varchar2,
                          p_castatus    in varchar2,
                          p_fromdate    in varchar2,
                          p_todate      in varchar2,
                          p_tlid        in varchar2,
                          p_role        in varchar2,
                          p_err_code    in out varchar2,
                          p_err_msg     in out varchar2);
procedure pr_auto_3384_web( p_camastid       varchar2,
                            p_custodycd      varchar2,
                            p_qtty           number,
                            p_valuedate      varchar2,
                            p_tlid           varchar2,
                            p_reftransid     out varchar2,
                            p_err_code       in out varchar2,
                            p_err_msg        in out varchar2);
procedure prc_get_list_regis_right_sub(p_refcursor   in out pkg_report.ref_cursor,
                                       p_fundsymbol  in varchar2,
                                       p_valuedate   in varchar2,
                                       p_camastid    in varchar2,
                                       p_tlid        in varchar2,
                                       p_role        in varchar2,
                                       p_err_code    in out varchar2,
                                       p_err_msg     in out varchar2);
procedure prc_get_list_regis_bond_convert(p_refcursor   in out pkg_report.ref_cursor,
                                          p_fundsymbol  in varchar2,
                                          p_valuedate   in varchar2,
                                          p_camastid    in varchar2,
                                          p_tlid        in varchar2,
                                          p_role        in varchar2,
                                          p_err_code    in out varchar2,
                                          p_err_msg     in out varchar2);
procedure pr_auto_3333_web( p_fundcode varchar2, p_valuedate varchar2, p_custodycd varchar2,
                            p_camastid varchar2, p_symbol varchar2, p_symbolname varchar2,
                            p_qtty_en number, p_reportdate varchar2, p_exrate varchar2,
                            p_maxqtty number, p_qtty number, p_remainqtty number,
                            p_subprice number, p_desc varchar2, p_tlid varchar2,
                            p_reftransid out varchar2, p_err_code in out varchar2, p_err_msg in out varchar2);
procedure prc_get_list_lapse_right(p_refcursor   in out pkg_report.ref_cursor,
                                   p_fundsymbol  in varchar2,
                                   p_valuedate   in varchar2,
                                   p_camastid    in varchar2,
                                   p_tlid        in varchar2,
                                   p_role        in varchar2,
                                   p_err_code    in out varchar2,
                                   p_err_msg     in out varchar2);
procedure prc_get_autoid_docstransfer (p_refcursor in out pkg_report.ref_cursor,
                                       p_fundcode  in varchar2,
                                       p_type      in varchar2,
                                       p_err_code  in out varchar2,
                                       p_err_msg   in out varchar2);
procedure prc_get_crphysagreeid (p_refcursor in out pkg_report.ref_cursor,
                                 p_fundcode  in varchar2,
                                 p_err_code  in out varchar2,
                                 p_err_msg   in out varchar2);
procedure prc_get_ticker (p_refcursor in out pkg_report.ref_cursor,
                          p_err_code  in out varchar2,
                          p_err_msg   in out varchar2);
procedure pr_auto_1405_1406_web( p_fundcode varchar2, p_custodycd varchar2, p_type varchar2,
                                 p_tradingdate varchar2, p_autoid varchar2, p_receiver varchar2,
                                 p_sender varchar2, p_crphysagreeid varchar2, p_codeid varchar2,
                                 p_qtty number, p_desc varchar2, p_tlid varchar2,
                                 p_reftransid out varchar2, p_err_code in out varchar2, p_err_msg in out varchar2);
procedure prc_get_info_from_fundcode(p_refcursor   in out pkg_report.ref_cursor,
                                     p_fundcode   in varchar2,
                                     p_err_code    in out varchar2,
                                     p_err_msg     in out varchar2);
procedure prc_get_info_from_ticker(p_refcursor   in out pkg_report.ref_cursor,
                                   p_ticker   in varchar2,
                                   p_err_code    in out varchar2,
                                   p_err_msg     in out varchar2);
procedure prc_get_info_from_crphysagreeid(p_refcursor   in out pkg_report.ref_cursor,
                                          p_crphysagreeid   in varchar2,
                                          p_err_code    in out varchar2,
                                          p_err_msg     in out varchar2);
procedure prc_get_info_from_autoid(p_refcursor   in out pkg_report.ref_cursor,
                                   p_autoid      in varchar2,
                                   p_err_code    in out varchar2,
                                   p_err_msg     in out varchar2);
procedure prc_get_list_physical(p_refcursor   in out pkg_report.ref_cursor,
                                p_fundsymbol  in varchar2,
                                p_valuedate   in varchar2,
                                p_type        in varchar2,
                                p_ticker      in varchar2,
                                p_tlid        in varchar2,
                                p_role        in varchar2,
                                p_err_code    in out varchar2,
                                p_err_msg     in out varchar2);
procedure prc_revert(p_refcursor   in out pkg_report.ref_cursor,
                     p_txnum       in varchar2,
                     p_txdate      in varchar2,
                     p_err_code    in out varchar2,
                     p_err_msg     in out varchar2);
procedure prc_get_securities_statement(p_refcursor   in out pkg_report.ref_cursor,
                                       p_fundsymbol  in varchar2,
                                       p_stocktype   in varchar2,
                                       p_fromdate    in varchar2,
                                       p_todate      in varchar2,
                                       p_stockcode   in varchar2,
                                       p_tlid        in varchar2,
                                       p_role        in varchar2,
                                       p_err_code    in out varchar2,
                                       p_err_msg     in out varchar2);
PROCEDURE PRC_GET_BALANCE_6639 (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                    P_CUSTODYCD    IN   VARCHAR2,
                    P_ACCTNO    IN   VARCHAR2,
                    p_tlid        in varchar2,
                    p_role        in varchar2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2);
procedure PRC_GET_RPTFIELDS(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     p_err_code      in out varchar2,
                     p_err_param     in out varchar2);
 PROCEDURE PRC_GET_LIST_SECURITIES_INFORMATION(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     TICKER    IN   VARCHAR2,
                     p_tlid IN VARCHAR2,
                     p_role IN VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2);
 PROCEDURE PRC_GET_LIST_SECURITIES_BALANCE_ONLINE(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     P_CUSTODYCD    IN   VARCHAR2,
                     P_TICKER    IN   VARCHAR2,
                     P_ISINCODE    IN   VARCHAR2,
                     p_tlid IN VARCHAR2,
                     p_role IN VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2) ;
PROCEDURE PRC_GET_LIST_SECURITIES_STATEMENT(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     P_CUSTODYCD    IN   VARCHAR2,
                     P_FRDATE    IN   VARCHAR2,
                     P_TODATE    IN   VARCHAR2,
                     P_SECTYPE IN VARCHAR2,
                     P_TICKER IN VARCHAR2,
                     P_ISINCODE IN VARCHAR2,
                     P_TYPE IN VARCHAR2,
                       p_tlid IN VARCHAR2,
                     p_role IN VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2);
PROCEDURE PRC_GET_FULLNAME_BYCUSTODYCD (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                      P_CUSTODYCD      IN  VARCHAR2,
                      P_tlid      IN  VARCHAR2,
                       P_ROLE      IN  VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2);
PROCEDURE PRC_GET_LIST_CASH_STATEMENT(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     P_CUSTODYCD    IN   VARCHAR2,
                     P_ACCTNO    IN   VARCHAR2,
                     P_FRDATE    IN   VARCHAR2,
                     P_TODATE    IN   VARCHAR2,
                     P_TYPE IN VARCHAR2,
                     p_tlid IN VARCHAR2,
                     p_role IN VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2);
 PROCEDURE PRC_GET_LIST_CASHBALANCE(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     P_CUSTODYCD    IN   VARCHAR2,
                     P_BANKACCTNO  IN VARCHAR2,
                     P_CURRENCY    IN   VARCHAR2,
                     P_STATUS    IN   VARCHAR2,
                     p_tlid IN VARCHAR2,
                     p_role IN VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2);
PROCEDURE PRC_GET_ALERT_NOTICE(p_2 out CLOB);
 PROCEDURE vinh_test1(p_2 out BLOB);
 PROCEDURE PRC_GET_LIST_TEMPLATE_IMPORT(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     p_tlid IN VARCHAR2,
                     p_role IN VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2);
PROCEDURE PRC_GET_STOCKS(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     P_CFICODE       in varchar2,
                     p_err_code      IN OUT VARCHAR2,
                     p_err_param     IN OUT VARCHAR2);
 PROCEDURE PRC_GET_DEPOSITORY_MEMBER (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                      P_tlid      IN  VARCHAR2,
                       P_ROLE      IN  VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2);
PROCEDURE PRC_GET_TICKER_DEPOSIT (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                      P_CUSTODYCD      IN  VARCHAR2,
                      P_tlid      IN  VARCHAR2,
                       P_ROLE      IN  VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2);
procedure PRC_USERS1(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     p_user      varchar2,
                     p_role      varchar2,
                     p_rolemaker      varchar2,
                     p_roleapprove      varchar2,
                     p_custodycd      varchar2,
                     p_listcustodycd      varchar2,
                     p_listsymbol      varchar2,
                     p_action      varchar2,
                     p_err_code      in out varchar2,
                     p_err_param     in out varchar2);
  Procedure PRC_USER_FUNC1(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     p_tlid      varchar2,
                     p_err_code      in out varchar2,
                     p_err_param     in out varchar2);
   PROCEDURE PRC_GET_feecal_6639 (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                    P_TRANSFERTYPE    IN   VARCHAR2,
                    P_CUSTODYCD    IN   VARCHAR2,
                    P_AMT  IN  number ,
                    p_FEETYPE   IN VARCHAR2 ,
                    p_tlid        in varchar2,
                    p_role        in varchar2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2);
 PROCEDURE PRC_GET_net_amount_6639 (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                    P_FEETYPE    IN   VARCHAR2,
                    P_AMT    IN   number,
                    P_FEEAMT    number,
                    p_tlid        in varchar2,
                    p_role        in varchar2,
                    err_code      IN OUT VARCHAR2,
                    err_msg     IN OUT VARCHAR2);
PROCEDURE PRC_GET_LIST_OD8894(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     p_tlid IN VARCHAR2,
                     p_role IN VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2);
PROCEDURE PRC_GET_LIST_IMPORT_BROKER(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     p_tlid IN VARCHAR2,
                     p_role IN VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2);
procedure pr_auto_8802_web(p_autoid varchar2,p_deletetype varchar2,  tlid varchar2, p_reftransid  out varchar2, err_code in out varchar2, err_msg in out varchar2);
procedure PR_AUTO_8802_WEB_BROKER(p_autoid varchar2,p_deletetype varchar2,  tlid varchar2, p_reftransid  out varchar2, err_code in out varchar2, err_msg in out varchar2);
PROCEDURE PRC_GET_LIST_OD0012(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     p_tlid IN VARCHAR2,
                     p_role IN VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2);
procedure PR_AUTO_8895_WEB(p_orderid varchar2,  tlid varchar2, p_reftransid  out varchar2, err_code in out varchar2, err_msg in out varchar2);
PROCEDURE PRC_GET_LIST_CANCEL_6639_WEB(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     P_CUSTODYCD    IN   VARCHAR2,
                     P_TRADINGDATE     IN  VARCHAR2,
                     p_tlid IN VARCHAR2,
                     p_role IN VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2) ;
procedure PR_CANCEL_6639_WEB(p_txnum varchar2,p_txdate varchar2,  tlid varchar2, p_reftransid  out varchar2, err_code in out varchar2, err_msg in out varchar2);
PROCEDURE PRC_GET_FX_REQUIRES_WEB(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     p_tlid IN VARCHAR2,
                     p_role IN VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2);
procedure PR_FX_REQUIRES_WEB(
    p_valuedate varchar2,
    p_custodycd varchar2,
    p_TransferAccount varchar2,
    p_RecevingAccount varchar2,
    p_amount number,
    p_description  varchar2,
    tlid varchar2,
    p_reftransid  out varchar2,
    err_code in out varchar2,
    err_msg in out varchar2
 );
 END FOPKS_SA;
/


CREATE OR REPLACE PACKAGE BODY fopks_sa is
  -- Private variable declarations
  C_FO_LOGIN  constant char := 'I';
  C_FO_LOGOUT constant char := 'O';
  C_FO_LOG    constant char := 'L';

  C_FO_USER_DOES_NOT_EXISTED   constant number := -107;
  C_FO_CUSTOMER_STATUS_INVALID constant number := -107;
  C_FO_USER_BLOCKED constant number := -108;
  C_FO_USER_PENDING constant number := -109;
  C_FO_INVALID_USER constant number := -111;
  C_TLID_ONLINE constant VARCHAR2(10) := '6868';
  pkgctx plog.log_ctx;
  logrow tlogdebug%rowtype;
  -- Function and procedure implementations
  procedure PRC_ALLCODE(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     p_cdtype      varchar2,
                     p_cdname      varchar2,
                     p_err_code      in out varchar2,
                     p_err_param     in out varchar2) as

      v_cdtype      varchar2(100);
      v_cdname      varchar2(100);
  begin

    plog.setBeginSection(pkgctx, 'PRC_ALLCODE');
    plog.debug(pkgctx, 'PRC_ALLCODE'|| 'p_cdtype:'||p_cdtype|| 'p_cdname:'||p_cdname);
    p_err_code  := systemnums.C_SUCCESS;
    p_err_param := 'SUCCESS';

     If p_cdtype is null or length(p_cdtype) = 0 then
         v_cdtype:='%';
     ELSE
         v_cdtype:=p_cdtype;
     End if;

    Open p_refcursor for
          SELECT 'CB.'||A.CDTYPE||'.'||A.CDNAME||'.'||A.CDVAL CDID,
          A.CDTYPE, A.CDNAME,A.CDVAL,A.LSTODR,'' CDPARENT,A.CDCONTENT,A.EN_CDCONTENT, 'CB' APPMODE
        FROM  (SELECT * FROM ALLCODE A ORDER BY A.lstodr) A
        WHERE (p_cdtype is null or p_cdtype = A.CDTYPE)
         AND (p_cdname is null or p_cdname = A.CDNAME)
         ;

    plog.setEndSection(pkgctx, 'PRC_ALLCODE');
  exception
    when others then
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace );
      plog.setEndSection(pkgctx, 'PRC_ALLCODE');
  end PRC_ALLCODE;

 -- nhac viec



  procedure PRC_FOCMDCODE(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     p_err_code      in out varchar2,
                     p_err_param     in out varchar2) as
  begin

    plog.setBeginSection(pkgctx, 'PRC_FOCMDCODE');


    p_err_code  := systemnums.C_SUCCESS;
    p_err_param := 'SUCCESS';

    Open p_refcursor for
        SELECT A.CMDCODE, A.CMDTEXT, A.CMDUSE, A.CMDTYPE, A.CMDDESC
        FROM FOCMDCODE A
        WHERE A.CMDUSE='Y'
        /*UNION ALL
        SELECT  r.objname||'.'||r.defname CMDCODE, r.llistonline CMDTEXT, 'Y' CMDUSE, 'RPTFIELDS' CMDTYPE, 'Auto CMDCODE from RPTFIELDS '|| r.objname||'.'||r.defname || '==>' || r.caption CMDDESC
        from rptfields r
        WHERE r.llistonline IS NOT null;
        */
        ;
    plog.setEndSection(pkgctx, 'PRC_FOCMDCODE');
  exception
    when others then
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error(pkgctx,'Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
      plog.setEndSection(pkgctx, 'PRC_FOCMDCODE');
  end PRC_FOCMDCODE;



  procedure PRC_USERS(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     p_user      varchar2,
                     p_err_code      in out varchar2,
                     p_err_param     in out varchar2) as
    l_user varchar2(50);
  begin

    plog.setBeginSection(pkgctx, 'PRC_USERS');
    plog.debug(pkgctx, 'PRC_USERS'|| 'p_user:'||p_user);

    p_err_code  := systemnums.C_SUCCESS;
    p_err_param := 'SUCCESS';
    If p_user is null or length(p_user)=0 then
        l_user :='%';
    ELSE
        l_user:=p_user;
    End if;

    Open p_refcursor for
        select u.username tlid,u.username userid,u.username || cd.cdval userkey,u.username tlfullname,'' mbcode ,'Y' active,
               'YYYYY', 'Y' status, '' department ,
               '' tltitle, '' idcode, '' mobile, '' email,'' description,
               'SHB' dbcode,cd.cdval rolecode,nvl(t.listsymbol,'') listsymbol,u.listcustodycd,u.ROLE,u.custodycd
        FROM userlogin u, allcode cd,
            (select u.username,
            listagg(f.symbol,',') within group (order by u.username) as listsymbol
            from userlogin u, cbfafund f
            where instr(NVL(u.listcustodycd,u.custodycd),f.custodycd)>0 group by u.username)t
        where  u.status ='A'
        AND cd.cdtype ='SY' AND cd.cdname ='SYROLE' AND INSTR(u.rolecd,cd.cdval)>0
        AND u.username like l_user
        AND u.username = t.username(+);

    plog.setEndSection(pkgctx, 'PRC_USERS');
  exception
    when others then
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error(pkgctx,'Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
      plog.setEndSection(pkgctx, 'PRC_USERS');
  end PRC_USERS;

  PROCEDURE PRC_USER_FUNC(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     p_tlid      varchar2,
                     p_err_code      in out varchar2,
                     p_err_param     in out varchar2) as
    l_tlid varchar2(50);

  BEGIN

    plog.setBeginSection(pkgctx, 'PRC_USER_FUNC');


    p_err_code  := systemnums.C_SUCCESS;
    p_err_param := 'SUCCESS';

    IF p_tlid IS NULL OR length(p_tlid)=0 THEN
        l_tlid :='%';
    ELSE
        l_tlid:=p_tlid;
    END IF;
    OPEN p_REFCURSOR FOR


        SELECT   tlr.tlid,
             tlr.tlid USERID,
             tlr.rolecd roles,
             f.cmdid,
             f.prid,
             f.lev,
             f.last,
             f.menutype,
             f.objname,
             f.cmdname,
             f.en_cmdname,
             f.kr_cmdname,
             'Y' IsInquiry,
        ( CASE WHEN  instr(tlr.rolemaker,f.roles)>0 then 'Y' ELSE 'N' END) IsAdd,
        ( CASE WHEN  instr(tlr.rolemaker,f.roles)>0 then 'Y' ELSE 'N' END) IsEdit,
        ( CASE WHEN  instr(tlr.rolemaker,f.roles)>0 then 'Y' ELSE 'N'END ) IsDelete,
        tlr.roleapprove IsApprove,
        tlr.role
        FROM
        (select u.USERNAME tlid,u.rolecd, u.rolemaker, u.roleapprove,u.role
         from
        userlogin u
        where u.status ='A') tlr,
         focmdmenu f
        where   tlr.tlid like l_tlid
            AND (
                    tlr.role = 'AP'
                        AND f.cmdid IN ('000000', '002000', '002010')
                    OR tlr.role='CTCK'
                        and f.cmdid IN ('300000','001022','001121')
                    OR tlr.role NOT IN( 'AP','CTCK')
                        AND (INSTR (tlr.rolecd, f.roles) > 0 OR f.roles = 'ALL')
                 )
        order by tlr.tlid,f.cmdid;
    plog.setEndSection(pkgctx, 'PRC_USER_FUNC');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error(pkgctx,'Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
      plog.setEndSection(pkgctx, 'PRC_USER_FUNC');
  END PRC_USER_FUNC;
  -- Function and procedure implementations
 PROCEDURE sp_login(p_username      varchar2,
                     p_password      varchar2,
                     p_ipaddress      varchar2,
                     p_browser      varchar2,
                     p_os      varchar2,
                     p_ismobile      varchar2,
                     p_tlid   in out varchar2,
                     p_tlfullname in out varchar2,
                     p_err_code      in out varchar2,
                     p_err_param     in out varchar2) AS

    l_username varchar2(50);
    l_active   char(1);
    l_status varchar2(10);
    l_loginpwd varchar2(2000);
    l_statusLogin varchar2(10); --C:complete,E:error
    l_countfail number;
  begin

    plog.setBeginSection(pkgctx, 'sp_login');
    plog.debug(pkgctx, 'sp_login'|| 'p_username:'||p_username|| 'p_password:'||p_password|| 'p_tlid:'||p_tlid|| 'p_tlfullname:'||p_tlfullname);
    --
    p_err_code  := systemnums.C_SUCCESS;
    p_err_param := 'SUCCESS';

    l_statusLogin:= 'E' ;

    BEGIN

      select u.username,u.username,  u.username fullname,'Y',u.status,u.loginpwd
            INTO    l_username, p_tlid, p_tlfullname, l_active,l_status,l_loginpwd
      from  userlogin u
      where  upper(u.username) = upper(p_username)
      and u.status in('A','P','C');

    exception
      when NO_DATA_FOUND then
        p_err_code := C_FO_INVALID_USER;
        p_err_param:='Invalid information';
        insert into login_online_history(autoid,username,hashpwd,ipaddress,browser,os,ismobile,logintime,status,errcode,errmsg)
        values (seq_login_online_history.nextval,p_username,genencryptpassword(p_password),p_ipaddress,p_browser,p_os,p_ismobile,SYSDATE,l_statusLogin,p_err_code,p_err_param);
        return;
        --raise errnums.E_BIZ_RULE_INVALID;
    end;
    if l_status = 'C' then
        p_err_code := C_FO_USER_BLOCKED;
        p_err_param:='Your account have been blocked';
        insert into login_online_history(autoid,username,hashpwd,ipaddress,browser,os,ismobile,logintime,status,errcode,errmsg)
        values (seq_login_online_history.nextval,p_username,genencryptpassword(p_password),p_ipaddress,p_browser,p_os,p_ismobile,SYSDATE,l_statusLogin,p_err_code,p_err_param);
        return;
    elsif l_status = 'P' then
        p_err_code := C_FO_USER_PENDING;
        p_err_param:='Account is in chaging process';
        insert into login_online_history(autoid,username,hashpwd,ipaddress,browser,os,ismobile,logintime,status,errcode,errmsg)
        values (seq_login_online_history.nextval,p_username,genencryptpassword(p_password),p_ipaddress,p_browser,p_os,p_ismobile,SYSDATE,l_statusLogin,p_err_code,p_err_param);
        return;
    end if;

    if NVL(l_loginpwd, 'PASSNULL') <> genencryptpassword(p_password) then
        p_err_code := C_FO_USER_DOES_NOT_EXISTED;
        p_err_param:='Username or password is invalid';

        insert into login_online_history(autoid,username,hashpwd,ipaddress,browser,os,ismobile,logintime,status,errcode,errmsg)
        values (seq_login_online_history.nextval,p_username,genencryptpassword(p_password),p_ipaddress,p_browser,p_os,p_ismobile,SYSDATE,l_statusLogin,p_err_code,p_err_param);

        --dem so lan dang nhap sai pass ke tu lan login thanh cong gan nhat trong ngay
        select count (1) into l_countfail
        from login_online_history
        where username=p_username AND to_char(LOGINTIME,'DD/MM/RRRR')=to_char(SYSDATE,'DD/MM/RRRR') and status='E' and errcode='-107'
        AND LOGINTIME > (select MAX(LOGINTIME) from login_online_history WHERE USERNAME=p_username and status='C' );

        --neu chua co lan nao dang nhap thanh cong trong ngay thi dem so lan login fail trong ngay
        if l_countfail=0 then
            select count (1) into l_countfail
            from login_online_history
            where username=p_username AND to_char(LOGINTIME,'DD/MM/RRRR')=to_char(SYSDATE,'DD/MM/RRRR') and status='E' and errcode='-107';
        end if;

        if l_countfail >= 5 then -- 5 lan thi se block acount+ghi log
             p_err_code := C_FO_USER_BLOCKED;
             p_err_param:='Fail 5 times ,block account';
            update userlogin set status='C' where username= p_username;
            insert into login_online_history(autoid,username,hashpwd,ipaddress,browser,os,ismobile,logintime,status,errcode,errmsg)
            values (seq_login_online_history.nextval,p_username,genencryptpassword(p_password),p_ipaddress,p_browser,p_os,p_ismobile,SYSDATE,l_statusLogin,p_err_code,p_err_param);
        end if;
        return;

    end if;

    if p_err_code = systemnums.C_SUCCESS then
        l_statusLogin:= 'C' ;
        insert into login_online_history(autoid,username,hashpwd,ipaddress,browser,os,ismobile,logintime,status,errcode,errmsg)
        values (seq_login_online_history.nextval,p_username,genencryptpassword(p_password),p_ipaddress,p_browser,p_os,p_ismobile,SYSDATE,l_statusLogin,p_err_code,p_err_param);
        return;
    end if;



    --sp_audit_authenticate(p_username, C_FO_LOGIN, '', 'Login successful');
    plog.setEndSection(pkgctx, 'sp_login');
  exception
    when others then
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.setEndSection(pkgctx, 'sp_login');
  end;

  function fn_is_ho_active return boolean as
    l_status char(1);
  begin
    -- TO DO
    l_status := cspks_system.fn_get_sysvar('SYSTEM', 'HOSTATUS');

    if nvl(l_status, '0') = '0' then
      return false;
    end if;

    return true;
  exception
    when others then
      return false;
  end;

  PROCEDURE sp_deactive_account(
                     p_username      varchar2,
                     p_err_code      in out varchar2,
                     p_err_param     in out varchar2) AS

  begin

    plog.setBeginSection(pkgctx, 'sp_deactive_account');

    p_err_code  := systemnums.C_SUCCESS;
    p_err_param := 'SUCCESS';

    update userlogin set status='C' where username= p_username;

    plog.setEndSection(pkgctx, 'sp_deactive_account');
  exception
    when errnums.E_BIZ_RULE_INVALID then
      for i in (select errdesc, en_errdesc
                  from deferror
                 where errnum = p_err_code)
      loop
        p_err_param := i.errdesc;
      end loop;
      plog.setEndSection(pkgctx, 'sp_deactive_account');
    when others then
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.setEndSection(pkgctx, 'sp_deactive_account');
  end;


  -- Audit log
  procedure sp_audit_log(p_key varchar2, p_text varchar2) as
  begin
    plog.setbeginsection(pkgctx, 'sp_audit_log');
    --Ghi log xu ly
   /* insert into fo_audit_logs
      (action_date, username, action_desc)
    values
      (sysdate, p_key, p_text);*/

    plog.debug(pkgctx, p_text);
    plog.setendsection(pkgctx, 'sp_audit_log');
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'sp_audit_log');
  end;

  -- Audit login/ logout
  procedure sp_audit_authenticate(p_key  varchar2,
                                  p_type char,
                                  p_channel varchar2,
                                  p_text varchar2) as
    l_text varchar2(200);
  begin
    plog.setbeginsection(pkgctx, 'sp_audit_authenticate');

    plog.debug(pkgctx, l_text);

    l_text := p_key || ' - ' || p_text;
    --Ghi log xu ly
 /*   insert into fo_audit_logs
      (action_date, username, channel, action_type, action_desc)
    values
      (sysdate, p_key, p_channel, p_type, l_text);*/

    plog.setendsection(pkgctx, 'sp_audit_authenticate');
    commit;
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'sp_audit_authenticate');
  end;
  procedure PRC_DEFERROR(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     p_errnum in number,
                     p_err_code      in out varchar2,
                     p_err_param     in out varchar2) as
  begin

    plog.setBeginSection(pkgctx, 'PRC_DEFERROR');


    p_err_code  := systemnums.C_SUCCESS;
    p_err_param := 'SUCCESS';

    Open p_refcursor for
    Select  d.errnum, d.errdesc, d.en_errdesc, d.modcode, 'CB' APPMODE,d.errnum||'CB' KEYERRNUM
    From deferror d
    Where p_errnum is null or d.errnum=p_errnum;

    plog.setEndSection(pkgctx, 'PRC_DEFERROR');
  exception
    when others then
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error(pkgctx,'Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
      plog.setEndSection(pkgctx, 'PRC_DEFERROR');
  end PRC_DEFERROR;


  procedure PRC_FOCMDCODE4REPORT(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     p_TLID IN  varchar2,
                     p_role          in varchar2,
                     p_Reflogid in varchar2,
                     p_err_code      in out varchar2,
                     p_err_param     in out varchar2) as
  begin

    plog.setBeginSection(pkgctx, 'PRC_FOCMDCODE');


    p_err_code  := systemnums.C_SUCCESS;
    p_err_param := 'SUCCESS';

 Open p_refcursor FOR

       SELECT  R.RPTID, R.description description, R.en_description en_description
     FROM
            rptmaster R
     WHERE  r.visible = 'Y' AND R.cmdtype ='R' AND r.islocal ='Y'
            GROUP BY R.RPTID,R.description, R.en_description
            ORDER BY R.rptid;

    plog.setEndSection(pkgctx, 'PRC_FOCMDCODE4REPORT');
  exception
    when others then
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error(pkgctx,'Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
      plog.setEndSection(pkgctx, 'PRC_FOCMDCODE4REPORT');
  end PRC_FOCMDCODE4REPORT;

procedure pr_check_confirm_resetpass( p_id in varchar2,p_username out varchar2, p_err_code in out varchar2, p_err_param in out varchar2)
is
    /*
    Input
        p_id: id KH duoc cap
        p_username: User dang nhap
    Output:
        p_err_code: Ma loi
        p_err_param: Mo ta loi
    */
 v_days number;
  v_hours number;
   v_minutes number;
      v_seconds number;
      v_final number;
      v_timeout number;
      v_username varchar2(10);
begin
    p_err_code      := '0';
    p_err_param      := 'Success';
    plog.setbeginsection (pkgctx, 'pr_check_confirm_resetpass');



    Begin
    select to_number(varvalue) into v_timeout from sysvar where varname='TIMEOUT_LINKACTIVE' and grname='FO';
        select username into p_username
            from reset_login_pass where id=p_id and status ='Y'
             and sysdate<=createdate + (1/1440*v_timeout);
    exception
    when NO_DATA_FOUND
        then
            p_username:=null;
    End;



    plog.setendsection (pkgctx, 'pr_check_confirm_resetpass');
exception
when others
   then
      p_err_code := errnums.c_system_error;
      for i in (
            select errdesc,en_errdesc from deferror
            where errnum = p_err_code
        ) loop
            p_err_param := i.errdesc;
        end loop;
      plog.error (pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_check_confirm_resetpass');
      raise errnums.e_system_error;
end pr_check_confirm_resetpass;

procedure pr_do_resetpass( p_id in varchar2,p_newpass in varchar2, p_err_code in out varchar2, p_err_param in out varchar2)
is
    /*
    Input
        p_id: id KH duoc cap
        p_newpass: password KH can set
    Output:
        p_err_code: Ma loi
        p_err_param: Mo ta loi
    */
    v_username      varchar2(255);
       v_final number;
      v_timeout number;
begin
    p_err_code      := '0';
    p_err_param      := 'Success';
    plog.setbeginsection (pkgctx, 'pr_do_resetpass');



    Begin
        select to_number(varvalue) into v_timeout from sysvar where varname='TIMEOUT_LINKACTIVE' and grname='FO';
        select username into v_username
            from reset_login_pass where id=p_id and status ='Y'
           and sysdate<=createdate + (1/1440*v_timeout);
    exception
    when NO_DATA_FOUND
        then
            p_err_code := '-911007';
            for i in (
                select errdesc,en_errdesc from deferror
                where errnum = p_err_code
            ) loop
                p_err_param := i.errdesc;
            end loop;

            plog.error (pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
            plog.setendsection (pkgctx, 'pr_do_resetpass');
            return ;
    End;

    update userlogin set loginpwd=genencryptpassword(p_newpass),status='A' where username= v_username;
    update reset_login_pass set STATUS='N' where USERNAME=v_username and STATUS= 'Y';



    plog.setendsection (pkgctx, 'pr_do_resetpass');
exception
when others
   then
      p_err_code := errnums.c_system_error;
      for i in (
            select errdesc,en_errdesc from deferror
            where errnum = p_err_code
        ) loop
            p_err_param := i.errdesc;
        end loop;
      plog.error (pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_do_resetpass');
      raise errnums.e_system_error;
end pr_do_resetpass;

procedure pr_update_loginpass( p_username in varchar2, p_oldpass in varchar2, p_newpass in varchar2,p_action in varchar2, p_err_code in out varchar2, p_err_param in out varchar2)
is
    /*
    Input
        p_username: user dang nhap
        p_oldpass : pass cu
        p_newpass: pass moi
    Output:
        p_err_code: Ma loi
        p_err_param: Mo ta loi
    */
    v_count         number;

begin
    p_err_code      := '0';
    p_err_param      := 'Success';
    plog.setbeginsection (pkgctx, 'pr_update_loginpass');


    Select count(1) into v_count
    from userlogin u
    where u.username = p_username and u.loginpwd = genencryptpassword(p_oldpass);

    If v_count = 0 then
        -- khong dung thong tin username, password
        p_err_code := '-911007';
        for i in (
            select errdesc,en_errdesc from deferror
            where errnum = p_err_code
        ) loop
            p_err_param := i.errdesc;
        end loop;

        plog.error (pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
        plog.setendsection (pkgctx, 'pr_update_loginpass');
        return ;
    End If;

    If p_action= 'confirm' then
        update userlogin set loginpwd = genencryptpassword(p_newpass) where username=p_username and loginpwd = genencryptpassword(p_oldpass);
    End If;
    plog.setendsection (pkgctx, 'pr_update_loginpass');
exception
when others
   then
    p_err_code := errnums.c_system_error;
    for i in (
        select errdesc,en_errdesc from deferror
        where errnum = p_err_code
    ) loop
        p_err_param := i.errdesc;
    end loop;

    plog.error (pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
    plog.setendsection (pkgctx, 'pr_update_loginpass');
    raise errnums.e_system_error;
end pr_update_loginpass;

procedure pr_generate_otp( p_objname in varchar2,
      p_keyval in varchar2,
      p_username in varchar2,
      p_account varchar2,
      p_strdata in varchar2,
      p_isauto in varchar2,
      p_err_code in out varchar2,
      p_err_param in out varchar2)
    is
    /*
    Input
        p_objname: Ma chuc nang tren Online
        p_keyval: Key cua GD
        p_username: User dang nhap
        p_account: So TK (neu co)
        p_strdata: Gia tri khac (neu co), field du phong dung sau nay.
    Output:
        p_err_code: Ma loi
        p_err_param: Mo ta loi
    */
    v_otpvalue      varchar2(1000);
    v_secset        varchar2(1000);
    v_issueddt      date;
    v_exprieddt     date;
    v_otpretrycnt   number;
    v_otppasstimeout    number;
    v_email         VARCHAR2(1000);
    v_fullname      VARCHAR2(1000);
    v_username      VARCHAR2(200);
    v_datasource    VARCHAR2(1000);
    v_emailmode     VARCHAR2(10);
    v_sendstatus    VARCHAR2(10);
    v_fromemail     VARCHAR2(100);
    v_return_code   VARCHAR2(100);
    v_return_msg    VARCHAR2(1000);
    v_err_code      VARCHAR2(100);
    v_desc          VARCHAR2(1000);
    v_sql           VARCHAR2(2000);
    v_SEQ           VARCHAR2(1000);
    v_otpcheck      VARCHAR2(5);
    v_Timecheck     VARCHAR2(5);
BEGIN
    p_err_code  := systemnums.C_SUCCESS;
    p_err_param := 'SUCCESS';
    Begin
        select varvalue into v_otpcheck  from sysvar where varname='OTPCHECK';
    exception
    when others
        then v_otpcheck := 'N';
    End;
     if p_objname= 'TRANS'  then
        fopks_file.pr_check_time_online(v_Timecheck,p_err_code,p_err_param);
        return;
     end if;
    plog.setbeginsection (pkgctx, 'pr_generate_otp');
    v_otpvalue      := round(DBMS_RANDOM.value(100000,999999));
    v_secset        := genencryptpassword(v_otpvalue);

    if(LENGTH(TRIM(p_keyval)) > 0) then
        update otp_logs set   status='C' where refid=p_keyval;
    end if;

    Begin
        select sysdate, sysdate + (1/1440*varvalue) into v_ISSUEDDT, v_EXPRIEDDT from sysvar where VARNAME='OTPPASSTIMEOUT';
    exception
    when others
        then
            v_ISSUEDDT  := sysdate;
            v_EXPRIEDDT := sysdate;
    End;

    -- Sinh Log OTP
    INSERT INTO otp_logs (AUTOID,REFCODE,REFID,SECSET,ISSUEDDT,EXPRIEDDT,STATUS,RETRY_COUNT,LASTCHANGE,ISAUTO)
    select seq_otp_logs.nextval, p_objname, p_keyval, v_secset, v_ISSUEDDT, v_EXPRIEDDT, 'A', 0, SYSTIMESTAMP, p_isauto from dual;

    --gui email otp cho khach hang
    BEGIN
        SELECT varvalue INTO v_emailmode FROM sysvar WHERE varname ='EMAILMODE';
        SELECT varvalue INTO v_fromemail FROM sysvar WHERE varname ='FROMEMAIL';
        -- So lan nhap sai
        SELECT varvalue INTO v_otpretrycnt FROM sysvar WHERE varname ='OTPRETRYCNT';
        -- Thoi gian time out co so phut, SHB yeu cau 180, he thong dang de la 3 * 60 = 180
        SELECT nvl(to_number(varvalue),5)  INTO v_otppasstimeout FROM sysvar WHERE varname ='OTPPASSTIMEOUT';

        select email, fullname
        into v_email, v_fullname
        from (
                    select u1.email, cf.fullname, u1.username
                   from  userlogin u1, cfmast cf
                   where u1.role ='STC' and u1.custodycd = cf.custodycd
                   union all
                    select u2.email, fa.fullname, u2.username
                   from  userlogin u2, famembers fa
                   where u2.role ='GCB' and u2.reffamemberid = fa.shortname and fa.roles='GCB'
                   union all
                    select u2.email, fa.fullname, u2.username
                   from  userlogin u2, famembers fa
                   where u2.role ='AMC' and u2.reffamemberid = fa.shortname and fa.roles='AMC'
                   union all
                   select u1.email, cf.fullname, u1.username
                   from  userlogin u1, cfmast cf
                   where u1.role ='AP' and u1.custodycd = cf.custodycd
        ) a where a.username =p_username;

        IF v_emailmode ='Y' THEN
            BEGIN
                v_SEQ        := TO_CHAR(SYSTIMESTAMP,'YYYYMMDDHH24MISSFF8');
                v_datasource :='@s@|f|5|P000999999|'||v_fullname||'|'||v_email||'|'|| v_SEQ ||'|127' || chr(10);
                v_datasource := v_datasource || '@g1@|f|6|'||v_fullname||'|'||v_otpvalue||'|' || p_username || '|'|| v_SEQ ||'|';
                v_datasource := v_datasource || v_otppasstimeout || '|' ||  v_otpretrycnt || '|' || v_otppasstimeout || '|' ||  v_otpretrycnt ;

                ---Chuyen sang dynamic sql
                /*
                v_sql :='BEGIN MAILUSER_API.SP_NVREALTIMEACCEPT_API_GEN@REPAY_MAIL(:v_SEQ, :v_RECEIVER_NM, :v_RECEIVER, :v_JONMUN, :v_RTN_CD, :v_RTN_MSG, :v_ER_CD); END;';
                EXECUTE IMMEDIATE v_sql  USING v_SEQ, v_fullname, v_email, v_datasource, out v_return_code, out v_return_msg, out v_err_code;
                */

                BEGIN
                    INSERT INTO EMAILLOG_OTP(SEQ, RECEIVERMAIL, RECEIVERNAME, OTPVALUE, CREATED_AT)
                    VALUES(V_SEQ, V_EMAIL, V_FULLNAME, V_OTPVALUE, SYSTIMESTAMP);
                EXCEPTION WHEN OTHERS THEN
                    PLOG.ERROR (PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
                END;

                gwpkg_sendemail.prc_sendOTPemail(v_SEQ, v_fullname, v_email, v_datasource, v_return_code, v_return_msg, v_err_code);

                IF v_return_code ='S' THEN
                    --sending
                    v_sendstatus :='S';
                ELSE
                     --Error
                    v_sendstatus :='E';
                END IF;

                --p_err_code := v_err_code;
                --p_err_param := v_return_msg;

            EXCEPTION WHEN OTHERS THEN
                --Error
                v_sendstatus :='E';
                --Cap nhat emaillog
              --  INSERT INTO emaillog (autoid,email,datasource,status,createtime,note, refid)
               -- VALUES(seq_emaillog.NEXTVAL,v_email,v_datasource,v_sendstatus,SYSTIMESTAMP,v_return_msg, v_SEQ);
             --   v_datasource :='';
                v_return_msg :='Exception:'||v_sql;

                plog.error (pkgctx, sqlerrm || dbms_utility.format_error_backtrace);

            END;
            --Cap nhat emaillog
            INSERT INTO emaillog (autoid,email,datasource,status,createtime,note, refid, templateid)
            VALUES(seq_emaillog.NEXTVAL,v_email,v_datasource,v_sendstatus,SYSTIMESTAMP,v_return_msg, v_SEQ, 'OTP');

        ELSE
            --Cap nhat emaillog
            INSERT INTO emaillog (autoid,email,datasource,status,createtime,note, refid, templateid)
            VALUES(seq_emaillog.NEXTVAL,v_email,'OTP:'||v_otpvalue,'R',SYSTIMESTAMP,'', '', 'OTP');

        END IF;

    EXCEPTION WHEN OTHERS THEN
        --error

        v_sendstatus :='E';
    END;
    plog.setendsection (pkgctx, 'pr_generate_otp');
EXCEPTION
when others
   then
      p_err_code := errnums.c_system_error;
      plog.error (pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_generate_otp');
      raise errnums.e_system_error;
end pr_generate_otp;

procedure pr_verify_totp_bk( p_objname in varchar2,
 p_keyval in varchar2,
 p_otpvalue in varchar2,
 p_strdata in varchar2,
 p_tlid IN VARCHAR2,
 p_role IN VARCHAR2,
 p_err_code in out varchar2,
 p_err_param in out varchar2)
is
    /*
    Input
        p_objname: Ma chuc nang
        p_keyval : Key cua GD
        p_otpvalue: Ma OTP
        p_strdata: Gia tri khac (neu co), field du phong dung sau nay.
    Output:
        p_err_code: Ma loi
        p_err_param: Mo ta loi
    */
    v_count         number;
    v_exprieddt     date;
    v_otpretrycnt   number;
    v_otpcheck    varchar2(1);
begin
    p_err_code      := '0';
    p_err_param      := 'Success';
    plog.setbeginsection (pkgctx, 'pr_verify_totp');


  Begin
        select varvalue into v_otpcheck  from sysvar where varname='OTPCHECK';
    exception
    when others
        then v_otpcheck := 'N';
    End;

    Begin
        select varvalue into v_otpretrycnt  from sysvar where varname='OTPRETRYCNT';
    exception
    when others
        then v_otpretrycnt := 1;
    End;

    if v_otpcheck <>'N' then
        Select count(1) into v_count
        from otp_logs
        where status ='A' and refid = p_keyval and secset = genencryptpassword(p_otpvalue);

        If v_count = 0 then
            -- OTP Khong dung
            p_err_code := '-202000';
            for i in (
                select errdesc,en_errdesc from deferror
                where errnum = p_err_code
            ) loop
                p_err_param := i.errdesc;
            end loop;

            plog.error (pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
            plog.setendsection (pkgctx, 'pr_generate_otp');
            return ;
        End If;


        Select count(1) into v_count
        from otp_logs
        where status ='A' and refid = p_keyval

        and secset = genencryptpassword(p_otpvalue)
        and exprieddt > sysdate
        and retry_count < v_otpretrycnt;

        If v_count = 0 then
            -- OTP het han
            p_err_code := '-202001';
            for i in (
                select errdesc,en_errdesc from deferror
                where errnum = p_err_code
            ) loop
                p_err_param := i.errdesc;
            end loop;

            plog.error (pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
            plog.setendsection (pkgctx, 'pr_generate_otp');
            return;
        End If;
    END IF;

    plog.setendsection (pkgctx, 'pr_verify_totp');
exception
when others
   then
    p_err_code := errnums.c_system_error;
    for i in (
        select errdesc,en_errdesc from deferror
        where errnum = p_err_code
    ) loop
        p_err_param := i.errdesc;
    end loop;

    plog.error (pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
    plog.setendsection (pkgctx, 'pr_verify_totp');
    raise errnums.e_system_error;
end pr_verify_totp_bk;

PROCEDURE pr_forgot_password(p_username in VARCHAR2,p_email in VARCHAR2,p_action in varchar2,  err_code in out varchar2, err_msg in out varchar2
                         ) IS
  L_TXMSG       TX.MSG_RECTYPE;
  V_STRCURRDATE VARCHAR2(20);
  V_STRDESC     VARCHAR2(1000);
  V_STREN_DESC  VARCHAR2(1000);
  V_TLTXCD      VARCHAR2(10);
  V_PARAM       VARCHAR2(1000);
  V_ERR_CODE    VARCHAR2(10);
  P_ERR_MESSAGE VARCHAR2(500);
  L_TXNUM         VARCHAR2(20);
  V_TLID        VARCHAR2(5);
  V_OTAUTHTYPE  VARCHAR2(2);
BEGIN

    ------------------------
    V_ERR_CODE    := SYSTEMNUMS.C_SUCCESS;
    P_ERR_MESSAGE := 'SUCCESS';
    PLOG.SETBEGINSECTION (PKGCTX, 'pr_auto_0024');
    V_TLTXCD := '0024';
    ------------------------

    BEGIN
      Select u. authtype into V_OTAUTHTYPE
        from userlogin u
        where  u.username = p_username and u.email = p_email;
      EXCEPTION
            WHEN NO_DATA_FOUND THEN
               -- khong dung thong tin username, email
            err_code := '-911007';
            for i in (
                select errdesc,en_errdesc from deferror
                where errnum = err_code
            ) loop
                err_msg := i.errdesc;
            end loop;

            plog.error (pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
            plog.setendsection (pkgctx, 'pr_forgot_password');
            return ;
    END;

    if p_action <> 'confirm' then
        return;
    end if;

    BEGIN
    SELECT TXDESC, EN_TXDESC
    INTO V_STRDESC, V_STREN_DESC
    FROM TLTX
    WHERE TLTXCD = V_TLTXCD;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            V_STRDESC:= null;
            V_STREN_DESC:= null;
    END;
    ------------------------
    SELECT TO_DATE (varvalue, systemnums.c_date_format)
    INTO v_strCURRDATE
    FROM sysvar
    WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

    ------------------------
    BEGIN
        SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD (SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
        INTO L_TXNUM
        FROM DUAL;
    EXCEPTION
          WHEN NO_DATA_FOUND THEN
            L_TXNUM:= null;
    END;
    ------------------------
    L_TXMSG.MSGTYPE     :='T';
    L_TXMSG.LOCAL       :='N';
    BEGIN
    SELECT TLID
    INTO L_TXMSG.TLID
    FROM cfmast
    where custodycd=p_username;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            L_TXMSG.TLID:=systemnums.C_ONLINE_USERID;
    END;
    ------------------------
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
    INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS
    FROM DUAL;
    ------------------------
    BEGIN
        SELECT BRID
        INTO L_TXMSG.BRID
        FROM TLPROFILES WHERE TLID=L_TXMSG.TLID;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           L_TXMSG.BRID:= null;
    END;
    ------------------------
    L_TXMSG.OFF_LINE    := 'N';
    L_TXMSG.DELTD       := TXNUMS.C_DELTD_TXNORMAL;
    L_TXMSG.TXSTATUS    := TXSTATUSNUMS.C_TXCOMPLETED;
    L_TXMSG.MSGSTS      := '0';
    L_TXMSG.OVRSTS      := '0';
    L_TXMSG.BATCHNAME   := 'DAY';
    L_TXMSG.REFTXNUM    := L_TXNUM;
    L_TXMSG.TXDATE      := TO_DATE(V_STRCURRDATE,SYSTEMNUMS.C_DATE_FORMAT);
    L_TXMSG.BUSDATE     := TO_DATE(V_STRCURRDATE,SYSTEMNUMS.C_DATE_FORMAT);
    L_TXMSG.TLTXCD      := V_TLTXCD;

 --------------------------SET CAC FIELD GIAO DICH-------------------------------
  ----SET TXNUM
  BEGIN
  SELECT L_TXMSG.BRID || LPAD(seq_txnum.NEXTVAL, 6, '0')
  INTO L_TXMSG.TXNUM
  FROM DUAL;
  EXCEPTION
        WHEN NO_DATA_FOUND THEN
           L_TXMSG.TXNUM:= null;
  END;





  --30    Di?n gi?i   D
   l_txmsg.txfields ('30').defname   := 'DESC';
   l_txmsg.txfields ('30').TYPE      := 'D';
   l_txmsg.txfields ('30').value      := V_STRDESC;
  --03    User Name   T
   l_txmsg.txfields ('03').defname   := 'USERNAME';
   l_txmsg.txfields ('03').TYPE      := 'T';
   l_txmsg.txfields ('03').value      := p_username;
  --04    Email   T
   l_txmsg.txfields ('04').defname   := 'EMAIL';
   l_txmsg.txfields ('04').TYPE      := 'T';
   l_txmsg.txfields ('04').value      := p_email;
  --06    L?i x?th?c   C
   l_txmsg.txfields ('06').defname   := 'OTAUTHTYPE';
   l_txmsg.txfields ('06').TYPE      := 'C';
   l_txmsg.txfields ('06').value      := V_OTAUTHTYPE;


err_code:=TXPKS_#0024.FN_BATCHTXPROCESS(L_TXMSG, V_ERR_CODE, P_ERR_MESSAGE);

--------------------------------------------------------------------------------
  IF err_code <>SYSTEMNUMS.C_SUCCESS THEN
    PLOG.ERROR(PKGCTX,
               V_PARAM || ' run ' || V_TLTXCD || ' got ' || V_ERR_CODE || ':' ||
               P_ERR_MESSAGE);

   /* for i in (
        select errdesc,en_errdesc from deferror
        where errnum =V_ERR_CODE
    ) loop
        err_msg := i.errdesc;
    end loop;*/
err_code:=V_ERR_CODE;


    ROLLBACK;
    PLOG.SETENDSECTION(PKGCTX, 'pr_auto_0024');
    RETURN;
  END IF;
--------------------------------------------------------------------------------
 PLOG.SETENDSECTION(PKGCTX, 'pr_auto_0024');
 EXCEPTION
    WHEN OTHERS THEN
        V_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.ERROR(PKGCTX,
                   ' Err: ' || SQLERRM || ' Trace: ' ||
                   DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

        PLOG.SETENDSECTION(PKGCTX, 'pr_auto_0024');
        ERR_CODE   := V_ERR_CODE;
END;

procedure PR_AUTO_8894_WEB(
    p_custodycd varchar2,
    p_etfid varchar2,
    p_type varchar2,
    p_txdate varchar2,
    p_stdate varchar2,
    p_tvlq varchar2,
    p_nav number,
    p_amount number,
    p_etfqtty number,
    p_fee number,
    p_tax number,
    p_desc varchar2,
    p_stringvalue varchar2,
    p_diff number,
    tlid varchar2,
    p_reftransid  out varchar2,
    err_code in out varchar2,
    err_msg in out varchar2
 ) is
    L_TXMSG       TX.MSG_RECTYPE;
     V_CODEIDETF VARCHAR2(20);
    V_STRCURRDATE VARCHAR2(20);
    V_STRDESC     VARCHAR2(1000);
    V_STREN_DESC  VARCHAR2(1000);
    V_TLTXCD      VARCHAR2(10);
    P_XMLMSG      VARCHAR2(4000);
    V_PARAM       VARCHAR2(1000);
    V_ETFNAME       VARCHAR2(1000);
    V_DC          NUMBER;
    V_FUNDCODEID   VARCHAR2(50);
    V_AMT         NUMBER;
    V_ERR_CODE    VARCHAR2(10);
    P_ERR_MESSAGE VARCHAR2(500);
    L_TXNUM         VARCHAR2(20);
    V_FULLNAME       VARCHAR2(1000);
    V_TLID        VARCHAR2(5);
    V_XMLMSG_STRING    varchar2(5000);
    V_NEW_STRING_ETF    varchar2(5000);
BEGIN
    ------------------------
    v_err_code    := systemnums.c_success;
    p_err_message := 'success';
    plog.setbeginsection (pkgctx, 'pr_auto_8894');
    v_tltxcd := '8894';
    p_reftransid :='';
    ------------------------
    begin
        select txdesc, en_txdesc
            into v_strdesc, v_stren_desc
        from tltx
        where tltxcd = v_tltxcd;
    exception
        when no_data_found then
            v_strdesc:= null;
            v_stren_desc:= null;
    end;
    ------------------------
    SELECT TO_DATE (varvalue, systemnums.c_date_format)
    INTO v_strCURRDATE
    FROM sysvar
    WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

    ------------------------
    BEGIN
        SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD (SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
        INTO L_TXNUM
        FROM DUAL;
    EXCEPTION
          WHEN NO_DATA_FOUND THEN
            L_TXNUM:= null;
    END;
    ------------------------
    L_TXMSG.MSGTYPE     :='T';
    L_TXMSG.LOCAL       :='N';
    L_TXMSG.TLID        :='6868';
    BEGIN
    SELECT TLID
    INTO v_tlid
    FROM cfmast
    where custodycd=P_CUSTODYCD;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
           v_tlid:= null;
    END;
    ------------------------
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
    INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS
    FROM DUAL;
    ------------------------
    BEGIN
        SELECT BRID
        INTO L_TXMSG.BRID
        FROM TLPROFILES WHERE TLID=v_tlid;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           L_TXMSG.BRID:= null;
    END;
    ------------------------
    L_TXMSG.OFF_LINE    := 'N';
    L_TXMSG.DELTD       := TXNUMS.C_DELTD_TXNORMAL;
    L_TXMSG.TXSTATUS    := TXSTATUSNUMS.c_txlogged;
    L_TXMSG.MSGSTS      := '0';
    L_TXMSG.OVRSTS      := '0';
    L_TXMSG.BATCHNAME   := 'DAY';
    L_TXMSG.REFTXNUM    := L_TXNUM;
    L_TXMSG.TXDATE      := TO_DATE(V_STRCURRDATE,SYSTEMNUMS.C_DATE_FORMAT);
    L_TXMSG.BUSDATE     := TO_DATE(V_STRCURRDATE,SYSTEMNUMS.C_DATE_FORMAT);
    L_TXMSG.TLTXCD      := V_TLTXCD;
    l_txmsg.nosubmit    := '1';
    l_txmsg.ovrrqd      := '@0';

 --------------------------SET CAC FIELD GIAO DICH-------------------------------
  ----SET TXNUM
  BEGIN
  SELECT L_TXMSG.BRID || LPAD(seq_txnum.NEXTVAL, 6, '0')
  INTO L_TXMSG.TXNUM
  FROM DUAL;
  EXCEPTION
        WHEN NO_DATA_FOUND THEN
           L_TXMSG.TXNUM:= null;
  END;

    p_reftransid :='['|| TO_char( L_TXMSG.TXDATE,SYSTEMNUMS.C_DATE_FORMAT)  ||']['||L_TXMSG.txnum||']';
    fopks_file.rebuildStringETF(P_STRINGVALUE,V_NEW_STRING_ETF,err_code,err_msg);

  ---------------ETFCODEID------------------
  BEGIN
  SELECT SB.codeid
  INTO V_CODEIDETF
  FROM SBSECURITIES SB
  WHERE  SB.symbol=P_ETFID;
  EXCEPTION
        WHEN NO_DATA_FOUND THEN
           V_CODEIDETF:= null;
  END;
  ---------------ETFCODEID------------------


  ---------------ETFNAME------------------
  BEGIN
  SELECT ISS.FULLNAME
  INTO V_ETFNAME
  FROM SBSECURITIES SB, ISSUERS ISS
  WHERE SB.ISSUERID = ISS.ISSUERID  AND SB.CODEID=V_CODEIDETF;
  EXCEPTION
        WHEN NO_DATA_FOUND THEN
           V_ETFNAME:= null;
  END;
  ---------------FULLNAME------------------
  BEGIN
  SELECT FULLNAME
  INTO V_FULLNAME
  FROM CFMAST CF
  WHERE CF.CUSTODYCD = P_CUSTODYCD;
  EXCEPTION
        WHEN NO_DATA_FOUND THEN
           V_FULLNAME:= null;
  END;
    ----FUNDCODEID OK----------------------
  l_txmsg.txfields('03').defname := 'ETFID';
  l_txmsg.txfields('03').TYPE := 'C';
  l_txmsg.txfields('03').VALUE := V_CODEIDETF;

   ----CTCK  OK
  L_TXMSG.TXFIELDS('05').DEFNAME := 'CTCK';
  L_TXMSG.TXFIELDS('05').TYPE := 'C';
  L_TXMSG.TXFIELDS('05').VALUE := NULL;
     ----QTTY  OK
  L_TXMSG.TXFIELDS('06').DEFNAME := 'ETFQTTY';
  L_TXMSG.TXFIELDS('06').TYPE := 'N';
  L_TXMSG.TXFIELDS('06').VALUE := P_ETFQTTY ;
     ----FULLNAME OK
  L_TXMSG.TXFIELDS('07').DEFNAME := 'FULLNAME';
  L_TXMSG.TXFIELDS('07').TYPE := 'C';
  L_TXMSG.TXFIELDS('07').VALUE := V_FULLNAME;
    ----NAV OK
  L_TXMSG.TXFIELDS('08').DEFNAME := 'NAV';
  L_TXMSG.TXFIELDS('08').TYPE := 'N';
  L_TXMSG.TXFIELDS('08').VALUE := P_NAV;
    ----AMT OK
  L_TXMSG.TXFIELDS('09').DEFNAME := 'AMOUNT';
  L_TXMSG.TXFIELDS('09').TYPE := 'N';
  L_TXMSG.TXFIELDS('09').VALUE := P_AMOUNT;
     ----FEE OK
  L_TXMSG.TXFIELDS('10').DEFNAME := 'FEE';
  L_TXMSG.TXFIELDS('10').TYPE := 'N';
  L_TXMSG.TXFIELDS('10').VALUE := P_FEE;
    ----TAX OK
  L_TXMSG.TXFIELDS('11').DEFNAME := 'TAX';
  L_TXMSG.TXFIELDS('11').TYPE := 'N';
  L_TXMSG.TXFIELDS('11').VALUE := P_TAX;
    ----TYPE OK
  L_TXMSG.TXFIELDS('12').DEFNAME := 'TYPE';
  L_TXMSG.TXFIELDS('12').TYPE := 'C';
  L_TXMSG.TXFIELDS('12').VALUE := P_TYPE;
    ----SET TXDATE
  L_TXMSG.TXFIELDS('20').DEFNAME := 'TXDATE';
  L_TXMSG.TXFIELDS('20').TYPE := 'D';
  L_TXMSG.TXFIELDS('20').VALUE :=  P_TXDATE;

    ----DESC OK
  L_TXMSG.TXFIELDS('30').DEFNAME := 'DESC';
  L_TXMSG.TXFIELDS('30').TYPE := 'C';
  L_TXMSG.TXFIELDS('30').VALUE := P_DESC;
      ----CLEARDATE
  L_TXMSG.TXFIELDS('40').DEFNAME := 'STDATE';
  L_TXMSG.TXFIELDS('40').TYPE := 'D';
  L_TXMSG.TXFIELDS('40').VALUE := P_STDATE;
     ----STRINGDATA OK
  L_TXMSG.TXFIELDS('50').DEFNAME := 'STRINGVALUE';
  L_TXMSG.TXFIELDS('50').TYPE := 'C';
  L_TXMSG.TXFIELDS('50').VALUE := V_NEW_STRING_ETF;
      ----ACCTNO OK
  L_TXMSG.TXFIELDS('51').DEFNAME := 'ACCTNO';
  L_TXMSG.TXFIELDS('51').TYPE := 'C';
  L_TXMSG.TXFIELDS('51').VALUE := P_CUSTODYCD;
     ----AP  NO
  L_TXMSG.TXFIELDS('83').DEFNAME := 'TVLQ';
  L_TXMSG.TXFIELDS('83').TYPE := 'C';
  L_TXMSG.TXFIELDS('83').VALUE := P_TVLQ;
       ---- ETFNAME
  L_TXMSG.TXFIELDS('82').DEFNAME := 'ETFNAME';
  L_TXMSG.TXFIELDS('82').TYPE := 'C';
  L_TXMSG.TXFIELDS('82').VALUE := V_ETFNAME;
  ----CUSTODYCD OK
  L_TXMSG.TXFIELDS('88').DEFNAME := 'CUSTODYCD';
  L_TXMSG.TXFIELDS('88').TYPE := 'C';
  L_TXMSG.TXFIELDS('88').VALUE := P_CUSTODYCD;

  --  ----SET BUSDATE
  --L_TXMSG.BUSDATE := TO_DATE(P_TXDATE,'DD/MM/RRRR');

    ----DIFF KHONG CAN
  L_TXMSG.TXFIELDS('41').DEFNAME := 'DIFFERENCE';
  L_TXMSG.TXFIELDS('41').TYPE := 'N';
  L_TXMSG.TXFIELDS('41').VALUE := P_DIFF;
         ----CTCK  OK
  L_TXMSG.TXFIELDS('04').DEFNAME := 'DDACCTNO';
  L_TXMSG.TXFIELDS('04').TYPE := 'C';
  L_TXMSG.TXFIELDS('04').VALUE := NULL;
   /*
   ----TRADINGID  KHONG CAN
  L_TXMSG.TXFIELDS('00').DEFNAME := 'TRADINGID';
  L_TXMSG.TXFIELDS('00').TYPE := 'C';
  L_TXMSG.TXFIELDS('00').VALUE := V_REC.TRADINGID;




  */
    V_XMLMSG_STRING :=txpks_msg.fn_obj2xml(l_txmsg);
    err_code:=txpks_#8894.fn_txProcess(V_XMLMSG_STRING, v_err_code, p_err_message);
    --------------------------------------------------------------------------------
    IF err_code <>SYSTEMNUMS.C_SUCCESS THEN
        PLOG.ERROR(PKGCTX,
           V_PARAM || ' run ' || V_TLTXCD || ' got ' || ERR_CODE || ':' ||
           P_ERR_MESSAGE);

        err_msg :=P_ERR_MESSAGE;
        ROLLBACK;
        PLOG.SETENDSECTION(PKGCTX, 'PR_AUTO_8864_WEB');
        RETURN;
    END IF;

    PR_LOG_USERNAME(l_txmsg, tlid, 'C');

    pr_generate_otp('TRANS',p_reftransid, TLID, '', '','N', err_code, err_MSG);

--------------------------------------------------------------------------------
 PLOG.SETENDSECTION(PKGCTX, 'pr_auto_8894');
 EXCEPTION
    WHEN OTHERS THEN
        V_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.ERROR(PKGCTX,
                   ' Err: ' || SQLERRM || ' Trace: ' ||
                   DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

        PLOG.SETENDSECTION(PKGCTX, 'pr_auto_8894');
        ERR_CODE   := V_ERR_CODE;
END;
PROCEDURE PRC_GET_LIST_trading_resultETF(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     P_CUSTODYCD    IN   VARCHAR2,
                     P_TRADINGDATE     IN  VARCHAR2,
                     P_TYPE IN  VARCHAR2,
                     p_tlid IN VARCHAR2,
                     p_role IN VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2) as
   v_param  varchar2(4000);
    v_custodycd VARCHAR2(20);
   v_listcustodycd varchar2(4000);
   v_role VARCHAR2(10);
   v_CUSTODYCDINPUT VARCHAR2(20);
   v_TRADINGDATE VARCHAR2(20);
   v_TYPE VARCHAR2(10);
  BEGIN

    plog.debug(pkgctx, 'PRC_GET_LIST_trading_resultETF');
    v_param:=' PRC_GET_LIST_trading_resultETF: CUSTODYCD' || P_CUSTODYCD ;

    err_code  := systemnums.C_SUCCESS;
    err_msg := 'SUCCESS';
    Begin
    select custodycd,listcustodycd,role
        into v_custodycd,v_listcustodycd,v_role
    from userlogin
    where username = p_tlid;
    exception
        when others then
         v_custodycd := '';
         v_listcustodycd:='';
         v_role:='';
    End;


    if P_TRADINGDATE is null or P_TRADINGDATE = '' then
        v_TRADINGDATE:= '%';
    else
     v_TRADINGDATE:= P_TRADINGDATE;
    end if ;

    if P_CUSTODYCD is null or P_CUSTODYCD = '' then
        v_CUSTODYCDINPUT:= '%';
    else
        v_CUSTODYCDINPUT:= P_CUSTODYCD;
    end if ;

    if P_TYPE is null or P_TYPE = '' then
        v_TYPE:= '%';
    else
        v_TYPE:= P_TYPE;
    end if ;

    OPEN p_refcursor FOR
 select * from (
SELECT xx.*,a2.cdcontent exectype_desc ,a2.en_cdcontent exectype_endesc,
SB.CODEID etfcodeid,SB.SYMBOL ||' - '|| ISS.FULLNAME ETFNAME_desc , SB.SYMBOL ||' - '|| ISS.EN_FULLNAME ETFNAME_endesc,
FA.fullname Authorized
FROM (
 select TL.AUTOID,to_char(tl.TXDATE,'dd/MM/rrrr') txdate ,tl.TXNUM,tl.tltxcd ||'-'||tx.txdesc txdesc,tl.tltxcd ||'-'||tx.en_txdesc en_txdesc,
        tl.txstatus txstatus, a1.cdcontent txstatus_desc ,case when od.ORSTATUS = '3' then (select en_cdcontent from allcode where cdname='ORSTATUS' and cdval='3') else a1.en_cdcontent end txstatus_endesc,
        max ( case when fldcd = '03' then cvalue else '' end)  fundcode,
        max( case when fldcd = '20' then to_char(to_date(cvalue,'dd/MM/rrrr'),'dd/MM/rrrr') else '' end)  tradingdate,
        max( case when fldcd = '12' then cvalue else '' end)  exectype,
        max( case when fldcd = '83' then cvalue else '' end)  Authorizedautoid,
        max( case when fldcd = '08' then nvalue else 0 end)  nav,
        max( case when fldcd = '06' then nvalue else 0 end)  ETFQTTY,
        max( case when fldcd = '09' then nvalue else 0 end)  AMOUNT,
       max( case when fldcd = '11' then nvalue else 0 end)  tax,
       max( case when fldcd = '10' then nvalue else 0 end)  tradingfee,
        max( case when fldcd = '30' then cvalue else '' end)  Description,
        max( case when fldcd = '50' then rebuildStringETFbyCodeid(cvalue) else '' end)  STRINGVALUE,
         max( case when fldcd = '88' then cvalue else '' end)  ACCOUNTTRADING,
          max( case when fldcd = '41' then nvalue else 0 end)  DIFFERENCE_max,
          min( case when fldcd = '41' then nvalue else 0 end)  DIFFERENCE_min,
          max( case when fldcd = '40' then to_char(to_date(cvalue,'dd/MM/rrrr'),'dd/MM/rrrr') else '' end)  stdate
from tllogfld tlfld,tllog tl,tltx tx,allcode a1,(
                                               select odm.* from
                                                    (select fld1.cvalue ORDERID
                                                         from tllog tl1,tllogfld fld1
                                                         where tl1.txnum=fld1.txnum
                                                         and tl1.tltxcd='8895'
                                                         and tl1.tlid='6868'
                                                         and fld1.fldcd='22' and tl1.txstatus='1'
                                                         )a,odmast odm
                                                         where a.ORDERID=odm.ORDERID
                                                ) od
where tlfld.txnum=tl.txnum
and tlfld.txdate=tl.txdate
and tx.tltxcd=tl.tltxcd
and a1.CDVAL=(CASE WHEN tl.DELTD='Y' THEN '9' WHEN tl.txstatus = 'P' THEN '4' else tl.txstatus END)
and tl.tltxcd='8894'
and a1.cdname='TXSTATUS' and a1.cdtype='SY'
and tl.txstatus<>'0'
AND tl.TLID=C_TLID_ONLINE
and tl.txnum=od.txnum (+)
GROUP BY TL.AUTOID,tl.TXDATE ,tl.TXNUM,tl.tltxcd ||'-'||tx.txdesc,tl.tltxcd ||'-'||tx.en_txdesc,tl.txstatus,
a1.cdcontent,a1.en_cdcontent,od.ORSTATUS
order by tl.AUTOID desc
)XX left join famembers FA on FA.AUTOID=XX.Authorizedautoid,allcode a2,SBSECURITIES SB, ISSUERS ISS
where xx.exectype=a2.cdval
and a2.cdname='TYPEETF' and a2.cdtype='OD'
and xx.fundcode=SB.codeid
and SB.ISSUERID = ISS.ISSUERID
AND SB.SECTYPE = '008'
AND SB.tradeplace <> '006'
AND SB.STATUS = 'Y'
and ( INSTR(v_listcustodycd, xx.ACCOUNTTRADING) >0 or xx.ACCOUNTTRADING =v_custodycd)
and xx.accounttrading like v_CUSTODYCDINPUT
and xx.exectype  like v_TYPE
and xx.tradingdate like v_TRADINGDATE
 union all
       -- import file
  SELECT tl.AUTOID AUTOID,to_char(TL.TXDATE,'dd/MM/rrrr')  TXDATE, TL.TXNUM TXNUM,TL.TLTXCD||'-'||TL.TXDESC TXDESC,TL.TLTXCD||'-'||TL.TXDESC EN_TXDESC,
        TL.TXSTATUS TXSTATUS,TL.STATUS TXSTATUS_DESC,TL.en_status TXSTATUS_ENDESC, ' '  FUNDCODE,' ' TRADINGDATE, ' ' EXECTYPE ,' ' authorizedautoid,
        null NAV,null ETFQTTY,null AMOUNT,null TAX,null TRADINGFEE,' ' description,' ' STRINGVALUE,' ' ACCOUNTTRADING,
        null DIFFERENCE_max,null DIFFERENCE_min,' ' stdate,' ' exectype_desc,' ' exectype_endesc,' ' etfcodeid,' ' etfname_desc,' ' etfname_endesc,' ' authorized
        FROM (Select t.AUTOID, t.txdesc, tltxcd, t.txdate,t.txnum,t.TXSTATUS,a.cdcontent status,a.EN_cdcontent en_status,(case when  a.cdval = '4' then 'N' else 'Y' end) statusval,t.tlid from  tllog t,
        (SELECT  TXDATE ,TXNUM,
        MAX( CASE WHEN fldcd = '16' THEN cvalue ELSE '' END)  FILECODE,
        MAX( CASE WHEN fldcd = '99' THEN cvalue ELSE '' END)  USERNAME
        FROM tllogfld
        GROUP BY TXDATE ,TXNUM) m,allcode a
        where a.cdname = 'TXSTATUS' AND m.txdate = t.txdate and m.txnum = t.txnum  and a.cdtype = 'SY' and a.cdval <> 0 and m.FILECODE = 'I072' and decode(t.TXSTATUS,'P','4',t.TXSTATUS)  = a.cdval and m.USERNAME=p_tlid
        and t.TLTXCD in ('8800')) tl,tltx tx where tl.tltxcd = tx.tltxcd and tl.tlid=C_TLID_ONLINE
         ) tt
order by tt.AUTOID desc;

    plog.setEndSection(pkgctx, 'PRC_GET_LIST_trading_resultETF');
  EXCEPTION
    WHEN OTHERS THEN
      err_code := errnums.C_SYSTEM_ERROR;
        plog.error(pkgctx,'p_cdtype: ' || ' Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
      plog.setEndSection(pkgctx, 'PRC_GET_LIST_trading_resultETF');

END PRC_GET_LIST_trading_resultETF;
PROCEDURE PR_AUTO_6639_WEB(P_TXDATE VARCHAR2,P_CUSTODYCD VARCHAR2,P_ACCTNO VARCHAR2,P_PORFOLIO VARCHAR2,P_INSTRUCTION VARCHAR2,P_TRANSFER VARCHAR2,P_AMT NUMBER,P_BANK VARCHAR2,P_BANKBRANCH VARCHAR2,P_BANKACCTNO VARCHAR2,P_NAME VARCHAR2,P_REFCONTRACT VARCHAR2,P_DESC VARCHAR2,P_CITAD VARCHAR2,P_FEETYPE varchar2,P_VALUEDATE VARCHAR2,P_BALANCE NUMBER,P_FEE NUMBER,P_NETAMT NUMBER,TLID VARCHAR2,p_reftransid  OUT VARCHAR2, err_code in out varchar2, err_msg in out varchar2
                         ) IS
  L_TXMSG       TX.MSG_RECTYPE;
  V_STRCURRDATE VARCHAR2(20);
  V_STRDESC     VARCHAR2(1000);
  V_STREN_DESC  VARCHAR2(1000);
  V_TLTXCD      VARCHAR2(10);
  P_XMLMSG      VARCHAR2(4000);
  V_PARAM       VARCHAR2(1000);
  V_ETFNAME       VARCHAR2(1000);
  V_DC          NUMBER;
  V_FUNDCODEID   VARCHAR2(50);
  V_AMT         NUMBER;
  V_ERR_CODE    VARCHAR2(10);
  P_ERR_MESSAGE VARCHAR2(500);
  L_TXNUM         VARCHAR2(20);
  V_FULLNAME       VARCHAR2(1000);
  V_TLID        VARCHAR2(5);
  V_BALANCE         NUMBER;
  V_AVAILABLE          NUMBER;
  V_XMLMSG_STRING    varchar2(5000);
  v_holiday varchar2(1);
  p_err_code varchar2(250);
BEGIN

    ------------------------
    select holiday into v_holiday From sbcldr where  cldrtype = '000' and sbdate = to_date(P_VALUEDATE,'dd/MM/RRRR');
    if v_holiday = 'Y' then
        p_err_code := '-930110';
        err_msg :='-930110';
        RETURN ;
    end if;
    V_ERR_CODE    := SYSTEMNUMS.C_SUCCESS;
    P_ERR_MESSAGE := 'SUCCESS';
    PLOG.SETBEGINSECTION (PKGCTX, 'PR_AUTO_6639_WEB');
    V_TLTXCD := '6639';
      p_reftransid :='';
    ------------------------
    BEGIN
    SELECT TXDESC, EN_TXDESC
    INTO V_STRDESC, V_STREN_DESC
    FROM TLTX
    WHERE TLTXCD = V_TLTXCD;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            V_STRDESC:= null;
            V_STREN_DESC:= null;
    END;
    ------------------------
    SELECT TO_DATE (varvalue, systemnums.c_date_format)
    INTO v_strCURRDATE
    FROM sysvar
    WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

    ------------------------
    BEGIN
        SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD (SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
        INTO L_TXNUM
        FROM DUAL;
    EXCEPTION
          WHEN NO_DATA_FOUND THEN
            L_TXNUM:= null;
    END;
    ------------------------
    L_TXMSG.MSGTYPE     :='T';
    L_TXMSG.LOCAL       :='N';
    L_TXMSG.TLID        :='6868';

    SELECT TLID
    INTO V_TLID
    FROM cfmast
    where custodycd=P_CUSTODYCD;
    ------------------------
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
    INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS
    FROM DUAL;
    ------------------------
    BEGIN
        SELECT BRID
        INTO L_TXMSG.BRID
        FROM TLPROFILES WHERE TLID=V_TLID;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           L_TXMSG.BRID:= null;
    END;
    ------------------------
    L_TXMSG.OFF_LINE    := 'N';
    L_TXMSG.DELTD       := TXNUMS.C_DELTD_TXNORMAL;
    L_TXMSG.TXSTATUS    := TXSTATUSNUMS.c_txlogged;
    L_TXMSG.MSGSTS      := '0';
    L_TXMSG.OVRSTS      := '0';
    L_TXMSG.BATCHNAME   := 'DAY';
    L_TXMSG.REFTXNUM    := L_TXNUM;
    L_TXMSG.TXDATE      := TO_DATE(V_STRCURRDATE,SYSTEMNUMS.C_DATE_FORMAT);
    L_TXMSG.BUSDATE     := TO_DATE(V_STRCURRDATE,SYSTEMNUMS.C_DATE_FORMAT);
    L_TXMSG.TLTXCD      := V_TLTXCD;
    l_txmsg.nosubmit    := '1';
    l_txmsg.ovrrqd      := '@00';

 --------------------------SET CAC FIELD GIAO DICH-------------------------------

  ----SET TXNUM
  BEGIN
  SELECT L_TXMSG.BRID || LPAD(seq_txnum.NEXTVAL, 6, '0')
  INTO L_TXMSG.TXNUM
  FROM DUAL;
  EXCEPTION
        WHEN NO_DATA_FOUND THEN
           L_TXMSG.TXNUM:= null;
  END;
      p_reftransid :='['|| TO_CHAR(TO_DATE(V_STRCURRDATE,SYSTEMNUMS.C_DATE_FORMAT),SYSTEMNUMS.C_DATE_FORMAT) ||']['||L_TXMSG.txnum||']';

  ----SET BALANCE
  BEGIN
 select fn_get_balance_6639(P_ACCTNO) into V_BALANCE from dual;
  EXCEPTION
        WHEN NO_DATA_FOUND THEN
           V_BALANCE:= 0;
  END;
  ----SET AVAILABLE
  BEGIN
 --select fn_get_balance_6639(P_ACCTNO) into V_BALANCE from dual; TONG TAI SAN
 V_AVAILABLE:=P_BALANCE;
  EXCEPTION
        WHEN NO_DATA_FOUND THEN
           V_AVAILABLE:= 0;
  END;
      ----SET POSTINGDATE
  L_TXMSG.TXFIELDS('01').DEFNAME := 'POSTINGDATE';
  L_TXMSG.TXFIELDS('01').TYPE := 'D';
  L_TXMSG.TXFIELDS('01').VALUE :=  TO_CHAR(TO_DATE(P_TXDATE,'DD/MM/RRRR'),'DD/MM/RRRR');
      ----TRADINGACCT OK----------------------
  l_txmsg.txfields('02').defname := 'TRADINGACCT';
  l_txmsg.txfields('02').TYPE := 'C';
  l_txmsg.txfields('02').VALUE := P_CUSTODYCD;
   ----ACCTNO OK----------------------
  l_txmsg.txfields('03').defname := 'ACCTNO';
  l_txmsg.txfields('03').TYPE := 'C';
  l_txmsg.txfields('03').VALUE := P_ACCTNO;
    ----PORFOLIO OK----------------------
  l_txmsg.txfields('04').defname := 'PORFOLIO';
  l_txmsg.txfields('04').TYPE := 'C';
  l_txmsg.txfields('04').VALUE := P_PORFOLIO;
    ----BALANCE OK----------------------
  l_txmsg.txfields('05').defname := 'BALANCE';
  l_txmsg.txfields('05').TYPE := 'N';
  l_txmsg.txfields('05').VALUE := V_BALANCE;
    ----AVAILABLE OK----------------------
  l_txmsg.txfields('06').defname := 'AVAILABLE';
  l_txmsg.txfields('06').TYPE := 'N';
  l_txmsg.txfields('06').VALUE := V_AVAILABLE;
      ----INSTRUCTION OK----------------------
  l_txmsg.txfields('07').defname := 'INSTRUCTION';
  l_txmsg.txfields('07').TYPE := 'C';
  l_txmsg.txfields('07').VALUE := P_INSTRUCTION;
       ----TRANSFER OK----------------------
  l_txmsg.txfields('08').defname := 'TRANSFER';
  l_txmsg.txfields('08').TYPE := 'C';
  l_txmsg.txfields('08').VALUE := P_TRANSFER;
   ----CITAD  OK
  L_TXMSG.TXFIELDS('09').DEFNAME := 'CITAD';
  L_TXMSG.TXFIELDS('09').TYPE := 'C';
  L_TXMSG.TXFIELDS('09').VALUE := P_CITAD;
     ----AMT  OK
  L_TXMSG.TXFIELDS('10').DEFNAME := 'AMT';
  L_TXMSG.TXFIELDS('10').TYPE := 'N';
  L_TXMSG.TXFIELDS('10').VALUE := P_AMT ;
     ----BANK OK
  L_TXMSG.TXFIELDS('11').DEFNAME := 'BANK';
  L_TXMSG.TXFIELDS('11').TYPE := 'C';
  L_TXMSG.TXFIELDS('11').VALUE := P_BANK;
    ----BANKBRANCH OK
  L_TXMSG.TXFIELDS('12').DEFNAME := 'BANKBRANCH';
  L_TXMSG.TXFIELDS('12').TYPE := 'C';
  L_TXMSG.TXFIELDS('12').VALUE := P_BANKBRANCH;
    ----BANKACCTNO OK
  L_TXMSG.TXFIELDS('13').DEFNAME := 'BANKACCTNO';
  L_TXMSG.TXFIELDS('13').TYPE := 'C';
  L_TXMSG.TXFIELDS('13').VALUE := P_BANKACCTNO;
    ----NAME OK
  L_TXMSG.TXFIELDS('14').DEFNAME := 'NAME';
  L_TXMSG.TXFIELDS('14').TYPE := 'C';
  L_TXMSG.TXFIELDS('14').VALUE := P_NAME;
    ----REFCONTRACT OK
  L_TXMSG.TXFIELDS('15').DEFNAME := 'REFCONTRACT';
  L_TXMSG.TXFIELDS('15').TYPE := 'C';
  L_TXMSG.TXFIELDS('15').VALUE := P_REFCONTRACT;
   ----FEETYPE OK
  L_TXMSG.TXFIELDS('16').DEFNAME := 'FEETYPE';
  L_TXMSG.TXFIELDS('16').TYPE := 'C';
  L_TXMSG.TXFIELDS('16').VALUE := P_FEETYPE;
      ----VALUEDATE OK
  L_TXMSG.TXFIELDS('17').DEFNAME := 'VALUEDATE';
  L_TXMSG.TXFIELDS('17').TYPE := 'D';
  L_TXMSG.TXFIELDS('17').VALUE := P_VALUEDATE;
    ----DESC OK
  L_TXMSG.TXFIELDS('30').DEFNAME := 'DESC';
  L_TXMSG.TXFIELDS('30').TYPE := 'C';
  L_TXMSG.TXFIELDS('30').VALUE := SUBSTR(P_DESC, 1, 200);
    ----DESC OK
    /*
  L_TXMSG.TXFIELDS('81').DEFNAME := 'BENEFACCT';
  L_TXMSG.TXFIELDS('81').TYPE := 'C';
  L_TXMSG.TXFIELDS('81').VALUE := P_BANKACCTNO;
*/

    ----FEE  OK
  L_TXMSG.TXFIELDS('19').DEFNAME := 'FEE';
  L_TXMSG.TXFIELDS('19').TYPE := 'N';
  L_TXMSG.TXFIELDS('19').VALUE := P_FEE ;

  ----NETAMT  OK
  L_TXMSG.TXFIELDS('20').DEFNAME := 'NETAMT';
  L_TXMSG.TXFIELDS('20').TYPE := 'N';
  L_TXMSG.TXFIELDS('20').VALUE := P_NETAMT ;

    V_XMLMSG_STRING :=txpks_msg.fn_obj2xml(l_txmsg);
    err_code:=txpks_#6639.fn_txProcess(V_XMLMSG_STRING, v_err_code, p_err_message);
    --------------------------------------------------------------------------------
    IF err_code <>SYSTEMNUMS.C_SUCCESS THEN
        PLOG.ERROR(PKGCTX,
           V_PARAM || ' run ' || V_TLTXCD || ' got ' || ERR_CODE || ':' ||
           P_ERR_MESSAGE);

        err_msg :=P_ERR_MESSAGE;
        ROLLBACK;
        PLOG.SETENDSECTION(PKGCTX, 'PR_AUTO_8864_WEB');
        RETURN;
    END IF;
    --check black list
    --if P_TRANSFER = 'D' then --cho duyet
   --    pck_bankapi.Checkblacklist( P_NAME,l_txmsg.txnum,l_txmsg.txdate,l_txmsg.tlid,'',v_err_code);
   -- end if;

    PR_LOG_USERNAME(l_txmsg, TLID, 'C');
  pr_generate_otp('TRANS',p_reftransid, TLID, '', '','N', err_code, err_MSG);

--------------------------------------------------------------------------------
 PLOG.SETENDSECTION(PKGCTX, 'PR_AUTO_6639_WEB');
 EXCEPTION
    WHEN OTHERS THEN
        V_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.ERROR(PKGCTX,
                   ' Err: ' || SQLERRM || ' Trace: ' ||
                   DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

        PLOG.SETENDSECTION(PKGCTX, 'PR_AUTO_6639_WEB');
        ERR_CODE   := V_ERR_CODE;
END;
PROCEDURE PRC_GET_LIST_trading_PAYMENTINSTRUCTION(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     P_CUSTODYCD    IN   VARCHAR2,
                     P_TRADINGDATE     IN  VARCHAR2,
                     p_tlid IN VARCHAR2,
                     p_role IN VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2) as
   v_param  varchar2(4000);
    v_custodycd VARCHAR2(20);
   v_listcustodycd varchar2(4000);
   v_role VARCHAR2(10);
   v_custodycdINPUT varchar2(20);
   v_TRADINGDATE varchar2(10);
  BEGIN

    plog.debug(pkgctx, 'PRC_GET_LIST_trading_PAYMENTINSTRUCTION');
    v_param:=' PRC_GET_LIST_trading_PAYMENTINSTRUCTION: CUSTODYCD' || P_CUSTODYCD ;

    err_code  := systemnums.C_SUCCESS;
    err_msg := 'SUCCESS';

     IF P_CUSTODYCD IS NULL OR length(P_CUSTODYCD)=0 THEN
        v_custodycdINPUT :='%';
    ELSE
        v_custodycdINPUT:=P_CUSTODYCD;
    END IF;

     IF P_TRADINGDATE IS NULL OR length(P_TRADINGDATE)=0 THEN
        v_TRADINGDATE :='%';
    ELSE
        v_TRADINGDATE:=P_TRADINGDATE;
    END IF;

    Begin
    select custodycd,listcustodycd,role
        into v_custodycd,v_listcustodycd,v_role
    from userlogin
    where username = p_tlid;
    exception
        when others then
         v_custodycd := '';
         v_listcustodycd:='';
         v_role:='';
    End;
    OPEN p_refcursor FOR
      select *
      from
      (
        select t.*,a2.cdcontent INSTRUCTION_desc,a2.en_cdcontent INSTRUCTION_endesc ,
            a3.cdcontent TRANSFER_desc,a3.en_cdcontent TRANSFER_endesc,
            a4.cdcontent FEETYPE_desc,a4.en_cdcontent FEETYPE_endesc,TO_CHAR(TO_DATE(T.VALUEDATE,'DD/MM/RRRR'),'DD/MM/RRRR') VALUEDATE_convert,
            ci.refcasaacct ||' - '|| ci.ccycd || ' - ' || A5.CDCONTENT DISPLAY_ACCTNO
        from
        (
            select  max ( case when fldcd = '01' then cvalue else '' end)  POSTINGDATE,
                max( case when fldcd = '02' then cvalue else '' end)  TRADINGACCT,
                max( case when fldcd = '03' then cvalue else '' end)  ACCTNO,
                max( case when fldcd = '04' then cvalue else '' end)  PORFOLIO,
                max( case when fldcd = '05' then nvalue else 0 end)  BALANCE,
                max( case when fldcd = '06' then nvalue else 0 end)  AVAILABLE,
                max( case when fldcd = '07' then cvalue else '' end)  INSTRUCTION,
                max( case when fldcd = '08' then cvalue else '' end)  TRANSFER,
                max( case when fldcd = '09' then cvalue else '' end)  CITAD,
                max( case when fldcd = '10' then nvalue else 0 end)  AMT,
                max( case when fldcd = '11' then cvalue else '' end)  BANK,
                max( case when fldcd = '12' then cvalue else '' end)  BANKBRANCH,
                max( case when fldcd = '13' then cvalue else '' end)  BANKACCTNO,
                max( case when fldcd = '14' then cvalue else '' end)  NAME,
                max( case when fldcd = '15' then cvalue else '' end)  REFCONTRACT,
                max( case when fldcd = '16' then cvalue else '' end)  FEETYPE,
                max( case when fldcd = '17' then cvalue else '' end)  VALUEDATE,
                max( case when fldcd = '19' then nvalue else 0 end)  FEE,
                max( case when fldcd = '20' then nvalue else 0 end)  NETAMT,
                max( case when fldcd = '30' then cvalue else '' end)  "DESC",
                tl.autoid, tl.txstatus txstatus, a1.cdcontent txstatus_desc ,a1.en_cdcontent txstatus_endesc,
                to_char(to_date(tl.txdate,'dd/MM/rrrr'),'dd/MM/rrrr') txdate ,tl.TXNUM,tl.tltxcd ||'-'||tx.txdesc txdesc,tl.tltxcd ||'-'||tx.en_txdesc en_txdesc
            from tllogfld tlfld,tllog tl,tltx tx,
            (select * from allcode where cdname = 'WEB6639STATUS' and cdtype = 'SY') a1,
            (
                select pay.txnum, pay.txdate, pay.bankstatus, req.status
                from cbfa_bankpayment pay,
                (
                    select * from crbtxreq
                    union all
                    select * from crbtxreqhist
                ) req
                where pay.globalid = req.reqtxnum
            ) pay
            where tlfld.txnum = tl.txnum
            and tx.tltxcd = tl.tltxcd
            and tl.txnum = pay.txnum(+)
            and tl.txdate = pay.txdate(+)
            and tl.tltxcd = '6639'
            and tl.tlid = '6868'
            and tl.txstatus <> '0'
            and a1.CDVAL=(case when tl.txstatus = '4' then 'I'
                               when tl.txstatus = '1' and NVL(pay.status,'P') = 'C' then pay.status
                               when tl.txstatus = '1' and NVL(pay.status,'P') = 'R' then pay.status
                               when tl.txstatus = '1' and NVL(pay.bankstatus,'P') = 'E' then pay.bankstatus
                               when tl.txstatus = '1' and NVL(pay.status,'P') NOT IN ('C','R') AND NVL(pay.bankstatus,'P') NOT IN ('E') then 'I'
                               else 'P' end)
            GROUP BY TL.AUTOID,tl.TXDATE ,tl.TXNUM,tl.tltxcd ||'-'||tx.txdesc,tl.tltxcd ||'-'||tx.en_txdesc,tl.txstatus, a1.cdcontent,a1.en_cdcontent,tl.autoid
            order by tl.autoid desc
        )t, ddmast ci, allcode a2, allcode a3, allcode a4, allcode a5
        where ci.acctno=t.ACCTNO
        and ci.STATUS <> 'C'
        and a2.cdval=t.INSTRUCTION
        and a2.cdname='CBTXTYPE'
        and a3.cdval=t.TRANSFER
        and a3.cdname='TRANSTYPE' and a3.cdtype='FA'
        and a4.cdval=t.FEETYPE
        and a4.cdname='IOROFEE' and a4.cdtype='SA'
        and a5.CDNAME = 'ACCOUNTTYPE' and a5.CDVAl = ci.accounttype and a5.CDTYPE = 'DD'
        and ( INSTR(v_listcustodycd, t.TRADINGACCT) >0 or t.TRADINGACCT =v_custodycd)
        and t.TRADINGACCT like v_custodycdINPUT
        and t.VALUEDATE like v_TRADINGDATE
        union all
        SELECT ' ' POSTINGDATE,' '   TRADINGACCT, ' ' ACCTNO,' ' PORFOLIO,null BALANCE,
        null AVAILABLE,' ' INSTRUCTION,' ' TRANSFER, ' '  CITAD,NULL AMT, ' ' BANK ,' ' BANKBRANCH,
        ' ' BANKACCTNO,' ' NAME,' ' REFCONTRACT,' ' FEETYPE,' ' VALUEDATE,NULL FEE,NULL NETAMT,' ' "DESC",
        TL.AUTOID,TL.STATUS TXSTATUS,TL.STATUS TXSTATUS_DESC,TL.STATUS TXSTATUS_ENDESC,to_char(TL.TXDATE,'dd/MM/rrrr'),TL.TXNUM,TL.TLTXCD||'-'||TL.TXDESC txdesc,TL.TLTXCD||'-'||TL.TXDESC EN_TXDESC,
        ' ' INSTRUCTION_desc,' ' INSTRUCTION_endesc,' ' TRANSFER_desc,' ' TRANSFER_endesc,
        ' ' FEETYPE_desc,' ' FEETYPE_endesc,' ' VALUEDATE_convert,' ' DISPLAY_ACCTNO
        FROM
        (
            Select t.AUTOID, t.txdesc, tltxcd, t.txdate,t.txnum,a.EN_cdcontent status,(case when  a.cdval = '4' then 'N' else 'Y' end) statusval
            from  tllog t,
            (
                SELECT  TXDATE ,TXNUM,
                MAX( CASE WHEN fldcd = '16' THEN cvalue ELSE '' END)  FILECODE,
                MAX( CASE WHEN fldcd = '99' THEN cvalue ELSE '' END)  USERNAME
                FROM tllogfld
                GROUP BY TXDATE ,TXNUM
            ) m, allcode a
            where a.cdname = 'TXSTATUS' AND m.txdate = t.txdate and m.txnum = t.txnum  and a.cdtype = 'SY' and a.cdval <> '0' and m.FILECODE in ('I078','I079','I080','R0061') and decode(t.TXSTATUS,'P','4',t.TXSTATUS)  = a.cdval and  M.USERNAME=p_tlid
            and t.TLTXCD in ('8800')) tl,tltx tx where tl.tltxcd = tx.tltxcd
        ) tt
        order by tt.AUTOID desc;
        plog.setEndSection(pkgctx, 'PRC_GET_LIST_trading_PAYMENTINSTRUCTION');
  EXCEPTION
    WHEN OTHERS THEN
      err_code := errnums.C_SYSTEM_ERROR;
        plog.error(pkgctx,'p_cdtype: ' || ' Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
      plog.setEndSection(pkgctx, 'PRC_GET_LIST_trading_PAYMENTINSTRUCTION');

END PRC_GET_LIST_trading_PAYMENTINSTRUCTION;
PROCEDURE PRC_GET_ACCTNO_BY_CUSTODYCD(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     P_CUSTODYCD    IN   VARCHAR2,
                     P_STATUS       IN   VARCHAR2,
                     p_tlid         IN   VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2) as
   v_param  varchar2(4000);
   L_STATUS  varchar2(5);
   v_custodycd  varchar2(20);
   v_listcustodycd  varchar2(4000);
   v_role  varchar2(10);
  BEGIN

    plog.debug(pkgctx, 'PRC_GET_ACCTNO_BY_CUSTODYCD');
    v_param:=' PRC_GET_ACCTNO_BY_CUSTODYCD: FUNDSYMBOL' || P_CUSTODYCD ;

    err_code  := systemnums.C_SUCCESS;
    err_msg := 'SUCCESS';
     IF P_STATUS='ALL' THEN L_STATUS := '%%';
    ELSE L_STATUS :=P_STATUS ;
    END IF;
      begin
        select custodycd,listcustodycd,role
        into v_custodycd,v_listcustodycd,v_role
        from userlogin
        where username = p_tlid;
    exception
        when others then
             v_custodycd := '';
             v_listcustodycd:='';
             v_role:='';
    end;

    IF V_ROLE ='AP' then
    OPEN p_refcursor FOR
       select t.acctno CDVAL,t.acctno, t.display CDCONTENT,t.fullname,T.refcasaacct from
(select cf.custodycd, ci.acctno acctno, ci.refcasaacct ||' - '|| ci.ccycd || ' - ' || A1.CDCONTENT DISPLAY,cf.fullname,ci.refcasaacct
from ddmast ci, allcode A1, cfmast cf
where A1.CDNAME = 'ACCOUNTTYPE' and A1.CDVAl = ci.accounttype and A1.CDTYPE = 'DD'
      and ci.custid = cf.custid
      and ci.STATUS LIKE L_STATUS) t
WHERE t.custodycd = P_CUSTODYCD
and  instr(v_listcustodycd,t.refcasaacct)>0;
    else
    OPEN p_refcursor FOR
 select t.acctno CDVAL,t.acctno, t.display CDCONTENT,t.fullname,T.refcasaacct from
(select cf.custodycd, ci.acctno acctno, ci.refcasaacct ||' - '|| ci.ccycd || ' - ' || A1.CDCONTENT DISPLAY,cf.fullname,ci.refcasaacct
from ddmast ci, allcode A1, cfmast cf,userlogin u
where A1.CDNAME = 'ACCOUNTTYPE' and A1.CDVAl = ci.accounttype and A1.CDTYPE = 'DD'
      and ci.custid = cf.custid
      and ci.STATUS LIKE L_STATUS
      and ( INSTR(u.listcustodycd, ci.custodycd) >0 or ci.custodycd =u.custodycd)
      and u.username=P_TLID) t
WHERE t.custodycd = P_CUSTODYCD;
end if;
    plog.setEndSection(pkgctx, 'PRC_GET_ACCTNO_BY_CUSTODYCD');
  EXCEPTION
    WHEN OTHERS THEN
      err_code := errnums.C_SYSTEM_ERROR;
        plog.error(pkgctx,'p_cdtype: ' || ' Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
      plog.setEndSection(pkgctx, 'PRC_GET_ACCTNO_BY_CUSTODYCD');

END PRC_GET_ACCTNO_BY_CUSTODYCD;

PROCEDURE PRC_GET_SYMBOL_SBSECURITIES (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     P_CODEID  IN  VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2) as
   v_param  varchar2(4000);
   l_codeid varchar2(10);
  BEGIN

    plog.debug(pkgctx, 'PRC_GET_SYMBOL_SBSECURITIES');
    v_param:=' PRC_GET_SYMBOL_SBSECURITIES: '  ;

    err_code  := systemnums.C_SUCCESS;
    err_msg := 'SUCCESS';
     IF P_CODEID IS NULL OR length(P_CODEID) = 0 THEN
        l_codeid:='%';
     else
        l_codeid:=P_CODEID;
     end if;
    OPEN p_refcursor FOR
    SELECT SB.CODEID CDVAL , SB.SYMBOL CDCONTENT,SB.SYMBOL EN_CDCONTENT FROM  SBSECURITIES SB
    where sb.tradeplace <> '006' and sb.sectype <> '004' and sb.codeid like l_codeid;
    plog.setEndSection(pkgctx, 'PRC_GET_SYMBOL_SBSECURITIES');
  EXCEPTION
    WHEN OTHERS THEN
      err_code := errnums.C_SYSTEM_ERROR;
        plog.error(pkgctx,'p_cdtype: ' || ' Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
      plog.setEndSection(pkgctx, 'PRC_GET_SYMBOL_SBSECURITIES');

END PRC_GET_SYMBOL_SBSECURITIES;

Procedure PRC_TXPROCESS4FUND(p_updatemode varchar2,
                          p_txnum varchar2 ,
                          p_txdate varchar2,
                          p_tlid varchar2,
                          P_level VARCHAR2,
                          p_err_code in out varchar2,
                          p_err_param out varchar2)
    IS
       l_txmsg               tx.msg_rectype;
       l_err_param           varchar2(300);
       l_tllog               tllog%rowtype;
       l_fldname             varchar2(100);
       l_defname             varchar2(100);
       l_fldtype             char(1);
       l_return              number(20,0);
       pv_refcursor            pkg_report.ref_cursor;
       l_return_code VARCHAR2(30) := systemnums.C_SUCCESS;
       p_xmlmsg        varchar2(4000);
       v_sql varchar2(1000);
       v_param varchar2(2000);
       v_txstatus varchar2(10);
BEGIN
    plog.setbeginsection (pkgctx, 'PRC_TXPROCESS4FUND');
    v_param:=' PRC_TXPROCESS4FUND(): p_updatemode = '||p_updatemode||
                                       ';p_txnum = '||p_txnum||
                                       ';p_txdate = '||p_txdate||
                                       ';p_tlid = '||p_tlid||
                                       ';P_level = '||P_level;
    plog.debug(pkgctx,'Begin '||v_param );
    p_err_code:=systemnums.C_SUCCESS;
    p_err_param:='SUCCESS';
    For vc in (Select txnum, txstatus
                  From tllog
                  Where txnum=p_txnum
                  )
    LOOP
            v_txstatus:=vc.txstatus;
    End loop;
    IF p_updatemode in ('A','R','D') and v_txstatus not in ('4','0') THEN
            p_err_code:=-100030;
            Raise  errnums.E_BIZ_RULE_INVALID;
    End if;

    OPEN pv_refcursor FOR
        select * from tllog
        where txnum=p_txnum ;
        --getcurrdate;--(p_txdate,systemnums.c_date_format);
    LOOP
    FETCH pv_refcursor
    INTO l_tllog;
    EXIT WHEN pv_refcursor%NOTFOUND;
        if l_tllog.deltd='Y' then
        p_err_code:=errnums.C_SA_CANNOT_DELETETRANSACTION;
        plog.setendsection (pkgctx, 'fn_txrevert');
            RETURN ;
        end if;
        l_txmsg.msgtype:='T';
        l_txmsg.local:='N';
        l_txmsg.tlid        := l_tllog.tlid;
        l_txmsg.offid        := p_tlid;
        l_txmsg.off_line    := l_tllog.off_line;
        L_TXMSG.WSNAME      := l_tllog.WSNAME;
        L_TXMSG.IPADDRESS   := L_tllog.IPADDRESS;
        l_txmsg.deltd       := txnums.C_DELTD_TXNORMAL;
        l_txmsg.txstatus    := l_tllog.txstatus;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        l_txmsg.batchname   := 'DAY';
        l_txmsg.txdate:=to_date(l_tllog.txdate,systemnums.c_date_format);
        l_txmsg.busdate:=to_date(l_tllog.busdate,systemnums.c_date_format);
        l_txmsg.txnum:=l_tllog.txnum;
        l_txmsg.tltxcd:=l_tllog.tltxcd;
        l_txmsg.brid:=l_tllog.brid;

        for rec in
        (
            select * from tllogfld
            where txnum=p_txnum  --getcurrdate--to_date(p_txdate,systemnums.c_date_format)
        )
        LOOP
            begin
                select fldname, defname, fldtype
                into l_fldname, l_defname, l_fldtype
                from fldmaster
                where objname=l_tllog.tltxcd and FLDNAME=rec.FLDCD;

                l_txmsg.txfields (l_fldname).defname   := l_defname;
                l_txmsg.txfields (l_fldname).TYPE      := l_fldtype;

                if l_fldtype='C' then
                    l_txmsg.txfields (l_fldname).VALUE     := rec.CVALUE;
                elsif   l_fldtype='N' then
                    l_txmsg.txfields (l_fldname).VALUE     := rec.NVALUE;
                else
                    l_txmsg.txfields (l_fldname).VALUE     := rec.CVALUE;
                end if;
                plog.debug (pkgctx,'field: ' || l_fldname || ' value:' || to_char(l_txmsg.txfields (l_fldname).VALUE));
            exception when others then
               l_err_param:=0;
            end;
        end loop;

        p_xmlmsg := txpks_msg.fn_obj2xml(l_txmsg);

        If  l_tllog.tltxcd='6639' then
           IF txpks_#6639.fn_TxProcess (p_xmlmsg,p_err_code,p_err_param) <> systemnums.c_success
           THEN
               plog.error (pkgctx,v_param||' run'||l_tllog.tltxcd||' got error ' ||p_err_code||':'||p_err_param );
               ROLLBACK;
               plog.setendsection (pkgctx, 'PRC_TXPROCESS4FUND');
               RETURN ;
           END IF;
         elsif  l_tllog.tltxcd='8894' then
           IF txpks_#8894.fn_TxProcess (p_xmlmsg,p_err_code,p_err_param) <> systemnums.c_success
           THEN

               ROLLBACK;
               plog.setendsection (pkgctx, 'PRC_TXPROCESS4FUND');
               RETURN ;
           END IF;
         elsif  l_tllog.tltxcd='8864' then
           IF txpks_#8864.fn_TxProcess (p_xmlmsg,p_err_code,p_err_param) <> systemnums.c_success
           THEN
               plog.error (pkgctx,v_param||' run'||l_tllog.tltxcd||' got error ' ||p_err_code||':'||p_err_param );
               ROLLBACK;
               plog.setendsection (pkgctx, 'PRC_TXPROCESS4FUND');
               RETURN ;
           END IF;
         elsif  l_tllog.tltxcd='6639' then
           IF txpks_#6639.fn_TxProcess (p_xmlmsg,p_err_code,p_err_param) <> systemnums.c_success
           THEN
               plog.error (pkgctx,v_param||' run'||l_tllog.tltxcd||' got error ' ||p_err_code||':'||p_err_param );
               ROLLBACK;
               plog.setendsection (pkgctx, 'PRC_TXPROCESS4FUND');
               RETURN ;
           END IF;
         END IF;

        plog.setendsection (pkgctx, 'PRC_TXPROCESS4FUND');
        return ;
    END LOOP;
       p_err_code:=errnums.C_HOST_VOUCHER_NOT_FOUND;
       plog.setendsection (pkgctx, 'PRC_TXPROCESS4FUND');
       Raise  errnums.E_BIZ_RULE_INVALID;

EXCEPTION
       WHEN errnums.E_BIZ_RULE_INVALID
       THEN
          FOR I IN (
               SELECT ERRDESC,EN_ERRDESC FROM deferror
               WHERE ERRNUM= p_err_code
          ) LOOP
               p_err_param := i.errdesc;
          END LOOP;
          plog.setendsection (pkgctx, 'PRC_TXPROCESS4FUND');
          RETURN ;
    WHEN OTHERS
       THEN
          p_err_code := errnums.C_SYSTEM_ERROR;
          plog.error(pkgctx,' Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );

          plog.setendsection (pkgctx, 'PRC_TXPROCESS4FUND');
          RETURN ;
END PRC_TXPROCESS4FUND;


procedure pr_verify_totp( p_objname in varchar2,
    p_keyval in varchar2,
    p_otpvalue in varchar2,
    p_strdata in varchar2,
    p_tlid IN VARCHAR2,
    p_role IN VARCHAR2,
    p_err_code in out varchar2,
    p_err_param in out varchar2)
is
    /*
    Input
        p_objname: Ma chuc nang
        p_keyval : Key cua GD
        p_otpvalue: Ma OTP
        p_strdata: Gia tri khac (neu co), field du phong dung sau nay.
    Output:
        p_err_code: Ma loi
        p_err_param: Mo ta loi
    */
    v_count         number;
    v_exprieddt     date;
    v_otpretrycnt   number;
    v_otpcheck    varchar2(1);
    v_isauto varchar2(1);
    v_txnum varchar2(50);
    v_txdate date;
    v_tltxcd varchar2(10);
begin
    p_err_code  := systemnums.C_SUCCESS;
    p_err_param := 'SUCCESS';
    plog.setbeginsection (pkgctx, 'pr_verify_totp');
    Begin
        select varvalue into v_otpcheck  from sysvar where varname='OTPCHECK';
    exception
    when others
        then v_otpcheck := 'N';
    End;

    begin
        select isauto into v_isauto from otp_logs where refcode = p_objname AND  refid = p_keyval;
    exception
        when others then
        v_isauto :='N';
    end;

    v_txnum := SUBSTR(p_keyval,14,10);

        --Cap nhat trang thai giao dich
                IF p_objname ='IMP' THEN
                        fopks_file.prc_txprocess4cb(p_keyval, p_tlid, P_ERR_CODE, P_ERR_PARAM);
                        if p_err_code <> SYSTEMNUMS.C_SUCCESS THEN

                            p_err_param :=cspks_system.fn_get_errmsg(p_err_code);
                            ROLLBACK;
                            plog.setEndSection(pkgctx, 'pr_verify_totp');
                            RETURN;
                        end if;
                 ELSIF  p_objname ='TRANS' THEN
                     v_txdate := TO_DATE(SUBSTR(p_keyval,2,10),'dd/mm/rrrr');
                     if v_isauto ='N' then
                         UPDATE tllog SET txstatus = 'P'--TXSTATUSNUMS.c_txpending
                         WHERE txdate = v_txdate
                         AND txnum = v_txnum
                         AND txstatus = TXSTATUSNUMS.c_txlogged;
                     else
                         PRC_TXPROCESS4FUND('A',
                         v_txnum ,
                         v_txdate,
                         '6868',
                         2,
                         p_err_code,
                         p_err_param);
                         if p_err_code <> SYSTEMNUMS.C_SUCCESS THEN

                             p_err_param :=cspks_system.fn_get_errmsg(p_err_code);
                             ROLLBACK;
                             plog.setEndSection(pkgctx, 'pr_verify_totp');
                             RETURN;
                         end if;
                    end if;
                ELSIF  p_objname in ('REJECT','APPROVE','LOGIN','ACTIVEACCOUNT','FORGOTPASSWORD','CHANGEPASSWORD') THEN
                    if v_otpcheck = 'Y' then
                        Begin
                            select varvalue into v_otpretrycnt  from sysvar where varname='OTPRETRYCNT';
                        exception when others then
                            v_otpretrycnt := 1;
                        End;

                        Select count(1) into v_count
                        from otp_logs
                        where status ='A' and  refcode = p_objname
                            AND refid = p_keyval and secset = genencryptpassword(p_otpvalue);

                        If v_count = 0 then
                            -- OTP Khong dung
                            p_err_code := '-202000';
                            p_err_param :=cspks_system.fn_get_errmsg(p_err_code);
                            plog.error (pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
                            plog.setendsection (pkgctx, 'pr_verify_totp');
                            return ;
                        End If;

                        Select count(1) into v_count
                        from otp_logs
                        where status ='A' and refid = p_keyval
                            AND refcode = p_objname
                            and secset = genencryptpassword(p_otpvalue)
                            and exprieddt > sysdate
                            and retry_count < v_otpretrycnt;

                        If v_count = 0 then
                            -- OTP het han
                            p_err_code := '-202001';
                             p_err_param :=cspks_system.fn_get_errmsg(p_err_code);
                            plog.error (pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
                            plog.setendsection (pkgctx, 'pr_verify_totp');
                            return;
                        end if;
                    end if;
            UPDATE otp_logs SET status ='C'
            WHERE  refid = p_keyval
            AND refcode = p_objname and status ='A';

               End If;



       BEGIN
    select tltxcd into v_tltxcd from tllog where txdate = v_txdate and txnum = v_txnum;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            v_tltxcd:= null;
    END;
    if v_tltxcd = '6639' then
        UPDATE tllog SET txstatus = 'P'
        WHERE txdate = v_txdate
        AND txnum = v_txnum;
    end if;

    plog.setendsection (pkgctx, 'pr_verify_totp');
exception
when others
   then
    p_err_code := errnums.c_system_error;
    plog.error (pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
    plog.setendsection (pkgctx, 'pr_verify_totp');
    raise errnums.e_system_error;
end pr_verify_totp;
procedure pr_verify_totp_bk0608( p_objname in varchar2,
    p_keyval in varchar2,
    p_otpvalue in varchar2,
    p_strdata in varchar2,
    p_tlid IN VARCHAR2,
    p_role IN VARCHAR2,
    p_err_code in out varchar2,
    p_err_param in out varchar2)
is
    /*
    Input
        p_objname: Ma chuc nang
        p_keyval : Key cua GD
        p_otpvalue: Ma OTP
        p_strdata: Gia tri khac (neu co), field du phong dung sau nay.
    Output:
        p_err_code: Ma loi
        p_err_param: Mo ta loi
    */
    v_count         number;
    v_exprieddt     date;
    v_otpretrycnt   number;
    v_otpcheck    varchar2(1);
    v_isauto varchar2(1);
    v_txnum varchar2(50);
    v_txdate date;
    v_tltxcd varchar2(10);
begin
    p_err_code  := systemnums.C_SUCCESS;
    p_err_param := 'SUCCESS';
    plog.setbeginsection (pkgctx, 'pr_verify_totp');
    Begin
        select varvalue into v_otpcheck  from sysvar where varname='OTPCHECK';
    exception
    when others
        then v_otpcheck := 'N';
    End;

    begin
        select isauto into v_isauto from otp_logs where refcode = p_objname AND  refid = p_keyval;
    exception
        when others then
        v_isauto :='N';
    end;

    v_txnum := SUBSTR(p_keyval,14,10);
        if v_otpcheck <> 'Y' then
        --Cap nhat trang thai giao dich
                IF p_objname ='IMP' THEN
                        fopks_file.prc_txprocess4cb(p_keyval, p_tlid, P_ERR_CODE, P_ERR_PARAM);
                        if p_err_code <> SYSTEMNUMS.C_SUCCESS THEN

                            p_err_param :=cspks_system.fn_get_errmsg(p_err_code);
                            ROLLBACK;
                            plog.setEndSection(pkgctx, 'pr_verify_totp');
                            RETURN;
                        end if;
                 ELSIF  p_objname ='TRANS' THEN
                     v_txdate := TO_DATE(SUBSTR(p_keyval,2,10),'dd/mm/rrrr');
                     if v_isauto ='N' then
                         UPDATE tllog SET txstatus = TXSTATUSNUMS.c_txpending
                         WHERE txdate = v_txdate
                         AND txnum = v_txnum
                         AND txstatus = TXSTATUSNUMS.c_txlogged;
                     else
                         PRC_TXPROCESS4FUND('A',
                         v_txnum ,
                         v_txdate,
                         '6868',
                         2,
                         p_err_code,
                         p_err_param);
                         if p_err_code <> SYSTEMNUMS.C_SUCCESS THEN

                             p_err_param :=cspks_system.fn_get_errmsg(p_err_code);
                             ROLLBACK;
                             plog.setEndSection(pkgctx, 'pr_verify_totp');
                             RETURN;
                         end if;
                    end if;
                end if;
            UPDATE otp_logs SET status ='C'
            WHERE  refid = p_keyval
            AND refcode = p_objname and status ='A';
        else
            Begin
                select varvalue into v_otpretrycnt  from sysvar where varname='OTPRETRYCNT';
            exception
            when others
                then v_otpretrycnt := 1;
            End;

            Select count(1) into v_count
            from otp_logs
            where status ='A' and  refcode = p_objname
                AND refid = p_keyval and secset = genencryptpassword(p_otpvalue);

            If v_count = 0 then
                -- OTP Khong dung
                p_err_code := '-202000';
                p_err_param :=cspks_system.fn_get_errmsg(p_err_code);
                plog.error (pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
                plog.setendsection (pkgctx, 'pr_verify_totp');
                return ;
            End If;

            Select count(1) into v_count
            from otp_logs
            where status ='A' and refid = p_keyval
                AND refcode = p_objname
                and secset = genencryptpassword(p_otpvalue)
                and exprieddt > sysdate
                and retry_count < v_otpretrycnt;

            If v_count = 0 then
                -- OTP het han
                p_err_code := '-202001';
                 p_err_param :=cspks_system.fn_get_errmsg(p_err_code);
                plog.error (pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
                plog.setendsection (pkgctx, 'pr_verify_totp');
                return;
            End If;
            --Cap nhat trang thai
            UPDATE otp_logs SET status ='C' WHERE  refid = p_keyval AND refcode = p_objname;
            --Cap nhat trang thai giao dich
            IF p_objname ='IMP' THEN
                fopks_file.prc_txprocess4cb(p_keyval, p_tlid, P_ERR_CODE, P_ERR_PARAM);
                if p_err_code <> SYSTEMNUMS.C_SUCCESS THEN

                    p_err_param :=cspks_system.fn_get_errmsg(p_err_code);
                    ROLLBACK;
                    plog.setEndSection(pkgctx, 'pr_verify_totp');
                    RETURN;
                end if;
                plog.setendsection (pkgctx, 'pr_verify_totp');
                return;
            ELSIF  p_objname ='TRANS' THEN
               v_txdate := TO_DATE(SUBSTR(p_keyval,2,10),'dd/mm/rrrr');
               if v_isauto ='N' then
                     UPDATE tllog SET txstatus = TXSTATUSNUMS.c_txpending
                     WHERE txdate = v_txdate
                     AND txnum = v_txnum
                     AND txstatus = TXSTATUSNUMS.c_txlogged;
               else
                     PRC_TXPROCESS4FUND('A',
                     v_txnum ,
                     v_txdate,
                     '6868',
                     2,
                     p_err_code,
                     p_err_param);
                     if p_err_code <> SYSTEMNUMS.C_SUCCESS THEN

                         p_err_param :=cspks_system.fn_get_errmsg(p_err_code);
                         ROLLBACK;
                         plog.setEndSection(pkgctx, 'pr_verify_totp');
                         RETURN;
                     end if;
                end if;
            end if;
        end if;


       BEGIN
    select tltxcd into v_tltxcd from tllog where txdate = v_txdate and txnum = v_txnum;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            v_tltxcd:= null;
    END;
    if v_tltxcd = '6639' then
        UPDATE tllog SET txstatus = '99'
        WHERE txdate = v_txdate
        AND txnum = v_txnum;
    end if;

    plog.setendsection (pkgctx, 'pr_verify_totp');
exception
when others
   then
    p_err_code := errnums.c_system_error;
    plog.error (pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
    plog.setendsection (pkgctx, 'pr_verify_totp');
    raise errnums.e_system_error;
end pr_verify_totp_bk0608;

PROCEDURE PRC_GET_TICKER_SBSECURITIES (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2) as
   v_param  varchar2(4000);
   v_settledate varchar2(50);
   v_codeid varchar2(50);
  BEGIN

    plog.debug(pkgctx, 'PRC_GET_TICKER_SBSECURITIES');
    v_param:=' PRC_GET_TICKER_SBSECURITIES: '  ;

    err_code  := systemnums.C_SUCCESS;
    err_msg := 'SUCCESS';
    OPEN p_refcursor FOR

SELECT  SEC.CODEID CDVAL, SEC.SYMBOL CDCONTENT, SEC.SYMBOL EN_CDCONTENT,
                (CASE WHEN SEC.BONDTYPE = '001' THEN 1 ELSE 2 END) CLEARDAY
             FROM SBSECURITIES SEC, SECURITIES_INFO SEINFO
              WHERE SEC.CODEID=SEINFO.CODEID
                AND SEC.SECTYPE <> '004'
                AND SEC.TRADEPLACE NOT IN ('006','003');
  EXCEPTION
    WHEN OTHERS THEN
      err_code := errnums.C_SYSTEM_ERROR;
      plog.setEndSection(pkgctx, 'PRC_GET_TICKER_SBSECURITIES');

END PRC_GET_TICKER_SBSECURITIES;
PROCEDURE PRC_GET_DEBIT_FROM_CUSTODYCD (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                    P_CUSTODYCD    IN   VARCHAR2,
                     P_TLID    IN   VARCHAR2,
                      P_ROLE    IN   VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2) as
   v_param  varchar2(4000);
  BEGIN

    plog.debug(pkgctx, 'PRC_GET_DEBIT_FROM_CUSTODYCD');
    v_param:=' PRC_GET_DEBIT_FROM_CUSTODYCD: '  ;

    err_code  := systemnums.C_SUCCESS;
    err_msg := 'SUCCESS';
    OPEN p_refcursor FOR


SELECT vnd.VALUE CDVAL, vnd.DISPLAY CDCONTENT, vnd.EN_DISPLAY EN_CDCONTENT
 FROM vw_ddmast_vnd vnd,userlogin u
 WHERE  ( INSTR(u.listcustodycd, vnd.filtercd) >0 or vnd.filtercd =u.custodycd)
 and u.username=p_tlid
 and vnd.FILTERCD=P_CUSTODYCD
 ORDER BY vnd.FILTERCD;

  EXCEPTION
    WHEN OTHERS THEN
      err_code := errnums.C_SYSTEM_ERROR;
      plog.setEndSection(pkgctx, 'PRC_GET_DEBIT_FROM_CUSTODYCD');

END PRC_GET_DEBIT_FROM_CUSTODYCD;
PROCEDURE PRC_GET_CITAD_LISTSOURCES (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2) as
   v_param  varchar2(4000);
  BEGIN

    plog.debug(pkgctx, 'PRC_GET_CITAD_LISTSOURCES');
    v_param:=' PRC_GET_CITAD_LISTSOURCES: '  ;

    err_code  := systemnums.C_SUCCESS;
    err_msg := 'SUCCESS';
    OPEN p_refcursor FOR
SELECT crb.CITAD CDVAL, crb.BANKNAME CDCONTENT,crb.BANKNAME EN_CDCONTENT
FROM crbbanklist crb, allcode A1
where  0=0
AND A1.CDTYPE='SY'
AND A1.CDNAME='APPRV_STS'
AND A1.CDVAL=crb.STATUS;
  EXCEPTION
    WHEN OTHERS THEN
      err_code := errnums.C_SYSTEM_ERROR;
      plog.setEndSection(pkgctx, 'PRC_GET_CITAD_LISTSOURCES');

END PRC_GET_CITAD_LISTSOURCES;
PROCEDURE PRC_GET_BROKERCODE_FROM_CUSTODYCD (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                    P_CUSTODYCD    IN   VARCHAR2,
                    P_TLID IN   VARCHAR2,
                    P_ROLE IN   VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2) as
   v_param  varchar2(4000);
  BEGIN

    plog.debug(pkgctx, 'PRC_GET_BROKERCODE_FROM_CUSTODYCD');
    v_param:=' PRC_GET_BROKERCODE_FROM_CUSTODYCD: '  ;

    err_code  := systemnums.C_SUCCESS;
    err_msg := 'SUCCESS';
    OPEN p_refcursor FOR

 SELECT vnd.VALUE CDVAL, vnd.DISPLAY CDCONTENT, vnd.EN_DISPLAY EN_CDCONTENT
 FROM VW_CUSTODYCD_MEMBER vnd,userlogin u
 WHERE  ( INSTR(u.listcustodycd, vnd.filtercd) >0 or vnd.filtercd =u.custodycd)
 and u.username=p_tlid
 and FILTERCD=P_CUSTODYCD
 ORDER BY vnd.VALUE;
  EXCEPTION
    WHEN OTHERS THEN
      err_code := errnums.C_SYSTEM_ERROR;
      plog.setEndSection(pkgctx, 'PRC_GET_BROKERCODE_FROM_CUSTODYCD');

END PRC_GET_BROKERCODE_FROM_CUSTODYCD;

procedure pr_auto_8864_web(p_codeid varchar2, p_kqgd varchar2, p_desacctno varchar2,
                        p_amt varchar2, p_parvalue varchar2, p_qtty varchar2,
                        p_citad varchar2, p_grossamount varchar2, p_tradedate varchar2,
                        p_settledate varchar2, p_exectype varchar2, p_feeamt varchar2,
                        p_vatamt varchar2, p_identity varchar2, p_ap varchar2,
                        p_clearday varchar2, p_symbol varchar2, p_custodycd varchar2, p_transtype varchar2,
                        p_memberid varchar2, p_desc varchar2,P_APACCT varchar2,P_ETFDATE varchar2,  tlid varchar2,
                        p_reftransid  out varchar2, err_code in out varchar2, err_msg in out varchar2) IS
  l_txmsg       tx.msg_rectype;
  v_strcurrdate varchar2(20);
  v_strdesc     varchar2(1000);
  v_stren_desc  varchar2(1000);
  v_tltxcd      varchar2(10);
  p_xmlmsg      varchar2(4000);
  v_param       varchar2(1000);
  v_etfname       varchar2(1000);
  v_dc          number;
  v_fundcodeid   varchar2(50);
  v_amt         number;
  v_err_code    varchar2(10);
  p_err_message varchar2(500);
  l_txnum         varchar2(20);
  v_fullname       varchar2(1000);
  v_tlid        varchar2(50);
  v_balance         number;
  v_settledate         varchar2(50);
  v_txmsg_string    varchar2(5000);
  V_CODEID    varchar2(5000);
BEGIN

    ------------------------
    V_ERR_CODE    := SYSTEMNUMS.C_SUCCESS;
    P_ERR_MESSAGE := 'SUCCESS';
    PLOG.SETBEGINSECTION (PKGCTX, 'PR_AUTO_8864_WEB');
    V_TLTXCD := '8864';

    p_reftransid :='';

    ------------------------
    BEGIN
    SELECT TXDESC, EN_TXDESC
    INTO V_STRDESC, V_STREN_DESC
    FROM TLTX
    WHERE TLTXCD = V_TLTXCD;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            V_STRDESC:= null;
            V_STREN_DESC:= null;
    END;
    ------------------------
    SELECT TO_DATE (varvalue, systemnums.c_date_format)
    INTO v_strCURRDATE
    FROM sysvar
    WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

    ------------------------
    BEGIN
        SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD (SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
        INTO L_TXNUM
        FROM DUAL;
    EXCEPTION
          WHEN NO_DATA_FOUND THEN
            L_TXNUM:= null;
    END;
    ------------------------
    L_TXMSG.MSGTYPE     :='T';
    L_TXMSG.LOCAL       :='N';
    L_TXMSG.TLID        :='6868';

    BEGIN
    SELECT TLID
    INTO v_tlid
    FROM cfmast
    where custodycd=P_CUSTODYCD;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
           v_tlid:= null;
    END;

    ------------------------
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
    INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS
    FROM DUAL;
    ------------------------
    BEGIN
        SELECT BRID
        INTO L_TXMSG.BRID
        FROM TLPROFILES WHERE TLID=v_tlid;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           L_TXMSG.BRID:= null;
    END;
    ------------------------

        BEGIN
        SELECT CODEID
        INTO V_CODEID
        FROM sbsecurities WHERE symbol=P_SYMBOL;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           V_CODEID:= '';
    END;
      ------------------------
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.C_DELTD_TXNORMAL;
    l_txmsg.txstatus    := txstatusnums.c_txlogged;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := 'DAY';
    l_txmsg.reftxnum    := l_txnum;
    l_txmsg.txdate      := to_date(v_strcurrdate,systemnums.c_date_format);
    l_txmsg.busdate     := to_date(v_strcurrdate,systemnums.c_date_format);
    l_txmsg.tltxcd      := v_tltxcd;
    l_txmsg.nosubmit    := '1';
    l_txmsg.ovrrqd      := '@0';

    --------------------------SET CAC FIELD GIAO DICH-------------------------------
    ----set txnum
    begin
        select l_txmsg.brid || lpad(seq_txnum.nextval, 6, '0')
            into l_txmsg.txnum
        from dual;
    exception
    when no_data_found then
       l_txmsg.txnum:= null;
    end;

    p_reftransid :='['|| to_char( l_txmsg.txdate,systemnums.c_date_format)  ||']['||l_txmsg.txnum||']';

    ----set settledate
    begin
        select fn_get_nextdate_8864(to_date(p_tradedate,systemnums.c_date_format),p_clearday)
            into v_settledate
        from dual;
    exception
    when no_data_found then
        v_settledate:= null;
    end;

    --01    M?h?ng kho?  C
    l_txmsg.txfields ('01').defname   := 'CODEID';
    l_txmsg.txfields ('01').TYPE      := 'C';
    l_txmsg.txfields ('01').value      := V_CODEID;
    --04    Ngu?n ghi nh?n   C
    l_txmsg.txfields ('04').defname   := 'KQGD';
    l_txmsg.txfields ('04').TYPE      := 'C';
    l_txmsg.txfields ('04').value      := P_KQGD;
    --06    S? TKNH chuy?n   C
    l_txmsg.txfields ('06').defname   := 'DESACCTNO';
    l_txmsg.txfields ('06').TYPE      := 'C';
    l_txmsg.txfields ('06').value      := P_DESACCTNO;
    --10    Gi?r? thanh to?  N
    l_txmsg.txfields ('10').defname   := 'AMT';
    l_txmsg.txfields ('10').TYPE      := 'N';
    l_txmsg.txfields ('10').value      := P_AMT;
    --11    Gi? N
    l_txmsg.txfields ('11').defname   := 'PARVALUE';
    l_txmsg.txfields ('11').TYPE      := 'N';
    l_txmsg.txfields ('11').value      := P_PARVALUE;
    --12    S? lu?ng   N
    l_txmsg.txfields ('12').defname   := 'QTTY';
    l_txmsg.txfields ('12').TYPE      := 'N';
    l_txmsg.txfields ('12').value      := P_QTTY;
    --13    M?itad   C
    l_txmsg.txfields ('13').defname   := 'CITAD';
    l_txmsg.txfields ('13').TYPE      := 'C';
    l_txmsg.txfields ('13').value      := P_CITAD;
    --14    Gi?r? l?nh   N
    l_txmsg.txfields ('14').defname   := 'PARVALUE';
    l_txmsg.txfields ('14').TYPE      := 'N';
    l_txmsg.txfields ('14').value      := P_GROSSAMOUNT;
    --20    Ng?giao d?ch   D
    l_txmsg.txfields ('20').defname   := 'TRADEDATE';
    l_txmsg.txfields ('20').TYPE      := 'D';
    l_txmsg.txfields ('20').value      := P_TRADEDATE;
    --21    Ng?TTBT   D
    l_txmsg.txfields ('21').defname   := 'SETTLEDATE';
    l_txmsg.txfields ('21').TYPE      := 'D';
    l_txmsg.txfields ('21').value      :=V_SETTLEDATE;
    --23    Lo?i l?nh   C
    l_txmsg.txfields ('23').defname   := 'EXECTYPE';
    l_txmsg.txfields ('23').TYPE      := 'C';
    l_txmsg.txfields ('23').value      := P_EXECTYPE;
    --25    Ph?D   N
    l_txmsg.txfields ('25').defname   := 'FEEAMT';
    l_txmsg.txfields ('25').TYPE      := 'N';
    l_txmsg.txfields ('25').value      := P_FEEAMT;
    --26    Thu?   N
    l_txmsg.txfields ('26').defname   := 'VATAMT';
    l_txmsg.txfields ('26').TYPE      := 'N';
    l_txmsg.txfields ('26').value      := P_VATAMT;
    --27    Lo?i giao d?ch   C
    l_txmsg.txfields ('27').defname   := 'TRANSTYPE';
    l_txmsg.txfields ('27').TYPE      := 'C';
    l_txmsg.txfields ('27').value      := P_TRANSTYPE;
    --29    S? d?nh danh   C
    l_txmsg.txfields ('29').defname   := 'IDENTITY';
    l_txmsg.txfields ('29').TYPE      := 'C';
    l_txmsg.txfields ('29').value      := P_IDENTITY;
    --30    Di?n gi?i   C
    l_txmsg.txfields ('30').defname   := 'DESC';
    l_txmsg.txfields ('30').TYPE      := 'C';
    l_txmsg.txfields ('30').value      := P_DESC;
    --31    Ap   C
    l_txmsg.txfields ('31').defname   := 'AP';
    l_txmsg.txfields ('31').TYPE      := 'C';
    l_txmsg.txfields ('31').value      := P_AP;
    --33    S? ng?thanh to?  N
    l_txmsg.txfields ('33').defname   := 'CLEARDAY';
    l_txmsg.txfields ('33').TYPE      := 'N';
    l_txmsg.txfields ('33').value      := P_CLEARDAY;
    --35    APACCT   C
    l_txmsg.txfields ('35').defname   := 'APACCT';
    l_txmsg.txfields ('35').TYPE      := 'C';
    l_txmsg.txfields ('35').value      := P_APACCT;
      --36    ETFDATE   D
    l_txmsg.txfields ('36').defname   := 'ETFDATE';
    l_txmsg.txfields ('36').TYPE      := 'C';
    l_txmsg.txfields ('36').value     := P_ETFDATE;
    --68    M?h?ng kho?  C
    l_txmsg.txfields ('68').defname   := 'SYMBOL';
    l_txmsg.txfields ('68').TYPE      := 'C';
    l_txmsg.txfields ('68').value      := P_SYMBOL;
    --88    S? TKLK   C
    l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
    l_txmsg.txfields ('88').TYPE      := 'C';
    l_txmsg.txfields ('88').value      := P_CUSTODYCD;
    --99    BROKER CODE   C
    l_txmsg.txfields ('99').defname   := 'MEMBERID';
    l_txmsg.txfields ('99').TYPE      := 'C';
    l_txmsg.txfields ('99').value      := P_MEMBERID;


    v_txmsg_string :=txpks_msg.fn_obj2xml(l_txmsg);
    err_code:=txpks_#8864.fn_txProcess(v_txmsg_string, v_err_code, p_err_message);
    --------------------------------------------------------------------------------
    IF err_code <>SYSTEMNUMS.C_SUCCESS THEN
        PLOG.ERROR(PKGCTX,
           V_PARAM || ' run ' || V_TLTXCD || ' got ' || ERR_CODE || ':' ||
           P_ERR_MESSAGE);

        err_msg :=P_ERR_MESSAGE;
        ROLLBACK;
        PLOG.SETENDSECTION(PKGCTX, 'PR_AUTO_8864_WEB');
        RETURN;
    END IF;

    PR_LOG_USERNAME(l_txmsg, tlid, 'C');

    pr_generate_otp('TRANS',p_reftransid,  TLID, '', '','N', err_code, err_MSG);

--------------------------------------------------------------------------------
 PLOG.SETENDSECTION(PKGCTX, 'PR_AUTO_8864_WEB');
 EXCEPTION
    WHEN OTHERS THEN
        V_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.ERROR(PKGCTX,
                   ' Err: ' || SQLERRM || ' Trace: ' ||
                   DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

        PLOG.SETENDSECTION(PKGCTX, 'PR_AUTO_8864_WEB');
        ERR_CODE   := V_ERR_CODE;
END;

PROCEDURE PRC_GET_LIST_8864(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     P_CUSTODYCD IN  VARCHAR2,
                     P_TRADINGDATE     IN  VARCHAR2,
                     p_tlid IN VARCHAR2,
                     p_role IN VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2) as
   v_param  varchar2(4000);
   v_custodycd VARCHAR2(20);
   v_listcustodycd varchar2(4000);
   v_role VARCHAR2(10);
   v_TRADINGDATE VARCHAR2(10);
   v_CUSTODYCDINPUT VARCHAR2(10);
  BEGIN

    plog.debug(pkgctx, 'PRC_GET_LIST_8864');
    v_param:=' PRC_GET_LIST_8864: P_CUSTODYCD' || P_CUSTODYCD ;

    err_code  := systemnums.C_SUCCESS;
    err_msg := 'SUCCESS';
    Begin
    select custodycd,listcustodycd,role
        into v_custodycd,v_listcustodycd,v_role
    from userlogin
    where username = p_tlid;
    exception
        when others then
         v_custodycd := '';
         v_listcustodycd:='';
         v_role:='';
    End;
    if P_TRADINGDATE is null or P_TRADINGDATE = '' then
        v_TRADINGDATE:= '%';
    else
     v_TRADINGDATE:= P_TRADINGDATE;
    end if ;

    if P_CUSTODYCD is null or P_CUSTODYCD = '' then
        v_CUSTODYCDINPUT:= '%';
    else
        v_CUSTODYCDINPUT:= P_CUSTODYCD;
    end if ;
    OPEN p_refcursor FOR

 select * from (

select t.*,a2.cdcontent KQGD_desc,a2.en_cdcontent KQGD_endesc,
        a3.cdcontent EXECTYPE_desc,a3.en_cdcontent EXECTYPE_endesc,
         a4.cdcontent TRANSTYPE_desc,a4.en_cdcontent TRANSTYPE_endesc,
          debit.display DESACCTNO_desc,debit.en_display DESACCTNO_endesc,
          sb.symbol symbol_codeid,MEM.EN_DISPLAY MEMBERID_DESC,crb.bankname CITAD_DESC
from(
 select  max ( case when fldcd = '01' then cvalue else '' end)  CODEID,
        max( case when fldcd = '04' then cvalue else '' end)  KQGD,
        max( case when fldcd = '06' then cvalue else '' end)  DESACCTNO,
        max( case when fldcd = '10' then nvalue else 0 end)  AMT,
        max( case when fldcd = '11' then nvalue else 0 end)  PRICE,
        max( case when fldcd = '12' then nvalue else 0 end)  QTTY,
        max( case when fldcd = '13' then cvalue else '' end)  CITAD,
        max( case when fldcd = '14' then nvalue else 0 end)  GROSSAMOUNT,
        max( case when fldcd = '20' then cvalue else '' end)  TRADEDATE,
        max( case when fldcd = '21' then cvalue else '' end)  SETTLEDATE,
        max( case when fldcd = '23' then cvalue else '' end)  EXECTYPE,
        max( case when fldcd = '25' then nvalue else 0 end)  FEEAMT,
        max( case when fldcd = '26' then nvalue else 0 end)  VATAMT,
        max( case when fldcd = '27' then cvalue else '' end)  TRANSTYPE,
        max( case when fldcd = '29' then cvalue else '' end)  IDENTITY,
        max( case when fldcd = '30' then cvalue else '' end)  "DESC",
        max( case when fldcd = '31' then cvalue else '' end)  AP,
         max( case when fldcd = '35' then cvalue else '' end)  APACCT,
        max( case when fldcd = '36' then cvalue else '' end)  ETFDATE,
        max( case when fldcd = '33' then nvalue else 0 end)  CLEARDAY,
        max( case when fldcd = '68' then cvalue else '' end)  SYMBOL,
        max( case when fldcd = '88' then cvalue else '' end)  CUSTODYCD,
        max( case when fldcd = '99' then cvalue else '' end)  MEMBERID,
       tl.autoid, tl.txstatus txstatus, a1.cdcontent txstatus_desc ,
       case when v_8802.fileid is not null then ( select en_cdcontent from allcode where cdname='ORSTATUS' and cdval='3') else a1.en_cdcontent end txstatus_endesc,
       to_char(to_date(tl.txdate,'dd/MM/rrrr'),'dd/MM/rrrr') txdate ,tl.TXNUM,tl.tltxcd ||'-'||tx.txdesc txdesc,tl.tltxcd ||'-'||tx.en_txdesc en_txdesc
from tllogfld tlfld,tllog tl,tltx tx,allcode a1,(select fld1.cvalue fileid
                                                 from tllog tl1,tllogfld fld1
                                                 where tl1.txnum=fld1.txnum
                                                 and tl1.tltxcd='8802'
                                                 and tlid='6868'
                                                 and fld1.fldcd='28' and tl1.txstatus='1') v_8802
where tlfld.txnum=tl.txnum
and tx.tltxcd=tl.tltxcd
and a1.CDVAL=(CASE WHEN tl.DELTD='Y' THEN '9'
                   WHEN tl.txstatus = 'P' THEN '4'
                   else tl.txstatus END)
and tl.tltxcd='8864'
and a1.cdname='TXSTATUS' and a1.cdtype='SY'
and tl.txstatus<>'0'
and tl.tlid=C_TLID_ONLINE
and v_8802.fileid (+)=to_char(tl.txdate,'RRRRMMDD') || tl.txnum
GROUP BY tl.autoid,tl.TXDATE ,tl.TXNUM,tl.tltxcd ||'-'||tx.txdesc,tl.tltxcd ||'-'||tx.en_txdesc,tl.txstatus,
a1.cdcontent,a1.en_cdcontent,tl.tlid,v_8802.fileid
)t left join crbbanklist crb on crb.CITAD=t.citad,
allcode a2,allcode a3,allcode a4,vw_ddmast_vnd debit,SBSECURITIES sb,VW_CUSTODYCD_MEMBER MEM
where a2.cdval=t.KQGD
and a2.cdname='KQGD' and a2.cdtype='OD'
and a3.cdval=t.EXECTYPE
and a3.cdname='EXECTYPE' and a3.cdtype='OD'
and a4.cdval=t.TRANSTYPE
and a4.cdname='TRANSACTIONTYPE' and a4.cdtype='OD'
and debit.filtercd=t.CUSTODYCD
and debit.value=t.DESACCTNO
and sb.codeid=t.CODEID
and MEM.VALUE=t.MEMBERID
and MEM.FILTERCD=T.CUSTODYCD
and ( INSTR(v_listcustodycd, t.CUSTODYCD) >0 or t.CUSTODYCD =v_custodycd)
AND t.custodycd like v_CUSTODYCDINPUT
and t.SETTLEDATE like v_TRADINGDATE
union all
       -- import file
       SELECT ' ' CODEID,' '  AS KQGD, ' ' DESACCTNO,null AMT,null PRICE,
        null QTTY,' ' CITAD,null GROSSAMOUNT, ' ' AS TRADEDATE,' ' SETTLEDATE, ' ' EXECTYPE ,null FEEAMT,
        null VATAMT,' ' TRANSTYPE,' ' IDENTITY,TL.TXDESC "DESC",' ' AP,' ' APACCT,' ' ETFDATE,null CLEARDAY,' ' SYMBOL,' ' CUSTODYCD,' ' MEMBERID,
        TL.AUTOID,TL.STATUS TXSTATUS,TL.STATUS TXSTATUS_DESC,TL.STATUS TXSTATUS_ENDESC,to_char(TL.TXDATE,'dd/MM/rrrr'),TL.TXNUM,TL.TLTXCD||'-'||TL.TXDESC,TL.TLTXCD||'-'||TL.TXDESC EN_TXDESC,
        ' ' KQGD_DESC,' ' KQGD_ENDESC,' ' EXECTYPE_DESC,' ' EXECTYPE_ENDESC,
        ' ' TRANSTYPE_DESC,' ' TRANSTYPE_ENDESC,' ' DESACCTNO_DESC,' ' DESACCTNO_ENDESC,
        ' ' SYMBOL_CODEID,' ' MEMBERID_DESC,' ' CITAD_DESC
        FROM (Select t.AUTOID, t.txdesc, tltxcd, t.txdate,t.txnum,a.EN_cdcontent status,(case when  a.cdval = '4' then 'N' else 'Y' end) statusval,t.tlid from  tllog t,
        (SELECT  TXDATE ,TXNUM,
        MAX( CASE WHEN fldcd = '16' THEN cvalue ELSE '' END)  FILECODE,
        MAX( CASE WHEN fldcd = '15' THEN cvalue ELSE '' END)  FILEID,
        MAX( CASE WHEN fldcd = '99' THEN cvalue ELSE '' END)  USERNAME
        FROM tllogfld
        GROUP BY TXDATE ,TXNUM) m,allcode a
        where a.cdname = 'TXSTATUS' AND m.txdate = t.txdate and m.txnum = t.txnum  and a.cdtype = 'SY' and a.cdval <> 0 and m.FILECODE = 'I069' and decode(t.TXSTATUS,'P','4',t.TXSTATUS)  = a.cdval and M.USERNAME=p_tlid
        and t.TLTXCD in ('8800')) tl,tltx tx where tl.tltxcd = tx.tltxcd and tl.tlid=C_TLID_ONLINE
        ) tt
order by tt.AUTOID desc;


    plog.setEndSection(pkgctx, 'PRC_GET_LIST_8864');
  EXCEPTION
    WHEN OTHERS THEN
      err_code := errnums.C_SYSTEM_ERROR;
        plog.error(pkgctx,'p_cdtype: ' || ' Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
      plog.setEndSection(pkgctx, 'PRC_GET_LIST_8864');

END PRC_GET_LIST_8864;
PROCEDURE PRC_GET_TRANSACTIONTYPE_6639 (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2) as
   v_param  varchar2(4000);
  BEGIN

    plog.debug(pkgctx, 'PRC_GET_TRANSACTIONTYPE_6639');
    v_param:=' PRC_GET_TRANSACTIONTYPE_6639: '  ;

    err_code  := systemnums.C_SUCCESS;
    err_msg := 'SUCCESS';
    OPEN p_refcursor FOR

/*
SELECT  CDVAL, CDCONTENT, EN_CDCONTENT,lstodr
FROM ALLCODE WHERE CDNAME='CBTXTYPE' AND CDTYPE='SB'
UNION
SELECT  CDVAL, CDCONTENT, EN_CDCONTENT,lstodr
FROM ALLCODE WHERE CDNAME='CBTXTYPE' AND CDTYPE='CB' AND CDVAL IN ('CARRI','LISEFEECD','LISEFEEC')
UNION
SELECT  CDVAL, CDCONTENT, EN_CDCONTENT,lstodr
FROM ALLCODE WHERE CDNAME='CBTXTYPE' AND CDTYPE='CF'
order by lstodr asc;

SELECT * FROM
(SELECT  CDVAL , CDCONTENT , EN_CDCONTENT , LSTODR
FROM ALLCODE WHERE CDNAME='CBTXTYPE' AND CDTYPE='SB' AND CDVAL NOT IN ('SEVFEE','TADFS','CLS','OPN')
UNION
SELECT CDVAL , CDCONTENT , EN_CDCONTENT , LSTODR
FROM ALLCODE WHERE CDNAME='CBTXTYPE' AND CDTYPE='CB' AND CDVAL IN ('LISEFEECD')
UNION
SELECT  CDVAL , CDCONTENT , EN_CDCONTENT , LSTODR
FROM ALLCODE WHERE CDNAME='CBTXTYPE' AND CDTYPE='CF'
) ORDER BY LSTODR;
*/
SELECT * FROM
(SELECT  CDVAL , CDCONTENT , EN_CDCONTENT , LSTODR
FROM ALLCODE WHERE CDNAME='CBTXTYPE' AND CDTYPE='SB' AND CDVAL NOT IN ('SEVFEE','TADFS','CLS','OPN')
UNION
SELECT  CDVAL , CDCONTENT , EN_CDCONTENT , LSTODR
FROM ALLCODE WHERE CDNAME='CBTXTYPE' AND CDTYPE='CB' AND CDVAL IN ('LISEFEEC','LISEFEED')
UNION
SELECT  CDVAL , CDCONTENT , EN_CDCONTENT , LSTODR
FROM ALLCODE WHERE CDNAME='CBTXTYPE' AND CDTYPE='CF'
) ORDER BY LSTODR;

  EXCEPTION
    WHEN OTHERS THEN
      err_code := errnums.C_SYSTEM_ERROR;
      plog.setEndSection(pkgctx, 'PRC_GET_TRANSACTIONTYPE_6639');

END PRC_GET_TRANSACTIONTYPE_6639;
PROCEDURE PRC_GET_CIFID_FROM_CUSTODYCD (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                    P_CUSTODYCD    IN   VARCHAR2,
                    P_TLID IN   VARCHAR2,
                    P_ROLE IN   VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2) as
   v_param  varchar2(4000);
  BEGIN

    plog.debug(pkgctx, 'PRC_GET_CIFID_FROM_CUSTODYCD');
    v_param:=' PRC_GET_CIFID_FROM_CUSTODYCD: '  ;

    err_code  := systemnums.C_SUCCESS;
    err_msg := 'SUCCESS';
    OPEN p_refcursor FOR
select cf.cifid CDVAL, cf.cifid CDCONTENT, cf.cifid EN_CDCONTENT
from cfmast cf ,userlogin u
where  u.username=P_TLID
and( INSTR(u.listcustodycd, cf.custodycd) >0 or cf.custodycd =u.custodycd)
and cf.custodycd=P_CUSTODYCD;
  EXCEPTION
    WHEN OTHERS THEN
      err_code := errnums.C_SYSTEM_ERROR;
      plog.setEndSection(pkgctx, 'PRC_GET_CIFID_FROM_CUSTODYCD');

END PRC_GET_CIFID_FROM_CUSTODYCD;
PROCEDURE PRC_GET_ETFFUND_8894 (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2) as
   v_param  varchar2(4000);
  BEGIN

    plog.debug(pkgctx, 'PRC_GET_ETFFUND_8894');
    v_param:=' PRC_GET_ETFFUND_8894: '  ;

    err_code  := systemnums.C_SUCCESS;
    err_msg := 'SUCCESS';
    OPEN p_refcursor FOR

SELECT SB.CODEID CDVAL,SB.SYMBOL ||' - '|| ISS.FULLNAME CDCONTENT , SB.SYMBOL ||' - '|| ISS.EN_FULLNAME EN_CDCONTENT
  FROM SBSECURITIES SB, ISSUERS ISS
   WHERE SB.ISSUERID = ISS.ISSUERID AND
    SB.SECTYPE = '008' AND SB.tradeplace <> '006'  AND SB.STATUS = 'Y'
ORDER BY SB.SYMBOL;
  EXCEPTION
    WHEN OTHERS THEN
      err_code := errnums.C_SYSTEM_ERROR;
      plog.setEndSection(pkgctx, 'PRC_GET_ETFFUND_8894');

END PRC_GET_ETFFUND_8894;
PROCEDURE PRC_GET_IMP_TRANS_DETAIL(PV_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     p_txnum    IN   VARCHAR2,
                     p_txdate      IN  VARCHAR2,
                     p_tlid IN VARCHAR2,
                     p_role IN VARCHAR2,
                     p_err_code      IN OUT VARCHAR2,
                     p_err_param     IN OUT VARCHAR2)
  AS
    v_tltxcd varchar2(10);
    v_fileid varchar2(100);
    v_filecode varchar2(100);
    v_txdate date;
    v_sql varchar2(32000);
  BEGIN
    plog.setBeginSection(pkgctx, 'PRC_GET_IMP_TRANS_DETAIL');
    p_err_code  := systemnums.C_SUCCESS;
    p_err_param := 'SUCCESS';
    v_txdate :=to_date(p_txdate,'dd/mm/rrrr');

    SELECT tl.tltxcd INTO v_tltxcd  FROM vw_tllog_all tl  WHERE tl.txnum=p_txnum AND tl.txdate=TO_DATE( v_txdate,'DD/MM/RRRR');
    SELECT cvalue into v_fileid FROM vw_tllogfld_all WHERE txnum= p_txnum AND txdate= TO_DATE( v_txdate,'DD/MM/RRRR') AND fldcd ='15';
    SELECT cvalue into v_filecode FROM vw_tllogfld_all WHERE txnum= p_txnum AND txdate= TO_DATE( v_txdate,'DD/MM/RRRR') AND fldcd ='16';

    if v_tltxcd = '8800' then
        if v_filecode = 'I069' then
            Open PV_REFCURSOR FOR
            select nvl( m.shortname ,t.broker_code)BROKER_CODE ,t.TRANS_TYPE,t.CUSTODYCD CUSTODYCD,t.SEC_ID,t.TRADE_DATE,t.SETTLE_DATE,t.QUANTITY,t.PRICE,
                   t.GROSS_AMOUNT,t.COMMISSION_FEE,t.TAX,t.NET_AMOUNT,t.MAKER,t.TRANSACTIONTYPE,t.AP,
                   t.APACCT,t.ETFDATE,t.TYPE,t.FILEID
           from(
            select BROKER_CODE ,TRANS_TYPE,CUSTODYCD CUSTODYCD,SEC_ID,TRADE_DATE,SETTLE_DATE,QUANTITY,PRICE,
                   GROSS_AMOUNT,COMMISSION_FEE,TAX,NET_AMOUNT,TLIDIMP "MAKER",TRANSACTIONTYPE,AP,
                   APACCT,TO_CHAR(ETFDATE) ETFDATE,'TABLE' TYPE,FILEID
            from ODMASTCUST
            union all
            select BROKER_CODE,TRANS_TYPE,ST_CODE CUSTODYCD,SEC_ID,TRADE_DATE,SETTLE_DATE,QUANTITY,PRICE,
                   GROSS_AMOUNT,COMMISSION_FEE,TAX,NET_AMOUNT,TLIDIMP "MAKER",TRANSACTIONTYPE,AP,
                   APACCT,TO_CHAR(ETFDATE) ETFDATE,'TABLE' TYPE,FILEID
            from ODMASTCUST_TEMP
            union all
            select BROKER_CODE,TRANS_TYPE,ST_CODE CUSTODYCD,SEC_ID,TRADE_DATE,SETTLE_DATE,QUANTITY,PRICE,
                   GROSS_AMOUNT,COMMISSION_FEE,TAX,NET_AMOUNT,TLIDIMP "MAKER",TRANSACTIONTYPE,AP,
                   APACCT,TO_CHAR(ETFDATE) ETFDATE,'TABLE' TYPE,FILEID
             from   odmastcusthist ) t,(SELECT * FROM FAMEMBERS WHERE ROLES='BRK') M
             where t.fileid =v_fileid
             AND t.broker_code= M.depositmember (+);
        end if;
        if v_filecode = 'I073' then
            Open PV_REFCURSOR FOR
            select nvl( m.shortname ,t.broker_code)BROKER_CODE ,t.TRANS_TYPE,t.CUSTODYCD CUSTODYCD,t.SEC_ID,t.TRADE_DATE,t.SETTLE_DATE,t.QUANTITY,t.PRICE,
                   t.GROSS_AMOUNT,t.COMMISSION_FEE,t.TAX,t.NET_AMOUNT,t.MAKER,t.TYPE,t.FILEID
           from(
            select BROKER_CODE ,TRANS_TYPE,CUSTODYCD CUSTODYCD,SEC_ID,TRADE_DATE,SETTLE_DATE,QUANTITY,PRICE,
                   GROSS_AMOUNT,COMMISSION_FEE,TAX,NET_AMOUNT,TLIDIMP "MAKER",'TABLE' TYPE,FILEID
            from ODMASTCMP
            union all
            select BROKER_CODE,TRANS_TYPE,ST_CODE CUSTODYCD,SEC_ID,TRADE_DATE,SETTLE_DATE,QUANTITY,PRICE,
                   GROSS_AMOUNT,COMMISSION_FEE,TAX,NET_AMOUNT,TLIDIMP "MAKER",'TABLE' TYPE,FILEID
            from ODMASTCMP_TEMP
            union all
            select BROKER_CODE,TRANS_TYPE,ST_CODE CUSTODYCD,SEC_ID,TRADE_DATE,SETTLE_DATE,QUANTITY,PRICE,
                   GROSS_AMOUNT,COMMISSION_FEE,TAX,NET_AMOUNT,TLIDIMP "MAKER",'TABLE' TYPE,FILEID
             from   ODMASTCMPhist ) t,(SELECT * FROM FAMEMBERS WHERE ROLES='BRK') M
             where t.fileid =v_fileid
             AND t.broker_code= M.depositmember (+);
        end if;
        if v_filecode = 'I072' then
            Open PV_REFCURSOR FOR
        select autoid,transdate,custodycd,fundcodeid,tradingid,type exectype,ap,nav,quantity,
               value,difference,tradingfee,tax,sercurities,secqtty,secprice,secvalue,
               holdforsell,tradingaccount,'TABLE' TYPE,fileid
        FROM  (select * from etfresult_temphist UNION ALL SELECT * FROM etfresult_temp) t
        where  t.fileid =v_fileid;
        end if;
        if v_filecode = 'I078' then
            Open PV_REFCURSOR FOR
   select t.FTYPE,t.TRADINGACCOUNT,t.VALUEDATE,
        t.AMOUNT,t.FEETYPE,t.DESCRIPTION,t.BANKTRANSFERS,t.beneficiaryaccount,
        t.BENEFICIARYBANK,t.BENERFICARYNAME,t.TLIDIMP MAKER,'TABLE' TYPE from(
        select * from PAYMENTCASH_TEMP
        union all
        select * from PAYMENTCASH_TEMP_HIST) t
    where  t.fileid =v_fileid;
        end if;
         if v_filecode = 'I079' then
            Open PV_REFCURSOR FOR
    select t.FTYPE,t.SYMBOL,t.VALUEDATE,t.AMOUNT,t.DESCRIPTION,t.BANKTRANSFERS,
           t.beneficiaryaccount,t.BENEFICIARYBANK,t.BENERFICARYNAME,t.TLIDIMP MAKER,'TABLE' TYPE from(
        select * from PAYMENTINSTRUCTION_TARD_ETFEX
        union all
        select * from PAYMENTINSTRUCTION_TARD_ETFEX_HIST) t
    where  t.fileid =v_fileid;
        end if;
          if v_filecode = 'I080' then
          Open PV_REFCURSOR FOR
    select t.FTYPE,t.SYMBOL,t.TRANSDATE,t.AMOUNT,t.DESCRIPTION,t.BANKTRANSFERS,
           t.beneficiaryaccount,t.BENEFICIARYBANK,t.TLIDIMP MAKER,'TABLE' TYPE from(
        select * from PAYMENTINSTRUCTION_TAEX
        union all
        select * from PAYMENTINSTRUCTION_TAEX_HIST) t
    where  t.fileid =v_fileid;
        end if;
    end if;


    plog.setEndSection(pkgctx, 'PRC_GET_IMP_TRANS_DETAIL');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error(pkgctx,'Err: ' || SQLERRM || ' Trace: ' || dbms_utility.format_error_backtrace );
      plog.setEndSection(pkgctx, 'PRC_GET_IMP_TRANS_DETAIL');
END PRC_GET_IMP_TRANS_DETAIL;
PROCEDURE PRC_GET_AUTTHORIZED_8894 (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                    P_CUSTODYCD    IN   VARCHAR2,
                    p_tlid        in varchar2,
                    p_role        in varchar2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2) as
   v_param  varchar2(4000);
   v_custid varchar2(20);
  BEGIN

    plog.debug(pkgctx, 'PRC_GET_AUTTHORIZED_8894');
    v_param:=' PRC_GET_AUTTHORIZED_8894: '  ;

    err_code  := systemnums.C_SUCCESS;
    err_msg := 'SUCCESS';

    select cf.custid  into v_custid
    from cfmast cf,userlogin u
    where u.username=P_TLID
    and( INSTR(u.listcustodycd, cf.custodycd) >0 or cf.custodycd =u.custodycd)
    and cf.custodycd=P_CUSTODYCD;
    OPEN p_refcursor FOR

SELECT VALUE CDVAL, DISPLAY CDCONTENT, EN_DISPLAY EN_CDCONTENT
 FROM VW_CUSTODYCD_MEMBERAP_CF
 WHERE FILTERCD=v_custid ORDER BY VALUE;
  EXCEPTION
    WHEN OTHERS THEN
      err_code := errnums.C_SYSTEM_ERROR;
      plog.setEndSection(pkgctx, 'PRC_GET_AUTTHORIZED_8894');

END PRC_GET_AUTTHORIZED_8894;
PROCEDURE PRC_GET_SETTLMENTDATE_8864 (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                    p_tradingdate in varchar2,
                    p_clearday in varchar2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2) as
   v_param  varchar2(4000);
   v_settledate varchar2(50);
  BEGIN

    plog.debug(pkgctx, 'PRC_GET_SETTLMENTDATE_8864');
    v_param:=' PRC_GET_SETTLMENTDATE_8864: '  ;

    err_code  := systemnums.C_SUCCESS;
    err_msg := 'SUCCESS';

     begin
        select fn_get_nextdate_8864(to_date(p_tradingdate,systemnums.c_date_format),p_clearday)
            into v_settledate
        from dual;
    exception
    when no_data_found then
        v_settledate:= null;
    end;
    OPEN p_refcursor FOR

SELECT  v_settledate settledate FROM DUAL;
  EXCEPTION
    WHEN OTHERS THEN
      err_code := errnums.C_SYSTEM_ERROR;
      plog.setEndSection(pkgctx, 'PRC_GET_SETTLMENTDATE_8864');

END PRC_GET_SETTLMENTDATE_8864;
PROCEDURE PRC_GET_BANKINFO_6639 (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                    p_type in varchar2,
                    p_bankname in varchar2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2) as
   v_param  varchar2(4000);
  BEGIN
    --p_type: 0-get bank name,1- get bank branch
    plog.debug(pkgctx, 'PRC_GET_BANKINFO_6639');
    v_param:=' PRC_GET_BANKINFO_6639: '  ;

    err_code  := systemnums.C_SUCCESS;
    err_msg := 'SUCCESS';

    IF P_TYPE='0' THEN
        OPEN P_REFCURSOR FOR
        SELECT  BANKNAME CDVAL, BANKNAME CDCONTENT, BANKNAME EN_CDCONTENT FROM CRBBANKLIST GROUP BY BANKNAME;
    END IF;
    IF P_TYPE = '1' THEN
        OPEN P_REFCURSOR FOR
        SELECT CITAD CDVAL, BRANCHNAME CDCONTENT, BRANCHNAME EN_CDCONTENT
        FROM CRBBANKLIST
        WHERE BANKNAME= P_BANKNAME AND STATUS <> 'C';
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      err_code := errnums.C_SYSTEM_ERROR;
      plog.setEndSection(pkgctx, 'PRC_GET_BANKINFO_6639');

END PRC_GET_BANKINFO_6639;
--Right tranfer
--view tra c?u
procedure prc_get_list_right_transfer(p_refcursor   in out pkg_report.ref_cursor,
                                      p_fundsymbol  in varchar2,
                                      p_tradingdate in varchar2,
                                      p_camastid    in varchar2,
                                      p_type        in varchar2,
                                      p_tlid        in varchar2,
                                      p_role        in varchar2,
                                      p_err_code    in out varchar2,
                                      p_err_msg     in out varchar2)
as
    v_param         varchar2(4000);
    v_custodycd     varchar2(20);
    v_listcustodycd varchar2(200);
    v_role          varchar2(10);
begin

    plog.debug(pkgctx, 'prc_get_list_right_transfer');
    v_param   :=' prc_get_list_right_transfer: fundsymbol' || p_fundsymbol||' tradingdate '||p_tradingdate||' camastid '||p_camastid||' type '||p_type ;

    p_err_code  := systemnums.c_success;
    p_err_msg   := 'SUCCESS';

    begin
        select custodycd,listcustodycd,role
        into v_custodycd,v_listcustodycd,v_role
        from userlogin
        where username = p_tlid;
    exception
        when others then
             v_custodycd := '';
             v_listcustodycd:='';
             v_role:='';
    end;

    open p_refcursor for
    select fa.symbol fundcode,a1.en_cdcontent txstatus_cnt, tl.txstatus,tl.txnum,tl.txdate,
        tl.tltxcd||' - '||gd.en_txdesc tranname, tl.cfcustodycd custodycd,
        substr(fld.camastid,1,4) || '.'||substr(fld.camastid,5,6) ||'.' ||substr(fld.camastid,11,6) camastid,
        fld.symbolbuy,fld.namesymbolbuy,fld.symbolsell,fld.namesymbolsell,
        case when tl.tltxcd = '3383' then 'Sell' else 'Buy' end trantype,
        tl.msgamt amt, fld.tranferprice, fld.tranferamount,
        case when tl.tltxcd = '3383' then fld.qtty else 0 end qtty_right, tl.txdesc
    from tllog tl,tltx gd,allcode a1,cbfafund fa,
        (select txnum,txdate,
             max(case when fldcd = '06' then cvalue else null end) camastid,
             max(case when fldcd = '13' then nvalue else null end) tranferprice,
             max(case when fldcd = '22' then nvalue else null end) qtty,
             max(case when fldcd = '18' then nvalue else null end) tranferamount,
             max(case when fldcd = '60' then cvalue else null end) symbolbuy,
             max(case when fldcd = '61' then cvalue else null end) namesymbolbuy,
             max(case when fldcd = '62' then cvalue else null end) symbolsell,
             max(case when fldcd = '38' then cvalue else null end) namesymbolsell
         from tllogfld
         where fldcd in ('06','13','22','18','60','61','62','38')
         group by txnum,txdate) fld
    where tl.tltxcd in ('3303','3383')
    and tl.txstatus <> '0'
    and a1.cdname='TXSTATUS'
    and a1.cdtype='SY'
    and a1.cdval = tl.txstatus
    and tl.tltxcd = gd.tltxcd
    and tl.txnum = fld.txnum
    and tl.txdate = fld.txdate
    and tl.cfcustodycd = fa.custodycd
    and (instr(v_listcustodycd, tl.cfcustodycd) >0 or tl.cfcustodycd =v_custodycd)
    and fa.symbol like  nvl(p_fundsymbol,'%%')
    and tl.busdate like nvl(p_tradingdate,'%%')
    and fld.camastid like nvl(p_camastid,'%%')
    and tl.tltxcd like (case when p_type = 'S' then '3383'
                             when p_type = 'B' then '3303'
                             else '%%' end)
    order by tl.txdate desc, tl.txnum desc;

    plog.setendsection(pkgctx, 'prc_get_list_right_transfer');
exception
    when others then
         p_err_code := errnums.c_system_error;
         plog.error(pkgctx,'p_cdtype: ' || ' Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
         plog.setendsection(pkgctx, 'prc_get_list_right_transfer');
end prc_get_list_right_transfer;

--------?ng k? quy?n mua (Registration for right subscription)----
procedure prc_get_camastid (p_refcursor in out pkg_report.ref_cursor,
                            p_fundcode  in varchar2,
                            p_tltxcd    in varchar2,
                            p_err_code  in out varchar2,
                            p_err_msg   in out varchar2)
as
    v_param     varchar2(4000);
    v_custodycd varchar2(30);
begin

    plog.debug(pkgctx, 'prc_get_camastid');
    v_param   := ' prc_get_camastid'  ;

    p_err_code  := systemnums.c_success;
    p_err_msg   := 'success';

    select custodycd into v_custodycd from cbfafund where symbol = p_fundcode;
    if p_tltxcd IN ('3383','3303') then
        open p_refcursor for
             select ca.camastid cdval,
                    substr(ca.camastid,1,4) || '.'||substr(ca.camastid,5,6) ||'.' ||substr(ca.camastid,11,6) cdcontent,
                    substr(ca.camastid,1,4) || '.'||substr(ca.camastid,5,6) ||'.' ||substr(ca.camastid,11,6) en_cdcontent
             from cfmast cf, afmast af, camast ca, caschd sc
             where cf.custid = af.custid
             and af.acctno = sc.afacctno and sc.camastid=ca.camastid
             and to_date(ca.frdatetransfer,'DD/MM/YYYY') <= to_date(getcurrdate,'DD/MM/YYYY')
             and to_date(ca.todatetransfer,'DD/MM/YYYY') >= to_date(getcurrdate,'DD/MM/YYYY')
             and ca.status  in ('V','S','M')
             and sc.status in ('V','S','M')
             and ca.trflimit = 'Y'
             and ca.catype = '014'
             and cf.custodycd = v_custodycd
             order by ca.autoid desc;
    elsif p_tltxcd IN ('3384') then
        open p_refcursor for

             select ca.camastid cdval,
                    substr(ca.camastid,1,4) || '.'||substr(ca.camastid,5,6) ||'.' ||substr(ca.camastid,11,6) cdcontent,
                    substr(ca.camastid,1,4) || '.'||substr(ca.camastid,5,6) ||'.' ||substr(ca.camastid,11,6) en_cdcontent
             from cfmast cf, afmast af, camast ca, caschd sc
             where cf.custid = af.custid
             and af.acctno = sc.afacctno and sc.camastid=ca.camastid
             and to_date(ca.begindate,'DD/MM/YYYY') <= to_date(getcurrdate,'DD/MM/YYYY')
             and ca.status  in( 'V','M')
             and sc.status in( 'V','M')
             and sc.pbalance > 0 and sc.pqtty > 0
             and ca.catype = '014'
             and cf.custodycd = v_custodycd
             order by ca.autoid desc;
    elsif p_tltxcd IN ('3327') then
        open p_refcursor for
             select ca.camastid cdval,
                    substr(ca.camastid,1,4) || '.'||substr(ca.camastid,5,6) ||'.' ||substr(ca.camastid,11,6) cdcontent,
                    substr(ca.camastid,1,4) || '.'||substr(ca.camastid,5,6) ||'.' ||substr(ca.camastid,11,6) en_cdcontent
             from camast ca, caschd schd, cfmast cf, afmast af
             where ca.camastid=schd.camastid
             and schd.afacctno=af.acctno and af.custid=cf.custid
             and to_date(ca.begindate,'DD/MM/YYYY') <= to_date(getcurrdate,'DD/MM/YYYY')
             and to_date(ca.duedate,'DD/MM/YYYY') >= to_date(getcurrdate,'DD/MM/YYYY')
             and ca.catype='023' and schd.status='V'
             and schd.pqtty>=1
             and schd.deltd='N'
             and cf.custodycd = v_custodycd
             order by ca.autoid desc;
    elsif p_tltxcd IN ('3333') then
        open p_refcursor for
             select ca.camastid cdval,
                    substr(ca.camastid,1,4) || '.'||substr(ca.camastid,5,6) ||'.' ||substr(ca.camastid,11,6) cdcontent,
                    substr(ca.camastid,1,4) || '.'||substr(ca.camastid,5,6) ||'.' ||substr(ca.camastid,11,6) en_cdcontent
             from camast ca, caschd schd, cfmast cf, afmast af
             where ca.camastid=schd.camastid
             and schd.afacctno=af.acctno and af.custid=cf.custid
             and to_date(ca.begindate,'DD/MM/YYYY') <= to_date(getcurrdate,'DD/MM/YYYY')
             and ca.status  in( 'V','M')
             and schd.status in( 'V','M')
             and schd.pbalance > 0 and schd.pqtty > 0
             and ca.catype='014'
             and schd.deltd='N'
             and cf.custodycd = v_custodycd
             order by ca.autoid desc;
     end if;
exception
    when others then
        p_err_code := errnums.c_system_error;
    plog.setendsection(pkgctx, 'prc_get_camastid');
end prc_get_camastid;

--lay du lieu th?tin t?kho?n
procedure prc_get_info_account(p_refcursor   in out pkg_report.ref_cursor,
                               p_custodycd   in varchar2,
                               p_err_code    in out varchar2,
                               p_err_msg     in out varchar2)
as
    v_param         varchar2(4000);
    v_acctno        varchar2(30);
begin

    plog.debug(pkgctx, 'prc_get_info_account');
    v_param   :=' prc_get_info_account: p_custodycd' ||p_custodycd ;

    p_err_code  := systemnums.c_success;
    p_err_msg   := 'SUCCESS';

    open p_refcursor for
    select cf.fullname, cf.address, cf.idcode, cf.iddate, cf.idplace,cf.country
        from cfmast cf
        where cf.custodycd = p_custodycd;
exception
    when others then
        p_err_code := errnums.c_system_error;
    plog.setendsection(pkgctx, 'prc_get_info_account');
end prc_get_info_account;


procedure prc_get_right_transfer_citad (p_refcursor in out pkg_report.ref_cursor,
                                        p_err_code  in out varchar2,
                                        p_err_msg   in out varchar2)
as
    v_param  varchar2(4000);
begin

    plog.debug(pkgctx, 'prc_get_right_transfer_citad');
    v_param   := ' prc_get_right_transfer_citad'  ;

    p_err_code  := systemnums.c_success;
    p_err_msg   := 'success';

    open p_refcursor for
        select citad cdval,
             citad ||'-'||bankbiccode cdcontent ,
             citad ||'-'||bankbiccode en_cdcontent
        from crbbanklist where 0=0;
exception
    when others then
        p_err_code := errnums.c_system_error;
    plog.setendsection(pkgctx, 'prc_get_right_transfer_citad');
end prc_get_right_transfer_citad;

procedure prc_get_right_transfer_fromcusadd (p_refcursor in out pkg_report.ref_cursor,
                                             p_trantype  in varchar2,
                                             p_err_code  in out varchar2,
                                             p_err_msg   in out varchar2)
as
    v_param  varchar2(4000);
begin

    plog.debug(pkgctx, 'prc_get_right_transfer_fromcusadd');
    v_param   := ' prc_get_right_transfer_fromcusadd'  ;

    p_err_code  := systemnums.c_success;
    p_err_msg   := 'success';

    if p_trantype = 'S' then
        open p_refcursor for
            select varvalue cdval, varvalue cdcontent,varvalue en_cdcontent from sysvar where varname like '%ISSUERMEMBER%';
    else
        open p_refcursor for
            select  depositid cdval, fullname cdcontent, fullname en_cdcontent
            from deposit_member
            order by depositid;
    end if;
exception
    when others then
        p_err_code := errnums.c_system_error;
    plog.setendsection(pkgctx, 'prc_get_right_transfer_fromcusadd');
end prc_get_right_transfer_fromcusadd;

procedure prc_get_right_transfer_feecd (p_refcursor in out pkg_report.ref_cursor,
                                        p_err_code  in out varchar2,
                                        p_err_msg   in out varchar2)
as
    v_param  varchar2(4000);
begin

    plog.debug(pkgctx, 'prc_get_right_transfer_feecd');
    v_param   := ' prc_get_right_transfer_feecd'  ;

    p_err_code  := systemnums.c_success;
    p_err_msg   := 'success';

    open p_refcursor for
        select feecd cdval,feecd ||'-'|| feename cdcontent, feecd ||'-'|| feename en_cdcontent
        from feemaster
        where feecd in (select distinct feecd from feemap where tltxcd='<$TLTXCD>')
        union all
        select '777777' cdval, 'Nh?p tay' cdcontent, 'Manual input' en_cdcontent from dual;
exception
    when others then
        p_err_code := errnums.c_system_error;
    plog.setendsection(pkgctx, 'prc_get_right_transfer_feecd');
end prc_get_right_transfer_feecd;

procedure prc_get_info_from_camastid(p_refcursor   in out pkg_report.ref_cursor,
                                     p_camastid    in varchar2,
                                     p_fundcode    in varchar2,
                                     p_tltxcd      in varchar2,
                                     p_err_code    in out varchar2,
                                     p_err_msg     in out varchar2)
as
    v_param         varchar2(4000);
    v_acctno        varchar2(30);
    v_custodycd     varchar2(30);
begin

    plog.debug(pkgctx, 'prc_get_info_from_camastid');
    v_param   :=' prc_get_info_from_camastid: p_camastid' ||p_camastid ;

    p_err_code  := systemnums.c_success;
    p_err_msg   := 'SUCCESS';

    select a.custodycd into v_custodycd from cbfafund a where a.symbol = p_fundcode;
    select af.acctno into v_acctno from cfmast cf, afmast af where cf.custid = af.custid and cf.custodycd = v_custodycd;

    if p_tltxcd in ('3383','3303') then
        open p_refcursor for
            select v_custodycd custodycd,NVL(cas.autoid,0) autoid, ca.camastid, nvl(cas.qtty,0) qtty,nvl(cas.qtty,0) maxqtty, se.symbol symbolbuy, iss.fullname issnamebuy,
                   se1.symbol symbolsell, iss1.fullname issnamesell,ca.catype, a1.en_cdcontent eventype,ca.todatetransfer
            from camast ca,sbsecurities se,issuers iss, allcode a1,sbsecurities se1,issuers iss1,
                 (select cas.autoid,cas.camastid,cas.pbalance-cas.inbalance qtty
                  from caschd cas
                  where cas.status in('V','S','M')
                  and cas.deltd <>'Y'
                  and cas.pbalance - cas.inbalance > 0
                  and cas.camastid = p_camastid
                  and cas.afacctno = v_acctno) cas
            where ca.camastid = cas.camastid(+)
            and ca.codeid = se.codeid
            and se.issuerid = iss.issuerid
            and a1.cdname='CATYPE'
            and a1.cdtype='CA'
            and a1.cdval = ca.catype
            and NVL(ca.TOCODEID, ca.CODEID) = se1.codeid
            and ca.camastid = p_camastid
            and se1.issuerid = iss1.issuerid;
    elsif p_tltxcd in ('3384') then
        open p_refcursor for
            select cf.custodycd,ca.catype, a1.en_cdcontent catype_cnt, sym.symbol ,iss.fullname issname,
                ca.reportdate,sc.pqtty qtty_en,ca.rightoffrate excersiseratio,
                --sc.pqtty/(substr(ca.rightoffrate,1,instr(ca.rightoffrate,'/')-1)/substr(ca.rightoffrate,instr(ca.rightoffrate,'/')+1)) maxqtty,
                sc.pqtty maxqtty,sc.qtty qtty_ex,sc.pqtty - sc.qtty remainqtty,sym.parvalue subprice
            from cfmast cf, afmast af, ddmast dd, camast ca, caschd sc, sbsecurities sym, issuers iss,allcode a1
            where cf.custid=af.custid and af.acctno=dd.afacctno
            and dd.afacctno=sc.afacctno and sc.camastid=ca.camastid
            and ca.codeid = sym.codeid
            and iss.issuerid = sym.issuerid
            and dd.isdefault ='Y' and dd.status <> 'C'
            and a1.cdname = 'CATYPE' and a1.cdtype = 'CA' and a1.cdval = ca.catype
            and ca.camastid = p_camastid
            and cf.custodycd = v_custodycd;
    elsif p_tltxcd in ('3327') then
        open p_refcursor for
            select cf.custodycd, ca.camastid, ca.catype,a1.en_cdcontent catype_cnt ,
                sec1.symbol bondsymbol,sec2.symbol sharesymbol, ca.begindate, ca.duedate,
                ca.actiondate,schd.balance maxbondqtty,schd.balance bondqtty, schd.pqtty shareqtty
            from camast ca, caschd schd,cfmast cf, afmast af,sbsecurities sec1, sbsecurities sec2, allcode a1
            where ca.camastid=schd.camastid
            and schd.afacctno=af.acctno and af.custid=cf.custid
            and ca.codeid=sec1.codeid and ca.tocodeid=sec2.codeid
            and schd.status='V'
            and schd.pqtty>=1
            and schd.deltd='N'
            and a1.cdname = 'CATYPE' and a1.cdtype = 'CA' and a1.cdval = ca.catype
            and ca.camastid = p_camastid
            and cf.custodycd = v_custodycd;
    elsif p_tltxcd in ('3333') then
        open p_refcursor for
            select cf.custodycd,ca.catype, a1.en_cdcontent catype_cnt, sym.symbol otpsymbol,iss.fullname otpsymbolname,
                (sc.pqtty + sc.qtty) qtty_en ,ca.reportdate, ca.rightoffrate excersiseratio, sc.pqtty maxqtty,
                 sc.pqtty qtty,sym.parvalue subprice
            from cfmast cf, afmast af, ddmast dd, camast ca, caschd sc, sbsecurities sym, issuers iss,allcode a1
            where cf.custid=af.custid and af.acctno=dd.afacctno
            and dd.afacctno=sc.afacctno and sc.camastid=ca.camastid
            and ca.optcodeid = sym.codeid
            and iss.issuerid = sym.issuerid
            and dd.isdefault ='Y' and dd.status <> 'C'
            and a1.cdname = 'CATYPE' and a1.cdtype = 'CA' and a1.cdval = ca.catype
            and ca.camastid = p_camastid
            and cf.custodycd = v_custodycd;
    end if;

exception
    when others then
        p_err_code := errnums.c_system_error;
    plog.setendsection(pkgctx, 'prc_get_info_from_camastid');
end prc_get_info_from_camastid;

procedure pr_auto_3383_3303_web(
    p_valuedate      varchar2,
    p_camastid       varchar2,
    p_trantype     varchar2,
    p_sellaccount    varchar2,
    p_fullname       varchar2,
    p_licenesid      varchar2,
    p_address        varchar2,
    p_issuedate      varchar2,
    p_issueplace     varchar2,
    p_country        varchar2,
    p_fromcusadd     varchar2,--TV LK ben chuyen
    p_buyaccount     varchar2,
    p_fullname2      varchar2,
    p_licenesid2     varchar2,
    p_address2       varchar2,
    p_issuedate2     varchar2,
    p_issueplace2    varchar2,
    p_country2       varchar2,
    p_citad          varchar2,
    p_symbolbuy      varchar2,
    p_issnamebuy     varchar2,
    p_symbolsell     varchar2,
    p_issnamesell    varchar2,
    p_qttyen         number,
    p_outptrade      number,
    p_outpblocked    number,
    p_qttyex         number,
    p_remainqtty     number,
    p_feecode        varchar2,
    p_transferprice  number,
    p_transferamt    number,
    p_feeamt         number,
    p_taxrate        number,
    p_taxamt         number,
    p_desc           varchar2,
    p_autoid         varchar2,
    p_remoaccount    varchar2,
    p_tlid           varchar2,
    p_reftransid     out varchar2,
    p_err_code       in out varchar2,
    p_err_msg        in out varchar2
 ) is
    l_txmsg          tx.msg_rectype;
    v_strcurrdate    varchar2(20);
    v_strdesc        varchar2(1000);
    v_stren_desc     varchar2(1000);
    v_tltxcd         varchar2(10);
    p_xmlmsg         varchar2(4000);
    v_param          varchar2(1000);
    v_dc             number;
    v_err_code       varchar2(10);
    p_err_message    varchar2(500);
    l_txnum          varchar2(20);
    v_tlid           varchar2(5);
    v_xmlmsg_string  varchar2(5000);

    v_cifid          varchar2(50);
    v_afacctno       varchar2(50);
    v_codeidbuy      varchar2(30);
    v_ptrade         number;
    v_pblocked       number;
    v_tradeplace     varchar2(300);
    v_trflimit       varchar2(50);
    v_sendto         varchar2(10);
    v_ddacctno     varchar2(50);
BEGIN
    v_err_code    := systemnums.c_success;
    p_err_message := 'success';
    plog.setbeginsection (pkgctx, 'pr_auto_3383_3303_web');

    p_reftransid :='';

    select to_date (varvalue, systemnums.c_date_format)
    into v_strcurrdate
    from sysvar
    where grname = 'SYSTEM' and varname = 'CURRDATE';

    l_txmsg.msgtype     :='T';
    l_txmsg.local       :='N';
    l_txmsg.tlid        :='6868';

    select codeid, tradeplace into v_codeidbuy, v_tradeplace from sbsecurities where symbol = p_symbolbuy;
    begin
        select cf.tlid,af.acctno, cf.cifid, dd.acctno
        into v_tlid, v_afacctno, v_cifid,v_ddacctno
        from cfmast cf, afmast af, ddmast dd
        where cf.custodycd= DECODE(p_trantype,'S',p_sellaccount,'B',p_buyaccount)
        and cf.custid = af.custid
        and af.acctno=dd.afacctno
        and dd.status <> 'C'
            and dd.isdefault = 'Y'
        and rownum = 1;
    exception
        when no_data_found then
          v_tlid:= null;
    end;

    select trflimit into v_trflimit from camast where camastid = p_camastid;
    select cdval into v_sendto from allcode where cdname='VSDNAME' and cdtype='CA' and cduser='Y' and rownum = 1;

    if p_trantype = 'S' THEN
        v_tltxcd := '3383';
        select nvl(calog.trade,0) - nvl(calog.intrade,0) ptrade, nvl(calog.blocked,0) - nvl(calog.inblocked,0) pblocked
        into v_ptrade, v_pblocked
        from caschd_log calog
        where calog.deltd = 'N'
        and replace(p_camastid,'.')=calog.camastid and calog.codeid = v_codeidbuy and calog.afacctno = v_afacctno;
    else
        v_tltxcd := '3303';
    end if;

    select sys_context ('USERENV', 'HOST'),
             sys_context ('USERENV', 'IP_ADDRESS', 15)
    into l_txmsg.wsname, l_txmsg.ipaddress
    from dual;

    begin
        select brid
        into l_txmsg.brid
        from tlprofiles where tlid = v_tlid;
    exception
        when no_data_found then
           l_txmsg.brid:= null;
    end;
    ------------------------
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txlogged;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := 'DAY';
    l_txmsg.txdate      := to_date(v_strcurrdate,systemnums.c_date_format);
    l_txmsg.busdate     := to_date(p_valuedate,systemnums.c_date_format);
    l_txmsg.tltxcd      := v_tltxcd;
    l_txmsg.nosubmit    := '1';
    l_txmsg.ovrrqd      := '@0';

    --------------------------SET CAC FIELD GIAO DICH-------------------------------
    ----SET TXNUM
    begin
        select l_txmsg.brid || lpad(seq_txnum.nextval, 6, '0')
        into l_txmsg.txnum
        from dual;
    exception
        when no_data_found then
             l_txmsg.txnum:= null;
    end;

    p_reftransid :='['|| to_char( l_txmsg.txdate,systemnums.c_date_format)  ||']['||l_txmsg.txnum||']';

        if v_tltxcd = '3383' then
            ----cifid---------------------
            l_txmsg.txfields('28').defname := 'CIFID';
            l_txmsg.txfields('28').type    := 'C';
            l_txmsg.txfields('28').value   := v_cifid;
            ----baldefavl---------------------
            l_txmsg.txfields('17').defname := 'BALDEFAVL';
            l_txmsg.txfields('17').type    := 'N';
            l_txmsg.txfields('17').value   := nvl(getbaldefavl(v_afacctno),0);
            ----acctno---------------------
            l_txmsg.txfields('03').defname := 'ACCTNO';
            l_txmsg.txfields('03').type    := 'C';
            l_txmsg.txfields('03').value   := v_afacctno || v_codeidbuy;
            ----tocusadd---------------------
            l_txmsg.txfields('85').defname := 'TOCUSADD';
            l_txmsg.txfields('85').type    := 'C';
            l_txmsg.txfields('85').value   := null;
            ----mamt---------------------
            l_txmsg.txfields('22').defname := 'MAMT';
            l_txmsg.txfields('22').type    := 'N';
            l_txmsg.txfields('22').value   := p_qttyen;
            ----ptrade
            l_txmsg.txfields('50').defname := 'PTRADE';
            l_txmsg.txfields('50').type    := 'N';
            l_txmsg.txfields('50').value   := v_ptrade;
            ----pblocked
            l_txmsg.txfields('52').defname := 'PBLOCKED';
            l_txmsg.txfields('52').type    := 'N';
            l_txmsg.txfields('52').value   := v_pblocked;
            ----ramt
            l_txmsg.txfields('23').defname := 'RAMT';
            l_txmsg.txfields('23').type    := 'N';
            l_txmsg.txfields('23').value   := p_remainqtty;
            ----tradeplace
            l_txmsg.txfields('37').defname := 'TRADEPLACE';
            l_txmsg.txfields('37').type    := 'C';
            l_txmsg.txfields('37').value   := v_tradeplace;
            ----sendto
            l_txmsg.txfields('41').defname := 'SENDTO';
            l_txmsg.txfields('41').type    := 'C';
            l_txmsg.txfields('41').value   := v_sendto;
            ----autoid
            l_txmsg.txfields('09').defname := 'AUTOID';
            l_txmsg.txfields('09').type    := 'C';
            l_txmsg.txfields('09').value   := p_autoid;
        else
            ----cifid---------------------
            l_txmsg.txfields('89').defname := 'CIFID';
            l_txmsg.txfields('89').type := 'C';
            l_txmsg.txfields('89').value := v_cifid;
        end if;

          ----camastid----------------------
        l_txmsg.txfields('06').defname := 'CAMASTID';
        l_txmsg.txfields('06').type    := 'C';
        l_txmsg.txfields('06').value   := p_camastid;
         ----custodycd
        l_txmsg.txfields('36').defname := 'CUSTODYCD';
        l_txmsg.txfields('36').type    := 'C';
        l_txmsg.txfields('36').value   := case when p_trantype = 'S'then p_sellaccount else p_buyaccount end;
        ----ddacctno
        l_txmsg.txfields('19').defname := 'DDACCTNO';
        l_txmsg.txfields('19').type    := 'C';
        l_txmsg.txfields('19').value   := v_ddacctno ;
           ----citad
        l_txmsg.txfields('27').defname := 'CITAD';
        l_txmsg.txfields('27').type    := 'C';
        l_txmsg.txfields('27').value   := p_citad;
          ----notransct
        l_txmsg.txfields('24').defname := 'NOTRANSCT';
        l_txmsg.txfields('24').type    := 'C';
        l_txmsg.txfields('24').value   := null;
          ----tosymbol
        l_txmsg.txfields('60').defname := 'TOSYMBOL';
        l_txmsg.txfields('60').type    := 'C';
        l_txmsg.txfields('60').value   := p_symbolbuy;
           ----toissname
        l_txmsg.txfields('61').defname := 'TOISSNAME';
        l_txmsg.txfields('61').type    := 'C';
        l_txmsg.txfields('61').value   := p_issnamebuy;
          ----tocodeid
        l_txmsg.txfields('62').defname := 'TOCODEID';
        l_txmsg.txfields('62').type    := 'C';
        l_txmsg.txfields('62').value   := p_symbolsell;
           ----issname
        l_txmsg.txfields('38').defname := 'ISSNAME';
        l_txmsg.txfields('38').type    := 'C';
        l_txmsg.txfields('38').value   := p_issnamesell;
           ----fromcusadd
        l_txmsg.txfields('25').defname := 'FROMCUSADD';
        l_txmsg.txfields('25').type    := 'C';
        l_txmsg.txfields('25').value   := p_fromcusadd;
          ----custname
        l_txmsg.txfields('90').defname := 'CUSTNAME';
        l_txmsg.txfields('90').type    := 'C';
        l_txmsg.txfields('90').value   := p_fullname;
          ----address
        l_txmsg.txfields('91').defname := 'ADDRESS';
        l_txmsg.txfields('91').type    := 'C';
        l_txmsg.txfields('91').value   := p_address;
          ----license
        l_txmsg.txfields('92').defname := 'LICENSE';
        l_txmsg.txfields('92').type    := 'C';
        l_txmsg.txfields('92').value   := p_licenesid;
          ----iddate
        l_txmsg.txfields('93').defname := 'IDDATE';
        l_txmsg.txfields('93').type    := 'D';
        l_txmsg.txfields('93').value   := to_date(p_issuedate,'DD/MM/RRRR');
          ----idplace
        l_txmsg.txfields('94').defname := 'IDPLACE';
        l_txmsg.txfields('94').type    := 'C';
        l_txmsg.txfields('94').value   := p_issueplace;
          ----country
        l_txmsg.txfields('80').defname := 'COUNTRY';
        l_txmsg.txfields('80').type    := 'C';
        l_txmsg.txfields('80').value   := p_country;
          ----toacctno
        l_txmsg.txfields('07').defname := 'TOACCTNO';
        l_txmsg.txfields('07').type    := 'C';
        l_txmsg.txfields('07').value   := case when p_trantype = 'S'then p_buyaccount  else p_sellaccount end;
          ----remoaccount
        l_txmsg.txfields('26').defname := 'REMOACCOUNT';
        l_txmsg.txfields('26').type    := 'C';
        l_txmsg.txfields('26').value   := p_remoaccount;
          ----citadp_remoaccount
        l_txmsg.txfields('27').defname := 'CITAD';
        l_txmsg.txfields('27').type    := 'C';
        l_txmsg.txfields('27').value   := p_citad;
          ----custname2
        l_txmsg.txfields('95').defname := 'CUSTNAME2';
        l_txmsg.txfields('95').type    := 'C';
        l_txmsg.txfields('95').value   := p_fullname2;
          ----address2
        l_txmsg.txfields('96').defname := 'ADDRESS2';
        l_txmsg.txfields('96').type    := 'C';
        l_txmsg.txfields('96').value   := p_address2;
          ----license2
        l_txmsg.txfields('97').defname := 'LICENSE2';
        l_txmsg.txfields('97').type    := 'C';
        l_txmsg.txfields('97').value   := p_licenesid2;
          ----iddate2
        l_txmsg.txfields('98').defname := 'IDDATE2';
        l_txmsg.txfields('98').type    := 'D';
        l_txmsg.txfields('98').value   := to_date(p_issuedate2,'DD/MM/RRRR');
          ----idplace2
        l_txmsg.txfields('99').defname := 'IDPLACE2';
        l_txmsg.txfields('99').type    := 'C';
        l_txmsg.txfields('99').value   := p_issueplace;
          ----country2
        l_txmsg.txfields('81').defname := 'COUNTRY2';
        l_txmsg.txfields('81').type    := 'C';
        l_txmsg.txfields('81').value   := p_country2;
          ----outptrade
        l_txmsg.txfields('51').defname := 'OUTPTRADE';
        l_txmsg.txfields('51').type    := 'N';
        l_txmsg.txfields('51').value   := p_outptrade;
          ----outpblocked
        l_txmsg.txfields('53').defname := 'OUTPBLOCKED';
        l_txmsg.txfields('53').type    := 'N';
        l_txmsg.txfields('53').value   := p_outpblocked;
          ----amt
        l_txmsg.txfields('21').defname := 'AMT';
        l_txmsg.txfields('21').type    := 'N';
        l_txmsg.txfields('21').value   := p_qttyex;
          ----$feecd
        l_txmsg.txfields('11').defname := '$FEECD';
        l_txmsg.txfields('11').type    := 'C';
        l_txmsg.txfields('11').value   := p_feecode;
          ----trflimit
        l_txmsg.txfields('31').defname := 'TRFLIMIT';
        l_txmsg.txfields('31').type    := 'C';
        l_txmsg.txfields('31').value   := v_trflimit;
          ----feeamt
        l_txmsg.txfields('12').defname := 'FEEAMT';
        l_txmsg.txfields('12').type    := 'N';
        l_txmsg.txfields('12').value   := p_feeamt;
          ----tranferprice
        l_txmsg.txfields('13').defname := 'TRANFERPRICE';
        l_txmsg.txfields('13').type    := 'N';
        l_txmsg.txfields('13').value   := p_transferprice;
          ----tranferamount
        l_txmsg.txfields('18').defname := 'TRANFERAMOUNT';
        l_txmsg.txfields('18').type    := 'N';
        l_txmsg.txfields('18').value   := p_transferamt;
          ----taxrate
        l_txmsg.txfields('14').defname := 'TAXRATE';
        l_txmsg.txfields('14').type    := 'N';
        l_txmsg.txfields('14').value   := p_taxrate;
          ----taxamt
        l_txmsg.txfields('15').defname := 'TAXAMT';
        l_txmsg.txfields('15').type    := 'N';
        l_txmsg.txfields('15').value   := p_taxamt;
          ----desc
        l_txmsg.txfields('30').defname := 'DESC';
        l_txmsg.txfields('30').type    := 'C';
        l_txmsg.txfields('30').value   := p_desc;

        v_xmlmsg_string :=txpks_msg.fn_obj2xml(l_txmsg);
        if v_tltxcd = '3383' then
            p_err_code:=txpks_#3383.fn_txprocess(v_xmlmsg_string, v_err_code, p_err_message);
            if p_err_code <>systemnums.c_success then
                plog.error(pkgctx,v_param || ' run ' || v_tltxcd || ' got ' || p_err_code || ':' || p_err_message);
                p_err_msg :=p_err_message;
                rollback;
                plog.setendsection(pkgctx, 'pr_auto_3383_3303_web');
                return;
            end if;
            pr_generate_otp('TRANS',p_reftransid, p_tlid, '', '','N', p_err_code, p_err_msg);
        else
            p_err_code:=txpks_#3303.fn_txprocess(v_xmlmsg_string, v_err_code, p_err_message);

            if p_err_code <>systemnums.c_success then
                plog.error(pkgctx,v_param || ' run ' || v_tltxcd || ' got ' || p_err_code || ':' ||p_err_message);
                p_err_msg :=p_err_message;
                rollback;
                plog.setendsection(pkgctx, 'pr_auto_3383_3303_web');
                return;
            end if;
            pr_generate_otp('TRANS',p_reftransid, p_tlid, '', '','N', p_err_code, p_err_msg);
        end if;
    plog.setendsection(pkgctx, 'pr_auto_3383_3303_web');
 exception
    when others then
        v_err_code := errnums.c_system_error;
        plog.error(pkgctx,
                   ' Err: ' || sqlerrm || ' Trace: ' ||
                   dbms_utility.format_error_backtrace);

        plog.setendsection(pkgctx, 'pr_auto_3383_3303_web');
        p_err_code   := v_err_code;
end;

-------cash_balance-----------------------
procedure prc_get_cash_balance_currency (p_refcursor in out pkg_report.ref_cursor,
                                         p_err_code  in out varchar2,
                                         p_err_msg   in out varchar2)
as
    v_param  varchar2(4000);
    begin

    plog.debug(pkgctx, 'prc_get_cash_balance_currency');
    v_param   := ' prc_get_cash_balance_currency'  ;

    p_err_code  := systemnums.c_success;
    p_err_msg   := 'success';

    open p_refcursor for
         select cdval,cdcontent,en_cdcontent
         from
             (select lstodr,cdval, cdcontent, en_cdcontent from allcode where cdname = 'CCYCD' and cdtype = 'FA'
              union all
              select 0 lstodr,'All' cdval, 'All' cdcontent,'All' en_cdcontent from dual)
         order by lstodr;
exception
    when others then
        p_err_code := errnums.c_system_error;
    plog.setendsection(pkgctx, 'prc_get_cash_balance_currency');
end prc_get_cash_balance_currency;

procedure prc_get_list_cash_balance(p_refcursor   in out pkg_report.ref_cursor,
                                    p_fundcode    in varchar2,
                                    p_currency    in varchar2,
                                    p_tlid        in varchar2,
                                    p_role        in varchar2,
                                    p_err_code    in out varchar2,
                                    p_err_msg     in out varchar2)
as
    v_param         varchar2(4000);
    v_custodycd     varchar2(20);
    v_listcustodycd varchar2(200);
    v_role          varchar2(10);
begin

    plog.debug(pkgctx, 'prc_get_list_cash_balance');
    v_param   :=' prc_get_list_cash_balance: p_fundcode' || p_fundcode||' p_currency '||p_currency;

    p_err_code  := systemnums.c_success;
    p_err_msg   := 'SUCCESS';

    begin
        select custodycd,listcustodycd,role
        into v_custodycd,v_listcustodycd,v_role
        from userlogin
        where username = p_tlid;
    exception
        when others then
             v_custodycd := '';
             v_listcustodycd:='';
             v_role:='';
    end;
    open p_refcursor for
        select cf.fundcode,cf.custodycd, cf.fullname, dd.acctno, dd.ccycd,a1.en_cdcontent ccycd_cnt,
               dd.balance + dd.holdbalance+dd.pendinghold+dd.pendingunhold totalamt,
               dd.balance, dd.holdbalance,
               case when dd.ccycd = 'VND' then 1 else nvl(ex.rate,0) end exrate,
               case when dd.ccycd = 'VND' then dd.balance + dd.holdbalance+dd.pendinghold+dd.pendingunhold
                    else nvl(ex.rate,0)*(dd.balance + dd.holdbalance+dd.pendinghold+dd.pendingunhold) end totalamt_vnd
        from ddmast dd,afmast af, cfmast cf, allcode a1,
             (select currency, max(vnd) rate from exchangerate where rtype = 'TTM' and itype = 'SHV' group by currency) ex
        where cf.custid = af.custid and af.acctno = dd.afacctno
            and dd.ccycd = ex.currency(+)
            and a1.cdname = 'CCYCD'
            and a1.cdtype = 'FA'
            and a1.cdval = dd.ccycd
            and (instr(v_listcustodycd, dd.custodycd) >0 or dd.custodycd =v_custodycd);

    plog.setendsection(pkgctx, 'prc_get_list_cash_balance');
exception
    when others then
         p_err_code := errnums.c_system_error;
         plog.error(pkgctx,'p_cdtype: ' || ' Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
         plog.setendsection(pkgctx, 'prc_get_list_cash_balance');
end prc_get_list_cash_balance;

------------------securities_balance---------------------
procedure prc_get_list_securities_balance(p_refcursor   in out pkg_report.ref_cursor,
                                          p_fundcode    in varchar2,
                                          p_stocktype   in varchar2,
                                          p_stockcode   in varchar2,
                                          p_tlid        in varchar2,
                                          p_role        in varchar2,
                                          p_err_code    in out varchar2,
                                          p_err_msg     in out varchar2)
as
    v_param         varchar2(4000);
    v_custodycd     varchar2(20);
    v_listcustodycd varchar2(200);
    v_role          varchar2(10);
begin

    plog.debug(pkgctx, 'prc_get_list_securities_balance');
    v_param   :=' prc_get_list_securities_balance: p_fundcode' || p_fundcode||' p_stocktype '||p_stocktype;

    p_err_code  := systemnums.c_success;
    p_err_msg   := 'SUCCESS';

    begin
        select custodycd,listcustodycd,role
        into v_custodycd,v_listcustodycd,v_role
        from userlogin
        where username = p_tlid;
    exception
        when others then
             v_custodycd := '';
             v_listcustodycd:='';
             v_role:='';
    end;
    open p_refcursor for
        select cf.fundcode,cf.custodycd ,sym.sectype, a1.en_cdcontent sectype_cnt,sym.symbol,
               se.trade + se.mortage + se.margin + se.netting + se.standing + se.withdraw + se.deposit + se.transfer + se.loan + se.blocked + se.receiving  total,
               se.trade available,
               se.mortage , se.hold , se.receiving,se.netting wft, 0 stock,
               nvl(st.securities_receiving_t1,0) receiving1,nvl(st.securities_receiving_t2,0) receiving2
        from semast se,sbsecurities sym, allcode a1,afmast af, cfmast cf,
             (select st.afacctno, st.codeid,
                     sum(case when st.duetype='RS' and st.nday=1 then st.st_qtty-st.st_aqtty else 0 end) securities_receiving_t1,
                     sum(case when st.duetype='RS' and st.nday=2 then st.st_qtty-st.st_aqtty else 0 end) securities_receiving_t2
              from vw_bd_pending_settlement st
              where duetype='RS'
              group by st.afacctno, st.codeid) st
        where a1.cdtype = 'SA' and a1.cdname = 'SECTYPE' and a1.cdval = sym.sectype
             and sym.codeid = se.codeid
             and af.acctno = se.afacctno
             and af.status not in ('C')
             and cf.custid = af.custid
             and (se.trade + se.mortage + se.margin + se.netting + se.standing + se.withdraw + se.deposit + se.transfer + se.loan + se.blocked + se.receiving) > 0
             and se.afacctno = st.afacctno (+) and se.codeid=st.codeid (+)
             and (instr(v_listcustodycd, cf.custodycd) >0 or cf.custodycd =v_custodycd);


    plog.setendsection(pkgctx, 'prc_get_list_securities_balance');
exception
    when others then
         p_err_code := errnums.c_system_error;
         plog.error(pkgctx,'p_cdtype: ' || ' Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
         plog.setendsection(pkgctx, 'prc_get_list_securities_balance');
end prc_get_list_securities_balance;

------------------Tra cuu CA-------------------
procedure prc_get_ca_catype (p_refcursor in out pkg_report.ref_cursor,
                             p_err_code  in out varchar2,
                             p_err_msg   in out varchar2)
as
    v_param  varchar2(4000);
    begin

    plog.debug(pkgctx, 'prc_get_ca_catype');
    v_param   := ' prc_get_ca_catype'  ;

    p_err_code  := systemnums.c_success;
    p_err_msg   := 'success';

    open p_refcursor for
         select cdval,cdcontent,en_cdcontent
         from
             (select lstodr,cdval, cdcontent, en_cdcontent from allcode
              where cdname = 'CATYPE' and cdtype = 'CA' and cduser='Y'
              union all
              select 0 lstodr,'All' cdval, 'All' cdcontent,'All' en_cdcontent from dual)
         order by lstodr;
exception
    when others then
        p_err_code := errnums.c_system_error;
    plog.setendsection(pkgctx, 'prc_get_ca_catype');
end prc_get_ca_catype;

procedure prc_get_ca_status (p_refcursor in out pkg_report.ref_cursor,
                             p_err_code  in out varchar2,
                             p_err_msg   in out varchar2)
as
    v_param  varchar2(4000);
    begin

    plog.debug(pkgctx, 'prc_get_ca_status');
    v_param   := ' prc_get_ca_status'  ;

    p_err_code  := systemnums.c_success;
    p_err_msg   := 'success';

    open p_refcursor for
         select cdval,cdcontent,en_cdcontent
         from
             (select lstodr,cdval, cdcontent, en_cdcontent from allcode
              where cdtype = 'CA' and cdname = 'CASTATUS'
              union all
              select 0 lstodr,'All' cdval, 'All' cdcontent,'All' en_cdcontent from dual)
         order by lstodr;
exception
    when others then
        p_err_code := errnums.c_system_error;
    plog.setendsection(pkgctx, 'prc_get_ca_status');
end prc_get_ca_status;

procedure prc_get_list_ca(p_refcursor   in out pkg_report.ref_cursor,
                          p_fundcode    in varchar2,
                          p_stockcode   in varchar2,
                          p_catype      in varchar2,
                          p_castatus    in varchar2,
                          p_fromdate    in varchar2,
                          p_todate      in varchar2,
                          p_tlid        in varchar2,
                          p_role        in varchar2,
                          p_err_code    in out varchar2,
                          p_err_msg     in out varchar2)
as
    v_param         varchar2(4000);
    v_custodycd     varchar2(20);
    v_listcustodycd varchar2(200);
    v_role          varchar2(10);
begin

    plog.debug(pkgctx, 'prc_get_list_ca');
    v_param   :=' prc_get_list_ca: p_fundcode' || p_fundcode||' p_catype '||p_catype;

    p_err_code  := systemnums.c_success;
    p_err_msg   := 'SUCCESS';

    begin
        select custodycd,listcustodycd,role
        into v_custodycd,v_listcustodycd,v_role
        from userlogin
        where username = p_tlid;
    exception
        when others then
             v_custodycd := '';
             v_listcustodycd:='';
             v_role:='';
    end;
    open p_refcursor for
        select cf.fundcode, sb.symbol, ca.catype, a1.en_cdcontent catype_cnt, ca.reportdate,
            ca.reportdate - 1 ex_date,ca.actiondate ,
            substr(ca.camastid,1,4) || '.'||substr(ca.camastid,5,6) ||'.' ||substr(ca.camastid,11,6) camastid,
            CASE WHEN CA.CATYPE = '014' THEN chd.TRADE ELSE chd.BALANCE end enqtty, ca.exrate exrate1,
            CASE WHEN CA.CATYPE IN ('014','023') THEN chd.pqtty ELSE chd.qtty end  qttyofright,
            chd.AMT cashamt,rightoffrate exrate2,exprice,
            chd.qtty stockqtty, a2.en_cdcontent status_cnt,ca.status
        from camast ca, cfmast cf,afmast af ,caschd chd, sbsecurities sb, allcode a1,allcode a2
        where chd.afacctno = af.acctno
        and af.custid = cf.custid
        and ca.camastid = chd.camastid
        and sb.codeid = ca.codeid
        and a1.cdtype = 'CA'
        and a1.cdname = 'CATYPE'
        and a1.cdval = ca.catype
        and a2.cdtype = 'CA'
        and a2.cdname = 'CASTATUS'
        and a2.cdval = ca.status
        and (instr(v_listcustodycd, cf.custodycd) >0 or cf.custodycd =v_custodycd);

    plog.setendsection(pkgctx, 'prc_get_list_ca');
exception
    when others then
         p_err_code := errnums.c_system_error;
         plog.error(pkgctx,'p_cdtype: ' || ' Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
         plog.setendsection(pkgctx, 'prc_get_list_ca');
end prc_get_list_ca;

procedure pr_auto_3384_web(
    p_camastid       varchar2,
    p_custodycd      varchar2,
    p_qtty           number,
    p_valuedate      varchar2,
    p_tlid           varchar2,
    p_reftransid     out varchar2,
    p_err_code       in out varchar2,
    p_err_msg        in out varchar2
 ) is
    l_txmsg          tx.msg_rectype;
    v_strcurrdate    varchar2(20);
    v_strdesc        varchar2(1000);
    v_stren_desc     varchar2(1000);
    v_tltxcd         varchar2(10);
    p_xmlmsg         varchar2(4000);
    v_param          varchar2(1000);
    v_err_code       varchar2(10);
    p_err_message    varchar2(500);
    l_txnum          varchar2(20);
    v_tlid           varchar2(5);
    v_xmlmsg_string  varchar2(5000);
BEGIN
    v_err_code    := systemnums.c_success;
    p_err_message := 'success';
    plog.setbeginsection (pkgctx, 'pr_auto_3384_web');

    p_reftransid :='';

    select to_date (varvalue, systemnums.c_date_format)
    into v_strcurrdate
    from sysvar
    where grname = 'SYSTEM' and varname = 'CURRDATE';

    l_txmsg.msgtype     :='T';
    l_txmsg.local       :='N';
    l_txmsg.tlid        :='6868';

    begin
        select tlid into v_tlid from cfmast where custodycd = p_custodycd;
    exception
        when no_data_found then
             v_tlid:= null;
    end;

    select sys_context ('USERENV', 'HOST'),
             sys_context ('USERENV', 'IP_ADDRESS', 15)
    into l_txmsg.wsname, l_txmsg.ipaddress
    from dual;

    begin
        select brid
        into l_txmsg.brid
        from tlprofiles where tlid = v_tlid;
    exception
        when no_data_found then
           l_txmsg.brid:= null;
    end;
    ------------------------
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txlogged;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := 'DAY';
    l_txmsg.txdate      := to_date(v_strcurrdate,systemnums.c_date_format);
    l_txmsg.busdate     := to_date(p_valuedate,systemnums.c_date_format);
    l_txmsg.tltxcd      := '3384';
    l_txmsg.nosubmit    := '1';
    l_txmsg.ovrrqd      := '@0';

    --------------------------SET CAC FIELD GIAO DICH-------------------------------
    ----SET TXNUM
    begin
        select l_txmsg.brid || lpad(seq_txnum.nextval, 6, '0')
        into l_txmsg.txnum
        from dual;
    exception
        when no_data_found then
             l_txmsg.txnum:= null;
    end;

    p_reftransid :='['|| to_char( l_txmsg.txdate,systemnums.c_date_format)  ||']['||l_txmsg.txnum||']';
    for rec in
    (
        SELECT V.ABC, V.AUTOID,V.CUSTODYCD,CF.CIFID, V.FULLNAME, V.AFACCTNO, V.AFACCTNO TRFACCTNO, REPLACE(V.CAMASTID,'.','') CAMASTID, V.SYMBOL,
        V.CODEID,V.TRADE,V.MAXBALANCE,V.BALANCE, V.PBALANCE,V.INBALANCE,V.OUTBALANCE, V.QTTY, V.MAXQTTY, V.AVLQTTY, V.SUQTTY BUYQTTY, V.CUSTNAME, V.IDCODE,
        V.IDPLACE, V.ADDRESS,V.IDDATE, V.AAMT, V.OPTCODEID, V.OPTSYMBOL, V.ISCOREBANK,
        V.COREBANK, A1.CDCONTENT STATUS, V.SEACCTNO, V.OPTSEACCTNO,V.ISSNAME,
        V.PARVALUE, V.REPORTDATE, V.ACTIONDATE, V.EXPRICE,
        V.EN_DESCRIPTION, V.DESCRIPTION, A2.CDCONTENT CATYPE, V.BALDEFOVD CIBALANCE,V.PHONE, V.BANKACCTNO, V.BANKNAME,V.SYMBOL_ORG , V.ISINCODE,GRP.GRPID, GRP.GRPNAME CAREBY
        FROM VW_STRADE_CA_RIGHTOFF_3384 V, TLGROUPS GRP, ALLCODE A1,  ALLCODE A2, CFMAST CF
        WHERE V.CAREBY = GRP.GRPID
        AND A1.CDTYPE = 'CA' AND A1.CDNAME = 'CASTATUS'
        AND A2.CDTYPE = 'CA' AND A2.CDNAME = 'CATYPE'
        AND A1.CDVAL = V.STATUS
        AND V.CATYPE = A2.CDVAL
        AND CF.CUSTODYCD = V.CUSTODYCD
        AND V.CAMASTID = P_CAMASTID
        AND CF.CUSTODYCD = P_CUSTODYCD
    )
    loop
        ----AUTOID---------------------
        l_txmsg.txfields('01').defname := 'AUTOID';
        l_txmsg.txfields('01').type    := 'C';
        l_txmsg.txfields('01').value   := REC.AUTOID;
        ----CAMASTID---------------------
        l_txmsg.txfields('02').defname := 'CAMASTID';
        l_txmsg.txfields('02').type    := 'C';
        l_txmsg.txfields('02').value   := P_CAMASTID;
        ----AFACCTNO---------------------
        l_txmsg.txfields('03').defname := 'AFACCTNO';
        l_txmsg.txfields('03').type    := 'C';
        l_txmsg.txfields('03').value   := REC.AFACCTNO;
        ----SYMBOL
        l_txmsg.txfields('04').defname := 'SYMBOL';
        l_txmsg.txfields('04').type    := 'C';
        l_txmsg.txfields('04').value   := REC.SYMBOL;
        ----EXPRICE
        l_txmsg.txfields('05').defname := 'EXPRICE';
        l_txmsg.txfields('05').type    := 'N';
        l_txmsg.txfields('05').value   := REC.EXPRICE;
        ----SEACCTNO
        l_txmsg.txfields('06').defname := 'SEACCTNO';
        l_txmsg.txfields('06').type    := 'C';
        l_txmsg.txfields('06').value   := REC.SEACCTNO;
        ----BALANCE----------------------
        l_txmsg.txfields('07').defname := 'BALANCE';
        l_txmsg.txfields('07').type    := 'N';
        l_txmsg.txfields('07').value   := REC.MAXBALANCE;
        ----FULLNAME
        l_txmsg.txfields('08').defname := 'FULLNAME';
        l_txmsg.txfields('08').type    := 'C';
        l_txmsg.txfields('08').value   := REC.FULLNAME;
        ----OPTSEACCTNO
        l_txmsg.txfields('09').defname := 'OPTSEACCTNO';
        l_txmsg.txfields('09').type    := 'C';
        l_txmsg.txfields('09').value   := REC.OPTSEACCTNO;
        ----AMT
        l_txmsg.txfields('10').defname := 'AMT';
        l_txmsg.txfields('10').type    := 'N';
        l_txmsg.txfields('10').value   := FN_GET_AMT_3384(P_CAMASTID, p_qtty, REC.EXPRICE);
        ----TASKCD
        l_txmsg.txfields('16').defname := 'TASKCD';
        l_txmsg.txfields('16').type    := 'C';
        l_txmsg.txfields('16').value   := null;
        ----MAXQTTY
        l_txmsg.txfields('20').defname := 'MAXQTTY';
        l_txmsg.txfields('20').type    := 'N';
        l_txmsg.txfields('20').value   := REC.MAXQTTY ;
        ----QTTY
        l_txmsg.txfields('21').defname := 'QTTY';
        l_txmsg.txfields('21').type    := 'N';
        l_txmsg.txfields('21').value   := FN_GET_QTTY_3384(P_CAMASTID, p_qtty);
        ----PARVALUE
        l_txmsg.txfields('22').defname := 'PARVALUE';
        l_txmsg.txfields('22').type    := 'N';
        l_txmsg.txfields('22').value   := REC.PARVALUE;
        ----REPORTDATE
        l_txmsg.txfields('23').defname := 'REPORTDATE';
        l_txmsg.txfields('23').type    := 'D';
        l_txmsg.txfields('23').value   := REC.REPORTDATE;
        ----CODEID
        l_txmsg.txfields('24').defname := 'CODEID';
        l_txmsg.txfields('24').type    := 'C';
        l_txmsg.txfields('24').value   := REC.CODEID;
        ----AVLQTTY
        l_txmsg.txfields('25').defname := 'AVLQTTY';
        l_txmsg.txfields('25').type    := 'N';
        l_txmsg.txfields('25').value   := REC.AVLQTTY;
        ----BUYQTTY
        l_txmsg.txfields('26').defname := 'BUYQTTY';
        l_txmsg.txfields('26').type    := 'N';
        l_txmsg.txfields('26').value   := REC.BUYQTTY;
        ----DESCRIPTION
        l_txmsg.txfields('30').defname := 'DESCRIPTION';
        l_txmsg.txfields('30').type    := 'C';
        l_txmsg.txfields('30').value   :=  REC.DESCRIPTION;
        ----DDACCTNO
        l_txmsg.txfields('31').defname := 'DDACCTNO';
        l_txmsg.txfields('31').type    := 'C';
        l_txmsg.txfields('31').value   := REC.TRFACCTNO;
        ----STATUS
        l_txmsg.txfields('40').defname := 'STATUS';
        l_txmsg.txfields('40').type    := 'C';
        l_txmsg.txfields('40').value   := 'M';
        ----ISCOREBANK
        l_txmsg.txfields('60').defname := 'ISCOREBANK';
        l_txmsg.txfields('60').type    := 'C';
        l_txmsg.txfields('60').value   := REC.ISCOREBANK;
        ----PHONE
        l_txmsg.txfields('70').defname := 'PHONE';
        l_txmsg.txfields('70').type    := 'C';
        l_txmsg.txfields('70').value   := REC.PHONE;
        ----SYMBOL_ORG
        l_txmsg.txfields('71').defname := 'SYMBOL_ORG';
        l_txmsg.txfields('71').type    := 'C';
        l_txmsg.txfields('71').value   := REC.SYMBOL_ORG;
        ----BALANCE
        l_txmsg.txfields('80').defname := 'BALANCE';
        l_txmsg.txfields('80').type    := 'N';
        l_txmsg.txfields('80').value   := REC.BALANCE;
        ----CAQTTY
        l_txmsg.txfields('81').defname := 'BUYQTTY';
        l_txmsg.txfields('81').type    := 'N';
        l_txmsg.txfields('81').value   := p_qtty;
        ----CUSTNAME
        l_txmsg.txfields('90').defname := 'CUSTNAME';
        l_txmsg.txfields('90').type    := 'C';
        l_txmsg.txfields('90').value   := REC.CUSTNAME;
        ----ADDRESS
        l_txmsg.txfields('91').defname := 'ADDRESS';
        l_txmsg.txfields('91').type    := 'C';
        l_txmsg.txfields('91').value   := REC.ADDRESS;
          ----LICENSE
        l_txmsg.txfields('92').defname := 'LICENSE';
        l_txmsg.txfields('92').type    := 'C';
        l_txmsg.txfields('92').value   := REC.IDCODE;
          ----IDDATE
        l_txmsg.txfields('93').defname := 'IDDATE';
        l_txmsg.txfields('93').type    := 'D';
        l_txmsg.txfields('93').value   := REC.IDDATE;
        ----IDPLACE
        l_txmsg.txfields('94').defname := 'IDPLACE';
        l_txmsg.txfields('94').type    := 'C';
        l_txmsg.txfields('94').value   := REC.IDPLACE;
        ----ISSNAME
        l_txmsg.txfields('95').defname := 'ISSNAME';
        l_txmsg.txfields('95').type    := 'C';
        l_txmsg.txfields('95').value   := REC.ISSNAME;
        ----CUSTODYCD---------------------
        l_txmsg.txfields('96').defname := 'CUSTODYCD';
        l_txmsg.txfields('96').type    := 'C';
        l_txmsg.txfields('96').value   := REC.CUSTODYCD;
        ----CIFID---------------------
        l_txmsg.txfields('97').defname := 'CIFID';
        l_txmsg.txfields('97').type    := 'C';
        l_txmsg.txfields('97').value   := REC.CIFID;


        v_xmlmsg_string :=txpks_msg.fn_obj2xml(l_txmsg);
        p_err_code := txpks_#3384.fn_txprocess(v_xmlmsg_string, v_err_code, p_err_message);
        if p_err_code <>systemnums.c_success then
             plog.error(pkgctx,v_param || ' run ' || v_tltxcd || ' got ' || p_err_code || ':' || p_err_message);
             p_err_msg :=p_err_message;
             rollback;
             plog.setendsection(pkgctx, 'pr_auto_3384_web');
             return;
        end if;
        pr_generate_otp('TRANS',p_reftransid, p_tlid, '', '','N', p_err_code, p_err_msg);
    end loop;
    plog.setendsection(pkgctx, 'pr_auto_3384_web');

 exception
    when others then
        v_err_code := errnums.c_system_error;
        plog.error(pkgctx,
                   ' Err: ' || sqlerrm || ' Trace: ' ||
                   dbms_utility.format_error_backtrace);

        plog.setendsection(pkgctx, 'pr_auto_3384_web');
        p_err_code   := v_err_code;
end;

procedure prc_get_list_regis_right_sub(p_refcursor   in out pkg_report.ref_cursor,
                                       p_fundsymbol  in varchar2,
                                       p_valuedate   in varchar2,
                                       p_camastid    in varchar2,
                                       p_tlid        in varchar2,
                                       p_role        in varchar2,
                                       p_err_code    in out varchar2,
                                       p_err_msg     in out varchar2)
as
    v_param         varchar2(4000);
    v_custodycd     varchar2(20);
    v_listcustodycd varchar2(4000);
    v_role          varchar2(10);
begin

    plog.debug(pkgctx, 'prc_get_list_regis_right_sub');
    v_param   :=' prc_get_list_regis_right_sub: fundsymbol' || p_fundsymbol||' p_valuedate '||p_valuedate||' camastid '||p_camastid;

    p_err_code  := systemnums.c_success;
    p_err_msg   := 'SUCCESS';

    begin
        select custodycd,listcustodycd,role
        into v_custodycd,v_listcustodycd,v_role
        from userlogin
        where username = p_tlid;
    exception
        when others then
             v_custodycd := '';
             v_listcustodycd:='';
             v_role:='';
    end;

    open p_refcursor for
        SELECT V.ABC, V.AUTOID, V.CUSTODYCD, CF.CIFID, V.FULLNAME, V.AFACCTNO, V.AFACCTNO TRFACCTNO, V.CAMASTID, V.SYMBOL,
        V.CODEID, V.TRADE, V.MAXBALANCE, V.BALANCE, V.PBALANCE, V.INBALANCE, V.OUTBALANCE, V.QTTY, V.MAXQTTY, V.AVLQTTY, V.SUQTTY BUYQTTY, V.CUSTNAME, V.IDCODE,
        V.IDPLACE, V.ADDRESS, V.IDDATE, V.AAMT, V.OPTCODEID, V.OPTSYMBOL, V.ISCOREBANK,
        V.COREBANK, A1.CDCONTENT STATUS, V.SEACCTNO, V.OPTSEACCTNO, V.ISSNAME,
        V.PARVALUE, V.REPORTDATE, V.ACTIONDATE, V.EXPRICE, RIGHTOFFRATE,
        V.EN_DESCRIPTION, V.DESCRIPTION, A2.CDCONTENT CATYPE, V.BALDEFOVD CIBALANCE, V.PHONE, V.BANKACCTNO, V.BANKNAME, V.SYMBOL_ORG, V.ISINCODE, GRP.GRPID, GRP.GRPNAME CAREBY
        FROM VW_STRADE_CA_RIGHTOFF_3384 V, TLGROUPS GRP, ALLCODE A1,  ALLCODE A2, CFMAST CF
        WHERE V.CAREBY = GRP.GRPID
        AND A1.CDTYPE = 'CA' AND A1.CDNAME = 'CASTATUS'
        AND A2.CDTYPE = 'CA' AND A2.CDNAME = 'CATYPE'
        AND A1.CDVAL = V.STATUS
        AND V.CATYPE = A2.CDVAL
        AND CF.CUSTODYCD = V.CUSTODYCD
        AND V.SYMBOL LIKE  NVL(P_FUNDSYMBOL,'%%')
        AND REPLACE(V.CAMASTID,'.','') LIKE NVL(P_CAMASTID,'%%')
        AND (INSTR(V_LISTCUSTODYCD, CF.CUSTODYCD) >0 OR CF.CUSTODYCD = V_CUSTODYCD);

        /*select a1.en_cdcontent txstatus_cnt, tl.txstatus, tl.txnum, tl.txdate,
            tl.tltxcd ||' - '|| gd.en_txdesc tranname, fa.symbol fundcode, tl.busdate,
            substr(fld.camastid,1,4) || '.'||substr(fld.camastid,5,6) ||'.' ||substr(fld.camastid,11,6) camastid,
            fld.refsymbol, fld.qtty_en, ca.rightoffrate exrate,
            fld.qtty_ex, fld.qtty, fld.subprice, fld.subamt, tl.txdesc
        from tllog tl,tltx gd,allcode a1,cbfafund fa,camast ca,
            (select txnum,txdate,
                 max(case when fldcd = '25' then nvalue else null end) qtty_en,
                 max(case when fldcd = '26' then nvalue else null end) qtty_ex,
                 max(case when fldcd = '21' then nvalue else null end) qtty,
                 max(case when fldcd = '22' then nvalue else null end) subprice,
                 max(case when fldcd = '10' then nvalue else null end) subamt,
                 max(case when fldcd = '96' then cvalue else null end) custodycd,
                 max(case when fldcd = '02' then cvalue else null end) camastid,
                 max(case when fldcd = '71' then cvalue else null end) refsymbol
             from tllogfld
             where fldcd in ('25','26','21','22','10','96','02','71')
             group by txnum,txdate) fld
        where tl.tltxcd in ('3384') and tl.txstatus <> '0'
        and a1.cdname='TXSTATUS' and a1.cdtype='SY' and a1.cdval = tl.txstatus
        and tl.tltxcd = gd.tltxcd
        and tl.txnum = fld.txnum and tl.txdate = fld.txdate
        and fld.custodycd = fa.custodycd
        and fld.camastid = ca.camastid
        and (instr(v_listcustodycd, fld.custodycd) >0 or fld.custodycd =v_custodycd)
        and fa.symbol like  nvl(p_fundsymbol,'%%')
        and tl.busdate like nvl(p_valuedate,'%%')
        and fld.camastid like nvl(p_camastid,'%%')
        order by tl.txdate desc, tl.txnum desc;*/

    plog.setendsection(pkgctx, 'prc_get_list_regis_right_sub');
exception
    when others then
         p_err_code := errnums.c_system_error;
         plog.error(pkgctx,'p_cdtype: ' || ' Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
         plog.setendsection(pkgctx, 'prc_get_list_regis_right_sub');
end prc_get_list_regis_right_sub;


procedure prc_get_list_regis_bond_convert(p_refcursor   in out pkg_report.ref_cursor,
                                          p_fundsymbol  in varchar2,
                                          p_valuedate   in varchar2,
                                          p_camastid    in varchar2,
                                          p_tlid        in varchar2,
                                          p_role        in varchar2,
                                          p_err_code    in out varchar2,
                                          p_err_msg     in out varchar2)
as
    v_param         varchar2(4000);
    v_custodycd     varchar2(20);
    v_listcustodycd varchar2(200);
    v_role          varchar2(10);
begin

    plog.debug(pkgctx, 'prc_get_list_regis_bond_convert');
    v_param   :=' prc_get_list_regis_bond_convert: fundsymbol' || p_fundsymbol||' p_valuedate '||p_valuedate||' camastid '||p_camastid;

    p_err_code  := systemnums.c_success;
    p_err_msg   := 'SUCCESS';

    begin
        select custodycd,listcustodycd,role
        into v_custodycd,v_listcustodycd,v_role
        from userlogin
        where username = p_tlid;
    exception
        when others then
             v_custodycd := '';
             v_listcustodycd:='';
             v_role:='';
    end;

    open p_refcursor for
        select a1.en_cdcontent txstatus_cnt, tl.txstatus, tl.txnum, tl.txdate,tl.txdesc,
            tl.tltxcd ||' - '|| gd.en_txdesc tranname, fa.symbol fundcode, tl.busdate,
            substr(fld.camastid,1,4) || '.'||substr(fld.camastid,5,6) ||'.' ||substr(fld.camastid,11,6) camastid,
            fld.bondsymbol, fld.sharesymbol, fld.bondqtty, fld.shareqtty
        from tllog tl,tltx gd,allcode a1,cbfafund fa,
            (select txnum,txdate,
                 max(case when fldcd = '02' then cvalue else null end) camastid,
                 max(case when fldcd = '96' then cvalue else null end) custodycd,
                 max(case when fldcd = '04' then cvalue else null end) bondsymbol,
                 max(case when fldcd = '05' then cvalue else null end) sharesymbol,
                 max(case when fldcd = '09' then nvalue else null end) bondqtty,
                 max(case when fldcd = '10' then nvalue else null end) shareqtty
             from tllogfld
             where fldcd in ('02','96','04','05','09','10')
             group by txnum,txdate) fld
        where tl.tltxcd in ('3327') and tl.txstatus <> '0'
        and a1.cdname='TXSTATUS' and a1.cdtype='SY' and a1.cdval = tl.txstatus
        and tl.tltxcd = gd.tltxcd
        and tl.txnum = fld.txnum and tl.txdate = fld.txdate
        and fld.custodycd = fa.custodycd
        and (instr(v_listcustodycd, fld.custodycd) >0 or fld.custodycd =v_custodycd)
        and fa.symbol like  nvl(p_fundsymbol,'%%')
        and tl.busdate like nvl(p_valuedate,'%%')
        and fld.camastid like nvl(p_camastid,'%%')
        order by tl.txdate desc, tl.txnum desc;

    plog.setendsection(pkgctx, 'prc_get_list_regis_bond_convert');
exception
    when others then
         p_err_code := errnums.c_system_error;
         plog.error(pkgctx,'p_cdtype: ' || ' Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
         plog.setendsection(pkgctx, 'prc_get_list_regis_bond_convert');
end prc_get_list_regis_bond_convert;

procedure pr_auto_3333_web(
    p_fundcode       varchar2,
    p_valuedate      varchar2,
    p_custodycd      varchar2,
    p_camastid       varchar2,
    p_symbol         varchar2,
    p_symbolname     varchar2,
    p_qtty_en        number,
    p_reportdate     varchar2,
    p_exrate         varchar2,
    p_maxqtty        number,
    p_qtty           number,
    p_remainqtty     number,
    p_subprice       number,
    p_desc           varchar2,
    p_tlid           varchar2,
    p_reftransid     out varchar2,
    p_err_code       in out varchar2,
    p_err_msg        in out varchar2
 ) is
    l_txmsg          tx.msg_rectype;
    v_strcurrdate    varchar2(20);
    v_strdesc        varchar2(1000);
    v_stren_desc     varchar2(1000);
    v_tltxcd         varchar2(10);
    p_xmlmsg         varchar2(4000);
    v_param          varchar2(1000);
    v_err_code       varchar2(10);
    p_err_message    varchar2(500);
    l_txnum          varchar2(20);
    v_tlid           varchar2(5);
    v_xmlmsg_string  varchar2(5000);
BEGIN
    v_err_code    := systemnums.c_success;
    p_err_message := 'success';
    plog.setbeginsection (pkgctx, 'pr_auto_3333_web');

    p_reftransid :='';

    select to_date (varvalue, systemnums.c_date_format)
    into v_strcurrdate
    from sysvar
    where grname = 'SYSTEM' and varname = 'CURRDATE';

    l_txmsg.msgtype     :='T';
    l_txmsg.local       :='N';
    l_txmsg.tlid        :='6868';

    begin
        select tlid into v_tlid from cfmast where custodycd = p_custodycd;
    exception
        when no_data_found then
             v_tlid:= null;
    end;

    select sys_context ('USERENV', 'HOST'),
             sys_context ('USERENV', 'IP_ADDRESS', 15)
    into l_txmsg.wsname, l_txmsg.ipaddress
    from dual;

    begin
        select brid
        into l_txmsg.brid
        from tlprofiles where tlid = v_tlid;
    exception
        when no_data_found then
           l_txmsg.brid:= null;
    end;
    ------------------------
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txlogged;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := 'DAY';
    l_txmsg.txdate      := to_date(v_strcurrdate,systemnums.c_date_format);
    l_txmsg.busdate     := to_date(p_valuedate,systemnums.c_date_format);
    l_txmsg.tltxcd      := '3333';
    l_txmsg.nosubmit    := '1';
    l_txmsg.ovrrqd      := '@0';

    --------------------------SET CAC FIELD GIAO DICH-------------------------------
    ----SET TXNUM
    begin
        select l_txmsg.brid || lpad(seq_txnum.nextval, 6, '0')
        into l_txmsg.txnum
        from dual;
    exception
        when no_data_found then
             l_txmsg.txnum:= null;
    end;

    p_reftransid :='['|| to_char( l_txmsg.txdate,systemnums.c_date_format)  ||']['||l_txmsg.txnum||']';
    for rec in
    (
        select sym_org.symbol symbol_org,sym.symbol,optsym.symbol optsymbol,
             cf.custodycd, cf.cifid, cf.fullname, schd.trade,schd.qttycancel
        from camast ca, caschd schd,cfmast cf, afmast af,
             sbsecurities sym, sbsecurities optsym, sbsecurities sym_org
        where ca.camastid=schd.camastid
        and schd.afacctno=af.acctno and af.custid=cf.custid
        and schd.status in( 'V','M')
        and schd.pbalance > 0 and schd.pqtty > 0
        and schd.deltd='N'
        and nvl(ca.tocodeid,ca.codeid) = sym.codeid
        and ca.optcodeid = optsym.codeid
        and sym_org.codeid = ca.codeid
        and ca.camastid = p_camastid
        and cf.custodycd = p_custodycd
    )
    loop
        ----CAMASTID---------------------
        l_txmsg.txfields('02').defname := 'CAMASTID';
        l_txmsg.txfields('02').type    := 'C';
        l_txmsg.txfields('02').value   := p_camastid;
        ----SYMBOL_ORG---------------------
        l_txmsg.txfields('71').defname := 'SYMBOL_ORG';
        l_txmsg.txfields('71').type    := 'C';
        l_txmsg.txfields('71').value   := rec.symbol_org;
        ----SYMBOL---------------------
        l_txmsg.txfields('04').defname := 'SYMBOL';
        l_txmsg.txfields('04').type    := 'C';
        l_txmsg.txfields('04').value   := rec.symbol;
        ----OPTSYMBOL---------------------
        l_txmsg.txfields('24').defname := 'OPTSYMBOL';
        l_txmsg.txfields('24').type    := 'C';
        l_txmsg.txfields('24').value   := rec.optsymbol;
        ----CUSTODYCD
        l_txmsg.txfields('96').defname := 'CUSTODYCD';
        l_txmsg.txfields('96').type    := 'C';
        l_txmsg.txfields('96').value   := rec.custodycd;
        ----CIFID
        l_txmsg.txfields('03').defname := 'CIFID';
        l_txmsg.txfields('03').type    := 'C';
        l_txmsg.txfields('03').value   := rec.cifid;
        ----FULLNAME
        l_txmsg.txfields('08').defname := 'FULLNAME';
        l_txmsg.txfields('08').type    := 'C';
        l_txmsg.txfields('08').value   := rec.fullname;
        ----TRADE
        l_txmsg.txfields('11').defname := 'TRADE';
        l_txmsg.txfields('11').type    := 'N';
        l_txmsg.txfields('11').value   := rec.trade;
        ----MAXQTTY
        l_txmsg.txfields('20').defname := 'MAXQTTY';
        l_txmsg.txfields('20').type    := 'N';
        l_txmsg.txfields('20').value   := p_qtty_en;
        ----QTTYCANCEL
        l_txmsg.txfields('12').defname := 'QTTYCANCEL';
        l_txmsg.txfields('12').type    := 'N';
        l_txmsg.txfields('12').value   := rec.qttycancel;
          ----QTTY----------------------
        l_txmsg.txfields('10').defname := 'QTTY';
        l_txmsg.txfields('10').type    := 'N';
        l_txmsg.txfields('10').value   := p_qtty;
         ----EXPRICE
        l_txmsg.txfields('05').defname := 'EXPRICE';
        l_txmsg.txfields('05').type    := 'N';
        l_txmsg.txfields('05').value   := p_subprice;
          ----DESC
        l_txmsg.txfields('30').defname := 'DESC';
        l_txmsg.txfields('30').type    := 'C';
        l_txmsg.txfields('30').value   :=  p_desc;

        v_xmlmsg_string :=txpks_msg.fn_obj2xml(l_txmsg);
        p_err_code := txpks_#3333.fn_txprocess(v_xmlmsg_string, v_err_code, p_err_message);
        if p_err_code <>systemnums.c_success then
             plog.error(pkgctx,v_param || ' run ' || v_tltxcd || ' got ' || p_err_code || ':' || p_err_message);
             p_err_msg :=p_err_message;
             rollback;
             plog.setendsection(pkgctx, 'pr_auto_3333_web');
             return;
        end if;
        pr_generate_otp('TRANS',p_reftransid, p_tlid, '', '','N', p_err_code, p_err_msg);
    end loop;
    plog.setendsection(pkgctx, 'pr_auto_3333_web');

 exception
    when others then
        v_err_code := errnums.c_system_error;
        plog.error(pkgctx,
                   ' Err: ' || sqlerrm || ' Trace: ' ||
                   dbms_utility.format_error_backtrace);

        plog.setendsection(pkgctx, 'pr_auto_3333_web');
        p_err_code   := v_err_code;
end;

procedure prc_get_list_lapse_right(p_refcursor   in out pkg_report.ref_cursor,
                                   p_fundsymbol  in varchar2,
                                   p_valuedate   in varchar2,
                                   p_camastid    in varchar2,
                                   p_tlid        in varchar2,
                                   p_role        in varchar2,
                                   p_err_code    in out varchar2,
                                   p_err_msg     in out varchar2)
as
    v_param         varchar2(4000);
    v_custodycd     varchar2(20);
    v_listcustodycd varchar2(200);
    v_role          varchar2(10);
begin

    plog.debug(pkgctx, 'prc_get_list_lapse_right');
    v_param   :=' prc_get_list_lapse_right: fundsymbol' || p_fundsymbol||' p_valuedate '||p_valuedate||' camastid '||p_camastid;

    p_err_code  := systemnums.c_success;
    p_err_msg   := 'SUCCESS';

    begin
        select custodycd,listcustodycd,role
        into v_custodycd,v_listcustodycd,v_role
        from userlogin
        where username = p_tlid;
    exception
        when others then
             v_custodycd := '';
             v_listcustodycd:='';
             v_role:='';
    end;

    open p_refcursor for
        select a1.en_cdcontent txstatus_cnt, tl.txstatus, tl.txnum, tl.txdate,
            tl.tltxcd ||' - '|| gd.en_txdesc tranname, fa.symbol fundcode,fa.custodycd, tl.busdate,
            substr(fld.camastid,1,4) || '.'||substr(fld.camastid,5,6) ||'.' ||substr(fld.camastid,11,6) camastid,
            ca.catype, a2.en_cdcontent catype_cnt,fld.otpsymbol,iss.fullname optname, fld.qtty_en, ca.reportdate,
            ca.rightoffrate exrate, fld.qtty, tl.txdesc
        from tllog tl,tltx gd,allcode a1,allcode a2,cbfafund fa,camast ca,sbsecurities opt,issuers iss,
            (select txnum,txdate,
                 max(case when fldcd = '02' then cvalue else null end) camastid,
                 max(case when fldcd = '24' then cvalue else null end) otpsymbol,
                 max(case when fldcd = '20' then nvalue else null end) qtty_en,
                 max(case when fldcd = '10' then nvalue else null end) qtty,
                 max(case when fldcd = '05' then nvalue else null end) subprice,
                 max(case when fldcd = '96' then cvalue else null end) custodycd
             from tllogfld
             where fldcd in ('02','24','20','10','05','96')
             group by txnum,txdate) fld
        where tl.tltxcd in ('3333') and tl.txstatus <> '0'
        and a1.cdname='TXSTATUS' and a1.cdtype='SY' and a1.cdval = tl.txstatus
        and a2.cdname='CATYPE' and a2.cdtype='SA' and a2.cdval = ca.catype
        and tl.tltxcd = gd.tltxcd
        and tl.txnum = fld.txnum and tl.txdate = fld.txdate
        and fld.custodycd = fa.custodycd
        and fld.camastid = ca.camastid
        and fld.otpsymbol = opt.symbol
        and opt.issuerid = iss.issuerid
        and (instr(v_listcustodycd, fld.custodycd) >0 or fld.custodycd =v_custodycd)
        and fa.symbol like  nvl(p_fundsymbol,'%%')
        and tl.busdate like nvl(p_valuedate,'%%')
        and fld.camastid like nvl(p_camastid,'%%')
        order by tl.txdate desc, tl.txnum desc;

    plog.setendsection(pkgctx, 'prc_get_list_lapse_right');
exception
    when others then
         p_err_code := errnums.c_system_error;
         plog.error(pkgctx,'p_cdtype: ' || ' Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
         plog.setendsection(pkgctx, 'prc_get_list_lapse_right');
end prc_get_list_lapse_right;

procedure prc_get_autoid_docstransfer (p_refcursor in out pkg_report.ref_cursor,
                                       p_fundcode  in varchar2,
                                       p_type      in varchar2,
                                       p_err_code  in out varchar2,
                                       p_err_msg   in out varchar2)
as
    v_param     varchar2(4000);
    v_custodycd varchar2(30);
begin

    plog.debug(pkgctx, 'prc_get_autoid_docstransfer');
    v_param   := ' prc_get_autoid_docstransfer'  ;

    p_err_code  := systemnums.c_success;
    p_err_msg   := 'success';

    select custodycd into v_custodycd from cbfafund where symbol = p_fundcode;
    if p_type = 'R' then
        open p_refcursor for
            select '-1' cdval , '-----' cdcontent, '-----' en_cdcontent from dual;
    else
        open p_refcursor for
            select DOC.AUTOID cdval,
                 case when CR.NO is not null then 'Agreement No: ' || CR.NO else '' end || ' - Received date: '||TO_CHAR(DOC.OPNDATE,'DD/MM/RRRR')|| ' - Physical: '||DOC.SYMBOL|| ' - Quantity : '||DOC.QTTY cdcontent ,
                 case when CR.NO is not null then 'Agreement No: ' || CR.NO else '' end || ' - Received date: '||TO_CHAR(DOC.OPNDATE,'DD/MM/RRRR')|| ' - Physical: '||DOC.SYMBOL|| ' - Quantity : '||DOC.QTTY en_cdcontent
            from docstransfer doc, crphysagree cr, cfmast cf
            where doc.crphysagreeid = cr.crphysagreeid (+)
                  and doc.custodycd = cf.custodycd
                  and doc.status = 'OPN'
                  and doc.deltd <> 'Y'
                  and doc.custodycd = v_custodycd;
    end if;
exception
    when others then
        p_err_code := errnums.c_system_error;
    plog.setendsection(pkgctx, 'prc_get_autoid_docstransfer');
end;
procedure prc_get_crphysagreeid (p_refcursor in out pkg_report.ref_cursor,
                                 p_fundcode  in varchar2,
                                 p_err_code  in out varchar2,
                                 p_err_msg   in out varchar2)
as
    v_param     varchar2(4000);
    v_custodycd varchar2(30);
begin

    plog.debug(pkgctx, 'prc_get_crphysagreeid');
    v_param   := ' prc_get_crphysagreeid'  ;

    p_err_code  := systemnums.c_success;
    p_err_msg   := 'success';

    select custodycd into v_custodycd from cbfafund where symbol = p_fundcode;
        open p_refcursor for
            select *
            from
                (select cr.crphysagreeid cdval,
                     'Agreement ID: '||cr.crphysagreeid||case when cr.no is not null then ' - Agreement No: ' || cr.no else '' end || ' - Physical: '||cr.symbol|| ' - Quantity : '||cr.qtty cdcontent ,
                     'Agreement ID: '||cr.crphysagreeid||case when cr.no is not null then ' - Agreement No: ' || cr.no else '' end || ' - Physical: '||cr.symbol|| ' - Quantity : '||cr.qtty en_cdcontent
                from crphysagree cr, cfmast cf
                where cr.status = 'A'
                      and cr.qtty > cr.reqtty
                      and cr.custodycd = v_custodycd
                union all
                select '-1' cdval , '-----' cdcontent, '-----' en_cdcontent from dual) f
             order by cdval;
exception
    when others then
        p_err_code := errnums.c_system_error;
    plog.setendsection(pkgctx, 'prc_get_crphysagreeid');
end;

procedure prc_get_ticker (p_refcursor in out pkg_report.ref_cursor,
                          p_err_code  in out varchar2,
                          p_err_msg   in out varchar2)
as
    v_param     varchar2(4000);
begin
    plog.debug(pkgctx, 'prc_get_ticker');
    v_param   := ' prc_get_ticker'  ;

    p_err_code  := systemnums.c_success;
    p_err_msg   := 'success';

    open p_refcursor for
        select sb.codeid cdval,
            sb.symbol || ' - ' || iss.fullname cdcontent ,
            sb.symbol || ' - ' || iss.fullname en_cdcontent
        from sbsecurities sb, issuers iss
        where sb.refcodeid is null
        and sb.issuerid = iss.issuerid
        and sb.sectype <> '004';
exception
    when others then
        p_err_code := errnums.c_system_error;
    plog.setendsection(pkgctx, 'prc_get_ticker');
end;

procedure prc_get_info_from_fundcode(p_refcursor   in out pkg_report.ref_cursor,
                                     p_fundcode   in varchar2,
                                     p_err_code    in out varchar2,
                                     p_err_msg     in out varchar2)
as
    v_param         varchar2(4000);
    v_acctno        varchar2(30);
begin

    plog.debug(pkgctx, 'prc_get_info_from_fundcode');
    v_param   :=' prc_get_info_from_fundcode: p_fundcode' ||p_fundcode ;

    p_err_code  := systemnums.c_success;
    p_err_msg   := 'SUCCESS';

    open p_refcursor for
        select cf.custodycd, case when fm.roles = 'AMC' then fm.fullname else '' end amc
            from cfmast cf,famembers fm, cbfafund fa
            where cf.amcid = fm.autoid(+)
            and cf.custodycd = fa.custodycd
            and fa.symbol = p_fundcode;
exception
    when others then
        p_err_code := errnums.c_system_error;
    plog.setendsection(pkgctx, 'prc_get_info_from_fundcode');
end prc_get_info_from_fundcode;

procedure prc_get_info_from_ticker(p_refcursor   in out pkg_report.ref_cursor,
                                   p_ticker   in varchar2,
                                   p_err_code    in out varchar2,
                                   p_err_msg     in out varchar2)
as
    v_param         varchar2(4000);
    v_acctno        varchar2(30);
begin

    plog.debug(pkgctx, 'prc_get_info_from_ticker');
    v_param   :=' prc_get_info_from_ticker: p_ticker' ||p_ticker ;

    p_err_code  := systemnums.c_success;
    p_err_msg   := 'SUCCESS';

    open p_refcursor for
        select nvl(iss.fullname,iss.en_fullname) fullname, sb.parvalue
            from sbsecurities sb, issuers iss
            where sb.issuerid = iss.issuerid
            and sb.codeid = p_ticker;
exception
    when others then
        p_err_code := errnums.c_system_error;
    plog.setendsection(pkgctx, 'prc_get_info_from_ticker');
end prc_get_info_from_ticker;

procedure prc_get_info_from_crphysagreeid(p_refcursor   in out pkg_report.ref_cursor,
                                          p_crphysagreeid   in varchar2,
                                          p_err_code    in out varchar2,
                                          p_err_msg     in out varchar2)
as
    v_param         varchar2(4000);
    v_acctno        varchar2(30);
begin

    plog.debug(pkgctx, 'prc_get_info_from_crphysagreeid');
    v_param   :=' prc_get_info_from_crphysagreeid: p_crphysagreeid' ||p_crphysagreeid ;

    p_err_code  := systemnums.c_success;
    p_err_msg   := 'SUCCESS';

    if p_crphysagreeid <> '-1' then
    open p_refcursor for
        select cr.codeid , nvl(iss.fullname,iss.en_fullname) symbolname,sb.parvalue
        from crphysagree cr, sbsecurities sb, issuers iss
        where cr.crphysagreeid = p_crphysagreeid
        and cr.codeid = sb.codeid
        and iss.issuerid = sb.issuerid;
    end if;
exception
    when others then
        p_err_code := errnums.c_system_error;
    plog.setendsection(pkgctx, 'prc_get_info_from_crphysagreeid');
end prc_get_info_from_crphysagreeid;

procedure prc_get_info_from_autoid(p_refcursor   in out pkg_report.ref_cursor,
                                   p_autoid      in varchar2,
                                   p_err_code    in out varchar2,
                                   p_err_msg     in out varchar2)
as
    v_param         varchar2(4000);
    v_acctno        varchar2(30);
begin

    plog.debug(pkgctx, 'prc_get_info_from_autoid');
    v_param   :=' prc_get_info_from_autoid: p_autoid' ||p_autoid ;

    p_err_code  := systemnums.c_success;
    p_err_msg   := 'SUCCESS';

    open p_refcursor for
        select cr.crphysagreeid contractnumber, sb.codeid ticker,
               nvl(iss.fullname,iss.en_fullname) symbolname,sb.parvalue, doc.qtty
        from docstransfer doc, crphysagree cr, sbsecurities sb,issuers iss
        where doc.crphysagreeid = cr.crphysagreeid(+)
        and doc.codeid = sb.codeid
        and iss.issuerid = sb.issuerid
        and doc.autoid = p_autoid;
exception
    when others then
        p_err_code := errnums.c_system_error;
    plog.setendsection(pkgctx, 'prc_get_info_from_autoid');
end prc_get_info_from_autoid;

procedure pr_auto_1405_1406_web(
    p_fundcode       varchar2,
    p_custodycd      varchar2,
    p_type           varchar2,
    p_tradingdate    varchar2,
    p_autoid         varchar2,
    p_receiver       varchar2,
    p_sender         varchar2,
    p_crphysagreeid  varchar2,
    p_codeid         varchar2,
    p_qtty           number,
    p_desc           varchar2,
    p_tlid           varchar2,
    p_reftransid     out varchar2,
    p_err_code       in out varchar2,
    p_err_msg        in out varchar2
 ) is
    l_txmsg          tx.msg_rectype;
    v_strcurrdate    varchar2(20);
    v_strdesc        varchar2(1000);
    v_stren_desc     varchar2(1000);
    v_tltxcd         varchar2(10);
    p_xmlmsg         varchar2(4000);
    v_param          varchar2(1000);
    v_err_code       varchar2(10);
    p_err_message    varchar2(500);
    l_txnum          varchar2(20);
    v_tlid           varchar2(5);
    v_xmlmsg_string  varchar2(5000);

    v_crqtty         number;
    v_symbol         varchar2(50);
    v_fullname       varchar2(200);
    v_opndate        date;

BEGIN
    v_err_code    := systemnums.c_success;
    p_err_message := 'success';
    plog.setbeginsection (pkgctx, 'pr_auto_1405_1406_web');

    p_reftransid :='';

    select qtty into v_crqtty from crphysagree a where a.crphysagreeid = p_crphysagreeid;
    select symbol into v_symbol from sbsecurities where codeid = p_codeid;
    select a.opndate into v_opndate from docstransfer a where autoid = p_autoid;
    select fullname into v_fullname from cfmast where custodycd = p_custodycd;

    select to_date (varvalue, systemnums.c_date_format)
    into v_strcurrdate
    from sysvar
    where grname = 'SYSTEM' and varname = 'CURRDATE';

    l_txmsg.msgtype     :='T';
    l_txmsg.local       :='N';
    l_txmsg.tlid        :='6868';

    begin
        select tlid into v_tlid from cfmast where custodycd = p_custodycd;
    exception
        when no_data_found then
             v_tlid:= null;
    end;

    select sys_context ('USERENV', 'HOST'),
             sys_context ('USERENV', 'IP_ADDRESS', 15)
    into l_txmsg.wsname, l_txmsg.ipaddress
    from dual;

    begin
        select brid
        into l_txmsg.brid
        from tlprofiles where tlid = v_tlid;
    exception
        when no_data_found then
           l_txmsg.brid:= null;
    end;
    ------------------------
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txlogged;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := 'DAY';
    l_txmsg.txdate      := to_date(v_strcurrdate,systemnums.c_date_format);
    l_txmsg.busdate     := to_date(p_tradingdate,systemnums.c_date_format);
    l_txmsg.tltxcd      := case when p_type = 'R' then '1405' else '1406' end;
    l_txmsg.nosubmit    := '1';
    l_txmsg.ovrrqd      := '@0';

    --------------------------SET CAC FIELD GIAO DICH-------------------------------
    ----SET TXNUM
    begin
        select l_txmsg.brid || lpad(seq_txnum.nextval, 6, '0')
        into l_txmsg.txnum
        from dual;
    exception
        when no_data_found then
             l_txmsg.txnum:= null;
    end;

    p_reftransid :='['|| to_char( l_txmsg.txdate,systemnums.c_date_format)  ||']['||l_txmsg.txnum||']';
    if p_type = 'R' then
        ----TXDATE---------------------
        l_txmsg.txfields('01').defname := 'TXDATE';
        l_txmsg.txfields('01').type    := 'D';
        l_txmsg.txfields('01').value   := to_date(p_tradingdate,'DD/MM/RRRR');
        ----CRPHYSAGREEID---------------------
        l_txmsg.txfields('02').defname := 'CRPHYSAGREEID';
        l_txmsg.txfields('02').type    := 'C';
        l_txmsg.txfields('02').value   := case when p_crphysagreeid like '-1' then null else p_crphysagreeid end;
        ----CODEID---------------------
        l_txmsg.txfields('03').defname := 'CODEID';
        l_txmsg.txfields('03').type    := 'C';
        l_txmsg.txfields('03').value   := p_codeid;
        ----QTTY---------------------
        l_txmsg.txfields('10').defname := 'QTTY';
        l_txmsg.txfields('10').type    := 'N';
        l_txmsg.txfields('10').value   := p_qtty;
        ----REFNO---------------------
        l_txmsg.txfields('11').defname := 'REFNO';
        l_txmsg.txfields('11').type    := 'C';
        l_txmsg.txfields('11').value   := null;
        ----CRQTTY---------------------
        l_txmsg.txfields('15').defname := 'CRQTTY';
        l_txmsg.txfields('15').type    := 'N';
        l_txmsg.txfields('15').value   := v_crqtty;
    else
        ----RECEIVEDDATE---------------------
        l_txmsg.txfields('17').defname := 'RECEIVEDDATE';
        l_txmsg.txfields('17').type    := 'D';
        l_txmsg.txfields('17').value   := v_opndate;
        ----POSTINGDATE---------------------
        l_txmsg.txfields('18').defname := 'POSTINGDATE';
        l_txmsg.txfields('18').type    := 'D';
        l_txmsg.txfields('18').value   := to_date(p_tradingdate,'DD/MM/RRRR');
        ----AUTOID---------------------
        l_txmsg.txfields('09').defname := 'AUTOID';
        l_txmsg.txfields('09').type    := 'C';
        l_txmsg.txfields('09').value   := p_autoid;
        ----CRPHYSAGREEID---------------------
        l_txmsg.txfields('01').defname := 'CRPHYSAGREEID';
        l_txmsg.txfields('01').type    := 'C';
        l_txmsg.txfields('01').value   := p_crphysagreeid;
        ----REFNO---------------------
        l_txmsg.txfields('02').defname := 'REFNO';
        l_txmsg.txfields('02').type    := 'C';
        l_txmsg.txfields('02').value   := null;
        ----SYMBOL---------------------
        l_txmsg.txfields('03').defname := 'SYMBOL';
        l_txmsg.txfields('03').type    := 'C';
        l_txmsg.txfields('03').value   := v_symbol;
        ----CODEID---------------------
        l_txmsg.txfields('04').defname := 'CODEID';
        l_txmsg.txfields('04').type    := 'C';
        l_txmsg.txfields('04').value   := p_codeid;
        ----AUTOID---------------------
        l_txmsg.txfields('09').defname := 'AUTOID';
        l_txmsg.txfields('09').type    := 'C';
        l_txmsg.txfields('09').value   := p_autoid;
        ----CRQTTY---------------------
        l_txmsg.txfields('10').defname := 'CRQTTY';
        l_txmsg.txfields('10').type    := 'N';
        l_txmsg.txfields('10').value   := v_crqtty;
        ----QTTY---------------------
        l_txmsg.txfields('11').defname := 'QTTY';
        l_txmsg.txfields('11').type    := 'N';
        l_txmsg.txfields('11').value   := p_qtty;
    end if;

        ----SENDER---------------------
        l_txmsg.txfields('31').defname := 'SENDER';
        l_txmsg.txfields('31').type    := 'C';
        l_txmsg.txfields('31').value   := p_sender;
        ----RECEIVER---------------------
        l_txmsg.txfields('32').defname := 'RECEIVER';
        l_txmsg.txfields('32').type    := 'C';
        l_txmsg.txfields('32').value   := p_receiver;
        ----CUSTODYCD
        l_txmsg.txfields('88').defname := 'CUSTODYCD';
        l_txmsg.txfields('88').type    := 'C';
        l_txmsg.txfields('88').value   := p_custodycd;
        ----FULLNAME
        l_txmsg.txfields('90').defname := 'FULLNAME';
        l_txmsg.txfields('90').type    := 'C';
        l_txmsg.txfields('90').value   := v_fullname;
          ----DESC
        l_txmsg.txfields('30').defname := 'DESC';
        l_txmsg.txfields('30').type    := 'C';
        l_txmsg.txfields('30').value   :=  p_desc;

        v_xmlmsg_string :=txpks_msg.fn_obj2xml(l_txmsg);
        if p_type = 'R' then
            p_err_code:=txpks_#1405.fn_txprocess(v_xmlmsg_string, v_err_code, p_err_message);
            if p_err_code <>systemnums.c_success then
                plog.error(pkgctx,v_param || ' run ' || v_tltxcd || ' got ' || p_err_code || ':' || p_err_message);
                p_err_msg :=p_err_message;
                rollback;
                plog.setendsection(pkgctx, 'pr_auto_1405_1406_web');
                return;
            end if;
            pr_generate_otp('TRANS',p_reftransid, p_tlid, '', '','N', p_err_code, p_err_msg);
        else
            p_err_code:=txpks_#1406.fn_txprocess(v_xmlmsg_string, v_err_code, p_err_message);

            if p_err_code <>systemnums.c_success then
                plog.error(pkgctx,v_param || ' run ' || v_tltxcd || ' got ' || p_err_code || ':' ||p_err_message);
                p_err_msg :=p_err_message;
                rollback;
                plog.setendsection(pkgctx, 'pr_auto_1405_1406_web');
                return;
            end if;
            pr_generate_otp('TRANS',p_reftransid, p_tlid, '', '','N', p_err_code, p_err_msg);
        end if;
    plog.setendsection(pkgctx, 'pr_auto_1405_1406_web');

 exception
    when others then
        v_err_code := errnums.c_system_error;
        plog.error(pkgctx,
                   ' Err: ' || sqlerrm || ' Trace: ' ||
                   dbms_utility.format_error_backtrace);

        plog.setendsection(pkgctx, 'pr_auto_1405_1406_web');
        p_err_code   := v_err_code;
end;

procedure prc_get_list_physical(p_refcursor   in out pkg_report.ref_cursor,
                                p_fundsymbol  in varchar2,
                                p_valuedate   in varchar2,
                                p_type        in varchar2,
                                p_ticker      in varchar2,
                                p_tlid        in varchar2,
                                p_role        in varchar2,
                                p_err_code    in out varchar2,
                                p_err_msg     in out varchar2)
as
    v_param         varchar2(4000);
    v_custodycd     varchar2(20);
    v_listcustodycd varchar2(200);
    v_role          varchar2(10);
begin

    plog.debug(pkgctx, 'prc_get_list_physical');
    v_param   :=' prc_get_list_physical: fundsymbol' || p_fundsymbol||' p_valuedate '||p_valuedate||' p_type '||p_type||' p_ticker '||p_ticker;

    p_err_code  := systemnums.c_success;
    p_err_msg   := 'SUCCESS';

    begin
        select custodycd,listcustodycd,role
        into v_custodycd,v_listcustodycd,v_role
        from userlogin
        where username = p_tlid;
    exception
        when others then
             v_custodycd := '';
             v_listcustodycd:='';
             v_role:='';
    end;

    open p_refcursor for
        select a1.en_cdcontent txstatus_cnt, tl.txstatus, tl.txnum, tl.txdate,
            tl.tltxcd ||' - '|| gd.en_txdesc tranname, fa.symbol fundcode,fa.custodycd, tl.busdate tradingdate,
            case when fm.roles = 'AMC' then fm.fullname else '' end amc,
            case when tl.tltxcd = '1405' then 'Deposit' else 'Withdraw' end trantype,
            fld.sender, fld.receiver,tl.msgamt qtty, tl.txdesc,
            case when tl.tltxcd = '1405' then fld.crid1405 else fld.crid1406 end Contractnumber,
            sb.codeid,sb.symbol ticker,nvl(iss.fullname,iss.en_fullname) tickername,sb.parvalue
        from tllog tl,tltx gd,allcode a1,cfmast cf, famembers fm,cbfafund fa,sbsecurities sb,issuers iss,
            (select txnum,txdate,
                 max(case when fldcd = '31' then cvalue else null end) sender,
                 max(case when fldcd = '32' then cvalue else null end) receiver,
                 max(case when fldcd = '88' then cvalue else null end) custodycd,
                 max(case when fldcd = '01' then cvalue else null end) crid1406,
                 max(case when fldcd = '02' then cvalue else null end) crid1405,
                 max(case when fldcd = '03' then cvalue else null end) codeid1405,
                 max(case when fldcd = '04' then cvalue else null end) codeid1406
             from tllogfld
             where fldcd in ('31','32','88','01','02','03','04')
             group by txnum,txdate) fld
        where tl.tltxcd in ('1405','1406') and tl.txstatus <> '0'
        and a1.cdname='TXSTATUS' and a1.cdtype='SY' and a1.cdval = tl.txstatus
        and tl.tltxcd = gd.tltxcd
        and tl.txnum = fld.txnum and tl.txdate = fld.txdate
        and fld.custodycd = fa.custodycd
        and fld.custodycd = cf.custodycd
        and cf.amcid = fm.autoid(+)
        and sb.codeid = (case when tl.tltxcd = '1405' then fld.codeid1405 else fld.codeid1406 end)
        and sb.issuerid = iss.issuerid
        and (instr(v_listcustodycd, fld.custodycd) >0 or fld.custodycd =v_custodycd)
        and fa.symbol like  nvl(p_fundsymbol,'%%')
        and tl.busdate like nvl(p_valuedate,'%%')
        and sb.codeid like nvl(p_ticker,'%%')
        and tl.tltxcd like (case when p_type = 'R' then '1405'
                                 when p_type = 'W' then '1406'
                                 else '%%' end)
        order by tl.txdate desc, tl.txnum desc;

    plog.setendsection(pkgctx, 'prc_get_list_physical');
exception
    when others then
         p_err_code := errnums.c_system_error;
         plog.error(pkgctx,'p_cdtype: ' || ' Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
         plog.setendsection(pkgctx, 'prc_get_list_physical');
end prc_get_list_physical;

procedure prc_revert(p_refcursor   in out pkg_report.ref_cursor,
                     p_txnum       in varchar2,
                     p_txdate      in varchar2,
                     p_err_code    in out varchar2,
                     p_err_msg     in out varchar2)
as
    v_param         varchar2(4000);
    v_status        varchar2(10);
begin

    plog.debug(pkgctx, 'prc_revert');
    v_param   :=' prc_revert: p_txnum' || p_txnum||' p_txdate '||p_txdate;

    p_err_code  := systemnums.c_success;
    p_err_msg   := 'SUCCESS';

    begin
        select txstatus into v_status from tllog where txnum = p_txnum and txdate = to_date(p_txdate,'DD/MM/RRRR') and deltd = 'N';
    exception
        when others then v_status := '';
    end;
    if v_status = '4' then
        update tllog set txstatus = txstatusnums.c_txrefuse,ptxstatus = txstatusnums.c_txrefuse where txnum = p_txnum and txdate = to_date(p_txdate,'DD/MM/RRRR') and deltd = 'N';
    else
        p_err_code := -930021;
        p_err_msg :=cspks_system.fn_get_errmsg(p_err_code);
        plog.setEndSection(pkgctx, 'prc_revert');
        rollback;
        return;
    end if;
    plog.setendsection(pkgctx, 'prc_revert');
exception
    when others then
         p_err_code := errnums.c_system_error;
         plog.error(pkgctx,'p_cdtype: ' || ' Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
         plog.setendsection(pkgctx, 'prc_revert');
end prc_revert;

procedure prc_get_securities_statement(p_refcursor   in out pkg_report.ref_cursor,
                                       p_fundsymbol  in varchar2,
                                       p_stocktype   in varchar2,
                                       p_fromdate    in varchar2,
                                       p_todate      in varchar2,
                                       p_stockcode   in varchar2,
                                       p_tlid        in varchar2,
                                       p_role        in varchar2,
                                       p_err_code    in out varchar2,
                                       p_err_msg     in out varchar2)
as
    v_param         varchar2(4000);
    v_custodycd     varchar2(20);
    v_listcustodycd varchar2(200);
    v_role          varchar2(10);
    v_cus           varchar2(30);
begin

    plog.debug(pkgctx, 'prc_get_securities_statement');
    v_param   :=' prc_get_securities_statement: fundsymbol' || p_fundsymbol
                                                ||' p_stocktype '||p_stocktype
                                                ||' p_fromdate '||p_fromdate
                                                ||' p_todate '||p_todate
                                                ||' p_stockcode '||p_stockcode;

    p_err_code  := systemnums.c_success;
    p_err_msg   := 'SUCCESS';
    begin
        select a.custodycd into v_cus from cbfafund a where a.symbol = p_fundsymbol;
    exception
        when others then
             v_cus := '';
    end;
    begin
        select custodycd,listcustodycd,role
        into v_custodycd,v_listcustodycd,v_role
        from userlogin
        where username = p_tlid;
    exception
        when others then
             v_custodycd := '';
             v_listcustodycd:='';
             v_role:='';
    end;

    open p_refcursor for
         select tran.txdate,se.sectype, a1.en_cdcontent sectype_cnt,se.symbol, tl.tltxcd ||' - '|| tl.en_txdesc trantype,
             tran.txdesc,tran.trade_namt,tran.blocked_namt,tran.netting_namt,tran.emkqtty_namt,tran.mortage_namt,tran.standing_namt,
             tran.receiving_namt,tran.ca_receiving_namt,tran.withdraw_namt,tran.dtoclose_namt,tran.blockwithdraw_namt,tran.blockdtoclose_namt
         from sbsecurities se,allcode a1,tltx tl,
            (select acctno,txnum,txdate,custodycd,symbol,tltxcd,txdesc,
                sum(case when field = 'TRADE' then (case when txtype = 'D' then - namt else namt end) else 0 end) trade_namt,
                sum(case when field = 'BLOCKED' then (case when txtype = 'D' then - namt else namt end) else 0 end) blocked_namt,
                sum(case when field = 'NETTING' then (case when txtype = 'D' then - namt else namt end) else 0 end) netting_namt,
                sum(case when field = 'EMKQTTY' then (case when txtype = 'D' then - namt else namt end) else 0 end) emkqtty_namt,
                sum(case when field = 'MORTAGE' then (case when txtype = 'D' then - namt else namt end) else 0 end) mortage_namt,
                sum(case when field = 'STANDING' then (case when txtype = 'D' then - namt else namt end) else 0 end) standing_namt,
                sum(case when field = 'RECEIVING' then (case when txtype = 'D' then -namt else namt end) else 0 end) receiving_namt,
                sum(case when field = 'RECEIVING' and txcd in('3351','3350') then
                   (case when txtype = 'D' then -namt else namt end) else 0 end) ca_receiving_namt,
                sum(case when field = 'WITHDRAW' then (case when txtype = 'D' then -namt else namt end) else 0 end) withdraw_namt,
                sum(case when field = 'DTOCLOSE' then (case when txtype = 'D' then -namt else namt end) else 0 end) dtoclose_namt,
                sum(case when field = 'BLOCKWITHDRAW' then (case when txtype = 'D' then -namt else namt end) else 0 end) blockwithdraw_namt,
                sum(case when field = 'BLOCKDTOCLOSE' then (case when txtype = 'D' then -namt else namt end) else 0 end) blockdtoclose_namt
            from vw_setran_gen
            where deltd <> 'Y' and field in ('TRADE','BLOCKED','NETTING','EMKQTTY','MORTAGE','STANDING','WITHDRAW','DTOCLOSE','BLOCKWITHDRAW','BLOCKDTOCLOSE','RECEIVING')
            and busdate >= to_date(p_fromdate,'DD/MM/RRRR') and busdate <= to_date(p_todate,'DD/MM/RRRR')
            and custodycd like nvl(v_cus,'%%')
            and (instr(v_listcustodycd, custodycd) >0 or custodycd = v_custodycd)
            group by acctno,txnum,txdate,custodycd,symbol,tltxcd,txdesc) tran
       where se.symbol = tran.symbol
       and a1.cdname = 'SECTYPE' and a1.cdtype = 'SA' and a1.cdval = se.sectype
       and tran.tltxcd = tl.tltxcd
       and ( tran.trade_namt <> 0 or tran.blocked_namt <> 0 or tran.netting_namt <> 0 or tran.emkqtty_namt <> 0
       or tran.mortage_namt <> 0 or tran.standing_namt <> 0 or tran.receiving_namt <> 0 or tran.ca_receiving_namt <> 0
       or tran.withdraw_namt <> 0 or tran.dtoclose_namt <> 0 or tran.blockwithdraw_namt <> 0 or tran.blockdtoclose_namt <> 0 )
       and se.sectype like nvl(p_stocktype,'%%')
       and se.symbol like nvl(p_stockcode,'%%');
    plog.setendsection(pkgctx, 'prc_get_securities_statement');
exception
    when others then
         p_err_code := errnums.c_system_error;
         plog.error(pkgctx,'p_cdtype: ' || ' Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
         plog.setendsection(pkgctx, 'prc_get_securities_statement');
end prc_get_securities_statement;
PROCEDURE PRC_GET_BALANCE_6639 (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                    P_CUSTODYCD    IN   VARCHAR2,
                    P_ACCTNO    IN   VARCHAR2,
                    p_tlid        in varchar2,
                    p_role        in varchar2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2) as
   v_param  varchar2(4000);
  BEGIN

    plog.debug(pkgctx, 'PRC_GET_BALANCE_6639');
    v_param:=' PRC_GET_BALANCE_6639: '  ;

    err_code  := systemnums.C_SUCCESS;
    err_msg := 'SUCCESS';


    OPEN p_refcursor FOR

select ci.balance
 from ddmast ci,userlogin u
  where u.username=P_TLID
and( INSTR(u.listcustodycd, ci.custodycd) >0 or ci.custodycd =u.custodycd)
and ci.custodycd=P_CUSTODYCD
and ci.ACCTNO=P_ACCTNO;
  EXCEPTION
    WHEN OTHERS THEN
      err_code := errnums.C_SYSTEM_ERROR;
      plog.setEndSection(pkgctx, 'PRC_GET_BALANCE_6639');

END PRC_GET_BALANCE_6639;
procedure PRC_GET_RPTFIELDS(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     p_err_code      in out varchar2,
                     p_err_param     in out varchar2) as
  begin

    plog.setBeginSection(pkgctx, 'PRC_GET_RPTFIELDS');


    p_err_code  := systemnums.C_SUCCESS;
    p_err_param := 'SUCCESS';

         Open p_refcursor FOR
                   -- SELECT rf.*, 'CB' APPMODE FROM rptfields rf;

                SELECT RF.*, 'CB' APPMODE
                FROM RPTFIELDS RF , RPTMASTER R
                WHERE RF.OBJNAME=R.RPTID
                AND R.VISIBLE = 'Y'
                AND R.CMDTYPE ='R'
                AND R.ISLOCAL ='Y';

    plog.setEndSection(pkgctx, 'PRC_GET_RPTFIELDS');
  exception
    when others then
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error(pkgctx,'Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
      plog.setEndSection(pkgctx, 'PRC_GET_RPTFIELDS');
  end PRC_GET_RPTFIELDS;
    PROCEDURE PRC_GET_LIST_SECURITIES_INFORMATION(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     TICKER    IN   VARCHAR2,
                     p_tlid IN VARCHAR2,
                     p_role IN VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2) as
   v_param  varchar2(4000);
   v_custodycd VARCHAR2(20);
   v_listcustodycd varchar2(4000);
   v_role VARCHAR2(10);
   v_TRADINGDATE VARCHAR2(10);
   v_ACCTNO VARCHAR2(10);
  BEGIN

    plog.debug(pkgctx, 'PRC_GET_LIST_SECURITIES_INFORMATION');
    v_param:=' PRC_GET_LIST_SECURITIES_INFORMATION: TICKER' || TICKER ;

    err_code  := systemnums.C_SUCCESS;
    err_msg := 'SUCCESS';


    OPEN p_refcursor FOR

select * from (
SELECT  ISS.ISSUERID, ISS.SHORTNAME, ISS.FULLNAME, ISS.EN_FULLNAME FULLNAME_EN,SI.oldcirculatingqtty,si.newcirculatingqtty,sb.FOREIGNRATE,
(CASE WHEN (SB.SECTYPE IN ('003','006') AND SB.BONDTYPE ='005' AND SB.TRADEPLACE IN ('001','002','005')) OR SB.SECTYPE IN('001','002') THEN  TO_CHAR(UTILS.SO_THANH_CHU(SI.BASICPRICE)) ELSE '' END) MARKET_PRICE,
SB.SYMBOL,SB.BONDNAME,SB.ISINCODE,NVL(SB.PARVALUE,0) PARVALUE,A1.CDCONTENT CCYCD,A1.SHORTCD CCYNAME,TO_CHAR(SB.ISSUEDATE,'DD/MM/RRRR') ISSUEDATE,A2.CDCONTENT TYPETERM,SB.TERM,TO_CHAR(SB.EXPDATE,'DD/MM/RRRR') EXPDATE,NVL(SB.INTCOUPON,0) INTCOUPON,
NVL(SB.INTPREMATURE,0) INTPREMATURE,SB.INTERESTDATE,A3.CDCONTENT ISBUYSELL,A4.CDCONTENT SECTYPE,A4.en_CDCONTENT SECTYPE_EN,A5.CDCONTENT ISSEDEPOFEE,A6.CDCONTENT TRADEPLACE,SB.CODEID,
A7.CDCONTENT BONDTYPE,A7.EN_CDCONTENT BONDTYPE_EN,SB.CONTRACTNO
FROM SBSECURITIES SB
JOIN ISSUERS ISS ON SB.ISSUERID=ISS.ISSUERID
JOIN SECURITIES_INFO SI ON SB.CODEID=SI.CODEID
LEFT JOIN (SELECT AL.*, SBC.CCYCD,SBC.SHORTCD FROM ALLCODE AL JOIN SBCURRENCY SBC ON AL.CDVAL=SBC.SHORTCD) A1 ON A1.CDNAME='CCYCD' AND A1.CDTYPE ='FA' AND A1.CCYCD=SB.CCYCD
LEFT JOIN ALLCODE A2 ON A2.CDNAME='TYPETERM' AND A2.CDTYPE='SA' AND A2.CDVAL=SB.TYPETERM
LEFT JOIN ALLCODE A3 ON A3.CDNAME='ISBUYSELL' AND A3.CDTYPE='SE' AND A3.CDVAL=SB.ISBUYSELL
LEFT JOIN ALLCODE A4 ON A4.CDTYPE='SA' AND A4.CDNAME='SECTYPE' AND A4.CDVAL=SB.SECTYPE
LEFT JOIN ALLCODE A5 ON A5.CDNAME='YESNO' AND A5.CDTYPE='SY' AND A5.CDVAL=SB.ISSEDEPOFEE
LEFT JOIN ALLCODE A6 ON A6.CDTYPE='SA' AND A6.CDNAME='TRADEPLACE' AND A6.CDVAL=SB.TRADEPLACE
LEFT JOIN ALLCODE A7 ON A7.CDTYPE='SA' AND A7.CDNAME='BONDTYPE' AND A7.CDVAL=SB.BONDTYPE
)
where symbol=TICKER;






    plog.setEndSection(pkgctx, 'PRC_GET_LIST_SECURITIES_INFORMATION');
  EXCEPTION
    WHEN OTHERS THEN
      err_code := errnums.C_SYSTEM_ERROR;
        plog.error(pkgctx,'p_cdtype: ' || ' Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
      plog.setEndSection(pkgctx, 'PRC_GET_LIST_SECURITIES_INFORMATION');

END PRC_GET_LIST_SECURITIES_INFORMATION;
PROCEDURE PRC_GET_LIST_SECURITIES_BALANCE_ONLINE(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     P_CUSTODYCD    IN   VARCHAR2,
                     P_TICKER    IN   VARCHAR2,
                     P_ISINCODE    IN   VARCHAR2,
                     p_tlid IN VARCHAR2,
                     p_role IN VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2) as
   v_param  varchar2(4000);
   v_custodycd VARCHAR2(20);
   v_listcustodycd varchar2(4000);
   v_role VARCHAR2(10);
   v_TRADINGDATE VARCHAR2(10);
   v_ACCTNO VARCHAR2(10);
    l_clob clob;
  BEGIN

    plog.debug(pkgctx, 'PRC_GET_LIST_SECURITIES_BALANCE_ONLINE');
    v_param:=' PRC_GET_LIST_SECURITIES_BALANCE_ONLINE: TICKER' || P_TICKER ||' P_CUSTODYCD '||P_CUSTODYCD;

    err_code  := systemnums.C_SUCCESS;
    err_msg := 'SUCCESS';


    OPEN p_refcursor FOR
    /*
SELECT * FROM (
SELECT   max(SYMBOL) SYMBOL,max(CUSTODYCD) CUSTODYCD,max(FULLNAME) FULLNAME,
max(IDCODE) IDCODE ,max(ADDRESS)ADDRESS,
sum(TOTAL_QTTY) TOTAL_QTTY,sum(TRADE_QTTY) TRADE_QTTY ,   sum(WTRADE)WTRADE ,sum(DEALFINANCING_QTTY) DEALFINANCING_QTTY,
sum(ORDERQTTY_NORMAL) ORDERQTTY_NORMAL,   sum(ORDERQTTY_BLOCKED) ORDERQTTY_BLOCKED,sum(ORDERQTTY_BUY) ORDERQTTY_BUY,
sum(MORTGAGE_QTTY) MORTGAGE_QTTY,sum(NETTING_QTTY)NETTING_QTTY,  sum(BLOCKED_QTTY)BLOCKED_QTTY,
sum(SECURITIES_RECEIVING_T1)SECURITIES_RECEIVING_T1,
sum(SECURITIES_RECEIVING_T2) SECURITIES_RECEIVING_T2,
sum(SECURITIES_RECEIVING_TN) SECURITIES_RECEIVING_TN,
sum(SECURITIES_SENDING_T1) SECURITIES_SENDING_T1,
sum(SECURITIES_SENDING_T2) SECURITIES_SENDING_T2,
sum(SECURITIES_SENDING_TN) SECURITIES_SENDING_TN,sum(CA_RECEIVING)CA_RECEIVING,
SUM(WITHDRAW_QTTY) WITHDRAW_QTTY,
SUM(DEPOSIT_QTTY) DEPOSIT_QTTY,
SUM(HOLD_QTTY) HOLD_QTTY,
SUM(CKCC_RECEIVING) CKCC_RECEIVING,
SUM(CKCC_NETTING) CKCC_NETTING,
ISINCODE
FROM  v_Se2206
GROUP BY custodycd, symbol,ISINCODE)SE
WHERE  SE.TOTAL_QTTY  <> 0
AND SE.CUSTODYCD=P_CUSTODYCD
AND SE.SYMBOL LIKE P_TICKER
AND SE.ISINCODE LIKE P_ISINCODE;
*/
select t.*,(t.MORTGAGE_QTTY+t.BLOCKED_QTTY+t.EMKQTTY) BLOCK_SUM,
 (t.SECURITIES_RECEIVING_TN+t.SECURITIES_RECEIVING_T1+t.SECURITIES_RECEIVING_T2) TRADERECEIVING_SUM,
 (t.NETTING_QTTY+t.WITHDRAW_QTTY) TRADEDELIVERY_SUM
from (
SELECT REPLACE(v.SYMBOL,'_WFT','') SYMBOL, v.CUSTODYCD, v.FULLNAME, v.IDCODE, v.ADDRESS,
SUM(CASE WHEN INSTR(SYMBOL,'_WFT') > 0 THEN 0 ELSE TOTAL_QTTY END) TOTAL_QTTY,
SUM(CASE WHEN INSTR(SYMBOL,'_WFT') > 0 THEN TOTAL_QTTY ELSE 0 END) WFT_TOTAL_QTTY,
SUM(CASE WHEN INSTR(SYMBOL,'_WFT') > 0 THEN 0 ELSE TRADE_QTTY END) TRADE_QTTY,
SUM(CASE WHEN INSTR(SYMBOL,'_WFT') > 0 THEN 0 ELSE WTRADE END) WTRADE,
SUM(CASE WHEN INSTR(SYMBOL,'_WFT') > 0 THEN 0 ELSE DEALFINANCING_QTTY END) DEALFINANCING_QTTY,
SUM(CASE WHEN INSTR(SYMBOL,'_WFT') > 0 THEN 0 ELSE ORDERQTTY_NORMAL END) ORDERQTTY_NORMAL,
SUM(CASE WHEN INSTR(SYMBOL,'_WFT') > 0 THEN 0 ELSE ORDERQTTY_BLOCKED END) ORDERQTTY_BLOCKED,
SUM(CASE WHEN INSTR(SYMBOL,'_WFT') > 0 THEN 0 ELSE ORDERQTTY_BUY END) ORDERQTTY_BUY,
SUM(CASE WHEN INSTR(SYMBOL,'_WFT') > 0 THEN 0 ELSE MORTGAGE_QTTY END) MORTGAGE_QTTY,
SUM(CASE WHEN INSTR(SYMBOL,'_WFT') > 0 THEN 0 ELSE NETTING_QTTY END) NETTING_QTTY,
SUM(CASE WHEN INSTR(SYMBOL,'_WFT') > 0 THEN 0 ELSE BLOCKED_QTTY END) BLOCKED_QTTY,
SUM(CASE WHEN INSTR(SYMBOL,'_WFT') > 0 THEN 0 ELSE SECURITIES_RECEIVING_T1 END) SECURITIES_RECEIVING_T1,
SUM(CASE WHEN INSTR(SYMBOL,'_WFT') > 0 THEN 0 ELSE SECURITIES_RECEIVING_T2 END) SECURITIES_RECEIVING_T2,
SUM(CASE WHEN INSTR(SYMBOL,'_WFT') > 0 THEN 0 ELSE SECURITIES_RECEIVING_TN END) SECURITIES_RECEIVING_TN,
SUM(CASE WHEN INSTR(SYMBOL,'_WFT') > 0 THEN 0 ELSE SECURITIES_SENDING_T1 END) SECURITIES_SENDING_T1,
SUM(CASE WHEN INSTR(SYMBOL,'_WFT') > 0 THEN 0 ELSE SECURITIES_SENDING_T2 END) SECURITIES_SENDING_T2,
SUM(CASE WHEN INSTR(SYMBOL,'_WFT') > 0 THEN 0 ELSE SECURITIES_SENDING_TN END) SECURITIES_SENDING_TN,
SUM(CA_RECEIVING) CA_RECEIVING,
SUM(CASE WHEN INSTR(SYMBOL,'_WFT') > 0 THEN 0 ELSE WITHDRAW_QTTY END) WITHDRAW_QTTY,
SUM(CASE WHEN INSTR(SYMBOL,'_WFT') > 0 THEN 0 ELSE DEPOSIT_QTTY END) DEPOSIT_QTTY,
SUM(CASE WHEN INSTR(SYMBOL,'_WFT') > 0 THEN 0 ELSE HOLD_QTTY END) HOLD_QTTY,
SUM(CASE WHEN INSTR(SYMBOL,'_WFT') > 0 THEN 0 ELSE CKCC_RECEIVING END) CKCC_RECEIVING,
SUM(CASE WHEN INSTR(SYMBOL,'_WFT') > 0 THEN 0 ELSE CKCC_NETTING END) CKCC_NETTING,
SUM(CASE WHEN INSTR(SYMBOL,'_WFT') > 0 THEN 0 ELSE EMKQTTY END) EMKQTTY
FROM V_SE2205 v,userlogin u
WHERE u.username=P_TLID
and ( INSTR(u.listcustodycd, v.CUSTODYCD) >0 or v.CUSTODYCD =u.custodycd)
and v.CUSTODYCD = P_CUSTODYCD
AND v.SYMBOL LIKE NVL(P_TICKER,'%') || '%'
AND (v.TOTAL_QTTY  <> 0 OR v.CA_RECEIVING <> 0)
GROUP BY REPLACE(v.SYMBOL,'_WFT','') , v.CUSTODYCD, v.FULLNAME, v.IDCODE, v.ADDRESS
)t;

    plog.setEndSection(pkgctx, 'PRC_GET_LIST_SECURITIES_BALANCE_ONLINE');
  EXCEPTION
    WHEN OTHERS THEN
      err_code := errnums.C_SYSTEM_ERROR;
        plog.error(pkgctx,'p_cdtype: ' || ' Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
      plog.setEndSection(pkgctx, 'PRC_GET_LIST_SECURITIES_BALANCE_ONLINE');

END PRC_GET_LIST_SECURITIES_BALANCE_ONLINE;
PROCEDURE PRC_GET_LIST_SECURITIES_STATEMENT(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     P_CUSTODYCD    IN   VARCHAR2,
                     P_FRDATE    IN   VARCHAR2,
                     P_TODATE    IN   VARCHAR2,
                     P_SECTYPE IN VARCHAR2,
                     P_TICKER IN VARCHAR2,
                     P_ISINCODE IN VARCHAR2,
                     P_TYPE IN VARCHAR2,
                     p_tlid IN VARCHAR2,
                     p_role IN VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2) as
   v_param  varchar2(4000);
   v_custodycd VARCHAR2(20);
   v_listcustodycd varchar2(4000);
   v_role VARCHAR2(10);
   v_TRADINGDATE VARCHAR2(10);
   v_ACCTNO VARCHAR2(10);
   v_sectype VARCHAR2(10);
  BEGIN

    plog.debug(pkgctx, 'PRC_GET_LIST_SECURITIES_STATEMENT');
    v_param:=' PRC_GET_LIST_SECURITIES_STATEMENT: TICKER' ;

    err_code  := systemnums.C_SUCCESS;
    err_msg := 'SUCCESS';

    if P_SECTYPE= '000' THEN
      v_sectype:='%%';
    else
      v_sectype:=P_SECTYPE;
    end if;

    OPEN p_refcursor FOR

   select to_char(TXDATE,'DD/MM/RRRR') TXDATE,a.CUSTODYCD,CIFID,SYMBOL,INCREASED,DECREASE,DESCCRIPTION,DORC,SECTYPE,ISINCODE,b.txdesc TLDESC,b.en_txdesc TLDESC_EN,
    CASE WHEN DORC='C' then INCREASED else DECREASE*(-1) end QUANTITY
     from v_se2220 a,tltx b,userlogin u
    where  u.username=P_TLID
    and ( INSTR(u.listcustodycd, a.CUSTODYCD) >0 or a.CUSTODYCD =u.custodycd)
    and a.tltxcd= b.tltxcd
    AND a.CUSTODYCD=P_CUSTODYCD
    AND a.SECTYPE LIKE v_sectype
    AND a.SYMBOL LIKE P_TICKER
    AND a.DORC LIKE P_TYPE
    AND NVL(a.ISINCODE,'%') LIKE P_ISINCODE
    AND TO_DATE(TO_CHAR(TXDATE,'DD/MM/RRRR'),'DD/MM/RRRR') >= TO_DATE(P_FRDATE,'DD/MM/RRRR')
    AND TO_DATE(TO_CHAR(TXDATE,'DD/MM/RRRR'),'DD/MM/RRRR') <= TO_DATE(P_TODATE,'DD/MM/RRRR')
      ORDER BY TO_DATE(TXDATE,'DD/MM/RRRR') DESC;


    plog.setEndSection(pkgctx, 'PRC_GET_LIST_SECURITIES_STATEMENT');
  EXCEPTION
    WHEN OTHERS THEN
      err_code := errnums.C_SYSTEM_ERROR;
        plog.error(pkgctx,'p_cdtype: ' || ' Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
      plog.setEndSection(pkgctx, 'PRC_GET_LIST_SECURITIES_STATEMENT');

END PRC_GET_LIST_SECURITIES_STATEMENT;
PROCEDURE PRC_GET_FULLNAME_BYCUSTODYCD (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                      P_CUSTODYCD      IN  VARCHAR2,
                      P_tlid      IN  VARCHAR2,
                       P_ROLE      IN  VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2) as
   v_param  varchar2(4000);
   v_custodycd     varchar2(20);
    v_listcustodycd varchar2(4000);
    v_role          varchar2(10);
  BEGIN

    plog.debug(pkgctx, 'PRC_GET_FULLNAME_BYCUSTODYCD');
    v_param:=' PRC_GET_FULLNAME_BYCUSTODYCD: '  ;

    err_code  := systemnums.C_SUCCESS;
    err_msg := 'SUCCESS';
      begin
        select custodycd,listcustodycd,role
        into v_custodycd,v_listcustodycd,v_role
        from userlogin
        where username = p_tlid;
    exception
        when others then
             v_custodycd := '';
             v_listcustodycd:='';
             v_role:='';
    end;
    /*
    IF V_ROLE ='AP' then
    OPEN p_refcursor FOR
        SELECT fullname FROM CFMAST cf,DDMAST ci
            WHERE cf.custodycd=ci.custodycd and   REFCASAACCT=P_CUSTODYCD;
    else
    OPEN p_refcursor FOR

select fullname from cfmast cf,userlogin u where cf.custodycd =P_CUSTODYCD
 and u.username=p_tlid
  and (instr(v_listcustodycd, cf.custodycd) >0 or cf.custodycd = v_custodycd);
end if;
*/
    OPEN p_refcursor FOR

select fullname from cfmast cf,userlogin u where cf.custodycd =P_CUSTODYCD
 and u.username=p_tlid
  and (instr(v_listcustodycd, cf.custodycd) >0 or cf.custodycd = v_custodycd);

  EXCEPTION
    WHEN OTHERS THEN
      err_code := errnums.C_SYSTEM_ERROR;
      plog.setEndSection(pkgctx, 'PRC_GET_FULLNAME_BYCUSTODYCD');

END PRC_GET_FULLNAME_BYCUSTODYCD;
PROCEDURE PRC_GET_LIST_CASH_STATEMENT(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     P_CUSTODYCD    IN   VARCHAR2,
                     P_ACCTNO    IN   VARCHAR2,
                     P_FRDATE    IN   VARCHAR2,
                     P_TODATE    IN   VARCHAR2,
                     P_TYPE IN VARCHAR2,
                     p_tlid IN VARCHAR2,
                     p_role IN VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2) as
    v_param  varchar2(4000);
    v_custodycd VARCHAR2(20);
    v_listcustodycd varchar2(4000);
    v_role VARCHAR2(10);
    v_TRADINGDATE VARCHAR2(10);
    v_ACCTNO VARCHAR2(20);
    v_dauky number;
    v_cuoiky number;
  BEGIN

    plog.debug(pkgctx, 'PRC_GET_LIST_CASH_STATEMENT');
    v_param:=' PRC_GET_LIST_CASH_STATEMENT: TICKER' ;

    err_code  := systemnums.C_SUCCESS;
    err_msg := 'SUCCESS';

    v_custodycd:=P_CUSTODYCD;
    v_acctno:=P_ACCTNO;
    select LISTCUSTODYCD || ';' || CUSTODYCD into v_listcustodycd  from userlogin where username=P_TLID;

    SELECT (DD.BALANCE + DD.HOLDBALANCE) - NVL(TR_DK.NAMT,0) INTO V_DAUKY
    FROM DDMAST DD
    LEFT JOIN (
        SELECT LOG.ACCTNO, SUM(CASE WHEN LOG.TXTYPE = 'D' THEN -LOG.NAMT ELSE LOG.NAMT END) NAMT
        FROM VW_DDTRAN_GEN LOG, VW_TLLOG_ALL TL1
        WHERE LOG.TXDATE = TL1.TXDATE AND LOG.TXNUM = TL1.TXNUM
        AND LOG.FIELD = 'BALANCE'
        AND LOG.TXTYPE IN ('D','C')
        AND LOG.DELTD = 'N'
        AND LOG.NAMT <> 0
        AND LOG.TLTXCD NOT IN ('6690', '6691', '6696', '6697', '6698', '6699', '6689', '6692', '6603', '6604')
        AND LOG.TLTXCD NOT IN ('6628', '6629', '6615', '6659')
        AND TL1.TLTXCD NOT IN ('1296')
        AND NVL(LOG.BUSDATE, LOG.TXDATE) >= TO_DATE(P_FRDATE,'DD/MM/RRRR')
        --AND NVL(LOG.BUSDATE, LOG.TXDATE) <= TO_DATE(P_TODATE,'DD/MM/RRRR')
        AND NOT EXISTS (
            SELECT 1 FROM VW_TLLOG_ALL TL2
            WHERE TL2.TLTXCD IN ('6628', '6629', '6615', '6659')
            AND TL2.TXDATE = TL1.TXDATE
            AND TL2.REFTXNUM = TL1.TXNUM
        )
        GROUP BY LOG.ACCTNO
    ) TR_DK ON TR_DK.ACCTNO = DD.ACCTNO
    WHERE INSTR(V_LISTCUSTODYCD, DD.CUSTODYCD) > 0
    AND DD.CUSTODYCD = V_CUSTODYCD
    AND DD.ACCTNO = V_ACCTNO;

    OPEN p_refcursor FOR
    SELECT NULL BUSDATE, 'Beginning balance' TXDESC, v_dauky NAMT,' ' TYPE from dual

    UNION ALL

    SELECT * FROM (
        SELECT to_char(LOG.BUSDATE,'DD/MM/RRRR') BUSDATE,REPLACE(NVL(TL1.txdesc ,LOG.TXDESC), 'BLACKLIST - ', '') TXDESC, (CASE WHEN LOG.TXTYPE = 'C' THEN LOG.NAMT ELSE - LOG.NAMT END) NAMT,LOG.TXTYPE TYPE
        FROM VW_TLLOG_ALL TL1, DDMAST DD
        JOIN VW_DDTRAN_GEN LOG ON DD.ACCTNO = LOG.ACCTNO
                               AND LOG.BUSDATE >= TO_DATE(P_FRDATE,'DD/MM/RRRR')
                               AND LOG.BUSDATE <= TO_DATE(P_TODATE,'DD/MM/RRRR')
                               AND LOG.FIELD = 'BALANCE'
                               AND LOG.TXTYPE IN ('D','C')
                               AND LOG.TLTXCD NOT IN ('6690', '6691', '6696', '6697', '6698', '6699', '6689', '6692', '6603', '6604')
                               AND LOG.TLTXCD NOT IN ('6628', '6629', '6615', '6659')
                               AND LOG.TXTYPE LIKE P_TYPE
        WHERE INSTR(v_listcustodycd, dd.CUSTODYCD) >0
        and DD.CUSTODYCD = v_custodycd
        AND DD.ACCTNO = v_ACCTNO
        AND LOG.TXDATE = TL1.TXDATE
        AND LOG.TXNUM = TL1.TXNUM
        AND TL1.TLTXCD NOT IN ('1296')
        AND NOT EXISTS (
            SELECT 1 FROM VW_TLLOG_ALL TL2
            WHERE TL2.TLTXCD IN ('6628', '6629', '6615', '6659')
            AND TL2.TXDATE = TL1.TXDATE
            AND TL2.REFTXNUM = TL1.TXNUM
        )
        ORDER BY LOG.BUSDATE, LOG.TLLOG_AUTOID, LOG.TXNUM
    );

    plog.setEndSection(pkgctx, 'PRC_GET_LIST_CASH_STATEMENT');
  EXCEPTION
    WHEN OTHERS THEN
      err_code := errnums.C_SYSTEM_ERROR;
        plog.error(pkgctx,'p_cdtype: ' || ' Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
      plog.setEndSection(pkgctx, 'PRC_GET_LIST_CASH_STATEMENT');

END PRC_GET_LIST_CASH_STATEMENT;

PROCEDURE PRC_GET_LIST_CASHBALANCE(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     P_CUSTODYCD    IN   VARCHAR2,
                     P_BANKACCTNO  IN VARCHAR2,
                     P_CURRENCY    IN   VARCHAR2,
                     P_STATUS    IN   VARCHAR2,
                     p_tlid IN VARCHAR2,
                     p_role IN VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2) as
   v_param  varchar2(4000);
   v_custodycd VARCHAR2(20);
   v_listcustodycd varchar2(4000);
   V_STATUS VARCHAR2(10);
   v_TRADINGDATE VARCHAR2(10);
   V_BANKACCTNO VARCHAR2(30);
   V_CURRENCY VARCHAR2(10);
  BEGIN
    if P_BANKACCTNO= 'ALL' THEN
      V_BANKACCTNO:='%%';
    else
      V_BANKACCTNO:=P_BANKACCTNO;
    end if;

    if P_CURRENCY= 'ALL' THEN
      V_CURRENCY:='%%';
    else
      V_CURRENCY:=P_CURRENCY;
    end if;

    if P_STATUS= 'ALL' THEN
      V_STATUS:='%%';
    else
      V_STATUS:=P_STATUS;
    end if;

    plog.debug(pkgctx, 'PRC_GET_LIST_SECURITIES_STATEMENT');
    v_param:=' PRC_GET_LIST_SECURITIES_STATEMENT: TICKER' ;

    err_code  := systemnums.C_SUCCESS;
    err_msg := 'SUCCESS';


    OPEN p_refcursor FOR

   select CF.CUSTODYCD, CF.FULLNAME, DD.AFACCTNO,DD.ACCTNO,DD.ACCOUNTTYPE,DD.CCYCD,DD.REFCASAACCT,
       DD.BALANCE,DD.HOLDBALANCE,(DD.BALANCE+DD.HOLDBALANCE)TOTALBALANCE,ALLCODE.CDCONTENT STATUS,ALLCODE.EN_CDCONTENT STATUS_EN,
       DD.OPNDATE,(case when dd.clsdate is not null then to_char(dd.clsdate,'dd/MM/RRRR') else '' end) CLOSEDATE, A2.CDCONTENT ISDEFAULT
    from DDMAST DD,AFMAST AF, CFMAST CF, ALLCODE, ALLCODE A2,userlogin u
    where u.username=P_TLID
    and ( INSTR(u.listcustodycd, cf.CUSTODYCD) >0 or cf.CUSTODYCD =u.custodycd)
    and CF.custid = AF.CUSTID AND AF.ACCTNO = DD.AFACCTNO
    AND ALLCODE.CDTYPE = 'CI' AND ALLCODE.CDNAME = 'STATUS'
    AND ALLCODE.cdval = DD.STATUS
    AND A2.CDNAME='YESNO' AND A2.CDVAL=DD.ISDEFAULT and A2.cdtype = 'SY'
    AND CF.CUSTODYCD = P_CUSTODYCD
    AND DD.REFCASAACCT like '%%'
    AND DD.CCYCD like V_CURRENCY
    AND DD.STATUS like V_STATUS ;


    plog.setEndSection(pkgctx, 'PRC_GET_LIST_CASHBALANCE');
  EXCEPTION
    WHEN OTHERS THEN
      err_code := errnums.C_SYSTEM_ERROR;
        plog.error(pkgctx,'p_cdtype: ' || ' Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
      plog.setEndSection(pkgctx, 'PRC_GET_LIST_CASHBALANCE');

END PRC_GET_LIST_CASHBALANCE;

PROCEDURE PRC_GET_ALERT_NOTICE(p_2 out CLOB) as

BEGIN
--SELECT EncodeBASE64(fileblob) into p_2  FROM fileupload  where autoid = '1422';
--SELECT fileblob into p_2  FROM fileupload  where autoid = '606';
    select EncodeBASE64(fileblob) into p_2 from fileupload where doctype ='Notice' and rownum=1 order by txdate desc;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
      p_2 := null;
END PRC_GET_ALERT_NOTICE;
 PROCEDURE vinh_test1(p_2 out BLOB) as

BEGIN
SELECT fileblob into p_2  FROM fileupload  where autoid = '606';
END;
PROCEDURE PRC_GET_LIST_TEMPLATE_IMPORT(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     p_tlid IN VARCHAR2,
                     p_role IN VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2) as
   v_param  varchar2(4000);

  BEGIN


    plog.debug(pkgctx, 'PRC_GET_LIST_TEMPLATE_IMPORT');
    v_param:=' PRC_GET_LIST_TEMPLATE_IMPORT' ;

    err_code  := systemnums.C_SUCCESS;
    err_msg := 'SUCCESS';


    OPEN p_refcursor FOR

 --select filename,filepath from filemaster where filecode in ('I069','I072','I079','I080');
    select filecode,name,en_name NAME_EN,filename,appmode from templates_import_online
    where isvisible='Y'
     order by odrnum ;


    plog.setEndSection(pkgctx, 'PRC_GET_LIST_TEMPLATE_IMPORT');
  EXCEPTION
    WHEN OTHERS THEN
      err_code := errnums.C_SYSTEM_ERROR;
        plog.error(pkgctx,'p_cdtype: ' || ' Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
      plog.setEndSection(pkgctx, 'PRC_GET_LIST_TEMPLATE_IMPORT');

END PRC_GET_LIST_TEMPLATE_IMPORT;
PROCEDURE PRC_GET_STOCKS(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     P_CFICODE       in varchar2,
                     p_err_code      IN OUT VARCHAR2,
                     p_err_param     IN OUT VARCHAR2) AS
  l_CFICODE varchar2(20);
  v_param  varchar2(4000);
  BEGIN

    plog.setBeginSection(pkgctx, 'PRC_GET_STOCKS');
    p_err_code  := systemnums.C_SUCCESS;
    p_err_param := 'SUCCESS';

     --plog.setBeginSection(pkgctx, 'PRC_GET_STOCKS');
     v_param:='PRC_GET_STOCKS P_CFICODE= '||P_CFICODE
                             ;


   OPEN p_refcursor FOR
select l.* ,  a.en_cdcontent cficode from (
  SELECT s.symbol CDVAL,s.symbol EN_CDCONTENT,s.symbol CDCONTENT,s.symbol||' - '||i.fullname CDCONTENTFULLNAME,
                    s.symbol||' - '||i.en_fullname EN_CDCONTENTFULLNAME,'M' pricetypeval,'Market' pricetype,' ' unitpriceval,
                    ' ' unitprice,s.isincode,s.sectype ,
                       CASE WHEN s.sectype ='006' AND s.bondtype = '005' THEN 'DB'
                                WHEN s.sectype ='006' AND s.bondtype = '001' THEN 'GB'
                                WHEN s.sectype ='006' AND s.bondtype = '002' THEN 'MB'
                                WHEN s.sectype ='006' AND s.bondtype = '003' THEN 'GO'
                                WHEN s.sectype ='006' AND s.bondtype = '004' THEN 'DC'
                                WHEN s.sectype ='015' AND s.coveredwarranttype ='C' THEN 'CC'
                                WHEN s.sectype ='015' AND s.coveredwarranttype ='P' THEN 'CP'
                                WHEN s.sectype ='001' THEN 'ES'
                                WHEN s.sectype ='002' THEN 'EP'
                                WHEN s.sectype ='008' THEN 'EF'
                                WHEN s.sectype ='009' THEN 'TD'
                                WHEN s.sectype ='011' THEN 'CW'
                                WHEN s.sectype ='012' THEN 'BB'
                                WHEN s.sectype ='013' THEN 'CD'
                                WHEN s.sectype ='005' THEN 'FF'
                                ELSE 'ES' END cficodeval,
                        CASE WHEN s.tradeplace ='001' THEN 'HSX' WHEN s.tradeplace ='002' THEN 'HNX'
                                WHEN s.tradeplace ='003' THEN 'OTC' WHEN s.tradeplace ='005' THEN 'UPCOM'
                                WHEN s.tradeplace ='006' THEN 'WFT' WHEN s.tradeplace ='010' THEN 'GBX' ELSE 'HNX' END exchange,s.tradeplace

                     FROM sbsecurities s,issuers i,sbcurrency sb
                      WHERE s.issuerid = i.issuerid and s.status='Y' and s.ccycd = sb.ccycd) l,allcode a
                       where a.cdname = 'CFICODE' and a.cdtype = 'SB' and a.cdval = l.cficodeval
                        union all
                          select 'Currency' || c.shortcd CDVAL,c.shortcd EN_CDCONTENT,c.shortcd CDCONTENT,c.shortcd||' - '||c.ccyname CDCONTENTFULLNAME,c.shortcd||' - '||c.ccyname EN_CDCONTENTFULLNAME,
                            'C' pricetypeval,'Currency' pricetype,'VND' unitpriceval,'VND' unitprice,' ' isincode,' ' sectype,' ' cficodeval,' ' exchange,' ' tradeplace,' ' cficode from sbcurrency c where c.active='Y' and shortcd in('VND','USD');


    plog.setEndSection(pkgctx, 'PRC_GET_STOCKS');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error(pkgctx,'Err: ' || SQLERRM || ' Trace: ' || dbms_utility.format_error_backtrace );
      plog.setEndSection(pkgctx, 'PRC_GET_STOCKS');
  END PRC_GET_STOCKS;
 PROCEDURE PRC_GET_DEPOSITORY_MEMBER (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                      P_tlid      IN  VARCHAR2,
                       P_ROLE      IN  VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2) as
   v_param  varchar2(4000);

  BEGIN

    plog.debug(pkgctx, 'PRC_GET_DEPOSITORY_MEMBER');
    v_param:=' PRC_GET_DEPOSITORY_MEMBER: '  ;

    err_code  := systemnums.C_SUCCESS;
    err_msg := 'SUCCESS';

    OPEN p_refcursor FOR
        select depositid CDVAL,depositid || '-' || fullname CDCONTENT,depositid || '-' || fullname EN_CDCONTENT  from deposit_member;

  EXCEPTION
    WHEN OTHERS THEN
      err_code := errnums.C_SYSTEM_ERROR;
      plog.setEndSection(pkgctx, 'PRC_GET_DEPOSITORY_MEMBER');

END PRC_GET_DEPOSITORY_MEMBER;
PROCEDURE PRC_GET_TICKER_DEPOSIT (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                      P_CUSTODYCD      IN  VARCHAR2,
                      P_tlid      IN  VARCHAR2,
                       P_ROLE      IN  VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2) as
   v_param  varchar2(4000);
  BEGIN

    plog.debug(pkgctx, 'PRC_GET_TICKER_DEPOSIT');
    v_param:=' PRC_GET_TICKER_DEPOSIT: '  ;

    err_code  := systemnums.C_SUCCESS;
    err_msg := 'SUCCESS';
    OPEN p_refcursor FOR
            select sb.symbol CDVAL,sb.symbol ||' - ' || iss.fullname CDCONTENT,sb.symbol ||' - ' || iss.en_fullname EN_CDCONTENT
            from issuers iss,sbsecurities sb,semast se,cfmast cf
            where iss.issuerid=sb.issuerid
            and se.codeid=sb.codeid
            and se.custid=cf.custid
            and sb.status='Y'
            and sb.TRADEPLACE <> '006'
            and sb.SECTYPE <> '004'
            and cf.custodycd=P_CUSTODYCD;

  EXCEPTION
    WHEN OTHERS THEN
      err_code := errnums.C_SYSTEM_ERROR;
      plog.setEndSection(pkgctx, 'PRC_GET_TICKER_DEPOSIT');

END PRC_GET_TICKER_DEPOSIT;
 procedure PRC_USERS1(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     p_user      varchar2,
                     p_role      varchar2,
                     p_rolemaker      varchar2,
                     p_roleapprove      varchar2,
                     p_custodycd      varchar2,
                     p_listcustodycd      varchar2,
                     p_listsymbol      varchar2,
                     p_action      varchar2,
                     p_err_code      in out varchar2,
                     p_err_param     in out varchar2) as
    l_user varchar2(50);
    l_role varchar2(50);
    l_rolemaker varchar2(50);
    l_roleapprove varchar2(50);
    l_custodycd varchar2(50);
    l_listcustodycd varchar2(4000);
    l_listsymbol varchar2(4000);
  begin

    plog.setBeginSection(pkgctx, 'PRC_USERS');
    plog.debug(pkgctx, 'PRC_USERS'|| 'p_user:'||p_user);

    p_err_code  := systemnums.C_SUCCESS;
    p_err_param := 'SUCCESS';
    If p_user is null or length(p_user)=0 then
        l_user :='%';
    ELSE
        l_user:=p_user;
    End if;

    If p_role is null or length(p_role)=0 then
        l_role :='%';
    ELSE
        l_role:=p_role;
    End if;

    If p_rolemaker is null or length(p_rolemaker)=0 then
        l_rolemaker :='%';
    ELSE
        l_rolemaker:=p_rolemaker;
    End if;

    If p_roleapprove is null or length(p_roleapprove)=0 then
        l_roleapprove :='%';
    ELSE
        l_roleapprove:=p_roleapprove;
    End if;

    If p_custodycd is null or length(p_custodycd)=0 then
        l_custodycd :='%';
    ELSE
        l_custodycd:=p_custodycd;
    End if;

    If p_listcustodycd is null or length(p_listcustodycd)=0 then
        l_listcustodycd :='%';
    ELSE
        l_listcustodycd:=p_listcustodycd;
    End if;

        If p_listsymbol is null or length(p_listsymbol)=0 then
        l_listsymbol :='%';
    ELSE
        l_listsymbol:=p_listsymbol;
    End if;


    if p_action   = 'check' then

        Open p_refcursor for
        select u.username || u.role USERKEY,u.username tlid,u.username userid,u.username tlfullname,'' mbcode ,'Y' active,
            'YYYYY', 'Y' status, '' department ,
            '' tltitle, '' idcode, '' mobile, '' email,'' description,
            'SHB' dbcode,
            (CASE WHEN U.ROLE IN ('AP','CTCK') THEN U.ROLE ELSE NVL(U.ROLECD, '') END) rolecode,
            nvl(t.listsymbol,'') listsymbol,u.listcustodycd,u.ROLE,u.custodycd,
            (CASE WHEN U.ROLE IN ('AP','CTCK') THEN U.ROLE ELSE NVL(U.ROLEMAKER,'') END) rolemaker,
            (CASE WHEN U.ROLE IN ('AP','CTCK') THEN 'CB' ELSE NVL(U.ROLEAPPROVE,'') END) roleapprove
        FROM userlogin u,
        (select u.username,
        listagg(f.symbol,',') within group (order by u.username) as listsymbol
        from userlogin u, cbfafund f
        where instr(NVL(u.listcustodycd,u.custodycd),f.custodycd)>0 group by u.username)t
        where  u.status ='A'
        AND u.username = p_user
        AND u.username = t.username(+)
        AND ((U.ROLE = P_ROLE) OR (U.ROLE IS NULL AND P_ROLE IS NULL))
        AND (((CASE WHEN U.ROLE IN ('AP','CTCK') THEN U.ROLE ELSE NVL(U.ROLEMAKER,'') END) = P_ROLEMAKER) OR (U.ROLEMAKER IS NULL AND P_ROLEMAKER IS NULL))
        AND (((CASE WHEN U.ROLE IN ('AP','CTCK') THEN 'CB' ELSE NVL(U.ROLEAPPROVE,'') END) = P_ROLEAPPROVE) OR (U.ROLEAPPROVE IS NULL AND P_ROLEAPPROVE IS NULL))
        --and ((u.rolemaker = p_rolemaker) OR (u.rolemaker is NULL and p_rolemaker is NULL) OR p_rolemaker IN ('AP','CTCK'))
        --and ((u.roleapprove = p_roleapprove) OR (u.roleapprove is NULL and p_roleapprove is NULL) OR p_roleapprove IN ('AP','CTCK'))
        and ((u.custodycd = p_custodycd) OR (u.custodycd is NULL and p_custodycd is NULL))
        and ((u.listcustodycd = p_listcustodycd) OR (u.listcustodycd is NULL and p_listcustodycd is NULL))
        and ((t.listsymbol = p_listsymbol) OR (t.listsymbol is NULL and p_listsymbol is NULL));
    ELSE
        Open p_refcursor for
        select u.username || u.role USERKEY,u.username tlid,u.username userid,u.username tlfullname,'' mbcode ,'Y' active,
            'YYYYY', 'Y' status, '' department ,
            '' tltitle, '' idcode, '' mobile, '' email,'' description,
            'SHB' dbcode,
            (CASE WHEN U.ROLE IN ('AP','CTCK') THEN U.ROLE ELSE NVL(U.ROLECD, '') END) rolecode,
            nvl(t.listsymbol,'') listsymbol,u.listcustodycd,u.ROLE,u.custodycd,
            (CASE WHEN U.ROLE IN ('AP','CTCK') THEN U.ROLE ELSE NVL(U.ROLEMAKER,'') END) rolemaker,
            (CASE WHEN U.ROLE IN ('AP','CTCK') THEN 'CB' ELSE NVL(U.ROLEAPPROVE,'') END) roleapprove
        FROM userlogin u,
        (
            select u.username,
                listagg(f.symbol,',') within group (order by u.username) as listsymbol
            from userlogin u, cbfafund f
            where instr(NVL(u.listcustodycd,u.custodycd),f.custodycd)>0 group by u.username
        )t
        where u.status ='A'
        AND u.username = p_user
        AND u.username = t.username(+);
    end if;
    plog.setEndSection(pkgctx, 'PRC_USERS');
  exception
    when others then
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error(pkgctx,'Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
      plog.setEndSection(pkgctx, 'PRC_USERS');
  end PRC_USERS1;

  PROCEDURE PRC_USER_FUNC1(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     p_tlid      varchar2,
                     p_err_code      in out varchar2,
                     p_err_param     in out varchar2) as
    l_tlid varchar2(50);

  BEGIN

    plog.setBeginSection(pkgctx, 'PRC_USER_FUNC');


    p_err_code  := systemnums.C_SUCCESS;
    p_err_param := 'SUCCESS';

    IF p_tlid IS NULL OR length(p_tlid)=0 THEN
        l_tlid :='%';
    ELSE
        l_tlid:=p_tlid;
    END IF;
    OPEN p_REFCURSOR FOR


         SELECT (',' || f.roles || ',') roles,
             f.cmdid,
             f.prid,
             f.lev,
             f.last,
             f.menutype,
             f.objname,
             f.cmdname,
             f.en_cmdname,
             f.kr_cmdname,
             'Y' IsInquiry
        FROM focmdmenu f
            order by f.cmdid asc;


    plog.setEndSection(pkgctx, 'PRC_USER_FUNC');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error(pkgctx,'Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
      plog.setEndSection(pkgctx, 'PRC_USER_FUNC');
  END PRC_USER_FUNC1;
   PROCEDURE PRC_GET_feecal_6639 (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                    P_TRANSFERTYPE    IN   VARCHAR2,
                    P_CUSTODYCD    IN   VARCHAR2,
                    P_AMT  IN  number ,
                    p_FEETYPE IN varchar2,
                    p_tlid        in varchar2,
                    p_role        in varchar2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2) as
   v_param  varchar2(4000);
  BEGIN

    plog.debug(pkgctx, 'PRC_GET_feecal_6639');
    v_param:=' PRC_GET_feecal_6639: '  ;

    err_code  := systemnums.C_SUCCESS;
    err_msg := 'SUCCESS';


    OPEN p_refcursor FOR
        select fn_feecal_6639(P_TRANSFERTYPE,P_CUSTODYCD,P_AMT,p_FEETYPE) FEECAL from dual;

  EXCEPTION
    WHEN OTHERS THEN
      err_code := errnums.C_SYSTEM_ERROR;
      plog.setEndSection(pkgctx, 'PRC_GET_feecal_6639');

END PRC_GET_feecal_6639;
 PROCEDURE PRC_GET_net_amount_6639 (p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                    P_FEETYPE    IN   VARCHAR2,
                    P_AMT    IN   number,
                    P_FEEAMT    number,
                    p_tlid        in varchar2,
                    p_role        in varchar2,
                    err_code      IN OUT VARCHAR2,
                    err_msg     IN OUT VARCHAR2) as
   v_param  varchar2(4000);
  BEGIN

    plog.debug(pkgctx, 'PRC_GET_net_amount_6639');
    v_param:=' PRC_GET_net_amount_6639: '  ;

    err_code  := systemnums.C_SUCCESS;
    err_msg := 'SUCCESS';


    OPEN p_refcursor FOR
        select fn_net_amount(P_FEETYPE,P_AMT,P_FEEAMT) NETAMOUNT from dual;
  EXCEPTION
    WHEN OTHERS THEN
      err_code := errnums.C_SYSTEM_ERROR;
      plog.setEndSection(pkgctx, 'PRC_GET_feecal_6639');

END PRC_GET_net_amount_6639;
PROCEDURE PRC_GET_LIST_OD8894(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     p_tlid IN VARCHAR2,
                     p_role IN VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2) as
   v_param  varchar2(4000);
   v_custodycd VARCHAR2(20);
   v_listcustodycd varchar2(4000);
   v_role VARCHAR2(10);
  BEGIN

    plog.debug(pkgctx, 'PRC_GET_LIST_OD8894');
    v_param:=' PRC_GET_LIST_OD8894: p_tlid' || p_tlid ;

    err_code  := systemnums.C_SUCCESS;
    err_msg := 'SUCCESS';
    Begin
    select custodycd,listcustodycd,role
        into v_custodycd,v_listcustodycd,v_role
    from userlogin
    where username = p_tlid;
    exception
        when others then
         v_custodycd := '';
         v_listcustodycd:='';
         v_role:='';
    End;
    OPEN p_refcursor FOR

select *from
(
    select 'Client' source, A1.CDCONTENT VIA,to_char(txtime,'dd/MM/RRRR')recorddate,dp.shortname ctck
            ,od.custodycd,od.sec_id symbol,A2.CDCONTENT ODTYPE,
            od.trade_date tradedate,od.settle_date settledate,od.price,od.quantity qtty, od.gross_amount grossamount, nvl(od.commission_fee,'0') fee,
            nvl(od.tax,'0')tax,fileid IDFILE,autoid,A3.CDCONTENT STATUSTEXT,A3.CDVAL STATUS
        from odmastcust od,allcode A1,deposit_member dp,allcode A2,allcode A3
        where   od.via = A1.cdval and A1.cdtype = 'OD' and A1.cdname = 'VIA' and od.via='O'
            and od.broker_code = dp.depositid
            and A2.cdname = 'EXECTYPE' and A2.cdtype = 'OD' and A2.cdval = od.trans_type
            and od.isodmast = 'N'
            and A3.cdname = 'CORDER' and A3.cdtype = 'OD' and A3.cdval = od.deltd
            --and version is not null
            and deltd <> 'Y'
)a
where   0=0
    and not exists ( select f.nvalue from
                                    tllog tl, tllogfld f where tl.txnum = f.txnum and
                                    tl.txdate = f.txdate and tl.tltxcd = '8802' and f.fldcd
                                    = '01' and tl.txstatus in('1', '4','P') and f.nvalue = a.autoid)
    and ( INSTR(v_listcustodycd, a.CUSTODYCD) >0 or a.CUSTODYCD =v_custodycd);

    plog.setEndSection(pkgctx, 'PRC_GET_LIST_OD8894');
  EXCEPTION
    WHEN OTHERS THEN
      err_code := errnums.C_SYSTEM_ERROR;
        plog.error(pkgctx,'p_cdtype: ' || ' Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
      plog.setEndSection(pkgctx, 'PRC_GET_LIST_OD8894');

END PRC_GET_LIST_OD8894;
procedure pr_auto_8802_web(p_autoid varchar2,p_deletetype varchar2,  tlid varchar2, p_reftransid  out varchar2, err_code in out varchar2, err_msg in out varchar2) IS
      l_txmsg       tx.msg_rectype;
      v_strcurrdate varchar2(20);
      v_strdesc     varchar2(1000);
      v_stren_desc  varchar2(1000);
      v_tltxcd      varchar2(10);
      p_xmlmsg      varchar2(4000);
      v_param       varchar2(1000);
      v_err_code    varchar2(10);
      p_err_message varchar2(500);
      l_txnum         varchar2(20);
      v_fullname       varchar2(1000);
      v_tlid        varchar2(50);
      v_txmsg_string    varchar2(5000);
       v_custodycd VARCHAR2(20);
       v_listcustodycd varchar2(4000);
       v_role VARCHAR2(10);
       v_count number;
       l_role varchar2(100);
BEGIN

    ------------------------
    V_ERR_CODE    := SYSTEMNUMS.C_SUCCESS;
    P_ERR_MESSAGE := 'SUCCESS';
    PLOG.SETBEGINSECTION (PKGCTX, 'pr_auto_8802_web');
    v_param   :=' pr_auto_8802_web: p_autoid' || p_autoid
                                                ||' p_deletetype '||p_deletetype
                                                ||' tlid '||tlid;

    V_TLTXCD := '8802';

    p_reftransid :='';
    v_count:=0;
    ------------------------
        Begin
    select custodycd,listcustodycd,role
        into v_custodycd,v_listcustodycd,v_role
    from userlogin
    where username = tlid;
    exception
        when others then
         v_custodycd := '';
         v_listcustodycd:='';
         v_role:='';
    End;
    ------------------------
    BEGIN
    SELECT TXDESC, EN_TXDESC
    INTO V_STRDESC, V_STREN_DESC
    FROM TLTX
    WHERE TLTXCD = V_TLTXCD;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            V_STRDESC:= null;
            V_STREN_DESC:= null;
    END;
    ------------------------
    SELECT TO_DATE (varvalue, systemnums.c_date_format)
    INTO v_strCURRDATE
    FROM sysvar
    WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

    ------------------------
    BEGIN
        SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD (SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
        INTO L_TXNUM
        FROM DUAL;
    EXCEPTION
          WHEN NO_DATA_FOUND THEN
            L_TXNUM:= null;
    END;
    ------------------------
    L_TXMSG.MSGTYPE     :='T';
    L_TXMSG.LOCAL       :='N';
    L_TXMSG.TLID        :='6868';

    ------------------------
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
    INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS
    FROM DUAL;
    ------------------------


      ------------------------
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.C_DELTD_TXNORMAL;
    l_txmsg.txstatus    := txstatusnums.c_txlogged;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := 'DAY';
    l_txmsg.reftxnum    := l_txnum;
    l_txmsg.txdate      := to_date(v_strcurrdate,systemnums.c_date_format);
    l_txmsg.busdate     := to_date(v_strcurrdate,systemnums.c_date_format);
    l_txmsg.tltxcd      := v_tltxcd;
    l_txmsg.nosubmit    := '1';
    l_txmsg.ovrrqd      := '@0';

    --------------------------SET CAC FIELD GIAO DICH-------------------------------

    --trung.luu:
    select role into l_role from userlogin where username = tlid;

        DECLARE
        CURSOR c_8802 IS
            select *from
            (
            select 'Client' source, A1.CDCONTENT VIA,to_char(txtime,'dd/MM/RRRR')recorddate,dp.shortname ctck
                    ,od.custodycd,od.sec_id symbol,A2.CDCONTENT ODTYPE,
                    od.trade_date tradedate,od.settle_date settledate,od.price,od.quantity qtty, od.gross_amount grossamount, nvl(od.commission_fee,'0') fee,
                    nvl(od.tax,'0')tax,fileid IDFILE,autoid,A3.CDCONTENT STATUSTEXT,A3.CDVAL STATUS
                from odmastcust od,allcode A1,deposit_member dp,allcode A2,allcode A3
                where   od.via = A1.cdval and A1.cdtype = 'OD' and A1.cdname = 'VIA' and od.via='O'
                    and od.broker_code = dp.depositid
                    and A2.cdname = 'EXECTYPE' and A2.cdtype = 'OD' and A2.cdval = od.trans_type
                    and od.isodmast = 'N'
                    and A3.cdname = 'CORDER' and A3.cdtype = 'OD' and A3.cdval = od.deltd
                    --and version is not null
                    and deltd <> 'Y'
            )a
            where  not exists ( select f.nvalue from
                                        tllog tl, tllogfld f where tl.txnum = f.txnum and
                                        tl.txdate = f.txdate and tl.tltxcd = '8802' and f.fldcd
                                        = '01' and tl.txstatus in('1', '4','P') and f.nvalue = a.autoid)
            and ( INSTR(v_listcustodycd, a.CUSTODYCD) >0 or a.CUSTODYCD =v_custodycd)
            and autoid=p_autoid;

        BEGIN
            FOR rec IN c_8802
            LOOP
                v_count:=v_count+1;

                --01    Auto ID   C
                 l_txmsg.txfields ('01').defname   := 'AUTOID';
                 l_txmsg.txfields ('01').TYPE      := 'C';
                 l_txmsg.txfields ('01').value      := rec.AUTOID;
                --06    Ngu?n ghi nh?n   C
                 l_txmsg.txfields ('06').defname   := 'SOURCE';
                 l_txmsg.txfields ('06').TYPE      := 'C';
                 l_txmsg.txfields ('06').value      := rec.SOURCE;
                --03    K?nh ghi nh?n   C
                 l_txmsg.txfields ('03').defname   := 'VIA';
                 l_txmsg.txfields ('03').TYPE      := 'C';
                 l_txmsg.txfields ('03').value      := rec.VIA;
                --04    Ng?y ghi nh?n   C
                 l_txmsg.txfields ('04').defname   := 'RECORDDATE';
                 l_txmsg.txfields ('04').TYPE      := 'C';
                 l_txmsg.txfields ('04').value      := rec.RECORDDATE;
                --24    CTCK   C
                 l_txmsg.txfields ('24').defname   := 'BROKER';
                 l_txmsg.txfields ('24').TYPE      := 'C';
                 l_txmsg.txfields ('24').value      := rec.CTCK;
                --88    S? TK   C
                 l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                 l_txmsg.txfields ('88').TYPE      := 'C';
                 l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
                --07    M? CK   C
                 l_txmsg.txfields ('07').defname   := 'SYMBOL';
                 l_txmsg.txfields ('07').TYPE      := 'C';
                 l_txmsg.txfields ('07').value      := rec.SYMBOL;
                --26    Lo?i GD   C
                 l_txmsg.txfields ('26').defname   := 'TYPEORDER';
                 l_txmsg.txfields ('26').TYPE      := 'C';
                 l_txmsg.txfields ('26').value      := rec.ODTYPE;
                --32    Lo?i x?a   C
                 l_txmsg.txfields ('32').defname   := 'CANCEL';
                 l_txmsg.txfields ('32').TYPE      := 'C';
                 l_txmsg.txfields ('32').value      := p_deletetype;
                --23    Ng?y GD   C
                 l_txmsg.txfields ('23').defname   := 'TRADEDATE';
                 l_txmsg.txfields ('23').TYPE      := 'C';
                 l_txmsg.txfields ('23').value      := rec.TRADEDATE;
                --29    Ng?y thanh to?n   C
                 l_txmsg.txfields ('29').defname   := 'SETTDATE';
                 l_txmsg.txfields ('29').TYPE      := 'C';
                 l_txmsg.txfields ('29').value      := rec.settledate;
                --10    Gi?   C
                 l_txmsg.txfields ('10').defname   := 'PRICE';
                 l_txmsg.txfields ('10').TYPE      := 'C';
                 l_txmsg.txfields ('10').value      := rec.PRICE;
                --09    S? lu?ng   C
                 l_txmsg.txfields ('09').defname   := 'QTTY';
                 l_txmsg.txfields ('09').TYPE      := 'C';
                 l_txmsg.txfields ('09').value      := rec.QTTY;
                --13    Gi? tr? l?nh   C
                 l_txmsg.txfields ('13').defname   := 'GROSSAMOUNT';
                 l_txmsg.txfields ('13').TYPE      := 'C';
                 l_txmsg.txfields ('13').value      := rec.GROSSAMOUNT;
                --11    Ph?   C
                 l_txmsg.txfields ('11').defname   := 'FEE';
                 l_txmsg.txfields ('11').TYPE      := 'C';
                 l_txmsg.txfields ('11').value      := rec.FEE;
                --27    Thu?   C
                 l_txmsg.txfields ('27').defname   := 'TAX';
                 l_txmsg.txfields ('27').TYPE      := 'C';
                 l_txmsg.txfields ('27').value      := rec.TAX;
                --28    ID file   C
                 l_txmsg.txfields ('28').defname   := 'IDFILE';
                 l_txmsg.txfields ('28').TYPE      := 'C';
                 l_txmsg.txfields ('28').value      := rec.IDFILE;
                --31    Tr?ng th?i   C
                 l_txmsg.txfields ('31').defname   := 'STATUS';
                 l_txmsg.txfields ('31').TYPE      := 'C';
                 l_txmsg.txfields ('31').value      := rec.STATUS;
                --30    Di?n gi?i   C
                 l_txmsg.txfields ('30').defname   := 'DESC';
                 l_txmsg.txfields ('30').TYPE      := 'C';
                 l_txmsg.txfields ('30').value      := V_STREN_DESC;
                BEGIN
                    SELECT TLID
                    INTO v_tlid
                    FROM cfmast
                    where custodycd=rec.CUSTODYCD;
                    EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                           v_tlid:= null;
                 END;

                 BEGIN
                    SELECT BRID
                    INTO L_TXMSG.BRID
                    FROM TLPROFILES WHERE TLID=v_tlid;
                 EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                       L_TXMSG.BRID:= null;
                 END;
                     ----set txnum
                begin
                    select l_txmsg.brid || lpad(seq_txnum.nextval, 6, '0')
                        into l_txmsg.txnum
                    from dual;
                exception
                when no_data_found then
                   l_txmsg.txnum:= null;
                end;
                p_reftransid :='['|| to_char( l_txmsg.txdate,systemnums.c_date_format)  ||']['||l_txmsg.txnum||']';

            End loop;

            IF v_count =0 THEN
                err_code:=errnums.C_BIZ_RULE_INVALID;
                ROLLBACK;
                PLOG.SETENDSECTION(PKGCTX, 'PR_AUTO_8802_WEB');
                RETURN;
            END IF;
        end;

    v_txmsg_string :=txpks_msg.fn_obj2xml(l_txmsg);
    err_code:=txpks_#8802.fn_txProcess(v_txmsg_string, v_err_code, p_err_message);
    --------------------------------------------------------------------------------
    IF err_code <>SYSTEMNUMS.C_SUCCESS THEN
        PLOG.ERROR(PKGCTX,
           V_PARAM || ' run ' || V_TLTXCD || ' got ' || ERR_CODE || ':' ||
           P_ERR_MESSAGE);

        err_msg :=P_ERR_MESSAGE;
        ROLLBACK;
        PLOG.SETENDSECTION(PKGCTX, 'PR_AUTO_8802_WEB');
        RETURN;
    END IF;

    PR_LOG_USERNAME(l_txmsg, tlid, 'C');

    pr_generate_otp('TRANS',p_reftransid,  TLID, '', '','N', err_code, err_MSG);

--------------------------------------------------------------------------------
 PLOG.SETENDSECTION(PKGCTX, 'PR_AUTO_8802_WEB');
 EXCEPTION
    WHEN OTHERS THEN
        V_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.ERROR(PKGCTX,
                   ' Err: ' || SQLERRM || ' Trace: ' ||
                   DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

        PLOG.SETENDSECTION(PKGCTX, 'PR_AUTO_8802_WEB');
        ERR_CODE   := V_ERR_CODE;
END PR_AUTO_8802_WEB;

procedure PR_AUTO_8802_WEB_BROKER(p_autoid varchar2,p_deletetype varchar2,  tlid varchar2, p_reftransid  out varchar2, err_code in out varchar2, err_msg in out varchar2) IS
      l_txmsg       tx.msg_rectype;
      v_strcurrdate varchar2(20);
      v_strdesc     varchar2(1000);
      v_stren_desc  varchar2(1000);
      v_tltxcd      varchar2(10);
      p_xmlmsg      varchar2(4000);
      v_param       varchar2(1000);
      v_err_code    varchar2(10);
      p_err_message varchar2(500);
      l_txnum         varchar2(20);
      v_fullname       varchar2(1000);
      v_tlid        varchar2(50);
      v_txmsg_string    varchar2(5000);
       v_custodycd VARCHAR2(20);
       v_listcustodycd varchar2(4000);
       v_role VARCHAR2(10);
       v_count number;
       l_role varchar2(100);
BEGIN

    ------------------------
    V_ERR_CODE    := SYSTEMNUMS.C_SUCCESS;
    P_ERR_MESSAGE := 'SUCCESS';
    PLOG.SETBEGINSECTION (PKGCTX, 'PR_AUTO_8802_WEB_BROKER');
    v_param   :=' PR_AUTO_8802_WEB_BROKER: p_autoid' || p_autoid
                                                ||' p_deletetype '||p_deletetype
                                                ||' tlid '||tlid;

    V_TLTXCD := '8802';

    p_reftransid :='';
    v_count:=0;
    ------------------------
        Begin
    select custodycd,listcustodycd,role
        into v_custodycd,v_listcustodycd,v_role
    from userlogin
    where username = tlid;
    exception
        when others then
         v_custodycd := '';
         v_listcustodycd:='';
         v_role:='';
    End;
    ------------------------
    BEGIN
    SELECT TXDESC, EN_TXDESC
    INTO V_STRDESC, V_STREN_DESC
    FROM TLTX
    WHERE TLTXCD = V_TLTXCD;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            V_STRDESC:= null;
            V_STREN_DESC:= null;
    END;
    ------------------------
    SELECT TO_DATE (varvalue, systemnums.c_date_format)
    INTO v_strCURRDATE
    FROM sysvar
    WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

    ------------------------
    BEGIN
        SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD (SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
        INTO L_TXNUM
        FROM DUAL;
    EXCEPTION
          WHEN NO_DATA_FOUND THEN
            L_TXNUM:= null;
    END;
    ------------------------
    L_TXMSG.MSGTYPE     :='T';
    L_TXMSG.LOCAL       :='N';
    L_TXMSG.TLID        :='6868';

    ------------------------
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
    INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS
    FROM DUAL;
    ------------------------


      ------------------------
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.C_DELTD_TXNORMAL;
    l_txmsg.txstatus    := txstatusnums.c_txlogged;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := 'DAY';
    l_txmsg.reftxnum    := l_txnum;
    l_txmsg.txdate      := to_date(v_strcurrdate,systemnums.c_date_format);
    l_txmsg.busdate     := to_date(v_strcurrdate,systemnums.c_date_format);
    l_txmsg.tltxcd      := v_tltxcd;
    l_txmsg.nosubmit    := '1';
    l_txmsg.ovrrqd      := '@0';

    --------------------------SET CAC FIELD GIAO DICH-------------------------------

    FOR rec IN (
        select *from
        (
            select 'Broker' source, A1.CDCONTENT VIA,to_char(txtime,'dd/MM/RRRR')recorddate,dp.shortname ctck
            ,od.custodycd,od.sec_id symbol,A2.CDCONTENT ODTYPE,
            od.trade_date tradedate,od.settle_date settledate,od.price,od.quantity qtty, od.gross_amount grossamount, nvl(od.commission_fee,'0') fee,
            nvl(od.tax,'0')tax,fileid IDFILE,autoid,A3.CDCONTENT STATUSTEXT,A3.CDVAL STATUS
            from odmastcmp od,allcode A1,deposit_member dp,allcode A2,allcode A3
            where   od.via = A1.cdval and A1.cdtype = 'OD' and A1.cdname = 'VIA' and od.via='O'
            and od.broker_code = dp.depositid
            and A2.cdname = 'EXECTYPE' and A2.cdtype = 'OD' and A2.cdval = od.trans_type
            and od.isodmast = 'N'
            and A3.cdname = 'CORDER' and A3.cdtype = 'OD' and A3.cdval = od.deltd
            --and version is not null
            and deltd <> 'Y'
        )a
        where not exists(
            select f.nvalue
            from tllog tl, tllogfld f
            where tl.txnum = f.txnum and tl.txdate = f.txdate
            and tl.tltxcd = '8802'
            and f.fldcd = '01'
            and tl.deltd = 'N'
            and tl.txstatus in('1', '4', 'P')
            and f.nvalue = a.autoid
        )
        and (INSTR(v_listcustodycd, a.CUSTODYCD) >0 or a.CUSTODYCD =v_custodycd)
        and autoid=p_autoid
    ) LOOP
        v_count:=v_count+1;

        --01    Auto ID   C
        l_txmsg.txfields ('01').defname   := 'AUTOID';
        l_txmsg.txfields ('01').TYPE      := 'C';
        l_txmsg.txfields ('01').value      := rec.AUTOID;
        --06    Ngu?n ghi nh?n   C
        l_txmsg.txfields ('06').defname   := 'SOURCE';
        l_txmsg.txfields ('06').TYPE      := 'C';
        l_txmsg.txfields ('06').value      := rec.SOURCE;
        --03    K?nh ghi nh?n   C
        l_txmsg.txfields ('03').defname   := 'VIA';
        l_txmsg.txfields ('03').TYPE      := 'C';
        l_txmsg.txfields ('03').value      := rec.VIA;
        --04    Ng?y ghi nh?n   C
        l_txmsg.txfields ('04').defname   := 'RECORDDATE';
        l_txmsg.txfields ('04').TYPE      := 'C';
        l_txmsg.txfields ('04').value      := rec.RECORDDATE;
        --24    CTCK   C
        l_txmsg.txfields ('24').defname   := 'BROKER';
        l_txmsg.txfields ('24').TYPE      := 'C';
        l_txmsg.txfields ('24').value      := rec.CTCK;
        --88    S? TK   C
        l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
        l_txmsg.txfields ('88').TYPE      := 'C';
        l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
        --07    M? CK   C
        l_txmsg.txfields ('07').defname   := 'SYMBOL';
        l_txmsg.txfields ('07').TYPE      := 'C';
        l_txmsg.txfields ('07').value      := rec.SYMBOL;
        --26    Lo?i GD   C
        l_txmsg.txfields ('26').defname   := 'TYPEORDER';
        l_txmsg.txfields ('26').TYPE      := 'C';
        l_txmsg.txfields ('26').value      := rec.ODTYPE;
        --32    Lo?i x?a   C
        l_txmsg.txfields ('32').defname   := 'CANCEL';
        l_txmsg.txfields ('32').TYPE      := 'C';
        l_txmsg.txfields ('32').value      := p_deletetype;
        --23    Ng?y GD   C
        l_txmsg.txfields ('23').defname   := 'TRADEDATE';
        l_txmsg.txfields ('23').TYPE      := 'C';
        l_txmsg.txfields ('23').value      := rec.TRADEDATE;
        --29    Ng?y thanh to?n   C
        l_txmsg.txfields ('29').defname   := 'SETTDATE';
        l_txmsg.txfields ('29').TYPE      := 'C';
        l_txmsg.txfields ('29').value      := rec.settledate;
        --10    Gi?   C
        l_txmsg.txfields ('10').defname   := 'PRICE';
        l_txmsg.txfields ('10').TYPE      := 'C';
        l_txmsg.txfields ('10').value      := rec.PRICE;
        --09    S? lu?ng   C
        l_txmsg.txfields ('09').defname   := 'QTTY';
        l_txmsg.txfields ('09').TYPE      := 'C';
        l_txmsg.txfields ('09').value      := rec.QTTY;
        --13    Gi? tr? l?nh   C
        l_txmsg.txfields ('13').defname   := 'GROSSAMOUNT';
        l_txmsg.txfields ('13').TYPE      := 'C';
        l_txmsg.txfields ('13').value      := rec.GROSSAMOUNT;
        --11    Ph?   C
        l_txmsg.txfields ('11').defname   := 'FEE';
        l_txmsg.txfields ('11').TYPE      := 'C';
        l_txmsg.txfields ('11').value      := rec.FEE;
        --27    Thu?   C
        l_txmsg.txfields ('27').defname   := 'TAX';
        l_txmsg.txfields ('27').TYPE      := 'C';
        l_txmsg.txfields ('27').value      := rec.TAX;
        --28    ID file   C
        l_txmsg.txfields ('28').defname   := 'IDFILE';
        l_txmsg.txfields ('28').TYPE      := 'C';
        l_txmsg.txfields ('28').value      := rec.IDFILE;
        --31    Tr?ng th?i   C
        l_txmsg.txfields ('31').defname   := 'STATUS';
        l_txmsg.txfields ('31').TYPE      := 'C';
        l_txmsg.txfields ('31').value      := rec.STATUS;
        --30    Di?n gi?i   C
        l_txmsg.txfields ('30').defname   := 'DESC';
        l_txmsg.txfields ('30').TYPE      := 'C';
        l_txmsg.txfields ('30').value      := V_STREN_DESC;

        BEGIN
            SELECT TLID INTO v_tlid
            FROM cfmast
            where custodycd=rec.CUSTODYCD;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_tlid:= null;
        END;

        BEGIN
            SELECT BRID INTO L_TXMSG.BRID
            FROM TLPROFILES
            WHERE TLID=v_tlid;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            L_TXMSG.BRID:= null;
        END;
        ----set txnum
        begin
            select l_txmsg.brid || lpad(seq_txnum.nextval, 6, '0')
            into l_txmsg.txnum
            from dual;
        exception
        when no_data_found then
            l_txmsg.txnum:= null;
        end;
        p_reftransid :='['|| to_char( l_txmsg.txdate,systemnums.c_date_format)  ||']['||l_txmsg.txnum||']';

    End loop;

    IF v_count = 0 THEN
        err_code:=errnums.C_BIZ_RULE_INVALID;
        ROLLBACK;
        PLOG.SETENDSECTION(PKGCTX, 'PR_AUTO_8802_WEB_BROKER');
        RETURN;
    END IF;

    v_txmsg_string :=txpks_msg.fn_obj2xml(l_txmsg);
    err_code:=txpks_#8802.fn_txProcess(v_txmsg_string, v_err_code, p_err_message);
    --------------------------------------------------------------------------------
    IF err_code <>SYSTEMNUMS.C_SUCCESS THEN
        PLOG.ERROR(PKGCTX,
           V_PARAM || ' run ' || V_TLTXCD || ' got ' || ERR_CODE || ':' ||
           P_ERR_MESSAGE);

        err_msg :=P_ERR_MESSAGE;
        ROLLBACK;
        PLOG.SETENDSECTION(PKGCTX, 'PR_AUTO_8802_WEB_BROKER');
        RETURN;
    END IF;

    PR_LOG_USERNAME(l_txmsg, tlid, 'C');

    pr_generate_otp('TRANS',p_reftransid,  TLID, '', '','N', err_code, err_MSG);

--------------------------------------------------------------------------------
 PLOG.SETENDSECTION(PKGCTX, 'PR_AUTO_8802_WEB_BROKER');
 EXCEPTION
    WHEN OTHERS THEN
        V_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.ERROR(PKGCTX,
                   ' Err: ' || SQLERRM || ' Trace: ' ||
                   DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

        PLOG.SETENDSECTION(PKGCTX, 'PR_AUTO_8802_WEB_BROKER');
        ERR_CODE   := V_ERR_CODE;
END PR_AUTO_8802_WEB_BROKER;

PROCEDURE PRC_GET_LIST_OD0012(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     p_tlid IN VARCHAR2,
                     p_role IN VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2) as
   v_param  varchar2(4000);
   v_custodycd VARCHAR2(20);
   v_listcustodycd varchar2(4000);
   v_role VARCHAR2(10);
         v_strdesc     varchar2(1000);
      v_stren_desc  varchar2(1000);
  BEGIN

    plog.debug(pkgctx, 'PRC_GET_LIST_OD0012');
    v_param:=' PRC_GET_LIST_OD0012: p_tlid' || p_tlid ;

    err_code  := systemnums.C_SUCCESS;
    err_msg := 'SUCCESS';
    Begin
    select custodycd,listcustodycd,role
        into v_custodycd,v_listcustodycd,v_role
    from userlogin
    where username = p_tlid;
    exception
        when others then
         v_custodycd := '';
         v_listcustodycd:='';
         v_role:='';
    End;

    BEGIN
    SELECT TXDESC, EN_TXDESC
    INTO V_STRDESC, V_STREN_DESC
    FROM TLTX
    WHERE TLTXCD = '8895';
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            V_STRDESC:= null;
            V_STREN_DESC:= null;
    END;

    OPEN p_refcursor FOR
    select  to_char(eq.txdate,'dd/MM/RRRR') txdate,OD.ORDERID txnum,od.custodycd,cf.fullname,od.codeid ETFID,sb.symbol ETFIDMA ,ISS.en_cdcontent ETFNAME,A1.en_cdcontent type,od.execqtty ETFQTTY
        ,od.nav NAV ,od.execamt AMOUNT, od.feeamt fee, od.taxrate tax,od.orderid ORDERID,od.exectype,V_STREN_DESC "DESC",TL1.msgacct FILEID
        from  odmast od,cfmast cf ,sbsecurities sb,allcode A1,(SELECT ISSUERID,fullname CDCONTENT,en_fullname EN_CDCONTENT FROM ISSUERS ISS ) ISS,
            (
                select txdate,txnum,orderid,status,sum(qtty) qt
                from etfwsap
                    group by txdate,txnum,orderid,status
            )eq,tllogall tl1,tllogall tl2
            where   od.custodycd = cf.custodycd
                and od.orderid = eq.ORDERID
                and eq.status = 'P'
                and sb.codeid = od.codeid
                and SB.ISSUERID = ISS.ISSUERID
                and A1.cdval = od.exectype and A1.cdname = 'TYPEETF' --and od.exectype = '0'
                and not exists ( select f.cvalue from
                                    tllog tl, tllogfld f where tl.txnum = f.txnum and
                                    tl.txdate = f.txdate and tl.tltxcd = '8895' and f.fldcd
                                    = '22' and tl.txstatus in('1', '4','P') and f.cvalue = eq.orderid)
                --and tl1.tltxcd (+)='8800'
                and tl1.txnum (+) =tl2.reftxnum
                and tl1.txdate (+)=tl2.txdate
                --and tl2.tltxcd='8894'
                and tl2.txnum(+) =od.txnum
                and tl2.txdate (+)=od.txdate
                and ( INSTR(v_listcustodycd, od.CUSTODYCD) >0 or od.CUSTODYCD =v_custodycd)
                order by od.orderid desc,od.txdate desc;

    plog.setEndSection(pkgctx, 'PRC_GET_LIST_OD0012');
  EXCEPTION
    WHEN OTHERS THEN
      err_code := errnums.C_SYSTEM_ERROR;
        plog.error(pkgctx,'p_cdtype: ' || ' Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
      plog.setEndSection(pkgctx, 'PRC_GET_LIST_OD0012');

END PRC_GET_LIST_OD0012;
procedure PR_AUTO_8895_WEB(p_orderid varchar2,  tlid varchar2, p_reftransid  out varchar2, err_code in out varchar2, err_msg in out varchar2) IS
      l_txmsg       tx.msg_rectype;
      v_strcurrdate varchar2(20);
      v_strdesc     varchar2(1000);
      v_stren_desc  varchar2(1000);
      v_tltxcd      varchar2(10);
      p_xmlmsg      varchar2(4000);
      v_param       varchar2(1000);
      v_err_code    varchar2(10);
      p_err_message varchar2(500);
      l_txnum         varchar2(20);
      v_fullname       varchar2(1000);
      v_tlid        varchar2(50);
      v_txmsg_string    varchar2(5000);
       v_custodycd VARCHAR2(20);
       v_listcustodycd varchar2(4000);
       v_role VARCHAR2(10);
       v_count number;
BEGIN

    ------------------------
    V_ERR_CODE    := SYSTEMNUMS.C_SUCCESS;
    P_ERR_MESSAGE := 'SUCCESS';
    PLOG.SETBEGINSECTION (PKGCTX, 'pr_auto_8895_web');
    v_param   :=' PR_AUTO_8895_WEB: p_orderid' || p_orderid
                                                ||' tlid '||tlid;

    V_TLTXCD := '8895';

    p_reftransid :='';

    ------------------------
        Begin
    select custodycd,listcustodycd,role
        into v_custodycd,v_listcustodycd,v_role
    from userlogin
    where username = tlid;
    exception
        when others then
         v_custodycd := '';
         v_listcustodycd:='';
         v_role:='';
    End;
    ------------------------
    BEGIN
    SELECT TXDESC, EN_TXDESC
    INTO V_STRDESC, V_STREN_DESC
    FROM TLTX
    WHERE TLTXCD = V_TLTXCD;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            V_STRDESC:= null;
            V_STREN_DESC:= null;
    END;
    ------------------------
    SELECT TO_DATE (varvalue, systemnums.c_date_format)
    INTO v_strCURRDATE
    FROM sysvar
    WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

    ------------------------
    BEGIN
        SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD (SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
        INTO L_TXNUM
        FROM DUAL;
    EXCEPTION
          WHEN NO_DATA_FOUND THEN
            L_TXNUM:= null;
    END;
    ------------------------
    L_TXMSG.MSGTYPE     :='T';
    L_TXMSG.LOCAL       :='N';
    L_TXMSG.TLID        :='6868';

    ------------------------
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
    INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS
    FROM DUAL;
    ------------------------


      ------------------------
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.C_DELTD_TXNORMAL;
    l_txmsg.txstatus    := txstatusnums.c_txlogged;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := 'DAY';
    l_txmsg.reftxnum    := l_txnum;
    l_txmsg.txdate      := to_date(v_strcurrdate,systemnums.c_date_format);
    l_txmsg.busdate     := to_date(v_strcurrdate,systemnums.c_date_format);
    l_txmsg.tltxcd      := v_tltxcd;
    l_txmsg.nosubmit    := '1';
    l_txmsg.ovrrqd      := errnums.C_OFFID_REQUIRED;
    --------------------------SET CAC FIELD GIAO DICH-------------------------------



    DECLARE
      CURSOR c_8895
      IS
        select  to_char(eq.txdate,'dd/MM/RRRR') txdate,OD.ORDERID txnum,od.custodycd,cf.fullname,od.codeid ETFID,sb.symbol ETFIDMA ,ISS.en_cdcontent ETFNAME,A1.en_cdcontent type,od.execqtty ETFQTTY
        ,od.nav NAV ,od.execamt AMOUNT, od.feeamt fee, od.taxrate tax,od.orderid ORDERID,od.exectype,eq.status
        from  odmast od,cfmast cf ,sbsecurities sb,allcode A1,(SELECT ISSUERID,fullname CDCONTENT,en_fullname EN_CDCONTENT FROM ISSUERS ISS ) ISS,
            (
                select txdate,txnum,orderid,status,sum(qtty) qt
                from etfwsap
                    group by txdate,txnum,orderid,status
            )eq
            where   od.custodycd = cf.custodycd
                and od.orderid = eq.ORDERID
                and eq.status = 'P'
                and sb.codeid = od.codeid
                and SB.ISSUERID = ISS.ISSUERID
                and A1.cdval = od.exectype and A1.cdname = 'TYPEETF' --and od.exectype = '0'
                and not exists ( select f.cvalue from
                                    tllog tl, tllogfld f where tl.txnum = f.txnum and
                                    tl.txdate = f.txdate and tl.tltxcd = '8895' and f.fldcd
                                    = '22' and tl.txstatus in('1', '4','P') and f.cvalue = eq.orderid)
                and ( INSTR(v_listcustodycd, od.CUSTODYCD) >0 or od.CUSTODYCD =v_custodycd)
                and eq.orderid=p_orderid;
      BEGIN
      FOR rec IN c_8895
      LOOP
         v_count:=v_count+1;

        --20    Ng?y giao d?ch   D
             l_txmsg.txfields ('20').defname   := 'TXDATE';
             l_txmsg.txfields ('20').TYPE      := 'D';
             l_txmsg.txfields ('20').value      := rec.TXDATE;
        --22    ORDERID   C
             l_txmsg.txfields ('22').defname   := 'ORDERID';
             l_txmsg.txfields ('22').TYPE      := 'C';
             l_txmsg.txfields ('22').value      := rec.ORDERID;
        --21    S? hi?u l?nh   C
             l_txmsg.txfields ('21').defname   := 'TXNUM';
             l_txmsg.txfields ('21').TYPE      := 'C';
             l_txmsg.txfields ('21').value      := rec.TXNUM;
        --88    S? TK luu k?   C
             l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
             l_txmsg.txfields ('88').TYPE      := 'C';
             l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
        --07    T?n kh?ch h?ng   C
             l_txmsg.txfields ('07').defname   := 'FULLNAME';
             l_txmsg.txfields ('07').TYPE      := 'C';
             l_txmsg.txfields ('07').value      := rec.FULLNAME;
        --03    M? ch?ng ch? ETF   C
             l_txmsg.txfields ('03').defname   := 'ETFID';
             l_txmsg.txfields ('03').TYPE      := 'C';
             l_txmsg.txfields ('03').value      := rec.ETFID;
        --82    T?n ch?ng ch? ETF   C
             l_txmsg.txfields ('82').defname   := 'ETFNAME';
             l_txmsg.txfields ('82').TYPE      := 'C';
             l_txmsg.txfields ('82').value      := rec.ETFNAME;
        --12    Lo?i l?nh   C
             l_txmsg.txfields ('12').defname   := 'TYPE';
             l_txmsg.txfields ('12').TYPE      := 'C';
             l_txmsg.txfields ('12').value      := rec.TYPE;
        --06    S? l? ETF   N
             l_txmsg.txfields ('06').defname   := 'ETFQTTY';
             l_txmsg.txfields ('06').TYPE      := 'N';
             l_txmsg.txfields ('06').value      := rec.ETFQTTY;
        --08    Gi? NAV   N
             l_txmsg.txfields ('08').defname   := 'NAV';
             l_txmsg.txfields ('08').TYPE      := 'N';
             l_txmsg.txfields ('08').value      := rec.NAV;
        --09    Gi? tr? giao d?ch   N
             l_txmsg.txfields ('09').defname   := 'AMOUNT';
             l_txmsg.txfields ('09').TYPE      := 'N';
             l_txmsg.txfields ('09').value      := rec.AMOUNT;
        --10    Ph?   N
             l_txmsg.txfields ('10').defname   := 'FEE';
             l_txmsg.txfields ('10').TYPE      := 'N';
             l_txmsg.txfields ('10').value      := rec.FEE;
        --11    Thu?   N
             l_txmsg.txfields ('11').defname   := 'TAX';
             l_txmsg.txfields ('11').TYPE      := 'N';
             l_txmsg.txfields ('11').value      := rec.TAX;
        --99    Lo?i l?nh   C
             l_txmsg.txfields ('99').defname   := 'exectype';
             l_txmsg.txfields ('99').TYPE      := 'C';
             l_txmsg.txfields ('99').value      := rec.exectype;
        --30    Di?n gi?i   C
             l_txmsg.txfields ('30').defname   := 'DESC';
             l_txmsg.txfields ('30').TYPE      := 'C';
             l_txmsg.txfields ('30').value      := V_STREN_DESC;
        --23    Tr?ng th?i   C
             l_txmsg.txfields ('23').defname   := 'STATUS';
             l_txmsg.txfields ('23').TYPE      := 'C';
             l_txmsg.txfields ('23').value      := rec.STATUS;
        BEGIN
            SELECT TLID
            INTO v_tlid
            FROM cfmast
            where custodycd=rec.CUSTODYCD;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                   v_tlid:= null;
         END;

         BEGIN
            SELECT BRID
            INTO L_TXMSG.BRID
            FROM TLPROFILES WHERE TLID=v_tlid;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               L_TXMSG.BRID:= null;
         END;
             ----set txnum
        begin
            select l_txmsg.brid || lpad(seq_txnum.nextval, 6, '0')
                into l_txmsg.txnum
            from dual;
        exception
        when no_data_found then
           l_txmsg.txnum:= null;
        end;
          p_reftransid :='['|| to_char( l_txmsg.txdate,systemnums.c_date_format)  ||']['||l_txmsg.txnum||']';

    End loop;
       IF v_count =0 THEN
            err_code:=errnums.C_BIZ_RULE_INVALID;
            ROLLBACK;
            PLOG.SETENDSECTION(PKGCTX, 'PR_AUTO_8895_WEB');
            RETURN;
        END IF;
    end;
    v_txmsg_string :=txpks_msg.fn_obj2xml(l_txmsg);
    err_code:=txpks_#8895.fn_txProcess(v_txmsg_string, v_err_code, p_err_message);
    --------------------------------------------------------------------------------
    IF err_code <>SYSTEMNUMS.C_SUCCESS THEN
        PLOG.ERROR(PKGCTX,
           V_PARAM || ' run ' || V_TLTXCD || ' got ' || ERR_CODE || ':' ||
           P_ERR_MESSAGE);

        err_msg :=P_ERR_MESSAGE;
        ROLLBACK;
        PLOG.SETENDSECTION(PKGCTX, 'PR_AUTO_8895_WEB');
        RETURN;
    END IF;

    PR_LOG_USERNAME(l_txmsg, tlid, 'C');

    pr_generate_otp('TRANS',p_reftransid,  TLID, '', '','N', err_code, err_MSG);

--------------------------------------------------------------------------------
 PLOG.SETENDSECTION(PKGCTX, 'PR_AUTO_8895_WEB');
 EXCEPTION
    WHEN OTHERS THEN
        V_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.ERROR(PKGCTX,
                   ' Err: ' || SQLERRM || ' Trace: ' ||
                   DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

        PLOG.SETENDSECTION(PKGCTX, 'PR_AUTO_8895_WEB');
        ERR_CODE   := V_ERR_CODE;
END PR_AUTO_8895_WEB;
PROCEDURE PRC_GET_LIST_CANCEL_6639_WEB(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     P_CUSTODYCD    IN   VARCHAR2,
                     P_TRADINGDATE     IN  VARCHAR2,
                     p_tlid IN VARCHAR2,
                     p_role IN VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2) as
   v_param  varchar2(4000);
    v_custodycd VARCHAR2(20);
   v_listcustodycd varchar2(4000);
   v_role VARCHAR2(10);
   v_custodycdINPUT varchar2(20);
   v_TRADINGDATE varchar2(10);
  BEGIN

    plog.debug(pkgctx, 'PRC_GET_LIST_CANCEL_6639_WEB');
    v_param:=' PRC_GET_LIST_CANCEL_6639_WEB: CUSTODYCD' || P_CUSTODYCD ;

    err_code  := systemnums.C_SUCCESS;
    err_msg := 'SUCCESS';

     IF P_CUSTODYCD IS NULL OR length(P_CUSTODYCD)=0 THEN
        v_custodycdINPUT :='%';
    ELSE
        v_custodycdINPUT:=P_CUSTODYCD;
    END IF;

     IF P_TRADINGDATE IS NULL OR length(P_TRADINGDATE)=0 THEN
        v_TRADINGDATE :='%';
    ELSE
        v_TRADINGDATE:=P_TRADINGDATE;
    END IF;

    Begin
    select custodycd,listcustodycd,role
        into v_custodycd,v_listcustodycd,v_role
    from userlogin
    where username = p_tlid;
    exception
        when others then
         v_custodycd := '';
         v_listcustodycd:='';
         v_role:='';
    End;
    OPEN p_refcursor FOR
      select * from (
select t.*,a2.cdcontent INSTRUCTION_desc,a2.en_cdcontent INSTRUCTION_endesc ,
a3.cdcontent TRANSFER_desc,a3.en_cdcontent TRANSFER_endesc,
a4.cdcontent FEETYPE_desc,a4.en_cdcontent FEETYPE_endesc,TO_CHAR(TO_DATE(T.VALUEDATE,'DD/MM/RRRR'),'DD/MM/RRRR') VALUEDATE_convert,
ci.refcasaacct ||' - '|| ci.ccycd || ' - ' || A5.CDCONTENT DISPLAY_ACCTNO
from(
 select  max ( case when fldcd = '01' then cvalue else '' end)  POSTINGDATE,
        max( case when fldcd = '02' then cvalue else '' end)  TRADINGACCT,
        max( case when fldcd = '03' then cvalue else '' end)  ACCTNO,
        max( case when fldcd = '04' then cvalue else '' end)  PORFOLIO,
        max( case when fldcd = '05' then nvalue else 0 end)  BALANCE,
        max( case when fldcd = '06' then nvalue else 0 end)  AVAILABLE,
        max( case when fldcd = '07' then cvalue else '' end)  INSTRUCTION,
        max( case when fldcd = '08' then cvalue else '' end)  TRANSFER,
        max( case when fldcd = '09' then cvalue else '' end)  CITAD,
        max( case when fldcd = '10' then nvalue else 0 end)  AMT,
        max( case when fldcd = '11' then cvalue else '' end)  BANK,
        max( case when fldcd = '12' then cvalue else '' end)  BANKBRANCH,
        max( case when fldcd = '13' then cvalue else '' end)  BANKACCTNO,
        max( case when fldcd = '14' then cvalue else '' end)  NAME,
        max( case when fldcd = '15' then cvalue else '' end)  REFCONTRACT,
        max( case when fldcd = '16' then cvalue else '' end)  FEETYPE,
        max( case when fldcd = '17' then cvalue else '' end)  VALUEDATE,
        max( case when fldcd = '30' then cvalue else '' end)  "DESC",
        tl.autoid, tl.txstatus txstatus, a1.cdcontent txstatus_desc ,case when tl.txstatus='4' then 'Waiting BO confirm' else a1.en_cdcontent end txstatus_endesc,
        to_char(to_date(tl.txdate,'dd/MM/rrrr'),'dd/MM/rrrr') txdate ,tl.TXNUM,tl.tltxcd ||'-'||tx.txdesc txdesc,tl.tltxcd ||'-'||tx.en_txdesc en_txdesc,tl.CCYUSAGE FILEID
from tllogfld tlfld,tllog tl,tltx tx,allcode a1
where tlfld.txnum=tl.txnum
and tx.tltxcd=tl.tltxcd
and a1.CDVAL=(case
when tl.txstatus ='4' then '1'
when tl.txstatus ='P' then '4'
else tl.txstatus
 end)
and tl.tltxcd='6639'
and a1.cdname='TXSTATUS' and a1.cdtype='SY'
and tl.txstatus ='4'
GROUP BY TL.AUTOID,tl.TXDATE ,tl.TXNUM,tl.tltxcd ||'-'||tx.txdesc,tl.tltxcd ||'-'||tx.en_txdesc,tl.txstatus,
a1.cdcontent,a1.en_cdcontent,tl.autoid,tl.CCYUSAGE
order by tl.autoid desc
)t,ddmast ci,allcode a2,allcode a3,allcode a4,allcode a5
where ci.acctno=t.ACCTNO
and ci.STATUS <> 'C'
and a2.cdval=t.INSTRUCTION
and a2.cdname='CBTXTYPE'
and a3.cdval=t.TRANSFER
and a3.cdname='TRANSTYPE' and a3.cdtype='FA'
and a4.cdval=t.FEETYPE
and a4.cdname='IOROFEE' and a4.cdtype='SA'
and a5.CDNAME = 'ACCOUNTTYPE' and a5.CDVAl = ci.accounttype and a5.CDTYPE = 'DD'
and ( INSTR(v_listcustodycd, t.TRADINGACCT) >0 or t.TRADINGACCT =v_custodycd)
and t.TRADINGACCT like v_custodycdINPUT
and t.VALUEDATE like v_TRADINGDATE
          ) tt
order by tt.AUTOID desc;
    plog.setEndSection(pkgctx, 'PRC_GET_LIST_CANCEL_6639_WEB');
  EXCEPTION
    WHEN OTHERS THEN
      err_code := errnums.C_SYSTEM_ERROR;
        plog.error(pkgctx,'p_cdtype: ' || ' Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
      plog.setEndSection(pkgctx, 'PRC_GET_LIST_CANCEL_6639_WEB');

END PRC_GET_LIST_CANCEL_6639_WEB;
procedure PR_CANCEL_6639_WEB(p_txnum varchar2,p_txdate varchar2,  tlid varchar2, p_reftransid  out varchar2, err_code in out varchar2, err_msg in out varchar2) IS
      l_txmsg       tx.msg_rectype;
      v_param  varchar2(4000);
       v_custodycd VARCHAR2(20);
       v_listcustodycd varchar2(4000);
       v_role VARCHAR2(10);
       v_count number;
BEGIN

    ------------------------
    err_code    := SYSTEMNUMS.C_SUCCESS;
    err_msg := 'SUCCESS';
    PLOG.SETBEGINSECTION (PKGCTX, 'PR_CANCEL_6639_WEB');
    v_param   :=' PR_CANCEL_6639_WEB: p_orderid' || p_txnum
                                                ||' p_txdate '|| p_txdate
                                                ||' tlid '||tlid;

    v_count:=0;
    ------------------------
    Begin
    select custodycd,listcustodycd,role
        into v_custodycd,v_listcustodycd,v_role
    from userlogin
    where username = tlid;
    exception
        when others then
         v_custodycd := '';
         v_listcustodycd:='';
         v_role:='';
    End;
    ------------------------
    DECLARE
      CURSOR c_6639
      IS
             select * from (
                select t.*
                from(
                 select  max ( case when fldcd = '01' then cvalue else '' end)  POSTINGDATE,
                        max( case when fldcd = '02' then cvalue else '' end)  TRADINGACCT,
                        max( case when fldcd = '03' then cvalue else '' end)  ACCTNO,
                        max( case when fldcd = '04' then cvalue else '' end)  PORFOLIO,
                        max( case when fldcd = '05' then nvalue else 0 end)  BALANCE,
                        max( case when fldcd = '06' then nvalue else 0 end)  AVAILABLE,
                        max( case when fldcd = '07' then cvalue else '' end)  INSTRUCTION,
                        max( case when fldcd = '08' then cvalue else '' end)  TRANSFER,
                        max( case when fldcd = '09' then cvalue else '' end)  CITAD,
                        max( case when fldcd = '10' then nvalue else 0 end)  AMT,
                        max( case when fldcd = '11' then cvalue else '' end)  BANK,
                        max( case when fldcd = '12' then cvalue else '' end)  BANKBRANCH,
                        max( case when fldcd = '13' then cvalue else '' end)  BANKACCTNO,
                        max( case when fldcd = '14' then cvalue else '' end)  NAME,
                        max( case when fldcd = '15' then cvalue else '' end)  REFCONTRACT,
                        max( case when fldcd = '16' then cvalue else '' end)  FEETYPE,
                        max( case when fldcd = '17' then cvalue else '' end)  VALUEDATE,
                        max( case when fldcd = '30' then cvalue else '' end)  "DESC",
                        to_char(to_date(tl.txdate,'dd/MM/rrrr'),'dd/MM/rrrr') txdate ,tl.TXNUM
                from tllogfld tlfld,tllog tl,tltx tx,allcode a1
                where tlfld.txnum=tl.txnum
                and tx.tltxcd=tl.tltxcd
                and a1.CDVAL=(case
                when tl.txstatus ='4' then '1'
                when tl.txstatus ='P' then '4'
                else tl.txstatus
                 end)
                and tl.tltxcd='6639'
                and a1.cdname='TXSTATUS' and a1.cdtype='SY'
                and tl.txstatus ='4'
                GROUP BY TL.AUTOID,tl.TXDATE ,tl.TXNUM,tl.tltxcd ||'-'||tx.txdesc,tl.tltxcd ||'-'||tx.en_txdesc,tl.txstatus,
                a1.cdcontent,a1.en_cdcontent,tl.autoid
                )t,ddmast ci,allcode a2,allcode a3,allcode a4,allcode a5
                where ci.acctno=t.ACCTNO
                and ci.STATUS <> 'C'
                and a2.cdval=t.INSTRUCTION
                and a2.cdname='CBTXTYPE'
                and a3.cdval=t.TRANSFER
                and a3.cdname='TRANSTYPE' and a3.cdtype='FA'
                and a4.cdval=t.FEETYPE
                and a4.cdname='IOROFEE' and a4.cdtype='SA'
                and a5.CDNAME = 'ACCOUNTTYPE' and a5.CDVAl = ci.accounttype and a5.CDTYPE = 'DD'
                and ( INSTR(v_listcustodycd, t.TRADINGACCT) >0 or t.TRADINGACCT =v_custodycd)
                and t.txnum=p_txnum
                and t.txdate=to_char(to_date(p_txdate,'dd/MM/rrrr'),'dd/MM/rrrr')
                          ) tt;
      BEGIN
      FOR rec IN c_6639
      LOOP

         v_count:=v_count+1;
         l_txmsg.txdate      := to_date(rec.TXDATE,systemnums.c_date_format);
         l_txmsg.txnum      := rec.txnum;
         UPDATE tllog SET txstatus = txstatusnums.c_txrejected WHERE txnum=rec.txnum AND TXDATE = to_date(rec.TXDATE,systemnums.c_date_format);
         PR_LOG_USERNAME(l_txmsg, tlid, 'A');
      End loop;
       IF v_count =0 THEN
            err_code:=errnums.C_BIZ_RULE_INVALID;
            ROLLBACK;
            PLOG.SETENDSECTION(PKGCTX, 'PR_CANCEL_6639_WEB');
            RETURN;
        END IF;
    end;

--------------------------------------------------------------------------------
 PLOG.SETENDSECTION(PKGCTX, 'PR_CANCEL_6639_WEB');
 EXCEPTION
    WHEN OTHERS THEN
        ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.ERROR(PKGCTX,
                   ' Err: ' || SQLERRM || ' Trace: ' ||
                   DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

        PLOG.SETENDSECTION(PKGCTX, 'PR_CANCEL_6639_WEB');
END PR_CANCEL_6639_WEB;
PROCEDURE PRC_GET_FX_REQUIRES_WEB(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     p_tlid IN VARCHAR2,
                     p_role IN VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2) as
   v_param  varchar2(4000);
   v_custodycd VARCHAR2(20);
   v_listcustodycd varchar2(4000);
   v_role VARCHAR2(10);
         v_strdesc     varchar2(1000);
      v_stren_desc  varchar2(1000);
  BEGIN

    plog.debug(pkgctx, 'PRC_GET_FX_REQUIRES_WEB');
    v_param:=' PRC_GET_FX_REQUIRES_WEB: p_tlid' || p_tlid ;

    err_code  := systemnums.C_SUCCESS;
    err_msg := 'SUCCESS';
    Begin
    select custodycd,listcustodycd,role
        into v_custodycd,v_listcustodycd,v_role
    from userlogin
    where username = p_tlid;
    exception
        when others then
         v_custodycd := '';
         v_listcustodycd:='';
         v_role:='';
    End;

    BEGIN
    SELECT TXDESC, EN_TXDESC
    INTO V_STRDESC, V_STREN_DESC
    FROM TLTX
    WHERE TLTXCD = '8895';
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            V_STRDESC:= null;
            V_STREN_DESC:= null;
    END;

    OPEN p_refcursor FOR
select t.*,ci.refcasaacct ||' - '|| ci.ccycd || ' - ' || A1.CDCONTENT TRANSFERACCOUNTNO,ci1.refcasaacct ||' - '|| ci1.ccycd || ' - ' || A2.CDCONTENT RECEVINGACCOUNTNO  from (
select max ( case when fldcd = '04' then cvalue else '' end)  TRANSFERACCOUNT,
        max( case when fldcd = '06' then cvalue else '' end)  RECEVINGACCOUNT,
        max( case when fldcd = '10' then nvalue else 0 end)  AMOUNT,
        max( case when fldcd = '30' then cvalue else '' end)  DESCRIPTION,
        max( case when fldcd = '88' then cvalue else '' end)  TRADINGACCOUNT,
        to_char(to_date(tl.busdate,'dd/MM/rrrr'),'dd/MM/rrrr') VALUEDATE ,tl.TXNUM,tl.TXDATE,tl.txstatus txstatus, a1.cdcontent txstatus_desc, a1.EN_cdcontent txstatus_desc_en
        from tllogfld tlfld,tllog tl,tltx tx,allcode a1
        where tlfld.txnum=tl.txnum
and tx.tltxcd=tl.tltxcd
and tl.tltxcd='1721'
and a1.cdname='TXSTATUS' and a1.cdtype='SY'
and a1.CDVAL=(CASE WHEN tl.DELTD='Y' THEN '9'
                   WHEN tl.txstatus = 'P' THEN '4'
                   else tl.txstatus END)
and tl.txstatus <>'0'
and tl.tlid=C_TLID_ONLINE
group by tl.busdate,tl.TXNUM,tl.TXDATE,tl.txstatus, a1.cdcontent, a1.en_cdcontent,TL.TXDATE
)t,ddmast ci, allcode A1,ddmast ci1,allcode A2
where  ( INSTR(v_listcustodycd, t.TRADINGACCOUNT) >0 or t.TRADINGACCOUNT =v_custodycd)
and A1.CDNAME = 'ACCOUNTTYPE' and A1.CDVAl = ci.accounttype and A1.CDTYPE = 'DD'
and A2.CDNAME = 'ACCOUNTTYPE' and A2.CDVAl = ci1.accounttype and A2.CDTYPE = 'DD'
and ci.acctno  =  t.TRANSFERACCOUNT
and ci1.acctno  =  t.RECEVINGACCOUNT
ORDER BY t.TXDATE,t.TXNUM DESC;
    plog.setEndSection(pkgctx, 'PRC_GET_FX_REQUIRES_WEB');
  EXCEPTION
    WHEN OTHERS THEN
      err_code := errnums.C_SYSTEM_ERROR;
        plog.error(pkgctx,'p_cdtype: ' || ' Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
      plog.setEndSection(pkgctx, 'PRC_GET_FX_REQUIRES_WEB');

END PRC_GET_FX_REQUIRES_WEB;
procedure PR_FX_REQUIRES_WEB(
    p_valuedate varchar2,
    p_custodycd varchar2,
    p_TransferAccount varchar2,
    p_RecevingAccount varchar2,
    p_amount number,
    p_description  varchar2,
    tlid varchar2,
    p_reftransid  out varchar2,
    err_code in out varchar2,
    err_msg in out varchar2
 ) is
    L_TXMSG       TX.MSG_RECTYPE;
    L_TXNUM       VARCHAR2(20);
    V_STRCURRDATE VARCHAR2(20);
    V_STRDESC     VARCHAR2(1000);
    V_STREN_DESC  VARCHAR2(1000);
    V_TLTXCD      VARCHAR2(10);
    P_XMLMSG      VARCHAR2(4000);
    V_PARAM       VARCHAR2(1000);
    V_ERR_CODE    VARCHAR2(10);
    P_ERR_MESSAGE VARCHAR2(500);
    V_TLID        VARCHAR2(5);
    V_XMLMSG_STRING    varchar2(5000);
BEGIN
    ------------------------
    v_err_code    := systemnums.c_success;
    p_err_message := 'success';
    plog.setbeginsection (pkgctx, 'PR_FX_REQUIRES_WEB');
    v_tltxcd := '8894';
    p_reftransid :='';
    ------------------------
    begin
        select txdesc, en_txdesc
            into v_strdesc, v_stren_desc
        from tltx
        where tltxcd = v_tltxcd;
    exception
        when no_data_found then
            v_strdesc:= null;
            v_stren_desc:= null;
    end;
    ------------------------
    SELECT TO_DATE (varvalue, systemnums.c_date_format)
    INTO v_strCURRDATE
    FROM sysvar
    WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

    ------------------------
    BEGIN
        SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD (SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
        INTO L_TXNUM
        FROM DUAL;
    EXCEPTION
          WHEN NO_DATA_FOUND THEN
            L_TXNUM:= null;
    END;
    ------------------------
    L_TXMSG.MSGTYPE     :='T';
    L_TXMSG.LOCAL       :='N';
    L_TXMSG.TLID        :='6868';
    BEGIN
    SELECT TLID
    INTO v_tlid
    FROM cfmast
    where custodycd=P_CUSTODYCD;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
           v_tlid:= null;
    END;
    ------------------------
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
    INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS
    FROM DUAL;
    ------------------------
    BEGIN
        SELECT BRID
        INTO L_TXMSG.BRID
        FROM TLPROFILES WHERE TLID=v_tlid;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           L_TXMSG.BRID:= null;
    END;
    ------------------------
    L_TXMSG.OFF_LINE    := 'N';
    L_TXMSG.DELTD       := TXNUMS.C_DELTD_TXNORMAL;
    L_TXMSG.TXSTATUS    := TXSTATUSNUMS.c_txlogged;
    L_TXMSG.MSGSTS      := '0';
    L_TXMSG.OVRSTS      := '0';
    L_TXMSG.BATCHNAME   := 'DAY';
    L_TXMSG.REFTXNUM    := L_TXNUM;
    L_TXMSG.TXDATE      := TO_DATE(V_STRCURRDATE,SYSTEMNUMS.C_DATE_FORMAT);
    L_TXMSG.BUSDATE     := TO_DATE(V_STRCURRDATE,SYSTEMNUMS.C_DATE_FORMAT);
    L_TXMSG.TLTXCD      := V_TLTXCD;
    l_txmsg.nosubmit    := '1';
    l_txmsg.ovrrqd      := '@0';

 --------------------------SET CAC FIELD GIAO DICH-------------------------------
  ----SET TXNUM
  BEGIN
  SELECT L_TXMSG.BRID || LPAD(seq_txnum.NEXTVAL, 6, '0')
  INTO L_TXMSG.TXNUM
  FROM DUAL;
  EXCEPTION
        WHEN NO_DATA_FOUND THEN
           L_TXMSG.TXNUM:= null;
  END;

    p_reftransid :='['|| TO_char( L_TXMSG.TXDATE,SYSTEMNUMS.C_DATE_FORMAT)  ||']['||L_TXMSG.txnum||']';

    ----FUNDCODEID OK----------------------
  l_txmsg.txfields('03').defname := 'ETFID';
  l_txmsg.txfields('03').TYPE := 'C';
  l_txmsg.txfields('03').VALUE := p_valuedate;

   ----CTCK  OK
  L_TXMSG.TXFIELDS('05').DEFNAME := 'CTCK';
  L_TXMSG.TXFIELDS('05').TYPE := 'C';
  L_TXMSG.TXFIELDS('05').VALUE := p_custodycd;
     ----QTTY  OK
  L_TXMSG.TXFIELDS('06').DEFNAME := 'ETFQTTY';
  L_TXMSG.TXFIELDS('06').TYPE := 'N';
  L_TXMSG.TXFIELDS('06').VALUE := p_TransferAccount ;
     ----FULLNAME OK
  L_TXMSG.TXFIELDS('07').DEFNAME := 'FULLNAME';
  L_TXMSG.TXFIELDS('07').TYPE := 'C';
  L_TXMSG.TXFIELDS('07').VALUE := p_RecevingAccount;
    ----AMT OK
  L_TXMSG.TXFIELDS('09').DEFNAME := 'AMOUNT';
  L_TXMSG.TXFIELDS('09').TYPE := 'N';
  L_TXMSG.TXFIELDS('09').VALUE := P_AMOUNT;
     ----FEE OK
  L_TXMSG.TXFIELDS('10').DEFNAME := 'FEE';
  L_TXMSG.TXFIELDS('10').TYPE := 'N';
  L_TXMSG.TXFIELDS('10').VALUE := p_amount;
    ----TAX OK
  L_TXMSG.TXFIELDS('11').DEFNAME := 'TAX';
  L_TXMSG.TXFIELDS('11').TYPE := 'N';
  L_TXMSG.TXFIELDS('11').VALUE := p_description;


    V_XMLMSG_STRING :=txpks_msg.fn_obj2xml(l_txmsg);
    err_code:=txpks_#8894.fn_txProcess(V_XMLMSG_STRING, v_err_code, p_err_message);
    --------------------------------------------------------------------------------
    IF err_code <>SYSTEMNUMS.C_SUCCESS THEN
        PLOG.ERROR(PKGCTX,
           V_PARAM || ' run ' || V_TLTXCD || ' got ' || ERR_CODE || ':' ||
           P_ERR_MESSAGE);

        err_msg :=P_ERR_MESSAGE;
        ROLLBACK;
        PLOG.SETENDSECTION(PKGCTX, 'PR_FX_REQUIRES_WEB');
        RETURN;
    END IF;

    PR_LOG_USERNAME(l_txmsg, tlid, 'C');

    pr_generate_otp('TRANS',p_reftransid, TLID, '', '','N', err_code, err_MSG);

--------------------------------------------------------------------------------
 PLOG.SETENDSECTION(PKGCTX, 'PR_FX_REQUIRES_WEB');
 EXCEPTION
    WHEN OTHERS THEN
        V_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.ERROR(PKGCTX,
                   ' Err: ' || SQLERRM || ' Trace: ' ||
                   DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

        PLOG.SETENDSECTION(PKGCTX, 'PR_FX_REQUIRES_WEB');
        ERR_CODE   := V_ERR_CODE;
END PR_FX_REQUIRES_WEB;



PROCEDURE PRC_GET_LISTED_TRADING_RESULT_FOR_BROKER(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     P_CUSTODYCD IN  VARCHAR2,
                     P_TRADINGDATE     IN  VARCHAR2,
                     p_tlid IN VARCHAR2,
                     p_role IN VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2) as
   v_param  varchar2(4000);
   v_custodycd VARCHAR2(20);
   v_listcustodycd varchar2(4000);
   v_role VARCHAR2(10);
   v_TRADINGDATE VARCHAR2(10);
   v_CUSTODYCDINPUT VARCHAR2(10);
  BEGIN

    plog.debug(pkgctx, 'PRC_GET_LISTED_TRADING_RESULT_FOR_BROKER');
    v_param:=' PRC_GET_LISTED_TRADING_RESULT_FOR_BROKER: P_CUSTODYCD' || P_CUSTODYCD ||', P_TRADINGDATE: '||P_TRADINGDATE||',p_tlid: '||p_tlid ||',p_role:' ||p_role;

    err_code  := systemnums.C_SUCCESS;
    err_msg := 'SUCCESS';
    Begin
    select custodycd,listcustodycd,role
        into v_custodycd,v_listcustodycd,v_role
    from userlogin
    where username = p_tlid;
    exception
        when others then
         v_custodycd := '';
         v_listcustodycd:='';
         v_role:='';
    End;
    if P_TRADINGDATE is null or P_TRADINGDATE = '' then
        v_TRADINGDATE:= '%';
    else
     v_TRADINGDATE:= P_TRADINGDATE;
    end if ;

    if P_CUSTODYCD is null or P_CUSTODYCD = '' then
        v_CUSTODYCDINPUT:= '%';
    else
        v_CUSTODYCDINPUT:= P_CUSTODYCD;
    end if ;
    OPEN p_refcursor FOR

 select * from (
/*
select t.*,a2.cdcontent KQGD_desc,a2.en_cdcontent KQGD_endesc,
        a3.cdcontent EXECTYPE_desc,a3.en_cdcontent EXECTYPE_endesc,
         a4.cdcontent TRANSTYPE_desc,a4.en_cdcontent TRANSTYPE_endesc,
          debit.display DESACCTNO_desc,debit.en_display DESACCTNO_endesc,
          sb.symbol symbol_codeid,MEM.EN_DISPLAY MEMBERID_DESC,crb.bankname CITAD_DESC
from(
 select  max ( case when fldcd = '01' then cvalue else '' end)  CODEID,
        max( case when fldcd = '04' then cvalue else '' end)  KQGD,
        max( case when fldcd = '06' then cvalue else '' end)  DESACCTNO,
        max( case when fldcd = '10' then nvalue else 0 end)  AMT,
        max( case when fldcd = '11' then nvalue else 0 end)  PRICE,
        max( case when fldcd = '12' then nvalue else 0 end)  QTTY,
        max( case when fldcd = '13' then cvalue else '' end)  CITAD,
        max( case when fldcd = '14' then nvalue else 0 end)  GROSSAMOUNT,
        max( case when fldcd = '20' then cvalue else '' end)  TRADEDATE,
        max( case when fldcd = '21' then cvalue else '' end)  SETTLEDATE,
        max( case when fldcd = '23' then cvalue else '' end)  EXECTYPE,
        max( case when fldcd = '25' then nvalue else 0 end)  FEEAMT,
        max( case when fldcd = '26' then nvalue else 0 end)  VATAMT,
        max( case when fldcd = '27' then cvalue else '' end)  TRANSTYPE,
        max( case when fldcd = '29' then cvalue else '' end)  IDENTITY,
        max( case when fldcd = '30' then cvalue else '' end)  "DESC",
        max( case when fldcd = '31' then cvalue else '' end)  AP,
         max( case when fldcd = '35' then cvalue else '' end)  APACCT,
        max( case when fldcd = '36' then cvalue else '' end)  ETFDATE,
        max( case when fldcd = '33' then nvalue else 0 end)  CLEARDAY,
        max( case when fldcd = '68' then cvalue else '' end)  SYMBOL,
        max( case when fldcd = '88' then cvalue else '' end)  CUSTODYCD,
        max( case when fldcd = '99' then cvalue else '' end)  MEMBERID,
       tl.autoid, tl.txstatus txstatus, a1.cdcontent txstatus_desc ,
       case when v_8802.fileid is not null then ( select en_cdcontent from allcode where cdname='ORSTATUS' and cdval='3') else a1.en_cdcontent end txstatus_endesc,
       to_char(to_date(tl.txdate,'dd/MM/rrrr'),'dd/MM/rrrr') txdate ,tl.TXNUM,tl.tltxcd ||'-'||tx.txdesc txdesc,tl.tltxcd ||'-'||tx.en_txdesc en_txdesc
from tllogfld tlfld,tllog tl,tltx tx,allcode a1,(select fld1.cvalue fileid
                                                 from tllog tl1,tllogfld fld1
                                                 where tl1.txnum=fld1.txnum
                                                 and tl1.tltxcd='8802'
                                                 and tlid='6868'
                                                 and fld1.fldcd='28' and tl1.txstatus='1') v_8802
where tlfld.txnum=tl.txnum
and tx.tltxcd=tl.tltxcd
and a1.CDVAL=(CASE WHEN tl.DELTD='Y' THEN '9'
                   WHEN tl.txstatus = 'P' THEN '4'
                   else tl.txstatus END)
and tl.tltxcd='8864'
and a1.cdname='TXSTATUS' and a1.cdtype='SY'
and tl.txstatus<>'0'
and tl.tlid=C_TLID_ONLINE
and v_8802.fileid (+)=to_char(tl.txdate,'RRRRMMDD') || tl.txnum
GROUP BY tl.autoid,tl.TXDATE ,tl.TXNUM,tl.tltxcd ||'-'||tx.txdesc,tl.tltxcd ||'-'||tx.en_txdesc,tl.txstatus,
a1.cdcontent,a1.en_cdcontent,tl.tlid,v_8802.fileid
)t left join crbbanklist crb on crb.CITAD=t.citad,
allcode a2,allcode a3,allcode a4,vw_ddmast_vnd debit,SBSECURITIES sb,VW_CUSTODYCD_MEMBER MEM
where a2.cdval=t.KQGD
and a2.cdname='KQGD' and a2.cdtype='OD'
and a3.cdval=t.EXECTYPE
and a3.cdname='EXECTYPE' and a3.cdtype='OD'
and a4.cdval=t.TRANSTYPE
and a4.cdname='TRANSACTIONTYPE' and a4.cdtype='OD'
and debit.filtercd=t.CUSTODYCD
and debit.value=t.DESACCTNO
and sb.codeid=t.CODEID
and MEM.VALUE=t.MEMBERID
and MEM.FILTERCD=T.CUSTODYCD
and ( INSTR(v_listcustodycd, t.CUSTODYCD) >0 or t.CUSTODYCD =v_custodycd)
AND t.custodycd like v_CUSTODYCDINPUT
and t.SETTLEDATE like v_TRADINGDATE
union all
*/
       -- import file
       SELECT ' ' CODEID,' '  AS KQGD, ' ' DESACCTNO,null AMT,null PRICE,
        null QTTY,' ' CITAD,null GROSSAMOUNT, ' ' AS TRADEDATE,' ' SETTLEDATE, ' ' EXECTYPE ,null FEEAMT,
        null VATAMT,' ' TRANSTYPE,' ' IDENTITY,TL.TXDESC "DESC",' ' AP,' ' APACCT,' ' ETFDATE,null CLEARDAY,' ' SYMBOL,' ' CUSTODYCD,' ' MEMBERID,
        TL.AUTOID,TL.STATUS TXSTATUS,TL.STATUS TXSTATUS_DESC,TL.STATUS TXSTATUS_ENDESC,to_char(TL.TXDATE,'dd/MM/rrrr') TXDATE,TL.TXNUM,TL.TLTXCD||'-'||TL.TXDESC,TL.TLTXCD||'-'||TL.TXDESC EN_TXDESC,
        ' ' KQGD_DESC,' ' KQGD_ENDESC,' ' EXECTYPE_DESC,' ' EXECTYPE_ENDESC,
        ' ' TRANSTYPE_DESC,' ' TRANSTYPE_ENDESC,' ' DESACCTNO_DESC,' ' DESACCTNO_ENDESC,
        ' ' SYMBOL_CODEID,' ' MEMBERID_DESC,' ' CITAD_DESC
        FROM (Select t.AUTOID, t.txdesc, tltxcd, t.txdate,t.txnum,a.EN_cdcontent status,(case when  a.cdval = '4' then 'N' else 'Y' end) statusval,t.tlid from  tllog t,
        (SELECT  TXDATE ,TXNUM,
        MAX( CASE WHEN fldcd = '16' THEN cvalue ELSE '' END)  FILECODE,
        MAX( CASE WHEN fldcd = '15' THEN cvalue ELSE '' END)  FILEID,
        MAX( CASE WHEN fldcd = '99' THEN cvalue ELSE '' END)  USERNAME
        FROM tllogfld
        GROUP BY TXDATE ,TXNUM) m,allcode a
        where a.cdname = 'TXSTATUS' AND m.txdate = t.txdate and m.txnum = t.txnum  and a.cdtype = 'SY' and a.cdval <> 0 and m.FILECODE = 'I073' and decode(t.TXSTATUS,'P','4',t.TXSTATUS)  = a.cdval and M.USERNAME=p_tlid
        and t.TLTXCD in ('8800')) tl,tltx tx where tl.tltxcd = tx.tltxcd and tl.tlid=C_TLID_ONLINE
        ) tt
order by tt.AUTOID desc;


    plog.setEndSection(pkgctx, 'PRC_GET_LISTED_TRADING_RESULT_FOR_BROKER');
  EXCEPTION
    WHEN OTHERS THEN
      err_code := errnums.C_SYSTEM_ERROR;
        plog.error(pkgctx,'p_cdtype: ' || ' Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
      plog.setEndSection(pkgctx, 'PRC_GET_LISTED_TRADING_RESULT_FOR_BROKER');

END PRC_GET_LISTED_TRADING_RESULT_FOR_BROKER;
PROCEDURE PRC_check_holidate(
                     p_date      varchar2,
                     p_holiday       IN out varchar2,
                     p_err_code      in out varchar2,
                     p_err_param     in out varchar2
                     ) as
Begin

        p_err_code  := systemnums.C_SUCCESS;
        p_err_param := 'Success';

        select holiday into p_holiday From sbcldr where  cldrtype = '000' and sbdate = to_date(p_date,'dd/MM/RRRR');
        if p_holiday ='Y' then
            p_err_code:='-1';
            p_err_param := 'Value date must be working day';
        end if;


  end PRC_check_holidate;

PROCEDURE PRC_GET_LIST_IMPORT_BROKER(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                     p_tlid IN VARCHAR2,
                     p_role IN VARCHAR2,
                     err_code      IN OUT VARCHAR2,
                     err_msg     IN OUT VARCHAR2) as
   v_param  varchar2(4000);
   v_custodycd VARCHAR2(20);
   v_listcustodycd varchar2(4000);
   v_role VARCHAR2(10);
  BEGIN

    plog.debug(pkgctx, 'PRC_GET_LIST_IMPORT_BROKER');
    v_param:=' PRC_GET_LIST_IMPORT_BROKER: p_tlid' || p_tlid ;

    err_code  := systemnums.C_SUCCESS;
    err_msg := 'SUCCESS';
    Begin
    select custodycd,listcustodycd,role
        into v_custodycd,v_listcustodycd,v_role
    from userlogin
    where username = p_tlid;
    exception
        when others then
         v_custodycd := '';
         v_listcustodycd:='';
         v_role:='';
    End;
    OPEN p_refcursor FOR

select *from
(
    select 'Broker' source, 'Online' VIA,to_char(txtime,'dd/MM/RRRR')recorddate,dp.shortname ctck
            ,od.custodycd,od.sec_id symbol,A2.CDCONTENT ODTYPE,
            od.trade_date tradedate,od.settle_date settledate,od.price,od.quantity qtty, od.gross_amount grossamount, nvl(od.commission_fee,'0') fee,
            nvl(od.tax,'0')tax,fileid IDFILE,autoid,A3.EN_CDCONTENT STATUSTEXT,A3.CDVAL STATUS
        from odmastcmp od,deposit_member dp,allcode A2,allcode A3
        where   od.VIA = 'O'
            and od.broker_code = dp.depositid
            and A2.cdname = 'EXECTYPE' and A2.cdtype = 'OD' and A2.cdval = od.trans_type
            and od.isodmast = 'N'
            and A3.cdname = 'CORDER' and A3.cdtype = 'OD' and A3.cdval = od.deltd
            --and version is not null
            and deltd <> 'Y'
)a
where   0=0
    and not exists ( select f.nvalue from
                                    tllog tl, tllogfld f where tl.txnum = f.txnum and
                                    tl.txdate = f.txdate and tl.tltxcd = '8802' and f.fldcd
                                    = '01' and tl.txstatus in('1', '4','P') and f.nvalue = a.autoid)
    and ( INSTR(v_listcustodycd, a.CUSTODYCD) >0 or a.CUSTODYCD =v_custodycd);

    plog.setEndSection(pkgctx, 'PRC_GET_LIST_IMPORT_BROKER');
  EXCEPTION
    WHEN OTHERS THEN
      err_code := errnums.C_SYSTEM_ERROR;
        plog.error(pkgctx,'p_cdtype: ' || ' Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
      plog.setEndSection(pkgctx, 'PRC_GET_LIST_IMPORT_BROKER');

END PRC_GET_LIST_IMPORT_BROKER;
begin
  -- Initialization
  for i in (select * from tlogdebug)
  loop
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  end loop;

  pkgctx := plog.init('FOPKS_SA',
                      plevel     => nvl(logrow.loglevel, 30),
                      plogtable  => (nvl(logrow.log4table, 'N') = 'Y'),
                      palert     => (nvl(logrow.log4alert, 'N') = 'Y'),
                      ptrace     => (nvl(logrow.log4trace, 'N') = 'Y'));

end FOPKS_SA;
/
