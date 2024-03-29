SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW V_APPCHK_BY_TLTXCD
(TLTXCD, APPTYPE, ACFLD, RULECD, AMTEXP, 
 FIELD, OPERAND, ERRNUM, ERRMSG, TBLNAME, 
 FLDKEY, REFID, ISRUN, FLDRND, CHKLEV)
AS 
SELECT C.TLTXCD TLTXCD, C.APPTYPE APPTYPE, C.ACFLD ACFLD, C.RULECD RULECD, C.AMTEXP AMTEXP,
    R.FIELD FIELD, R.OPERAND OPERAND, R.ERRNUM ERRNUM, R.ERRMSG ERRMSG, R.TBLNAME TBLNAME, C.FLDKEY FLDKEY, NVL(R.REFID,TBLNAME) REFID, C.ISRUN, R.FLDRND, C.CHKLEV
FROM APPCHK C, APPRULES R
WHERE C.APPTYPE = R.APPTYPE AND C.RULECD = R.RULECD
/
