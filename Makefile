
.phony: all clean

default: all

SHELL := /bin/bash

all: 
	buildah bud -f docker/shell --tag bfblog/shell