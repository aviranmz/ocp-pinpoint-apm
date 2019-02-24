FROM centos:7
MAINTAINER Marcos Entenza <mak@redhat.com>

LABEL io.k8s.description="Platform for running Pinpoint Application Performance Monitoring" \
      io.k8s.display-name="Pinpoint APM" \
      io.openshift.expose-services="28080:http,28081:http,28082:http" \
      io.openshift.tags="pinpoint-apm"

ENV JAVA_6_HOME /usr/java/jdk1.6.0_45
ENV JAVA_7_HOME /usr/java/jdk1.7.0_79-amd64
ENV JAVA_8_HOME /usr/java/jdk1.8.0_201-amd64
ENV JAVA_9_HOME /usr/java/jdk-9.0.4-amd64
ENV JAVA_HOME /usr/java/jdk1.8.0_201-amd64


RUN  find /usr/ -name *jdk

#CMD ["sleep","1000000"]
