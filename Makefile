SHELL = /bin/bash

DIR=$(shell pwd)

CERESDB_DIR=$(DIR)/ceresdb

update-ceresdb:
	git -C $(CERESDB_DIR) pull || git clone https://github.com/ShiKaiWi/ceresdb.git

run: update-ceresdb
	cd $(DIR); sh scripts/run.sh
