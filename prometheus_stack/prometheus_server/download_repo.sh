PROMETHEUS_SRV_REPO="https://raw.githubusercontent.com/vakhtanov/tivaliclub_install/refs/heads/main/prometheus_stack/prometheus_server"

## COLORS FOR BASH
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

if [ "$PWD" != "$HOME" ]; then
    echo -e "${RED}Error: You mast be in home ($HOME).${NC}"
    echo -e "Now in: $PWD"
    exit 1
fi

echo -e "${GREEN}Success: you in home${NC}"



mkdir -p prometheus_server
cd prometheus_server

sudo wget $PROMETHEUS_SRV_REPO/alertmanager/config.yml -O alertmanager/config.yml
sudo wget $PROMETHEUS_SRV_REPO/prometheus/etc/alert.rules -O prometheus/etc/alert.rules
sudo wget $PROMETHEUS_SRV_REPO/prometheus/etc/prometheus.yml -O prometheus/etc/prometheus.yml
sudo wget $PROMETHEUS_SRV_REPO/prometheus/etc/targets.json -O prometheus/etc/targets.json
sudo wget $PROMETHEUS_SRV_REPO/grafana/provisioning/datasource.yml -O grafana/provisioning/datasource.yml
sudo wget $PROMETHEUS_SRV_REPO/docker-compose.yml -O docker-compose.yml
sudo wget $PROMETHEUS_SRV_REPO/.env -O .env
sudo wget $PROMETHEUS_SRV_REPO/install_prometheus_stack.sh -O install_prometheus_stack.sh

echo -e "${GREEN}cd prometheus_server${NC}"
