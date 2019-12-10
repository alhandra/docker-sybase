#!/bin/sh

# Source in the Sybase environment variables

source /opt/sap/SYBASE.sh

# Start QIPSYBASE
${SYBASE}/${SYBASE_ASE}/install/RUN_SYBASE
RET=$?

# exit ${RET}
exit 0
