#!/bin/bash
sudo apt install nfs-kernel-server -y
sudo mkdir -p /data/nfs
sudo chown nobody:nogroup /data/nfs/
sudo chmod 777 /data/nfs/
echo "/data/nfs 192.168.2.103(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports > /dev/null
sudo exportfs -a
sudo systemctl restart nfs-kernel-server
sudo ufw allow from 0.0.0.0/0 to any port nfs
showmount -e 


kubectl create namespace nfs-provisioner

helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
helm repo update
helm install nfs-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
    --set nfs.server=XXX \
    --set nfs.path=/data/nfs \
    --set storageClass.name=cluster-nfs \
    --set storageClass.accessModes=ReadWriteOnce \
    --namespace nfs-provisioner \
    --create-namespace




cat << EOF | kubectl apply -f -
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: test-claim
spec:
  storageClassName: cluster-nfs
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Mi
EOF

kubectl delete pvc test-claim