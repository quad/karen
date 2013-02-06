dep 'bootstrap', :disk do
  disk.default! '/dev/sda'

  requires 'stage1.bootstrap'.with(disk)

  met? {
    log_shell 'Running stage1 babushka...',
              "arch-chroot /mnt babushka #{dependency.dep_source.name}:stage1"
  }
end

dep 'stage1.bootstrap', :disk do
  requires 'babushka.bootstrap'.with(disk)

  met? { '/mnt/root/.babushka/sources/karen/.git'.p.dir? }
  meet { shell! "arch-chroot /mnt babushka sources --add #{dependency.dep_source.name} #{dependency.dep_source.uri}" }
end

dep 'babushka.bootstrap', :disk do
  requires 'chroot.bootstrap'.with(disk)

  met? { '/mnt/usr/local/babushka'.p.dir? }
  meet {
    log_shell 'Injecting babushka...',
              'arch-chroot /mnt sh -c "`curl https://babushka.me/up`"'
  }
end

dep 'chroot.bootstrap', :disk do
  requires 'mounts.bootstrap'.with(disk)

  met? { shell? "arch-chroot /mnt true" }
  meet { log_shell 'Bootstrapping Arch Linux...', 'pacstrap /mnt base base-devel' }
end

dep 'filesystems.bootstrap', :disk do
  requires 'boot.fs'.with(disk)
  requires 'swap.fs'.with(disk)
  requires 'root.fs'.with(disk)
end

dep 'mounts.bootstrap', :disk do
  requires 'filesystems.bootstrap'

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
