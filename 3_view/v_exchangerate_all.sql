SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW V_EXCHANGERATE_ALL
(LASTCHANGE, ITYPE, CURRENCY, QUO, REFNO)
AS 
select to_char(LASTCHANGE,'dd/MM/yyyy hh24:mi:ss') LASTCHANGE, ITYPE,CURRENCY, to_char(VND) QUO, NOTE REFNO                   
    from exchangerate
        where rtype = 'QUO'
union all
select to_char(LASTCHANGE,'dd/MM/yyyy hh24:mi:ss') LASTCHANGE, ITYPE,CURRENCY, to_char(VND) QUO, NOTE REFNO                   
    from exchangerate_hist
        where rtype = 'QUO'
/
