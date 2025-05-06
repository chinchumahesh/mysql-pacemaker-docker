# Use the official HAProxy Alpine image
FROM haproxy:2.8-alpine

# Temporarily switch to root for package installation
USER root

# Install dependencies
RUN apk update && \
    apk add --no-cache curl netcat-openbsd

# Switch back to the haproxy user
USER haproxy

# Copy configuration files
COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
COPY conf.d/ /etc/haproxy/conf.d/

# # Copy healthcheck script
# COPY scripts/healthcheck.sh /usr/local/bin/healthcheck.sh
# RUN chmod +x /usr/local/bin/healthcheck.sh

# Expose ports
EXPOSE 3306 3307 8404

# Healthcheck
HEALTHCHECK --interval=10s --timeout=5s --retries=3 \
  CMD /usr/local/bin/healthcheck.sh

# Start HAProxy
CMD ["haproxy", "-f", "/usr/local/etc/haproxy/haproxy.cfg"]