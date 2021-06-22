#!/usr/bin/env bash

SERVICE_A_EXIT_CODE=$1

cat <<EOT >> /usr/lib/systemd/system/a.service.d/test.conf
[Service]
Environment="SERVICE_A_EXIT_CODE=$SERVICE_A_EXIT_CODE"
EOT