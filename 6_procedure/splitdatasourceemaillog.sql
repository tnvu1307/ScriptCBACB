SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE SplitDatasourceEmaillog
    (
           p_email varchar2,
           p_templateid varchar2,
           p_datasource varchar2,
           p_afacctno varchar2
    )
IS
    l_datasource varchar2(2000);
    l_content varchar2(2000);
    l_foo varchar2(2000);
    iscount NUMBER;
    l_split varchar2(2000);
BEGIN
    l_datasource := p_datasource;
    l_split := 'custodycd,fullname,marginrate,addvnd';
    iscount := 0;
    l_datasource := REPLACE(l_datasource,'select ','');
    IF p_templateid = '106S' THEN
        --l_content := 'PHS-TB: So TK [custodycd] - [fullname] can bo sung so tien [addvnd] d de dam bao ti le ky quy theo quy dinh.';
        l_content := 'PHS TB: [custodycd]. '
            ||'Ty le thuc te(Rtt) [marginrate]%. '
            ||'So tien bo sung [addvnd] dong. '
            ||'Rtt<Rat va/hoac co no qua han, '
            ||'PHS co quyen ban giai chap ve Rat quy dinh';

    --SELECT datasource INTO bar from emailloghist WHERE templateid = '106E' AND status = 'S';
        FOR FOO IN (    SELECT REGEXP_SUBSTR (l_datasource,
                                             '[^,]+',
                                             1,
                                             LEVEL)
                                 TXT
                         FROM DUAL
                   CONNECT BY REGEXP_SUBSTR (l_datasource,
                                             '[^,]+',
                                             1,
                                             LEVEL)
                                 IS NOT NULL)
        LOOP
            for rec2 IN (SELECT REGEXP_SUBSTR (l_split,
                                             '[^,]+',
                                             1,
                                             LEVEL)
                                 TXT
                         FROM DUAL
                   CONNECT BY REGEXP_SUBSTR (l_split,
                                             '[^,]+',
                                             1,
                                             LEVEL)
                                 IS NOT NULL)
            LOOP
                IF INSTR(FOO.TXT, ' ' || upper(rec2.txt)) > 0 THEN
                    --l_datasource := foo.txt;
                    l_content := replace(l_content, rec2.txt, replace(foo.txt, ' ' || upper(rec2.txt), ''));
                    l_content := replace(l_content, '[''', '');
                    l_content := replace(l_content, ''']', '');
                    --pr_error('SplitDatasourceEmaillog', 'error: ' || l_content);
                END IF;
            END LOOP;
          --l_content := replace(foo,' FULLNAME', '');
          --DBMS_OUTPUT.PUT_LINE (l_foo);

        END LOOP;
        nmpks_ems.InsertEmailLog(p_email,
                             '106S',
                             l_content,
                             p_afacctno);
    ELSIF p_templateid = '114S' THEN
        l_content := 'PHS TB: TK [custodycd]. '
            ||'Ty le KQ thuc te [marginrate]%. '
            ||'Ty le KQ thuc te < Ty le an toan va/hoac co No qua han, PHS thong bao ban giai chap TK theo quy dinh';

    --SELECT datasource INTO bar from emailloghist WHERE templateid = '106E' AND status = 'S';
        FOR FOO IN (    SELECT REGEXP_SUBSTR (l_datasource,
                                             '[^,]+',
                                             1,
                                             LEVEL)
                                 TXT
                         FROM DUAL
                   CONNECT BY REGEXP_SUBSTR (l_datasource,
                                             '[^,]+',
                                             1,
                                             LEVEL)
                                 IS NOT NULL)
        LOOP
            for rec2 IN (SELECT REGEXP_SUBSTR (l_split,
                                             '[^,]+',
                                             1,
                                             LEVEL)
                                 TXT
                         FROM DUAL
                   CONNECT BY REGEXP_SUBSTR (l_split,
                                             '[^,]+',
                                             1,
                                             LEVEL)
                                 IS NOT NULL)
            LOOP
                IF INSTR(FOO.TXT, ' ' || upper(rec2.txt)) > 0 THEN
                    --l_datasource := foo.txt;
                    l_content := replace(l_content, rec2.txt, replace(foo.txt, ' ' || upper(rec2.txt), ''));
                    l_content := replace(l_content, '[''', '');
                    l_content := replace(l_content, ''']', '');
                    --pr_error('SplitDatasourceEmaillog', 'error: ' || l_content);
                END IF;
            END LOOP;
          --l_content := replace(foo,' FULLNAME', '');
          --DBMS_OUTPUT.PUT_LINE (l_foo);

        END LOOP;
        nmpks_ems.InsertEmailLog(p_email,
                             '114S',
                             l_content,
                             p_afacctno);
    END IF;
EXCEPTION
   WHEN OTHERS THEN

            pr_error('SplitDatasourceEmaillog', 'error:' || to_char(dbms_utility.format_error_backtrace));
            ---raise;
END;
 
 
/
