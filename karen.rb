dep 'bootstrap', :disk do
  disk.default! '/dev/sda'

  requires 'chroot'.with(disk)
end

dep 'chroot', :disk do
  requires 'mounts'

  met? { shell? "arch-chroot /mnt true" }
  meet { log_shell 'Bootstrapping Arch Linux...', 'pacstrap /mnt base base-devel' }
end

dep 'filesystems', :disk do
  requires 'boot.fs'.with(disk)
  requires 'swap.fs'.with(disk)
  requires 'root.fs'.with(disk)
end

dep 'mounts', :disk do
  requires 'filesystems'

  requires 'root.mnt'.with(disk)
  requires 'boot.mnt'.with(disk)
  requires 'swap.mnt'.with(disk)
end

dep 'bootstrap.managed' do
  installs {
    via :pacman,
	'dialog',
	'gptfdisk',
	'syslinux',
	'wireless_tools',
	'wpa_actiond',
	'wpa_supplicant'
  }
  provides []
end

dep 'install.managed' do
  installs {
    via :pacman,
	'alsa-utils',
	'awesome',
	'btrfs-progs',
	'ca-certificates',
	'go',
	'iproute2',
	'mesa',
	'openssh',
	'python',
	'python2',
	'ruby',
	'rxvt-unicode',
	'sudo',
	'surf',
	'tmux',
	'ttf-dejavu',
	'ttf-inconsolata',
	'vim',
	'xf86-input-synaptics',
	'xf86-video-intel',
	'xorg-server',
	'xorg-server-utils',
	'xorg-xinit'
  }
  provides []
end
