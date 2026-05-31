FROM python:3.12

RUN apt-get update && apt-get install -y \
    apache2 \
    apache2-dev \
    gcc

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN mod_wsgi-express install-module > /tmp/mod_wsgi.conf

EXPOSE 80

CMD ["mod_wsgi-express", "start-server", "observabilidad/wsgi.py", "--port", "80", "--working-directory", "/app", "--user", "www-data", "--group", "www-data", "--reload-on-changes"]