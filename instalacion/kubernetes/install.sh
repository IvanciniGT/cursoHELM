# docker
sudo sed -i 's/--containerd=\/run\/containerd\/containerd.sock/--containerd=\/run\/containerd\/containerd.sock  --exec-opt native.cgroupdriver=systemd/' \ 
    /lib/systemd/system/docker.service    
cat  /lib/systemd/system/docker.service
sudo systemctl daemon-reload
sudo systemctl restart docker
systemctl status docker

# Desactivar swap
sudo swapoff -a
sudo sed -i "s/\/var\/swapfile/#\/var\/swapfile/" /etc/fstab

# Instalacion de kubernetes
# Alta del repo de kubernetes en apt
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo touch /etc/apt/sources.list.d/kubernetes.list
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update -y

# Instalamos kubeadm
sudo apt-get install kubeadm -y

# Crear cluster kubernetes
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

# De la propia del programa anterior, copiar y ejecutar:
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Montar la red provada del cluster
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

# Activar autocompletado de kubectl desde la terminal
source <(kubectl completion bash) # setup autocomplete in bash into the current shell, bash-completion package should be installed first.
echo "source <(kubectl completion bash)" >> ~/.bashrc # add autocomplete permanently to your bash shell.

# Quitar el taint master al nodo principal para que nos deje instalar cosas...
kubectl taint nodes --all node-role.kubernetes.io/master-
