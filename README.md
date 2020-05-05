[![Made with Doom Emacs](https://img.shields.io/badge/Made_with-Doom_Emacs-blueviolet.svg?style=flat-square&logo=GNU%20Emacs&logoColor=white)](https://github.com/hlissner/doom-emacs)
[![NixOS 20.03](https://img.shields.io/badge/NixOS-v20.03-blue.svg?style=flat-square&logo=NixOS&logoColor=white)](https://nixos.org)

![Me looking busy](/../screenshots/fluorescence/fakebusy.png?raw=true)

<p align="center">
<span><img src="/../screenshots/fluorescence/desktop.png?raw=true" height="188" /></span>
<span><img src="/../screenshots/fluorescence/rofi.png?raw=true" height="188" /></span>
<span><img src="/../screenshots/fluorescence/tiling.png?raw=true" height="188" /></span>
</p>

# My dotfiles

+ **Operating System:** NixOS
+ **Shell:** zsh + zgen
+ **DM:** lightdm + lightdm-mini-greeter
+ **WM:** bspwm + polybar
+ **Editor:** [Doom Emacs][doom-emacs] (and occasionally [vim][vimrc])
+ **Terminal:** st
+ **Launcher:** rofi
+ **Browser:** firefox
+ **GTK Theme:** [Ant Dracula](https://github.com/EliverLara/Ant-Dracula)
+ **Icon Theme:** [Paper Mono Dark](https://github.com/snwh/paper-icon-theme)

*Works on my machine* ¯\\\_(ツ)_/¯

## Quick start

Set up system:

If on wireless networking:

```sh
sudo su
sudo wpa_supplicant -B -i <WIRELESS_INTERFACE> \
    -c <(wpa_passphrase '<SSID>' '<PASSWORD'>)
```

Set up disk partitioning and mount install environment:

```sh
sudo parted /dev/nvme0n1 -- mklabel gpt
sudo parted /dev/nvme0n1 -- mkpart ESP fat32 1MiB 512MiB
sudo parted /dev/nvme0n1 -- set 1 boot on
sudo parted /dev/nvme0n1 -- mkpart primary linux-swap 512MiB 8512MiB
sudo mkswap /dev/nvme0n1p2
sudo swapon /dev/nvme0n1p2
sudo parted /dev/nvme0n1 -- mkpart primary 8512MiB 100%
sudo pvcreate /dev/nvme0n1p3
sudo vgcreate pool /dev/nvme0n1p3
sudo lvcreate -L 96G -n root pool
sudo lvcreate -L 133G -n home pool
sudo mkfs.ext4 -L root /dev/pool/root
sudo mkfs.ext4 -L home /dev/pool/home
sudo mount /dev/disk/by-label/root /mnt
sudo mkdir -p /mnt/home /mnt/boot
sudo mount /dev/disk/by-label/home /mnt/home
sudo mount /dev/disk/by-label/boot /mnt/boot
```

Install git and make in installer:
```sh
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-channel --update
nix-env -iA nixpkgs.git
nix-env -iA nixpkgs.gnumake
```

```sh
# Assumes your partitions are set up and root is mounted on /mnt
git clone https://github.com/hlissner/dotfiles /etc/dotfiles
make -C /etc/dotfiles install
```

Which is equivalent to:

```sh
USER=${USER:-hlissner}
HOST=${HOST:-kuro}
NIXOS_VERSION=20.03
DOTFILES=/home/$USER/.dotfiles

git clone https://github.com/hlissner/dotfiles /etc/dotfiles
ln -s /etc/dotfiles $DOTFILES
chown -R $USER:users $DOTFILES

# make channels
nix-channel --add "https://nixos.org/channels/nixos-${NIXOS_VERSION}" nixos
nix-channel --add "https://github.com/rycee/home-manager/archive/release-${NIXOS_VERSION}.tar.gz" home-manager
nix-channel --add "https://nixos.org/channels/nixpkgs-unstable" nixpkgs-unstable

# make /etc/nixos/configuration.nix
nixos-generate-config --root /mnt
echo "import /etc/dotfiles \"$$HOST\" \"$$USER\"" >/mnt/etc/nixos/configuration.nix

# make install
nixos-install --root /mnt -I "my=/etc/dotfiles"
```

### Management

+ `make` = `nixos-rebuild test`
+ `make switch` = `nixos-rebuild switch`
+ `make upgrade` = `nix-channel --update && nixos-rebuild switch`
+ `make install` = `nixos-generate-config --root $PREFIX && nixos-install --root
  $PREFIX`
+ `make gc` = `nix-collect-garbage -d` (use sudo to clear system profile)


[doom-emacs]: https://github.com/hlissner/doom-emacs
[vimrc]: https://github.com/hlissner/.vim
