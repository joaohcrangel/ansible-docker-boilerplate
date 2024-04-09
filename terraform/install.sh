#!/bin/bash
echo "Digite seu token da Digital Ocean: "

read -s userToken

echo "export DIGITALOCEAN_ACCESS_TOKEN='$userToken'" >> ~/.bashrc

source ~/.bashrc

echo "☑️ Token salvo com sucesso na variável de ambiente do seu usuário."

wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update && sudo apt install terraform