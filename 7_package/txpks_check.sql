SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_check
IS


TYPE ddmastcheck_rectype IS RECORD (
      acctno           ddmast.acctno%TYPE,
      ccycd            ddmast.ccycd%TYPE,
      afacctno         ddmast.afacctno%TYPE,
      custid           ddmast.custid%TYPE,
      opndate          ddmast.opndate%TYPE,
      clsdate          ddmast.clsdate%TYPE,
      lastchange         ddmast.lastchange%TYPE,
      status           ddmast.status%type,
      pstatus          ddmast.pstatus%type,
      balance          ddmast.balance%type,
      holdbalance      ddmast.holdbalance%type,
      bankbalance          ddmast.bankbalance%type,
      bankholdbalance      ddmast.bankholdbalance%type,
      pendinghold      ddmast.pendinghold%type,
      pendingunhold    ddmast.pendingunhold%type,
      refcasaacct         ddmast.refcasaacct%type,
      receiving        ddmast.receiving%type,
      netting          ddmast.netting%type,
      pp               number (38, 4)

   );

   TYPE ddmastcheck_arrtype IS TABLE OF ddmastcheck_rectype
      INDEX BY PLS_INTEGER;

  FUNCTION fn_ddmastcheck (
      pv_condvalue   IN   VARCHAR2,
      pv_tblname     IN   VARCHAR2,
      pv_fldkey      IN   VARCHAR2
   )
      RETURN ddmastcheck_arrtype;




   TYPE semastcheck_rectype IS RECORD (
      actype          semast.actype%TYPE,
      acctno          semast.acctno%TYPE,
      codeid          semast.codeid%TYPE,
      afacctno        semast.afacctno%TYPE,
      opndate         semast.opndate%TYPE,
      clsdate         semast.clsdate%TYPE,
      lastdate        semast.lastdate%TYPE,
      status          semast.status%TYPE,
      pstatus         semast.pstatus%TYPE,
      irtied          semast.irtied%TYPE,
      ircd            semast.ircd%TYPE,
      costprice       semast.costprice%TYPE,
      trade           semast.trade%TYPE,
      mortage         semast.mortage%TYPE,
      dfmortage       semast.mortage%TYPE,
      margin          semast.margin%TYPE,
      netting         semast.netting%TYPE,
      standing        semast.standing%TYPE,
      withdraw        semast.withdraw%TYPE,
      deposit         semast.deposit%TYPE,
      loan            semast.loan%TYPE,
      blocked         semast.blocked%TYPE,
      receiving       semast.receiving%TYPE,
      transfer        semast.transfer%TYPE,
      prevqtty        semast.prevqtty%TYPE,
      dcrqtty         semast.dcrqtty%TYPE,
      dcramt          semast.dcramt%TYPE,
      depofeeacr      semast.depofeeacr%TYPE,
      repo            semast.repo%TYPE,
      pending         semast.pending%TYPE,
      tbaldepo        semast.tbaldepo%TYPE,
      custid          semast.custid%TYPE,
      costdt          semast.costdt%TYPE,
      secured         semast.secured%TYPE,
      iccfcd          semast.iccfcd%TYPE,
      iccftied        semast.iccftied%TYPE,
      tbaldt          semast.tbaldt%TYPE,
      senddeposit     semast.senddeposit%TYPE,
      sendpending     semast.sendpending%TYPE,
      ddroutqtty      semast.ddroutqtty%TYPE,
      ddroutamt       semast.ddroutamt%TYPE,
      dtoclose        semast.dtoclose%TYPE,
      sdtoclose       semast.sdtoclose%TYPE,
      qtty_transfer   semast.qtty_transfer%TYPE,
      trading         semast.trade%TYPE,
      EMKQTTY         semast.EMKQTTY%TYPE,
      BLOCKWITHDRAW         semast.BLOCKWITHDRAW%TYPE,
      BLOCKDTOCLOSE         semast.BLOCKDTOCLOSE%TYPE

   );

   TYPE semastcheck_arrtype IS TABLE OF semastcheck_rectype
      INDEX BY PLS_INTEGER;

   TYPE afmastcheck_rectype IS RECORD (
      actype            afmast.actype%TYPE,
      custid            afmast.custid%TYPE,
      acctno            afmast.acctno%TYPE,
      aftype            afmast.aftype%TYPE,
      tradefloor        cfmast.tradefloor%TYPE,
      tradetelephone    cfmast.tradetelephone%TYPE,
      tradeonline       cfmast.tradeonline%TYPE,
      pin               cfmast.pin%TYPE,
      bankacctno        afmast.bankacctno%TYPE,
      bankname          afmast.bankname%TYPE,
      swiftcode         afmast.swiftcode%TYPE,
      email             cfmast.email%TYPE,
      address           cfmast.address%TYPE,
      fax               cfmast.fax%TYPE,
      lastdate          afmast.lastdate%TYPE,
      status            afmast.status%TYPE,
      pstatus           afmast.pstatus%TYPE,
      advanceline       afmast.advanceline%TYPE,
      bratio            afmast.bratio%TYPE,
      termofuse         afmast.termofuse%TYPE,
      description       afmast.description%TYPE,
      isotc             afmast.isotc%TYPE,
      consultant        cfmast.consultant%TYPE,
      pisotc            afmast.pisotc%TYPE,
      opndate           afmast.opndate%TYPE,
      corebank          afmast.corebank%TYPE,
      via               afmast.via%type,
      mrirate           afmast.mrirate%TYPE,
      mrmrate           afmast.mrmrate%TYPE,
      mrlrate           afmast.mrlrate%TYPE,
      mrcrlimit         afmast.mrcrlimit%TYPE,
      mrcrlimitmax      afmast.mrcrlimitmax%TYPE,
      groupleader       afmast.groupleader%TYPE,
      t0amt             afmast.t0amt%TYPE,
      CUSTODIANTYP      char(1),
      CUSTTYPE          char(1),
      idexpdays         NUMBER(20),
      WARNINGTERMOFUSE  number(20)
   );

   TYPE afmastcheck_arrtype IS TABLE OF afmastcheck_rectype
      INDEX BY PLS_INTEGER;

   TYPE sewithdrawcheck_rectype IS RECORD (
      avlsewithdraw   NUMBER (20, 4)
   );

   TYPE sewithdrawcheck_arrtype IS TABLE OF sewithdrawcheck_rectype
      INDEX BY PLS_INTEGER;


   FUNCTION fn_sewithdrawcheck (
      pv_condvalue   IN   VARCHAR2,
      pv_tblname     IN   VARCHAR2,
      pv_fldkey      IN   VARCHAR2
   )RETURN sewithdrawcheck_arrtype;

    --TungNT added
   TYPE crbtrflogcheck_rectype IS RECORD (
        AUTOID crbtrflog.AUTOID%TYPE,
        VERSION crbtrflog.VERSION%TYPE,
        VERSIONLOCAL crbtrflog.VERSIONLOCAL%TYPE,
        TXDATE crbtrflog.TXDATE%TYPE,
        CREATETST crbtrflog.CREATETST%TYPE,
        SENDTST crbtrflog.SENDTST%TYPE,
        REFBANK crbtrflog.REFBANK%TYPE,
        TRFCODE crbtrflog.TRFCODE%TYPE,
        STATUS crbtrflog.STATUS%TYPE,
        PSTATUS crbtrflog.PSTATUS%TYPE,
        ERRCODE crbtrflog.ERRCODE%TYPE,
        FEEDBACK crbtrflog.FEEDBACK%TYPE,
        ERRSTS crbtrflog.ERRSTS%TYPE,
        REFVERSION crbtrflog.REFVERSION%TYPE,
        NOTES crbtrflog.NOTES%TYPE,
        TLID crbtrflog.TLID%TYPE,
        OFFID crbtrflog.OFFID%TYPE
   );

   TYPE crbtrflogcheck_arrtype IS TABLE OF crbtrflogcheck_rectype
      INDEX BY PLS_INTEGER;


