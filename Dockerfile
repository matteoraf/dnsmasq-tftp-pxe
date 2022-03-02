# syntax=docker/dockerfile:1
FROM debian:stable-slim

ARG CONFIG_PATH
ARG TFTP_HOST_IP
ARG TFTP_NETWORK

COPY dnsmasq.conf.tpl grub.cfg.tpl boot.cfg.tpl watcher.sh "$CONFIG_PATH"/

# Install and configure grub
RUN \
	# Install Grub Tools and dnsmasq
	apt-get update && apt-get install -y \
    grub-pc-bin \
    dnsmasq \
    # Remove apt cache
	&& rm -rf /var/lib/apt/lists/* \
	# Replace variables in boot.cfg file
	&& sed -e "s/\${TFTP_HOST_IP}/$TFTP_HOST_IP/" "$CONFIG_PATH"/boot.cfg.tpl > "$CONFIG_PATH"/boot.cfg \
	# Create tftp directory structure
	&& grub-mknetdir --net-directory=/tftp --subdir=/boot/grub -d /usr/lib/grub/i386-pc \
	# Rebuild Grub core image with embedded config
	&& grub-mkimage -O i386-pc-pxe -o /tftp/boot/grub/i386-pc/core.0 --config=$CONFIG_PATH/boot.cfg -p '(tftp,$TFTP_HOST_IP)/boot/grub' pxe tftp \
	# Replace variables in dnsmasq and grub config giles
	&& sed -e "s/\${TFTP_NETWORK}/$TFTP_NETWORK/" -e "s/\${TFTP_HOST_IP}/$TFTP_HOST_IP/" "$CONFIG_PATH"/dnsmasq.conf.tpl > /etc/dnsmasq.conf \
	&& sed -e "s/\${TFTP_HOST_IP}/$TFTP_HOST_IP/" "$CONFIG_PATH"/grub.cfg.tpl > /tftp/boot/grub/grub.cfg

# Copy images to tftp dir
COPY vmlinuz* initrd* /tftp/boot/
#COPY memtest* /tftp/boot/

#####
EXPOSE 67/udp
EXPOSE 68/udp

ENTRYPOINT ["dnsmasq", "-k", "--log-facility=-"]