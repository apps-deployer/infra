
#!/usr/bin/env bash
set -euo pipefail

BUCKET_NAME="apps-deployer-tfstate"

yc storage bucket create --name "$BUCKET_NAME"
