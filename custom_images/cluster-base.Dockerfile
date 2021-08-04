ARG debian_buster_image_tag=8-jre-slim
FROM openjdk:${debian_buster_image_tag}

# -- Layer: OS + Python 3.7

ARG spark_version=3.0.0
ARG shared_workspace=/opt/workspace

RUN mkdir -p ${shared_workspace} && \
    apt-get update -y && \
    apt-get install -y python3 python3-pip && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get install -y gcc \
    && rm -rf /var/lib/apt/lists/* \
    && pip3 install --no-cache-dir tf-models-official==2.4.0 pandas numpy \
    && pip3 install pyspark==${spark_version} spark-nlp \
    && apt-get purge -y --auto-remove gcc

ENV SHARED_WORKSPACE=${shared_workspace}

# -- Runtime

VOLUME ${shared_workspace}
CMD ["bash"]