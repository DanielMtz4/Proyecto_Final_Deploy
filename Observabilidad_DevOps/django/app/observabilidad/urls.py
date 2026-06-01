from django.contrib import admin
from django.urls import path, include
from . import views


urlpatterns = [
    path('admin/', admin.site.urls),
    path('', views.home, name='home'),  # Vista principal del dashboard
    path('', include('django_prometheus.urls')),  # Agrega las URLs de Prometheus (/metrics, etc.)
]
