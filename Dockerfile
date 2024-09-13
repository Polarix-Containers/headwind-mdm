FROM tomcat:9

LABEL maintainer="Thien Tran contact@tommytran.io"

ENV SERVER_VERSION=5.27.2
ENV CLIENT_VERSION=5.28

# Premium version has a different shared secret
ENV HMDM_VARIANT=os
ENV SHARED_SECRET=changeme-C3z9vi54

ENV HMDM_URL=https://h-mdm.com/files/hmdm-${SERVER_VERSION}-${HMDM_VARIANT}.war

# Available values: en, ru (en by default)
ENV INSTALL_LANGUAGE=en

# TLS configuration. These should be kept the same to maintain compatibility with upstream.
ENV PROTOCOL=https
ENV HTTPS_LETSENCRYPT=true
ENV HTTPS_CERT=cert.pem
ENV HTTPS_FULLCHAIN=fullchain.pem
ENV HTTPS_PRIVKEY=privkey.pem

COPY get-aapt2.sh .
COPY .gnupg /root/.gnupg

RUN apt update \
    && apt full-upgrade -y \
	&& apt install -y gnupg libarchive-tools postgresql-client sed wget yq \
	&& chmod u+x ./get-aapt2.sh \
	&& ./get-aapt2.sh \
	&& chmod +x aapt2 \
	&& mv aapt2 /usr/bin/local \
	&& apt purge -y gnupg libarchive-tools yq \
	&& rm -rf /var/lib/apt/lists/* \
 	&& mkdir -p /usr/local/tomcat/conf/Catalina/localhost /usr/local/tomcat/ssl

EXPOSE 8080/tcp 8443/tcp 31000/tcp

COPY docker-entrypoint.sh /
COPY tomcat_conf/server.xml /usr/local/tomcat/conf/server.xml 
ADD templates /opt/hmdm/templates/

ENTRYPOINT ["/docker-entrypoint.sh"]
