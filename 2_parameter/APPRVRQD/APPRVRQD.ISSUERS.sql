SET DEFINE OFF;DELETE FROM APPRVRQD WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('ISSUERS','NULL');Insert into APPRVRQD   (OBJNAME, RQDSTRING, MAKERID, MAKERDT, APPRVID, APPRVDT, MODNUM, ADDATAPPR, EDITATAPPR, DELATAPPR, ADDCHILDATAPPR) Values   ('ISSUERS', 'ALL', NULL, TO_DATE(NULL,'DD/MM/RRRR'), NULL, TO_DATE(NULL,'DD/MM/RRRR'), 1, 'N', 'Y', 'Y', 'Y');COMMIT;