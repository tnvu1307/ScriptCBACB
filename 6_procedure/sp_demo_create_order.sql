SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE SP_DEMO_CREATE_ORDER (intcount IN NUMBER)
  IS
v_AFACCTNO                    VARCHAR2(20);
v_errcode           NUMBER(20,4);
v_BUYCODEID     VARCHAR2(20);
v_BUYPRICE      NUMBER(20,4);
v_SELLCODEID    VARCHAR2(20);
v_SELLPRICE     NUMBER(20,4);
v_RQSID         VARCHAR2(50);
v_count              NUMBER(20,4);
CURSOR c1
    IS SELECT ACCTNO FROM  AFMAST WHERE ACTYPE='0000' and acctno <='0001900100' ORDER BY ACCTNO;
BEGIN
  --BUY INFORMATION
  SELECT CODEID, CEILINGPRICE/TRADEUNIT INTO v_BUYCODEID, v_BUYPRICE FROM SECURITIES_INFO WHERE SYMBOL='STB';
  --SELL INFORMATION
  SELECT CODEID, FLOORPRICE/TRADEUNIT INTO v_SELLCODEID, v_SELLPRICE FROM SECURITIES_INFO WHERE SYMBOL='SSI';

   v_count:=0;
   OPEN c1;
   LOOP
      FETCH c1 INTO v_AFACCTNO;
      EXIT WHEN v_count > intcount; 
                  --OR c1%NOTFOUND;
                  SELECT TO_CHAR(SYSTIMESTAMP) INTO v_RQSID FROM DUAL;
                  sp_placeorder(v_AFACCTNO,'NB','','STB','LO',v_BUYPRICE,1000000,v_RQSID || 1,v_errcode);
                  sp_placeorder(v_AFACCTNO,'NS','','SSI','LO',v_SELLPRICE,1000000,v_RQSID || 2,v_errcode);
                  sp_placeorder(v_AFACCTNO,'NS','','SSI','LO',v_SELLPRICE,1000000,v_RQSID || 3,v_errcode);
                  COMMIT;   
                  v_count:=v_count+1;
   END LOOP;
   CLOSE c1;
  RETURN;
END; 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
/
