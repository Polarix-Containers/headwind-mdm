FROM tomcat:9

ENV VERSION=5.27.2
ENV CLIENT_VERSION=5.28

# Premium version has a different shared secret
ENV HMDM_VARIANT=os
ENV SHARED_SECRET=changeme-C3z9vi54

ENV HMDM_URL=https://h-mdm.com/files/hmdm-${VERSION}-${HMDM_VARIANT}.war

# Available values: en, ru (en by default)
ENV INSTALL_LANGUAGE=en

RUN apt update \
    && apt full-upgrade -y \
	&& apt install -y aapt wget sed postgresql-client \
	&& rm -rf /var/lib/apt/lists/* \
 	&& mkdir -p /usr/local/tomcat/conf/Catalina/localhost /usr/local/tomcat/ssl

ENV SQL_HOST=localhost
ENV SQL_PORT=5432
ENV SQL_BASE=hmdm
ENV SQL_USER=hmdm
ENV SQL_PASS=Ch@nGeMe

ENV PROTOCOL=https

# Comment it to use custom certificates
ENV HTTPS_LETSENCRYPT=true
# Mount the custom certificate path if custom certificates must be used
# ENV_HTTPS_CERT_PATH is the path to certificates and keys inside the container
#ENV HTTPS_CERT_PATH=/cert
ENV HTTPS_CERT=cert.pem
ENV HTTPS_FULLCHAIN=fullchain.pem
ENV HTTPS_PRIVKEY=privkey.pem

EXPOSE 8080/tcp 8443/tcp 31000/tcp

COPY docker-entrypoint.sh /
COPY tomcat_conf/server.xml /usr/local/tomcat/conf/server.xml 
ADD templates /opt/hmdm/templates/

ENTRYPOINT ["/docker-entrypoint.sh"]
