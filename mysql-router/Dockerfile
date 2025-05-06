FROM ubuntu:22.04

# 1. Configure APT to use reliable mirrors and retry failed downloads
RUN echo 'Acquire::ForceIPv4 "true";' > /etc/apt/apt.conf.d/99force-ipv4 && \
    echo 'APT::Acquire::Retries "5";' >> /etc/apt/apt.conf.d/99retries && \
    sed -i \
      -e 's|http://[a-z0-9\./]*ubuntu\.com|http://archive.ubuntu.com/ubuntu|g' \
      -e 's|http://security\.ubuntu\.com|http://archive.ubuntu.com/ubuntu|g' \
      /etc/apt/sources.list && \
    echo "deb [signed-by=/usr/share/keyrings/ubuntu-archive-keyring.gpg] http://archive.ubuntu.com/ubuntu jammy main restricted universe multiverse" > /etc/apt/sources.list && \
    echo "deb [signed-by=/usr/share/keyrings/ubuntu-archive-keyring.gpg] http://archive.ubuntu.com/ubuntu jammy-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb [signed-by=/usr/share/keyrings/ubuntu-archive-keyring.gpg] http://archive.ubuntu.com/ubuntu jammy-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb [signed-by=/usr/share/keyrings/ubuntu-archive-keyring.gpg] http://security.ubuntu.com/ubuntu jammy-security main restricted universe multiverse" >> /etc/apt/sources.list

# 2. Install dependencies
RUN apt-get update -o Acquire::AllowInsecureRepositories=true && \
    apt-get install -y --allow-unauthenticated \
      wget \
      gnupg \
      lsb-release \
      ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 3. Import MySQL's GPG key and add repository
RUN wget -qO- https://repo.mysql.com/RPM-GPG-KEY-mysql-2023 | gpg --dearmor > /usr/share/keyrings/mysql.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/mysql.gpg] http://repo.mysql.com/apt/ubuntu $(lsb_release -sc) mysql-8.0" > /etc/apt/sources.list.d/mysql.list

# 4. Install MySQL Router
RUN apt-get update && \
    apt-get install -y mysql-router curl netcat && \
    rm -rf /var/lib/apt/lists/*

# 5. Copy configuration files
COPY mysqlrouter.conf /etc/mysqlrouter/mysqlrouter.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 6446 6447
CMD ["/entrypoint.sh"]