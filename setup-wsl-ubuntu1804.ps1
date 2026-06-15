#Requires -RunAsAdministrator

Write-Host "=== 1/8: 下载乌班图 18.04 根文件系统 ===" -ForegroundColor Cyan
curl.exe -L -o "$env:USERPROFILE\Downloads\ubuntu-base-18.04.5-base-amd64.tar.gz" `
  "https://mirrors.tuna.tsinghua.edu.cn/ubuntu-cdimage/ubuntu-base/releases/18.04/release/ubuntu-base-18.04.5-base-amd64.tar.gz"

Write-Host "=== 2/8: 导入 WSL 实例 ===" -ForegroundColor Cyan
mkdir -Force "$env:USERPROFILE\wsl\Ubuntu-1804" | Out-Null
wsl --import Ubuntu-1804 "$env:USERPROFILE\wsl\Ubuntu-1804" `
  "$env:USERPROFILE\Downloads\ubuntu-base-18.04.5-base-amd64.tar.gz" --version 2

Write-Host "=== 3/8: 更新软件源 ===" -ForegroundColor Cyan
wsl -d Ubuntu-1804 -- apt update

Write-Host "=== 4/8: 安装软件包 ===" -ForegroundColor Cyan
wsl -d Ubuntu-1804 -- apt install -y iputils-ping iproute2 openssh-client openssh-server haveged sshpass

Write-Host "=== 5/8: 配置 SSH ===" -ForegroundColor Cyan
wsl -d Ubuntu-1804 -- sed -i "s/^#\?PermitRootLogin.*/PermitRootLogin yes/" /etc/ssh/sshd_config
wsl -d Ubuntu-1804 -- bash -c "echo UseDNS no >> /etc/ssh/sshd_config"
wsl -d Ubuntu-1804 -- bash -c "echo GSSAPIAuthentication no >> /etc/ssh/sshd_config"

Write-Host "=== 6/8: 配置开机自启 ===" -ForegroundColor Cyan
wsl -d Ubuntu-1804 -- bash -c "cat > /etc/wsl.conf << 'EOF'
[boot]
command = haveged 2>/dev/null
EOF"

Write-Host "=== 7/8: 重启 WSL ===" -ForegroundColor Cyan
wsl --shutdown

Write-Host "=== 8/8: 验证 ===" -ForegroundColor Cyan
wsl -d Ubuntu-1804 -- hostname -I

Write-Host ""
Write-Host "安装完成！" -ForegroundColor Green
Write-Host "使用方法: wsl -d Ubuntu-1804 -- ssh 用户名@目标IP" -ForegroundColor Yellow
