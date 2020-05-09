### 介绍
- 用于脱机环境下jenkins部署
- 包含jenkins常用插件前后端 node、maven 编译依赖
### Jnekins安装方法

- jenkins_root.tar.gz  jenkins-custom.tar docker-compose.yml  拷贝到目标环境/home目录下
- 解压Jenkins挂载目录
    - tar -zxvf jenkins_root.tar.gz  [下载地址](https://pan.baidu.com/s/1c2K-H3kyJQvgi5EqrzjKBA )  密码:2vmj
- 载入docker镜像
    - docker pull nhzdevops/jenkins:1.0.25
- 启动镜像
    - docker-compose up -d

#### 

### jenkins_root目录简介
- jenkins_home                       「jenkins映射目录」
- jenkins_opt
    - maven
        - mvn-repo                   「maven依赖的缓存目录 ，jenkins使用的maven环境配置如下 settings.xml.」
    - nodejs
        - cache                      「cache global是node缓存目录」
        - global
        - npm-packages-offline-cache 「npm-packages-offline-cache是离线包   [参考](https://classic.yarnpkg.com/blog/2016/11/24/offline-mirror/)  」
  
 
 
- settings.xml 「本地映射目录地址:/home/jenkins_root/jenkins_home/tools/hudson.tasks.Maven_MavenInstallation/maven/conf 」
 ```
 <?xml version="1.0" encoding="UTF-8"?>
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">
<!--本地缓存目录,注: /opt/maven/mvn-repo 是容器内目录-->
    <localRepository>/opt/maven/mvn-repo</localRepository> 
     <mirrors>
        <mirror>
            <id>central</id>
            <name>central</name>
            <url>file:/opt/maven/mvn-repo</url>
            <mirrorOf>*</mirrorOf>
        </mirror>
    </mirrors>
<!--确定执行构建时，maven是否脱机-->
    <offline>true</offline>
</settings>

 ```
 ### 登录
     默认用户名密码 admin Ecc0m@123
