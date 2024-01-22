SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_ETFRESULT_TEMP
(CUSTODYCD, TRANSDATE, FUNDCODEID, TRADINGID, TYPE, 
 AP, NAV, QUANTITY, VALUE, DIFFERENCE, 
 VIRTUALQTTY, TRADINGFEE, TAX, SERCURITIES, SECQTTY, 
 SECPRICE, SECVALUE, ERRMSG, MBID, IMPTLID, 
 FILEID, STATUS, CLEARDATE, AP_SERCURITIES, AUTOID, 
 TXTIME, IMPSTATUS, OVRSTATUS, TLIDIMP, VIA)
AS 
select "CUSTODYCD","TRANSDATE","FUNDCODEID","TRADINGID","TYPE","AP","NAV","QUANTITY","VALUE","DIFFERENCE","VIRTUALQTTY","TRADINGFEE","TAX","SERCURITIES","SECQTTY","SECPRICE","SECVALUE","ERRMSG","MBID","IMPTLID","FILEID","STATUS","CLEARDATE","AP_SERCURITIES","AUTOID","TXTIME","IMPSTATUS","OVRSTATUS","TLIDIMP","VIA" from etfresult_temp
union all 
select "CUSTODYCD","TRANSDATE","FUNDCODEID","TRADINGID","TYPE","AP","NAV","QUANTITY","VALUE","DIFFERENCE","VIRTUALQTTY","TRADINGFEE","TAX","SERCURITIES","SECQTTY","SECPRICE","SECVALUE","ERRMSG","MBID","IMPTLID","FILEID","STATUS","CLEARDATE","AP_SERCURITIES","AUTOID","TXTIME","IMPSTATUS","OVRSTATUS","TLIDIMP","VIA" from etfresult_temp4web
/
