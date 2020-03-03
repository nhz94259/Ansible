#!/bin/sh
arangosh --server.password Cisco123 --javascript.execute-string "db._createDatabase('cmdb');db._useDatabase('_system');require('@arangodb/users').save('eccom','eccom');"
arangosh --server.password Cisco123 --javascript.execute-string "db._useDatabase('_system');require('@arangodb/users').grantDatabase('eccom','cmdb','rw');"
echo "init success!"
