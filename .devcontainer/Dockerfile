FROM nestybox/ubuntu-jammy-systemd-docker
ARG WORKSPACE_DIR=/workspaces

USER root

COPY coder-agent.service /etc/systemd/system/coder-agent.service
COPY merge-env.sh /usr/local/bin/merge-env.sh
COPY override.conf /etc/systemd/system/redis-server.service.d/override.conf

ENV GO_VERSION=1.23.2
ENV GOPATH=/go
ENV PATH=/usr/local/go/bin:$GOPATH/bin:/usr/local/rvm/rubies/ruby-3.3.6/bin:$PATH
ENV DEBIAN_FRONTEND=noninteractive
ENV PGDATABASE=postgres
ENV GOPRIVATE=github.com/Shuttlerock
ENV DYNO=potato
ENV RAILS_ENV=test
ENV PROTOC_DISABLE_DOCKER=true
ENV DATABASE_NAME=order
ENV DATABASE_USER=root
ENV DATABASE_HOST=/var/run/postgresql
ENV APOLLO_ELV2_LICENSE=accept

# Software packages - i.e. big layer
RUN ln -fs /usr/share/zoneinfo/Pacific/Auckland /etc/localtime &&                                                 \
    echo "tzdata tzdata/Areas select Pacific" | debconf-set-selections &&                                         \
    echo "tzdata tzdata/Zones/Pacific select Auckland" | debconf-set-selections &&                                \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - &&                                                  \
                                                                                                                  \
    apt-get update -y && apt-get install -y                                                                       \
    build-essential                                                                                               \
    containerd.io=1.6.33-1                                                                                        \
    curl                                                                                                          \
    dnsutils                                                                                                      \
    git                                                                                                           \
    git-lfs                                                                                                       \
    gnupg2                                                                                                        \
    iputils-ping                                                                                                  \
    libimage-exiftool-perl                                                                                        \
    libpq-dev                                                                                                     \
    netcat-openbsd                                                                                                \
    nodejs=20.17.*                                                                                                \
    pipx                                                                                                          \
    postgresql                                                                                                    \
    protobuf-compiler                                                                                             \
    redis-server                                                                                                  \
    shared-mime-info                                                                                              \
    tar                                                                                                           \
    tcptraceroute                                                                                                 \
    traceroute                                                                                                    \
    unzip &&                                                                                                      \
                                                                                                                  \
    pipx install poetry && pipx ensurepath &&                                                                     \
                                                                                                                  \
    npm install -g yarn pnpm &&                                                                                   \
                                                                                                                  \
    curl -sSL "https://rover.apollo.dev/nix/latest" | sh &&                                                       \
    /root/.rover/bin/rover install --plugin router@=1.58.1 &&                                                     \
    /root/.rover/bin/rover install --plugin supergraph@=2.9.3 &&                                                  \
                                                                                                                  \
    curl -OL https://github.com/protocolbuffers/protobuf/releases/download/v28.0/protoc-28.0-linux-x86_64.zip &&  \
    unzip -o protoc-28.0-linux-x86_64.zip -d /usr &&                                                              \
    rm protoc-28.0-linux-x86_64.zip &&                                                                            \
                                                                                                                  \
    curl -LO https://golang.org/dl/go$GO_VERSION.linux-amd64.tar.gz &&                                            \
    tar -C /usr/local -xzf go$GO_VERSION.linux-amd64.tar.gz &&                                                    \
    rm go$GO_VERSION.linux-amd64.tar.gz &&                                                                        \
    mkdir -p $GOPATH/src $GOPATH/bin &&                                                                           \
    go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.36.0 &&                                            \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.5.1 &&                                            \
                                                                                                                  \
    curl -sSL https://rvm.io/mpapis.asc | gpg --import - &&                                                       \
    curl -sSL https://rvm.io/pkuczynski.asc | gpg --import - &&                                                   \
    curl -sSL https://get.rvm.io | bash -s stable &&                                                              \
    /bin/bash -l -c "rvm install 3.3.6" &&                                                                        \
    /bin/bash -l -c "rvm use 3.3.6 --default"

RUN mkdir -p ~/.ssh &&                                                                                  \
    ssh-keyscan github.com >> ~/.ssh/known_hosts &&                                                     \
                                                                                                        \
    systemctl disable systemd-binfmt.service &&                                                         \
                                                                                                        \
    echo "local   all             root                                    trust" >>                     \
      /etc/postgresql/14/main/pg_hba.conf &&                                                            \
    sed -i "s|^#*external_pid_file = .*|external_pid_file = '/run/postgresql/14-main.pid'|"             \
      /etc/postgresql/14/main/postgresql.conf &&                                                        \
    sed -i "s|^#*data_directory = .*|data_directory = '${WORKSPARE_DIR}/postgres-data'|"                \
      /etc/postgresql/14/main/postgresql.conf &&                                                        \
                                                                                                        \
    sed -i "s|^dir .*|dir ${WORKSPARE_DIR}/redis-data|" /etc/redis/redis.conf &&                        \
    sed -i "s|^pidfile .*|pidfile /run/redis/redis-server.pid|" /etc/redis/redis.conf &&                \
                                                                                                        \
    systemctl enable coder-agent.service &&                                                             \
    touch /etc/coder/coder-agent.conf &&                                                                \
                                                                                                        \
    sed -i "s|/workspaces|${WORKSPACE_DIR}|g" /etc/systemd/system/redis-server.service.d/override.conf
