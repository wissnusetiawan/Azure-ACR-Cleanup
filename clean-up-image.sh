#!/bin/bash

######################################################################
# Script Name    : clean-up-image.sh
# Description    : Used to clean up container registries by deleting untagged (dangling) images and images older than 30 days
# Args           : CONTAINER_REGISTRY_NAME
# Author         : Wisnu Setiawan <wissnusetiawan@gmail.com>
######################################################################

# Stop execution on any error
registry_name=$1
repository_name=$2
