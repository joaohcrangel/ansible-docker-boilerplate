FROM ubuntu:latest

ARG IP

USER root

WORKDIR /ansible

RUN apt update -y

RUN apt install ansible ssh-client -y

RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh

RUN echo "Host ${IP}\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config

COPY ./.ssh /root/.ssh

RUN chmod -R 700 /root/.ssh

COPY ./ansible /ansible

CMD ["ansible-playbook", "main.yaml", "-i", "inventory.yaml"]