SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_cigetdepofeeacr(strACCTNO IN varchar2, strCODEID IN varchar2, strBUSDATE IN varchar2, strTXDATE IN varchar2, dblQTTY IN NUMBER)
  RETURN  number
  IS
  v_strTRADEPLACE  varchar2(10);
  v_strSECTYPEEXT  varchar2(10);
  v_strSECTYPE    varchar2(10);
  v_strFORP      varchar2(10);
  v_strROUNDTYP    varchar2(10);
  v_dtmLASTACRDT  DATE;
  v_dblFEEAMT    number(20,4);
  v_dblLOTDAY    number(20,0);
  v_dblLOTVAL    number(20,0);
  v_dblFEERATIO    number(20,6);  --h? s? fee
  v_dblNUMOFDAYS  number(20,0);
  v_Result      number(20);
  l_issedepofee char(1);
  V_COUNT NUMBER(20,0);
  l_lastDepoFree date;
  l_isdepofree char(1);
  l_refcodeid varchar2(10);
BEGIN
  --sonlt neu la tu doanh thi ko tinh phi luu ky khi lam backdate
  select COUNT(1) INTO V_COUNT FROM vw_afmast_custodycd WHERE ACCTNO = strACCTNO AND SUBSTR(CUSTODYCD,4,1) = 'P';
  IF V_COUNT > 0 then
    RETURN 0;
  end IF;

  v_dblLOTDAY := 30;
  v_dblLOTVAL := 1;

  SELECT TRADEPLACE, SECTYPE,issedepofee, refcodeid INTO v_strTRADEPLACE, v_strSECTYPE, l_issedepofee, l_refcodeid
  FROM SBSECURITIES WHERE CODEID=strCODEID;

  IF v_strTRADEPLACE = '006' THEN --Trai phieu san WFT
    SELECT TRADEPLACE, SECTYPE,issedepofee INTO v_strTRADEPLACE, v_strSECTYPE, l_issedepofee
    FROM SBSECURITIES WHERE CODEID=l_refcodeid;
  END IF;

  if(l_issedepofee='N') THEN
     RETURN 0;
  END IF;

  IF v_strSECTYPE='001' OR v_strSECTYPE='002' OR v_strSECTYPE='007' OR v_strSECTYPE='008' THEN--Co phieu va chung chi quy
      IF v_strTRADEPLACE = '005' THEN
        SELECT TO_NUMBER(VARVALUE) INTO v_dblFEEAMT
        FROM SYSVAR WHERE GRNAME = 'DEFINED' AND VARNAME = 'FEEVSDUC_CP';
      ELSIF v_strTRADEPLACE = '001' OR v_strTRADEPLACE = '002' THEN
        SELECT TO_NUMBER(VARVALUE) INTO v_dblFEEAMT
        FROM SYSVAR WHERE GRNAME = 'DEFINED' AND VARNAME = 'FEEVSD_CP';
      END IF;
  ELSIF v_strSECTYPE='003' OR v_strSECTYPE='006' THEN--Trai phieu
    SELECT TO_NUMBER(VARVALUE) INTO v_dblFEEAMT FROM SYSVAR WHERE GRNAME = 'DEFINED' AND VARNAME = 'FEEVSD_TP';

  ELSIF v_strSECTYPE='011' THEN--Chung quyen
    SELECT TO_NUMBER(VARVALUE) INTO v_dblFEEAMT FROM SYSVAR WHERE GRNAME = 'DEFINED' AND VARNAME = 'FEEVSD_CW';

  ELSIF v_strSECTYPE='012' THEN--Tin phieu
    SELECT TO_NUMBER(VARVALUE) INTO v_dblFEEAMT FROM SYSVAR WHERE GRNAME = 'DEFINED' AND VARNAME = 'FEEVSD_TNP';
  END IF;

  Begin
  SELECT (nvl (DEPOLASTDT,TO_DATE(strBUSDATE,'DD/MM/RRRR'))-1) into v_dtmLASTACRDT FROM DDMAST WHERE AFACCTNO=strACCTNO and isdefault ='Y';
  EXCEPTION
   WHEN OTHERS THEN
    v_dtmLASTACRDT := TO_DATE(strBUSDATE,'DD/MM/RRRR') -1;
  END;

  --pr_error('FN_CIGETDEPOFEEACR','v_dtmLASTACRDT: ' || v_dtmLASTACRDT);
  SELECT (TO_DATE(strBUSDATE,'DD/MM/RRRR')-v_dtmLASTACRDT)  INTO v_dblNUMOFDAYS FROM DUAL;
  IF v_dblNUMOFDAYS>0 THEN
    SELECT (TO_DATE(strTXDATE,'DD/MM/RRRR')-TO_DATE(strBUSDATE,'DD/MM/RRRR')) INTO v_dblNUMOFDAYS FROM DUAL;
  ELSE
    SELECT (TO_DATE(strTXDATE,'DD/MM/RRRR')-v_dtmLASTACRDT) -1 INTO v_dblNUMOFDAYS FROM DUAL;
  END IF;
  IF v_dblNUMOFDAYS<=0 THEN
    RETURN 0;
  END IF;

/*  IF v_strFORP='P' THEN
    v_dblFEEAMT := v_dblFEEAMT/100;
  END IF;*/
    v_Result := ROUND(v_dblFEEAMT*dblQTTY*v_dblNUMOFDAYS/(v_dblLOTDAY*v_dblLOTVAL),4);
    RETURN nvl(v_result,0);
EXCEPTION
   WHEN OTHERS THEN
    plog.error('FN_CIGETDEPOFEEAMT: ' || dbms_utility.format_error_backtrace);
    RETURN 0;
END;
/
