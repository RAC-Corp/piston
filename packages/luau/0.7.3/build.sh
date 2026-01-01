#!/usr/bin/env bash

# Put instructions to build your package in here
curl -R -O -L https://github.com/luau-lang/luau/archive/refs/tags/0.703.tar.gz
tar -xzf 0.703.tar.gz
rm 0.703.tar.gz

cd luau-0.703
mkdir build
cd build
cmake ..
make -j$(nproc)