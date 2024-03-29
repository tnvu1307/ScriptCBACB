SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_STS_ORDERS_HNX_UPCOM
(ORDER_ID, ORG_ORDER_ID, FLOOR_CODE, ORDER_CONFIRM_NO, ORDER_NO, 
 CO_ORDER_NO, ORG_ORDER_NO, ORDER_DATE, ORDER_TIME, MEMBER_ID, 
 CO_MEMBER_ID, ACCOUNT_ID, CO_ACCOUNT_ID, STOCK_ID, ORDER_TYPE, 
 PRIORITY, OORB, NORP, NORC, BORE, 
 AORI, SETTLEMENT_TYPE, DORF, ORDER_QTTY, ORDER_PRICE, 
 STATUS, QUOTE_PRICE, STATE, QUOTE_TIME, QUOTE_QTTY, 
 EXEC_QTTY, CORRECT_QTTY, CANCEL_QTTY, REJECT_QTTY, REJECT_REASON, 
 ACCOUNT_NO, CO_ACCOUNT_NO, BROKER_ID, CO_BROKER_ID, DELETED, 
 DATE_CREATED, DATE_MODIFIED, MODIFIED_BY, CREATED_BY, TELEPHONE, 
 SESSION_NO, SETTLE_DAY, AORC, YIELDMAT, DML_TYPE, 
 NEW_DATA)
AS 
SELECT "ORDER_ID","ORG_ORDER_ID","FLOOR_CODE","ORDER_CONFIRM_NO","ORDER_NO","CO_ORDER_NO","ORG_ORDER_NO","ORDER_DATE","ORDER_TIME","MEMBER_ID","CO_MEMBER_ID","ACCOUNT_ID","CO_ACCOUNT_ID","STOCK_ID","ORDER_TYPE","PRIORITY","OORB","NORP","NORC","BORE","AORI","SETTLEMENT_TYPE","DORF","ORDER_QTTY","ORDER_PRICE","STATUS","QUOTE_PRICE","STATE","QUOTE_TIME","QUOTE_QTTY","EXEC_QTTY","CORRECT_QTTY","CANCEL_QTTY","REJECT_QTTY","REJECT_REASON","ACCOUNT_NO","CO_ACCOUNT_NO","BROKER_ID","CO_BROKER_ID","DELETED","DATE_CREATED","DATE_MODIFIED","MODIFIED_BY","CREATED_BY","TELEPHONE","SESSION_NO","SETTLE_DAY","AORC","YIELDMAT","DML_TYPE","NEW_DATA" FROM sts_orders_hnx UNION ALL SELECT "ORDER_ID","ORG_ORDER_ID","FLOOR_CODE","ORDER_CONFIRM_NO","ORDER_NO","CO_ORDER_NO","ORG_ORDER_NO","ORDER_DATE","ORDER_TIME","MEMBER_ID","CO_MEMBER_ID","ACCOUNT_ID","CO_ACCOUNT_ID","STOCK_ID","ORDER_TYPE","PRIORITY","OORB","NORP","NORC","BORE","AORI","SETTLEMENT_TYPE","DORF","ORDER_QTTY","ORDER_PRICE","STATUS","QUOTE_PRICE","STATE","QUOTE_TIME","QUOTE_QTTY","EXEC_QTTY","CORRECT_QTTY","CANCEL_QTTY","REJECT_QTTY","REJECT_REASON","ACCOUNT_NO","CO_ACCOUNT_NO","BROKER_ID","CO_BROKER_ID","DELETED","DATE_CREATED","DATE_MODIFIED","MODIFIED_BY","CREATED_BY","TELEPHONE","SESSION_NO","SETTLE_DAY","AORC","YIELDMAT","DML_TYPE","NEW_DATA" FROM sts_orders_upcom
/
