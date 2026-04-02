FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=zh_CN.UTF-8

# 安装图形支持依赖
RUN apt-get update && apt-get install -y \
    libnss3 libxss1 libasound2 libxtst6 libgtk-3-0 \
    libcanberra-gtk-module libcanberra-gtk3-module \
    fonts-wqy-microhei language-pack-zh-hans \
    && rm -rf /var/lib/apt/lists/*

# 拷贝并安装 deb
COPY com.tdx.tdxcfv_7.64_amd64.deb /tmp/tdx.deb
RUN apt-get update && apt-get install -y /tmp/tdx.deb || apt-get install -y -f

# 设置容器启动时进入的工作目录
WORKDIR /opt/apps/com.tdx.tdxcfv/files/bin
CMD ["./tdxw.sh"]