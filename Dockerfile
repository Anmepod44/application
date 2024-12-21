FROM python:3.9-slim

WORKDIR /application

COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY . /application

EXPOSE 8080

CMD ["python", "main_app.py"]
