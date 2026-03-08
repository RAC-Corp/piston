#!/bin/bash

git clone https://github.com/luau-lang/luau.git --depth 1
cd luau

cmake -DCMAKE_BUILD_TYPE=Release .
make -j$(nproc)