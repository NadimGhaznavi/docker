#!/bin/bash

# Get the hostname, we'll use it in the log name and the STDIN named pipe name
HOSTNAME=$(hostname)

# Set the P2Pool base directory.
if [ -d /opt/p2pool ]; then
  # Running in a container with this path
  P2P_DIR="/opt/p2pool"
elif [ -d /opt/dev/p2pool ]; then
  # Running in DEV on bare metal, on the docker host, with this path
  P2P_DIR="/opt/dev/p2pool"
fi

# Usually /opt/p2pool/run is mounted with a "-v" switch to "docker run...".
# Incase the directory hasn't been automounted at runtime, then create it
# on the container's (temporary) filesystem:
RUN_DIR=${P2P_DIR}/run
if [ ! -d ${RUN_DIR} ]; then
	mkdir -p ${RUN_DIR}
fi

STDIN=${RUN_DIR}/p2pool-${HOSTNAME}.stdin
# Setup the named pipe for interacting with P2Pool
if [ -e $STDIN ]; then
  rm -f $STDIN
fi
mkfifo $STDIN

# Configure access to the Monero Daemon that hosts the blockchain
MONERO_NODE="192.168.0.176"
ZMQ_PORT=20083
RPC_PORT=20081

# P2Pool settings
ANY_IP="0.0.0.0"
STRATUM_PORT=3335
P2P_PORT=38890
WALLET="48wY7nYBsQNSw7v4LjoNnvCtk1Y6GLNVmePGrW82gVhYhQtWJFHi6U6G3X5d7JN2ucajU9SeBcijET8ZzKWYwC3z3Y6fDEG"
LOG_LEVEL=1
IN_PEERS=16
OUT_PEERS=16
DATA_API_DIR="${P2P_DIR}/json"
P2P_LOG="${RUN_DIR}/p2pool-${HOSTNAME}.log"
P2POOL="${P2P_DIR}/p2pool"

USER=$(whoami)
if [ "$USER" != "root" ]; then
	echo "ERROR: Run the p2pool daemon as root, exiting.."
	exit 1
fi

tail -f $STDIN | $P2POOL \
	--host ${MONERO_NODE} \
	--wallet ${WALLET} \
	--mini \
	--stratum ${ANY_IP}:${STRATUM_PORT} \
	--p2p ${ANY_IP}:${P2P_PORT} \
	--rpc-port ${RPC_PORT} \
	--zmq-port ${ZMQ_PORT} \
	--loglevel ${LOG_LEVEL} \
	--in-peers ${IN_PEERS} \
	--out-peers ${OUT_PEERS} \
	| tee -a ${P2P_LOG}
