#!/bin/sh

export LUAJIT_LIB=/usr/local/lib
# Not use at 20211215.
#export LUAJIT_INC=/usr/local/include/luajit-2.0
export LUAJIT_INC=/usr/local/include/luajit-2.1

./configure \
  --prefix=/usr/local/etc/nginx \
  --sbin-path=/usr/local/sbin/nginx \
  --modules-path=/usr/local/libexe/nginx \
  --conf-path=/usr/local/etc/nginx/nginx.conf \
  --error-log-path=/var/log/nginx/error.log \
  --http-log-path=/var/log/nginx/access.log \
  --pid-path=/var/run/nginx.pid \
  --lock-path=/var/run/nginx.lock \
{% if ansible_facts['os_family'] == 'FreeBSD' %}
  --http-client-body-temp-path=/var/tmp/nginx/client_body_temp \
  --http-proxy-temp-path=/var/tmp/nginx/proxy_temp \
  --http-fastcgi-temp-path=/var/tmp/nginx/fastcgi_temp \
  --http-uwsgi-temp-path=/var/tmp/nginx/uwsgi_temp \
  --http-scgi-temp-path=/var/tmp/nginx/scgi_temp \
{% endif %}
  --user={{ nginx_user }} \
  --group={{ nginx_group }} \
  --with-http_ssl_module \
{% if openssl_dir is defined and 'stat' in openssl_dir and openssl_dir.stat.exists %}
  --with-openssl=/usr/local/src/openssl-{{ openssl_ver }} \
{% endif %}
  --with-http_realip_module \
  --with-http_addition_module \
  --with-http_sub_module \
  --with-http_dav_module \
  --with-http_flv_module \
  --with-http_mp4_module \
  --with-http_gunzip_module \
  --with-http_gzip_static_module \
  --with-http_random_index_module \
  --with-http_secure_link_module \
  --with-http_stub_status_module \
  --with-http_auth_request_module \
  --with-http_xslt_module=dynamic \
  --with-http_image_filter_module \
  --with-http_perl_module=dynamic \
  --with-threads \
  --with-stream \
  --with-stream_ssl_module \
  --with-stream_ssl_preread_module \
  --with-http_slice_module \
  --with-mail \
  --with-mail_ssl_module \
  --with-file-aio \
  --with-http_v2_module \
  --with-google_perftools_module \
  --with-cc-opt='-I /usr/local/include' \
{% if ansible_facts['os_family'] == 'FreeBSD' %}
  --with-ld-opt='-L /usr/local/lib' \
{% else %}
  --with-ld-opt='-Wl,-rpath,/usr/local/lib' \
{% endif %}
  --add-module=../ngx_devel_kit \
  --add-module=../lua-nginx-module \
  --add-module=../naxsi/naxsi_src \
  --add-module=../ngx_http_geoip2_module
