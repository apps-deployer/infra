#!/usr/bin/env bash
set -euo pipefail

BUCKET_NAME="apps-deployer-tfstate"

yc storage bucket create --name "$BUCKET_NAME"

# Enable versioning — allows rolling back tfstate on accidental deletion or corruption
yc storage bucket update --name "$BUCKET_NAME" --versioning versioning-enabled

# Create KMS key for server-side encryption of tfstate (state contains secrets in plaintext)
KMS_KEY_ID=$(yc kms symmetric-key create \
  --name "tfstate-encryption-key" \
  --default-algorithm AES_256 \
  --jq ".id")

yc storage bucket update --name "$BUCKET_NAME" \
  --encryption "key-id=$KMS_KEY_ID"
