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
