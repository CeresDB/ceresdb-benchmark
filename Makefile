SHELL = /bin/bash

DIR=$(shell pwd)
PATH_FOR_CRONTAB=PATH=$(PATH)

run-once:
	cd $(DIR); sh run.sh

run-without-upload:
	cd $(DIR); DISABLE_UPLOAD=1 sh run.sh

run-daily:
	# Append the scheduled task to the crontab.
	cd $(DIR); (crontab -l ;  echo "$(PATH_FOR_CRONTAB)" ; echo "30 2 * * * sh $(DIR)/run.sh >> $(DIR)/out.log 2>&1") | crontab -

