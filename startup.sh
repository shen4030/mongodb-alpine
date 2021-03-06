#!/bin/sh
if [ -e /data/init/init.lock ]; then
	echo "跳过初始化"
else
	echo "安装初始化开始"
	mkdir -p /data/init && touch /data/init/init.lock && mkdir -p /data/db
	username=${MONGODB_USERNAME:-admin}
	password=${MONGODB_PASSWORD:-admin}
	database=${MONGODB_DBNAME:-admin}

	if [ ! -z "$MONGODB_DBNAME" ]
	then
    	userrole=${MONGODB_ROLE:-dbOwner}
	else
    	userrole=${MONGODB_ROLE:-dbAdminAnyDatabase}
	fi

	# 首次运行创建用户
	/usr/bin/mongod --dbpath /data/db --nojournal &
	while ! nc -vz localhost 27017; do sleep 1; done

	mongo ${database} --eval "db.createUser({ user: '${username}', pwd: '${password}', roles: [ { role: '${userrole}', db: '${database}' } ] });"
	/usr/bin/mongod --dbpath /data/db --shutdown
fi

exec /usr/bin/mongod --dbpath /data/db --auth --bind_ip_all