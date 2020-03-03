# ArangoDB部署（以单点部署为例）

## 启动
```
cd single
docker-compose up -d
```
## 数据库和用户初始化
```
# single_single_1为容器名称，也可用ID代替，使用 docker ps 命令查询
docker exec -it single_single_1 sh -c '/.init.sh'
```
