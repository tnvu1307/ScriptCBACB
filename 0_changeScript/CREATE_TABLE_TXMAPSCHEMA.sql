--DROP TABLE TXMAPSCHEMA;

CREATE TABLE txmapschema
    (autoid                         NUMBER NOT NULL,
    frobj                          VARCHAR2(20 BYTE) NOT NULL,
    toobj                          VARCHAR2(30 BYTE) NOT NULL,
    refcode                        VARCHAR2(50 BYTE) NOT NULL,
    bankcode                       VARCHAR2(20 BYTE) NOT NULL,
    msgtype                        VARCHAR2(20 BYTE) NOT NULL,
    schbody                        VARCHAR2(4000 BYTE),
    description                    VARCHAR2(1000 BYTE),
    reqrestype                     VARCHAR2(2 BYTE),
    url_corebank                   VARCHAR2(200 BYTE),
    callback                       VARCHAR2(10 BYTE) DEFAULT 'N',
    methods                        VARCHAR2(50 BYTE)
    );
