FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=zh_CN.UTF-8

# 安装图形支持依赖和下载工具
RUN apt-get update && apt-get install -y \
    wget \
    libnss3 libxss1 libasound2 libxtst6 libgtk-3-0 \
    libcanberra-gtk-module libcanberra-gtk3-module \
    fonts-wqy-microhei language-pack-zh-hans \
    && rm -rf /var/lib/apt/lists/*

# 检查本地 deb 文件是否存在，不存在则下载
RUN if [ -f com.tdx.tdxcfv_7.64_amd64.deb ]; then \
      cp com.tdx.tdxcfv_7.64_amd64.deb /tmp/tdx.deb; \
    else \
      wget -q -O /tmp/tdx.deb https://data.tdx.com.cn/kylin/com.tdx.tdxcfv_7.64_amd64.deb; \
    fi

# 安装通达信
RUN apt-get update && apt-get install -y /tmp/tdx.deb || apt-get install -y -f

# 设置容器启动时进入的工作目录
WORKDIR /opt/apps/com.tdx.tdxcfv/files/bin
CMD ["./tdxw.sh"]