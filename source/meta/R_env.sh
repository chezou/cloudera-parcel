#!/bin/bash

if [ -n "${R_HOME}" ]; then
  export R_HOME="${R_HOME}:$PARCELS_ROOT/__PARCEL_NAME__-__PARCEL_VERSION__/lib/r/lib"
else
  export R_HOME="$PARCELS_ROOT/__PARCEL_NAME__-__PARCEL_VERSION__/lib/r/lib"
fi

if [ -n "${RHOME}" ]; then
  export RHOME="${RHOME}:$PARCELS_ROOT/__PARCEL_NAME__-__PARCEL_VERSION__/lib/r"
else
  export RHOME="$PARCELS_ROOT/__PARCEL_NAME__-__PARCEL_VERSION__/lib/r"
fi

if [ -n "${R_SHARE_DIR}" ]; then
  export R_SHARE_DIR="${R_SHARE_DIR}:$PARCELS_ROOT/__PARCEL_NAME__-__PARCEL_VERSION__/lib/r/lib/R/share"
else
  export R_SHARE_DIR="$PARCELS_ROOT/__PARCEL_NAME__-__PARCEL_VERSION__/lib/r/lib/R/share"
fi

if [ -n "${R_INCLUDE_DIR}" ]; then
  export R_INCLUDE_DIR="${R_INCLUDE_DIR}:$PARCELS_ROOT/__PARCEL_NAME__-__PARCEL_VERSION__/lib/r/lib/R/include"
else
  export R_INCLUDE_DIR="$PARCELS_ROOT/__PARCEL_NAME__-__PARCEL_VERSION__/lib/r/lib/R/include"
fi
