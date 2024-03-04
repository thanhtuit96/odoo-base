#!/bin/bash
DATE=$(date +"%Y%m%d")
REPO="registry.gitlab.com/thanhtuit96/farmnet"

docker push $REPO:latest-arm64v8
docker push $REPO:$DATE-arm64v8