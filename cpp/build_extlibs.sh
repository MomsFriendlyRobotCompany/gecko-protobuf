#!/bin/bash

rm -fr tmp
mkdir -p tmp
cd tmp

DIR="/opt/gecko"


get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

# protobuf --------------------------------------------------------------
USER_REPO="protocolbuffers/protobuf"
VER=`get_latest_release ${USER_REPO}`
echo "latest is ${VER}"

git clone -b ${VER} https://github.com/protocolbuffers/protobuf.git
mkdir -p protobuf/buildpb
cd protobuf/buildpb
git submodule update --init --recursive
cmake -DCMAKE_INSTALL_PREFIX=${DIR} \
    -DBUILD_SHARED_LIBS=OFF \
    -Dprotobuf_BUILD_TESTS=OFF \
    -Dprotobuf_BUILD_EXAMPLES=OFF \
    -Dprotobuf_WITH_ZLIB=ON \
    ../cmake
# make
# make install
cd ../..

cd ..
