#!/usr/bin/env bash
set -euo pipefail

obj="$(curl  -H "Accept: application/vnd.github.v3+json"  https://api.github.com/repos/maxhbr/mykyria/actions/artifacts | jq -r ".artifacts|first")"
objdate="$(echo "$obj" | jq -r ".updated_at")"
objurl="$(echo "$obj" | jq -r ".archive_download_url")"

if [[ -d "$objdate" ]]; then
  echo "already downloaded"
else
  mkdir -p "$objdate"
  (cd "$objdate"
   curl -i -L -H "Authorization: token $(pass -p github-bot-token)" "$objurl" > "firmeware.zip"
   unzip "firmeware.zip"
  )

  ln -s "$objdate" latest
fi

if lsblk -f | grep "sda" | grep "NICENANO"; then
  echo "nicenano found"
  udisksctl mount -b /dev/sda
  cp -i "$objdate/kyria_rev2_left-nice_nano_v2-zmk.uf2" /run/media/mhuber/NICENANO
else
  echo "not connected"
fi
