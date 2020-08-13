BUILDER=docker # you may use podman if in Linux
OPERATOR_NAME=
BUNDLE_DIR=
PUSH_REGISTRY=
# PUSH_REGISTRY=scan.connect.redhat.com #after testing uncomment this one
PROJECT_ID=portworx-certified

# This is used to control which index images should include this operator.
LABEL_OCP_VER='com.redhat.openshift.versions="v4.5, v4.6"'

# until cloudbld-2121 is done, you muse also add 
LABEL_DELIVERY_BUNDLE='com.redhat.delivery.operator.bundle=true'

# Optionally, enable backporting in the generated dockerfile.  
# You want to do this only for the last image that will be published 
# as part of the migration.  For operators with only one release, 
# enable it since that is the first and last image.
LABEL_DELIVERY_BACKPORT='com.redhat.delivery.backport=true'

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

	for dockerfile in $$(ls -l1 ${BUNDLE_DIR} | grep bundle); \
		do ${BUILDER} build . -f ${BUNDLE_DIR}/$$dockerfile  -t ${OPERATOR_NAME}:$$(echo $$dockerfile | cut -c8-12); \
	done;
	
# tag images with the project ID/tag
tag-bundle-images:

	for operator_tag in $$(${BUILDER} images | grep ${OPERATOR_NAME} | awk '{print $$2}'); \
		do ${BUILDER} tag ${OPERATOR_NAME}:$$operator_tag ${PUSH_REGISTRY}/${PROJECT_ID}:$$operator_tag; \
	done;

# Finally push to the official repo
push-bundle-image:

	for operator_tag in $$(${BUILDER} images | grep ${PUSH_REGISTRY}/${PROJECT_ID} | awk '{print $$2}'); \
		do ${BUILDER} push ${PUSH_REGISTRY}/${PROJECT_ID}:$$operator_tag; \
	done;
