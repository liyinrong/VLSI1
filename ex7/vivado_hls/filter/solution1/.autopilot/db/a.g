#!/bin/sh
lli=${LLVMINTERP-lli}
exec $lli \
    /home/vlsi1_010hs23/ex7/vivado_hls/filter/solution1/.autopilot/db/a.g.bc ${1+"$@"}