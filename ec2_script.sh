#!/bin/bash
echo "Running bash script!"
sudo apt-get update
echo Qwerty0134! | docker login -u andrienkoms --password-stdin
docker pull andrienkoms/final:latest
#docker stop \$(docker ps -a -q)



