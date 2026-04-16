# Prometheus Grafana stack

Readme for server and nodes is in folders

## Usefull notes

### Hostname from host

```yaml
services:
  node-exporter:
    image: prom/node-exporter
    container_name: exporter
    # Убираем hostname: exporter, чтобы не путаться
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
      - /etc/hostname:/etc/nodename:ro  # Пробрасываем файл с именем хоста
    command:
      - --path.procfs=/host/proc
      - --path.sysfs=/host/sys
      - --collector.filesystem.ignored-mount-points
      - ^/(sys|proc|dev|host|etc|rootfs/var/lib/docker/containers|rootfs/var/lib/docker/overlay2|rootfs/run/docker/netns|rootfs/var/lib/docker/aufs)($$|/)
      # Добавляем эту строку:
      - --collector.textfile.directory=/etc/nodename 
    environment:
      - NODE_NAME=${HOSTNAME:-undetermined} # Берет имя из системы
    ports:
      - 9100:9100
    restart: unless-stopped
```

```
   command:
      - --path.procfs=/host/proc
      - --path.sysfs=/host/sys
      - --collector.filesystem.ignored-mount-points
      - ^/(sys|proc|dev|host|etc|rootfs/var/lib/docker/containers|rootfs/var/lib/docker/overlay2|rootfs/run/docker/netns|rootfs/var/lib/docker/aufs)($$|/)
      - --node-exporter.hostname=${HOSTNAME} # передаем имя хоста
```
