--DROP TABLE SYNC_TO_REDIS;

CREATE TABLE sync_to_redis
    (autoid                         NUMBER,
    synctype                       VARCHAR2(50 BYTE),
    synckey                        VARCHAR2(50 BYTE),
    syncvalue                      VARCHAR2(200 BYTE),
    error_msg                      VARCHAR2(500 BYTE),
    status                         VARCHAR2(10 BYTE) DEFAULT 'P',
    created_at                     TIMESTAMP (6) DEFAULT SYSTIMESTAMP
    );
