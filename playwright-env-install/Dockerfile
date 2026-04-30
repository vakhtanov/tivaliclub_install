ARG PW_VERSION=latest
FROM mcr.microsoft.com/playwright:${PW_VERSION}
ARG PW_VERSION=latest

# Set SSH, clear cache
RUN apt-get update && apt-get install -y \
    openssh-server \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /var/run/sshd

# Config SSH
RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh
COPY authorized_keys /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys

# Config security
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    echo "export PATH=$PATH" >> /root/.bashrc

# Allow X11 Forwarding SSH config
RUN echo "X11Forwarding yes" >> /etc/ssh/sshd_config && \
    echo "X11UseLocalhost no" >> /etc/ssh/sshd_config && \
    echo "AddressFamily inet" >> /etc/ssh/sshd_config

WORKDIR /app
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]