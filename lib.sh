#!/bin/bash
set -eu -o pipefail -o errtrace


# put our custom binaries on PATH.
export PATH="$PATH:$HOME/go/bin"


function title {
    cat <<EOF

########################################################################
#
# $*
#

EOF
}


set -x
