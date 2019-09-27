#! /bin/bash

THIS_SCRIPT_DIR_ABSOLUTE=${PWD}

sudo apt-get install -y git cmake make automake vim gcc g++

mkdir ~/P4
cd ~/P4

#installing openssl

#wget https://www.openssl.org/source/openssl-1.0.2t.tar.gz
#sudo apt-get remove -y openssl

#tar -xf openssl-1.0.2t.tar.gz
#cd ./openssl-1.0.2t

#./config shared
#make -j$1

#sudo make install
#sudo ldconfig

#cd ..

#installing requed packages 

sudo apt-get install -y cmake g++ git automake libtool libgc-dev bison flex libfl-dev libgmp-dev libboost-dev libboost-iostreams-dev libboost-graph-dev llvm pkg-config python python-scapy python-ipaddr python-ply tcpdump python-dev python3-dev


#installing thrift

git clone https://github.com/apache/thrift
cd ./thrift

./bootstrap.sh
./configure

make -j$1
sudo make install
sudo ldconfig

cd ..

#installing grpc

git clone https://github.com/google/grpc
cd ./grpc
git checkout tags/v1.3.2

PATCH_DIR="${THIS_SCRIPT_DIR_ABSOLUTE}/grpc-v1.3.2-patches-for-ubuntu18.04"


for PATCH_FILE in no-werror.diff unvendor-zlib.diff fix-libgrpc++-soname.diff make-pkg-config-files-nonexecutable.diff add-wrap-memcpy-flags.diff
do
    patch -p1 < "${PATCH_DIR}/${PATCH_FILE}"
done


git submodule update --init --recursive

sudo apt-get install curl

make -j$1
sudo make install
sudo ldconfig

cd ..

#installing nanomsg

git clone https://github.com/nanomsg/nanomsg
cd ./nanomsg

mkdir build
cd ./build

cmake ..
make -j$1
sudo make install
sudo ldconfig

cd ..
cd ..

#installing protobuf
git clone https://github.com/google/protobuf
cd ./protobuf
git submodule update --init --recursive

./autogen.sh
./configure

make -j$1
sudo make install
sudo ldconfig

cd ..

#installing some boost libs
sudo apt-get install -y libjudy-dev libpcap-dev libboost-thread-dev libboost-program-options-dev libboost-filesystem-dev





#installing libyang
sudo apt-get install -y libavl-dev libev-dev

git clone https://github.com/CESNET/libyang
cd ./libyang

mkdir build
cd ./build

cmake ..
make -j$1
sudo make install
sudo ldconfig

cd ..
cd ..

#installing sysrepo
sudo apt-get install -y swig doxygen protobuf-compiler protobuf-c-compiler libprotobuf-c-dev

git clone https://github.com/sysrepo/sysrepo
cd sysrepo

mkdir build
cd ./build

cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_EXAMPLES=Off -DCALL_TARGET_BINS_DIRECTLY=Off ..
make -j$1
sudo make install
sudo ldconfig

cd ..
cd ..

#installing PI (without behavioral-model)

git clone https://github.com/p4lang/PI
cd ./PI
git submodule update --init --recursive

./autogen.sh
./configure --with-proto --without-internal-rpc --without-cli --without-bmv2 --with-sysrepo

make -j$1
sudo make install
sudo ldcondig

cd ..

#installing behavioral-model
git clone https://github.com/p4lang/behavioral-model

cd behavioral-model
# Get latest updates that are not in the repo cache version
git pull
git log -n 1
# This command installs Thrift, which I want to include in my build of
# simple_switch_grpc
./install_deps.sh
# simple_switch_grpc README.md says to configure and build the bmv2
# code first, using these commands:
./autogen.sh
# Remove 'CXXFLAGS ...' part to disable debug
./configure --with-pi 'CXXFLAGS=-O0 -g'
make -j$1
sudo make install
# Now build simple_switch_grpc
cd targets/simple_switch_grpc
./autogen.sh
# Remove 'CXXFLAGS ...' part to disable debug
./configure --with-sysrepo --with-thrift 'CXXFLAGS=-O0 -g'
# I saw the following near end of output of 'configure' command:
#Features recap ......................
#With Sysrepo .................. : yes
#With Thrift ................... : yes
make -j$1
sudo make install
sudo ldconfig

echo "end install behavioral-model:"
date

#git clone https://github.com/p4lang/behavioral-model
#cd ./behavioral-model

#./autogen.sh
#./configure --with-pi
#make -j$1
#sudo make install
#sudo ldconfig



#installing simple_switch_grpc

#cd targets/simple_switch_grpc/
#./autogen.sh
#./configure --with-thrift --with-sysrepo

#mv ~/p4_system_init/switch_runner.h ./
#make -j$1
#sudo make install
#sudo ldconfig

cd ~/P4

#installing p4c

git clone https://github.com/p4lang/p4c
cd ./p4c
git submodule update --init --recursive

mkdir build
cd ./build

cmake ..
make -j$1
sudo make install
sudo ldconfig

cd ..
cd ..

#installing requed packages 

sudo apt-get install -y mininet python-pip

#some tutorials

git clone https://github.com/p4lang/tutorials
cd tutorials
