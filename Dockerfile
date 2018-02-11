FROM nouchka/eclipse:oxygen

ARG ECLIPSE_OOMPH_INSTALLER_TAR_URL=http://ftp-stud.fht-esslingen.de/pub/Mirrors/eclipse/oomph/products/eclipse-inst-linux64.tar.gz
ENV ECLIPSE_OOMPH_INSTALLER_DIRECTORY=/opt

USER root
RUN wget ${ECLIPSE_OOMPH_INSTALLER_TAR_URL} -O /tmp/eclipse-inst.tar.gz -q && \
	tar -xf /tmp/eclipse-inst.tar.gz -C ${ECLIPSE_OOMPH_INSTALLER_DIRECTORY} && \
	rm /tmp/eclipse-inst.tar.gz

RUN mkdir -p /home/developer/.p2/pool/
RUN mkdir -p /home/developer/.eclipse/org.eclipse.oomph.setup/setups/
RUN mkdir -p /home/developer/.eclipse/org.eclipse.oomph.p2/

##RUN echo "/home/developer/.p2/pool" > /home/developer/.p2/pools.info
COPY setup/Katagena.setup /home/developer/.p2/pool/Katagena.setup
COPY user.setup /home/developer/.eclipse/org.eclipse.oomph.setup/setups/user.setup
COPY user.products.setup /home/developer/.eclipse/org.eclipse.oomph.setup/setups/user.products.setup
COPY agents.info /home/developer/.eclipse/org.eclipse.oomph.p2/agents.info
COPY defaults.info /home/developer/.eclipse/org.eclipse.oomph.p2/defaults.info

RUN chown -R developer: /home/developer/

USER developer

## Make update permanent
## VOLUME ${ECLIPSE_OOMPH_INSTALLER_DIRECTORY}/eclipse-inst

