FROM nvidia/cuda:8.0-devel-ubuntu16.04
MAINTAINER Alex Suslov
WORKDIR /

RUN apt-get update \
    && apt-get -y install software-properties-common \
    && add-apt-repository -y ppa:ethereum/ethereum -y \
    && apt-get update \
    && apt-get install -y git \
     cmake \
     libcryptopp-dev \
     libleveldb-dev \
     libjsoncpp-dev \
     libjsonrpccpp-dev \
     libboost-all-dev \
     libgmp-dev \
     libreadline-dev \
     libcurl4-gnutls-dev \
     ocl-icd-libopencl1 \
     opencl-headers \
     mesa-common-dev \
          libmicrohttpd-dev \
          build-essential
     
RUN git clone https://github.com/ethereum-mining/ethminer.git\
         && cd ethminer \
         && mkdir build \
         && cd build \
         && cmake -DBUNDLE=cudaminer -DETHASHCUDA=ON .. \
         && cmake --build .
     
ENV GPU_FORCE_64BIT_PTR=0
ENV GPU_MAX_HEAP_SIZE=100
ENV GPU_USE_SYNC_OBJECTS=1
ENV GPU_MAX_ALLOC_PERCENT=100
ENV GPU_SINGLE_ALLOC_PERCENT=100
     
COPY *.sh /

CMD ["ethminer/build/ethminer/ethminer", "--farm-recheck", "5000", "-U", "-F"]
