-- Usuario con permisos mínimos para el exporter de Prometheus (mysqld_exporter)
-- Ejecutar una sola vez en MariaDB antes de levantar mariadb_exporter
-- Este script también se ejecuta automáticamente desde mariadb/init.sql al primer arranque

CREATE USER IF NOT EXISTS 'exporter'@'%' IDENTIFIED BY 'exporterpass';
GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'exporter'@'%';
FLUSH PRIVILEGES;
