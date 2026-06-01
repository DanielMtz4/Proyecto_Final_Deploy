-- Bases de datos para el stack de observabilidad
CREATE DATABASE IF NOT EXISTS observabilidad;
CREATE DATABASE IF NOT EXISTS wordpress_db;

-- Usuario para el exporter de Prometheus (acceso mínimo de solo lectura)
CREATE USER IF NOT EXISTS 'exporter'@'%' IDENTIFIED BY 'exporterpass';
GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'exporter'@'%';
FLUSH PRIVILEGES;
