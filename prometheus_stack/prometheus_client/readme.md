# Node_exporter

[https://www.dmosk.ru/miniinstruktions.php?mini=prometheus-stack-docker](https://www.dmosk.ru/miniinstruktions.php?mini=prometheus-stack-docker)

## Connect VMs

node_exporter  
`ssh -o ProxyCommand="ssh -i c:\Users\User\.ssh\wahha_rsa -W %h:%p wahha@devopsdemo.ru" -i c:\Users\User\.ssh\wahha_rsa wahha@192.168.0.5`  

## set VARIABLES in install_node_exporter.sh

INSTALL_DIR="/opt/prometheus_stack"  
PROMETHEUS_SRV_REPO="https://raw.githubusercontent.com/vakhtanov/tivaliclub_install/refs/heads/main/prometheus_stack/client"  
DOCKER_REPO="https://raw.githubusercontent.com/vakhtanov/tivaliclub_install/refs/heads/main/docker"  

## download repo

`wget -O - https://raw.githubusercontent.com/vakhtanov/tivaliclub_install/refs/heads/main/prometheus_stack/prometheus_client/download_repo.sh | bash`
