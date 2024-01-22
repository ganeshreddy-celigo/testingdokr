FROM node:18.12.1-alpine

ENV NODE_VERSION=18.12.1
ENV NPM_VERSION=8.19.1
# Install npm
RUN ver=$(echo $NODE_VERSION | awk '{print int($NF)}') && \
    if [ "$ver" -lt "16" ]; then \
    npm install npm@${NPM_VERSION} && \
    rm -rf /usr/local/lib/node_modules/npm && \
    mv node_modules/npm /usr/local/lib/node_modules/npm; \
    elif [ "$ver" -lt "19" ]; then \
    npm install -g npm@${NPM_VERSION}; \
    fi

# Updating packages
RUN ver=$(echo $NODE_VERSION | awk '{print int($NF)}') && \
    if [ "$ver" -lt "17" ]; then \
    apk add busybox zlib libretls && \
    apk upgrade busybox zlib libretls; \
    fi

RUN apk add curl

# Install git, openjdk, g++, jq
RUN apk add make g++ git jq

# Install Python3 & awscli
RUN apk add --update --no-cache python3 && \
    python3 -m ensurepip && \
    pip3 install --upgrade pip && \
    pip3 install awscli && \
    pip3 cache purge

# Install bash
RUN apk add --no-cache bash

# Install JAVA
RUN apk --no-cache add openjdk17 --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community

# Install openssh libaio
RUN apk add --no-cache openssh libaio

# Install docker
RUN apk add --no-cache docker

RUN apk add --update redis openssl

ENV JAVA_HOME=/usr/lib/jvm/default-jvm

ENV PATH=$PATH:$JAVA_HOME/bin


WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Start your application
#CMD ["npm", "start"]
