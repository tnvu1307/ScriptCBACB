SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_AF_ADTYPE_INFO
(ODRPRIO, FLDKEY, FILTERCD, VALUE, VALUECD, 
 DISPLAY, EN_DISPLAY, DESCRIPTION, AFTYP, ADTYPEMAP, 
 VATRATE, AFEEBANK, AMINFEEBANK, AMINBAL, AINTRATE, 
 AMINFEE, AMAXFEE, FEEONDAY, AMTLIMITONDAY)
AS 
SELECT DISTINCT MST.ODRPRIO, MST.FLDKEY, MST.FILTERCD, MST.VALUE, MST.VALUECD, MST.DISPLAY, MST.EN_DISPLAY,
       MST.DESCRIPTION, MST.AFTYP, MST.ADTYPEMAP, MST.VATRATE, MST.AFEEBANK, MST.AMINFEEBANK, MST.AMINBAL,
       MST.AINTRATE, MST.AMINFEE, MST.AMAXFEE, FEEONDAY , mst.AMTLIMITONDAY
FROM       
(
    SELECT 1 ODRPRIO, AF.ACTYPE || AD.ACTYPE FLDKEY, AF.ACTYPE FILTERCD, AD.ACTYPE VALUE, AD.ACTYPE VALUECD,
        AD.ACTYPE || '.' || AD.TYPENAME DISPLAY, AD.ACTYPE || '.' || AD.TYPENAME EN_DISPLAY, AD.ACTYPE || '.' || AD.TYPENAME DESCRIPTION,
        AF.ACTYPE AFTYP, AD.ACTYPE ADTYPEMAP, AD.VATRATE, AD.ADVRATE AINTRATE, AD.ADVMINAMT AMINBAL, AD.ADVBANKRATE AFEEBANK, 
        AD.ADVMINFEEBANK AMINFEEBANK, AD.advminfee AMINFEE, AD.advmaxfee AMAXFEE, MST.ACCTNO, AD.FEEONDAY, ad.AMTLIMITONDAY
    FROM AFMAST MST, AFTYPE AF, ADTYPE AD
    WHERE MST.actype = AF.ACTYPE AND AF.ADTYPE=AD.ACTYPE
    UNION ALL
    SELECT 2 ODRPRIO, AF.ACTYPE || AD.ACTYPE FLDKEY, AF.ACTYPE FILTERCD, AD.ACTYPE VALUE, AD.ACTYPE VALUECD,
        AD.ACTYPE || '.' || AD.TYPENAME DISPLAY, AD.ACTYPE || '.' || AD.TYPENAME EN_DISPLAY, AD.ACTYPE || '.' || AD.TYPENAME DESCRIPTION,
        AF.ACTYPE AFTYP, AD.ACTYPE ADTYPEMAP, AD.VATRATE, AD.ADVRATE AINTRATE, AD.ADVMINAMT AMINBAL, AD.ADVBANKRATE AFEEBANK, 
        AD.ADVMINFEEBANK AMINFEEBANK,AD.ADVMINFEE AMINFEE, AD.ADVMAXFEE AMAXFEE, MST.ACCTNO, AD.FEEONDAY, ad.AMTLIMITONDAY
    FROM AFMAST MST, AFTYPE AF, ADTYPE AD
    WHERE AF.ADTYPE<>AD.ACTYPE AND MST.ACTYPE = AF.ACTYPE
)MST
ORDER BY MST.ODRPRIO
/
