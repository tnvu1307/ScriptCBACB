SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_CMDMENU_ALL
(ODRID, CMDID, PRID, CMDNAME, EN_CMDNAME, 
 LAST, AUTHCODE, LEV, IMGINDEX, MODCODE, 
 OBJNAME, MENUTYPE, CMDCODE)
AS 
SELECT M.CMDID ODRID, M.CMDID, M.PRID, M.CMDNAME, M.EN_CMDNAME, M.LAST, M.AUTHCODE, M.LEV,
        (CASE WHEN M.LEV=1 THEN 0 ELSE (CASE WHEN M.LAST='Y' THEN 3 ELSE 1 END) END) IMGINDEX, 
        M.MODCODE, M.OBJNAME, M.MENUTYPE, M.CMDID CMDCODE
FROM CMDMENU M
UNION ALL
SELECT M.CMDID || '.' || T.TLTXCD ODRID, T.TLTXCD CMDID, M.CMDID PRID, T.TXDESC CMDNAME, T.EN_TXDESC EN_CMDNAME, 'Y' LAST, M.AUTHCODE, M.LEV,
        3 IMGINDEX, M.MODCODE, M.OBJNAME, M.MENUTYPE, T.TLTXCD CMDCODE
FROM TLTX T, APPMODULES A, CMDMENU M
WHERE T.DIRECT='Y' AND T.TLTXCD LIKE A.TXCODE || '%' AND NOT (A.MODCODE IS NULL) 
  AND M.MENUTYPE='T' AND M.MODCODE=A.MODCODE
/
