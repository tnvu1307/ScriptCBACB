SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('TYPEPON','NULL') AND NVL(CDTYPE,'NULL') = NVL('SA','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'TYPEPON', 'CR', 'Ghi tăng trên GCN cũ', 1, 'Y', 'Increase on old GCN');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'TYPEPON', 'NE', 'Phát hành GCN mới', 2, 'Y', 'Release new GCN');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'TYPEPON', 'DR', 'Ghi giảm trên GCN cũ', 3, 'Y', 'Deincrease on old GCN');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'TYPEPON', 'OL', 'Thu hồi GCN cũ', 4, 'Y', 'Revoke old GCN');COMMIT;