#编译参考https://www.jianshu.com/p/20902ca448ae?utm_source=oschina-app
# lib-name
MY_LIBS_NAME=libjpeg-turbo
MY_SOURCE_DIR=$(pwd)/libjpeg-turbo
MY_BUILD_DIR=binary

CMAKE_PATH=/Users/guxiuzhong/Library/Android/sdk/cmake/3.10.2.4988404
export PATH=${CMAKE_PATH}/bin:$PATH
NDK_PATH=/Users/guxiuzhong/Library/Android/sdk/ndk/21.1.6352462


BUILD_PLATFORM=linux-x86_64
TOOLCHAIN_VERSION=4.9
ANDROID_VERSION=24

ANDROID_ARMV5_CFLAGS="-march=armv5te"
ANDROID_ARMV7_CFLAGS="-march=armv7-a -mfloat-abi=softfp -mfpu=neon"  # -mfpu=vfpv3-d16  -fexceptions -frtti
ANDROID_ARMV8_CFLAGS="-march=armv8-a "                   # -mfloat-abi=softfp -mfpu=neon -fexceptions -frtti
ANDROID_X86_CFLAGS="-march=i386 -mtune=intel -mssse3 -mfpmath=sse -m32"
ANDROID_X86_64_CFLAGS="-march=x86-64 -msse4.2 -mpopcnt -m64 -mtune=intel"

# params($1:arch,$2:arch_abi,$3:host,$4:compiler,$5:cflags,$6:processor)
build_bin() {

    echo "-------------------start build $1-------------------------"

    ANDROID_ARCH_ABI=$1    # armeabi armeabi-v7a x86 mips
    CFALGS="$2"
    
    PREFIX=$(pwd)/dist/${MY_LIBS_NAME}/${ANDROID_ARCH_ABI}/
    # build 中间件
    BUILD_DIR=./${MY_BUILD_DIR}/${MY_LIBS_NAME}/${ANDROID_ARCH_ABI}

    echo "path==>$PATH"
    echo "build_dir==>$BUILD_DIR"
    echo "ANDROID_ARCH_ABI==>$ANDROID_ARCH_ABI"
    echo "CFALGS==>$CFALGS"


    mkdir -p ${BUILD_DIR}
    cd ${BUILD_DIR}

    # -DCMAKE_MAKE_PROGRAM=${NDK_PATH}/prebuilt/${BUILD_PLATFORM}/bin/make \
    # -DCMAKE_ASM_COMPILER=${NDK_PATH}/prebuilt/${BUILD_PLATFORM}/bin/yasm \

    cmake -G"Unix Makefiles" \
      -DANDROID_ABI=${ANDROID_ARCH_ABI} \
      -DANDROID_PLATFORM=android-${ANDROID_VERSION} \
      -DCMAKE_BUILD_TYPE=Release \
      -DANDROID_NDK=${NDK_PATH} \
      -DCMAKE_TOOLCHAIN_FILE=${NDK_PATH}/build/cmake/android.toolchain.cmake \
      -DCMAKE_POSITION_INDEPENDENT_CODE=1 \
      -DCMAKE_INSTALL_PREFIX=${PREFIX} \
      -DANDROID_ARM_NEON=TRUE \
      -DANDROID_TOOLCHAIN=clang \
      -DANDROID_STL=c++_static \
      -DCMAKE_C_FLAGS="${CFALGS} -Os -Wall -pipe -fPIC" \
      -DCMAKE_CXX_FLAGS="${CFALGS} -Os -Wall -pipe -fPIC" \
      -DANDROID_CPP_FEATURES=rtti exceptions \
      -DWITH_JPEG8=1 \
      ${MY_SOURCE_DIR}

    make clean
    make
    make install

    cd ../../../

    echo "-------------------$1 build end-------------------------"
}

# build armeabi
build_bin armeabi "$ANDROID_ARMV5_CFLAGS"

#build armeabi-v7a
build_bin armeabi-v7a "$ANDROID_ARMV7_CFLAGS"

#build arm64-v8a
build_bin arm64-v8a "$ANDROID_ARMV8_CFLAGS"

#build x86
build_bin x86 "$ANDROID_X86_CFLAGS"

#build x86_64
build_bin x86_64 "$ANDROID_X86_64_CFLAGS"
