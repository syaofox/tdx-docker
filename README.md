# 通达信麒麟版 Docker 容器化

将通达信麒麟版（`.deb`）打包为 Docker 容器，实现跨 Linux 发行版的稳定运行。

## 前提条件

- Docker 和 Docker Compose
- X11 显示服务器（Linux 桌面环境）
- 显卡驱动（可选，用于硬件加速）

## 快速开始

### 1. 克隆或下载项目
```bash
git clone <repository-url>
cd tdx-docker
```

### 2. 设置 X11 权限
```bash
xhost +local:docker
```

### 3. 构建镜像
```bash
docker build -t tdx-kylin-native .
```

### 4. 启动容器
```bash
docker compose up -d
```

### 5. 查看运行状态
```bash
docker ps
docker logs tdx_app
```

## 项目结构

```
tdx-docker/
├── Dockerfile              # 镜像构建文件
├── docker-compose.yml      # 容器编排配置
├── com.tdx.tdxcfv_7.64_amd64.deb  # 通达信安装包
├── tdx_data/               # 持久化数据目录（自动创建）
│   └── drive_c/tc/
│       ├── T0002/          # 用户配置、自选股等
│       └── vipdoc/         # 历史数据
└── README.md               # 本文件
```

## 配置说明

### 持久化数据
- **T0002**: 用户配置、自选股、公式、登录信息
- **vipdoc**: 股票历史数据

数据保存在宿主机 `./tdx_data` 目录中，删除容器后数据不会丢失。

### 网络配置
使用 `host` 网络模式，直接共享宿主机网络，方便连接行情服务器。

### 设备挂载
- `/dev/dri`: 显卡硬件加速
- `/dev/snd`: 声音输出
- X11 套接字: 图形界面显示

## 常用命令

### 启动和停止
```bash
# 启动
docker compose up -d

# 停止
docker compose down

# 重启
docker compose restart
```

### 查看日志
```bash
# 实时日志
docker logs -f tdx_app

# 最近 100 行
docker logs --tail 100 tdx_app
```

### 进入容器调试
```bash
docker exec -it tdx_app bash
```

### 重新构建镜像
```bash
docker compose build --no-cache
```

## 故障排除

### 1. 无法显示图形界面
```bash
# 检查 X11 权限
xhost +local:docker

# 检查 DISPLAY 变量
echo $DISPLAY

# 测试 X11 连接
docker exec tdx_app xdpyinfo
```

### 2. 容器启动后立即退出
```bash
# 查看错误日志
docker logs tdx_app

# 以交互模式运行调试
docker run -it --rm tdx-kylin-native bash
```

### 3. 缺少依赖库
如果运行时提示缺少 `.so` 文件，需要在 Dockerfile 中添加对应的包：
```dockerfile
RUN apt-get install -y <package-name>
```

### 4. 声音无法播放
确保 `/dev/snd` 设备已挂载，且 PulseAudio 服务正常运行。

## 更新通达信版本

1. 下载新版本的 `.deb` 文件
2. 替换项目中的 `com.tdx.tdxcfv_7.64_amd64.deb`
3. 重新构建镜像：
   ```bash
   docker compose build --no-cache
   ```
4. 重启容器：
   ```bash
   docker compose down && docker compose up -d
   ```

## 注意事项

1. **首次启动**: 首次运行会自动初始化数据目录，可能需要稍等片刻
2. **硬件加速**: 挂载 `/dev/dri` 可启用显卡加速，减少 CPU 占用
3. **数据备份**: 定期备份 `./tdx_data` 目录以防数据丢失
4. **网络连接**: 使用 host 网络模式，确保防火墙允许相关端口

## 环境变量

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `DISPLAY` | `:0` | X11 显示地址 |
| `QT_X11_NO_MITSHM` | `1` | 修复某些显示问题 |
| `XDG_RUNTIME_DIR` | `/run/user/1000` | 运行时目录 |

## 许可证

本项目仅用于学习和研究目的。通达信软件版权归其开发商所有。