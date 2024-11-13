
ARG ALPINE_VERSION="3.18"
ARG NODE="v20.18.0"

FROM --platform=$BUILDPLATFORM tonistiigi/xx AS xx

###################################################
# Build nodejs
###################################################

FROM --platform=$BUILDPLATFORM alpine AS xbuild

COPY --from=xx / /

ARG TARGETPLATFORM
ARG NODE

RUN apk add --update curl cargo \
    rust \
	pkgconfig \
	python3 \
    busybox \
	build-base

RUN xx-apk add  --no-scripts --update \
    musl-dev zlib-dev gcc  \
	libuv-dev \
	sqlite-dev \
	icu-dev \
	linux-headers

RUN xx-info env

# Build nodejs from source
RUN wget -O - https://nodejs.org/dist/${NODE}/node-${NODE}.tar.gz | tar -xz && \
	cd node-$NODE && \
    export CC="/usr/bin/armv7-alpine-linux-musleabihf-gcc" && \
    export CXX="/usr/bin/armv7-alpine-linux-musleabihf-g++" && \
    export AR="/usr/bin/armv7-alpine-linux-musleabihf-ar" && \
    export RANLIB="/usr/bin/armv7-alpine-linux-musleabihf-ranlib" && \
    export LD="/usr/bin/armv7-alpine-linux-musleabihf-ld" && \
    export STRIP="/usr/bin/armv7-alpine-linux-musleabihf-strip" && \
    export CFLAGS="$CFLAGS -march=armv7-a+vfpv4 -mfloat-abi=hard" && \
    export CXXFLAGS="$CXXFLAGS -march=armv7-a+vfpv4 -mfloat-abi=hard" && \
	./configure --prefix=/usr/local --enable-lto --openssl-use-def-ca-store --with-intl=none --without-inspector --cross-compiling --dest-os=linux --dest-cpu=arm --with-arm-float-abi=hard --with-arm-fpu=vfpv3&& \
	make -j$(nproc) && \
	make install