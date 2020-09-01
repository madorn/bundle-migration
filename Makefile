BUILDER?=docker # you may use podman if in Linux
OPERATOR_NAME?=cic-operator
BUNDLE_DIR?=manifests-435264820/cic-operator
PUSH_REGISTRY?=scan.connect.redhat.com
PROJECT_ID=cic-operator
FLAT?='false'
# For nesting flat directories
NESTED_DIR=${BUNDLE_DIR}-nested

# run all targets
.phony: all
all: nest migrate-bundle build-bundle-images tag-bundle-images

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

	for dockerfile in $$(ls -1 ${BUNDLE_DIR} | grep bundle); \
		do echo "build . -f ${BUNDLE_DIR}/$$dockerfile  -t ${OPERATOR_NAME}:$$(echo $$dockerfile | sed 's/.Dockerfile//' | cut -c8-18)"; \
		${BUILDER} build . -f ${BUNDLE_DIR}/$$dockerfile  -t ${OPERATOR_NAME}:$$(echo $$dockerfile | sed 's/.Dockerfile//' | cut -c8-18); \
	done;
	
# Tag images with the project ID/tag
.phony: tag-bundle-images
tag-bundle-images:

	for operator_tag in $$(${BUILDER} images | grep ${OPERATOR_NAME} | awk '{print $$2}'); \
		do echo "tagging ${OPERATOR_NAME}:$$operator_tag ${PUSH_REGISTRY}/${PROJECT_ID}:$$operator_tag"; \
		${BUILDER} tag ${OPERATOR_NAME}:$$operator_tag ${PUSH_REGISTRY}/${PROJECT_ID}:$$operator_tag; \
	done;

# If versions are to be pushed individually just do:
# podman or docker images on local machine and pick the right version, then
# podman or docker push with format ${PUSH_REGISTRY}/${PROJECT_ID}:$$operator_tag;

# Finally push to the official repo
# .phony: push-bundle-images
# push-bundle-images:

# 	for operator_tag in $$(${BUILDER} images | grep ${PUSH_REGISTRY}/${PROJECT_ID} | awk '{print $$2}'); \
# 		do echo "pushing ${PUSH_REGISTRY}/${PROJECT_ID}:$$operator_tag"; \
# 		${BUILDER} push ${PUSH_REGISTRY}/${PROJECT_ID}:$$operator_tag; \
# 	done;
