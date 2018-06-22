FROM java:openjdk-7-jre

# Install dependencies
RUN apt-get update && \
    apt-get install -y curl

# Install dockerize
ENV DOCKERIZE_VERSION v0.2.0
RUN curl -L "https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/dockerize-linux-amd64-${DOCKERIZE_VERSION}.tar.gz" -o "/tmp/dockerize-linux-amd64-${DOCKERIZE_VERSION}.tar.gz" \
    && tar -C /usr/local/bin -xzvf "/tmp/dockerize-linux-amd64-${DOCKERIZE_VERSION}.tar.gz"

# Install database client
RUN apt-get update && apt-get install -y postgresql-client

# Install OpenXDS
ENV HOME_SHARE="/usr/share/openxds"
ENV OPENXDS_HOME ${HOME_SHARE}

RUN mkdir -p ${HOME_SHARE}
WORKDIR ${HOME_SHARE}

RUN curl -L "https://github.com/jembi/openxds/releases/download/v1.1.2/openxds.tar.gz" -o openxds.tar.gz \
    && tar -zxvf openxds.tar.gz -C . \
    && rm openxds.tar.gz

ADD openxds.properties openxds.properties
ADD XdsCodes.xml conf/actors/XdsCodes.xml
ADD XdsRegistryConnections.xml conf/actors/XdsRegistryConnections.xml
ADD start_openxds.sh start_openxds.sh
RUN chmod +x start_openxds.sh

# Run using dockerize
CMD ["dockerize","-wait","tcp://postgresql-openxds:5432","-timeout","20s","/usr/share/openxds/start_openxds.sh", "run"]
