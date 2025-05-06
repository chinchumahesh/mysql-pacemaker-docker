```markdown
# MySQL High Availability Cluster with Pacemaker, HAProxy, and MySQL Router

A Docker-based setup for a self-healing MySQL cluster with automated failover, read-write splitting, and load balancing.

![Architecture Diagram](https://i.imgur.com/mJkLd7g.png)

## 📋 Features
- **Automatic Failover**: Pacemaker/Corosync promotes a new primary node if the current one fails.
- **Read-Write Splitting**: HAProxy routes writes to the primary node and load-balances reads across replicas.
- **GTID-Based Replication**: Ensures data consistency across nodes.
- **VIP Management**: Floating IP (`192.168.100.100`) for seamless failover.
- **Health Checks**: Built-in monitoring for MySQL nodes and HAProxy.

## 🏗️ Architecture
| Component               | Role                                                                 |
|-------------------------|----------------------------------------------------------------------|
| **MySQL Primary**       | Handles write operations (`INSERT`, `UPDATE`, `DELETE`).            |
| **MySQL Replicas**      | Read-only copies of the primary (load-balanced for reads).          |
| **Pacemaker/Corosync**  | Cluster manager that monitors nodes and triggers failovers.         |
| **HAProxy**             | Routes traffic: `3306` (writes) → Primary, `3307` (reads) → Replicas. |
| **MySQL Router**        | Alternative to HAProxy for advanced read-write splitting.            |
| **Virtual IP (VIP)**    | Floating IP (`192.168.100.100`) that points to the active primary.   |

## ⚙️ Prerequisites
- Docker 20.10+
- Docker Compose 1.29+
- 4GB+ RAM (Recommended)

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/your-username/mysql-ha-cluster.git
cd mysql-ha-cluster
```

### 2. Configure Environment Variables
Create a `.env` file:
```bash
cp .env.example .env
```
Edit `.env` to set MySQL credentials and IPs:
```ini
MYSQL_ROOT_PASSWORD=your_secure_password
MYSQL_REPL_USER=repl_user
MYSQL_REPL_PASSWORD=repl_password
```

### 3. Start the Cluster
```bash
docker-compose up -d
```

## 🛠️ Directory Structure
```
.
├── docker-compose.yml
├── haproxy/
│   ├── Dockerfile
│   ├── haproxy.cfg
│   └── scripts/
├── mysql/
│   ├── master/
│   │   ├── Dockerfile
│   │   └── my.cnf
│   └── slave/
│       ├── Dockerfile
│       └── my.cnf
├── pacemaker/
│   ├── Dockerfile
│   ├── corosync.conf
│   └── pcs-config.sh
└── mysql-router/
    ├── Dockerfile
    └── mysqlrouter.conf
```

## 🔍 Monitoring
### Check Cluster Status
```bash
docker exec -it pacemaker-node crm status
```

### View HAProxy Stats
Access `http://localhost:8404/admin?stats` for real-time metrics.

### Verify Replication
```bash
docker exec -it mysql-master mysql -uroot -p -e "SHOW REPLICAS;"
```

## 🚨 Troubleshooting
### Common Issues
| Error                          | Solution                                  |
|--------------------------------|-------------------------------------------|
| VIP not failing over           | Check Pacemaker logs: `docker logs pacemaker-node` |
| Replication broken             | Run `docker exec mysql-slave mysql -uroot -p -e "START REPLICA;"` |
| HAProxy not routing traffic    | Verify `haproxy.cfg` and check ports with `netstat -tulpn` |

### View Logs
```bash
docker-compose logs mysql-master
docker-compose logs haproxy
```

## 📚 FAQ
### Q: How do I manually promote a replica to primary?
```bash
docker exec -it pacemaker-node pcs resource move mysql-master
```

### Q: How to scale read replicas?
Update `docker-compose.yml` and add:
```yaml
mysql-slave3:
  build: ./mysql/slave
  environment:
    MYSQL_MASTER_HOST: mysql-master
  networks:
    mysql_net:
      ipv4_address: 192.168.100.5
```

## 🤝 Contributing
1. Fork the repository.
2. Create a feature branch: `git checkout -b feature/new-feature`.
3. Commit changes: `git commit -m 'Add new feature'`.
4. Push to the branch: `git push origin feature/new-feature`.
5. Open a pull request.

## 📜 License
MIT License. See [LICENSE](LICENSE) for details.
```

---

### Key Features:
- **Beginner-Friendly**: Step-by-step setup instructions.
- **Visual Architecture**: Clear diagram and component explanations.
- **Troubleshooting Guide**: Quick fixes for common issues.
- **Extensible**: Easy to add more replicas or customize configurations.

### Preview:
![README Preview](https://i.imgur.com/xyz123.png)

Adjust IPs, passwords, and repository URLs to match your setup. Add badges (e.g., Docker, MySQL) for better visibility! 🚀