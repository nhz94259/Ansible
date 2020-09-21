#!/bin/bash

date=`date +%Y.%m.%d.%H.%M.%S`
registry=registry.ant.com.cn/ant/
service_version=rc-$date
shell_dir=${WORKSPACE}
code_dir=${WORKSPACE}/${service_name}
image_name=${registry}${service_name}:${service_version}


if [[ ! -f "docker-compos.yml" ]];then
	echo ""
	echo [info] docker-compose down
	echo ""
	docker-compose down
fi

echo ""
echo [info] update docker-compose.yml
echo ""

cat <<EOF> docker-compose.yml
version: '2.4'
services:
  ${service_name}:
    image: "${image_name}"
    restart: always
    network_mode: "host"
    environment:
      - api_servers=server ${api_servers};
    cpus: 1
    mem_limit: 2g
EOF

echo ${code_dir}
if [ ! -d ${code_dir}  ];then
    echo ""
    echo [info] create ${service_name} code
    echo ""
    git clone ${repo_url} 
    cd  ${service_name}
    git checkout ${branch_name}   
else
    echo ""
    echo [info] update ${service_name} code
    echo ""
    cd  ${service_name}
    echo "current code branch is :"${branch_name}
    git checkout ${branch_name}
    echo "git pulling"
    git pull    
fi
echo ""
echo [info] docker build ${service_name} image.
echo ""
if [[ ! -f "Dockerfile" ]];then
    echo "Dockerfile can not find!"
    exit 1
fi
if [[ ! -f "package.json" ]];then
    echo "package.json can not find !"
    exit 1
fi


yarn install

yarn build

docker build -t ${image_name} .
	
if [ $? -eq 0 ]; then
    cd ${shell_dir}
    echo ""
    echo [info] create  ${service_name} container.
    echo ""
    docker-compose up -d
    
    echo ""
    echo [info] images:tag=${image_name}
    echo ""
    
    if [[ ${upload_image} == "yes" ]]||[[ ${upload_image} == "release" ]];then
    	echo ""
    	echo [info] push image to harbor name : image_name
    	echo ""
    	git push ${image_name}   
    fi
    
    exit 0
else
    echo ""
    echo [error] build image faild. 
    echo ""
    exit 7
fi
