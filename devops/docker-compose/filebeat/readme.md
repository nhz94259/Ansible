#**FileBeat部署配置**
---

## **普通安装**
```
普通安装
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.5.4-linux-x86_64.tar.gz
tar xzvf filebeat-6.5.4-linux-x86_64.tar.gz
修改 filebeat.yml 文件
touch filebeat.out
nohup ./filebeat -e &>filebeat.out & 
记得定期清理filebeat.out文件或者直接 &>/dev/null即 nohup ./filebeat -e &>/dev/null & 
```

## **Docker安装**
修改filebeat.yml owner
```
chown root:filebeat filebeat.yml
```

## **配置文件说明**
根据读取不同日志源配置不同filebeat.yml，需要把对应文件重命名为filebeat.yml

#### ***输出***
修改输出的logstash地址 host1,host2
output.logstash:
  hosts: ["host1:5044", "host2:5044"]
  loadbalance: true

#### ***Docker输入***
docker 使用filebeat.yml.docker
使用docker ps -a --no-trunc拿到完整的containerID
将拿到的ID配置在   containers.ids: 
也可以默认机器上所有的docker容器检测
containers.ids: 
  - '*'


#### ***文件输入***
docker 使用filebeat.yml.normalfile
把需要监控的log文件配置在
type: log下的paths:

#### ***syslog输入***
配置syslog文件，并输出到kafka
