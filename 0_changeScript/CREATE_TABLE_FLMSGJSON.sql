--DROP TABLE FLMSGJSON;

CREATE TABLE flmsgjson
    (reqid                          NUMBER,
    body                           VARCHAR2(4000 BYTE),
    api                            VARCHAR2(1000 BYTE),
    tlid                           VARCHAR2(50 BYTE),
    token                          VARCHAR2(2000 BYTE),
    status                         VARCHAR2(10 BYTE) DEFAULT 'P',
    methods                        VARCHAR2(50 BYTE)
    );
