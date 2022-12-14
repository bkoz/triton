# Triton Model Server (this should be merged with the fingerprint repo)

## Build and Deploy

### On Openshift
```
oc new-app https://github.com/bkoz/triton
```

### Expose the service
```
oc expose service triton
```

### Get the route and test.
```
HOST=$(oc get routes --output=custom-columns=':.spec.host' --no-headers=true)
```

If the `model_repository` directory is removed the `fetch_models.sh` script
will not rebuild it correctly.

[Triton v2 protocol extensions](https://docs.nvidia.com/deeplearning/triton-inference-server/user-guide/docs/protocol/extension_model_configuration.html)

```
curl triton-triton.apps.ocp.sandbox2395.opentlc.com/v2
curl triton-triton.apps.ocp.sandbox2395.opentlc.com/v2/models/densenet_onnx
curl triton-triton.apps.ocp.sandbox2395.opentlc.com/v2/models/densenet_onnx | jq
curl triton-triton.apps.ocp.sandbox2395.opentlc.com/v2/models/densenet_onnx/config | jq

curl -v triton-triton.apps.ocp.sandbox2395.opentlc.com/v2/models/densenet_onnx/config

podman run -it --rm --net=host nvcr.io/nvidia/tritonserver:22.11-py3-sdk /workspace/install/bin/image_client -m densenet_onnx -c 3 -s INCEPTION /workspace/images/mug.jpg -u triton-triton.apps.ocp.sandbox2395.opentlc.com
```

Test the *simple* model. The `versions/N` path is optional.
```
curl -X POST -H "Content-Type: application/json" -d @request-simple.json ${HOST}:8000/v2/models/simple/infer
```
```
{"model_name":"simple","model_version":"1","outputs":[{"name":"OUTPUT0","datatype":"INT32","shape":[1,16],"data":[2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32]},{"name":"OUTPUT1","datatype":"INT32","shape":[1,16],"data":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]}]}
```
```
curl $HOST/v2
curl $HOST/v2/models/densenet_onnx
curl $HOST/v2/models/densenet_onnx | jq
curl $HOST/v2/models/densenet_onnx/config | jq
curl -v $HOST/v2/models/densenet_onnx/config
```

### Test Inference
```
podman run -it --rm --net=host nvcr.io/nvidia/tritonserver:22.09-py3-sdk /workspace/install/bin/image_client -m densenet_onnx -c 3 -s INCEPTION /workspace/images/mug.jpg -u $HOST
```

Expected output
```
=================================
== Triton Inference Server SDK ==
=================================

NVIDIA Release 22.09 (build 44909149)

Copyright (c) 2018-2022, NVIDIA CORPORATION & AFFILIATES.  All rights reserved.

Various files include modifications (c) NVIDIA CORPORATION & AFFILIATES.  All rights reserved.

This container image and its contents are governed by the NVIDIA Deep Learning Container License.
By pulling and using the container, you accept the terms and conditions of this license:
https://developer.nvidia.com/ngc/nvidia-deep-learning-container-license

WARNING: The NVIDIA Driver was not detected.  GPU functionality will not be available.
   Use the NVIDIA Container Toolkit to start this container with GPU support; see
   https://docs.nvidia.com/datacenter/cloud-native/ .

Request 0, batch size 1
Image '/workspace/images/mug.jpg':
    15.349563 (504) = COFFEE MUG
    13.227461 (968) = CUP
    10.424893 (505) = COFFEEPOT

