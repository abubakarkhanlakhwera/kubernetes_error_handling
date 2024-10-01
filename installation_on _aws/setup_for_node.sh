#!/bin/bash



# Update the system
echo "Updating package lists..."
apt update -y

# Load necessary kernel modules for containerd
echo "Loading necessary kernel modules..."
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

# Set up required sysctl parameters for Kubernetes networking
echo "Configuring sysctl parameters for Kubernetes networking..."
cat <<EOF | sudo tee /etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sysctl --system

# Install required dependencies
echo "Installing required dependencies..."
apt-get update -y
apt-get install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates

# Add Docker's official GPG key and set up the Docker repository
echo "Setting up Docker repository..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/docker.gpg
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Install containerd and configure it to use systemd as the cgroup driver
echo "Installing and configuring containerd..."
apt-get update -y
apt-get install -y containerd.io
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml

# Restart and enable containerd to apply the new configuration
echo "Restarting containerd service..."
systemctl restart containerd
systemctl enable containerd

# Add Kubernetes apt repository
echo "Setting up Kubernetes repository..."
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Install Kubernetes components
echo "Installing Kubernetes components..."
apt-get update -y
apt-get install -y kubelet kubeadm kubectl

# Prevent Kubernetes components from being automatically updated
apt-mark hold kubelet kubeadm kubectl
