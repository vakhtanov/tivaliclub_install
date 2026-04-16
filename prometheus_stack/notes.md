# Prometheus Grafana stack

Readme for server and nodes is in folders

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
