FROM debian:9

ENV OTP_VERSION="20.2" \
    CLOUDI_VERSION=1.7.2 \
    BINDIR=/usr/local/lib/erlang/erts-9.2/bin/ \
    TERM=xterm \
    REBAR_VERSION="2.6.4"

## DEBIAN PACKAGES
RUN set -ex; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		autoconf \
    apt-utils \
    dpkg-dev \
		automake \
		file \
		g++ \
		gcc \
    ca-certificates \
		libc6-dev \
		libncurses5-dev \
		libreadline-dev \
		libssl-dev \
		libtool \
    nodejs \
    php \
    perl \
    ruby1.9.1 \
    default-jdk \
		libgmp-dev \
		make \
    sed \
    wget \
    curl \
    gzip \
    libboost-dev \
    libboost-system-dev \
    libboost-thread-dev \
    python3 \
    python3-dev \
    uuid-dev ;

## ERLANG
RUN set -xe \
	&& export OTP_DOWNLOAD_URL="https://github.com/erlang/otp/archive/OTP-${OTP_VERSION}.tar.gz" \
	&& export OTP_DOWNLOAD_SHA256="32c05e0fccc0a83f03266c05ced0294eb2da70ad8657718a1a917686c7b76aae" \
	&& apt-get update \
	&& curl -fSL -o otp-src.tar.gz "$OTP_DOWNLOAD_URL" \
	&& echo "$OTP_DOWNLOAD_SHA256  otp-src.tar.gz" | sha256sum -c - \
	&& export ERL_TOP="/usr/src/otp_src_${OTP_VERSION%%@*}" \
	&& mkdir -vp $ERL_TOP \
	&& tar -xzf otp-src.tar.gz -C $ERL_TOP --strip-components=1 \
	&& rm otp-src.tar.gz \
	&& ( cd $ERL_TOP \
	  && ./otp_build autoconf \
	  && gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
	  && ./configure --build="$gnuArch" \
	  && make -j$(nproc) \
	  && make install ) \
	&& find /usr/local -name examples | xargs rm -rf \
	&& apt-get purge -y \
	&& rm -rf $ERL_TOP /var/lib/apt/lists/*

## REBAR AND REBAR3
ENV REBAR_VERSION="2.6.4"

RUN set -xe \
	&& REBAR_DOWNLOAD_URL="https://github.com/rebar/rebar/archive/${REBAR_VERSION}.tar.gz" \
	&& REBAR_DOWNLOAD_SHA256="577246bafa2eb2b2c3f1d0c157408650446884555bf87901508ce71d5cc0bd07" \
	&& mkdir -p /usr/src/rebar-src \
	&& curl -fSL -o rebar-src.tar.gz "$REBAR_DOWNLOAD_URL" \
	&& echo "$REBAR_DOWNLOAD_SHA256 rebar-src.tar.gz" | sha256sum -c - \
	&& tar -xzf rebar-src.tar.gz -C /usr/src/rebar-src --strip-components=1 \
	&& rm rebar-src.tar.gz \
	&& cd /usr/src/rebar-src \
	&& ./bootstrap \
	&& install -v ./rebar /usr/local/bin/ \
	&& rm -rf /usr/src/rebar-src

ENV REBAR3_VERSION="3.4.6"

RUN set -xe \
	&& REBAR3_DOWNLOAD_URL="https://github.com/erlang/rebar3/archive/${REBAR3_VERSION}.tar.gz" \
	&& REBAR3_DOWNLOAD_SHA256="20e1bfc603b42171c10e0882eb75782c1ecd7f4361fdaea28adb2a97381a2523" \
	&& mkdir -p /usr/src/rebar3-src \
	&& curl -fSL -o rebar3-src.tar.gz "$REBAR3_DOWNLOAD_URL" \
	&& echo "$REBAR3_DOWNLOAD_SHA256 rebar3-src.tar.gz" | sha256sum -c - \
	&& tar -xzf rebar3-src.tar.gz -C /usr/src/rebar3-src --strip-components=1 \
	&& rm rebar3-src.tar.gz \
	&& cd /usr/src/rebar3-src \
	&& HOME=$PWD ./bootstrap \
	&& install -v ./rebar3 /usr/local/bin/ \
  && rm -rf /usr/src/rebar3-src


## CLOUDI
ADD tmp/cloudi/ /opt/

RUN cd /opt/cloudi*/src && \
    ./configure && make && make install

RUN rm -rf /opt/cloudi*

ADD vm.args /opt/vm.args
ADD entrypoint /opt/entrypoint
RUN cp /opt/vm.args /usr/local/lib/cloudi-${CLOUDI_VERSION}/etc/vm.args

EXPOSE 6464
EXPOSE 4369
EXPOSE 4374

ENTRYPOINT ["/opt/entrypoint"]
