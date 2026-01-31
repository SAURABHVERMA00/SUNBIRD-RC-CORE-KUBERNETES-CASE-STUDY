# Sunbird Registry and Credentials

![Build](https://github.com/Sunbird-RC/sunbird-rc-core/actions/workflows/maven.yml/badge.svg)


Sunbird RC is an open-source software framework for rapidly building electronic
registries, enable atestation capabilities, and build verifiable credentialling
with minimal effort.

Registry is a shared digital infrastructure which enables authorized data
repositories to publish appropriate data and metadata about a user/entity along
with the link to the repository in a digitally signed form. It allows data
owners to provide authorized access to other users/entities in controlled manner
for digital verification and usage.


## Installation and Setup

See
[the installation and getting started guide](https://docs.sunbirdrc.dev/developer-documentation/installation-guide).

More documentation can be found [here](https://docs.sunbirdrc.dev/).

## [Help / Discussion](https://github.com/Sunbird-RC/community/discussions)

## License

This repository's contents are licensed under the MIT license. See the
[license file](./LICENSE) for more details.

## Configmap file
command: 
kubectl create configmap file_name-config-files \
  --from-file=folder/file_name \
  --dry-run=client -o yaml > file_name-config-files.yaml


1.kubectl create configmap file_name-config-files -  You are creating a ConfigMap

2.--from-file=folder/file_name  - Take everything inside this directory and store it in the ConfigMap

3.--dry-run=client - Do NOT create the ConfigMap in Kubernetes . Just simulate it locally
Why this is best practice:
You can review the YAML
You can commit it to Git
You avoid accidental cluster changes

4.-o yaml - Kubernetes prints the resource as YAML . Instead of creating it

5.> file_name-config-files.yaml - Save the generated YAML to a file


final command: kubectl apply -f file_name-config-files.yaml 
