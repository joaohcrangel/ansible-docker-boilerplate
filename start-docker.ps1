Write-Host "🏁 Iniciando..."

Write-Host "⏳ Criando Servidor na Digital Ocean"

Set-Location ".\terraform"

terraform init

terraform fmt

terraform validate

terraform apply -auto-approve

$IP = terraform output ip

Set-Location ".."

Write-Host "✅ Servidor criado com sucesso no IP: ${IP}"

Write-Host "⏳ Configurando inventário do Ansible"

Set-Location ".\ansible"

$inventario = @"
webservers:
  hosts:
    web1:
      ansible_host: ${IP}
      ansible_user: root
      ansible_ssh_private_key_file: '~/.ssh/id_ed25519'
"@

Set-Content -Path ".\inventory.yaml" -Value $inventario -Encoding utf8NoBOM

Set-Location ".."

Write-Host "✅ Inventário configurado"

Write-Host "⏳ Executar o Ansible com Docker..."

docker build -t ansible --build-arg IP=${IP} .

docker run --rm --name ansible ansible:latest

Write-Host "✅ Execução concluída"

$endereco = $IP.Replace('"', '')

curl "http://${endereco}"