#!/bin/bash
# Remove all exited containers and images
docker ps -f status=exited --format {{.Image}} | xargs docker rmi -f
docker rm $(docker ps -q -f status=exited)
