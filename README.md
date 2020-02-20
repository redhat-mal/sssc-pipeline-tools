# tssc-pipeline-tools
Trusted Software Supply Chain Pipeline Tools

## Overview
This repo is used to install the TSSC tools needed to run pipelines.  The tools installed can be configured by modified the deployment values.  The install is based on Helm charts.

## Instalation

The install parameters are defined in the helm/values.yaml.  The namespace is defined in the file and must exists before installation.  The apps installed are determined by the enabled flag.  

### Install via Apply

helm template v1 ./helm | oc apply -f-

### Install via Helm

TODO: 