TYPE crbdefbankcheck_rectype IS RECORD (
        AUTOID crbdefbank.AUTOID%TYPE,
        BANKCODE crbdefbank.BANKCODE%TYPE,
        ROOTCODE crbdefbank.ROOTCODE%TYPE,
        BANKNAME crbdefbank.BANKNAME%TYPE,
        USERIDKEY crbdefbank.USERIDKEY%TYPE,
        ACCESSKEY crbdefbank.ACCESSKEY%TYPE,
        PRIVATEKEY crbdefbank.PRIVATEKEY%TYPE,
        STATUS crbdefbank.STATUS%TYPE,
        PASSWORD crbdefbank.PASSWORD%TYPE,
        PFXKEYNAME crbdefbank.PFXKEYNAME%TYPE,
        PFXKEYPASS crbdefbank.PFXKEYPASS%TYPE,
        MINAMOUNTI crbdefbank.MINAMOUNTI%TYPE,
        MINAMOUNTG crbdefbank.MINAMOUNTG%TYPE,
        SIGNER crbdefbank.SIGNER%TYPE,
        SIGNERPASS crbdefbank.SIGNERPASS%TYPE,
        RECEIVER crbdefbank.RECEIVER%TYPE
   );

   TYPE crbdefbankcheck_arrtype IS TABLE OF crbdefbankcheck_rectype
      INDEX BY PLS_INTEGER;
   --End

  FUNCTION fn_afmastcheck (
      pv_condvalue   IN   VARCHAR2,
      pv_tblname     IN   VARCHAR2,
      pv_fldkey      IN   VARCHAR2
   )
      RETURN afmastcheck_arrtype;

  FUNCTION fn_semastcheck (
      pv_condvalue   IN   VARCHAR2,
      pv_tblname     IN   VARCHAR2,
      pv_fldkey      IN   VARCHAR2
   )
      RETURN semastcheck_arrtype;


