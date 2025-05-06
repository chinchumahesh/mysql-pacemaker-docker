FROM mysql:8.0

# Custom configuration for primary node
COPY my.cnf /etc/mysql/conf.d/
RUN chown -R mysql:mysql /etc/mysql/conf.d/

# Initialize replication user and permissions
ENV MYSQL_ROOT_PASSWORD=rootpass \
    MYSQL_REPL_USER=repl_user \
    MYSQL_REPL_PASSWORD=replpass

# Startup script to configure replication
COPY init.sql /docker-entrypoint-initdb.d/
RUN chmod +x /docker-entrypoint-initdb.d/init.sql

CMD ["mysqld", \
     "--server-id=1", \
     "--log-bin=mysql-bin", \
     "--binlog-format=ROW", \
     "--gtid-mode=ON", \
     "--enforce-gtid-consistency=ON", \
     "--read-only=OFF"]