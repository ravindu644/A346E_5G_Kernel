#!/bin/bash
export ARCH=arm64
export RDIR="$(pwd)"
export KBUILD_BUILD_USER="@ravindu644"

#init ksu next
git submodule init && git submodule update

#export toolchain paths
export BUILD_CROSS_COMPILE="${RDIR}/toolchain/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-androidkernel-"
export BUILD_CC="${RDIR}/toolchain/clang/host/linux-x86/clang-r383902/bin/clang"

#output dir
if [ ! -d "${RDIR}/out" ]; then
    mkdir -p "${RDIR}/out"
fi

#build dir
if [ ! -d "${RDIR}/build" ]; then
    mkdir -p "${RDIR}/build"
else
    rm -rf "${RDIR}/build" && mkdir -p "${RDIR}/build"
fi

#build options
export ARGS="
-C $(pwd) \
O=$(pwd)/out \
-j$(nproc) \
ARCH=arm64 \
CROSS_COMPILE=${BUILD_CROSS_COMPILE} \
CC=${BUILD_CC} \
CLANG_TRIPLE=aarch64-linux-gnu- \
KCFLAGS=-w \
CONFIG_SECTION_MISMATCH_WARN_ONLY=y \
"

#build kernel image
build_kernel(){
    make ${ARGS} clean && make ${ARGS} mrproper
    make ${ARGS} a34x_defconfig a34.config
    make ${ARGS} menuconfig
    make ${ARGS} || exit 1
    cp out/arch/arm64/boot/Image $(pwd)/arch/arm64/boot/Image
}

build_kernel
