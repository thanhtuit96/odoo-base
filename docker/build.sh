#!/bin/bash

REPO="registry.gitlab.com/thanhtuit96/farmnet"
DATE=$(date +"%Y%m%d")
echo "Building image ..."
docker build --force-rm -f ./docker/odoo/Dockerfile -t $REPO:latest-arm64v8 -t $REPO:$DATE-arm64v8 . 
