#FROM ubuntu:18.04
FROM nvidia/cuda:10.0-devel

MAINTAINER "Peter Salanki <peter@atlanticcrypto.com>"

RUN \
	apt-get update \
	&& apt-get install -y wget \
	unzip \
	tar \
	curl \
	bzip2 \
	libfreetype6 \
	libgl1-mesa-dev \
	libglu1-mesa \
	libxi6 \
	libxrender1 \
	gcc \
        make \
        cmake \
        g++  \
        sudo

RUN mkdir -p /source
ADD ./ /source

RUN mkdir -p /build

WORKDIR /build

ENV TERM=xterm

RUN /source/build_files/build_environment/install_deps.sh

RUN cmake  -D WITH_CODEC_SNDFILE=OFF \
  -D PYTHON_VERSION=3.7 \
  -D WITH_OPENCOLORIO=ON \
  -D OPENCOLORIO_ROOT_DIR=/opt/lib/ocio \
  -D WITH_OPENIMAGEIO=ON \
  -D OPENIMAGEIO_ROOT_DIR=/opt/lib/oiio \
  -D WITH_CYCLES_OSL=ON \
  -D WITH_LLVM=ON \
  -D LLVM_VERSION=6.0 \
  -D OSL_ROOT_DIR=/opt/lib/osl \
  -D WITH_OPENSUBDIV=ON \
  -D OPENSUBDIV_ROOT_DIR=/opt/lib/osd \
  -D WITH_OPENVDB=ON \
  -D WITH_OPENVDB_BLOSC=ON \
  -D OPENVDB_ROOT_DIR=/opt/lib/openvdb \
  -D BLOSC_ROOT_DIR=/opt/lib/blosc \
  -D WITH_ALEMBIC=ON \
  -D ALEMBIC_ROOT_DIR=/opt/lib/alembic \
  -D WITH_CODEC_FFMPEG=ON \
  -D WITH_CYCLES_CUDA_BINARIES=YES \
  -D FFMPEG_LIBRARIES='avformat;avcodec;avutil;avdevice;swscale;swresample;lzma;rt;theora;theoradec;theoraenc;vorbis;vorbisenc;vorbisfile;ogg;x264;openjp2' \
  -D WITH_STATIC_LIBS=ON \
  /source

RUN make -j16

RUN make install

RUN     apt-get -y autoremove \
        && rm -rf /var/lib/apt/lists/*

RUN mv /build/bin/ /blender

RUN rm -r /build /source

	
