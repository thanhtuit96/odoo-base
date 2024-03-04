#!/bin/bash

REPO="registry.gitlab.com/thanhtuit96/farmgate"
DATE=$(date +"%Y%m%d")
echo "Building image ..."
docker build --platform linux/amd64 --force-rm -f ./docker/odoo/Dockerfile -t $REPO:latest -t $REPO:$DATE . 
