#!/usr/bin/env bash

JSON_BODY=""

add_user() {
    USER='{"uuid": "'"$1"'", "level": "'"$2"'", "name": "'"$3"'", "bypassesPlayerLimit": '"$4"'}'
    if [[ -z $JSON_BODY ]]; then
        JSON_BODY="  $USER"
    else
        JSON_BODY="$JSON_BODY,
  $USER"
    fi
}

add_user 6cde5c61-9493-4726-b580-a74e751e5eb4 4 anatawa12 true

echo "[
$JSON_BODY
]" > ops.json