FUNCTION fn_aftxmapcheck (
      pv_acctno   IN   VARCHAR2,
      pv_tblname     IN   VARCHAR2,
      pv_acfld       IN varchar2,
      pv_tltxcd in varchar2
   )
      RETURN VARCHAR2;
     PROCEDURE pr_txcorecheck (
        pv_refcursor   IN OUT   pkg_report.ref_cursor,
        pv_condvalue   IN       VARCHAR2,
        pv_tblname     IN       VARCHAR2,
        pv_fldkey      IN       VARCHAR2,
        pv_busdate      IN       VARCHAR2
     );

END;
/


CREATE OR REPLACE PACKAGE BODY txpks_check
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   PROCEDURE pr_txcorecheck (
      pv_refcursor   IN OUT   pkg_report.ref_cursor,
      pv_condvalue   IN       VARCHAR2,
      pv_tblname     IN       VARCHAR2,
      pv_fldkey      IN       VARCHAR2,
      pv_busdate      IN       VARCHAR2
   )
   IS
      v_fldkey                VARCHAR2 (50);
      v_tblname               VARCHAR2 (50);
      v_txdate                DATE;
      v_cmdsql                VARCHAR2 (2000);
      v_margintype            CHAR (1);
      v_actype                VARCHAR2 (4);
      v_groupleader           VARCHAR2 (10);
      v_baldefovd             NUMBER (20, 0);
      v_pp                    NUMBER (20, 0);
      v_avllimit              NUMBER (20, 0);
      v_navaccount            NUMBER (20, 0);
      v_outstanding           NUMBER (20, 0);
      v_mrirate               NUMBER (20, 4);
      v_deallimit             number(20,4);

      l_ismarginallow varchar2(1);
      l_count number;
      l_isMarginAcc varchar2(2);

      l_ddmastcheck_rectype   txpks_check.ddmastcheck_rectype;
      l_ddmastcheck_arrtype   txpks_check.ddmastcheck_arrtype;
   BEGIN                                                               -- Proc
      v_tblname := UPPER (pv_tblname);
      v_fldkey := pv_fldkey;

      SELECT TO_DATE (varvalue, 'dd/MM/yyyy')
        INTO v_txdate
        FROM sysvar
       WHERE UPPER (varname) = 'CURRDATE';

    plog.setbeginsection(pkgctx, 'pr_txcorecheck');
    plog.debug(pkgctx, 'pv_condvalue=' || pv_condvalue || '::pv_tblname=' || pv_tblname || '::pv_fldkey=' || pv_fldkey);

    if v_tblName = 'ODMAST' then
        OPEN PV_REFCURSOR FOR
        SELECT * FROM ODMAST WHERE ORDERID = pv_CONDVALUE;
    elsif v_tblName = 'OOD' then
        OPEN PV_REFCURSOR FOR
        SELECT * FROM OOD WHERE ORGORDERID = pv_CONDVALUE;

 elsif v_tblName = 'DDMAST' then
         l_ddmastcheck_arrtype := txpks_check.fn_ddmastcheck(PV_CONDVALUE, 'DDMAST', '');
        OPEN PV_REFCURSOR FOR
            Select l_ddmastcheck_arrtype(0).acctno acctno,
                      l_ddmastcheck_arrtype(0).ccycd ccycd,
                      l_ddmastcheck_arrtype(0).afacctno afacctno,
                      l_ddmastcheck_arrtype(0).custid custid,
                      l_ddmastcheck_arrtype(0).opndate opndate,
                      l_ddmastcheck_arrtype(0).clsdate clsdate,
                      l_ddmastcheck_arrtype(0).lastchange lastchange,
                      l_ddmastcheck_arrtype(0).status status,
                      l_ddmastcheck_arrtype(0).pstatus pstatus,
                      l_ddmastcheck_arrtype(0).balance balance,
                      l_ddmastcheck_arrtype(0).holdbalance holdbalance,
                      l_ddmastcheck_arrtype(0).bankbalance bankbalance,
                      l_ddmastcheck_arrtype(0).bankholdbalance bankholdbalance,
                      l_ddmastcheck_arrtype(0).pendinghold pendinghold,
                      l_ddmastcheck_arrtype(0).pendingunhold pendingunhold,
                      l_ddmastcheck_arrtype(0).refcasaacct refcasaacct,
                      l_ddmastcheck_arrtype(0).receiving receiving,
                      l_ddmastcheck_arrtype(0).netting netting
            From dual;



    elsif v_tblName = 'CAMAST' then
        OPEN PV_REFCURSOR FOR
        SELECT * FROM CAMAST WHERE CAMASTID = pv_CONDVALUE;

    elsif v_tblName = 'CASCHD' then
        OPEN PV_REFCURSOR FOR
        SELECT * FROM CASCHD WHERE TRIM(AUTOID) = pv_CONDVALUE;

    elsif v_tblName = 'CFMAST' then
        OPEN PV_REFCURSOR FOR
        SELECT * FROM CFMAST WHERE CUSTID = pv_CONDVALUE;

    elsif v_tblName = 'AFMAST' then
        OPEN PV_REFCURSOR FOR
        SELECT AF.*,
        (CASE WHEN CF.CUSTATCOM='Y' THEN 'C' ELSE 'T' END) CUSTODIANTYP,
        substr(cf.custodycd,4,1) CUSTTYPE,
        (cf.idexpired - v_txdate) idexpdays,
        decode(af.TERMOFUSE,'003',0,1) WARNINGTERMOFUSE
        FROM CFMAST CF, AFMAST AF,AFTYPE AFT,sysvar sys
        WHERE AF.actype =AFT.actype --AND AF.aftype =AFT.aftype
        AND AF.CUSTID=CF.CUSTID
        AND sys.grname ='SYSTEM' and sys.varname ='COMPANYCD'
        AND AF.ACCTNO =pv_CONDVALUE;
    elsif v_tblName = 'SEMAST' then
       OPEN PV_REFCURSOR FOR
        select semast.actype, semast.acctno, semast.codeid, semast.afacctno, semast.opndate, semast.clsdate,
                    semast.lastdate, semast.status, semast.pstatus, semast.irtied, semast.ircd, semast.costprice,
                    semast.trade  trade,  semast.margin, semast.netting, abs(semast.standing) standing, semast.withdraw,
                   semast.deposit, semast.loan, semast.blocked, semast.receiving, semast.transfer,
                   semast.prevqtty, semast.dcrqtty, semast.dcramt, semast.depofeeacr, semast.repo, semast.pending,
                   semast.tbaldepo, semast.custid, semast.costdt, semast.iccfcd, semast.iccftied,
                   semast.tbaldt, semast.senddeposit, semast.sendpending, semast.ddroutqtty,
                   semast.ddroutamt, semast.dtoclose, semast.sdtoclose, semast.qtty_transfer
            from SEMAST
            WHERE acctno = pv_CONDVALUE  ;
    elsif v_tblName = 'SEREVERT' then
                OPEN PV_REFCURSOR FOR
                        select SUM(serevert) SESTATUS
                      from ((SELECT count(*) serevert FROM SEMAST
                            WHERE afacctno = pv_CONDVALUE and status = 'N')
                            UNION ALL (SELECT count(*) serevert FROM caschd
                            WHERE afacctno = pv_CONDVALUE and status = 'O' AND deltd='N'));

    elsif v_tblName = 'CFBANK' then
          if length(trim(pv_CONDVALUE)) > 0 then
             OPEN PV_REFCURSOR FOR
                        select count(1) ISBANKSTATUS
                      from CFMAST
                            WHERE custid = pv_CONDVALUE and isbanking = 'Y' and status = 'A';
          else
             OPEN PV_REFCURSOR FOR
                        select 1 ISBANKSTATUS
                      from dual;
          end if;
    end if;

        plog.setendsection(pkgctx, 'pr_txcorecheck');

   EXCEPTION
      WHEN OTHERS
      THEN
          plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
        plog.setendsection(pkgctx, 'pr_txcorecheck');
         RETURN;
   END pr_txcorecheck;



  FUNCTION fn_sewithdrawcheck (
      pv_condvalue   IN   VARCHAR2,
      pv_tblname     IN   VARCHAR2,
      pv_fldkey      IN   VARCHAR2
   )
      RETURN sewithdrawcheck_arrtype
   IS
      l_margintype                CHAR (1);
      l_actype                    VARCHAR2 (4);
      l_groupleader               VARCHAR2 (10);
      l_baldefovd                 NUMBER (20, 0);
      l_pp                        NUMBER (20, 0);
      l_avllimit                  NUMBER (20, 0);
      l_navaccount                NUMBER (20, 0);
      l_outstanding               NUMBER (20, 0);
      l_mrirate                   NUMBER (20, 4);
      l_sewithdrawcheck_rectype   sewithdrawcheck_rectype;
      l_sewithdrawcheck_arrtype   sewithdrawcheck_arrtype;
      l_i                         NUMBER (10);
      pv_refcursor                pkg_report.ref_cursor;
      l_count number;
   BEGIN                                                               -- Proc


         OPEN pv_refcursor FOR
            SELECT trade  avlsewithdraw
              FROM semast WHERE acctno = pv_condvalue ;


      l_i := 0;

      LOOP
         FETCH pv_refcursor
          INTO l_sewithdrawcheck_rectype;

         l_sewithdrawcheck_arrtype (l_i) := l_sewithdrawcheck_rectype;
         EXIT WHEN pv_refcursor%NOTFOUND;
         l_i := l_i + 1;
      END LOOP;


      RETURN l_sewithdrawcheck_arrtype;
   EXCEPTION
      WHEN OTHERS
      THEN
	  plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
         if pv_refcursor%ISOPEN THEN
            CLOSE pv_refcursor;
         END IF;
         RETURN l_sewithdrawcheck_arrtype;
   END fn_sewithdrawcheck;


   FUNCTION fn_ddmastcheck (
      pv_condvalue   IN   VARCHAR2,
      pv_tblname     IN   VARCHAR2,
      pv_fldkey      IN   VARCHAR2
   )
      RETURN ddmastcheck_arrtype
   IS
      l_margintype            CHAR (1);
      l_actype                VARCHAR2 (4);
      l_groupleader           VARCHAR2 (10);
      l_baldefovd             NUMBER (20, 0);
      l_baldefovd_Released    NUMBER (20, 0);

      l_pp                    NUMBER (20, 0);
      l_avllimit              NUMBER (20, 0);
      l_deallimit             NUMBER (20, 0);
      l_navaccount            NUMBER (20, 0);
      l_outstanding           NUMBER (20, 0);
      l_mrirate               NUMBER (20, 4);

      l_baldefovd_Released_depofee    NUMBER (20, 0);

      l_ddmastcheck_rectype   ddmastcheck_rectype;
      l_ddmastcheck_arrtype   ddmastcheck_arrtype;
      l_i                     NUMBER (10);
      pv_refcursor            pkg_report.ref_cursor;
      l_count number;
      l_isMarginAcc varchar2(1);

      l_avladvance  NUMBER; -- TheNN added
      l_advanceamount NUMBER; -- TheNN added
      l_paidamt       NUMBER; -- TheNN added
      l_execbuyamt      number;
   BEGIN




         --Tai khoan binh thuong khong Margin
         OPEN pv_refcursor FOR
          select acctno , ccycd ,afacctno, custid, opndate,clsdate,lastchange,status , pstatus ,balance , holdbalance ,bankbalance,
                bankholdbalance , pendinghold , pendingunhold , refcasaacct , receiving , netting, 0 pp
          from ddmast where acctno = pv_condvalue;


      l_i := 0;
      LOOP
         FETCH pv_refcursor
          INTO l_ddmastcheck_rectype;

         l_ddmastcheck_arrtype (l_i) := l_ddmastcheck_rectype;

         EXIT WHEN pv_refcursor%NOTFOUND;
         l_i := l_i + 1;
      END LOOP;
      --close pv_refcursor;
      /*FETCH pv_refcursor
          bulk collect INTO l_cimastcheck_arrtype;
      close pv_refcursor;*/
      RETURN l_ddmastcheck_arrtype;
   EXCEPTION
      WHEN OTHERS
      THEN
         plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
         if pv_refcursor%ISOPEN THEN
            CLOSE pv_refcursor;
         END IF;
         RETURN l_ddmastcheck_arrtype;
   END fn_ddmastcheck;




   FUNCTION fn_semastcheck (
      pv_condvalue   IN   VARCHAR2,
      pv_tblname     IN   VARCHAR2,
      pv_fldkey      IN   VARCHAR2
   )
      RETURN semastcheck_arrtype
   IS
      l_semastcheck_rectype   semastcheck_rectype;
      l_semastcheck_arrtype   semastcheck_arrtype;
      l_i                     NUMBER (10);
      pv_refcursor            pkg_report.ref_cursor;
      l_txdate                DATE;
      l_setype                setype.actype%TYPE;
      l_custid                semast.custid%TYPE;
       L_COUNT                NUMBER(5);
   BEGIN                                                               -- Proc
      SELECT TO_DATE (varvalue, 'DD/MM/YYYY')
        INTO l_txdate
        FROM sysvar
       WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

       SELECT COUNT(*) INTO L_COUNT FROM SEMAST WHERE ACCTNO = pv_condvalue; -- and status ='A';
       L_COUNT := NVL(L_COUNT,0);
    IF L_COUNT > 0 THEN
     OPEN pv_refcursor FOR
         SELECT semast.actype, semast.acctno, semast.codeid, semast.afacctno,
                semast.opndate, semast.clsdate, semast.lastdate,
                semast.status, semast.pstatus, semast.irtied, semast.ircd,
                semast.costprice, greatest(semast.trade,0) trade,
                semast.mortage mortage,0 dfmortage, semast.margin,
                semast.netting, abs(semast.standing)standing, semast.withdraw,
                semast.deposit, semast.loan, semast.blocked, semast.receiving,
                semast.transfer, semast.prevqtty, semast.dcrqtty,
                semast.dcramt, semast.depofeeacr, semast.repo, semast.pending,
                semast.tbaldepo, semast.custid, semast.costdt,
                0 secured,
                semast.iccfcd, semast.iccftied, semast.tbaldt,
                semast.senddeposit, semast.sendpending, semast.ddroutqtty,
                semast.ddroutamt, semast.dtoclose, semast.sdtoclose,
                semast.qtty_transfer,
                greatest(semast.trade ,0) trading,
                 semast.emkqtty,semast.blockwithdraw,semast.blockdtoclose

          FROM semast

          WHERE acctno = pv_condvalue ;


      l_i := 0;

      LOOP
         FETCH pv_refcursor
          INTO l_semastcheck_rectype;
         EXIT WHEN pv_refcursor%NOTFOUND;
         l_semastcheck_arrtype (l_i) := l_semastcheck_rectype;
         l_i := l_i + 1;
      END LOOP;
      --close pv_refcursor;
      /*FETCH pv_refcursor
          bulk collect INTO l_semastcheck_arrtype;
      close pv_refcursor;*/

      --- IF (l_semastcheck_arrtype.count) <= 0   THEN
      else
         --Securities account does not exits
         --Automatic open sub securities account
         SELECT '0000', af.custid
           INTO l_setype, l_custid
           FROM afmast af
          WHERE af.acctno = SUBSTR(pv_condvalue,1,10);

         INSERT INTO semast
                     (actype, custid, acctno,
                      codeid,
                      afacctno, opndate, lastdate,
                      costdt, tbaldt, status, irtied, ircd, costprice, trade,
                      mortage, margin, netting, standing, withdraw, deposit,
                      loan
                     )
              VALUES (l_setype, l_custid, pv_condvalue,
                      SUBSTR (pv_condvalue, 11, 6),
                      SUBSTR (pv_condvalue, 1, 10), l_txdate, l_txdate,
                      l_txdate, l_txdate, 'A', 'Y', '000', 0, 0,
                      0, 0, 0, 0, 0, 0,
                      0
                     )
           RETURNING actype,
                     custid,
                     acctno,
                     codeid,
                     afacctno,
                     opndate,
                     lastdate,
                     costdt,
                     tbaldt,
                     status,
                     irtied,
                     ircd,
                     costprice,
                     trade,
                     mortage,
                     margin,
                     netting,
                     standing,
                     withdraw,
                     deposit,
                     loan,
                     l_txdate,    --      clsdate         semast.clsdate%TYPE,
                     '',          --      pstatus         semast.pstatus%TYPE,
                     0,           --      blocked         semast.blocked%TYPE,
                     0,         --      receiving       semast.receiving%TYPE,
                     0,          --      transfer        semast.transfer%TYPE,
                     0,          --      prevqtty        semast.prevqtty%TYPE,
                     0,           --      dcrqtty         semast.dcrqtty%TYPE,
                     0,            --      dcramt          semast.dcramt%TYPE,
                     0,        --      depofeeacr      semast.depofeeacr%TYPE,
                     0,              --      repo            semast.repo%TYPE,
                     0,           --      pending         semast.pending%TYPE,
                     0,          --      tbaldepo        semast.tbaldepo%TYPE,
                     0,           --      secured         semast.secured%TYPE,
                     '',           --      iccfcd          semast.iccfcd%TYPE,
                     '',         --      iccftied        semast.iccftied%TYPE,
                     0,       --      senddeposit     semast.senddeposit%TYPE,
                     0,       --      sendpending     semast.sendpending%TYPE,
                     0,        --      ddroutqtty      semast.ddroutqtty%TYPE,
                     0,         --      ddroutamt       semast.ddroutamt%TYPE,
                     0,          --      dtoclose        semast.dtoclose%TYPE,
                     0,         --      sdtoclose       semast.sdtoclose%TYPE,
                     0,       --      qtty_transfer   semast.qtty_transfer%TYPE
                     0,
                    emkqtty,       --      emkqtty   semast.emkqtty%TYPE
                     blockwithdraw,       --      blockwithdraw   semast.blockwithdraw%TYPE
                    blockdtoclose       --      blockdtoclose   semast.blockdtoclose%TYPE
                INTO l_semastcheck_arrtype (0).actype,
                     l_semastcheck_arrtype (0).custid,
                     l_semastcheck_arrtype (0).acctno,
                     l_semastcheck_arrtype (0).codeid,
                     l_semastcheck_arrtype (0).afacctno,
                     l_semastcheck_arrtype (0).opndate,
                     l_semastcheck_arrtype (0).lastdate,
                     l_semastcheck_arrtype (0).costdt,
                     l_semastcheck_arrtype (0).tbaldt,
                     l_semastcheck_arrtype (0).status,
                     l_semastcheck_arrtype (0).irtied,
                     l_semastcheck_arrtype (0).ircd,
                     l_semastcheck_arrtype (0).costprice,
                     l_semastcheck_arrtype (0).trade,
                     l_semastcheck_arrtype (0).mortage,
                     l_semastcheck_arrtype (0).margin,
                     l_semastcheck_arrtype (0).netting,
                     l_semastcheck_arrtype (0).standing,
                     l_semastcheck_arrtype (0).withdraw,
                     l_semastcheck_arrtype (0).deposit,
                     l_semastcheck_arrtype (0).loan,
                     l_semastcheck_arrtype (0).clsdate,
                     l_semastcheck_arrtype (0).pstatus,
                     l_semastcheck_arrtype (0).blocked,
                     l_semastcheck_arrtype (0).receiving,
                     l_semastcheck_arrtype (0).transfer,
                     l_semastcheck_arrtype (0).prevqtty,
                     l_semastcheck_arrtype (0).dcrqtty,
                     l_semastcheck_arrtype (0).dcramt,
                     l_semastcheck_arrtype (0).depofeeacr,
                     l_semastcheck_arrtype (0).repo,
                     l_semastcheck_arrtype (0).pending,
                     l_semastcheck_arrtype (0).tbaldepo,
                     l_semastcheck_arrtype (0).secured,
                     l_semastcheck_arrtype (0).iccfcd,
                     l_semastcheck_arrtype (0).iccftied,
                     l_semastcheck_arrtype (0).senddeposit,
                     l_semastcheck_arrtype (0).sendpending,
                     l_semastcheck_arrtype (0).ddroutqtty,
                     l_semastcheck_arrtype (0).ddroutamt,
                     l_semastcheck_arrtype (0).dtoclose,
                     l_semastcheck_arrtype (0).sdtoclose,
                     l_semastcheck_arrtype (0).qtty_transfer,
                     l_semastcheck_arrtype (0).trading,
                     l_semastcheck_arrtype (0).emkqtty,
                     l_semastcheck_arrtype (0).blockwithdraw,
                     l_semastcheck_arrtype (0).dtoclose

                     ;
      END IF;

      RETURN l_semastcheck_arrtype;
   EXCEPTION
      WHEN OTHERS
      THEN
		plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
        if pv_refcursor%ISOPEN THEN
            CLOSE pv_refcursor;
         END IF;
         RETURN l_semastcheck_arrtype;
   END fn_semastcheck;

   FUNCTION fn_afmastcheck (
      pv_condvalue   IN   VARCHAR2,
      pv_tblname     IN   VARCHAR2,
      pv_fldkey      IN   VARCHAR2
   )
      RETURN afmastcheck_arrtype
   IS
      l_afmastcheck_rectype   afmastcheck_rectype;
      l_afmastcheck_arrtype   afmastcheck_arrtype;
      l_i                     NUMBER (10);
      pv_refcursor            pkg_report.ref_cursor;
      l_currdate              DATE;
   BEGIN                                                               -- Proc

      l_currdate:= to_date(cspks_system.fn_get_sysvar('SYSTEM', 'CURRDATE'),SYSTEMNUMS.c_date_format);
      OPEN pv_refcursor FOR
         SELECT af.actype, af.custid, af.acctno, af.aftype, cf.tradefloor,
                cf.tradetelephone, cf.tradeonline, cf.pin, af.bankacctno, af.bankname,
                af.swiftcode, cf.email, cf.address, cf.fax,
                af.lastdate, af.status, af.pstatus,
                af.advanceline, af.bratio, af.termofuse, af.description, af.isotc,
                cf.consultant, af.pisotc, af.opndate, af.corebank, af.via,
                af.mrirate, af.mrmrate, af.mrlrate, af.mrcrlimit, af.mrcrlimitmax, af.groupleader,
                af.t0amt,
                (case when cf.custatcom= 'Y' then 'C' else 'T' end) CUSTODIANTYP,
                substr(cf.custodycd,4,1) CUSTTYPE,
                (cf.idexpired - l_currdate) idexpdays,
                decode(af.TERMOFUSE,'003',0,1) WARNINGTERMOFUSE
           FROM afmast af, aftype aft, cfmast cf
          WHERE af.custid = cf.custid
            and af.actype = aft.actype
            --AND af.aftype = aft.aftype
            AND af.acctno = pv_condvalue;

         l_i := 0;
         LOOP
             FETCH pv_refcursor
              INTO l_afmastcheck_rectype;

             l_afmastcheck_arrtype (l_i) := l_afmastcheck_rectype;
             EXIT WHEN pv_refcursor%NOTFOUND;
             l_i := l_i + 1;
         END LOOP;
         --close pv_refcursor;
         /*FETCH pv_refcursor
          bulk collect INTO l_afmastcheck_arrtype;
         close pv_refcursor;*/


      RETURN l_afmastcheck_arrtype;
   EXCEPTION
      WHEN OTHERS
      THEN
		plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
         if pv_refcursor%ISOPEN THEN
            CLOSE pv_refcursor;
         END IF;
         RETURN l_afmastcheck_arrtype;
   END fn_afmastcheck;




