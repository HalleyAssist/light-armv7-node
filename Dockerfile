# Use an ARMv7 base image
FROM --platform=$BUILDPLATFORM alpine:3.18

ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM"

