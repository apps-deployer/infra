#!/usr/bin/env bash
set -euo pipefail

SA_NAME="sa-terraform"
PROFILE_NAME="sa-terraform"
KEY_OUT="key.json"

CLOUD_ID=$(yc config get cloud-id)
FOLDER_ID=$(yc config get folder-id)
SA_ID=$(yc iam service-account create --name "$SA_NAME" --jq ".id")

yc resource-manager folder add-access-binding "$FOLDER_ID" \
  --role editor \
  --subject serviceAccount:$SA_ID

yc iam key create \
  --service-account-id "$SA_ID" \
  --output "$KEY_OUT"

yc config profile create "$PROFILE_NAME"

yc config set cloud-id "$CLOUD_ID"
yc config set folder-id "$FOLDER_ID"
yc config set service-account-key "$KEY_OUT"
