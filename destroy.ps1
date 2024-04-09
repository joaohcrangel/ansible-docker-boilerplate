Write-Host "🏁 Iniciando..."

Set-Location "./terraform"

terraform destroy -auto-approve

Set-Location ".."

Write-Host "✅ Execução concluída"