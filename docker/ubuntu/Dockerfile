#-*-coding:utf-8;tab-width:4;c-basic-offset:4;indent-tabs-mode:()-*-
# ex: set fenc=utf-8 sts=4 ts=4 sw=4 et nomod:

# Set the base image to Ubuntu
FROM ubuntu:16.04

# Set the release version of CloudI
ARG CLOUDI_VERSION
ENV CLOUDI_VERSION ${CLOUDI_VERSION:-1.7.2}

# Set the release SHA256 checksum of CloudI
ARG CLOUDI_SHA256
ENV CLOUDI_SHA256 ${CLOUDI_SHA256:-5ffeddb4ddabc9611d02fe356022849d2cbb1d1557311651f3f5b42c37ba3d71}

# Set the release version of Erlang/OTP
ARG ERLANG_OTP_VERSION
ENV ERLANG_OTP_VERSION ${ERLANG_OTP_VERSION:-20.2}

# Set the release SHA256 checksum of Erlang/OTP
ARG ERLANG_OTP_SHA256
ENV ERLANG_OTP_SHA256 ${ERLANG_OTP_SHA256:-24d9895e84b800bf0145d6b3042c2f2087eb31780a4a45565206844b41eb8f23}

# Update the repository sources list and install required Ubuntu packages
RUN apt-get update && apt-get install -y \
    build-essential \
    autoconf \
    libtool \
    libncurses5-dev \
    openssl \
    libssl-dev \
    fop \
    curl \
    git \
    g++ \
    default-jdk \
    nodejs \
    perl \
    php \
    python3 \
    python3-dev \
    ruby \
    libboost-system-dev \
    libboost-thread-dev \
    libboost-dev \
    libgmp3-dev \
    uuid-dev

# Build and Install Erlang/OTP
RUN curl -fSL -o otp_src.tar.gz \
    "http://erlang.org/download/otp_src_${ERLANG_OTP_VERSION}.tar.gz" \
    && echo "${ERLANG_OTP_SHA256}  otp_src.tar.gz" | sha256sum -c - \
    && tar zxvf otp_src.tar.gz \
    && rm -f otp_src.tar.gz \
    && cd "otp_src_${ERLANG_OTP_VERSION}" \
    && export ERL_TOP=`pwd` \
    && ./otp_build autoconf \
    && ./configure --enable-threads --enable-smp-support --enable-kernel-poll \
                   --disable-hipe --enable-dirty-schedulers \
    && make \
    && make install \
    && cd .. \
    && rm -rf "otp_src_${ERLANG_OTP_VERSION}"

# Build and Install CloudI
# (vm.args needs "+B i" so the Erlang VM will ignore SIGINT)
RUN curl -fSL -o cloudi.tar.gz \
    "https://downloads.sourceforge.net/project/cloudi/${CLOUDI_VERSION}/cloudi-${CLOUDI_VERSION}.tar.gz" \
    && echo "${CLOUDI_SHA256}  cloudi.tar.gz" | sha256sum -c - \
    && tar zxvf cloudi.tar.gz \
    && rm -f cloudi.tar.gz \
    && cd "cloudi-${CLOUDI_VERSION}/src" \
    && ./configure --with-cxx-backtrace \
    && make \
    && make install \
    && cd .. \
    && rm -rf "cloudi-${CLOUDI_VERSION}" \
    && echo "+B i" >> /usr/local/etc/cloudi/vm.args

# Use a modified CloudI configuration file based on cloudi_minimal.conf
COPY conf/cloudi.conf /usr/local/etc/cloudi/cloudi.conf

# Add the entrypoint script
COPY scripts/entrypoint.sh /entrypoint.sh

# Allow the HTTP Server port for CloudI
EXPOSE 6464

# Allow the Erlang Port Mapper Daemon port
EXPOSE 4369

# Allow the distributed Erlang ports (inet_dist_listen)
EXPOSE 4374-4474

ENTRYPOINT ["/entrypoint.sh"]
