
ARG ALPINE_VERSION="3.18"
ARG NODE="v20.18.0"

###################################################
# Build nodejs
###################################################

FROM alpine:${ALPINE_VERSION} as build-node

ARG NODE

RUN apk add --update --no-cache \
	build-base \
	python3 \
	curl \
	libuv \
	sqlite-dev \
	cargo \
	rust \
	pkgconfig \
	icu-dev \
	linux-headers

# Add ARMv7 cross-compilation support
RUN apk add --update --no-cache \
    armv7-linux-musleabihf-gcc \
    armv7-linux-musleabihf-g++ \
    armv7-linux-musleabihf-pkgconf \
    armv7-linux-musleabihf-cmake

# Build nodejs from source
RUN wget -O - https://nodejs.org/dist/${NODE}/node-${NODE}.tar.gz | tar -xz && \
	cd node-$NODE && \
	./configure --prefix=/usr/local --enable-lto --openssl-use-def-ca-store --with-intl=none --without-inspector --dest-cpu=arm --dest-os=linux --with-arm-float-abi=hard && \
	make -j$(nproc) && \
	make install