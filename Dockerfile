FROM ubuntu:14.04.2

MAINTAINER atsushi <atsushi@ageet.com>
WORKDIR /opt/workspace

RUN apt-get update && apt-get install -y wget unzip build-essential && rm -rf /var/lib/apt/lists/*

ARG NDK_VERSION=r11b
ARG PLATFORM=android-14
ARG ARCHS="arm x86"
ADD make-toolchain.sh /opt/workspace
RUN chmod a+x make-toolchain.sh

RUN wget -O tmp.zip http://dl.google.com/android/repository/android-ndk-${NDK_VERSION}-linux-x86_64.zip && unzip tmp.zip && rm tmp.zip && \
ANDROID_NDK_DIR=android-ndk-${NDK_VERSION} ANDROID_NDK_TOOLCHAIN=toolchain PLATFORM=$PLATFORM ARCHS=$ARCHS ./make-toolchain.sh && \
rm -rf android-ndk-${NDK_VERSION}
