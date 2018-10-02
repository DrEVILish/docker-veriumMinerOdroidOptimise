FROM        ubuntu:latest
MAINTAINER  drevilish

RUN         apt update && \
            apt install -y git automake autoconf pkg-config libcurl4-openssl-dev libjansson-dev libssl-dev libgmp-dev libxmu-dev libxmu-headers freeglut3-dev libxext-dev libxi-dev zlib1g-dev

RUN         mkdir /verium

RUN         git clone https://github.com/effectsToCause/veriumMiner /verium/1wayminer && \
            sed -i -e 's/#define SCRYPT_MAX_WAYS 3/#define SCRYPT_MAX_WAYS 1/g' /verium/1wayminer/algo/scrypt.c && \
            sed -i -e 's/#define HAVE_SCRYPT_3WAY 1/\/\/#define HAVE_SCRYPT_3WAY 1/g' /verium/1wayminer/algo/scrypt.c && \
            sed -i -e 's/#define scrypt_best_throughput() 3/#define scrypt_best_throughput() 1/g' /verium/1wayminer/algo/scrypt.c && \
            sed -i -e 's/void scrypt_core_3way/void scrypt_core /g' /verium/1wayminer/algo/scrypt.c && \
            sed -i -e 's/-DUSE_ASM -pg/-DUSE_ASM -mfpu=neon -pg/g' /verium/1wayminer/build.sh
RUN         cd /verium/1wayminer && \
            ./build.sh

RUN         git clone https://github.com/effectsToCause/veriumMiner /verium/3wayminer && \
            sed -i -e 's/-DUSE_ASM -pg/-DUSE_ASM -mfpu=neon -pg/g' /verium/3wayminer/build.sh
RUN         cd /verium/3wayminer && \
            ./build.sh


COPY        init.sh /init.sh
RUN         chmod +x /init.sh
WORKDIR     /verium
