FROM python:3.12

RUN apt-get update && \
    apt-get install -y apache2 apache2-dev gcc

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

WORKDIR /app

COPY app/ .

RUN django-admin startproject observabilidad .

EXPOSE 80

CMD ["apachectl", "-D", "FOREGROUND"]