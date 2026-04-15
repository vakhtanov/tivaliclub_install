#!/usr/bin/env bash
set -euo pipefail ## ЗАВЕРШАЕТ БАШ СКПРИПТ ПРИ ЛЮБОЙ ОШИБКЕ!!!!!

REPO_URL="https://github.com/hyperdxio/hyperdx.git"
INSTALL_DIR="/opt/prometheus_stack"
RUN_USER="hyperdx"
SERVER_IP="hyperdx.tivaliclub.com"  # ← Твой домен!

## КРАСИТ ЭХО В РАЗНЫЕ ЦВЕТА!!!!
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'


#===================

mkdir -p $INSTALL_DIR/{prometheus,grafana,alertmanager,blackbox}
