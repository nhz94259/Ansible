#!/bin/bash
date=`date +%Y.%m.%d.%H.%M.%S`
# 服务名称
service_name=$1
# 服务所在目录
service_dir=$2
# 代码地址
repo_url=$3
# 分支名称
branch_name=$4
# 构建环境 dev or prod
env=$5
# 是否上传
harbor=$6
registry=registry.eccom.com.cn/eccom/
service_version=rc-$date
shell_dir=`pwd`
code_dir=/opt/cloudnet/$service_dir/code/$service_name
image_name=$registry$service_name:$service_version

echo ""
echo [info] stop and remove $service_name container.
echo ""
docker-compose  down

echo TAG=$service_version > $shell_dir/.env
if [ ! -d $code_dir  ];then
    echo ""
    echo [info] create $service_name code
    echo ""
    mkdir -p  /opt/cloudnet/$service_dir/code/
    cd /opt/cloudnet/$service_dir/code/
    git clone $repo_url 
    cd ./$service_name
    git checkout $branch_name
    mvn clean package -Dmaven.test.skip=true -U
else
    echo ""
    echo [info] update $service_name code
    echo ""
    cd $code_dir
    echo "current code branch is :"$branch_name
    git checkout $branch_name
    echo "git pulling"
    git pull    
    mvn clean package -Dmaven.test.skip=true -U
fi

echo ""
echo [info] docker build $service_name image.
echo ""

docker build --build-arg name=$service_dir-$env -t $image_name .

if [ $? -eq 0 ]; then
    cd $shell_dir
    echo ""
    echo [info] create  $service_name container.
    echo ""
    docker-compose up -d
    
    echo ""
    echo [info] images:tag=$image_name
    echo ""

    if [[ $harbor==yes ]]||[[ $harbor==YES ]];then
        echo ""
        echo [info] push image to harbor name : image_name
        echo ""
        #git push $image_name
    fi
    
    exit 0
else
    echo ""
    echo [error] build image faild. 
    echo ""
fi

