FROM python:slim

WORKDIR /ansible

RUN pip install --no-cache-dir ansible

CMD ["ansible-playbook", "-i", "inventory.yaml", "main.yaml"]