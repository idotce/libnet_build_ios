#!/bin/bash

# https://ares.lids.mit.edu/redmine/projects/forest-game/wiki/Building_sigc++_for_iOS
# https://gist.github.com/idotce/be94b667b40ed694d006
# xcode-select --install
# "/Applications/Xcode.app/Contents/Developer"
# "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer"
# "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk"

IOSMIN="7.0";
PREFIX=`pwd`"/out/usr";
CUST_CONFIG="ENDIANESS=LIBNET_LIL_ENDIAN ac_cv_libnet_endianess=lil ac_libnet_have_packet_socket=no ac_cv_libnet_linux_procfs=no ac_cv_lbl_unaligned_fail=no";
CUST_CFLAGS="";
CUST_CXXFLAGS="";
CUST_LDFLAGS="";

if [ $# != 1 ] ; then
    echo "USAGE: $0 directory"
    exit 1
else
    rm -rf $PREFIX
    mkdir -p $PREFIX
    cd $1
fi

DEVROOT=`xcode-select -p`;
SDKROOT=`xcrun --sdk iphoneos --show-sdk-path`;
BINROOT="$DEVROOT/usr/bin";

ARCH="-arch armv7 -arch armv7s -arch arm64";

INCLUDES="\
    -I$SDKROOT/usr/include \
";

LIBS="\
    -L$SDKROOT/usr/lib \
    -L$SDKROOT/usr/lib/system \
";

CFLAGS="\
    $ARCH \
    -isysroot ${SDKROOT} \
    -miphoneos-version-min=$IOSMIN \
    -g -O2 -Wall -std=c99 \
    ${INCLUDES} \
";

CXXFLAGS="\
    $ARCH \
    -isysroot ${SDKROOT} \
    -miphoneos-version-min=$IOSMIN \
    -g -O2 -Wall -std=c++11 \
    ${INCLUDES} \
";

LDFLAGS="\
    $ARCH \
    -isysroot ${SDKROOT} \
    -miphoneos-version-min=$IOSMIN \
    -Wl,-segalign,4000 \
    ${LIBS} \
";

CC="${BINROOT}/gcc";
CXX="${BINROOT}/g++";

make distclean

./configure \
    $CUST_CONFIG \
    --prefix="$PREFIX" \
    --host=arm-apple-darwin \
    CC="$CC" \
    CFLAGS="$CFLAGS $CUST_CFLAGS" \
    CXX="$CXX" \
    CXXFLAGS="$CXXFLAGS $CUST_CXXFLAGS" \
    LDFLAGS="$LDFLAGS $CUST_LDFLAGS" \
;

make
make install
cd ..
