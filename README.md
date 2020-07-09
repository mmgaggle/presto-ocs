# Setting up OCS + Presto

# OCP Cluster notes

We noticed an issue when the OpenShift SDN was used that prevented presto
workers from talking to some hosts.

# Typical OCS steps

Create OCS namespace

```
oc create namespace openshift-storage
```

Install OCS using OLM

```
insert screenshot
``` 

Install OCS using Console

```
insert screenshot
```

# Extra OCS Setup

OCS does not automatically deploy Ceph object storage in EC2, so we need to
provide a CephObjectStore CR .

```
oc create -f rgw.yaml
```

Even outside of EC2, OCS does not by default create a Ceph object storage
class for object bucket claims (this may change in 4.5/4.6).

```
oc create -f rgw-class.yaml
```

# Presto Setup

Create Presto namespace

```
oc create namespace presto
```

Create Postgres instance to use for metastore
```
template.sh
oc new-app -n presto --name=metastore --template=postgresql-persistent-cephrbd \
-e POSTGRESQL_USER=redhat \
-e POSTGRESQL_PASSWORD=redhat \
-e POSTGRESQL_DATABASE=redhat
```

Create S3 bucket for presto using an object bucket claim

```
oc create -f presto-obc.yaml
```

Install Starburst Operator from console using OLM

```
insert screenshot
```

Edit and create Presto CR

```
oc create -f presto.yaml
```

# Using Presto

You can either expose the coordinator and connect from your local machine using
the presto-cli, or you can rsh to the coordinator deployment/pod and use the
presto-cli located there.

```
oc rsh deployment/presto-coordinator
```

# Generating data with TPC-DS connector

