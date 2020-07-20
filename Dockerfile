#This docker file

#VERSION 1

#Author:paddypei

#Base image 可以是镜像名字或者镜像ID

FROM centos:7

 

#Maintainer 作者 邮箱

MAINTAINER paddypei 535768220@qq.com

RUN mkdir /soft

# -----------------------------------------------------------------------------
# Make src dir
# -----------------------------------------------------------------------------
ENV HOME /
ENV CUSTOM_BIN_PATH /usr/local
ENV SRC_DIR $HOME/soft
RUN mkdir -p ${SRC_DIR}


# running required command 在容器里运行nginx需要依赖包的命令

RUN yum install -y gcc gcc-c++ glibc make autoconf openssl openssl-devel

RUN yum install -y wget

RUN yum install -y libxslt-devel -y gd gd-devel GeoIP GeoIP-devel pcre pcre-devel

RUN useradd -M -s /sbin/nologin nginx

# -----------------------------------------------------------------------------
# Devel libraries for delelopment tools like php & nginx ...
# -----------------------------------------------------------------------------
RUN yum -y install \
	lrzsz psmisc epel-release lemon \
    tar gzip bzip2 bzip2-devel unzip file perl-devel perl-ExtUtils-Embed perl-CPAN \
    pcre pcre-devel openssh-server openssh sudo \
    screen vim git telnet expat expat-devel\
    ca-certificates m4\
    gd gd-devel libjpeg libjpeg-devel libpng libpng-devel libevent libevent-devel \
    net-snmp net-snmp-devel net-snmp-libs \
    freetype freetype-devel libtool-tldl libtool-ltdl-devel libxml2 libxml2-devel unixODBC unixODBC-devel libyaml libyaml-devel\
    libxslt libxslt-devel libmcrypt libmcrypt-devel freetds freetds-devel \
    curl-devel gettext-devel \
    openldap openldap-devel libc-client-devel \
    jemalloc jemalloc-devel inotify-tools nodejs apr-util yum-utils tree js\
    && ln -s /usr/lib64/libc-client.so /usr/lib/libc-client.so \
    && rm -rf /var/cache/{yum,ldconfig}/* \
    && rm -rf /etc/ld.so.cache \
    && yum clean all
    
RUN rpm --import /etc/pki/rpm-gpg/RPM*

RUN yum -y install htop

# -----------------------------------------------------------------------------
# Install nginx
# -----------------------------------------------------------------------------

ENV NGINX_INSTALL_DIR ${CUSTOM_BIN_PATH}/nginx
RUN cd ${SRC_DIR} \ 
	&&  wget -q -O nginx-1.12.2.tar.gz http://nginx.org/download/nginx-1.12.2.tar.gz \
	&& tar zxvf nginx-1.12.2.tar.gz \
	&& cd nginx-1.12.2 \
	&& ./configure --user=nginx --group=nginx --prefix=${NGINX_INSTALL_DIR} --with-file-aio --with-http_ssl_module --with-http_realip_module --with-http_addition_module --with-http_xslt_module --with-http_image_filter_module --with-http_geoip_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_auth_request_module --with-http_random_index_module --with-http_secure_link_module --with-http_degradation_module --with-http_stub_status_module \
	&& make \
	&& make install \
	&& rm -rf ${SRC_DIR}/nginx-*
	
	
# =========================以下命令也可以正确安装=================================================
# ADD http://nginx.org/download/nginx-1.12.2.tar.gz .
# RUN tar -zxvf nginx-1.12.2.tar.gz -C /usr/local/src

# change dir to /usr/local/src/nginx-1.12.2 去到nginx解压目录

# WORKDIR /usr/local/src/nginx-1.12.2

# execute command to compile nginx 在容器里运行命令进行编译安装

# RUN ./configure --user=nginx --group=nginx --prefix=/usr/local/nginx --with-file-aio --with-http_ssl_module --with-http_realip_module --with-http_addition_module --with-http_xslt_module --with-http_image_filter_module --with-http_geoip_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_auth_request_module --with-http_random_index_module --with-http_secure_link_module --with-http_degradation_module --with-http_stub_status_module && make && make install

#env 将nginx启动命令加到环境变量里

# ENV PATH /usr/local/nginx/sbin:$PATH
# ==========================================================================


#安装python3
###
ADD https://www.python.org/ftp/python/3.6.5/Python-3.6.5.tar.xz .
RUN tar -xvf Python-3.6.5.tar.xz -C /soft
WORKDIR /soft/Python-3.6.5

RUN ./configure --prefix=/usr/local/python3 && make && make install
RUN ln -s /usr/local/python3/bin/python3.6 /usr/bin/python3
RUN rm -rf /soft/Python-3.6.5*
#RUN yum install -y epel-release
#RUN yum install -y python-pip
###
#RUN set -ex
RUN ln -s /usr/local/python3/bin/pip3 /usr/bin/pip3
RUN python --version
RUN python3 --version

RUN yum install -y python-setuptools \
    && easy_install pip \ 
    && pip install django==1.8.5 -i http://pypi.douban.com/simple/ --trusted-host pypi.douban.com \
    && pip install psycopg2 -i http://pypi.douban.com/simple/ --trusted-host pypi.douban.com




# 安装mysql
RUN rpm -Uvh http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm

RUN yum repolist enabled | grep "mysql.*-community.*"

RUN yum -y install mysql-community-server

RUN systemctl enable mysqld


#expose 映射80端口

EXPOSE 22 80 443 8080 8000
#CMD ["/usr/sbin/init"]