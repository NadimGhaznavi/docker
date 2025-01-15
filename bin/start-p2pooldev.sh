#!/bin/bash
#
docker run \
	--rm \
	-di \
	--name="p2pooldev" \
	--hostname=p2pooldev \
	--domainname="osoyalce.com" \
	-p 3334:3334 \
	-p 38889:38889 \
	-v /opt/dev/p2pool:/opt/p2pool \
	-v /opt/prod/docker/run:/opt/p2pool/run \
	sallykolodny/db4e:p2pooldev
