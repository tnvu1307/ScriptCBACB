--DROP TABLE FLMSGMAP;

CREATE TABLE flmsgmap
    (autoid                         NUMBER NOT NULL,
    refautoid                      NUMBER,
    frfield                        VARCHAR2(100 BYTE),
    tofield                        VARCHAR2(100 BYTE),
    length                         NUMBER,
    defaultvalue                   VARCHAR2(100 BYTE),
    description                    VARCHAR2(1000 BYTE),
    valuetype                      VARCHAR2(2 BYTE),
    issubval                       VARCHAR2(10 BYTE) DEFAULT 'N',
    issubheader                    VARCHAR2(50 BYTE)
    );
