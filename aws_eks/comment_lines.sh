#!/bin/bash

# Define the file to be modified
file=".terraform/modules/bog-vpc/main.tf"

# Use awk to comment out specific lines
awk '/enable_classiclink             = null/ {print "# enable_classiclink             = null"; next} 1' $file > temp && mv temp $file

awk '/enable_classiclink_dns_support = null/ {print "# enable_classiclink_dns_support = null"; next} 1' $file > temp && mv temp $file
