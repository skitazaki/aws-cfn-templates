AWS CloudFormation Templates
=============================

Collection of CloudFormation templates.

Check "I acknowledge that this this template may create IAM resources" on when creating a stack.
Or "CAPABILITY_IAM" on the command line option if the template requires IAM Role.

To use CloudFormation CLI tools:

1. Download and unzip archive from here.
    http://aws.amazon.com/developertools/2555753788650372

2. Assign following environmental variables.
    * EC2_REGION
    * AWS_CLOUDFORMATION_HOME
    * AWS_CREDENTIAL_FILE

Example:

    export EC2_REGION=ap-northeast-1
    export AWS_CLOUDFORMATION_HOME=$HOME/.awstools/AWSCloudFormation-1.0.12
    export AWS_CREDENTIAL_FILE=$HOME/.aws-credential
    export PATH=$PATH:$AWS_CLOUDFORMATION_HOME/bin

To see parameters and capabilities, run ``cfn-validate-template`` command.

    $ cfn-validate-template --template-file awscfn-solr.json

To delete stack, use ``cfn-delete-stack``.

    $ cfn-delete-stack {STACK_NAME}

Simple Tool
------------

``awscfn-simple-tool.json`` is a template of simple command line tool including:

* Python 2.7 (``virtualenv`` + ``pip``)
* JDK 1.7
* Git
* S3 Tools (``s3cmd``)
* MySQL 5.5 Client

Usage:

    $ cfn-create-stack simple-tool --template-file awscfn-simple-tool.json \
        --parameters KeyName=${EC2_KEYNAME}

Solr
-----

``awscfn-solr.json`` is a template of Solr server.

* JDK 1.7
* Tomcat 7
* Solr 4.3

Usage:

    $ cfn-create-stack solr --template-file awscfn-solr.json \
        --parameters KeyName=${EC2_KEYNAME} \
        --capabilities CAPABILITY_IAM
