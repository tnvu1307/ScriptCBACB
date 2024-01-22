SET DEFINE OFF;
CREATE OR REPLACE function amqp_exchange_declare
(brokerId IN number, exchange IN varchar2, exchange_type IN varchar2)
return NUMBER
as language java
name 'com.zenika.oracle.amqp.RabbitMQPublisher.amqpExchangeDeclare(int, java.lang.String, java.lang.String) return int';
/
