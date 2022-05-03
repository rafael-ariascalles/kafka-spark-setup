FROM rjacdevops/cluster-base

# -- Layer: JupyterLab

ARG spark_version=3.0.0
ARG jupyterlab_version=3.0.15

RUN apt-get update \
    && apt-get install -y gcc \
    && pip3 install --no-cache-dir pyspark==${spark_version} spark-nlp \
    && apt-get purge -y --auto-remove gcc \
    && pip3 install wget jupyterlab==${jupyterlab_version} 

EXPOSE 8888
WORKDIR ${SHARED_WORKSPACE}
CMD jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token=