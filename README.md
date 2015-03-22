AWS CloudFormation Templates
=============================

Collection of CloudFormation templates.

To use AWS CLI tools, install [*awscli*](http://aws.amazon.com/jp/cli/).

1. Follow the instruction, using [*pip*](https://pypi.python.org/pypi/awscli).

2. Create a configuration file `$HOME/.aws/config` including:
    * aws_access_key_id
    * aws_secret_access_key
    * region

To see parameters and capabilities, run ``validate-template`` command.

    $ aws cloudformation validate-template --template-body file://`pwd`/awscfn-solr.json

To delete stack, use ``delete-stack`` command.

    $ aws cloudformation delete-stack --stack-name {STACK_NAME}

To show the list of stacks, use ``describe-stacks`` command.

    $ aws cloudformation describe-stacks

Check "I acknowledge that this this template may create IAM resources" on when creating a stack.
Or "CAPABILITY_IAM" on the command line option if the template requires IAM Role.

To confirm Amazon Linux AMI ID, visit [Amazon Linux AMI](http://aws.amazon.com/jp/amazon-linux-ami/) page
and [Amazon Linux AMI instance type matrix](https://aws.amazon.com/jp/amazon-linux-ami/instance-type-matrix/) page.


Simple Tool
------------

``awscfn-simple-tool.json`` is a template of simple command line tool including:

* Python 2.7 (`pip`, `virtualenv`, and `ansible`)
* Git
* Docker, Docker Compose
* tmux, zsh, direnv
* jq, q, peco

Usage:

```bash
$ aws cloudformation create-stack \
    --stack-name simple-tool \
    --template-body file://`pwd`/awscfn-simple-tool.json \
    --parameters \
        ParameterKey=KeyName,ParameterValue=${EC2_KEYNAME} \
        ParameterKey=InstanceType,ParameterValue=t1.micro
```

Solr
-----

``awscfn-solr.json`` is a template of Solr server.

* JDK 1.7
* Tomcat 7
* Solr 4.5 (*SolrVersion* parameter)

Usage:

    $ aws cloudformation create-stack \
        --stack-name solr \
        --template-body file://`pwd`/awscfn-solr.json \
        --parameters ParameterKey=KeyName,ParameterValue=${EC2_KEYNAME} \
        --capabilities CAPABILITY_IAM
