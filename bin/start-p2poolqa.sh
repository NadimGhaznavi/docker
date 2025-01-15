#!/bin/bash
#
docker run \
  --rm \
  -di \
  --name="p2poolqa" \
  --hostname=p2poolqa \
  --domainname="osoyalce.com" \
  -v /opt/qa/p2pool:/opt/p2pool \
  -v /opt/prod/docker/run:/opt/p2pool/run \
  -p 3335:3335 \
  -p 38890:38890 \
  sallykolodny/db4e:p2poolqa
