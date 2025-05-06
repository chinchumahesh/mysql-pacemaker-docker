FROM mysql:8.0

# Custom configuration for replica node
COPY my.cnf /etc/mysql/conf.d/
RUN chown -R mysql:mysql /etc/mysql/conf.d/

# Replication credentials
ENV MYSQL_ROOT_PASSWORD=rootpass \
    MYSQL_MASTER_HOST=mysql-master \
    MYSQL_REPL_USER=repl_user \
    MYSQL_REPL_PASSWORD=replpass

# Startup script to configure replication
COPY init-slave.sql /docker-entrypoint-initdb.d/
RUN chmod +x /docker-entrypoint-initdb.d/init-slave.sql

CMD ["mysqld", \
     "--server-id=2", \
     "--log-bin=mysql-bin", \
     "--binlog-format=ROW", \
     "--gtid-mode=ON", \
     "--enforce-gtid-consistency=ON", \
     "--read-only=ON"]