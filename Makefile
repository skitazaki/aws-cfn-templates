S3_STORAGE := s3://${AWS_S3_BUCKET}/${AWS_S3_PREFIX}

.PHONY: all
all: help

.PHONY: validate
validate:  ## Validate templates file
	aws cloudformation validate-template --template-body file://`pwd`/files/aws-cfn-vpc.yml
	aws cloudformation validate-template --template-body file://`pwd`/files/aws-cfn-nat.yml
	aws cloudformation validate-template --template-body file://`pwd`/files/aws-cfn-ec2-simple.yml
	aws cloudformation validate-template --template-body file://`pwd`/files/aws-cfn-ec2-solr.yml
	aws cloudformation validate-template --template-body file://`pwd`/files/aws-cfn-ec2-jupyter.yml

.PHONY: upload
upload:  ## Upload templates file
	aws s3 cp files/aws-cfn-vpc.yml $(S3_STORAGE)/aws-cfn-vpc.yml
	aws s3 cp files/aws-cfn-nat.yml $(S3_STORAGE)/aws-cfn-nat.yml
	aws s3 cp files/aws-cfn-ec2-simple.yml $(S3_STORAGE)/aws-cfn-ec2-simple.yml
	aws s3 cp files/aws-cfn-ec2-solr.yml $(S3_STORAGE)/aws-cfn-ec2-solr.yml

.PHONY: upload-ec2-jupyter
upload-ec2-jupyter:  ## Upload templates file of JupyterLab on EC2 stack
	aws s3 cp files/aws-cfn-ec2-jupyter.yml $(S3_STORAGE)/aws-cfn-ec2-jupyter.yml

.PHONY: help
help:  ## Show this messages
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: clean
clean:  ## Clean working files
	@rm -f *~
