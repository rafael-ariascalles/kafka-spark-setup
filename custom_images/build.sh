# -- Software Stack Version

SPARK_VERSION="3.1.1"
HADOOP_VERSION="3.2"
JUPYTERLAB_VERSION="3.0.15"

docker build \
  -f kafka-connect.Dockerfile \
  -t rjacdevops/kafka-connect-sqlserver .

docker build \
  --build-arg spark_version="${SPARK_VERSION}" \
  -f cluster-base.Dockerfile \
  -t rjacdevops/cluster-base .

docker build \
  --build-arg spark_version="${SPARK_VERSION}" \
  --build-arg hadoop_version="${HADOOP_VERSION}" \
  -f spark-base.Dockerfile \
  -t rjacdevops/spark-base .

docker build \
  -f spark-master.Dockerfile \
  -t rjacdevops/spark-master .

docker build \
  -f spark-worker.Dockerfile \
  -t rjacdevops/spark-worker .

docker build \
  --build-arg spark_version="${SPARK_VERSION}" \
  --build-arg jupyterlab_version="${JUPYTERLAB_VERSION}" \
  -f jupyterlab.Dockerfile \
  -t rjacdevops/jupyterlab .
