FROM tomcat:9

COPY jmx_prometheus_javaagent.jar /opt/jmx_prometheus_javaagent.jar

COPY config.yaml /opt/config.yaml

# Eliminar archivos default de Tomcat para que index.jsp tome prioridad
RUN rm -rf /usr/local/tomcat/webapps/ROOT/*

COPY index.jsp /usr/local/tomcat/webapps/ROOT/index.jsp

ENV CATALINA_OPTS="-javaagent:/opt/jmx_prometheus_javaagent.jar=9404:/opt/config.yaml"