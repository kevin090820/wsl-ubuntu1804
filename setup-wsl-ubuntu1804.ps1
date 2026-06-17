#Requires -RunAsAdministrator

Write-Host "=== 1/8: 检查 WSL 是否已安装 ===" -ForegroundColor Cyan
wsl --set-default-version 2 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "请先运行: wsl --install 并重启电脑" -ForegroundColor Red
    exit 1
}

Write-Host "=== 2/8: 下载乌班图 18.04 根文件系统 ===" -ForegroundColor Cyan
$url = "https://mirrors.tuna.tsinghua.edu.cn/ubuntu-cdimage/ubuntu-base/releases/18.04/release/ubuntu-base-18.04.5-base-amd64.tar.gz"
Write-Host "下载中，请稍候..."
curl.exe -sL -o "$env:USERPROFILE\Downloads\ubuntu-base-18.04.5-base-amd64.tar.gz" $url
if ($LASTEXITCODE -ne 0) {
    Write-Host "下载失败，请检查网络" -ForegroundColor Red
    exit 1
}
Write-Host "下载完成"

Write-Host "=== 3/8: 导入 WSL 实例 ===" -ForegroundColor Cyan
mkdir -Force "$env:USERPROFILE\wsl\Ubuntu-1804" | Out-Null
wsl --import Ubuntu-1804 "$env:USERPROFILE\wsl\Ubuntu-1804" `
  "$env:USERPROFILE\Downloads\ubuntu-base-18.04.5-base-amd64.tar.gz" --version 2
if ($LASTEXITCODE -ne 0) {
    Write-Host "导入失败" -ForegroundColor Red
    exit 1
}

Write-Host "=== 4/8: 更新软件源 ===" -ForegroundColor Cyan
wsl -d Ubuntu-1804 -- apt update -qq
wsl -d Ubuntu-1804 -- apt install -y -qq iputils-ping iproute2 openssh-client openssh-server haveged sshpass

Write-Host "=== 5/8: 配置 SSH ===" -ForegroundColor Cyan
wsl -d Ubuntu-1804 -- sed -i "s/.*PermitRootLogin.*/PermitRootLogin yes/" /etc/ssh/sshd_config
wsl -d Ubuntu-1804 -- bash -c "printf 'UseDNS no\nGSSAPIAuthentication no\n' >> /etc/ssh/sshd_config"

Write-Host "=== 6/8: 配置开机自启 ===" -ForegroundColor Cyan
wsl -d Ubuntu-1804 -- bash -c "printf '[boot]\ncommand = haveged 2>/dev/null\n' > /etc/wsl.conf"

Write-Host "=== 7/8: 重启 WSL 使配置生效 ===" -ForegroundColor Cyan
wsl --shutdown

Write-Host "=== 8/8: 验证 ===" -ForegroundColor Cyan
Start-Sleep -Seconds 2
$ip = wsl -d Ubuntu-1804 -- hostname -I 2>$null
Write-Host "WSL IP: $ip" -ForegroundColor Green

Write-Host ""
Write-Host "安装完成！" -ForegroundColor Green
Write-Host "使用方法: wsl -d Ubuntu-1804 -- ssh 用户名@目标IP" -ForegroundColor Yellow
