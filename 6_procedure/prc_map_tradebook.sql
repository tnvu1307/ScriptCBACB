SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE prc_map_tradebook 
   IS
   
   V_COUNT NUMBER(10);
   V_SQL varchar2(500);
BEGIN
         dbms_output.put_line(' start '||to_char(sysdate,'hh24:mi:ss'));
         --Dua cac lenh moi vao bang ket qua khop lenh tam thoi.
         INSERT INTO STCTRADEBOOKTEMP (TXDATE,
                              CONFIRMNUMBER,
                              REFCONFIRMNUMBER,
                              ORDERNUMBER,
                              BORS,
                              VOLUME,
                              PRICE)
       SELECT TXDATE,
                              CONFIRMNUMBER,
                              REFCONFIRMNUMBER,
                              ORDERNUMBER,
                              BORS,
                              VOLUME,
                              PRICE
       FROM (                                                     
            SELECT      ORDER_DATE TXDATE, ORDER_CONFIRM_NO CONFIRMNUMBER,  ORDER_CONFIRM_NO REFCONFIRMNUMBER,
                        CO_ORDER_NO  ORDERNUMBER, 'S' BORS,  ORDER_QTTY VOLUME, ORDER_PRICE PRICE
            FROM        STS_ORDERS  S 
            WHERE (NORC = 5 OR (NORC= 7 AND STATUS=4 )) 
            AND SUBSTR(CO_ACCOUNT_NO,1,3) =(SELECT VARVALUE FROM SYSVAR WHERE VARNAME ='COMPANYCD')

            UNION ALL
            SELECT      ORDER_DATE TXDATE, ORDER_CONFIRM_NO CONFIRMNUMBER,  ORDER_CONFIRM_NO REFCONFIRMNUMBER,
                        ORDER_NO  ORDERNUMBER, 'B' BORS,  ORDER_QTTY VOLUME, ORDER_PRICE PRICE
            FROM        STS_ORDERS  S 
            WHERE (NORC = 5 OR (NORC= 7 AND STATUS=4 )) 
            AND SUBSTR(ACCOUNT_NO,1,3) =(SELECT VARVALUE FROM SYSVAR WHERE VARNAME ='COMPANYCD')
        ) S
        
        WHERE NOT EXISTS (SELECT REFCONFIRMNUMBER FROM STCTRADEBOOK WHERE REFCONFIRMNUMBER =S.CONFIRMNUMBER);
        
        /*
        INSERT INTO STCTRADEBOOKTEMP
                SELECT * FROM STCTRADEBOOKBUFFER S WHERE  NOT EXISTS
                (SELECT REFCONFIRMNUMBER FROM STCTRADEBOOK WHERE REFCONFIRMNUMBER =S.REFCONFIRMNUMBER);

        */
        --Cap nhat STCTRADEBOOK cho nhung lenh da duoc map (o bang STCORDERBOOK)
        INSERT INTO STCTRADEBOOK
                SELECT * FROM STCTRADEBOOKTEMP WHERE SUBSTR(REFCONFIRMNUMBER,1,2) || ORDERNUMBER IN
                (SELECT SUBSTR(REFORDERNUMBER,1,2) || ORDERNUMBER FROM STCORDERBOOK);


        --Xoa nhung DEAL trong STCTRADEBOOKTEMP ma co ban ghi trong STCTRADEBOOK
        DELETE FROM STCTRADEBOOKTEMP S WHERE EXISTS
                (SELECT REFCONFIRMNUMBER FROM STCTRADEBOOK WHERE REFCONFIRMNUMBER=S.REFCONFIRMNUMBER);


        --Xoa di nhung DEAL khop lenh trong STCTRADEBOOKEXP ma khong xuat hien trong STCTRADEBOOKTEMP
        DELETE FROM STCTRADEBOOKEXP S WHERE  NOT EXISTS
                (SELECT REFCONFIRMNUMBER FROM STCTRADEBOOKTEMP WHERE REFCONFIRMNUMBER =S.REFCONFIRMNUMBER);

        --Day vao trong STCORDERBOOKEXP nhung lenh exception moi
        INSERT INTO STCTRADEBOOKEXP SELECT * FROM STCTRADEBOOKTEMP S WHERE  NOT EXISTS
                (SELECT REFCONFIRMNUMBER FROM STCTRADEBOOKEXP WHERE REFCONFIRMNUMBER=S.REFCONFIRMNUMBER);

        dbms_output.put_line(' finnish '||to_char(sysdate,'hh24:mi:ss'));
   EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
END;
 
 
/
