FROM centos:7.4.1708 
RUN mkdir -p /data/web/
ADD CentOS-Base.repo	 /etc/yum.repos.d/ 
ADD pcre2-10.23.tar.gz   /data/
ADD nginx-1.12.1.tar.gz  /data/
WORKDIR /data/
#install depences
RUN yum -y install lsof gcc gcc-c++ wget pcre-devel openssl openssl-devel && yum clean all && \
rm -rf /var/cache/yum
#install pcre
RUN cd pcre2-10.23 && ./configure && make && make install && \
cd .. && rm -rf pcre2-10.23 && \
#install nginx
cd nginx-1.12.1 && ./configure --prefix=/usr/local/nginx-1.12.1 \
--with-pcre \
--user=daemon \
--group=daemon \
--with-http_stub_status_module \
--with-http_ssl_module \
--with-http_realip_module &&\
make -j4 && make install &&\
cd .. && rm -rf nginx-1.12.1
EXPOSE 80 20
RUN yum -y  install python-setuptools && easy_install supervisor
RUN mkdir -p /etc/supervisor/conf.d
ADD supervisord.conf  /etc/supervisor
ADD nginx.conf  /etc/supervisor/conf.d
CMD /usr/bin/supervisord "-c" "/etc/supervisor/supervisord.conf"

test
