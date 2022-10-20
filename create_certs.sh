#!/bin/bash
# 
# Copyright (C) 2022 Sven Erik Knop, Confluent
# No warrenty give or implied
#
# Script to create signed SSL certificates
# Input
#   Location of CA file
#   Location of CAKey file
#   Location of text file containing hostnames, one host for each line

set -euo pipefail

CAfile=$1
CAKeyfile=$2
hostfile=$3

function create_cert_for_host() {
    host=$1
    echo "Creating cert for $host"

    # Use template to create CNF file
    sed "s/{{hostname}}/$host/g" template_cert.cnf  > certs/$host.cnf
}

# ensure certs directory is available
mkdir -p certs

while read -r hostname || [[ -n "${hostname}" ]]; do
    create_cert_for_host $hostname
done < "$hostfile"
