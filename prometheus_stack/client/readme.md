# Node_exporter

[https://www.dmosk.ru/miniinstruktions.php?mini=prometheus-stack-docker](https://www.dmosk.ru/miniinstruktions.php?mini=prometheus-stack-docker)

## Connect VMs

nodeexporter
`ssh -o ProxyCommand="ssh -i c:\Users\User\.ssh\wahha_rsa -W %h:%p wahha@devopsdemo.ru" -i c:\Users\User\.ssh\wahha_rsa wahha@192.168.0.5`  

## START SCRIPT

`wget -O - https://raw.githubusercontent.com/vakhtanov/tivaliclub_install/refs/heads/main/prometheus_stack/test/install_node_exporter.sh | bash`


#==============================
еще сборщик  
cAdvisor  

```yaml
  cadvisor:
    image: gcr.io/cadvisor/cadvisor:latest
    container_name: cadvisor
    ports:
      - 8080:8080
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:ro
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
      - /dev/disk/:/dev/disk:ro
    restart: unless-stopped

```

```yaml
scrape_configs:
  - job_name: 'docker_containers'
    static_configs:
      - targets: ['<IP_ВТОРОГО_ХОСТА>:8080']
```

Grafana dashboard
Docker Monitoring (ID: 10619)
