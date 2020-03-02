FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y git wget libpcre3 libpcre3-dev libssl-dev libmaxminddb0 libmaxminddb-dev mmdb-bin build-essential

RUN wget http://nginx.org/download/nginx-1.17.3.tar.gz && \
    tar zxvf nginx-1.17.3.tar.gz && \
    cd nginx-1.17.3 && \
    git clone https://github.com/leev/ngx_http_geoip2_module.git && \
    wget http://www.zlib.net/zlib-1.2.11.tar.gz && \
    tar -xvzf zlib-1.2.11.tar.gz && \
    cd zlib-1.2.11 && \
    ./configure --prefix=/usr/local/zlib && \
    make install && \
    cd .. && \
    ./configure --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=nginx --group=nginx --with-compat --with-file-aio --with-threads --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module --with-cc-opt='-g -O2 -fdebug-prefix-map=/data/builder/debuild/nginx-1.17.3/debian/debuild-base/nginx-1.17.3=. -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fPIC' --with-ld-opt='-Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,-z,now -Wl,--as-needed -pie' --add-module=ngx_http_geoip2_module --with-zlib=./zlib-1.2.11 --with-debug && \
    make && \
    make install && \
    adduser --system --disabled-login --home /var/cache/nginx --shell /sbin/nologin --group nginx

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
