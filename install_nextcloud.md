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
* Configure your web server or reverse proxy with the specific settings for AIO. See "Configuring your reverse proxy" below.
* Specify the port that AIO's integrated Apache container will use via the environment variable APACHE_PORT, and update the docker run command or your Compose file accordingly. See "Use this startup command" below.
* Optional: Limit the access to the Apache container. See "Limit the access to the Apache container".
* Open the AIO interface at port 8080, enter your domain, and validate it. See "Open the AIO interface" below.

Optional steps:
* Configure additional settings if your reverse proxy uses an IP address to connect to AIO. See "Configure AIO for IP-based reverse proxies".
* Get a valid certificate for the AIO interface. See "Get a valid certificate for the AIO interface".
* Debug things if needed. See "How to debug things".


5. Optional: Configure AIO for reverse proxies that connect to nextcloud not using localhost nor 127.0.0.1
If your reverse proxy connects to nextcloud not using localhost or 127.0.0.1, you must add said IP as trusted proxy to the installation. See the step below:

Add the IP it uses connect to AIO to the Nextcloud trusted_proxies like this:  
`sudo docker exec --user www-data -it nextcloud-aio-nextcloud php occ config:system:set trusted_proxies 2 --value=ip.address.of.proxy`

If you have somehow lost the passphrase that is used for the AIO interface, you can reobtain it by running   
`sudo docker exec nextcloud-aio-mastercontainer grep password /mnt/docker-aio-config/data/configuration.json`


https://raju.dev/nextcloud-aio-install-with-docker-compose-and-reverse-proxy/
