##########################
# Bootstrapping variables
##########################

# Application specific environment variables
include .env
export

# Base settings, these should almost never change
export AWS_ACCOUNT ?= $(shell aws sts get-caller-identity --query Account --output text)
export ROOT_DIR ?= $(shell pwd)

# Resource identifiers
export DATA_BUCKET_NAME ?= ${STAGE}-${APP_NAME}-data-${AWS_ACCOUNT}-${AWS_REGION}

# test:
# 	$(MAKE) -C ${APP_NAME}/emr/ test

target:
	$(info ${HELP_MESSAGE})
	@exit 0

check.env:
ifndef STAGE
$(error STAGE is not set. Please add STAGE to the environment variables.)
endif
ifndef APP_NAME
$(error APP_NAME is not set. Please add APP_NAME to the environment variables.)
endif
ifndef AWS_PROFILE
$(error AWS_PROFILE is not set. Please select an AWS profile to use.)
endif
ifndef AWS_REGION
$(error AWS_REGION is not set. Please add AWS_REGION to the environment variables.)
endif

deploy: ##=> Deploy services
	$(MAKE) analytics.deploy

# Deploy specific stacks
analytics.deploy:
	$(MAKE) -C ${APP_NAME}/analytics/ deploy

# # Deploy static assets
# static.deploy:
# 	$(MAKE) -C ${APP_NAME}/emr/ service.jobs.deploy
# 	$(MAKE) -C ${APP_NAME}/emr/ service.data.deploy

delete: ##=> Delete services
	# $(MAKE) analytics.delete

# Delete specific stacks
analytics.delete:
	$(MAKE) -C ${APP_NAME}/analytics/ delete

define HELP_MESSAGE

	Environment variables:

	STAGE: "${STAGE}"
		Description: Feature branch name used as part of stacks name

	APP_NAME: "${APP_NAME}"
		Description: Stack Name already deployed

	AWS_ACCOUNT: "${AWS_ACCOUNT}":
		Description: AWS account ID for deployment

	AWS_REGION: "${AWS_REGION}":
		Description: AWS region for deployment

	Common usage:

	...::: Deploy all CloudFormation based services :::...
	$ make deploy

	...::: Delete all CloudFormation based services and data :::...
	$ make delete

endef
