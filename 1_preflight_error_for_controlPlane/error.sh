#!/bin/bash

# Stop Kubernetes services if they are running
echo "Stopping kubelet and Docker services..."
sudo systemctl stop kubelet
sudo systemctl stop docker

# Reset kubeadm if there was a previous initialization
echo "Resetting kubeadm to clean up any previous cluster..."
sudo kubeadm reset -f

# Check and kill processes using the specified ports
echo "Killing processes using Kubernetes-related ports..."

# Port 6443
PID_6443=$(sudo lsof -t -i :6443)
if [ ! -z "$PID_6443" ]; then
    sudo kill -9 $PID_6443
    echo "Killed process on port 6443"
fi

# Port 10259
PID_10259=$(sudo lsof -t -i :10259)
if [ ! -z "$PID_10259" ]; then
    sudo kill -9 $PID_10259
    echo "Killed process on port 10259"
fi

# Port 10257
PID_10257=$(sudo lsof -t -i :10257)
if [ ! -z "$PID_10257" ]; then
    sudo kill -9 $PID_10257
    echo "Killed process on port 10257"
fi

# Port 10250
PID_10250=$(sudo lsof -t -i :10250)
if [ ! -z "$PID_10250" ]; then
    sudo kill -9 $PID_10250
    echo "Killed process on port 10250"
fi

# Port 2379
PID_2379=$(sudo lsof -t -i :2379)
if [ ! -z "$PID_2379" ]; then
    sudo kill -9 $PID_2379
    echo "Killed process on port 2379"
fi

# Port 2380
PID_2380=$(sudo lsof -t -i :2380)
if [ ! -z "$PID_2380" ]; then
    sudo kill -9 $PID_2380
    echo "Killed process on port 2380"
fi

# Remove existing Kubernetes manifest files
echo "Removing existing Kubernetes manifest files..."
sudo rm -rf /etc/kubernetes/manifests/

# Remove etcd data directory if it exists
echo "Removing existing etcd data directory..."
sudo rm -rf /var/lib/etcd/

# Initialize the Kubernetes cluster
echo "Initializing the Kubernetes cluster..."
sudo kubeadm init --control-plane-endpoint=""

# Configure kubectl for the non-root user
echo "Setting up kubeconfig for the user..."
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Display networking setup message
echo "To setup networking, run the following command:"
echo "kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.0/manifests/calico.yaml"

echo "Script execution completed."
