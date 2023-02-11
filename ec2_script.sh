#!/bin/bash
sudo apt-get update
echo Qwerty0134! | docker login -u andrienkoms --password-stdin
docker pull andrienkoms/final:latest
#docker stop \$(docker ps -a -q)

echo "Hello from bash script"

