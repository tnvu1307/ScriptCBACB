SET DEFINE OFF;DELETE FROM APPRVRQD WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('FAMEMBERSEXTRA','NULL');Insert into APPRVRQD   (OBJNAME, RQDSTRING, MAKERID, MAKERDT, APPRVID, APPRVDT, MODNUM, ADDATAPPR, EDITATAPPR, DELATAPPR, ADDCHILDATAPPR) Values   ('FAMEMBERSEXTRA', 'ALL', '', TO_DATE('','DD/MM/RRRR'), '', TO_DATE('','DD/MM/RRRR'), 1, 'N', 'Y', 'N', 'Y');COMMIT;