#!/bin/bash
sudo apt-get update

#docker stop \$(docker ps -a -q)

echo "Hello from bash script"
docker pull andrienkoms/final:latest
