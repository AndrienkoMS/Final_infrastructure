#!/bin/bash
echo "Running bash script!"
sudo apt-get update

#docker stop $(docker ps -a -q) || echo "Nothing to stop"
#docker rm $(docker ps -a -q) || echo "Nothing to delete"

echo Qwerty0134! | docker login -u andrienkoms --password-stdin
docker pull andrienkoms/final:latest


docker run --name wp-cont -e WORDPRESS_DB_HOST=l1-mysql-db.cde1mvsw4pqc.us-west-1.rds.amazonaws.com:3306 -e WORDPRESS_DB_USER=admin -e WORDPRESS_DB_PASSWORD=01340134 -p 8000:80 -d andrienkoms/final
#docker run --name some-wordpress -e WORDPRESS_DB_PASSWORD_FILE=/run/secrets/mysql-root ... -d wordpress:tag
#connect to db from new instance
#mysql -u admin -p01340134 -h l1-mysql-db.cde1mvsw4pqc.us-west-1.rds.amazonaws.com WordpressTest
