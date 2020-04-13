include:
### 配置统一yum 仓库
  - init.http-repo
### 安装服务器常用软件
  - init.pkg-install
### 审计：将用户信息写入history
  - init.audit
### 关闭防火墙
  - init.firewalld-disabled
### 格式化history输出
  - init.history-init 
### 配置hosts 目录
  - init.hosts
### 关闭selinux
  - init.selinux-init
### 配置参数文件
  - init.sysctl-init
### 配置文件打开数
  - init.limits-config       
  - init.system-limits-config
  - init.user-limits-config
### 配置提示信息
  - init.tty-init
  - init.tty-prompt
### 查询指定目录下所有的url
  - init.geturl-config
### 关闭透明大页
  # Notice: can only be used to initialize a new server
  #- init.transparent_hugepage
  - init.disable_thpage
