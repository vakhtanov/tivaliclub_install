# Prometheus Grafana stack

Readme for server and nodes is in folders

## Usefull notes

### Hostname from host

```yaml
  node-exporter:
    image: prom/node-exporter
    container_name: exporter
    #hostname: exporter
    network_mode: host  # Контейнер будет использовать имя сервера
```

### Dinamic host attach
```yaml
```
