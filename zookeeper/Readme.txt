1.修改var中zk节点】
2.需要升级zookeeper 需要替换file.zookeeper-3.4.5.tar.gz文件并修改var.zookeeper_file_name
3.BigdataDir: /opt/hzgc  自定义zk安装目录
4.AnsibleDir: /etc/ansible/roles 修改为zookeeper.tar.gz 解压的当前目录 
5.1 制作命令 ansible-playbook -i /etc/ansible/hosts zookeeper.yml 
5.2 inventory 可修改为 自己ansible自定义处
