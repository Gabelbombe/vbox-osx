#!/bin/bash -eux

# set the profile name
VM='macOS'

# set the location where the VM will be created
VM_DIR="${HOME}/VirtualBox VMs/$VM"

# create the VM directory
[ -d ] && rm -fr "$VM_DIR"
mkdir -p "$VM_DIR"

# create an OSX 10.00 El Capitan x64 profile
VBoxManage createvm --register --name "$VM" --ostype MacOS_64

# modify some system settings
VBoxManage modifyvm "$VM" --chipset ich9
VBoxManage modifyvm "$VM" --cpus 2
VBoxManage modifyvm "$VM" --firmware efi
VBoxManage modifyvm "$VM" --memory 4096 --vram 128
VBoxManage modifyvm "$VM" --mouse usbtablet --keyboard usb

# fixes boot order
VBoxManage modifyvm "$VM" --boot1 dvd
VBoxManage modifyvm "$VM" --boot2 disk

# create a new virtual SATA controller,  attach the virtual disk and installation iso
VBoxManage storagectl "$VM" --name "SATA Controller" --add sata --controller IntelAHCI
VBoxManage storageattach "$VM" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "${VM}-Sierra-10.12.vmdk"

# fixes "Stuck on boot: "Missing Bluetooth Controller Transport"
VBoxManage modifyvm "$VM" --cpuidset 00000001 000106e5 00100800 0098e3fd bfebfbff

VBoxManage setextradata "$VM" "VBoxInternal/Devices/efi/0/Config/DmiSystemProduct" "iMac11,3"
VBoxManage setextradata "$VM" "VBoxInternal/Devices/efi/0/Config/DmiSystemVersion" "1.0"
VBoxManage setextradata "$VM" "VBoxInternal/Devices/efi/0/Config/DmiBoardProduct" "Hackintosh"
VBoxManage setextradata "$VM" "VBoxInternal/Devices/smc/0/Config/DeviceKey" "(c)EhimePrefecture"
VBoxManage setextradata "$VM" "VBoxInternal/Devices/smc/0/Config/GetKeyFromRealSMC" 1

# start the VM
VBoxManage startvm "$VM" --type gui
