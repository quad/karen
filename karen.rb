dep 'bootstrap', :disk do
  disk.default! '/dev/sda'

  requires 'boot.fs'.with(disk)
end

meta 'fs' do
  accepts_value_for :block_device
  accepts_value_for :partition
  accepts_value_for :mkfs

  template {
    def label
      name.gsub /\.fs$/, ''
    end

    def device
      "#{block_device}#{partition}"
    end

    setup { requires 'partition.bootstrap'.with(disk) }
    met? { shell? "blkid -t LABEL=#{label}" }
    meet { shell! "#{mkfs} --label=#{label} #{device}" }
  }
end

dep 'boot.fs', :disk do
  block_device disk
  partition 1
  mkfs 'mkfs.btrfs'
end

dep 'partition.bootstrap', :disk do
  def labels
    %w(boot swap root)
  end

  def parttab
    dependency.load_path.parent / 'parttab'
  end

  met? { shell? labels.map { |l| "blkid -t PARTLABEL=#{l}" }.join ' && ' }
  meet {
    parttab.readlines.each { |l| shell! "sgdisk #{l.chomp} #{disk}" }
  }
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
