#!/bin/bash
source .bashrc

# Проверка наличия аргумента
vm_name=$1

# Установка переменных
SSH_PUBLIC_KEY_PATH=/Users/peter/.ssh/yc.pub
YC_CLUSTER=otus-dataproc-cluster
YC_VERSION=2.0
YC_ZONE=ru-central1-a
YC_SUBNET_NAME=otus-dataproc-subnet
YC_BUCKET=otus-dataproc-bucket
YC_SA_NAME=otus-dataproc
YC_SECURITY_GROUP=otus-dataproc-security-group
YC_USER=peter

# Создание виртуальной машины
log "Creating virtual machine..."
yc compute instance create \
    --preemptible \
    --name $vm_name \
    --hostname $vm_name \
    --zone ${YC_ZONE} \
    --memory=2 \
    --cores=2 \
    --create-boot-disk `
        `image-folder-id=standard-images,`
        `image-family=ubuntu-2004-lts,`
        `type=network-hdd,`
        `size=30 \
    --network-interface subnet-name=${YC_SUBNET_NAME},nat-ip-version=ipv4 \
    --service-account-name ${YC_SA_NAME} \
    --metadata serial-port-enable=1 \
    --metadata-from-file user-data=metadata.yaml

log "Virtual machine created successfully!"

# Получение публичного IP-адреса виртуальной машины
log "Getting public IP address of the proxy VM..."
YC_PROXY_VM_PUBLIC_IP=$(
    yc compute instance get $vm_name \
        --format json | jq -r .network_interfaces[0].primary_v4_address.one_to_one_nat.address
)
log "Proxy VM public IP: $YC_PROXY_VM_PUBLIC_IP"

# Копирование SSH-ключа на виртуальную машину
#scp -i ~/.ssh/yc ~/.ssh/yc 130.193.38.234:~/.ssh/yc
#log "INFO": "SSH private key copied to proxy VM successfully!"