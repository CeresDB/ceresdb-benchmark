SHELL = /bin/bash

DIR=$(shell pwd)

CERESDB_DIR=$(DIR)/ceresdb

run:
	cd $(DIR); sh run.sh
