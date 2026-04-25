# Node_exporter - original article

[https://www.dmosk.ru/miniinstruktions.php?mini=prometheus-stack-docker](https://www.dmosk.ru/miniinstruktions.php?mini=prometheus-stack-docker)

## IF NEED Connect VMs

node_exporter  
```
ssh -o ProxyCommand="ssh -i c:\Users\User\.ssh\wahha_rsa -W %h:%p wahha@devopsdemo.ru" -i c:\Users\User\.ssh\wahha_rsa wahha@192.168.0.5
```  

## IF NEED download repo from VAH

```
wget --no-cache -O - https://raw.githubusercontent.com/vakhtanov/tivaliclub_install/refs/heads/main/prometheus_stack/prometheus_agent/download_repo.sh | bash
```

## IF NEED set VARIABLES in install_node_exporter.sh 

INSTALL_DIR="/opt/prometheus_stack"  

## START install_node_exporter.sh
