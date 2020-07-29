oc create secret -n presto generic presto-license --from-file signed.license

oc new-app -n presto --name=metastore --template=postgresql-persistent-cephrbd \
-e POSTGRESQL_USER=redhat \
-e POSTGRESQL_PASSWORD=redhat \
-e POSTGRESQL_DATABASE=redhat
