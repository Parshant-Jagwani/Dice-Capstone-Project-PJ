FROM python:3.9.18-slim-bullseye

WORKDIR /app

COPY server.py server.py
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

VOLUME /serverdata

CMD ["python", "server.py"]