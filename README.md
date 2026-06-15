# WSL Ubuntu 18.04 安装配置

在 WSL 中安装 Ubuntu 18.04 并配置 SSH 客户端的完整脚本和文档，方便从 Windows 局域网内 SSH 登录其他 Linux 设备。

## 使用方法

### 一键安装（推荐）
以管理员身份运行 PowerShell：

`powershell
.\setup-wsl-ubuntu1804.ps1
`

### 手动安装
参照 WSL_Ubuntu1804_安装配置清单.txt 一步步操作。

## 功能
- 下载并导入 Ubuntu 18.04 LTS（Bionic Beaver）
- 安装 SSH 客户端、ping、ip 等网络工具
- 解决 WSL 下 SSH 因熵不足卡住的问题
- 开机自启配置
