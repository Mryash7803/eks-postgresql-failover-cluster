# AWS EKS PostgreSQL High Availability Cluster

## Project Overview

This project demonstrates how to deploy a highly available PostgreSQL cluster on Amazon EKS using Kubernetes StatefulSets, Persistent Volumes, Amazon EBS, Zalando Postgres Operator, and Patroni.

The cluster is designed to provide:

* High Availability (HA)
* Automatic failover
* Persistent storage
* Replication
* Kubernetes-native database management

This project simulates a production-grade PostgreSQL deployment where database availability and data durability are critical requirements.

---

## Architecture

```text
                    Application
                          |
                          |
                    PostgreSQL Service
                          |
        ---------------------------------------
        |                  |                  |
        |                  |                  |
   postgres-0        postgres-1         postgres-2
    (Leader)          (Replica)          (Replica)
        |                  |                  |
        |                  |                  |
      PVC                PVC                PVC
        |                  |                  |
      EBS                EBS                EBS
```

### Components Used

| Component                 | Purpose                                 |
| ------------------------- | --------------------------------------- |
| Amazon EKS                | Kubernetes Cluster                      |
| EBS CSI Driver            | Dynamic Volume Provisioning             |
| EKS Pod Identity Agent    | AWS Credential Access for CSI Driver    |
| StatefulSet               | Stable Database Pods                    |
| Persistent Volume Claims  | Persistent Storage                      |
| Amazon EBS                | Durable Block Storage                   |
| Zalando Postgres Operator | PostgreSQL Lifecycle Management         |
| Patroni                   | PostgreSQL High Availability & Failover |
| PostgreSQL 17             | Database Engine                         |
| Helm                      | Kubernetes Package Management           |

---

## Objectives

* Deploy PostgreSQL on Kubernetes
* Configure persistent storage using Amazon EBS
* Implement PostgreSQL replication
* Configure automatic failover using Patroni
* Verify data persistence after pod failures
* Simulate leader node failure and recovery

---

## Prerequisites

* AWS Account
* AWS CLI
* kubectl
* eksctl
* Helm
* IAM permissions to create EKS resources

---

## Create EKS Cluster

```bash
eksctl create cluster \
  --name stateful-postgres-cluster \
  --region ap-south-1 \
  --nodegroup-name postgres-workers \
  --node-type t3.medium \
  --nodes 3 \
  --managed
```

Verify cluster:

```bash
kubectl get nodes
```

---

## Install EKS Pod Identity Agent

This step is required for the EBS CSI Driver to obtain AWS credentials.

```bash
eksctl create addon \
  --cluster stateful-postgres-cluster \
  --region ap-south-1 \
  --name eks-pod-identity-agent
```

Without this addon, the EBS CSI controller may repeatedly restart with errors similar to:

```text
Get "http://169.254.170.23/v1/credentials":
dial tcp 169.254.170.23:80: i/o timeout
```

---

## Install EBS CSI Driver

```bash
eksctl create addon \
  --cluster stateful-postgres-cluster \
  --region ap-south-1 \
  --name aws-ebs-csi-driver \
  --service-account-role-arn auto \
  --force
```

Verify:

```bash
kubectl get pods -n kube-system
```

---

## Create Storage Class

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: gp3
provisioner: ebs.csi.aws.com
volumeBindingMode: WaitForFirstConsumer
allowVolumeExpansion: true
parameters:
  type: gp3
```

Apply:

```bash
kubectl apply -f gp3-storageclass.yaml
```

---

## Install Zalando Postgres Operator

```bash
helm repo add postgres-operator-charts \
https://opensource.zalando.com/postgres-operator/charts/postgres-operator

helm repo update
```

Create namespace:

```bash
kubectl create namespace postgres-operator
```

Install operator:

```bash
helm install postgres-operator \
postgres-operator-charts/postgres-operator \
-n postgres-operator
```

---

## Deploy PostgreSQL HA Cluster

```yaml
apiVersion: acid.zalan.do/v1
kind: postgresql
metadata:
  name: devops-postgres
  namespace: database

spec:
  teamId: "devops"

  numberOfInstances: 3

  volume:
    size: 5Gi
    storageClass: gp3

  users:
    app_user:
      - login
      - createdb

  databases:
    appdb: app_user

  postgresql:
    version: "17"
```

Deploy:

```bash
kubectl apply -f postgres-cluster.yaml
```

Verify:

```bash
kubectl get pods -n database
kubectl get pvc -n database
kubectl get svc -n database
```

---

## Database Connectivity Test

Launch temporary PostgreSQL client:

```bash
kubectl run psql-client \
  --rm -it \
  --image=postgres:17 \
  --namespace database \
  -- bash
```

Connect:

```bash
psql "sslmode=require host=devops-postgres.database.svc.cluster.local user=app_user dbname=appdb"
```

---

## Data Persistence Test

Create sample table:

```sql
CREATE TABLE test (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);

INSERT INTO test(name)
VALUES ('Yash');

SELECT * FROM test;
```

Output:

```text
 id | name
----+------
 1  | Yash
```

---

## Failover Test

Identify current leader:

```bash
kubectl exec -it -n database devops-postgres-0 -- patronictl list
```

Delete leader pod:

```bash
kubectl delete pod devops-postgres-0 -n database
```

Watch failover:

```bash
kubectl get pods -n database -w
```

Verify new leader:

```bash
kubectl exec -it -n database devops-postgres-1 -- patronictl list
```

---

## Validation

During failover:

```text
FATAL: terminating connection due to administrator command
SSL connection has been closed unexpectedly
```

After automatic reconnection:

```sql
SELECT * FROM test;
```

Result:

```text
 id | name
----+------
 1 | Yash
```

This confirms:

* Automatic failover succeeded
* Data persisted successfully
* EBS-backed PVC retained database files
* PostgreSQL replication remained healthy

---

## Key Learnings

* Kubernetes StatefulSets
* Persistent Volumes and PVCs
* Amazon EBS Integration
* EKS Pod Identity
* EBS CSI Driver
* PostgreSQL Replication
* Patroni Failover
* High Availability Architecture
* Kubernetes Storage Management
* Production Database Operations

---

## Cleanup

Delete EKS cluster:

```bash
eksctl delete cluster \
  --name stateful-postgres-cluster \
  --region ap-south-1
```

---

## Author

Yash Singar

DevOps Engineer | Linux Administrator | AWS & Kubernetes Enthusiast
