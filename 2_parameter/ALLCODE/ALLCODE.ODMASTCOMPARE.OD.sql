SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('ODMASTCOMPARE','NULL') AND NVL(CDTYPE,'NULL') = NVL('OD','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'ODMASTCOMPARE', 'OD8893', 'Broker-Client-VSD', 0, 'Y', 'Broker-Client-VSD');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'ODMASTCOMPARE', 'CLIENT', 'Đối chiếu 1 nguồn client', 1, 'Y', 'Reconcile 1 source Client');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'ODMASTCOMPARE', 'BROKER', 'Đối chiếu 1 nguồn broker', 2, 'Y', 'Reconcile 1 source broker');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'ODMASTCOMPARE', 'CLIENTBROKER', 'Đối chiếu nguồn Client và Broker', 3, 'Y', 'Reconcile source Client and Broker');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'ODMASTCOMPARE', 'CLIENTVSD', 'Đối chiếu nguồn Client và VSD', 4, 'Y', 'Reconcile source Client and VSD');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'ODMASTCOMPARE', 'VSDBROKER', 'Đối chiếu nguồn VSD và Broker', 5, 'Y', 'Reconcile source VSD and Broker');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'ODMASTCOMPARE', 'BROKERVSD', 'Đối chiếu nguồn Broker và VSD', 6, 'Y', 'Reconcile source Broker and VSD');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'ODMASTCOMPARE', 'VSDCLIENT', 'Đối chiếu nguồn VSD và Client', 7, 'Y', 'Reconcile source VSD and Client');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'ODMASTCOMPARE', 'CLIENTBROKERHIST', 'Đối chiếu lịch sử nguồn Client và Broker', 8, 'Y', 'Reconcile history source Client and Broker');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'ODMASTCOMPARE', 'CLIENTVSDHIST', 'Đối chiếu lịch sử nguồn Client và VSD ', 9, 'Y', 'Reconcile history source Client and VSD');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'ODMASTCOMPARE', 'BROKERVSDHIST', 'Đối chiếu lịch sử nguồn Broker và VSD', 10, 'Y', 'Reconcile history source Broker and VSD');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'ODMASTCOMPARE', 'OD8893HIST', 'Đối chiếu lịch sử nguồn Broker và Client và VSD', 11, 'Y', 'Reconcile history source Broker and Client and VSD');COMMIT;