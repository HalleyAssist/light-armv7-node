ARG NODE="v20.18.0"

# Use an ARMv7 base image
FROM arm32v7/alpine:3.18

ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM"
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

# Build nodejs from source
RUN wget -O - https://nodejs.org/dist/${NODE}/node-${NODE}.tar.gz | tar -xz && \
	cd node-$NODE && \
	./configure --prefix=/usr/local --enable-lto --openssl-use-def-ca-store --with-intl=none --without-inspector && \
	make -j$(nproc) && \
	make install
