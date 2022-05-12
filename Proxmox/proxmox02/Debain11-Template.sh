# Set this to your Proxmox host name; it's case sensitive!
export ProxmoxHost="proxmox02"
# Set this to the correct network bridge; for most people it should be vmbr0.
export ProxmoxNetworkBridge="vmbr0"
# Set the name of the Storage Volume for Proxmox
export ProxmoxStorageVolume="datastore02"
# Set the name of the Storage Volume Path
export ProxmoxStoragePath="/mnt/pve/${ProxmoxStorageVolume}/"
# Set this to the Virtual Machine ID you want to set your template to.
export VMID="9100"
# Set the default Disk Size
export DiskSize="16"
# VM Template Name
export TEMPLATE_NAME="Debian11-Template"
# Set your SSH PublicKey
export SSHPUBKEY=""
# Set your qcow2 Disk Image Path
export DiskPath="/home/project/templates/debian/debian11"
# Set your Template Cloud-Init user name
export TemplateUser="debian"

# Create your VM Template
pvesh create /nodes/${ProxmoxHost}/qemu \
    --serial0=socket --vga=serial0 \
    --boot=c --agent=1 \
    --bootdisk=scsi0 \
    --net0='model=e1000,bridge='${ProxmoxNetworkBridge}'' \
    --ide2=${ProxmoxStorageVolume}:cloudinit \
    --sockets=1 --cores=2 --memory=2048 \
    -scsihw='virtio-scsi-pci' \
    --ostype=l26 --numa 0 \
    --template=1 \
    --name=${TEMPLATE_NAME} \
    --vmid=${VMID}

# Ensure that `jq` is installed on your system
#sudo apt install jq -y

# Import the disk image
qm importdisk ${VMID} ${DiskPath} ${ProxmoxStorageVolume} -f qcow2

# Mount the disk image and set the Cloud-Init settings
pvesh set /nodes/${ProxmoxHost}/qemu/${VMID}/config \
    --scsi0=${ProxmoxStorageVolume}:${VMID}/vm-${VMID}-disk-0.qcow2 \
    -ipconfig0='ip=dhcp' \
    --ciuser="${TemplateUser}" \
    --sshkeys="$(printf %s "${SSHPUBKEY}" | jq -sRr @uri)"

# Set the boot drive size
pvesh set /nodes/${ProxmoxHost}/qemu/${VMID}/resize \
    -disk=scsi0 --size="${DiskSize}G"