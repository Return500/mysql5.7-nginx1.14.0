FROM centos:7.5.1804
MAINTAINER wind_qq <wind_qq@163.com>

RUN yum update -y \
	&& yum install -y wget vim numactl.x86_64 libaio* gcc zlib zlib-devel pcre-devel openssl openssl-devel \
	&& wget --no-cookies --no-check-certificate --header \
		"Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; \
		oraclelicense=accept-securebackup-cookie" \
		"http://download.oracle.com/otn-pub/java/jdk/8u141-b15/336fa29ff2bb4ef291e347e091f7f4a7/jdk-8u141-linux-x64.tar.gz" \
	&& tar -zxvf jdk-8u141-linux-x64.tar.gz \
	&& mv jdk1.8.0_141 /usr/local/
	
ENV JAVA_HOME /usr/local/jdk1.8.0_141
ENV JRE_HOME ${JAVA_HOME}/jre
ENV CLASSPATH .:${JAVA_HOME}/lib:${JRE_HOME}/lib
ENV PATH ${JAVA_HOME}/bin:$PATH

RUN wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.24-el7-x86_64.tar.gz \
	&& tar -zxvf mysql-5.7.24-el7-x86_64.tar.gz \
	&& mv mysql-5.7.24-el7-x86_64 /usr/local/ \
	&& mkdir /usr/local/mysql-5.7.24-el7-x86_64/data \
	&& echo "[mysqld]" >> /etc/my.cnf \
	&& echo "port=3306" >> /etc/my.cnf \
	&& echo "basedir=/usr/local/mysql-5.7.24-el7-x86_64" >> /etc/my.cnf \
	&& echo "datadir=/usr/local/mysql-5.7.24-el7-x86_64/data" >> /etc/my.cnf \
	&& echo "character-set-server=utf8" >> /etc/my.cnf \
	&& echo "default-storage-engine=INNODB" >> /etc/my.cnf \
	&& echo "max_connections=4096" >> /etc/my.cnf \
	&& echo "wait_timeout=1800" >> /etc/my.cnf \
	&& echo "interactive_timeout=1800" >> /etc/my.cnf \
	&& echo "sql_mode=STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION" >> /etc/my.cnf \
	&& echo "lower_case_table_names=1" >> /etc/my.cnf \
	&& echo "skip-grant-tables" >> /etc/my.cnf \
	&& echo "[mysql]" >> /etc/my.cnf \
	&& echo "default-character-set=utf8" >> /etc/my.cnf \
	&& echo "[client]" >> /etc/my.cnf \
	&& echo "default-character-set=utf8" >> /etc/my.cnf \
	&& groupadd mysql \
	&& useradd mysql -g mysql \
	&& chown -R mysql:mysql /usr/local/mysql-5.7.24-el7-x86_64 \
	&& cd /usr/local/mysql-5.7.24-el7-x86_64 \
	&& ./bin/mysqld \
		--no-defaults \
		--user=mysql \
		--basedir=/usr/local/mysql-5.7.24-el7-x86_64 \
		--datadir=/usr/local/mysql-5.7.24-el7-x86_64/data \
		--initialize \
	&& ./support-files/mysql.server start \
	&& ln -s /usr/local/mysql-5.7.24-el7-x86_64/support-files/mysql.server /etc/init.d/mysqld \
	&& ln -s /usr/local/mysql-5.7.24-el7-x86_64/bin/mysql /usr/bin/mysql \
	&& rm -r /jdk-8u141-linux-x64.tar.gz \
	&& rm -r /mysql-5.7.24-el7-x86_64.tar.gz

RUN wget http://nginx.org/download/nginx-1.14.0.tar.gz \
	&& tar -zxvf nginx-1.14.0.tar.gz \
	&& cd nginx-1.14.0 \
	&& ./configure --prefix=/usr/local/nginx-1.14.0/ \
	&& make \
	&& make install \
	&& cd /usr/local/nginx-1.14.0/sbin \
	&& ./nginx \
	&& rm -r /nginx-1.14.0.tar.gz

