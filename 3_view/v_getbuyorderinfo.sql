SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW V_GETBUYORDERINFO
(AFACCTNO, OVERAMT, ADVAMT, SECUREAMT, EXECBUYAMT)
AS 
Select afacctno afacctno,
       -- TruongLD Add PHS bo ko dung 2 dai luong nay nua --> De mac dinh = 0
       -- nvl(a.overamt,0) + nvl(aboveramt,0) overamt,
       -- case when hosts=0 then 0 else greatest(nvl(a.overamt,0) + nvl(aboveramt,0) - greatest(af.mrcrlimitmax-ci.dfodamt,0),0) end advamt,
       0 overamt,
       0 advamt,
        execamt + feeacr secureamt,
        feeacr execbuyamt
       FROM odmast od
/
