#!/bin/bash
set -e

LOWERCASE_USERNAME=$(echo "$ZOWE_USERNAME" | tr '[:upper:]' '[:lower:]')

if [ -z "$ZOWE_USERNAME" ] || [ -z "$ZOWE_PASSWORD" ]; then
  echo "ZOWE_USERNAME or ZOWE_PASSWORD is empty."
  exit 1
fi

if ! npx zowe zos-files list uss-files "/z/$LOWERCASE_USERNAME/cobolcheck" \
  --host 204.90.115.200 \
  --port 10443 \
  --user "$ZOWE_USERNAME" \
  --password "$ZOWE_PASSWORD" \
  --reject-unauthorized false \
  &>/dev/null; then
  echo "Directory does not exist. Creating it..."
  npx zowe zos-files create uss-directory "/z/$LOWERCASE_USERNAME/cobolcheck" \
    --host 204.90.115.200 \
    --port 10443 \
    --user "$ZOWE_USERNAME" \
    --password "$ZOWE_PASSWORD" \
    --reject-unauthorized false
else
  echo "Directory already exists."
fi

npx zowe zos-files upload dir-to-uss "./cobol-check" "/z/$LOWERCASE_USERNAME/cobolcheck" \
  --recursive \
  --binary-files "cobol-check-0.2.19.jar" \
  --host 204.90.115.200 \
  --port 10443 \
  --user "$ZOWE_USERNAME" \
  --password "$ZOWE_PASSWORD" \
  --reject-unauthorized false

echo "Verifying upload:"
npx zowe zos-files list uss-files "/z/$LOWERCASE_USERNAME/cobolcheck" \
  --host 204.90.115.200 \
  --port 10443 \
  --user "$ZOWE_USERNAME" \
  --password "$ZOWE_PASSWORD" \
  --reject-unauthorized false