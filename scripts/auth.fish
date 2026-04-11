#!/usr/bin/env fish
set STATIC_KEY_PATH "static-key.json"

set -x AWS_ACCESS_KEY_ID (cat "$STATIC_KEY_PATH" | jq -r ".access_key.key_id")
set -x AWS_SECRET_ACCESS_KEY (cat "$STATIC_KEY_PATH" | jq -r ".secret")
