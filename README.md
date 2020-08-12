# Setting up OCS + Presto

## OCP Cluster notes

Fixed with new Presto operator version

~~We noticed an issue when the OpenShift SDN was used that prevented presto
workers from talking to some hosts.~~

## Typical OCS steps

Create OCS namespace (optional, depending on the OCS operator version, newest one do it automatically)

```bash
oc create namespace openshift-storage
```

Install OCS using OLM

```bash
insert screenshot
```

Install OCS using Console

```bash
insert screenshot
```

## Extra OCS Setup

### Ceph toolbox

The Ceph toolbox may prove handy for debugging. You can install it with:

```bash
oc create -f 01_rook_toolbox.yaml
```

After installation, commands may not work because the keyring is missing. Copy the content of the keyring from one of the MONs, in /etc/ceph/keyring

## ObjectStore

OCS does not automatically deploy Ceph object storage in EC2 (AWS), so we need to
provide a CephObjectStore CR. That's only when you are on AWS, otherwise the ObjectStore is automatically created.

```bash
oc create -f 02_ceph_rgw_object_store.yaml
```

## ~~Object bucket StorageClass~~

Does not work, can skip this step.

~~Even outside of EC2, OCS does not by default create a Ceph object storage
class for object bucket claims (this may change in 4.5/4.6).~~

```bash
oc create -f 03_rgw_class.yaml
```

### ~~Create S3 bucket for presto using an object bucket claim~~

This does not work because of the storage class issue. You can skip this step and replace it with the following one.

```bash
oc create -f 04_presto_obc.yaml
```

### Create an Object Store User in the RGW

**Edit** the file `05_object_store_user.yaml` and replace the object store name with the one that was either deployed by OCS (the default in the file), or by the one you created earlier if you are on AWS.

```bash
oc create -f 05_object_store_user.yaml
```

For further steps, please make note of:

- The **access and secret keys** for the user you just created. They can be found in a **Secret** in the **openshift-storage** namespace. This secret would be named for example **rook-ceph-object-user-ocs-storagecluster-cephobjectstore-s3user1**
- The **IP address of the RGW**, which can be found in  Networking/Services in OCP UI. This service would be named for example **rook-ceph-rgw-ocs-storagecluster-cephobjectstore**

## Presto Setup

### Create Presto namespace

```bash
oc create namespace presto
```

### Create Postgres template to use for metastore

```bash
06_postgres_template.sh
```

### Create metastore instance

```bash
07_presto_metastore.sh
```

### Create the Presto license Secret

```bash
oc create -f 08_presto_license.yaml
```

### Create the S3 access secret

**Edit** the `09_presto_S3_secret.yaml`file and replace Access and Secret key fields with the values for the S3 user you created before.

```bash
oc create -f 09_presto_S3_secret.yaml
```

### Install Starburst Operator from console using OLM

```bash
insert screenshot
```

### Edit and create Presto CR

Edit the `09_presto_cr.yaml` file and replace the endoint addresses with the IP of the RGW service (IP is a workaround to force the use of path-style access to the S3 storage).

```bash
oc create -f 09_presto_cr.yaml
```

This will create a Presto instance as well as the Route to connect to it.

## Using Presto

### Connection

You can either expose the coordinator and connect from your local machine using
the presto-cli, or you can rsh to the coordinator deployment/pod and use the
presto-cli located there.

```bash
oc rsh deployment/presto-coordinator
```

To connect externally, download the Presto CLI at 
and do:

```bash
presto --server <replace_with_route> --catalog hive --schema default
```

### S3 storage

Before being able to use the S3 storage to store tables, you must create a bucket. You can use you favorite tool, like s3cmd, using the access/secret keys from the user created previously.
