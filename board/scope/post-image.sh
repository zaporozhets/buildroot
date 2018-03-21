#!/bin/bash

set -x
set -e

BOARD_DIR="$(dirname $0)"
BOARD_NAME="$(basename ${BOARD_DIR})"

GENIMAGE_CFG="$(dirname $0)/genimage.cfg"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

PRODUCT_NAME=${BOARD_NAME}

################################################################################
# Main function
################################################################################
function MAIN 
{

    if [ -z "$PRODUCT_FW_VERSION" ]; then
        echo "Undefined product version!"
        PRODUCT_FW_VERSION="undefined"
    else
        echo $PRODUCT_FW_VERSION
    fi

    sed -e "s/@@FW_VERSION@@/$PRODUCT_FW_VERSION/" "${BOARD_DIR}/sw-description" > ${BINARIES_DIR}/sw-description

    cp "${BOARD_DIR}/update.sh"      ${BINARIES_DIR}/

    #openssl dgst -sha256 -sign swupdate-priv.pem sw-description > sw-description.sig
    SWU_FNAME="${PRODUCT_NAME}_${PRODUCT_FW_VERSION}.swu"
    (
        cd ${BINARIES_DIR}/

        gzip -k -f rootfs.ext2

        FILES="sw-description rootfs.ext2.gz update.sh"

        for i in $FILES;do
            echo $i;done | cpio -ov -H crc > ${SWU_FNAME}
    )

    LATEST_SWU_FNAME="${BINARIES_DIR}/${PRODUCT_NAME}_latest.swu"

    ln -s -f ${SWU_FNAME} ${LATEST_SWU_FNAME}
}

MAIN

exit $?
