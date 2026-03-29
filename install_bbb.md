основное руководство

[https://docs.bigbluebutton.org/administration/install/](https://docs.bigbluebutton.org/administration/install/)

требования
```
Ubuntu 22.04 64-bit OS running Linux kernel 5.x
Latest version of docker installed
16 GB of memory with swap enabled
8 CPU cores, with high single-thread performance
500 GB of free disk space (or more) for recordings, or 50GB if session recording is disabled on the server.
TCP ports 80 and 443 are accessible
UDP ports 16384 - 32768 are accessible
250 Mbits/sec bandwidth (symmetrical) or more
TCP port 80 and 443 are not in use by another web server or reverse proxy
A hostname (such as bbb.example.com) for setup of a SSL certificate
IPV4 and IPV6 address
```

После создания виртуальной машины

1. check locale
   
  `cat /etc/default/locale`  
    ответ: LANG="en_US.UTF-8"  

#if not ===================
    sudo apt-get install -y language-pack-en  
    sudo update-locale LANG=en_US.UTF-8  
    перелогиниться  
    проверить  
    cat /etc/default/locale
    ответ LANG="en_US.UTF-8"
    ======================

2. check sysctl env

    `sudo systemctl show-environment`
   ответ:  
    LANG=en_US.UTF-8
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# if not =============================
sudo systemctl set-environment LANG=en_US.UTF-8

#check
sudo systemctl show-environment
#LANG=en_US.UTF-8
#PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# 3 check memory
free -h

16 for prod
8 for dev

# 4 check version
cat /etc/lsb-release
#DISTRIB_ID=Ubuntu
#DISTRIB_RELEASE=22.04
#DISTRIB_CODENAME=jammy
#DISTRIB_DESCRIPTION="Ubuntu 22.04.3 LTS"

# 5 check 64 bit
uname -m
# x86_64

# 6 check ipv6
ip addr | grep inet6
#inet6 ::1/128 scope host

# if not after install need to disable ipv6 in FreeSWITCH 

# 7 check kernel
uname -r
#5.15.x-xx-generic

# 8 check cores
grep -c ^processor /proc/cpuinfo
# 8

# 9 check ports
sudo ufw status

# inactive or 
# 80       ALLOW   Anywhere
# 443      ALLOW   Anywhere


# 10 install
wget -qO- https://raw.githubusercontent.com/bigbluebutton/bbb-install/v3.0.x-release/bbb-install.sh | bash -s -- -v jammy-300 -s bbb.example.com -e info@example.com -g


#DEV install
wget -qO- https://raw.githubusercontent.com/bigbluebutton/bbb-install/v3.0.x-release/bbb-install.sh | bash -s -- -v jammy-300 -s devopsdemo.ru -e wahha@mail.ru -g -j

tivaliclub.com
wget -qO- https://raw.githubusercontent.com/bigbluebutton/bbb-install/v3.0.x-release/bbb-install.sh | bash -s -- -v jammy-300 -s bbb.tivaliclub.com -e wahha@mail.ru -g -j


# 11 check install

bbb-conf --check
sudo bbb-conf --status
dpkg -l | grep bbb-
bbb-conf --secret

check ARI
 https://mconf.github.io/api-mate/#server=https://devopsdemo.ru/bigbluebutton/&
 
 
 #12 check firewall
sudo apt-get install netcat
===
sudo bbb-conf --stop

netcat -l 443
