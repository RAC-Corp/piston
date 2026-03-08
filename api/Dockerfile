FROM buildpack-deps:noble AS isolate
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends git libcap-dev ca-certificates build-essential && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/envicutor/isolate.git /tmp/isolate && \
    cd /tmp/isolate && \
    git checkout af6db68042c3aa0ded80787fbb78bc0846ea2114 && \
    make -j"$(nproc)" install && \
    rm -rf /tmp/isolate

FROM ubuntu:noble
ENV DEBIAN_FRONTEND=noninteractive

RUN dpkg-reconfigure -p critical dash || true

RUN apt-get update && apt-get install -y ca-certificates curl gnupg && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    NODE_MAJOR=20 && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" > /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      libxml2 gnupg tar coreutils util-linux libc6-dev \
      binutils build-essential locales libpcre3-dev libevent-dev libgmp-dev \
      libncurses6 libedit-dev libseccomp-dev rename procps python3 \
      libreadline-dev libblas-dev liblapack-dev libarpack2-dev \
      libfftw3-dev libglpk-dev libqhull-dev libqrupdate-dev libsuitesparse-dev \
      libsundials-dev libpcre2-dev libcap-dev ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -M piston

COPY --from=isolate /usr/local/bin/isolate /usr/local/bin/
COPY --from=isolate /usr/local/etc/isolate /usr/local/etc/isolate

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

WORKDIR /piston_api

COPY ["package.json", "package-lock.json", "./"]
RUN npm ci

COPY ./src ./src

CMD ["/piston_api/src/docker-entrypoint.sh"]
EXPOSE 2000/tcp