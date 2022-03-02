<div id="top"></div>


<br />
<h3 align="center">Proxmox + ZFS - PXE Booting with GRUB for BIOS systems</h3>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#env-variables">ENV VARIABLES</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

This is a Docker container I put together after writing this post on [Reddit](https://www.reddit.com/r/homelab/comments/st3bji/proxmox_zfs_pxe_booting_with_grub_for_bios_systems/).

The reason I built this is to be able to boot my Gen8 HP Servers running Proxmox, because the HP RAID cards, when in HBA mode (which is needed to pass over disks to ZFS), do not make disks available to the Bootloader and thus you are not allowed to boot from your local zfs pool.

It serves as a quick method to get a proxyDHCP up and running with dnsmasq and its own tftp server in order to serve GRUB and boot Proxmox over your network.


<p align="right">(<a href="#top">back to top</a>)</p>


<!-- GETTING STARTED -->
## Getting Started

Usage is very simple

Follow along the next steps to get it running.

### Prerequisites

I have this running on a Synology NAS, but it can be used anywhere as long as you have a Docker instance running.

### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/matteoraf/dnsmasq-tftp-pxe.git
   ```
2. Edit the .env file and adjust the variables according to your network.

3. Follow the guide on [Reddit](https://www.reddit.com/r/homelab/comments/st3bji/proxmox_zfs_pxe_booting_with_grub_for_bios_systems/) to get your kernel and initial ramdisk images and the grub.cfg file and put them in the same folder of the Dockerfile

4. Adjust your grub.cfg file according to the guide but, instead of manually writing your server IP address in the file, use the `${TFTP_HOST_IP}` variable. 
This way, in case you need to change the address of your TFTP server, you will just need to change it in the .env file and rebuild the container.
Rename the file to `grub.cfg.tpl` and put it together with the kernel and initrd images.
You can see the file included with this repo and use it as a sample to understand how to edit it, but I recommend to use your own and adapt it.

5. Spin up your container
   ```sh
   docker-compose up -d
   ```

6. You're done

7. Side note: if you also want memtest86+ available, you should adjust the `/etc/grub.d/20_memtest86+` section of the grub.cfg file with the same principles (edit all the `set root` commands to point towards your tftp server) and copy over the memtest binaries as well.
In this case, you will also need to edit your `Dockerfile` by uncommenting [line 30](https://github.com/matteoraf/dnsmasq-tftp-pxe/blob/main/Dockerfile#L30) or, even better, add `memtest*` in the existing [COPY command on line 29](https://github.com/matteoraf/dnsmasq-tftp-pxe/blob/main/Dockerfile#L29).

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- ENV VARIABLES -->
## Env Variables

The directory where we will temporarily copy our config and template files into the container
```
CONFIG_PATH=/config
```

The Physical interface of your host, it's needed to set up the macvlan network
```
HOST_PARENT_INTERFACE=eth0
```

The Subnet where our container will serve its content (Use CIDR notation)
```
TFTP_SUBNET=10.0.15.0/24
```

Same as the Subnet above but without the mask
```
TFTP_NETWORK=10.0.15.0
```

The existing network gateway
```
TFTP_SUBNET_GATEWAY=10.0.15.1
```
The IP address of the Container
```
TFTP_HOST_IP=10.0.15.254
```


<p align="right">(<a href="#top">back to top</a>)</p>