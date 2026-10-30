FROM python:3.13-slim
WORKDIR /opt/catalog
COPY catalog.py model-template.json ./
USER 1000:1000
ENTRYPOINT ["python3", "catalog.py"]
