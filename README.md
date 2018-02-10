AWS CloudFormation Templates
=============================

Collection of CloudFormation templates.

| Name | Description |
|------|-------------|
| VPC  | VPC network similar to AWS Quick Start without NAT |
| NAT  | NAT gateway in VPC network |

Development
-----------

### Setup

To use AWS CLI tools

1. Install [*awscli*](http://aws.amazon.com/jp/cli/) from [*PyPI*](https://pypi.python.org/pypi/awscli).
2. Create a credential file `$HOME/.aws/credentials`.
3. Create a local environment file `.envrc` and load it.

`.envrc` may include:

- *AWS_PROFILE*: Profile name in credential file.
- *AWS_DEFAULT_REGION*: AWS region name.
- *AWS_S3_BUCKET*: S3 bucket name to upload template files.
- *AWS_S3_PREFIX* Prefix string in S3 bucket to upload template files.

Sample file looks like:

```bash
export AWS_PROFILE=dev
export AWS_DEFAULT_REGION=ap-northeast-1
export AWS_S3_BUCKET=toolboxbucket
export AWS_S3_PREFIX=aws-cloudformation
```

### Workflow

Edit YAML template file and validate it by `validate-template` command in `aws`.

```bash
$ aws cloudformation validate-template --template-body file://`pwd`/files/aws-cfn-vpc.yml
```

Test stack creation and deletion using `create-stack` and `delete-stack` command.
Check "I acknowledge that this this template may create IAM resources" on when creating a stack.
Or "CAPABILITY_IAM" on the command line option if the template requires IAM Role.

```bash
$ aws cloudformation create-stack --stack-name ${STACK_NAME} \
    --template-body file://`pwd`/files/aws-cfn-vpc.yml \
    --cli-input-json file://`pwd`/utils/aws-cfn-vpc-input.json
```

Note that CLI parameters JSON cannot include external file.
"TemplateURL" works if the file is uploaded.

- [#1803 Ability to include external file contents in cli parameters json](https://github.com/aws/aws-cli/issues/1803)

To delete the stack, just pass stack name.

```bash
$ aws cloudformation delete-stack --stack-name ${STACK_NAME}
```

To show the list of stacks, use ``describe-stacks`` command.

```bash
$ aws cloudformation describe-stacks
```

Templates
---------

### VPC & NAT

Creates VPC network similar to AWS Quick Start without NAT gateway.

```bash
$ aws cloudformation create-stack --stack-name TestVPC \
    --template-body file://`pwd`/files/aws-cfn-vpc.yml \
    --parameters 'ParameterKey=AvailabilityZones,ParameterValue="ap-northeast-1d,ap-northeast-1c"'
```

Creates NAT gateway in VPC network.

```bash
$ aws cloudformation create-stack --stack-name TestNAT \
    --template-body file://`pwd`/files/aws-cfn-nat.yml \
    --parameters 'ParameterKey=VPCStackName,ParameterValue=TestVPC'
```

### Simple Tool

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

To confirm Amazon Linux AMI ID, visit [Amazon Linux AMI](http://aws.amazon.com/jp/amazon-linux-ami/) page
and [Amazon Linux AMI instance type matrix](https://aws.amazon.com/jp/amazon-linux-ami/instance-type-matrix/) page.

### Solr

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
