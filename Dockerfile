FROM lsiobase/ubuntu:bionic

# set version label
ARG BUILD_DATE
ARG VERSION
ARG CODE_RELEASE
LABEL build_version="Codeclub Server:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="Leigh"

# environment settings
ENV HOME="/config"

ENV NVM_VERSION v0.35.2
ENV NODE_VERSION --lts

RUN \
 apt-get update && \
 apt-get install -y -q --no-install-recommends\
	git \
<<<<<<< HEAD
	curl \
	build-essential \
=======
	jq \
>>>>>>> a9346cfc98dc9cbf431b25d385a867868c545c02
	nano \
	net-tools \
	python3 \
	python3-pip \
	htop \
	libssl-dev \
	sudo && \
 echo "**** install code-server ****" && \
 if [ -z ${CODE_RELEASE+x} ]; then \
	CODE_RELEASE=$(curl -sX GET "https://api.github.com/repos/cdr/code-server/releases/latest" \
	| awk '/tag_name/{print $4;exit}' FS='[""]'); \
 fi && \
 CODE_URL=$(curl -sX GET "https://api.github.com/repos/cdr/code-server/releases/tags/${CODE_RELEASE}" \
	| jq -r '.assets[] | select(.browser_download_url | contains("linux-x86_64")) | .browser_download_url') && \
 curl -o \
<<<<<<< HEAD
 /tmp/code.tar.gz -L \
	"https://github.com/cdr/code-server/releases/download/2.1698/code-server2.1698-vsc1.41.1-linux-arm64.tar.gz" && \
=======
	/tmp/code.tar.gz -L \
	"${CODE_URL}" && \
>>>>>>> a9346cfc98dc9cbf431b25d385a867868c545c02
 tar xzf /tmp/code.tar.gz -C \
	/usr/bin/ --strip-components=1 \
	--wildcards code-server*/code-server && \
 echo "**** clean up ****" && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/* && \
 rm /bin/sh && ln -s /bin/bash /bin/sh
 
# Replace shell with bash so we can source files
#RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install NVM
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/${NVM_VERSION}/install.sh | bash

# Install NODE
RUN source ~/.nvm/nvm.sh; \
    nvm install $NODE_VERSION; \
    nvm use --delete-prefix $NODE_VERSION;

# add local files
COPY /root /

# ports and volumes
EXPOSE 8443


#"https://github.com/cdr/code-server/releases/download/${CODE_RELEASE}/code-server${CODE_RELEASE}-linux-arm64.tar.gz" 