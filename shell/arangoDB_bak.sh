#!/bin/bash

mkdir /data
cd /data #set cronjob workspace

date=`date +%Y-%m%d-%H%M%S`
data_user=eccom
data_password=eccom
database_name=cmdb
containerIdorName=arangodb_app_1
arango_volunm_dir=/opt/cloudnet/arangodb/data/ #docker arango volumn dir
cur_shell_dir=`pwd`
work_dir=$cur_shell_dir'/cmdb_data_backup/'
echo $work_dir
if [ ! -d $work_dir  ];then
    mkdir $work_dir
fi
filename='dump-'$date
docker exec  $containerIdorName  sh -c 'arangodump --server.endpoint tcp://localhost:8529 --server.username '$data_user' --server.password '$data_password' --server.database '$database_name' --output-directory /var/lib/arangodb3/'$filename'  --overwrite true'
if [ $? -eq 0 ]; then
     echo -e "\033[32m"backup succeed "\033[0m"
     mv $arango_volunm_dir$filename $work_dir
     cd $work_dir
cat << EOF > $work_dir$filename/aarangorestore.sh
#!/bin/bash
docker exec -it arangodb_app_1  sh -c 'arangorestore --server.endpoint tcp://localhost:8529 --server.username eccom --server.password eccom --server.database cmdb --output-directory /var/lib/arangodb3/$filename  --overwrite true'
EOF
     tar -zcf $filename.tar $filename
     echo
     echo -e "\033[32m"The latest backup file is : $work_dir$filename.tar"\033[0m"
     echo -e "\033[32m"You can use follow command to check it: tar -tf $work_dir$filename.tar"\033[0m"
     echo -e "\033[32m"We provide scripts to support arangodb data import in $filename.tar , aarangorestore.sh"\033[0m"
    
else
     echo -e "\033[1;5;31mbackup faild\033[0m"
     
fi







