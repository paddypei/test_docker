#This docker file

#VERSION 1

#Author:paddypei

#Base image 可以是镜像名字或者镜像ID

FROM centos:7

 

#Maintainer 作者 邮箱

MAINTAINER paddypei 535768220@qq.com


#put nginx-1.12.2.tar.gz into /usr/local/src and unpack nginx

#ADD nginx-1.12.2.tar.gz /usr/local/src

ADD http://nginx.org/download/nginx-1.12.2.tar.gz .
RUN tar -zxvf nginx-1.12.2.tar.gz -C /usr/local/src
 

# running required command 在容器里运行nginx需要依赖包的命令

RUN yum install -y gcc gcc-c++ glibc make autoconf openssl openssl-devel

RUN yum install -y wget

RUN yum install -y libxslt-devel -y gd gd-devel GeoIP GeoIP-devel pcre pcre-devel

RUN useradd -M -s /sbin/nologin nginx

 

# change dir to /usr/local/src/nginx-1.12.2 去到nginx解压目录

WORKDIR /usr/local/src/nginx-1.12.2

 

# execute command to compile nginx 在容器里运行命令进行编译安装

RUN ./configure --user=nginx --group=nginx --prefix=/usr/local/nginx --with-file-aio --with-http_ssl_module --with-http_realip_module --with-http_addition_module --with-http_xslt_module --with-http_image_filter_module --with-http_geoip_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_auth_request_module --with-http_random_index_module --with-http_secure_link_module --with-http_degradation_module --with-http_stub_status_module && make && make install

#安装python3
###
ADD https://www.python.org/ftp/python/3.6.5/Python-3.6.5.tar.xz .
RUN tar -xvf Python-3.6.5.tar.xz
WORKDIR /Python-3.6.5  
RUN ./configure --prefix=/usr/local/python3 make && make install
RUN ln -s /usr/local/python3/bin/python3 /usr/bin/python3
RUN rm -rf /Python-3.6.5*
#RUN yum install -y epel-release
#RUN yum install -y python-pip
###
#RUN set -ex
RUN ln -s /usr/local/python3/bin/pip3 /usr/bin/pip3
RUN python --version
RUN python3 --version

# 安装mysql
RUN rpm -Uvh http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm

RUN yum repolist enabled | grep "mysql.*-community.*"

RUN yum -y install mysql-community-server

RUN systemctl enable mysqld



#env 将nginx启动命令加到环境变量里

ENV PATH /usr/local/nginx/sbin:$PATH

 

#expose 映射80端口

EXPOSE 80
#CMD ["/usr/sbin/init"]