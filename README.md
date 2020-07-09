# Setting up OCS + Presto

# Typical OCS steps

# Extra Steps

Setup Ceph object storage (only required on EC2)

```
oc create -f rgw.yaml
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


