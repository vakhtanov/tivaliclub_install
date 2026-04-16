# Node_exporter

[https://www.dmosk.ru/miniinstruktions.php?mini=prometheus-stack-docker](https://www.dmosk.ru/miniinstruktions.php?mini=prometheus-stack-docker)

## Connect VMs

nodeexporter
`ssh -o ProxyCommand="ssh -i c:\Users\User\.ssh\wahha_rsa -W %h:%p wahha@devopsdemo.ru" -i c:\Users\User\.ssh\wahha_rsa wahha@192.168.0.5`  

## START SCRIPT

`wget -O - https://raw.githubusercontent.com/vakhtanov/tivaliclub_install/refs/heads/main/prometheus_stack/test/install_node_exporter.sh | bash`
