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
# set -x

CAfile=$1
CAKeyfile=$2
hostfile=$3

password="changeme"

function create_cert_for_host() {
    host=$1
    echo "Creating cert for $host"

    # Use template to create CNF file
    sed "s/{{hostname}}/$host/g" template_cert.cnf  > certs/$host.cnf
    openssl req -new -newkey rsa:4096 -keyout certs/$host.key -nodes -out certs/$host.csr -config certs/$host.cnf

    echo "Will be signed by $CAfile with $CAKeyfile"
    openssl x509 -req -CA $CAfile -CAkey $CAKeyfile  -in certs/$host.csr -out certs/$host.crt -days 3650 -CAcreateserial -extensions req_ext -extfile certs/$host.cnf

    echo "Convert to pkc12 file"
    openssl pkcs12 -password pass:$password -export -in certs/$host.crt -inkey certs/$host.key -out certs/$host.p12 -name service

    keytool -importkeystore \
        -deststorepass $password -destkeypass $password  -destkeystore certs/$host-keystore.jks \
        -srckeystore certs/$host.p12 -srcstoretype PKCS12 -srcstorepass $password -alias service
}

# ensure certs directory is available
mkdir -p certs

while read -r hostname || [[ -n "${hostname}" ]]; do
    create_cert_for_host $hostname
done < "$hostfile"
