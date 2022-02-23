#!/usr/bin/env bash

JSON_BODY=""

add_user() {
    USER='{"uuid": "'"$1"'", "name": "'"$2"'"}'
    if [[ -z $JSON_BODY ]]; then
        JSON_BODY="  $USER"
    else
        JSON_BODY="$JSON_BODY,
  $USER"
    fi
}

add_user 6cde5c61-9493-4726-b580-a74e751e5eb4 anatawa12
add_user f060a0d5-a246-43fb-8c92-2395798483da kirisamekuroa
add_user 0ee944a1-4a15-488c-9ef0-8edae0bfd128 Alice1537
add_user 52806416-f227-49ef-8fd8-0fca389c793a kaka_256
add_user 87229700-66c8-4436-8cbc-f288b7bae8ec seemense

echo "[
$JSON_BODY
]" > whitelist.json
