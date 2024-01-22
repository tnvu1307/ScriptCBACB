SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CF1513','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CF1513', 'Tra cứu đối chiếu SID', 'Tra cuu doi chieu SID', 'SELECT a.CUSTODYCD, a.VSDMSGID, a.PCOD,A.SIDN, a.LNAM1 ,a.LNAM2, NVL(a0.CDCONTENT,'''') IDTY1, NVL(a1.CDCONTENT,'''') IDTY2 , a.idsn1, a.idsn2,
 to_char (to_date (a.idid1, ''RRRRMMDD'') , ''DD/MM/RRRR'') idid1 ,  to_char (to_date (a.idid2, ''RRRRMMDD'') , ''DD/MM/RRRR'') idid2,
  to_char (to_date (a.bird1, ''RRRRMMDD'') , ''DD/MM/RRRR'') bird1 ,  to_char (to_date (a.bird2, ''RRRRMMDD'') , ''DD/MM/RRRR'') bird2,
  nvl(a3.cdcontent,'''') cour1, nvl(a4.cdcontent,'''') cour2, a.taxn1, a.taxn2, nvl(a5.cdcontent, '''') ptyp1,  nvl(a6.cdcontent, '''') ptyp2 ,
  A.HLDC1, A.HLDC2,
  A7.CDCONTENT gend1, A8.CDCONTENT GEND2,
  A.ITYP1, A.ITYP2,
  A.ADRF1, A.ADRF2,A.PHNM1, A.PHNM2, A.MAIL1, A.MAIL2
  FROM COMPARESID a,(select * FROM ALLCODE WHERE CDTYPE = ''CF'' AND CDNAME = ''IDTYPESID'' ) A0,
                    (select * FROM ALLCODE WHERE CDTYPE = ''CF'' AND CDNAME = ''IDTYPESID'' ) A1,
                    (select a1.CDCONTENT , a2.CDCONTENT cdval from allcode  a1, allcode a2
                     where  a1.cdtype =''CF'' and a1.CDNAME = ''COUNTRY''
                         and a2.cdtype =''CF'' and a2.cdname = ''NATIONAL''
                         and a2.cdval = a1.cdval ) A3,
                     (select a1.CDCONTENT , a2.CDCONTENT cdval from allcode  a1, allcode a2
                      where  a1.cdtype =''CF'' and a1.CDNAME = ''COUNTRY''
                         and a2.cdtype =''CF'' and a2.cdname = ''NATIONAL''
                         and a2.cdval = a1.cdval ) a4,
                    (select * FROM ALLCODE WHERE CDTYPE = ''CF'' AND CDNAME = ''CUSTTYPESID'' ) A5,
                    (select * FROM ALLCODE WHERE CDTYPE = ''CF'' AND CDNAME = ''CUSTTYPESID'' ) A6,
                    (select * FROM ALLCODE WHERE CDTYPE = ''CF'' AND CDNAME = ''SEX'' ) A7,
                    (select * FROM ALLCODE WHERE CDTYPE = ''CF'' AND CDNAME = ''SEX'' ) A8
 WHERE a.IDTY1 = A0.CDVAL (+) AND a.IDTY2 = A1.CDVAL (+)
   and a.cour1 = a3.cdval (+) and a.cour2 = a4.cdval (+)
   and a.ptyp1 = a5.cdval (+) and a.ptyp2 = a6.cdval (+)
   and DECODE (a.GEND1, ''M'',''001'',''F'', ''002'',''000'' )= a7.cdval and DECODE (a.GEND2, ''M'',''001'',''F'', ''002'',''000'' ) = a8.cdval (+)', 'CF1513', '', '', '', 0, 50, 'N', 30, '', 'Y', 'T', '', 'N', '');COMMIT;