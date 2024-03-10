#!/bin/bash

# Define the file to be modified
file=".terraform/modules/bog-vpc/main.tf"

# Comment out specific lines using sed
sed -i 's/enable_classiclink             = null/# enable_classiclink             = null/g' $file
sed -i 's/enable_classiclink_dns_support = null/# enable_classiclink_dns_support = null/g' $file
