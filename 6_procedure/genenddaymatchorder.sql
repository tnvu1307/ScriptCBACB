SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE genenddaymatchorder
IS
    l_datasource varchar2(4000);
    l_mobile varchar2(20);

BEGIN
    FOR rec IN (

          select nvl(cf.mobilesms,'') mobilesms, cf.custodycd, /*listagg(detail, ', ') within group(order by detail)  as detail*/ detail,txdate, afacctno
                    from (
                            select max(autoid) autoid, custodycd, afacctno, txdate, FLOOR(rnorder/100) grporder,
                               -- (MAX(ORDERQTTY) - max(TOTALQTTY)) as KLCL ,
                               -- upper(substr(header,1,3)) || ' ' ||
                                 --MAX(ORDERQTTY) || ' ' ||  ltrim(substr(header,4))  || 'DA KHOP ' ||
                                listagg(detail, '; ') within group(order by detail)  as detail
                            from
                                (select a.*, ROW_NUMBER() OVER (PARTITION BY afacctno ORDER BY autoid desc) - 1 rnorder
                                    from (select max(autoid) autoid, txdate, custodycd, max(TOTALQTTY) TOTALQTTY, max(afacctno) afacctno, --sum(ORDERQTTY) orderqtty,
                                                substr(max(header),1,3) || ' (' || substr(max(header),5) || sum(matchqtty) || ', ' || trim(to_char(matchprice/1000, '999.999')) || ')' as detail
                                            from smsmatched
                                            where status = 'N'
                                            group by txdate, custodycd, header,  matchprice
                                            order by autoid) a)
                                   group by custodycd,  txdate, afacctno, FLOOR(rnorder/100)
                                   order by autoid) od, vw_cfmast_sms cf
                                   where cf.custodycd = od.custodycd
                     --group by cf.custodycd, od.txdate, afacctno, nvl(cf.mobilesms,'')
    /*
                    select custodycd, 'PHS-KQKL ' || to_char(txdate, 'DD/MM/RRRR') || ' TK ' || custodycd || ': ' || listagg(detail, ', ') within group(order by detail)  as detail ,txdate
                    from (
                            select max(autoid) autoid, custodycd, orderid, txdate,
                                (MAX(ORDERQTTY) - max(TOTALQTTY)) as KLCL ,
                                upper(substr(header,1,3)) || ' ' || MAX(ORDERQTTY) || ' ' ||  ltrim(substr(header,4))  || 'DA KHOP ' ||
                                listagg(detail, ', ') within group(order by detail)  as detail
                            from
                                (select a.*, rownum top
                                    from (select max(autoid) autoid, txdate, custodycd, orderid, header,max(TOTALQTTY) TOTALQTTY,ORDERQTTY,price,
                                                sum(matchqtty) || ' GIA ' || matchprice as detail
                                            from smsmatched
                                            where status = 'N'
                                            group by txdate, custodycd, orderid, header, matchprice ,ORDERQTTY,price
                                            order by autoid) a)
                                   group by custodycd, orderid, txdate, header ,price
                                   order by autoid)
                     group by custodycd, txdate*/
                 )
    LOOP
        /*BEGIN
            select mobilesms into l_mobile
            from vw_cfmast_sms where custodycd=rec.custodycd;
        exception
        when others then
            l_mobile:= '';
        end;*/

        l_mobile := nvl(rec.mobilesms,'');

        l_datasource := NULL;
        IF LENGTH(l_mobile) > 0 THEN
            FOR rec2 IN (
                SELECT REGEXP_SUBSTR (rec.detail,
                                         '[^;]+',
                                         1,
                                         LEVEL)
                             TXT
                        FROM DUAL
                        CONNECT BY REGEXP_SUBSTR (rec.detail,
                                         '[^;]+',
                                         1,
                                         LEVEL)
                             IS NOT NULL
            )
            LOOP
                --dbms_output.put_line('rec2.txt: ' || rec2.txt);
                IF l_datasource IS NULL OR l_datasource = '' THEN
                    l_datasource := 'PHS-KQKL ' || to_char(rec.txdate, 'DD/MM/RRRR') || ' ' || rec.custodycd || ':';
                END IF;
                IF length(l_datasource) + length (' ') + length(trim(rec2.txt)) + length (';') <= 160 THEN
                    l_datasource := l_datasource || ' ' || trim(rec2.txt) || ';';
                    --dbms_output.put_line(l_datasource || ' - ' || length(l_datasource));
                ELSE
                    --dbms_output.put_line('insert vao db: ' || l_datasource || ' - ' || length(l_datasource));
                    --TruongLD Add, rec.afacctno
                    nmpks_ems.InsertEmailLog(l_mobile, '303S', l_datasource, rec.afacctno);
                    l_datasource := 'PHS-KQKL ' || to_char(rec.txdate, 'DD/MM/RRRR') || ' ' || rec.custodycd || ':';
                    l_datasource := l_datasource || ' ' || trim(rec2.txt) || ';';
                END IF;
            END LOOP;
       -- END IF;

        --IF LENGTH(l_mobile) > 0 THEN

          -- nmpks_ems.InsertEmailLog(l_mobile, '303S', l_datasource, '');

            update smsmatched
            set status = 'S'
            where  status = 'N'
            and custodycd=rec.custodycd;
        --END IF;
        IF length(l_datasource) > 0 AND length(l_mobile) > 0 THEN
            nmpks_ems.InsertEmailLog(l_mobile, '303S', l_datasource, rec.afacctno);
        END IF;
       END IF;
    END LOOP;

EXCEPTION
    when others then
      pr_error('error', 'genenddaymatchorder: error:'||SQLERRM || dbms_utility.format_error_backtrace);
END;
 
 
/
