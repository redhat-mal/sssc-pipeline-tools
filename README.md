# tssc-pipeline-tools
Trusted Software Supply Chain Pipeline Tools

## Overview
This repo is used to install the TSSC tools needed to run pipelines.  The tools installed can be configured by modified the deployment values.  The install is based on Helm charts.

The following tools are currently installed via Helm
* Jenkins with dependent plugins and configurations
* Sonrqube scanner
* Nexus repository with a Docker repo configured
* Anchore scanning tool with a default profile installed

## Instalation

The install parameters are defined in the helm/values.yaml.  The namespace is defined in the file and must exists before installation.  The apps installed are determined by the enabled flag.  

### Install via Apply

````
oc new-project tssc-tools

helm template v1 ./helm/ --set global.namespace=tssc-tools --set global.cluster_url=mikes.sandbox389.opentlc.com | oc apply -f-

oc start-bulid tssc-post-config-runonce
````
### Install via Helm

helm install v1 ./helm/ --set global.namespace=tssc-tools --set global.cluster_url=mikes.sandbox389.opentlc.com

oc start-build tssc-post-config-runonce
