FROM almalinux:8

# Enable High Availability (HA) and EPEL repositories
RUN dnf install -y epel-release dnf-utils \
    && dnf config-manager --set-enabled ha \
    && dnf install -y corosync pacemaker pcs firewalld \
    && dnf clean all

# Copy configuration files and scripts
COPY corosync.conf /etc/corosync/corosync.conf
COPY pcs-config.sh /pcs-config.sh

# Set permissions
RUN chmod +x /pcs-config.sh

CMD ["/usr/sbin/init"]