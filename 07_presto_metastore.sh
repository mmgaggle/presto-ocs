oc new-project presto
oc new-app -n presto --name=metastore --template=postgresql-persistent-cephrbd \
-e POSTGRESQL_USER=redhat \
-e POSTGRESQL_PASSWORD=redhat \
-e POSTGRESQL_DATABASE=redhat
