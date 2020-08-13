# REQUIRED MANUAL STEPS BEFORE RUNNING THIS
# 1. Login access.redhat.com with your masquared account 
# 2. Create a new certification project of type 'operator bundle image'
# 3. remove package-lock or ask someone to do it for the migrating operator

BUNDLE_DIR=manifests-851274669/portworx-certified/portworx-certified-5edb2jey
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
OUTPUT_TAG=
DOCKERFILE_PATH=

# Download and install all tools
.phony: get-tools
get-tools:

# run all targets
.phony: all
all: 
# TODO - insert all targets if they can run seamlessly

# Pull all certified operator manifests
.phony: pull-cert-operators
pull-cert-operators: 

	offline-cataloger generate-manifests "certified-operators"

# adjust bundle format if it's not nested
.phony: nest 
nest:
	operator-courier nest ${BUNDLE_DIR} ${OUPUT_DIR}

# run migrate.sh
migrate-bundle:
	./migrate.sh ${BUNDLE_DIR}

# Bundle images with operator-courier and add to Docker image
build-bundle-images:

	# TODO operator-courier commands:
	podman build . -f ${DOCKERFILE_PATH}  -t ${OUTPUT_TAG}

# tag images with the project ID/tag
tag-bundle-images:

	# TODO: get the image ID from the previous step
	podman tag ${IMAGE_ID} scan.connect.redhat.com/${PID}/${OUTPUT_TAG}

# Finally push to the official repo
bundle-image-push:
	podman push scan.connect.redhat.com/${PID}/${TAG}