FUNCTION fn_aftxmapcheck (
      pv_acctno   IN   VARCHAR2,
      pv_tblname     IN   VARCHAR2,
      pv_acfld       IN varchar2,
      pv_tltxcd in varchar2
   )
      RETURN VARCHAR2
   IS
     l_result boolean;
     l_afacctno varchar2(10);
     l_currdate date;
     l_count number(5);
     l_actype VARCHAR2(4);
     l_ChgTypeAllow VARCHAR2(1);
   BEGIN
      /*if pv_tblname= 'DDMAST' then
         --Khong check voi ddmastt
         return 'TRUE';
      end if;*/

      --31/05/2017, neu GD xu ly batch cuoi ngay --> khong chan
      If CSPKS_SYSTEM.fn_get_sysvar('SYSTEM', 'HOSTATUS') =systemnums.C_OPERATION_INACTIVE Then
        RETURN 'TRUE';
      End If;
      --End

      l_result:=true;
      l_afacctno:='';
      select to_date(varvalue,systemnums.c_date_format) into l_currdate from sysvar where varname ='CURRDATE' and grname ='SYSTEM';
      if pv_tblname='AFMAST' then
          l_afacctno:=   pv_acctno;
      elsif pv_tblname='DDMAST' then
          l_afacctno:=   pv_acctno;
      elsif pv_tblname='SEMAST' then
          l_afacctno:=   substr(pv_acctno,1,10);
      elsif pv_tblname='ODMAST' then
          select afacctno into l_afacctno from odmast where orderid =   pv_acctno;
      end if;

      -- TruongLD Add
      -- Lay loai hinh cua tieu khoan
      if l_afacctno is not null THEN
         SELECT actype INTO l_actype FROM afmast WHERE acctno = l_afacctno;
      END IF;

      l_count := 0;
      if l_actype is not null THEN
         BEGIN
           SELECT COUNT(1) INTO l_count FROM aftxmap WHERE actype = l_actype AND upper(afacctno) = 'ALL';
           EXCEPTION
                  WHEN OTHERS THEN
                       l_count := 0;
         END;
      END IF;
      -- End TruongLD

      IF l_count <> 0 THEN
         -- Chan theo loai hinh.
         l_count := 0;
         select count(1) into l_count from aftxmap where actype = l_actype and tltxcd = pv_tltxcd
            and effdate<=l_currdate and expdate>l_currdate;
            l_result:= case when l_count>0 then false else true end;
      end if;
      if l_result then
          IF l_afacctno is not null THEN
                -- Chan theo tieu khoan.
                l_count := 0;
                select count(1) into l_count from aftxmap where afacctno = l_afacctno and tltxcd = pv_tltxcd
                and effdate<=l_currdate and expdate>l_currdate;
                l_result:= case when l_count>0 then false else true end;
          END IF;
      end if;

       -- HaiLT them
      select ChgTypeAllow into l_ChgTypeAllow from tltx where tltxcd = pv_tltxcd;
      --Neu check duyet thay doi loai hinh
      if l_ChgTypeAllow = 'N' then
        select COUNT(1) INTO l_count FROM afmast WHERE acctno = l_afacctno and CHGACTYPE = 'Y' and status = 'P';
        l_result:= case when l_count>0 then false else true end;
      end if;
      -- End of HaiLT them



      RETURN case when l_result then 'TRUE' else 'FALSE' end;
   exception when others then
        return 'TRUE';
   END fn_aftxmapcheck;

BEGIN
   FOR i IN (SELECT *
               FROM tlogdebug)
   LOOP
      logrow.loglevel := i.loglevel;
      logrow.log4table := i.log4table;
      logrow.log4alert := i.log4alert;
      logrow.log4trace := i.log4trace;
   END LOOP;

   pkgctx :=
      plog.init ('TXPKS_CHECK',
                 plevel         => NVL (logrow.loglevel, 30),
                 plogtable      => (NVL (logrow.log4table, 'N') = 'Y'),
                 palert         => (NVL (logrow.log4alert, 'N') = 'Y'),
                 ptrace         => (NVL (logrow.log4trace, 'N') = 'Y')
                );
END txpks_check;
/
