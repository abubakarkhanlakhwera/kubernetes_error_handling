# Kubernetes Setup Script

This script automates the setup of a Kubernetes environment on an Ubuntu system. It installs and configures the necessary tools and dependencies, including `containerd`, `kubelet`, `kubeadm`, and `kubectl`.

## Features

- Loads required kernel modules for containerd.
- Configures sysctl parameters for Kubernetes networking.
- Installs Docker's container runtime (containerd).
- Sets up Docker's stable repository and installs containerd.
- Configures containerd to use systemd as the cgroup driver.
- Installs Kubernetes components: `kubelet`, `kubeadm`, and `kubectl`.
- Prevents Kubernetes components from being automatically updated.

## Prerequisites

- An Ubuntu-based system (preferably Ubuntu 20.04 or later).
- Root or sudo access to execute system-level commands.

## Usage

1. Clone this repository or download the script to your local machine.

2. Ensure the script has executable permissions:
    ```bash
    chmod +x setup-kubernetes.sh
    ```

3. Run the script with sudo:
    ```bash
    sudo ./setup-kubernetes.sh
    ```

4. Follow any prompts during the installation.

## Important Notes

- The script modifies system configurations, so it should be run with caution, especially on production environments.
- The Kubernetes components (`kubelet`, `kubeadm`, `kubectl`) are marked as held back, preventing them from being automatically updated. To update them manually, remove the hold using:
    ```bash
    sudo apt-mark unhold kubelet kubeadm kubectl
    ```

## Troubleshooting

If you encounter issues, consider the following:

- Ensure your system is up to date with `sudo apt-get update && sudo apt-get upgrade`.
- Verify that all required kernel modules are loaded using `lsmod | grep -e overlay -e br_netfilter`.
- Check containerd and Kubernetes service statuses:
    ```bash
    sudo systemctl status containerd
    sudo systemctl status kubelet
    ```
    # Calico Network Plugin Setup for Kubernetes

This guide explains how to install the Calico network plugin in your Kubernetes cluster using `kubectl`.

## Prerequisites

- A running Kubernetes cluster
- `kubectl` command-line tool installed and configured to interact with your Kubernetes cluster

## Step 1: Install Calico Network Plugin

To install Calico as the network plugin for your Kubernetes cluster, run the following command:

```bash
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.0/manifests/calico.yaml


## License

This project is open-source and available under the MIT License.

## Acknowledgments

- [Docker](https://www.docker.com/)
- [Kubernetes](https://kubernetes.io/)
