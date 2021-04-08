#!/bin/bash
# Remove all exited containers and dangling images
docker rm $(docker ps -q -f status=exited)
docker rmi $(docker images -q -f dangling=true)
