ARG  BASE_IMAGE=ubuntu:xenial
FROM ${BASE_IMAGE}
LABEL maintainer="Jean-Avit Promis docker@katagena.com"

ARG ECLIPSE_OOMPH_INSTALLER_TAR_URL=http://ftp-stud.fht-esslingen.de/pub/Mirrors/eclipse/oomph/products/eclipse-inst-linux64.tar.gz
ENV ECLIPSE_OOMPH_INSTALLER_DIRECTORY=/opt
ARG PUID=1000
ARG PGID=1000
ARG BASE_IMAGE=ubuntu:xenial
ARG DOCKER_TAG=php7
ARG JDK_VERSION=8
ARG PHP_VERSION=7.0
LABEL version="${DOCKER_TAG}"

ENV PUID ${PUID}
ENV PGID ${PGID}
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

COPY launch.sh /launch.sh
COPY user.setup /user.setup

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get -yq install gnupg2 wget git libcanberra-gtk3-module ssh-askpass openssh-client wmctrl locales fonts-takao-mincho && \
	[ "$PHP_VERSION" == "5" ] || DEBIAN_FRONTEND=noninteractive apt-get -yq install php${PHP_VERSION} php-cli php-xdebug php-intl php-xml && \
	[ "$PHP_VERSION" != "5" ] || apt-get -yq install php5 php5-cli php5-xdebug && \
	apt-get -yq install openjdk-${JDK_VERSION}-jdk && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	locale-gen en_US.UTF-8 && \
	wget "${ECLIPSE_OOMPH_INSTALLER_TAR_URL}" -O /tmp/eclipse-inst.tar.gz -q && \
	tar -xf /tmp/eclipse-inst.tar.gz -C ${ECLIPSE_OOMPH_INSTALLER_DIRECTORY} && \
	rm /tmp/eclipse-inst.tar.gz && \
	wget "http://get.sensiolabs.org/php-cs-fixer.phar" -O php-cs-fixer && \
	chmod a+x php-cs-fixer && \
	mv php-cs-fixer /usr/local/bin/php-cs-fixer && \
	wget -qO- https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
	php /usr/local/bin/composer self-update && \
	export uid=${PUID} gid=${PGID} && \
	mkdir -p /home/developer/workspace && \
	mkdir -p /home/developer/.p2/pool/ && \
	echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
	echo "developer:x:${uid}:" >> /etc/group && \
	chmod +x /launch.sh && \
	chown developer: /launch.sh && \
	chown -R developer: /${ECLIPSE_OOMPH_INSTALLER_DIRECTORY}/ && \
	mkdir -p /home/developer/.eclipse/org.eclipse.oomph.setup/setups/ && \
	mv /user.setup /home/developer/.eclipse/org.eclipse.oomph.setup/setups/user.setup && \
	mkdir -p /home/developer/eclipse/ && \
	chown -R developer: /home/developer/ && \
	chown ${uid}:${gid} -R /home/developer

USER developer
ENV HOME /home/developer
VOLUME /home/developer/eclipse/ /opt/eclipse-installer/ /home/developer/.p2/ /home/developer/workspace/


ENTRYPOINT [ "/launch.sh" ]
