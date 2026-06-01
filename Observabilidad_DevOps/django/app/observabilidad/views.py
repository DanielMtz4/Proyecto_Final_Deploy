from django.shortcuts import render


def home(request):
    """Vista principal del dashboard de observabilidad"""
    context = {
        'services': [
            {
                'name': 'Django',
                'description': 'Framework web Python con django-prometheus integrado',
                'icon': 'django',
                'color': 'primary'
            },
            {
                'name': 'Tomcat',
                'description': 'Servidor de aplicaciones Java monitoreado',
                'icon': 'tomcat',
                'color': 'warning'
            },
            {
                'name': 'MariaDB',
                'description': 'Base de datos relacional con MariaDB Exporter',
                'icon': 'database',
                'color': 'danger'
            },
            {
                'name': 'WordPress',
                'description': 'Plataforma de contenido integrada',
                'icon': 'wordpress',
                'color': 'success'
            },
            {
                'name': 'Prometheus',
                'description': 'Sistema de monitoreo y almacenamiento de series temporales',
                'icon': 'prometheus',
                'color': 'info'
            },
            {
                'name': 'Grafana',
                'description': 'Visualización y análisis de métricas en tiempo real',
                'icon': 'chart-line',
                'color': 'success'
            },
            {
                'name': 'Alertmanager',
                'description': 'Gestión y enrutamiento de alertas',
                'icon': 'bell',
                'color': 'danger'
            },
        ],
        'architecture_flow': [
            {'step': '1', 'service': 'Docker', 'description': 'Contenedores aislados'},
            {'step': '2', 'service': 'Prometheus', 'description': 'Scraping de métricas'},
            {'step': '3', 'service': 'Grafana', 'description': 'Visualización'},
            {'step': '4', 'service': 'Alertmanager', 'description': 'Alertas automáticas'},
        ],
        'technologies': [
            {'category': 'Infraestructura', 'items': ['Docker', 'Docker Compose']},
            {'category': 'Monitoreo', 'items': ['Prometheus', 'Grafana', 'Alertmanager']},
            {'category': 'Exportadores', 'items': ['Node Exporter', 'cAdvisor', 'MariaDB Exporter', 'django-prometheus']},
            {'category': 'Stack Web', 'items': ['Django', 'Apache', 'Tomcat', 'WordPress']},
        ]
    }
    return render(request, 'home.html', context)
