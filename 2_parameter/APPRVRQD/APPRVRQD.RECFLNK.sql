SET DEFINE OFF;DELETE FROM APPRVRQD WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('RECFLNK','NULL');Insert into APPRVRQD   (OBJNAME, RQDSTRING, MAKERID, MAKERDT, APPRVID, APPRVDT, MODNUM, ADDATAPPR, EDITATAPPR, DELATAPPR, ADDCHILDATAPPR) Values   ('RECFLNK', 'ALL', NULL, TO_DATE(NULL,'DD/MM/RRRR'), NULL, TO_DATE(NULL,'DD/MM/RRRR'), 1, 'N', 'N', 'N', 'N');COMMIT;