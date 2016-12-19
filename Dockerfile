FROM centos:7
MAINTAINER Marcos Entenza

ENV JAVA_6_HOME /usr/java/jdk1.6.0_45
ENV JAVA_7_HOME /usr/java/jdk1.7.0_79
ENV JAVA_8_HOME /usr/java/jdk1.8.0_101
ENV JAVA_HOME /usr/java/jdk1.8.0_101

RUN yum install git wget tar hostname lsof net-tools -y && yum clean all

WORKDIR /usr/local/src

COPY src/* ./

RUN cp epel-apache-maven.repo /etc/yum.repos.d/ && \
wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-x64.rpm && \
wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u101-b13/jdk-8u101-linux-x64.rpm && \
rpm -i jdk-6u45-linux-amd64.rpm --force && \
rpm -i jdk-7u79-linux-x64.rpm --force && \
rpm -i jdk-8u101-linux-x64.rpm --force && \
rpm -i epel-release-7-8.noarch.rpm && \
yum install apache-maven -y && yum clean all

WORKDIR /root

COPY src/startup.sh .
RUN chmod +x howto-startup.sh pinpoint-start.sh && \
mkdir /root/logs \
echo "/root/howto-startup.sh" >> /etc/bashrc

RUN git clone https://github.com/naver/pinpoint.git /pinpoint
WORKDIR /pinpoint
RUN git checkout tags/1.6.0
RUN mvn install -Dmaven.test.skip=true -B

RUN sed -i '/^CLOSE_WAIT_TIME/c\CLOSE_WAIT_TIME=1000' /pinpoint/quickstart/bin/start-collector.sh && \
sed -i '/^CLOSE_WAIT_TIME/c\CLOSE_WAIT_TIME=1000' /pinpoint/quickstart/bin/start-web.sh && \
sed -i '/^CLOSE_WAIT_TIME/c\CLOSE_WAIT_TIME=1000' /pinpoint/quickstart/bin/start-testapp.sh

WORKDIR quickstart/hbase
ADD http://archive.apache.org/dist/hbase/hbase-1.0.3/hbase-1.0.3-bin.tar.gz ./
RUN tar -xf hbase-1.0.3-bin.tar.gz
RUN rm hbase-1.0.3-bin.tar.gz
RUN ln -s hbase-1.0.3 hbase
RUN cp ../conf/hbase/hbase-site.xml hbase-1.0.3/conf/
RUN chmod +x hbase-1.0.3/bin/start-hbase.sh

EXPOSE 28080 28081

WORKDIR /pinpoint
VOLUME [/pinpoint]

CMD ["sh","/root/pinpoint-start.sh"]
