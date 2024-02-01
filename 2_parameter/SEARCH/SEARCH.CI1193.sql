SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CI1193','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CI1193', 'Danh sách khách hàng hoàn phí', 'List of fee deducted customer ', 'select cf.custodycd,af.acctno,cf.fullname,cf.ADDRESS, cf.idcode LICENSE ,cf.iddate, cf.idplace,
     TRUNC(BALDEFOVD) AVLCASH ,''005'' WDRTYPE, TRUNC(cit.amt) amt ,TRUNC(cit.amtold) amtold  , fullname CUSTNAME,
     CASE WHEN  BALDEFOVD -cit.amt >=0 THEN ''Y'' ELSE ''N'' END ISPAY ,
     ''BSC THU HỒI LÃI KHÔNG KỲ HẠN TRẢ THỪA T2,T3/2014 (LS THỰC TẾ 1,2%, LS ĐÃ TRẢ 3%)'' DESCRIPTION,
     AL.CDCONTENT CUSTYPE
      from crintacr_temp cit, buf_ci_account ci,cfmast cf, afmast af,ALLCODE al
     where cit.afacctno = ci.afacctno
     and ci.afacctno = af.acctno
     and af.custid = cf.custid
     AND TRUNC(cit.amt) >=1000
     and cf.custtype= al.cdval
     and al.cdname=''CUSTTYPE''
     and al.cdtype=''CF''
     AND AF.STATUS<>''C''
     and af.corebank=''N''
     and cit.status =''N''
     ', 'BANKINFO', 'CI1193', NULL, '1193', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;