# NextCloud install thrue docker

Минимальыне требвоания - 2CPU 2MEM 40HDD

## Community docker image
https://github.com/docker-library/docs/blob/master/nextcloud/README.md

Позволяет сделать различные варианты установки меняя базы данных, расположить з аобратным прокси и т.д. 

## NEXTCLOUD ALL IN ONE - oficial docker

https://github.com/nextcloud/all-in-one?tab=readme-ov-file#how-to-use-this

## NEXTCLOUD ALL IN ONE - oficial docker revers proxy  
https://github.com/nextcloud/all-in-one/blob/main/reverse-proxy.md#1-configure-the-reverse-proxy

https://github.com/nextcloud/all-in-one/blob/main/compose.yaml

Required steps:

Configure your web server or reverse proxy with the specific settings for AIO. See "Configuring your reverse proxy" below.
Specify the port that AIO's integrated Apache container will use via the environment variable APACHE_PORT, and update the docker run command or your Compose file accordingly. See "Use this startup command" below.
Optional: Limit the access to the Apache container. See "Limit the access to the Apache container".
Open the AIO interface at port 8080, enter your domain, and validate it. See "Open the AIO interface" below.
Optional steps:

Configure additional settings if your reverse proxy uses an IP address to connect to AIO. See "Configure AIO for IP-based reverse proxies".
Get a valid certificate for the AIO interface. See "Get a valid certificate for the AIO interface".
Debug things if needed. See "How to debug things".
