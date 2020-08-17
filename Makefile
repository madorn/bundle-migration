BUILDER?=docker # you may use podman if in Linux
OPERATOR_NAME?=cic-operator
BUNDLE_DIR?=manifests-435264820/cic-operator
PUSH_REGISTRY?=quay.io
# PUSH_REGISTRY=scan.connect.redhat.com #after testing uncomment this one
PROJECT_ID=cic-operator
FLAT?='false'
# For nesting flat directories
NESTED_DIR=${BUNDLE_DIR}-nested

# run all targets
.phony: all
all: nest migrate-bundle build-bundle-images tag-bundle-images push-bundle-images

# Pull all certified operator manifests
.phony: pull-cert-operators
pull-cert-operators: 

	offline-cataloger generate-manifests "certified-operators"

# adjust bundle format if it's not nested
.phony: nest 
nest:
	@if [ ${FLAT} == "true" ]; then \
		operator-courier nest ${BUNDLE_DIR} ${NESTED_DIR}; \
		mv ${BUNDLE_DIR} ${BUNDLE_DIR}-flat-old; \
		mv ${NESTED_DIR} ${BUNDLE_DIR}; \
	fi

# Run migrate.sh
# This command will generate the manisfests and metadata folder
# as well as the correspondent Dockerfile
.phony: migrate-bundle
migrate-bundle:
	./migrate.sh ${BUNDLE_DIR}

# Build an image for each version
.phony: build-bundle-images
build-bundle-images:

	for dockerfile in $$(ls -l1 ${BUNDLE_DIR} | grep bundle); \
		do ${BUILDER} build . -f ${BUNDLE_DIR}/$$dockerfile  -t ${OPERATOR_NAME}:$$(echo $$dockerfile | cut -c8-12); \
	done;
	
# Tag images with the project ID/tag
.phony: tag-bundle-images
tag-bundle-images:

	for operator_tag in $$(${BUILDER} images | grep ${OPERATOR_NAME} | awk '{print $$2}'); \
		do ${BUILDER} tag ${OPERATOR_NAME}:$$operator_tag ${PUSH_REGISTRY}/${PROJECT_ID}:$$operator_tag; \
	done;

# Finally push to the official repo
.phony: push-bundle-images
push-bundle-images:

	for operator_tag in $$(${BUILDER} images | grep ${PUSH_REGISTRY}/${PROJECT_ID} | awk '{print $$2}'); \
		do ${BUILDER} push ${PUSH_REGISTRY}/${PROJECT_ID}:$$operator_tag; \
	done;
