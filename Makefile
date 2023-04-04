SHELL = /bin/bash

DIR=$(shell pwd)

run-once:
	cd $(DIR); sh run.sh

run-daily:
	# Append the scheduled task to the crontab.
	cd $(DIR); (crontab -l ;  echo "30 2 * * * sh $(DIR)/run.sh >> $(DIR)/out.log 2>&1") | crontab -

