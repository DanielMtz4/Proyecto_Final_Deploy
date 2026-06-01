<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.lang.management.*" %>
<%@ page import="java.util.*" %>
<%
    // Obtener información de la JVM
    OperatingSystemMXBean osBean = ManagementFactory.getOperatingSystemMXBean();
    MemoryMXBean memBean = ManagementFactory.getMemoryMXBean();
    RuntimeMXBean runtimeBean = ManagementFactory.getRuntimeMXBean();
    ThreadMXBean threadBean = ManagementFactory.getThreadMXBean();
    
    // Métricas
    long heapUsed = memBean.getHeapMemoryUsage().getUsed();
    long heapMax = memBean.getHeapMemoryUsage().getMax();
    long nonHeapUsed = memBean.getNonHeapMemoryUsage().getUsed();
    double cpuUsage = osBean.getProcessCpuLoad() * 100;
    int threadCount = threadBean.getThreadCount();
    long uptime = runtimeBean.getUptime();
    
    // Conversiones
    long heapUsedMB = heapUsed / (1024 * 1024);
    long heapMaxMB = heapMax / (1024 * 1024);
    long nonHeapUsedMB = nonHeapUsed / (1024 * 1024);
    double heapPercent = (heapUsed * 100.0) / heapMax;
    
    // Uptime format
    long days = uptime / (1000 * 60 * 60 * 24);
    long hours = (uptime % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60);
    long minutes = (uptime % (1000 * 60 * 60)) / (1000 * 60);
    
    // Fecha del servidor
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    String serverTime = sdf.format(new Date());
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Servidor Tomcat Monitoreado - Observabilidad DevOps</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #0d6efd;
            --dark-bg: #0f172a;
            --card-bg: #1e293b;
            --text-light: #e2e8f0;
            --accent-blue: #3b82f6;
            --accent-orange: #f97316;
        }

        * {
            scroll-behavior: smooth;
        }

        body {
            background: linear-gradient(135deg, var(--dark-bg) 0%, #1e3a8a 100%);
            color: var(--text-light);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
        }

        /* Navbar */
        .navbar {
            background: rgba(15, 23, 42, 0.95) !important;
            border-bottom: 2px solid var(--accent-blue);
            backdrop-filter: blur(10px);
        }

        .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
            background: linear-gradient(135deg, var(--accent-orange), #ec4899);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        /* Hero Section */
        .hero-section {
            padding: 4rem 0;
            text-align: center;
            background: linear-gradient(180deg, rgba(59, 130, 246, 0.15) 0%, rgba(15, 23, 42, 0) 100%);
        }

        .hero-title {
            font-size: 3.5rem;
            font-weight: 800;
            margin-bottom: 1rem;
            background: linear-gradient(135deg, var(--accent-orange), #f97316);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .hero-subtitle {
            font-size: 1.3rem;
            color: #cbd5e1;
            margin-bottom: 2rem;
        }

        /* Info Cards */
        .info-badge {
            display: inline-block;
            background: rgba(59, 130, 246, 0.2);
            border: 1px solid var(--accent-blue);
            color: var(--accent-blue);
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            margin: 0.25rem;
        }

        .metric-card {
            background: var(--card-bg);
            border: 1px solid rgba(59, 130, 246, 0.3);
            border-radius: 15px;
            padding: 2rem;
            transition: all 0.3s ease;
            height: 100%;
            display: flex;
            flex-direction: column;
            backdrop-filter: blur(10px);
        }

        .metric-card:hover {
            transform: translateY(-10px);
            border-color: var(--accent-blue);
            box-shadow: 0 20px 40px rgba(59, 130, 246, 0.2);
        }

        .metric-icon {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            min-height: 3rem;
        }

        .metric-title {
            font-size: 1.1rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            color: white;
        }

        .metric-value {
            font-size: 2rem;
            font-weight: 800;
            color: var(--accent-blue);
            margin: 0.5rem 0;
        }

        .metric-unit {
            font-size: 0.9rem;
            color: #cbd5e1;
        }

        /* Progress Bar */
        .metric-bar {
            background: rgba(59, 130, 246, 0.1);
            border-radius: 10px;
            height: 8px;
            margin-top: 0.5rem;
            overflow: hidden;
        }

        .metric-bar-fill {
            background: linear-gradient(90deg, var(--accent-blue), var(--accent-orange));
            height: 100%;
            border-radius: 10px;
            transition: width 0.3s ease;
        }

        /* Service Cards */
        .service-card {
            background: var(--card-bg);
            border: 1px solid rgba(59, 130, 246, 0.3);
            border-radius: 15px;
            padding: 2rem;
            transition: all 0.3s ease;
            height: 100%;
            display: flex;
            flex-direction: column;
            backdrop-filter: blur(10px);
            text-decoration: none;
            color: inherit;
        }

        .service-card:hover {
            transform: translateY(-10px);
            border-color: var(--accent-orange);
            box-shadow: 0 20px 40px rgba(249, 115, 22, 0.2);
        }

        .service-icon {
            font-size: 3rem;
            margin-bottom: 1.5rem;
            min-height: 4rem;
        }

        .service-name {
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            color: white;
        }

        .service-description {
            font-size: 0.95rem;
            color: #cbd5e1;
            margin-bottom: 1.5rem;
            flex-grow: 1;
        }

        .service-status {
            display: inline-block;
            background: linear-gradient(135deg, var(--accent-orange), #f97316);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
        }

        /* Section Headers */
        .section-header {
            position: relative;
            padding-bottom: 1.5rem;
            margin-bottom: 3rem;
        }

        .section-header h2 {
            font-size: 2.5rem;
            font-weight: 800;
            margin-bottom: 0.5rem;
            background: linear-gradient(135deg, var(--accent-orange), #f97316);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .section-header .underline {
            width: 60px;
            height: 4px;
            background: linear-gradient(90deg, var(--accent-orange), #f97316);
            border-radius: 2px;
            margin-top: 1rem;
        }

        /* Architecture Section */
        .architecture-container {
            background: var(--card-bg);
            border: 1px solid rgba(59, 130, 246, 0.3);
            border-radius: 15px;
            padding: 3rem;
            backdrop-filter: blur(10px);
        }

        .architecture-flow {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 2rem;
        }

        .flow-item {
            flex: 1;
            min-width: 180px;
            text-align: center;
        }

        .flow-step {
            width: 70px;
            height: 70px;
            background: linear-gradient(135deg, var(--accent-orange), #f97316);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            font-weight: 700;
            margin: 0 auto 1rem;
            box-shadow: 0 10px 30px rgba(249, 115, 22, 0.3);
        }

        .flow-service {
            font-size: 1.3rem;
            font-weight: 700;
            color: white;
            margin-bottom: 0.5rem;
        }

        .flow-description {
            font-size: 0.9rem;
            color: #cbd5e1;
        }

        .flow-arrow {
            font-size: 2rem;
            color: var(--accent-orange);
            align-self: center;
        }

        @media (max-width: 768px) {
            .flow-arrow {
                display: none;
            }

            .architecture-flow {
                flex-direction: column;
            }

            .hero-title {
                font-size: 2.5rem;
            }
        }

        /* Status Section */
        .status-section {
            background: rgba(249, 115, 22, 0.1);
            border: 1px solid rgba(249, 115, 22, 0.3);
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
        }

        .status-item {
            display: flex;
            align-items: center;
            padding: 0.5rem 0;
        }

        .status-icon {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 1rem;
            background: linear-gradient(135deg, var(--accent-orange), #f97316);
            color: white;
            font-size: 0.8rem;
            font-weight: 700;
        }

        /* Footer */
        .footer {
            border-top: 1px solid rgba(59, 130, 246, 0.3);
            padding: 2rem 0;
            margin-top: 4rem;
            text-align: center;
            color: #cbd5e1;
        }

        /* Animations */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .metric-card {
            animation: fadeInUp 0.6s ease forwards;
        }

        .metric-card:nth-child(1) { animation-delay: 0.1s; }
        .metric-card:nth-child(2) { animation-delay: 0.2s; }
        .metric-card:nth-child(3) { animation-delay: 0.3s; }
        .metric-card:nth-child(4) { animation-delay: 0.4s; }
        .metric-card:nth-child(5) { animation-delay: 0.5s; }

        .service-card {
            animation: fadeInUp 0.6s ease forwards;
        }

        .service-card:nth-child(1) { animation-delay: 0.1s; }
        .service-card:nth-child(2) { animation-delay: 0.2s; }
        .service-card:nth-child(3) { animation-delay: 0.3s; }
        .service-card:nth-child(4) { animation-delay: 0.4s; }
        .service-card:nth-child(5) { animation-delay: 0.5s; }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark sticky-top">
        <div class="container-lg">
            <a class="navbar-brand" href="#">
                <i class="fas fa-server"></i> Tomcat Monitoreado
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="#metricas">Métricas</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#servicios">Servicios</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#arquitectura">Arquitectura</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="http://localhost:9404" target="_blank">
                            <i class="fas fa-external-link-alt"></i> JMX Exporter
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero-section">
        <div class="container-lg">
            <h1 class="hero-title">
                <i class="fas fa-server"></i> Servidor Tomcat Monitoreado
            </h1>
            <p class="hero-subtitle">Proyecto Final de Observabilidad y DevOps</p>
            <div>
                <span class="info-badge"><i class="fas fa-check-circle"></i> JVM Monitoring Activo</span>
                <span class="info-badge"><i class="fas fa-chart-line"></i> JMX Exporter Conectado</span>
                <span class="info-badge"><i class="fas fa-heartbeat"></i> Estado Operacional</span>
            </div>
        </div>
    </section>

    <!-- Main Content -->
    <main class="container-lg py-5">
        <!-- Status Section -->
        <div class="status-section">
            <h5 style="color: white; margin-bottom: 1.5rem;">
                <i class="fas fa-circle-check"></i> Estado del Servidor
            </h5>
            <div class="row">
                <div class="col-md-6">
                    <div class="status-item">
                        <div class="status-icon"><i class="fas fa-server"></i></div>
                        <div>
                            <strong>Servidor Tomcat 9</strong>
                            <div style="font-size: 0.85rem; color: #cbd5e1;">En ejecución</div>
                        </div>
                    </div>
                    <div class="status-item">
                        <div class="status-icon"><i class="fas fa-database"></i></div>
                        <div>
                            <strong>JMX Exporter</strong>
                            <div style="font-size: 0.85rem; color: #cbd5e1;">Puerto 9404</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="status-item">
                        <div class="status-icon"><i class="fas fa-clock"></i></div>
                        <div>
                            <strong>Hora del Servidor</strong>
                            <div style="font-size: 0.85rem; color: #cbd5e1;"><%= serverTime %></div>
                        </div>
                    </div>
                    <div class="status-item">
                        <div class="status-icon"><i class="fas fa-hourglass-end"></i></div>
                        <div>
                            <strong>Uptime</strong>
                            <div style="font-size: 0.85rem; color: #cbd5e1;"><%= days %>d <%= hours %>h <%= minutes %>m</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Metricas JVM Section -->
        <section id="metricas">
            <div class="section-header">
                <h2><i class="fas fa-chart-bar"></i> Métricas JVM en Tiempo Real</h2>
                <div class="underline"></div>
            </div>
            <div class="row g-4 mb-5">
                <!-- Heap Memory -->
                <div class="col-lg-4 col-md-6">
                    <div class="metric-card">
                        <div class="metric-icon">
                            <i class="fas fa-memory" style="color: var(--accent-blue);"></i>
                        </div>
                        <div class="metric-title">Memoria Heap</div>
                        <div class="metric-value"><%= heapUsedMB %> MB</div>
                        <div class="metric-unit">de <%= heapMaxMB %> MB disponibles</div>
                        <div class="metric-bar">
                            <div class="metric-bar-fill" style="width: <%= (int)heapPercent %>%"></div>
                        </div>
                        <small style="color: #cbd5e1; margin-top: 0.5rem;">Uso: <%= String.format("%.1f%%", heapPercent) %></small>
                    </div>
                </div>

                <!-- Non-Heap Memory -->
                <div class="col-lg-4 col-md-6">
                    <div class="metric-card">
                        <div class="metric-icon">
                            <i class="fas fa-microchip" style="color: var(--accent-orange);"></i>
                        </div>
                        <div class="metric-title">Memoria No-Heap</div>
                        <div class="metric-value"><%= nonHeapUsedMB %> MB</div>
                        <div class="metric-unit">Metaspace, Code Cache, etc.</div>
                        <div class="metric-bar">
                            <div class="metric-bar-fill" style="width: <%= Math.min(nonHeapUsedMB / 128, 100) %>%"></div>
                        </div>
                        <small style="color: #cbd5e1; margin-top: 0.5rem;">Infraestructura</small>
                    </div>
                </div>

                <!-- CPU Usage -->
                <div class="col-lg-4 col-md-6">
                    <div class="metric-card">
                        <div class="metric-icon">
                            <i class="fas fa-processor" style="color: var(--accent-orange);"></i>
                        </div>
                        <div class="metric-title">Uso de CPU</div>
                        <div class="metric-value"><%= String.format("%.1f%%", cpuUsage) %></div>
                        <div class="metric-unit">del proceso Tomcat</div>
                        <div class="metric-bar">
                            <div class="metric-bar-fill" style="width: <%= (int)cpuUsage %>%"></div>
                        </div>
                        <small style="color: #cbd5e1; margin-top: 0.5rem;">En tiempo real</small>
                    </div>
                </div>

                <!-- Threads -->
                <div class="col-lg-4 col-md-6">
                    <div class="metric-card">
                        <div class="metric-icon">
                            <i class="fas fa-sitemap" style="color: var(--accent-blue);"></i>
                        </div>
                        <div class="metric-title">Threads JVM</div>
                        <div class="metric-value"><%= threadCount %></div>
                        <div class="metric-unit">threads activos</div>
                        <div class="metric-bar">
                            <div class="metric-bar-fill" style="width: <%= Math.min((threadCount / 200.0) * 100, 100) %>%"></div>
                        </div>
                        <small style="color: #cbd5e1; margin-top: 0.5rem;">Concurrencia</small>
                    </div>
                </div>

                <!-- Garbage Collector -->
                <div class="col-lg-4 col-md-6">
                    <div class="metric-card">
                        <div class="metric-icon">
                            <i class="fas fa-trash-alt" style="color: var(--accent-orange);"></i>
                        </div>
                        <div class="metric-title">Garbage Collector</div>
                        <div class="metric-value"><%= ManagementFactory.getGarbageCollectorMXBeans().size() %></div>
                        <div class="metric-unit">recolectores activos</div>
                        <div class="metric-bar">
                            <div class="metric-bar-fill" style="width: 100%"></div>
                        </div>
                        <small style="color: #cbd5e1; margin-top: 0.5rem;">Limpieza de memoria</small>
                    </div>
                </div>

                <!-- Server Status -->
                <div class="col-lg-4 col-md-6">
                    <div class="metric-card">
                        <div class="metric-icon">
                            <i class="fas fa-heartbeat" style="color: #10b981;"></i>
                        </div>
                        <div class="metric-title">Estado del Servidor</div>
                        <div class="metric-value"><span style="color: #10b981;">ACTIVO</span></div>
                        <div class="metric-unit">Tomcat 9 en ejecución</div>
                        <div class="metric-bar">
                            <div class="metric-bar-fill" style="width: 100%; background: linear-gradient(90deg, #10b981, #34d399);"></div>
                        </div>
                        <small style="color: #cbd5e1; margin-top: 0.5rem;">Operacional</small>
                    </div>
                </div>
            </div>
        </section>

        <!-- Servicios Section -->
        <section id="servicios">
            <div class="section-header">
                <h2><i class="fas fa-cube"></i> Componentes de Monitoreo</h2>
                <div class="underline"></div>
            </div>
            <div class="row g-4 mb-5">
                <!-- JVM Monitoring -->
                <div class="col-lg-4 col-md-6">
                    <div class="service-card">
                        <div class="service-icon">
                            <i class="fas fa-java" style="color: var(--accent-orange);"></i>
                        </div>
                        <h3 class="service-name">JVM Monitoring</h3>
                        <p class="service-description">Monitoreo completo de la máquina virtual Java incluyendo memoria, threads, y garbage collector.</p>
                        <span class="service-status">
                            <i class="fas fa-check-circle"></i> Monitorizado
                        </span>
                    </div>
                </div>

                <!-- JMX Exporter -->
                <div class="col-lg-4 col-md-6">
                    <div class="service-card">
                        <div class="service-icon">
                            <i class="fas fa-exchange-alt" style="color: var(--accent-blue);"></i>
                        </div>
                        <h3 class="service-name">JMX Exporter</h3>
                        <p class="service-description">Exporta métricas JMX a formato Prometheus en el puerto 9404.</p>
                        <span class="service-status">
                            <i class="fas fa-check-circle"></i> Monitorizado
                        </span>
                    </div>
                </div>

                <!-- Prometheus -->
                <div class="col-lg-4 col-md-6">
                    <div class="service-card">
                        <div class="service-icon">
                            <i class="fas fa-fire" style="color: var(--accent-orange);"></i>
                        </div>
                        <h3 class="service-name">Prometheus</h3>
                        <p class="service-description">Sistema de monitoreo que recopila métricas de JMX Exporter cada 15 segundos.</p>
                        <span class="service-status">
                            <i class="fas fa-check-circle"></i> Monitorizado
                        </span>
                    </div>
                </div>

                <!-- Grafana -->
                <div class="col-lg-4 col-md-6">
                    <div class="service-card">
                        <div class="service-icon">
                            <i class="fas fa-chart-line" style="color: #10b981;"></i>
                        </div>
                        <h3 class="service-name">Grafana</h3>
                        <p class="service-description">Visualización avanzada de métricas con dashboards interactivos en tiempo real.</p>
                        <span class="service-status">
                            <i class="fas fa-check-circle"></i> Monitorizado
                        </span>
                    </div>
                </div>

                <!-- Alertmanager -->
                <div class="col-lg-4 col-md-6">
                    <div class="service-card">
                        <div class="service-icon">
                            <i class="fas fa-bell" style="color: var(--accent-orange);"></i>
                        </div>
                        <h3 class="service-name">Alertmanager</h3>
                        <p class="service-description">Gestión de alertas automáticas basadas en reglas de Prometheus.</p>
                        <span class="service-status">
                            <i class="fas fa-check-circle"></i> Monitorizado
                        </span>
                    </div>
                </div>

                <!-- Docker -->
                <div class="col-lg-4 col-md-6">
                    <div class="service-card">
                        <div class="service-icon">
                            <i class="fab fa-docker" style="color: #3b82f6;"></i>
                        </div>
                        <h3 class="service-name">Docker Container</h3>
                        <p class="service-description">Contenedor Docker con Tomcat 9 y JMX Exporter preconfigurado.</p>
                        <span class="service-status">
                            <i class="fas fa-check-circle"></i> Monitorizado
                        </span>
                    </div>
                </div>
            </div>
        </section>

        <!-- Arquitectura Section -->
        <section id="arquitectura" class="py-5">
            <div class="section-header">
                <h2><i class="fas fa-sitemap"></i> Arquitectura de Monitoreo</h2>
                <div class="underline"></div>
            </div>
            <div class="architecture-container">
                <div class="architecture-flow">
                    <div class="flow-item">
                        <div class="flow-step">
                            <i class="fas fa-java"></i>
                        </div>
                        <div class="flow-service">Aplicación Java</div>
                        <div class="flow-description">Tomcat + JMX</div>
                    </div>
                    <div class="flow-arrow">
                        <i class="fas fa-arrow-right"></i>
                    </div>
                    <div class="flow-item">
                        <div class="flow-step">
                            <i class="fas fa-exchange-alt"></i>
                        </div>
                        <div class="flow-service">JMX Exporter</div>
                        <div class="flow-description">Puerto 9404</div>
                    </div>
                    <div class="flow-arrow">
                        <i class="fas fa-arrow-right"></i>
                    </div>
                    <div class="flow-item">
                        <div class="flow-step">
                            <i class="fas fa-fire"></i>
                        </div>
                        <div class="flow-service">Prometheus</div>
                        <div class="flow-description">Recopilación</div>
                    </div>
                    <div class="flow-arrow">
                        <i class="fas fa-arrow-right"></i>
                    </div>
                    <div class="flow-item">
                        <div class="flow-step">
                            <i class="fas fa-chart-line"></i>
                        </div>
                        <div class="flow-service">Grafana</div>
                        <div class="flow-description">Visualización</div>
                    </div>
                    <div class="flow-arrow">
                        <i class="fas fa-arrow-right"></i>
                    </div>
                    <div class="flow-item">
                        <div class="flow-step">
                            <i class="fas fa-bell"></i>
                        </div>
                        <div class="flow-service">Alertmanager</div>
                        <div class="flow-description">Alertas</div>
                    </div>
                </div>
                <div style="margin-top: 2rem; padding-top: 2rem; border-top: 1px solid rgba(249, 115, 22, 0.3);">
                    <p style="color: #cbd5e1; margin: 0; line-height: 1.8;">
                        <strong style="color: white;">Flujo de monitoreo:</strong> La aplicación Java ejecuta en Tomcat con JMX habilitado. 
                        El JMX Exporter, configurado como javaagent, expone las métricas JVM en formato Prometheus. 
                        Prometheus realiza scraping de estas métricas cada 15 segundos. 
                        Grafana consume los datos de Prometheus para crear dashboards en tiempo real. 
                        Alertmanager gestiona las alertas basadas en reglas definidas en Prometheus cuando se exceden umbrales.
                    </p>
                </div>
            </div>
        </section>

        <!-- Technical Details -->
        <section class="py-5">
            <div class="section-header">
                <h2><i class="fas fa-cog"></i> Configuración Técnica</h2>
                <div class="underline"></div>
            </div>
            <div class="row g-4">
                <div class="col-lg-6">
                    <div class="metric-card">
                        <h4 style="color: white; margin-bottom: 1rem;">JMX Exporter</h4>
                        <code style="background: rgba(0,0,0,0.3); padding: 1rem; border-radius: 8px; display: block; font-size: 0.85rem; color: #e2e8f0;">
-javaagent:/opt/jmx_prometheus_javaagent.jar=9404:/opt/config.yaml
                        </code>
                        <p style="color: #cbd5e1; margin-top: 1rem; font-size: 0.9rem;">
                            <i class="fas fa-info-circle"></i> Exporta métricas JVM en formato Prometheus
                        </p>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="metric-card">
                        <h4 style="color: white; margin-bottom: 1rem;">Endpoints Disponibles</h4>
                        <div style="font-size: 0.9rem; color: #cbd5e1;">
                            <p><strong style="color: #3b82f6;">JMX Metrics:</strong> http://localhost:9404/metrics</p>
                            <p><strong style="color: var(--accent-orange);">Tomcat Manager:</strong> http://localhost:8080/manager</p>
                            <p><strong style="color: #10b981;">Prometheus:</strong> http://prometheus:9090</p>
                            <p><strong style="color: #ec4899;">Grafana:</strong> http://grafana:3000</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <!-- Footer -->
    <footer class="footer">
        <div class="container-lg">
            <p>&copy; 2026 Proyecto Final de Observabilidad y DevOps | Tomcat 9 + JMX Exporter + Prometheus + Grafana + Alertmanager</p>
            <p style="font-size: 0.9rem; margin-top: 0.5rem;">
                <i class="fas fa-chart-bar"></i> Accede a las métricas JMX en <a href="http://localhost:9404/metrics" target="_blank" style="color: var(--accent-orange); text-decoration: none;">:9404/metrics</a>
            </p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Auto-refresh de métricas
        setTimeout(function() {
            location.reload();
        }, 30000); // Refresca cada 30 segundos

        // Smooth scroll para los enlaces de navegación
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({ behavior: 'smooth', block: 'start' });
                }
            });
        });
    </script>
</body>
</html>
