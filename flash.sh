#!/usr/bin/env bash
set -euo pipefail

if lsblk -f | grep "sda" | grep "NICENANO"; then
  echo "nicenano found"
  udisksctl mount -b /dev/sda
  cp -i "artifacts/kyria_rev2_left-nice_nano_v2-zmk.uf2" /run/media/mhuber/NICENANO
else
  echo "not connected"
fi
