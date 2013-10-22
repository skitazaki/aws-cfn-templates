AWS CloudFormation Templates
=============================

Collection of CloudFormation templates.

To use AWS CLI tools, install *awscli*.
[http://aws.amazon.com/jp/cli/]

1. Follow the instruction here, using *pip*.
   [https://pypi.python.org/pypi/awscli]

2. Create configuration file including:
    * aws_access_key_id
    * aws_secret_access_key
    * region

3. Set environmetal variable **AWS_CONFIG_FILE** to point the configuration file.

To see parameters and capabilities, run ``validate-template`` command.

    $ aws cloudformation validate-template --template-body awscfn-solr.json

To delete stack, use ``delete-stack`` command.

    $ aws cloudformation delete-stack --stack-name {STACK_NAME}

To show the list of stacks, use ``describe-stacks`` command.

    $ aws cloudformation describe-stacks

Check "I acknowledge that this this template may create IAM resources" on when creating a stack.
Or "CAPABILITY_IAM" on the command line option if the template requires IAM Role.

Simple Tool
------------

``awscfn-simple-tool.json`` is a template of simple command line tool including:

* Python 2.7 (``virtualenv`` + ``pip``)
* JDK 1.7
* GCC 4.7
* Git
* S3 Tools (``s3cmd``) - will be removed due to *awscli*
* MySQL 5.5 Client
* jq

Usage:

    $ aws cloudformation create-stack \
        --stack-name simple-tool \
        --template-body file://`pwd`/awscfn-simple-tool.json \
        --parameters ParameterKey=KeyName,ParameterValue=${EC2_KEYNAME}

Solr
-----

``awscfn-solr.json`` is a template of Solr server.

* JDK 1.7
* Tomcat 7
* Solr 4.3

Usage:

    $ aws cloudformation create-stack \
        --stack-name solr \
        --template-body file://`pwd`/awscfn-solr.json \
        --parameters ParameterKey=KeyName,ParameterValue=${EC2_KEYNAME}
        --capabilities CAPABILITY_IAM
