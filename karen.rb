dep 'bootstrap', :disk do
  disk.default! '/dev/sda'

  requires 'boot.fs'.with(disk)
  requires 'swap.fs'.with(disk)
  requires 'root.fs'.with(disk)
end

meta 'fs' do
  accepts_value_for :mkfs
  accepts_value_for :device

  template {
    def label
      name.gsub /\.fs$/, ''
    end

    met? { shell? "blkid -t LABEL=#{label}" }
    meet { shell! "#{mkfs} --label=#{label} #{device}" }
  }
end

dep 'boot.fs', :disk do
  mkfs 'mkfs.btrfs'
  device `blkid -t PARTLABEL=boot`.split(':').first

  requires 'boot.partition'.with(disk)
end

dep 'swap.fs', :disk do
  mkfs 'mkswap'
  device '/dev/lvm/swap'

  requires 'swap.lv'.with(disk)
end

dep 'root.fs', :disk do
  mkfs 'mkfs.btrfs'
  device '/dev/lvm/root'

  requires 'root.lv'.with(disk)
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
