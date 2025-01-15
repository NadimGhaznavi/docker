#!/bin/bash
#
docker run \
	--rm --name "con1" -it --network host -v /opt/prod/docker/p2pool-v4.1-linux-x64:/opt/p2pool,/opt/prod/docker/xmrig:/opt/xmrig  debian:con1.1
