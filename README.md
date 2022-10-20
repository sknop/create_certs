# create_certs
Create TLS certificates and sign them for a list of hosts

Simple script to create signed certificates from a text file with a list of hosts

Invoke with
  
  create_certs.sh /path/to/cacert.pem /path/to/cakey.pem  hostnames.txt
  
Will create a directory called certs and place all files in here.

The hostname file should just contain hostnames separated by newline:

  host1
  host2
  host3
  
And so on

Will create a keystore file with certs and key stored and protected by password
