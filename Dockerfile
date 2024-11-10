# 基于 debian12 构建
FROM debian:12.7 

# 复制源配置和公钥文件
COPY debian.sources /tmp/
COPY remote.pub /tmp/

# 更改源，安装必要的软件包
RUN mv /tmp/debian.sources /etc/apt/sources.list.d/debian.sources && \
    apt -o Acquire::https::Verify-Peer=false update && \
    apt -o Acquire::https::Verify-Peer=false install -y ca-certificates apt-transport-https && \
    apt update && \
    apt install -y vim git ssh && \
    mkdir -p /root/.ssh && \
    cat /tmp/remote.pub >> /root/.ssh/authorized_keys && \
    chmod 600 /root/.ssh/authorized_keys && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apt/* && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

# 创建 SSHD 运行目录
RUN mkdir -p /run/sshd && chmod 755 /run/sshd
    
# 修改 ssh 配置
# 允许 root 和密钥登录
RUN sed -i '$a # 允许 root 用户登录\nPermitRootLogin yes # 允许密钥登录\nPubkeyAuthentication yes\nAuthorizedKeysFile /root/.ssh/authorized_keys' /etc/ssh/sshd_config 

CMD ["/usr/sbin/sshd", "-D"]
