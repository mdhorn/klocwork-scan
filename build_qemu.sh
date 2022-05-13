#!/bin/bash

MAXCPU="${MAXCPU:-16}"
if [ ${MAXCPU} -gt $(nproc --all) ]; then
    MAXCPU="$(nproc --all)"
fi

SOURCE_DIR=$(pwd)
PROJ=$(basename $(pwd))
# Verify we are in a valid directory of QEMU source
if [ ! -f qemu-img.c -a ! -f configure ]
then
    echo "'${PROJ}' does not appear to be a QEMU source dir"
    exit 1
fi
cd ..
if [ -e "${PROJ}-build" -o -h "${PROJ}-build" -o  -d "${PROJ}-build" ]
then
    echo "${PROJ}-build already exists, clean-up and try again"
    exit 1
fi

BUILD_DIR=$(mktemp -d /build/${PROJ}-build-XXXXXXXXXX)
ln -s ${BUILD_DIR} ${PROJ}-build
if [ $? -ne 0 ]
then
    echo Failed
    exit 1
fi

cd ${BUILD_DIR}
if [ $? -ne 0 ]
then
    echo Failed
    exit 1
fi

DEBUG="/bin/true"
DEBUG=""

# # Test mode for ensure builds work first
# ${DEBUG} ${SOURCE_DIR}/configure --target-list-exclude=i386-softmmu
# ${DEBUG} make -j${MAXCPU}
# exit $?

KW_PROJ="dcp-qemu"
KW_SERVER_URL=${KW_SERVER_URL:="https://klocwork-jf22.devtools.intel.com:8180"}
KW_LICENSE_SERVER_URL=${KW_LICENSE_SERVER_URL:=""klocwork05p.elic.intel.com}
KW_LICENSE_SERVER_PORT=${KW_LICENSE_SERVER_PORT:="7500"}
echo ""
echo "============================================================"
echo KW_PROJ=${KW_PROJ}
echo KW_SERVER_URL=${KW_SERVER_URL}
echo "============================================================"
echo ""
export KW_PROJ KW_SERVER_URL KW_LICENSE_SERVER_URL KW_LICENSE_SERVER_PORT
echo ""
echo "============================================================"
echo kwinject ${SOURCE_DIR}/configure --target-list-exclude=i386-softmmu
echo "============================================================"
${DEBUG} kwinject ${SOURCE_DIR}/configure --target-list-exclude=i386-softmmu
echo ""
echo "============================================================"
echo kwinject make -j${MAXCPU}
echo "============================================================"
${DEBUG} kwinject make -j${MAXCPU}
echo ""
echo "============================================================"
echo kwbuildproject --force --verbose \
    --license-host ${KW_LICENSE_SERVER_URL} --license-port ${KW_LICENSE_SERVER_PORT} \
    --url ${KW_SERVER_URL}/${KW_PROJ} -o my_tables kwinject.out
echo "============================================================"
${DEBUG} kwbuildproject --force --verbose \
    --license-host ${KW_LICENSE_SERVER_URL} --license-port ${KW_LICENSE_SERVER_PORT} \
    --url ${KW_SERVER_URL}/${KW_PROJ} -o my_tables kwinject.out
echo ""
echo "============================================================"
echo kwadmin --url ${KW_SERVER_URL} load ${KW_PROJ} my_tables
echo "============================================================"
${DEBUG} kwadmin --url ${KW_SERVER_URL} load ${KW_PROJ} my_tables

