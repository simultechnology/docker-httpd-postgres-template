FROM centos:latest

RUN yum install -y epel-release \
    yum install -y http://rpms.famillecollet.com/enterprise/remi-release-7.rpm && \
    yum install yum-utils && \
    yum-config-manager --enable remi-php73 && \
    yum update -y && \
    yum install -y \
    php73-php.x86_64 \
    php73-php-bcmath.x86_64 \
    php73-php-cli.x86_64 \
    php73-php-common.x86_64 \
    php73-php-devel.x86_64 \
    php73-php-gd.x86_64 \
    php73-php-intl.x86_64 \
    php73-php-json.x86_64 \
    php73-php-mbstring.x86_64 \
    php73-php-mcrypt.x86_64 \
    php73-php-pdo.x86_64 \
    php73-php-pear.noarch \
    php73-php-xml.x86_64 \
    php73-php-ast.x86_64 \
    php73-php-opcache.x86_64 \
    php73-php-pecl-zip.x86_64 \
    php73-php-pgsql

RUN ln -fs /usr/bin/php73 /usr/bin/php && \
    ln -fs /etc/opt/remi/php73/php.ini /etc/php.ini && \
    ln -fs /etc/opt/remi/php73/php.d /etc/php.d && \
    ln -fs /etc/opt/remi/php73/pear.conf /etc/pear.conf && \
    ln -fs /etc/opt/remi/php73/pear /etc/pear

RUN yum install -y httpd-devel.x86_64 vim wget git zip unzip

RUN usermod -u 1000 apache && ln -sf /dev/stdout /var/log/httpd/access_log && ln -sf /dev/stderr /var/log/httpd/error_log

RUN unlink /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

RUN rm -f /etc/httpd/conf.d/welcome.conf \
    && sed -i -e "s/Options\ Indexes\ FollowSymLinks/Options\ -Indexes\ +FollowSymLinks/g" /etc/httpd/conf/httpd.conf \
    && sed -i -e "s/AllowOverride\ None/AllowOverride All/g" /etc/httpd/conf/httpd.conf \
    && echo "FileETag None" >> /etc/httpd/conf/httpd.conf \
    && sed -i -e "s/expose_php\ =\ On/expose_php\ =\ Off/g" /etc/php.ini \
    && sed -i -e "s/\;error_log\ =\ php_errors\.log/error_log\ =\ \/var\/log\/php_errors\.log/g" /etc/php.ini \
    && echo "ServerTokens Prod" >> /etc/httpd/conf/httpd.conf \
    && echo "ServerSignature Off" >> /etc/httpd/conf/httpd.conf

WORKDIR /var/www/html

#COPY ./httpd.sh /httpd.sh

#CMD "/httpd.sh"
#CMD "/usr/sbin/httpd -D FOREGROUND"
#ポート80を開ける
EXPOSE 80
#runした時にapache起動
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]

