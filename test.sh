#!/bin/sh
#/ Usage: test.sh

set -eu

BASEDIR=`cd $(dirname $0) && pwd`
EC2_KEYNAME=${EC2_KEYNAME-id_aws}
CFN_TEMPLATE=$BASEDIR/awscfn-simple-tool.json
STACK_NAME="simple-tool-test"
INSTANCE_TYPE=t.micro

###############################################################################
### Utility functions
# GitHub Enterprise Backup Utilities
# https://github.com/github/backup-utils

# Function to print usage embedded in a script's opening doc comments.
print_usage () {
    grep '^#/' <"$0" | cut -c 4-
    exit ${1:-1}
}

# Check for a "--help" arg and show usage
for a in "$@"; do
    if [ "$a" = "--help" ]; then
        print_usage
    fi
done

###############################################################################
### Run tasks

aws cloudformation create-stack \
    --stack-name $STACK_NAME \
    --template-body file://$CFN_TEMPLATE \
    --parameters \
        ParameterKey=KeyName,ParameterValue=$EC2_KEYNAME \
        ParameterKey=InstanceType,ParameterValue=t1.micro \
    --disable-rollback

