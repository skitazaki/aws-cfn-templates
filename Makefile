S3_STORAGE := s3://${AWS_S3_BUCKET}/${AWS_S3_PREFIX}

.PHONY: all
all: help

.PHONY: validate
validate:  ## Validate template files
	aws cloudformation validate-template --template-body file://`pwd`/files/aws-cfn-vpc.yml
	aws cloudformation validate-template --template-body file://`pwd`/files/aws-cfn-nat.yml
	aws cloudformation validate-template --template-body file://`pwd`/files/aws-cfn-ec2-simple.yml
	aws cloudformation validate-template --template-body file://`pwd`/files/aws-cfn-ec2-solr.yml
	aws cloudformation validate-template --template-body file://`pwd`/files/aws-cfn-ec2-jupyter.yml

.PHONY: upload
upload:  ## Upload template files
	aws s3 cp files/aws-cfn-vpc.yml $(S3_STORAGE)/aws-cfn-vpc.yml
	aws s3 cp files/aws-cfn-nat.yml $(S3_STORAGE)/aws-cfn-nat.yml

.PHONY: upload-simple
upload-simple:  ## Upload template file of single instance on EC2 stack
	aws s3 cp files/aws-cfn-ec2-simple.yml $(S3_STORAGE)/aws-cfn-ec2-simple.yml

.PHONY: upload-solr
upload-solr:  ## Upload template file of Solr server on EC2 stack
	aws s3 cp files/aws-cfn-ec2-solr.yml $(S3_STORAGE)/aws-cfn-ec2-solr.yml

.PHONY: upload-jupyter
upload-jupyter:  ## Upload template file of JupyterLab on EC2 stack
	aws cloudformation validate-template --template-body file://files/aws-cfn-ec2-jupyter.yml
	aws s3 cp files/aws-cfn-ec2-jupyter.yml $(S3_STORAGE)/aws-cfn-ec2-jupyter.yml

.PHONY: upload-cwlog-policy
upload-cwlog-policy:  ## Upload template file of putting retention policy on CloudWatch Logs
	aws s3 cp files/aws-cfn-cwlog-policy.yml $(S3_STORAGE)/aws-cfn-cwlog-policy.yml

.PHONY: help
help:  ## Show this messages
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: clean
clean:  ## Clean working files
	@rm -f *~
