# Disable DNS Server
# Listen on this specific port instead of the standard DNS port
# (53). Setting this to zero completely disables DNS function,
# leaving only DHCP and/or TFTP.
port=0
 
# Enable DHCP logging
log-dhcp
 
# Respond to PXE requests for the specified network;
# run as DHCP proxy
dhcp-range=${TFTP_NETWORK},proxy
dhcp-option=pxe,66,"${TFTP_HOST_IP}"

# Set the boot filename for netboot/PXE. You will only need
# this if you want to boot machines over the network and you will need
# a TFTP server; either dnsmasq's built-in TFTP server or an
# external one. (See below for how to enable the TFTP server.)
#dhcp-boot=pxelinux.0
# The same as above, but use custom tftp-server instead machine running dnsmasq
#dhcp-boot=pxelinux,server.name,192.168.1.100
#dhcp-boot=booti386,,10.0.15.159
#dhcp-boot=boot/grub/i386-pc/core.0,,10.0.15.159
#pxe-service=X86PC, "Boot BIOS PXE", booti386 

pxe-service=X86PC, "Boot BIOS PXE", boot/grub/i386-pc/core.0  

#--enable tftp service
enable-tftp

#-- Root folder for tftp 
tftp-root=/tftp