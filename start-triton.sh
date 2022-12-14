#!/bin/bash

#
# Script to run the NVIDIA Triton model server. The
# model repository is pointed to an AWS s3 bucket.
#
# Modify the default values listed below or enter them
# from the command line when prompted.
#
# The AWS_DEFAULT_REGION is the region of the s3 bucket
# that contains the model repository.
#
default_region=us-east-1
default_model_repository="s3://koz-triton-test"
default_id=XXXXXXXXXXXXXXXXXXXX
default_secret="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

# echo -n "Enter AWS_ACCESS_KEY_ID (${default_id}): "
# read id
# if [ -z "$id" ] ; then id=${default_id}; fi

# echo -n "Enter AWS_SECRET_ACCESS_KEY (${default_secret}): "
# read secret
# if [ -z "$secret" ] ; then secret=${default_secret}; fi

echo -n "Enter region (${default_region}): "
read region
if [ -z "$region" ] ; then region=${default_region}; fi

echo -n "Enter model-repository: (${default_model_repository}): "
read model_repository
if [ -z "$model_repository" ] ; then model_repository=${default_model_repository}; fi

#
# Modify the triton container image tag as necessary.
#
# podman run -it --rm --name=triton -p8000:8000 -p8002:8002 \
# -e AWS_ACCESS_KEY_ID=${id} \
# -e AWS_SECRET_ACCESS_KEY=${secret} \
# -e AWS_DEFAULT_REGION=${region} \
# nvcr.io/nvidia/tritonserver:22.11-py3 \
# tritonserver --model-repository=${model_repository}

podman run -it --rm --name=triton -p8000:8000 -p8002:8002 \
-e AWS_DEFAULT_REGION=${region} \
nvcr.io/nvidia/tritonserver:22.11-py3 \
tritonserver --model-repository=${model_repository}
