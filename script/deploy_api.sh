#!/bin/bash

clear

build_location_context=$(pwd)

local_docker_file_name="./Dockerfile.api"
images_name='tuanloc/todo_api'
latest_git_commit_hash_id=$(git log -n 1 --pretty=format:'%h')
images_tag="${latest_git_commit_hash_id}"
app_name='todo-api'
app_namespace='lcx'
replica='1'

printf "\n\n >> Load image into kind\n"
kind load docker-image ${images_name}:${images_tag} --name $(whoami)

printf "\n\n >> Upgrade helm chart\n"
helm upgrade \
  -i --force \
  --set image.name=${images_name},image.tag=${images_tag},replica=${replica} ${app_name} \
  -n ${app_namespace} --create-namespace \
  ./helm/api
