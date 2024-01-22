SET DEFINE OFF;
CREATE OR REPLACE FUNCTION get_voting_list (p_camastid varchar2)
   RETURN VARCHAR2
IS
/*===================================
creater                    createdate
thunt                      13/01/2020
===================================*/
   l_voting VARCHAR2(4000) := NULL;
BEGIN
   FOR i IN
   (SELECT (votecode||'. '||voting) voting, votecode
      FROM cavoting where camastid = p_camastid order by REGEXP_SUBSTR(VOTECODE, '^\D*') NULLS FIRST, TO_NUMBER(REGEXP_SUBSTR(VOTECODE, '\d+')) DESC
   )
   LOOP
      l_voting := i.voting || '<br/>' ||l_voting;
   END LOOP;
dbms_output.put_line('Email ' || l_voting);
RETURN REPLACE(l_voting,'''','''''');
EXCEPTION
WHEN OTHERS THEN
   dbms_output.put_line('Exception in mail function :'||SQLCODE||SQLERRM);
   RETURN '-1';
END;
/
