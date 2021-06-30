FROM confluentinc/cp-kafka-connect:6.2.0

RUN confluent-hub install --no-prompt confluentinc/kafka-connect-jdbc:10.2.0 &&\
    confluent-hub install --no-prompt mongodb/kafka-connect-mongodb:1.5.1 

COPY /driver/ /usr/share/confluent-hub-components/confluentinc-kafka-connect-jdbc/
