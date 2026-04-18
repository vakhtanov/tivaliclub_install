ssh -i c:/Users/wahha/.ssh/wahha_rsa andrey@192.168.20.62


# Prometheus Grafana stack

**Readme for server and nodes is in folders**

_Grafana admin:TIvaliClub_

## Usefull notes

### Hostname from host
docker-compose.yml
```yaml
  node-exporter:
    image: prom/node-exporter
    container_name: exporter
    #hostname: exporter
    network_mode: host  # Контейнер будет использовать имя сервера
```

### Dinamic host attach
prometheus.yml
```yaml
scrape_configs:
  - job_name: 'node_exporter'
    file_sd_configs:
      - files:
        - '/etc/prometheus/targets.json'
```

targets.json
```json
[
  {
    "targets": ["192.168.0.6:9100"],
    "labels": {
      "env": "production",
      "job": "node_exporter"
    }
  },
  {
    "targets": ["192.168.0.5:9100"],
    "labels": {
      "env": "production",
      "job": "node_exporter"
    }
  },
    {
    "targets": ["10.130.0.26:9100"],
    "labels": {
      "env": "production",
      "job": "node_exporter"
    }
  }
]
```


  
### cAdvisor  еще сборщик - мониторит docker контейнеры

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

