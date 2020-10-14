#!/bin/env bash
case $1 in
"start"){
	for i in kafka-1 kafka-2 kafka-3
	do
		     ssh $i "source /etc/profile&&$KAFKA_HOME/bin/kafka-server-start.sh -daemon $KAFKA_HOME/config/server.properties"
		     echo $?
         if [[ $? -eq 0 ]]; then
                 echo "INFO:=======  ${i} startup success   =========="
         fi
	done
};;

"stop"){
	for i in kafka-1 kafka-2 kafka-3
	do
		      ssh $i "source /etc/profile&&$KAFKA_HOME/bin/kafka-server-stop.sh"
		      echo $?
          if [[ $? -eq 0 ]]; then
                 echo "INFO:=======  ${i} shutdown success   =========="
          fi
	done
};;
esac

#cat>>/etc/hosts<<EOF
#128.196.97.199 kafka-1
#128.196.97.202 kafka-2
#128.196.97.203 kafka-3
#EOF
