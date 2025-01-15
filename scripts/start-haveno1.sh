#!/bin/bash
#
docker run \
	--rm \
	--name "haveno1" \
	-it \
	--network host \
	--priviledged \
	-v /opt/prod/docker/haveno:/opt/haveno_src \
	-v /opt/prod/docker/utils:/opt/utils \
	debian:latest
