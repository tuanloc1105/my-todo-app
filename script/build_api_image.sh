#!/bin/bash

clear

build_location_context=$(pwd)

local_docker_file_name="./Dockerfile.api"
images_name='tuanloc/todo_api'
latest_git_commit_hash_id=$(git log -n 1 --pretty=format:'%h')
images_tag="${latest_git_commit_hash_id}"

printf "\n\n  >> Build image\n"

docker buildx build -f ${local_docker_file_name} -t ${images_name}:${images_tag} ${build_location_context}
