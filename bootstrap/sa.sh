#!/usr/bin/env bash
set -euo pipefail

SA_NAME="sa-terraform"
PROFILE_NAME="sa-terraform"
KEY_OUT="key.json"

CLOUD_ID=$(yc config get cloud-id)
FOLDER_ID=$(yc config get folder-id)
SA_ID=$(yc iam service-account create --name "$SA_NAME" --jq ".id")

# admin is required (not editor) because Terraform creates service accounts and assigns
# folder-level IAM roles to them (yandex_resourcemanager_folder_iam_member).
# editor does not have permission to manage IAM bindings.
yc resource-manager folder add-access-binding "$FOLDER_ID" \
  --role admin \
  --subject "serviceAccount:$SA_ID"

yc iam key create \
  --service-account-id "$SA_ID" \
  --output "$KEY_OUT"

yc config profile create "$PROFILE_NAME"

yc config set cloud-id "$CLOUD_ID"
yc config set folder-id "$FOLDER_ID"
yc config set service-account-key "$KEY_OUT"
