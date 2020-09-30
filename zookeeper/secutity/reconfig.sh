#!/bin/bash
#安装目录
ZK_HOME="/Users/nahongze/Data/component/zookeeper/zookeeper_test"
KAFKA_HOME="/Users/nahongze/Data/component/kafka/kafka_test"
#访问用户名\密码
SEC_USERNAME="admin"
SEC_PASSWD="admin-2019"
#复制jar到ZK lib下
cp $KAFKA_HOME/libs/kafka-clients-*.jar $ZK_HOME/lib/
cp $KAFKA_HOME/libs/lz4-java-*.jar $ZK_HOME/lib/
cp $KAFKA_HOME/libs/slf4j-api-*.jar $ZK_HOME/lib/
cp $KAFKA_HOME/libs/slf4j-log4j12-*.jar $ZK_HOME/lib/
cp $KAFKA_HOME/libs/snappy-java-*.jar $ZK_HOME/lib/
echo finished copy jar

#  conf/zoo.cfg 开启安全设置 配置文件末尾加 三行配置内容如下
cat>>$ZK_HOME/conf/zoo.cfg<<EOF
authProvider.1=org.apache.zookeeper.server.auth.SASLAuthenticationProvider
requireClientAuthScheme=sasl
jaasLoginRenew=3600000
EOF
echo zoo.cfg
cat $ZK_HOME/conf/zoo.cfg

# 新建 conf/zk_server_jaas.conf 并填充内容如下
cat>$ZK_HOME/conf/zk_server_jaas.conf<<EOF
Server {
    org.apache.kafka.common.security.plain.PlainLoginModule required 
    username=$SEC_USERNAME
    password=$SEC_PASSWD
    user_kafka="kafka-2019" 
    user_producer="prod-2019";
};
EOF
echo zk_server_jaas.cfg
cat $ZK_HOME/conf/zk_server_jaas.conf

# $ZK_HOME/bin/zkEnv.sh 脚本第二行添加 安全配置环境变量
sed -i '2a\export SERVER_JVMFLAGS=" -Djava.security.auth.login.config=$ZK_HOME/conf/zk_server_jaas.conf "' $ZK_HOME/bin/zkEnv.sh
cat $ZK_HOME/bin/zkEnv.sh  | grep -v ^# |grep -v ^$

# 新建 $KAFKA_HOME/config/kafka_server_jaas.conf 并填充内容如下
cat>$KAFKA_HOME/config/kafka_server_jaas.conf<<EOF
KafkaServer {
       org.apache.kafka.common.security.plain.PlainLoginModule required
       username=$SEC_USERNAME
       password=$SEC_PASSWD
       user_admin="admin-2019"
       user_producer="prod-2019"
       user_consumer="cons-2019";
};
 
Client {
       org.apache.kafka.common.security.plain.PlainLoginModule required
       username="kafka"
       password="kafka-2019";
};
 
KafkaClient {
        org.apache.kafka.common.security.plain.PlainLoginModule required
        username="producer"
        password="prod-2019";
};
EOF
cat $KAFKA_HOME/config/kafka_server_jaas.conf
# 新建 $KAFKA_HOME/config/client-sasl.properties 并填充内容如下
cat>$KAFKA_HOME/config/client-sasl.properties<<EOF
security.protocol=SASL_PLAINTEXT
sasl.mechanism=PLAIN
EOF
cat $KAFKA_HOME/config/client-sasl.properties
# 替换$KAFKA_HOME/bin/kafka-server-start.sh KAFKA_HEAP_OPTS启动参数
sed -i 's@export KAFKA_HEAP_OPTS="-Xmx1G -Xms1G"@export KAFKA_HEAP_OPTS=" -Xmx1G -Xms1G -Djava.security.auth.login.config=$KAFKA_HOME/config/kafka_server_jaas.conf"@'  $KAFKA_HOME/bin/kafka-server-start.sh
# 替换$KAFKA_HOME/config/server.properties 开启kafka sasl安全配置
sed -i 's@listeners=PLAINTEXT@listeners=SASL_PLAINTEXT@'  $KAFKA_HOME/config/server.properties
sed -i "/listeners=SASL_PLAINTEXT/aallow.everyone.if.no.acl.found=true" $KAFKA_HOME/config/server.properties
sed -i "/listeners=SASL_PLAINTEXT/aauthorizer.class.name=kafka.security.auth.SimpleAclAuthorizer" $KAFKA_HOME/config/server.properties
sed -i "/listeners=SASL_PLAINTEXT/asasl.mechanism.inter.broker.protocol=PLAIN" $KAFKA_HOME/config/server.properties
sed -i "/listeners=SASL_PLAINTEXT/asasl.enabled.mechanisms=PLAIN" $KAFKA_HOME/config/server.properties
sed -i "/listeners=SASL_PLAINTEXT/asecurity.inter.broker.protocol=SASL_PLAINTEXT" $KAFKA_HOME/config/server.properties

cat $KAFKA_HOME/config/server.properties | grep -v ^# |grep -v ^$
