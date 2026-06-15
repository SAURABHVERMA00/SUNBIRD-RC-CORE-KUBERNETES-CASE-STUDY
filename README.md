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






# Sunbird RC Kubernetes Deployment Guide

## Prerequisites

* Docker
* Minikube
* kubectl
* Kubernetes Cluster Running

Verify:

```bash
kubectl cluster-info
kubectl get nodes
```

---

## Step 1: Create Required ConfigMaps

### 1. Signer Imports ConfigMap

Ensure the `imports` directory is available.

```bash
kubectl create configmap signer-imports \
  --from-file=imports \
  --dry-run=client -o yaml > signer-imports.yaml
```

Apply:

```bash
kubectl apply -f signer-imports.yaml
```

---

### 2. Public Key Imports ConfigMap

Ensure the `imports` directory is available.

```bash
kubectl create configmap public-key-imports \
  --from-file=imports \
  --dry-run=client -o yaml > public-key-imports.yaml
```

Apply:

```bash
kubectl apply -f public-key-imports.yaml
```

---

### 3. Vault Config ConfigMap

Ensure `vault.json` is available.

```bash
kubectl create configmap vault-config \
  --from-file=vault.json \
  --dry-run=client -o yaml > vault-config.yaml
```

Apply:

```bash
kubectl apply -f vault-config.yaml
```

---

## Step 2: Create Secrets

Create the required secrets using the provided example files.

Example:

```bash
kubectl apply -f secrets/identity-secret.example.yaml
kubectl apply -f secrets/registry-secret.example.yaml
```

Update placeholder values before applying.

---

## Step 3: Deploy Application

Deploy all Kubernetes resources:

```bash
kubectl apply -k .
```

or

```bash
kubectl apply -f .
```

depending on the deployment structure.

---

## Step 4: Verify Deployment

Check all pods:

```bash
kubectl get pods
```

Expected:

```text
STATUS: Running
READY: 1/1
```

for all application components.

---

## Step 5: Verify Services

```bash
kubectl get svc
```

---

## Step 6: Verify Stateful Components

```bash
kubectl get statefulsets
```

Expected:

* PostgreSQL
* Kafka
* ZooKeeper
* Redis
* Elasticsearch
* Vault

should all be Running.

---

## Troubleshooting

### Kafka Cluster ID Mismatch

If Kafka reports:

```text
InconsistentClusterIdException
```

delete both Kafka and ZooKeeper PVCs and redeploy:

```bash
kubectl delete pvc kafka-storage-kafka-deployment-0
kubectl delete pvc data-zookeeper-deployment-0
```

Then redeploy Kafka and ZooKeeper.

---

## Application Access

Check ingress and services:

```bash
kubectl get ingress
kubectl get svc
```

Use the configured ingress host or Minikube IP to access the application.
