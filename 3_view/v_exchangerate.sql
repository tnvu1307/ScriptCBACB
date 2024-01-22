SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW V_EXCHANGERATE
(LASTCHANGE, ITYPE, CURRENCY, TTM, TTB, 
 TTS, USR, QUO)
AS 
select to_char(LASTCHANGE,'dd/MM/yyyy hh24:mi:ss') LASTCHANGE,
                    ITYPE,CURRENCY,
                   MAX(case when RTYPE = 'TTM' then to_char(VND) else '--' end) TTM,
                   MAX(case when RTYPE = 'TTB' then to_char(VND) else '--' end) TTB,
                   MAX(case when RTYPE = 'TTS' then to_char(VND) else '--' end) TTS,
                   MAX(case when RTYPE = 'USR' then to_char(VND) else '--' end) USR,
                    MAX(case when RTYPE = 'QUO' then to_char(VND) else '--' end) QUO
    from exchangerate
        group by ITYPE,CURRENCY,LASTCHANGE
/
