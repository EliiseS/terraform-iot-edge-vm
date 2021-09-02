SHELL := /bin/bash

dps-cert-gen:
	cd scripts/dps/ca && \
	./create_root_ca.sh && \
	./create_intermediary_cert.sh

dps-configure:
	cd scripts/dps/enrollment && \
	dotenv -f ../../../src/edge/deployment/.env run ./upload_and_verify_root_ca.sh && \
	dotenv -f ../../../src/edge/deployment/.env run ./create_enrollment_group.sh
	