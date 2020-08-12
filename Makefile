MANIFEST_DIR=
OUTPUT_DIR=
OUTPUT_TAG=

# This is used to control which index images should include this operator.
LABEL_OCP_VER='com.redhat.openshift.versions="v4.5, v4.6"'

# until cloudbld-2121 is done, you muse also add 
LABEL_DELIVERY_BUNDLE='com.redhat.delivery.operator.bundle=true'

# Optionally, enable backporting in the generated dockerfile.  
# You want to do this only for the last image that will be published 
# as part of the migration.  For operators with only one release, 
# enable it since that is the first and last image.
LABEL_DELIVERY_BACKPORT='com.redhat.delivery.backport=true'
PID=
TAG=

# Download and install all tools
.phony: get-tools
get-tools:

# run all targets
.phony: all
all: 
# TODO - insert all targets if they can run seamlessly

# Pull all certified operator manifests
pull-certified-operators: 
offline-cataloger generate-manifests "certified-operators"


# adjust bundle format
nest:
operator-courier nest ${MANIFEST_DIR} ${OUPUT_DIR}

# run migrate.sh

#!/bin/bash
set -e

folder=$1

for dir in ${folder}/*/
do
    echo "migrating ${dir}"
    opm alpha bundle generate --directory ${dir} --output-dir ${dir}
    dir=${dir%*/}
    version=${dir##*/} 
    echo "LABEL com.redhat.openshift.versions=v4.5" >> bundle.Dockerfile
    mv bundle.Dockerfile bundle-${version}.Dockerfile
    echo "migrated ${dir}"
done

# add the missing labels to dockerfile
label-docker-images:



# Bundle images with operator-courier
bundle-images:
podman build . -f [docker file]  -t [output tag]

# create a new certification project of type 'operator bundle image'

# tag images with the project ID/tag
tag-images:
podman tag [image id] scan.connect.redhat.com/${PID}/${TAG}

# remove package-lock
# ???

bundle-push:
podman push scan.connect.redhat.com/${PID}/${TAG}



