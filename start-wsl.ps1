Write-Host "🏁 Iniciando..."

Write-Host "⏳ Copiando chave SSH"

Copy-Item -Path "./.ssh/id_ed25519*" -Destination "/home/jrangel/.ssh" -Force

& chmod 700 /home/jrangel/.ssh/*

if (-not(Test-Path -Path "/home/jrangel/.ssh/id_ed25519")) {
    Write-Host "⛔ O arquivo não foi copiado."
    Exit
}

Write-Host "✅ Arquivos copiados"

Write-Host "⏳ Criando Servidor na Digital Ocean"

Set-Location "./terraform"

terraform init

terraform fmt

terraform validate

terraform apply -auto-approve

$IP = terraform output ip

Set-Location ".."

Write-Host "✅ Servidor criado com sucesso no IP: ${IP}"

Write-Host "⏳ Configurando inventário do Ansible"

Set-Location "./ansible"

$inventario = @"
webservers:
  hosts:
    web1:
      ansible_host: ${IP}
      ansible_user: root
      ansible_ssh_private_key_file: '/home/jrangel/.ssh/id_ed25519'
"@

Set-Content -Path "./inventory.yaml" -Value $inventario -Encoding utf8NoBOM

Write-Host "✅ Inventário configurado"

Write-Host "⏳ Executar o Ansible com WSL..."

$endereco = $IP.Replace('"', '')

ssh-keyscan $endereco >> /home/jrangel/.ssh/known_hosts

ansible-playbook main.yaml -i inventory.yaml

Set-Location ".."

Write-Host "✅ Execução concluída"

Write-Host "http://${endereco}"