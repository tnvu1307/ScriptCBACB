SET DEFINE OFF;
CREATE OR REPLACE function amqp_publish
(brokerId IN number, exchange IN varchar2, routingKey IN varchar2, message IN varchar2)
return NUMBER
as language java
name 'com.zenika.oracle.amqp.RabbitMQPublisher.amqpPublish(int, java.lang.String, java.lang.String, java.lang.String) return int';
/
