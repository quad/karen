dep 'stage2' do
  dep 'text editor'
end

dep('text editor') { requires dep('vim.managed') }

dep 'stage2.managed' do
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
	'xf86-input-synaptics',
	'xf86-video-intel',
	'xorg-server',
	'xorg-server-utils',
	'xorg-xinit'
  }
  provides []
end
