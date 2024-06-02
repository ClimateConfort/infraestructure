FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install -y \
    default-jdk \
    wget && \
    rm -rf /var/lib/apt/lists/*

ENV KAFKA_PATH=/usr/local/kafka

# https://kafka.apache.org/downloads
#RUN wget https://downloads.apache.org/kafka/3.5.0/kafka_2.13-3.5.0.tgz && \
RUN wget https://archive.apache.org/dist/kafka/3.5.0/kafka_2.13-3.5.0.tgz && \
    tar xzf kafka_2.13-3.5.0.tgz && \
    mv kafka_2.13-3.5.0 $KAFKA_PATH && \
    rm -rf kafka_2.13-3.5.0.tgz


# Install HDFS 2 Sink Conector
# ---
RUN mkdir $KAFKA_PATH/plugins && \
    mkdir $KAFKA_PATH/plugins/kafka-hdfs-connect
    
COPY kafka-connect/confluentinc-kafka-connect-hdfs-10.1.17/kafka-hdfs-connect $KAFKA_PATH/plugins/kafka-hdfs-connect
  
COPY kafka-connect/connect-distributed.properties $KAFKA_PATH/config
# ---

COPY scripts $KAFKA_PATH

WORKDIR $KAFKA_PATH

RUN chmod +x *.sh

EXPOSE 2181 9092

#CMD ["sh", "$KAFKA_PATH/bin/connect-distributed.sh", "$KAFKA_PATH/config/connect-distributed.properties", "&"]
#ENTRYPOINT sh bin/connect-distributed.sh config/connect-distributed.properties && tail -f /dev/null

