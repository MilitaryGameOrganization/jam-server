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
add_user c3e91197-2db1-4e2d-9267-cdefbe84caba kuma_yamamoto
add_user 899329f1-a457-4427-aa9c-ab86ee8a7416 noyciy7037
add_user 6682c0b9-3ce3-4cae-84b4-e6ffc42e664d subaru1572
add_user 7f98a71c-e894-4973-8a20-0f38a741e680 Yukikaze_Scarlet
add_user 344c695a-558e-4a41-ba29-82036b3d6369 icefire7


echo "[
$JSON_BODY
]" > whitelist.json
