#!/bin/bash

CONDAR_DIRNAME=${PARCEL_DIRNAME:-"CONDAR-3.4.1"}

if [ -n "${R_HOME}" ]; then
  export R_HOME="${R_HOME}:$PARCELS_ROOT/$CONDAR_DIRNAME/lib/conda-R/lib"
else
  export R_HOME="$PARCELS_ROOT/$CONDAR_DIRNAME/lib/conda-R/lib"
fi

if [ -n "${RHOME}" ]; then
  export RHOME="${RHOME}:$PARCELS_ROOT/$CONDAR_DIRNAME/lib/conda-R"
else
  export RHOME="$PARCELS_ROOT/$CONDAR_DIRNAME/lib/conda-R"
fi

if [ -n "${R_SHARE_DIR}" ]; then
  export R_SHARE_DIR="${R_SHARE_DIR}:$PARCELS_ROOT/$CONDAR_DIRNAME/lib/conda-R/lib/R/share"
else
  export R_SHARE_DIR="$PARCELS_ROOT/$CONDAR_DIRNAME/lib/conda-R/lib/R/share"
fi

if [ -n "${R_INCLUDE_DIR}" ]; then
  export R_INCLUDE_DIR="${R_INCLUDE_DIR}:$PARCELS_ROOT/$CONDAR_DIRNAME/lib/conda-R/lib/R/include"
else
  export R_INCLUDE_DIR="$PARCELS_ROOT/$CONDAR_DIRNAME/lib/conda-R/lib/R/include"
fi
