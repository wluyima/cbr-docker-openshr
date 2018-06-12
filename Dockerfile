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
ENV HOME_SHARE="/opt"

RUN mkdir -p "${HOME_SHARE}/openxds/" \
    && curl -L "https://github.com/jembi/openxds/releases/download/v1.1.2/openxds.tar.gz" \
            -o ${HOME_SHARE}/openxds.tar.gz \
    && tar -zxvf ${HOME_SHARE}/openxds.tar.gz -C ${HOME_SHARE}/openxds \
    && rm ${HOME_SHARE}/openxds.tar.gz

ADD openxds.properties ${HOME_SHARE}/openxds/openxds.properties
RUN cd ${HOME_SHARE}/openxds/
ADD run.sh ${HOME_SHARE}/openxds/run.sh
RUN chmod +x ${HOME_SHARE}/openxds/run.sh

# Run using dockerize
CMD ["dockerize","-wait","tcp://postgresql-openxds:5432","-timeout","20s","/opt/openxds/run.sh", "run"]
