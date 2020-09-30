### Availability Check
````
KAFKA_HOME="/Users/nahongze/Data/component/kafka/kafka_test"
````
- producer
````
export KAFKA_OPTS="-Djava.security.auth.login.config=$KAFKA_HOME/config/kafka_server_jaas.conf"
bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test --producer.config $KAFKA_HOME/config/client-sasl.properties
````
- consumer
````
export KAFKA_OPTS="-Djava.security.auth.login.config=$KAFKA_HOME/config/kafka_server_jaas.conf"
bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test --from-beginning --consumer.config $KAFKA_HOME/config/client-sasl.properties
````
