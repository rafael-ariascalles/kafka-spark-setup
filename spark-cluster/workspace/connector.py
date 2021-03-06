import json
from confluent_kafka.admin import AdminClient, NewTopic
import requests

KAFKA_CONNECT_URL = "http://connect:8083/connectors"
KAFKA_BROKER = "PLAINTEXT://kafka0:19092"
CONNECTOR_NAME = "producer"

def configure_connector():
    """
    Starts and configures the Kafka Connect connector
    """
    
    
    print("create initial topic")    
    admin_client = AdminClient({"bootstrap.servers":KAFKA_BROKER})
    topic_list = []
    input_topic = NewTopic("staging_input", 10, 1)
    middle_topic = NewTopic("preprocess", 25, 1)
    output_topic = NewTopic("inference",25, 1)

    topic_list.append(input_topic)
    topic_list.append(middle_topic)
    topic_list.append(output_topic)
    
    admin_client.create_topics(topic_list)

    print("creating or updating kafka connect connector...")
    
    resp = requests.get("{}/{}".format(KAFKA_CONNECT_URL,CONNECTOR_NAME))

    if resp.status_code == 200:
        print("connector already created skipping recreation")
        return

    print("connector code not completed skipping connector creation")
    resp = requests.post(
        KAFKA_CONNECT_URL,
        headers={"Content-Type": "application/json"},
        data=json.dumps({
            "name": CONNECTOR_NAME,
            "config": {
                "connector.class": "io.confluent.connect.jdbc.JdbcSourceConnector",
                "key.converter": "org.apache.kafka.connect.json.JsonConverter",
                "key.converter.schemas.enable": "false",
                "value.converter": "org.apache.kafka.connect.json.JsonConverter",
                "value.converter.schemas.enable": "false",
                "tasks.max": "1",
                "batch.max.rows": "500",
                "connection.url": "jdbc:sqlserver://<SERVERNAME>:<PORT>;databaseName=<DBNAME>",
                "connection.user": "<USER>",
                "connection.password": "<PASSWORD>",
                "table.whitelist": "<TABLENAME_TO_MONITOR>",
                "mode": "incrementing",
                "incrementing.column.name": "<COLUMN_TO_DETECT_INCREMENT>",
                "topic.prefix": "staging_",
                "poll.interval.ms": "5000",
                "connection.attempts": "10",
                "connection.backoff.ms":"30000",
                "validate.non.null": "false"
            }
        }),
    )

    ## Ensure a healthy response was given
    print(resp.raise_for_status())
    print("connector created successfully")


if __name__ == "__main__":
    configure_connector()
