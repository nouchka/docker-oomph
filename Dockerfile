FROM nouchka/eclipse:oxygen

ARG ECLIPSE_OOMPH_INSTALLER_TAR_URL=http://ftp-stud.fht-esslingen.de/pub/Mirrors/eclipse/oomph/products/eclipse-inst-linux64.tar.gz
ENV ECLIPSE_OOMPH_INSTALLER_DIRECTORY=/opt

USER root
RUN wget ${ECLIPSE_OOMPH_INSTALLER_TAR_URL} -O /tmp/eclipse-inst.tar.gz -q && \
	tar -xf /tmp/eclipse-inst.tar.gz -C ${ECLIPSE_OOMPH_INSTALLER_DIRECTORY} && \
	rm /tmp/eclipse-inst.tar.gz

USER developer
RUN mkdir -p /home/developer/.p2/pool/
RUN ls -al /home/developer/.p2/

RUN echo "/home/developer/.p2/pool" > /home/developer/.p2/pools.info
COPY Katagena.setup /home/developer/.p2/pool/Katagena.setup

## Make update permanent
## VOLUME ${ECLIPSE_OOMPH_INSTALLER_DIRECTORY}/eclipse-inst

