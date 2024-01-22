SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf0107 (
   PV_REFCURSOR     IN OUT   PKG_REPORT.REF_CURSOR,
   OPT              IN       VARCHAR2,
   BRID             IN       VARCHAR2,
   I_DATE           IN       VARCHAR2,
   PV_CUSTODYCD     IN       VARCHAR2

       )
IS

--
-- PURPOSE: BAO CAO IN HOP DONG MO TIEU KHOAN GIAO DICH KY QUY
-- MODIFICATION HISTORY
-- PERSON       DATE        COMMENTS

-- ---------    ------      -------------------------------------------

    V_STROPTION         VARCHAR2  (5);
    V_STRBRID           VARCHAR2(100);


BEGIN
    -- GET REPORT'S PARAMETERS
    V_STROPTION := OPT;

     OPEN PV_REFCURSOR FOR
        select  upper(cf.fullname)   name,
                cf.dateofbirth Birthday,
                al.cdcontent nationality,
                cf.sex,
                case when cf.country = '234' then cf.idcode else cf.tradingcode end idcode,
                cf.iddate,
                cf.idplace,
                cf.idexpired,
                cf.mobilesms,
                cf.address,
                cf.email,
                cf.custodycd, mtl.*, cf.custtype

        from    cfmast cf, allcode al,
        (select CUSTID,  CHANGEDATE,
            max(oldFULLNAME) oldFULLNAME, max(newFULLNAME) newFULLNAME,max(oldIDCODE) oldIDCODE,max(newIDCODE) newIDCODE,max(oldIDDATE) oldIDDATE,
            max(newIDDATE) newIDDATE,max(oldIDPLACE) oldIDPLACE,max(newIDPLACE) newIDPLACE,max(oldADDRESS) oldADDRESS,max(newADDRESS) newADDRESS,
            max(oldEMAIL) oldEMAIL,max(newEMAIL) newEMAIL,max(oldMOBILESMS) oldMOBILESMS,max(newMOBILESMS) newMOBILESMS,max(oldTRADINGCODE) oldTRADINGCODE,
            max(newTRADINGCODE) newTRADINGCODE,max(oldTRADINGCODEDT) oldTRADINGCODEDT,max(oldKFULLNAME) oldKFULLNAME,max(newKFULLNAME) newKFULLNAME,max(oldKLICENSENO) oldKLICENSENO,
            max(newKLICENSENO) newKLICENSENO,max(oldKLNIDDATE) oldKLNIDDATE,max(newKLNIDDATE) newKLNIDDATE,max(oldKADDRESS) oldKADDRESS,max(newKADDRESS) newKADDRESS,
            max(oldKRETYPE) oldKRETYPE,max(newKRETYPE) newKRETYPE,max(oldKTELEPHONE) oldKTELEPHONE,max(newKTELEPHONE) newKTELEPHONE,max(KACTION) KACTION,max(oldDFULLNAME) oldDFULLNAME,
            max(newDFULLNAME) newDFULLNAME,max(oldDLICENSENO) oldDLICENSENO,max(newDLICENSENO) newDLICENSENO,max(oldDLNIDDATE) oldDLNIDDATE,max(newDLNIDDATE) newDLNIDDATE,max(oldDLNPLACE) oldDLNPLACE,
            max(newDLNPLACE) newDLNPLACE,max(oldDRETYPE) oldDRETYPE,max(newDRETYPE) newDRETYPE,max(oldDADDRESS) oldDADDRESS,max(newDADDRESS) newDADDRESS,max(oldDTELEPHONE) oldDTELEPHONE,
            max(newDTELEPHONE) newDTELEPHONE,max(DACTION) DACTION
        from
        ((
            select SUBSTR(MTL.RECORD_KEY,11,10) CUSTID,  MTL.MAKER_DT CHANGEDATE,
                max(case when MTL.COLUMN_NAME='FULLNAME' and nvl(child_table_name,'--')='--' then FROM_VALUE else '' end) oldFULLNAME,
                max(case when MTL.COLUMN_NAME='FULLNAME' and nvl(child_table_name,'--')='--' then TO_VALUE else '' end) newFULLNAME,
                max(case when MTL.COLUMN_NAME='IDCODE' and nvl(child_table_name,'--')='--' then FROM_VALUE else '' end) oldIDCODE,
                max(case when MTL.COLUMN_NAME='IDCODE' and nvl(child_table_name,'--')='--' then TO_VALUE else '' end) newIDCODE,
                max(case when MTL.COLUMN_NAME='IDDATE' and nvl(child_table_name,'--')='--' then FROM_VALUE else '' end) oldIDDATE,
                max(case when MTL.COLUMN_NAME='IDDATE' and nvl(child_table_name,'--')='--' then TO_VALUE else '' end) newIDDATE,
                max(case when MTL.COLUMN_NAME='IDPLACE' and nvl(child_table_name,'--')='--' then FROM_VALUE else '' end) oldIDPLACE,
                max(case when MTL.COLUMN_NAME='IDPLACE' and nvl(child_table_name,'--')='--' then TO_VALUE else '' end) newIDPLACE,
                max(case when MTL.COLUMN_NAME='ADDRESS' and nvl(child_table_name,'--')='--' then FROM_VALUE else '' end) oldADDRESS,
                max(case when MTL.COLUMN_NAME='ADDRESS' and nvl(child_table_name,'--')='--' then TO_VALUE else '' end) newADDRESS,
                max(case when MTL.COLUMN_NAME='EMAIL' and nvl(child_table_name,'--')='--' then FROM_VALUE else '' end) oldEMAIL,
                max(case when MTL.COLUMN_NAME='EMAIL' and nvl(child_table_name,'--')='--' then TO_VALUE else '' end) newEMAIL,
                max(case when MTL.COLUMN_NAME='MOBILESMS' and nvl(child_table_name,'--')='--' then FROM_VALUE else '' end) oldMOBILESMS,
                max(case when MTL.COLUMN_NAME='MOBILESMS' and nvl(child_table_name,'--')='--' then TO_VALUE else '' end) newMOBILESMS,
                max(case when MTL.COLUMN_NAME='TRADINGCODE' and nvl(child_table_name,'--')='--' then FROM_VALUE else '' end) oldTRADINGCODE,
                max(case when MTL.COLUMN_NAME='TRADINGCODE' and nvl(child_table_name,'--')='--' then TO_VALUE else '' end) newTRADINGCODE,
                max(case when MTL.COLUMN_NAME='TRADINGCODEDT' and nvl(child_table_name,'--')='--' then FROM_VALUE else '' end) oldTRADINGCODEDT,
                max(case when MTL.COLUMN_NAME='TRADINGCODEDT' and nvl(child_table_name,'--')='--' then TO_VALUE else '' end) newTRADINGCODEDT ,
                '' oldKFULLNAME, '' newKFULLNAME,'' oldKLICENSENO, '' newKLICENSENO,'' oldKLNIDDATE, '' newKLNIDDATE, '' oldKLNPLACE, '' newKLNPLACE,
                '' oldKRETYPE, '' newKRETYPE,'' oldKADDRESS, '' newKADDRESS, '' oldKTELEPHONE, '' newKTELEPHONE,'' KACTION,
                '' oldDFULLNAME, '' newDFULLNAME,'' oldDLICENSENO, '' newDLICENSENO,'' oldDLNIDDATE, '' newDLNIDDATE, '' oldDLNPLACE, '' newDLNPLACE,
                '' oldDRETYPE, '' newDRETYPE,'' oldDADDRESS, '' newDADDRESS, '' oldDTELEPHONE, '' newDTELEPHONE,'' DACTION
            FROM MAINTAIN_LOG MTL,(
                                    select SUBSTR(MTL.RECORD_KEY,11,10) CUSTID,  MTL.MAKER_DT CHANGEDATE,0 autoid, max(MTL.MOD_NUM) MOD_NUM
                                    FROM MAINTAIN_LOG MTL
                                    WHERE MTL.TABLE_NAME = 'CFMAST'
                                        AND (MTL.COLUMN_NAME IN ('FULLNAME', 'IDCODE', 'IDDATE', 'IDPLACE', 'ADDRESS', 'EMAIL', 'MOBILESMS', 'TRADINGCODE', 'TRADINGCODEDT') and nvl(child_table_name,'--')='--' AND MTL.ACTION_FLAG IN('EDIT'))
                                    group by SUBSTR(MTL.RECORD_KEY,11,10) ,  MTL.MAKER_DT ) mtl1
            WHERE MTL.TABLE_NAME = 'CFMAST'
            AND ((MTL.COLUMN_NAME IN ('FULLNAME', 'IDCODE', 'IDDATE', 'IDPLACE', 'ADDRESS', 'EMAIL', 'MOBILESMS', 'TRADINGCODE', 'TRADINGCODEDT') and nvl(child_table_name,'--')='--' AND MTL.ACTION_FLAG IN('EDIT'))
                )
            and SUBSTR(MTL.RECORD_KEY,11,10) = mtl1.CUSTID and MTL.MAKER_DT =mtl1.CHANGEDATE  and mtl.MOD_NUM=mtl1.MOD_NUM
            group by SUBSTR(MTL.RECORD_KEY,11,10) ,  MTL.MAKER_DT
        )
        union all
        (
            select SUBSTR(MTL.RECORD_KEY,11,10) CUSTID,  MTL.MAKER_DT CHANGEDATE,
                '' oldFULLNAME,'' newFULLNAME,'' oldIDCODE,'' newIDCODE,'' oldIDDATE,'' newIDDATE,'' oldIDPLACE,'' newIDPLACE,'' oldADDRESS, '' newADDRESS,
                '' oldEMAIL, '' newEMAIL, '' oldMOBILESMS, '' newMOBILESMS, '' oldTRADINGCODE, '' newTRADINGCODE, '' oldTRADINGCODEDT, '' newTRADINGCODEDT,
                max(case when MTL.COLUMN_NAME='FULLNAME' and child_table_name='CFRELATION' then FROM_VALUE else '' end) oldKFULLNAME,
                max(case when MTL.COLUMN_NAME='FULLNAME' and child_table_name='CFRELATION' then TO_VALUE else '' end) newKFULLNAME,
                max(case when MTL.COLUMN_NAME='LICENSENO' and child_table_name='CFRELATION' then FROM_VALUE else '' end) oldKLICENSENO,
                max(case when MTL.COLUMN_NAME='LICENSENO' and child_table_name='CFRELATION' then TO_VALUE else '' end) newKLICENSENO,
                max(case when MTL.COLUMN_NAME='LNIDDATE' and child_table_name='CFRELATION' then FROM_VALUE else '' end) oldKLNIDDATE,
                max(case when MTL.COLUMN_NAME='LNIDDATE' and child_table_name='CFRELATION' then TO_VALUE else '' end) newKLNIDDATE,
                max(case when MTL.COLUMN_NAME='LNPLACE' and child_table_name='CFRELATION' then FROM_VALUE else '' end) oldKLNPLACE,
                max(case when MTL.COLUMN_NAME='LNPLACE' and child_table_name='CFRELATION' then TO_VALUE else '' end) newKLNPLACE,
                max(case when MTL.COLUMN_NAME='RETYPE' and child_table_name='CFRELATION' then FROM_VALUE else '' end) oldKRETYPE,
                max(case when MTL.COLUMN_NAME='RETYPE' and child_table_name='CFRELATION' then TO_VALUE else '' end) newKRETYPE,
                max(case when MTL.COLUMN_NAME='ADDRESS' and child_table_name='CFRELATION' then FROM_VALUE else '' end) oldKADDRESS,
                max(case when MTL.COLUMN_NAME='ADDRESS' and child_table_name='CFRELATION' then TO_VALUE else '' end) newKADDRESS,
                max(case when MTL.COLUMN_NAME='TELEPHONE' and child_table_name='CFRELATION' then FROM_VALUE else '' end) oldKTELEPHONE,
                max(case when MTL.COLUMN_NAME='TELEPHONE' and child_table_name='CFRELATION' then TO_VALUE else '' end) newKTELEPHONE,
                max(case when MTL.ACTION_FLAG='ADD' and child_table_name='CFRELATION' then 'A'
                         When MTL.ACTION_FLAG='EDIT' and child_table_name='CFRELATION' then 'E' else '' end) KACTION ,
                '' oldDFULLNAME, '' newDFULLNAME,'' oldDLICENSENO, '' newDLICENSENO,'' oldDLNIDDATE, '' newDLNIDDATE, '' oldDLNPLACE, '' newDLNPLACE,
                '' oldDRETYPE, '' newDRETYPE,'' oldDADDRESS, '' newDADDRESS, '' oldDTELEPHONE, '' newDTELEPHONE,'' DACTION
            FROM MAINTAIN_LOG MTL,(
                                    select SUBSTR(MTL.RECORD_KEY,11,10) CUSTID,  MTL.MAKER_DT CHANGEDATE, RE.AUTOID AUTOID, max(MTL.MOD_NUM) MOD_NUM
                                    from MAINTAIN_LOG MTL, cfrelation RE
                                    where MTL.TABLE_NAME = 'CFMAST' and child_table_name='CFRELATION' AND INSTR(MTL.child_record_key,TO_CHAR(RE.AUTOID)) >0
                                        and MTL.COLUMN_NAME IN ('FULLNAME','LICENSENO','LNIDDATE','LNPLACE','RETYPE','ADDRESS','TELEPHONE')  AND MTL.ACTION_FLAG IN('ADD','EDIT')
                                        AND RE.RETYPE='009'
                                    group by SUBSTR(MTL.RECORD_KEY,11,10) ,  MTL.MAKER_DT , RE.AUTOID
                                )mtl1
            WHERE MTL.TABLE_NAME = 'CFMAST' and child_table_name='CFRELATION' AND INSTR(MTL.child_record_key,TO_CHAR(mtl1.AUTOID)) >0
                  and MTL.COLUMN_NAME IN ('FULLNAME','LICENSENO','LNIDDATE','LNPLACE','RETYPE','ADDRESS','TELEPHONE')  AND MTL.ACTION_FLAG IN('ADD','EDIT')
            and SUBSTR(MTL.RECORD_KEY,11,10) = mtl1.CUSTID and MTL.MAKER_DT =mtl1.CHANGEDATE  and mtl.MOD_NUM=mtl1.MOD_NUM
            group by SUBSTR(MTL.RECORD_KEY,11,10) ,  MTL.MAKER_DT
        )
        union all
        (
            select SUBSTR(MTL.RECORD_KEY,11,10) CUSTID,  MTL.MAKER_DT CHANGEDATE,
                '' oldFULLNAME,'' newFULLNAME,'' oldIDCODE,'' newIDCODE,'' oldIDDATE,'' newIDDATE,'' oldIDPLACE,'' newIDPLACE,'' oldADDRESS, '' newADDRESS,
                '' oldEMAIL, '' newEMAIL, '' oldMOBILESMS, '' newMOBILESMS, '' oldTRADINGCODE, '' newTRADINGCODE, '' oldTRADINGCODEDT, '' newTRADINGCODEDT,
                '' oldKFULLNAME, '' newKFULLNAME,'' oldKLICENSENO, '' newKLICENSENO,'' oldKLNIDDATE, '' newKLNIDDATE, '' oldKLNPLACE, '' newKLNPLACE,
                '' oldKRETYPE, '' newKRETYPE,'' oldKADDRESS, '' newKADDRESS, '' oldKTELEPHONE, '' newKTELEPHONE,'' KACTION,
                max(case when MTL.COLUMN_NAME='FULLNAME' and child_table_name='CFRELATION' then FROM_VALUE else '' end) oldDFULLNAME,
                max(case when MTL.COLUMN_NAME='FULLNAME' and child_table_name='CFRELATION' then TO_VALUE else '' end) newDFULLNAME,
                max(case when MTL.COLUMN_NAME='LICENSENO' and child_table_name='CFRELATION' then FROM_VALUE else '' end) oldDLICENSENO,
                max(case when MTL.COLUMN_NAME='LICENSENO' and child_table_name='CFRELATION' then TO_VALUE else '' end) newDLICENSENO,
                max(case when MTL.COLUMN_NAME='LNIDDATE' and child_table_name='CFRELATION' then FROM_VALUE else '' end) oldDLNIDDATE,
                max(case when MTL.COLUMN_NAME='LNIDDATE' and child_table_name='CFRELATION' then TO_VALUE else '' end) newDLNIDDATE,
                max(case when MTL.COLUMN_NAME='LNPLACE' and child_table_name='CFRELATION' then FROM_VALUE else '' end) oldDLNPLACE,
                max(case when MTL.COLUMN_NAME='LNPLACE' and child_table_name='CFRELATION' then TO_VALUE else '' end) newDLNPLACE,
                max(case when MTL.COLUMN_NAME='RETYPE' and child_table_name='CFRELATION' then FROM_VALUE else '' end) oldDRETYPE,
                max(case when MTL.COLUMN_NAME='RETYPE' and child_table_name='CFRELATION' then TO_VALUE else '' end) newDRETYPE,
                max(case when MTL.COLUMN_NAME='ADDRESS' and child_table_name='CFRELATION' then FROM_VALUE else '' end) oldDADDRESS,
                max(case when MTL.COLUMN_NAME='ADDRESS' and child_table_name='CFRELATION' then TO_VALUE else '' end) newDADDRESS,
                max(case when MTL.COLUMN_NAME='TELEPHONE' and child_table_name='CFRELATION' then FROM_VALUE else '' end) oldDTELEPHONE,
                max(case when MTL.COLUMN_NAME='TELEPHONE' and child_table_name='CFRELATION' then TO_VALUE else '' end) newDTELEPHONE,
                max(case when MTL.ACTION_FLAG='ADD' and child_table_name='CFRELATION' then 'A'
                         When MTL.ACTION_FLAG='EDIT' and child_table_name='CFRELATION' then 'E' else '' end) DACTION
            FROM MAINTAIN_LOG MTL,(
                                    select SUBSTR(MTL.RECORD_KEY,11,10) CUSTID,  MTL.MAKER_DT CHANGEDATE, RE.AUTOID AUTOID, max(MTL.MOD_NUM) MOD_NUM
                                    from MAINTAIN_LOG MTL, cfrelation RE
                                    where MTL.TABLE_NAME = 'CFMAST' and child_table_name='CFRELATION' AND INSTR(MTL.child_record_key,TO_CHAR(RE.AUTOID)) >0
                                        and MTL.COLUMN_NAME IN ('FULLNAME','LICENSENO','LNIDDATE','LNPLACE','RETYPE','ADDRESS','TELEPHONE')  AND MTL.ACTION_FLAG IN('ADD','EDIT')
                                        AND RE.RETYPE='010'
                                    group by SUBSTR(MTL.RECORD_KEY,11,10) ,  MTL.MAKER_DT , RE.AUTOID
                                )mtl1
            WHERE MTL.TABLE_NAME = 'CFMAST' and child_table_name='CFRELATION' AND INSTR(MTL.child_record_key,TO_CHAR(mtl1.AUTOID)) >0
                  and MTL.COLUMN_NAME IN ('FULLNAME','LICENSENO','LNIDDATE','LNPLACE','RETYPE','ADDRESS','TELEPHONE')  AND MTL.ACTION_FLAG IN('ADD','EDIT')
            and SUBSTR(MTL.RECORD_KEY,11,10) = mtl1.CUSTID and MTL.MAKER_DT =mtl1.CHANGEDATE  and mtl.MOD_NUM=mtl1.MOD_NUM
            group by SUBSTR(MTL.RECORD_KEY,11,10) ,  MTL.MAKER_DT
            )
            )mst
        group by CUSTID,  CHANGEDATE) mtl
        where   al.cdTYPE='CF' and al.cdname = 'COUNTRY'
        AND     CF.country = AL.CDVAL
        and mtl.custid=cf.custid
        and mtl.CHANGEDATE=to_date(I_DATE,'dd/MM/rrrr')
        AND     CF.CUSTODYCD = PV_CUSTODYCD


     ;


EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
 
 
 
 
/
