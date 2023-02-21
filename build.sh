#!/bin/bash

function compile() 
{

source ~/.bashrc && source ~/.profile
export LC_ALL=C && export USE_CCACHE=1
ccache -M 100G
export ARCH=arm64
export KBUILD_BUILD_HOST=MARK•DEVS
export KBUILD_BUILD_USER="AbzRaider"
export KBUILD_COMPILER_STRING="(${KERNEL_DIR}/clang/bin/clang --version | head -n 1 | perl -pe 's/\((?:http|git).*?\)//gs' | sed -e 's/  */ /g' -e 's/[[:space:]]*$//' -e 's/^.*clang/clang/')"

git clone --depth=1 -b master https://github.com/MASTERGUY/proton-clang clang 

[ -d "out" ] && rm -rf AnyKernel && rm -rf out || mkdir -p out

make O=out ARCH=arm64 sweet_user_defconfig

PATH="${PWD}/clang/bin:${PATH}:${PWD}/clang/bin:${PATH}:${PWD}/clang/bin:${PATH}" \
       make -j$(nproc --all) O=out \
                      ARCH=arm64 \
                      CC=clang \
                      CROSS_COMPILE=aarch64-linux-gnu- \
                      CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
                      NM=llvm-nm \
                      OBJCOPY=llvm-objcopy \
                      OBJDUMP=llvm-objdump \
                      STRIP=llvm-strip
}

function zupload()
{
mkdir AnyKernel
cd AnyKernel 
git clone --depth=1 https://github.com/AbzRaider/AnyKernel33.git -b sweet
cd /
cp out/arch/arm64/boot/Image.gz-dtb AnyKernel
cd AnyKernel
zip -r9 Azrael-KERNEL-11-SWEET.zip *
curl -sL https://git.io/file-transfer | sh
./transfer wet Azrael-KERNEL-11-SWEET.zip
}

compile
zupload
