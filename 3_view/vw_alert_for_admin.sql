SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_ALERT_FOR_ADMIN
(STT, AUTOID, DESCSCRIPTION)
AS 
select rownum stt, autoid, autoid ||': '|| paytype DESCSCRIPTION
        from
        (
            SELECT p.objlogid autoid,p.paytype,p.codeid  FROM payschedule p
               
           )
/
