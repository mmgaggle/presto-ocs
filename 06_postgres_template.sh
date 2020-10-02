#!/bin/bash

temp_file=/tmp/template.$$

readonly CSI_DRIVER=ocs-storagecluster-ceph-rbd
readonly PV_SIZE=100Gi
readonly NEW_TEMPLATE_NAME=postgresql-persistent-cephrbd

oc get template -n openshift postgresql-persistent -o yaml > ${temp_file}

if [ "$(uname -s)" == "Linux" ];then
  sed -i "s/postgresql-persistent/${NEW_TEMPLATE_NAME}/g" ${temp_file}
  sed -i '/PersistentVolumeClaim/{n;d}' ${temp_file}
  sed -i "/PersistentVolumeClaim/a\  \metadata:\n    annotations:\n      volume.beta.kubernetes.io/storage-class: ${CSI_DRIVER}" ${temp_file}
  sed -i '/name: VOLUME_CAPACITY/{n;N;d}' ${temp_file}
  sed -i "/name: VOLUME_CAPACITY/a\ \ required: true\n  value: ${PV_SIZE}" ${temp_file}
else
  sed -i '' -e "s/postgresql-persistent/${NEW_TEMPLATE_NAME}/g" ${temp_file}
  sed -i '' -e '/PersistentVolumeClaim/{n;d;}' ${temp_file}
  sed -i '' -e $'s/kind: PersistentVolumeClaim/kind: PersistentVolumeClaim\\\n  metadata:\\\n    annotations:\\\n      volume.beta.kubernetes.io\\/storage-class: '${CSI_DRIVER}'/' ${temp_file}
  sed -i '' -e '/name: VOLUME_CAPACITY/{n;N;d;}' ${temp_file}
  sed -i '' -e $'s/name: VOLUME_CAPACITY/name: VOLUME_CAPACITY\\\n  required: true\\\n  value: '${PV_SIZE}'/' ${temp_file}
fi

oc create -n openshift -f ${temp_file}
