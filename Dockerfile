FROM debian:trixie-slim

ENV TARANTOOL_VERSION_BRANCH="release/3.6"
ENV TARANTOOL_SRC="/usr/local/src/tarantool"

RUN set -x && \
  #
  # Build tools
  #
  apt-get update && \
  apt-get install --no-install-recommends --no-install-suggests -y \
  git \
  ca-certificates \
  build-essential \
  cmake \
  autoconf \
  automake \
  libtool \
  make \
  zlib1g-dev \
  libreadline-dev \
  libncurses5-dev \
  libssl-dev \
  libunwind-dev \
  libicu-dev \
  python3 \
  python3-yaml \
  python3-six \
  python3-gevent && \
  #
  # Download sources (with GIT)
  #
  git clone \
    --branch "${TARANTOOL_VERSION_BRANCH}" \
    --recursive \
    https://github.com/tarantool/tarantool.git "${TARANTOOL_SRC}" && \
  cd "${TARANTOOL_SRC}" && \
  git submodule update --init --recursive && \
  #
  # Build tarantool
  #
  mkdir build && \
  cd build && \
  cmake .. -DCMAKE_BUILD_TYPE=RelWithDebInfo && \
  make && \
  #
  # Install
  #
  make install && \
  #
  # Cleanup
  #
  apt autoremove -y \
    git \
    ca-certificates \
    python3 \
    python3-yaml \
    python3-gevent && \
  cd "/usr/local/src/" && \
  rm -rf "${TARANTOOL_SRC}"

CMD ["tarantool"]
