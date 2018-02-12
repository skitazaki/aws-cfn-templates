AWS CloudFormation Templates
=============================

Collection of CloudFormation templates.

| Name       | Description |
|------------|-------------|
| VPC        | VPC network similar to AWS Quick Start without NAT |
| NAT        | NAT gateway in VPC network |
| EC2 Simple | Single EC2 instance in public subnet, EIP attached |
| EC2 Solr   | Solr search server behind ALB with bastion support |

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

### Simple Instance

`aws-cfn-ec2-simple.yml` is a template for simple command line work.
An instance is created in public subnet in VPC network.

EC2 instance includes:

* Python 3.6 (`pipenv` and `ansible`)
* Go
* Git, tmux, zsh, jq
* Docker

Usage:

```bash
$ aws cloudformation create-stack \
    --stack-name SimpleConsole \
    --template-body file://`pwd`/files/aws-cfn-ec2-simple.yml \
    --parameters \
        ParameterKey=VPCStackName,ParameterValue=TestVPC \
        ParameterKey=KeyPairName,ParameterValue=${EC2_KEYNAME} \
        ParameterKey=RemoteAccessCIDR1,ParameterValue=${REMOTE_CIDR}
```

This template accepts four remote CIDR addresses on parameters.

To confirm Amazon Linux AMI ID, visit [Amazon Linux AMI](http://aws.amazon.com/jp/amazon-linux-ami/)
and [Amazon Linux AMI instance type matrix](https://aws.amazon.com/jp/amazon-linux-ami/instance-type-matrix/) pages.

### Solr

`aws-cfn-ec2-solr.yml` is a template of Solr server with Application Load Balancer.
This template also create a bastion host in public subnet for manual operation through SSH.

* Open JDK 1.8
* Solr 7.2.1 (*SolrVersion* parameter is used)

Usage:

```bash
$ aws cloudformation create-stack \
    --stack-name Solr \
    --template-body file://`pwd`/files/aws-cfn-ec2-solr.yml \
    --parameters \
        ParameterKey=VPCStackName,ParameterValue=TestVPC \
        ParameterKey=KeyPairName,ParameterValue=${EC2_KEYNAME} \
        ParameterKey=RemoteAccessCIDR1,ParameterValue=${REMOTE_CIDR}
```

Bootstrapping feature prepares two cores; *core1* and *techproducts*.
*core1* is copied from *_default* config set, while *techproducts* is copied from *sample_techproducts_configs*
Both cores require initialization requests from Core Admin in dashboard, whose URL is shown in outputs of the stack.

For more information about Solr, see official tutorial.

- [Solr Tutorial](https://lucene.apache.org/solr/guide/7_2/solr-tutorial.html)
