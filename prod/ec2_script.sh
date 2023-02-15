#!/bin/bash
sudo apt-get update
docker stop $(docker ps -a -q) || echo "Nothing to stop"
docker rm $(docker ps -a -q) || echo "Nothing to delete"