FROM python:3.7

LABEL maintainer="contact@caleydo.org"
LABEL description="This is a base image for phovea server docker images" 
LABEL vendor="The Caleydo Team"
LABEL version="2.0"


COPY requirements*.txt docker_packages.txt ./
RUN (!(test -s docker_packages.txt) || (apt-get update && (cat docker_packages.txt | xargs apt-get install -y))) && pip install --no-cache-dir -r requirements.txt