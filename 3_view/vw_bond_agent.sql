SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_BOND_AGENT
(TYPE, TASK, DEADLINE, SYMBOL, ISSUEDATE)
AS 
select "TYPE","TASK","DEADLINE","SYMBOL","ISSUEDATE"from  
(
    --type1
    select 'type1' type,   'task1' task,to_char(getpdate_next(CONTRACTDATE,10)) deadline,symbol,ISSUEDATE
        from SBSECURITIES
        where   getpdate_next(CONTRACTDATE,1) <= (select to_date(varvalue,'dd/MM/RRRR') varvalue from sysvar where varname = 'CURRDATE') and (select to_date(varvalue,'dd/MM/RRRR') varvalue from sysvar where varname = 'CURRDATE') <= getpdate_next(CONTRACTDATE,10) and sectype = '006' or(sectype = '015' and TRADEPLACE ='003')
    union all
    select 'type1' type, 'task2' task,to_char(getpdate_next(ISSUEDATE,3)) deadline,symbol,ISSUEDATE
        from SBSECURITIES
        where   getpdate_next(ISSUEDATE,1) <= (select to_date(varvalue,'dd/MM/RRRR') varvalue from sysvar where varname = 'CURRDATE') and (select to_date(varvalue,'dd/MM/RRRR') varvalue from sysvar where varname = 'CURRDATE') <= getpdate_next(ISSUEDATE,3) and sectype = '006' or(sectype = '015' and TRADEPLACE ='003')
    union all
    select 'type1' type, 'task4' task,to_char(getpdate_next(ISSUEDATE,5)) deadline,symbol,ISSUEDATE
        from SBSECURITIES
        where   getpdate_next(ISSUEDATE,1) <= (select to_date(varvalue,'dd/MM/RRRR') varvalue from sysvar where varname = 'CURRDATE') and (select to_date(varvalue,'dd/MM/RRRR') varvalue from sysvar where varname = 'CURRDATE') <= getpdate_next(ISSUEDATE,5) and sectype = '006' or(sectype = '015' and TRADEPLACE ='003')
    union all
    select 'type1' type,'task3' task,to_char(getpdate_next(ISSUEDATE,3)) deadline,symbol,ISSUEDATE
        from SBSECURITIES
        where  getpdate_next(ISSUEDATE,1) <= (select to_date(varvalue,'dd/MM/RRRR') varvalue from sysvar where varname = 'CURRDATE') and (select to_date(varvalue,'dd/MM/RRRR') varvalue from sysvar where varname = 'CURRDATE') <= getpdate_next(ISSUEDATE,3) and sectype = '006' or(sectype = '015' and TRADEPLACE ='003')
    union all
    --type2
    select 'type2' type, 'task5' task, to_char(getpdate_next(ISSUEDATE,5)) deadline,symbol,ISSUEDATE
        from SBSECURITIES
        where   getpdate_next(ISSUEDATE,1) <= (select to_date(varvalue,'dd/MM/RRRR') varvalue from sysvar where varname = 'CURRDATE') and (select to_date(varvalue,'dd/MM/RRRR') varvalue from sysvar where varname = 'CURRDATE') <= getpdate_next(ISSUEDATE,5) and sectype = '006' or(sectype = '015' and TRADEPLACE ='003')
    union all
    --type3
    select 'type3' type, 'task6' task,to_char(fn_check_holiday(ADD_MONTHS(ISSUEDATE,3))) deadline,symbol,ISSUEDATE
        from SBSECURITIES
        where   getpdate_next(ISSUEDATE,1) <= (select to_date(varvalue,'dd/MM/RRRR') varvalue from sysvar where varname = 'CURRDATE') and (select to_date(varvalue,'dd/MM/RRRR') varvalue from sysvar where varname = 'CURRDATE') <= fn_check_holiday(ADD_MONTHS(ISSUEDATE,3)) and sectype = '006' or(sectype = '015' and TRADEPLACE ='003')
    union all
    --type4
    select 'type4' type,'task8' task,to_char(getpdate_next(v.txdate,1)) deadline,sb.symbol,sb.ISSUEDATE
        from vw_tllog_all v,
                (
                      SELECT   txnum,txdate,
                             MAX (CASE WHEN f.fldcd = '02' THEN f.cvalue ELSE '' END)  SYMBOL
                      FROM   vw_tllogfld_all f
                      WHERE   fldcd IN ('02')
                      GROUP BY   txnum,txdate
                 ) f,(select *from sbsecurities where sectype = '006' or(sectype = '015' and TRADEPLACE ='003'))  sb
        where   v.tltxcd = '1911'
            and v.txnum = f.txnum
            and v.txdate = f.txdate
            and f.symbol = sb.symbol(+)
            and v.txdate <= (select to_date(varvalue,'dd/MM/RRRR') varvalue from sysvar where varname = 'CURRDATE') and (select to_date(varvalue,'dd/MM/RRRR') varvalue from sysvar where varname = 'CURRDATE') <= getpdate_next(v.txdate,1) 
    union all
    select 'type4' type, 'task9' task, to_char(getpdate_next(v.txdate,1)) deadline,sb.symbol,sb.ISSUEDATE
        from vw_tllog_all v,
                (
                      SELECT   txnum,txdate,
                             MAX (CASE WHEN f.fldcd = '02' THEN f.cvalue ELSE '' END)  SYMBOL
                      FROM   vw_tllogfld_all f
                      WHERE   fldcd IN ('02')
                      GROUP BY   txnum,txdate
                 ) f,(select *from sbsecurities where sectype = '006' or(sectype = '015' and TRADEPLACE ='003'))  sb
        where   v.tltxcd = '1911'
            and v.txnum = f.txnum
            and v.txdate = f.txdate
            and f.symbol = sb.symbol(+)
            and v.txdate <= (select to_date(varvalue,'dd/MM/RRRR') varvalue from sysvar where varname = 'CURRDATE') and (select to_date(varvalue,'dd/MM/RRRR') varvalue from sysvar where varname = 'CURRDATE') <= getpdate_next(v.txdate,1) 
    union all
    --type5
    select 'type5' type, 'task11' task,to_char(fn_check_holiday_return_nextdate(getpdate_next(b.ACTUALPAYDATE,3))) deadline,sb.symbol,sb.ISSUEDATE
        from (select min(ACTUALPAYDATE) ACTUALPAYDATE,bondsymbol from  BONDTYPEPAY group by bondsymbol )b,(select *from sbsecurities where sectype = '006' or(sectype = '015' and TRADEPLACE ='003')) sb --min ngay thanh toan
        where b.bondsymbol = sb.symbol and  fn_get_prevdate(b.ACTUALPAYDATE,21) <= (select to_date(varvalue,'dd/MM/RRRR') varvalue from sysvar where varname = 'CURRDATE') and (select to_date(varvalue,'dd/MM/RRRR') varvalue from sysvar where varname = 'CURRDATE') <= fn_check_holiday_return_nextdate(getpdate_next(b.ACTUALPAYDATE,3))
    union all
    select 'type5' type,'task12' task,to_char(fn_check_holiday_return_nextdate(getpdate_next(b.ACTUALPAYDATE,3))) deadline,sb.symbol,sb.ISSUEDATE
        from (select min(ACTUALPAYDATE) ACTUALPAYDATE,bondsymbol from  BONDTYPEPAY group by bondsymbol )b ,(select *from sbsecurities where sectype = '006' or(sectype = '015' and TRADEPLACE ='003')) sb--min ngay thanh toan
        where  b.bondsymbol = sb.symbol and fn_get_prevdate(b.ACTUALPAYDATE,15) <= (select to_date(varvalue,'dd/MM/RRRR') varvalue from sysvar where varname = 'CURRDATE') and (select to_date(varvalue,'dd/MM/RRRR') varvalue from sysvar where varname = 'CURRDATE') <= fn_check_holiday_return_nextdate(getpdate_next(b.ACTUALPAYDATE,3))
    union all
    select 'type5' type, 'task13' task,to_char(c.RECORDDATE) deadline,sb.symbol,sb.ISSUEDATE
        from (select max(RECORDDATE) RECORDDATE ,bondsymbol from  BONDTYPEPAY group by bondsymbol)c ,(select *from sbsecurities where sectype = '006' or(sectype = '015' and TRADEPLACE ='003')) sb--max ngay dang ky 
        where   c.RECORDDATE = (select to_date(varvalue,'dd/MM/RRRR') varvalue from sysvar where varname = 'CURRDATE') and c.bondsymbol = sb.symbol 
    union all
    select 'type5' type,'task14'task,to_char(getpdate_next(c.RECORDDATE,1))deadline,sb.symbol,sb.ISSUEDATE
        from (select max(RECORDDATE) RECORDDATE ,bondsymbol from  BONDTYPEPAY group by bondsymbol)c,(select *from sbsecurities where sectype = '006' or(sectype = '015' and TRADEPLACE ='003')) sb --max ngay dang ky 
        where   getpdate_next(c.RECORDDATE,1) = (select to_date(varvalue,'dd/MM/RRRR') varvalue from sysvar where varname = 'CURRDATE') and c.bondsymbol = sb.symbol 
    union all
    select 'type5' type,'task15' task,to_char(fn_get_prevdate(b.ACTUALPAYDATE,2))  deadline,sb.symbol,sb.ISSUEDATE
        from (select min(ACTUALPAYDATE) ACTUALPAYDATE,bondsymbol from  BONDTYPEPAY group by bondsymbol )b,(select *from sbsecurities where sectype = '006' or(sectype = '015' and TRADEPLACE ='003')) sb --min ngay thanh toan
        where   fn_get_prevdate(b.ACTUALPAYDATE,2) = (select to_date(varvalue,'dd/MM/RRRR') varvalue from sysvar where varname = 'CURRDATE') or (select to_date(varvalue,'dd/MM/RRRR') varvalue from sysvar where varname = 'CURRDATE') = b.ACTUALPAYDATE and b.bondsymbol = sb.symbol 
    union all
    select 'type5' type,'task16' task,to_char(b.ACTUALPAYDATE) deadline,sb.symbol,sb.ISSUEDATE
        from (select min(ACTUALPAYDATE) ACTUALPAYDATE,bondsymbol from  BONDTYPEPAY group by bondsymbol )b,(select *from sbsecurities where sectype = '006' or(sectype = '015' and TRADEPLACE ='003')) sb  --min ngay thanh toan
        where   fn_get_prevdate(b.ACTUALPAYDATE,2) = (select to_date(varvalue,'dd/MM/RRRR') varvalue from sysvar where varname = 'CURRDATE') or (select to_date(varvalue,'dd/MM/RRRR') varvalue from sysvar where varname = 'CURRDATE') = b.ACTUALPAYDATE  and b.bondsymbol = sb.symbol
    union all
    select 'type6' type, 'task17' task,to_char(getpdate_next(EXPDATE,10)) deadline,symbol,ISSUEDATE
        from SBSECURITIES 
        where   EXPDATE = (select to_date(varvalue,'dd/MM/RRRR') varvalue from sysvar where varname = 'CURRDATE')   and sectype = '006' or(sectype = '015' and TRADEPLACE ='003')
) a
order by deadline
-- Start of DDL Script for View HOSTSHVTEST.VW_BOND_AGENT
-- Generated 03-Aug-2020 09:28:56 from HOSTSHVTEST@FLEX191
/
