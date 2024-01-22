SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE pr_cancel_order_reject(p_orderid VARCHAR2) IS
BEGIN
    update odmast set remainqtty = 0, orstatus = 6 where orderid = p_orderid;
    update ood set deltd ='Y' where ORGorderid = p_orderid;
    pr_error('pr_cancel_order_reject', 'p_orderid:' || p_orderid);
END;
/
