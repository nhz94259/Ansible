jenkins_opt目录结构

maven
    mvn-repo
nodejs
    cache
    global
    npm-packages-offline-cache
    
 jenkins 使用的maven环境配置 ( /opt/maven/mvn-repo 是容器内地址  )
 
 ```
 <?xml version="1.0" encoding="UTF-8"?>
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">
<!--本地缓存目录-->
    <localRepository>/opt/maven/mvn-repo</localRepository>  
    <mirrors>
        <mirror>
            <id>ali maven</id>
            <name>aliyun maven</name>
            <url>https://maven.aliyun.com/repository/public/</url>
            <mirrorOf>central</mirrorOf>
        </mirror>
    </mirrors>
<!--
    确定执行构建时，maven是否脱机
-->
    <offline>true</offline>
 <!--
     配置网络代理
 -->
    <proxies>
    <!-- proxy Specification for one proxy, to be used in connecting to the network.
        <proxy>
          <id>optional</id>
          <active>true</active>
          <protocol>http</protocol>
          <username>proxyuser</username>
          <password>proxypass</password>
          <host>proxy.host.net</host>
          <port>80</port>
          <nonProxyHosts>local.net|some.host.com</nonProxyHosts>
        </proxy>
    -->
    </proxies>
</settings>

 ```
