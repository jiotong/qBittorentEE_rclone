FROM lsiobase/alpine:3.16 as builder
LABEL maintainer="K"

WORKDIR /qbittorrent

COPY install.sh /qbittorrent/
COPY ReleaseTag /qbittorrent/

RUN  apk add --no-cache ca-certificates curl

RUN cd /qbittorrent \
	&& chmod a+x install.sh \
	&& bash install.sh

# docker qBittorrent-Enhanced-Edition

FROM lsiobase/alpine:3.12

# environment settings
ENV TZ=Asia/Shanghai
ENV WEBUIPORT=8080

# add local files and install qbitorrent
COPY root /
COPY --from=builder  /qbittorrent/qbittorrent-nox   /usr/local/bin/qbittorrent-nox

# install python3
RUN  apk add --no-cache python3 \
&&   rm -rf /var/cache/apk/*   \
&&   chmod a+x  /usr/local/bin/qbittorrent-nox  

# add rclone
RUN if [ "$(uname -m)" = "x86_64" ];then s6_arch=amd64;elif [ "$(uname -m)" = "aarch64" ];then s6_arch=arm64;elif [ "$(uname -m)" = "armv7l" ];then s6_arch=arm; fi \
&& wget --no-check-certificate https://github.com/rclone/rclone/releases/download/v1.56.2/rclone-v1.56.2-linux-${s6_arch}.zip \
&& unzip rclone-v1.56.2-linux-${s6_arch}.zip \
&& cp ./rclone-*/rclone /usr/local/bin/ \
&& rm -rf ./rclone-* \
&& chmod a+x /usr/local/bin/rclone

# ports and volumes
VOLUME /downloads /config /upload
EXPOSE 8080  6881  6881/udp
