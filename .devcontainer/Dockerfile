FROM nestybox/ubuntu-jammy-systemd-docker

RUN ln -fs /usr/share/zoneinfo/Pacific/Auckland /etc/localtime &&                   \
    echo "tzdata tzdata/Areas select Pacific" | debconf-set-selections &&           \
    echo "tzdata tzdata/Zones/Pacific select Auckland" | debconf-set-selections &&  \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - &&                    \
    apt-get update -y && apt-get install -y                                         \
    curl                                                                            \
    tar                                                                             \
    git                                                                             \
    gnupg2                                                                          \
    libpq-dev                                                                       \
    shared-mime-info                                                                \
    build-essential                                                                 \
    netcat-openbsd                                                                  \
    dnsutils                                                                        \
    iputils-ping                                                                    \
    traceroute                                                                      \
    tcptraceroute                                                                   \
    pipx                                                                            \
    protobuf-compiler                                                               \
    unzip                                                                           \
    redis-server                                                                    \
    postgresql                                                                      \
    libimage-exiftool-perl                                                          \
    git-lfs
