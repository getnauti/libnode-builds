ARG NODE_VERSION=v24.9.0
ARG TARGET_OS=linux
ARG TARGET_ARCH=x64
ARG TARGET_LIBC=gnu

FROM debian:trixie

ARG NODE_VERSION
ARG TARGET_OS
ARG TARGET_ARCH
ARG TARGET_LIBC

ENV DEBIAN_FRONTEND=noninteractive \
    NODE_VERSION=${NODE_VERSION} \
    TARGET_OS=${TARGET_OS} \
    TARGET_ARCH=${TARGET_ARCH} \
    TARGET_LIBC=${TARGET_LIBC}

# COPY scripts/ /tmp/scripts/
# RUN chmod +x /tmp/scripts/*.sh

# RUN /tmp/scripts/install-deps.sh

RUN apt-get update
RUN apt-get install -y \
    build-essential \
    clang \
    python3 \
    git \
    curl \
    ca-certificates \
    ccache \
    pkg-config \
    ninja-build \
    nasm \
    libtool \
    autoconf \
    automake \
    libssl-dev \
    zlib1g-dev \
    libuv1-dev \
    libnghttp2-dev \
    libbrotli-dev \
    libc-ares-dev \
    libicu-dev

WORKDIR /usr/src

RUN git clone --depth 1 --branch ${NODE_VERSION} https://github.com/nodejs/node.git node

WORKDIR /usr/src/node

ENV CC=clang
ENV CXX=clang++
ENV AR=llvm-ar
ENV NM=llvm-nm
ENV OBJCOPY=llvm-objcopy
ENV OBJDUMP=llvm-objdump
ENV STRIP=llvm-strip

RUN ./configure
RUN make -j$(nproc)

# RUN /tmp/scripts/build-node.sh

# ENV NODE_SOURCE_DIR=/usr/src/node \
#     PATH="/usr/src/node/out/Release:${PATH}"

# LABEL org.opencontainers.image.title="Node.js Build Cache" \
#       org.opencontainers.image.description="Node.js ${NODE_VERSION} build cache for ${TARGET_OS}-${TARGET_ARCH}-${TARGET_LIBC}" \
#       nodejs.version=${NODE_VERSION} \
#       nodejs.target=${TARGET_OS}-${TARGET_ARCH}-${TARGET_LIBC}

WORKDIR /usr/src/node
CMD ["/bin/bash"]
