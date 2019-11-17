#!/bin/bash

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
VERSION=${VER//v}
HTTP="https://github.com/${USER_REPO}/releases/download/${VER}/protobuf-cpp-${VERSION}.tar.gz"
echo "latest is ${VERSION}"
echo "path is ${HTTP}"

wget ${HTTP}
tar -zxvf protobuf-cpp-${VERSION}.tar.gz
mkdir -p protobuf-${VERSION}/build
cd protobuf-${VERSION}/build
# ./configure --prefix=${DIR} --with-cmake
cmake -DCMAKE_INSTALL_PREFIX=${DIR} -DBUILD_SHARED_LIBS=ON -Dprotobuf_BUILD_TESTS=OFF ../cmake
make
make install
cd ../..

cd ..
# rm -fr tmp
