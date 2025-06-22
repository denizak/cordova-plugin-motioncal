#!/bin/bash
cd src/android
ndk-build clean
ndk-build
mkdir -p jniLibs
cp -r libs/* jniLibs/
echo "Native libraries built and copied to jniLibs/"