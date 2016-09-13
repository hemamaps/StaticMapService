FROM ubuntu:14.04
MAINTAINER Yue Zhou "yue@hemamaps.com.au"

ADD .docker/depends /depends

RUN apt-key add /depends/nginx_signing.key; \
    echo "deb http://nginx.org/packages/ubuntu/ trusty nginx" > /etc/apt/sources.list.d/nginx.list; \
    apt-get update; \
    apt-get install -q -y supervisor nginx python-gdal python-mapnik2 python-pil python-dev python-virtualenv
    

RUN python /depends/get-pip.py virtualenv;
RUN virtualenv --system-site-packages /opt/ve/deploy; \
    /opt/ve/deploy/bin/pip install -r /depends/requirements.txt

RUN useradd deploy

ADD staticMaps /opt/apps/staticMaps
ADD .docker/nginx /opt/nginx
ADD .docker/supervisor /opt/supervisor
ADD .docker/bin /opt/bin/deploy
ADD .docker/rsyslog.conf /etc/rsyslog.conf
EXPOSE 8000
CMD ["/opt/bin/deploy/run_supervisord.sh", "web"]
