# Setting up OCS + Presto

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


