FROM python:2.7

LABEL maintainer="samuel.gratzl@datavisyn.io"
LABEL description="This is a base image for phovea server docker images (dev version)" 
LABEL vendor="The Caleydo Team"
LABEL version="2018.04"

# install node
# install openssh-server for python debugging
# Fix up SSH, probably should rip this out in real deploy situations.
# SSH login fix. Otherwise user is kicked off after login
ENV NOTVISIBLE "in users profile"
# Expose SSH on 22, but this gets mapped to some other address.
EXPOSE 22
RUN (curl -sL https://deb.nodesource.com/setup_6.x | bash - ) \
  && apt-get install -y nodejs openssh-server \
  && mkdir -p /var/run/sshd \
  && echo 'root:docker' | chpasswd \
  && sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
  && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd  \
  && echo "export VISIBLE=now" >> /etc/profile

COPY requirements*.txt docker_packages.txt ./
RUN (!(test -s docker_packages.txt) || (apt-get update && (cat docker_packages.txt | xargs apt-get install -y))) && pip install --no-cache-dir -r requirements.txt && pip install --no-cache-dir -r requirements_dev.txt