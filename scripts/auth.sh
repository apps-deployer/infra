#!/usr/bin/env bash
STATIC_KEY_PATH="static-key.json"

export AWS_ACCESS_KEY_ID=$(cat "$STATIC_KEY_PATH" | jq -r ".access_key.key_id")
export AWS_SECRET_ACCESS_KEY=$(cat "$STATIC_KEY_PATH" | jq -r ".secret")
