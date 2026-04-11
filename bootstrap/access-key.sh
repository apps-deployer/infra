#!/usr/bin/env bash
set -euo pipefail

SA_NAME="sa-terraform"
KEY_OUT="static-key.json"

SA_ID=$(yc iam service-account get "$SA_NAME" --jq ".id")

yc iam access-key create \
  --service-account-id "$SA_ID" \
  --format json \
  > $KEY_OUT
