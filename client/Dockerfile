FROM python:3.9.18-slim-bullseye

WORKDIR /app

COPY client.py client.py
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

VOLUME /clientdata

CMD ["python", "client.py"]