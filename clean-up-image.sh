#!/bin/bash

######################################################################
# Script Name    : clean-up-image.sh
# Description    : Used to clean up container registries by deleting untagged (dangling) images and images older than 30 days
# Args           : registry_name repository_name
# Author         : Wisnu Setiawan <wissnusetiawan@gmail.com>
######################################################################

#!/bin/bash

# Declare variables
registry_name=$1
repository_name=$2 
end=`date -u -d "30 days ago" '+%Y-%m-%dT%H:%M:%SZ'`
image=hello-world

# Check if correct parameters were passed
msg="\tUsage:\t$0 <registry name> <repository name>\n"

if [ $# -ne 2 ]; then
    echo -e $msg
    exit -1
fi

# Check repository name
echo "Validating ACR list..."
registry_list=$(az acr repository list --name $registry_name -o json)
if [ -z "$registry_list" ]; then
    echo -e "Error:\tEither registry name $registry_name.\n$msg"
    exit -1
fi
echo "Show $registry_list info..."

# Show repository name with tag
echo "Validating ACR tag..."
registry_tags=$(az acr repository show-tags --name $registry_name --repository $repository_name --top 10 --orderby time_desc --detail --query '[].name' -o tsv)
if [ -z "$registry_tags" ]; then
    echo -e "Error:\tEither repository name $repository_name.\n$msg"
    exit -1
fi
echo "Show $registry_tags info..."

# Show manifests name with top 100 image
show_manifests=$(
    az acr repository show-manifests --name "$registry_name" --repository "$repository_name" --top 100 --query '[].tags' \
    --output tsv 
    )
echo "Show $show_manifests info..."

# Delete images older than 30 days & keep 100 image
echo "ACR delete image info..."
az acr repository show-manifests --name "$registry_name" --repository "$repository_name" --orderby time_desc -o tsv --query '[].digest' | sed -n '100,$ p' | xargs -I% az acr repository delete --name "$registry_name" --image hello-world@% --yes

