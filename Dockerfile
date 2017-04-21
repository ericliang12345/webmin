FROM ubuntu:16.04
MAINTAINER Advantech

# Setup adv user
RUN apt-get update && \
    apt-get install -y sudo libsocket6-perl && \
    useradd -m -k /home/adv adv -p adv -s /bin/bash -G sudo && \
    echo "adv ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo 'adv:adv' | chpasswd

 
RUN echo "Acquire::GzipIndexes \"false\"; Acquire::CompressionTypes::Order:: \"gz\";" >/etc/apt/apt.conf.d/docker-gzip-indexes && \
    apt-get update && apt-get install -y wget locales ntpdate && \
    locale-gen en_US.UTF-8 && locale-gen th_TH.UTF-8 && dpkg-reconfigure locales && \
    wget http://www.webmin.com/jcameron-key.asc && apt-key add jcameron-key.asc && \
    echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list && \
    echo "deb http://webmin.mirror.somersettechsolutions.co.uk/repository sarge contrib" >> /etc/apt/sources.list && \
    apt-get update && apt-get dist-upgrade -y && \
    apt-get install -y webmin && apt-get autoclean
   
USER adv

ENV LC_ALL en_US.UTF-8

EXPOSE 10000

VOLUME ["/etc/webmin"]

CMD sudo /usr/bin/touch /var/webmin/miniserv.log && sudo /usr/sbin/service webmin restart && sudo /usr/bin/tail -f /var/webmin/miniserv.log
