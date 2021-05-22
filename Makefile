
.phony: all clean

default: all

SHELL := /bin/bash
ROOT_DIR := $(shell git rev-parse --show-toplevel)
CURRENT_DIR := $(shell cd -P -- '$(shell dirname -- "$0")' && pwd -P)
BUILD_DATE := $(shell date -u +'%Y-%m-%dT%H:%M:%SZ')
REVISION := $(shell git rev-parse --short HEAD)
VERSION := $(shell git describe --tags)

all: work-tmp/crd work-tmp/others
	mkdir --parents $(ROOT_DIR)/kubernetes/tekton-pipelines
	mkdir --parents $(ROOT_DIR)/kubernetes/tekton-default
	mv $(ROOT_DIR)/work-tmp/crd/*.yaml $(ROOT_DIR)/kubernetes/tekton-default
	mv $(ROOT_DIR)/work-tmp/others/*.yaml $(ROOT_DIR)/kubernetes/tekton-pipelines
		  
work-tmp/tekton.yaml:
	echo "downloading tekton ..."
	mkdir --parents $(ROOT_DIR)/work-tmp
	curl "https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml" --output $(ROOT_DIR)/work-tmp/tekton.yaml
	
work-tmp/tekton-dashboard.yaml:
	echo "downloading tekton-dashboard ..."
	mkdir --parents $(ROOT_DIR)/work-tmp
	curl "https://storage.googleapis.com/tekton-releases/dashboard/latest/tekton-dashboard-release.yaml" --output $(ROOT_DIR)/work-tmp/tekton-dashboard.yaml
	
work-tmp/yaml-1: work-tmp/tekton.yaml
	mkdir --parents $(ROOT_DIR)/work-tmp/yaml-1
	cd $(ROOT_DIR)/work-tmp/yaml-1 ; \
	  $(ROOT_DIR)/scripts/split-yaml.awk $(ROOT_DIR)/work-tmp/tekton.yaml ; \
	  chmod +x $(ROOT_DIR)/work-tmp/yaml-1/rename-generated.sh ; \
	  $(ROOT_DIR)/work-tmp/yaml-1/rename-generated.sh
	  
work-tmp/yaml-2: work-tmp/tekton-dashboard.yaml
	mkdir --parents $(ROOT_DIR)/work-tmp/yaml-2
	cd $(ROOT_DIR)/work-tmp/yaml-2 ; \
	  $(ROOT_DIR)/scripts/split-yaml.awk $(ROOT_DIR)/work-tmp/tekton-dashboard.yaml ; \
	  chmod +x $(ROOT_DIR)/work-tmp/yaml-2/rename-generated.sh ; \
	  $(ROOT_DIR)/work-tmp/yaml-2/rename-generated.sh
	  
work-tmp/crd: work-tmp/yaml-1 work-tmp/yaml-2
	mkdir --parents $(ROOT_DIR)/work-tmp/crd
	mv $(ROOT_DIR)/work-tmp/yaml-1/*CustomResource*.yaml $(ROOT_DIR)/work-tmp/crd
	mv $(ROOT_DIR)/work-tmp/yaml-2/*CustomResource*.yaml $(ROOT_DIR)/work-tmp/crd

work-tmp/others: work-tmp/yaml-1 work-tmp/yaml-2
	mkdir --parents $(ROOT_DIR)/work-tmp/others
	mv $(ROOT_DIR)/work-tmp/yaml-1/*.yaml $(ROOT_DIR)/work-tmp/others
	mv $(ROOT_DIR)/work-tmp/yaml-2/*.yaml $(ROOT_DIR)/work-tmp/others
	
clean:
	rm -rf $(ROOT_DIR)/work-tmp