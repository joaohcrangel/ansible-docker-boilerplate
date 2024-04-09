$secureString = Read-Host -Prompt "Digite seu token da Digital Ocean" -AsSecureString

# Passo 1: Converter SecureString para ponteiro
$ptr = [System.Runtime.InteropServices.Marshal]::SecureStringToGlobalAllocUnicode($secureString)

try {
    # Passo 2: Converter ponteiro para string em texto plano
    $token = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($ptr)
} finally {
    # Limpar o ponteiro da memória para manter a segurança
    [System.Runtime.InteropServices.Marshal]::ZeroFreeGlobalAllocUnicode($ptr)
}

[System.Environment]::SetEnvironmentVariable("DIGITALOCEAN_ACCESS_TOKEN", $token, [System.EnvironmentVariableTarget]::User)

Write-Host "☑️ Token salvo com sucesso na variável de ambiente do seu usuário."

Write-Host "Iniciou a configuração to terraform..."

$terraformURL = "https://releases.hashicorp.com/terraform/1.7.5/terraform_1.7.5_windows_386.zip"
$toolsPath = "C:\Tools"
$fileName = "terraform.zip"

if (-not (Test-Path -Path $toolsPath)) {
    Write-Host "O diretório $toolsPath não existe"
    New-Item -ItemType Directory -Path $toolsPath
    Write-Host "Diretório $toolsPath criado com sucesso!"
}

Write-Host "Inciando download do Terraform..."
Invoke-WebRequest $terraformURL -OutFile "$toolsPath\$fileName"
Write-Host "Download concluído!"

Expand-Archive -Path "$toolsPath\$fileName" -DestinationPath $toolsPath -Force
Write-Host "O arquivo foi extraído"

Remove-Item -Path "$toolsPath\$fileName"
Write-Host "Arquivo zip excluído"

$currentPath = [System.Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::Machine)
Write-Host "Obtemos a variável de ambiente PATH"

[System.Environment]::SetEnvironmentVariable("PATH", "$currentPath;$toolsPath", [System.EnvironmentVariableTarget]::Machine)
Write-Host "Definimos a variável de ambiente PATH"

Write-Host "☑️ Configuração foi concluída com sucesso!"