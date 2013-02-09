dep 'stage2' do
  requires 'power management.stage2'
  requires 'stage2.managed'
end

dep 'power management.stage2' do
  requires dep('power management.managed') {
    installs {
      via :pacman,
      'powertop',
      'laptop-mode-tools'
    }
    provides ['powertop']
  }

  met? { shell? 'systemctl is-enabled laptop-mode.service' }
  meet { shell 'systemctl enable laptop-mode.service' }
end

dep 'stage2.managed' do
  installs {
    via :pacman,
        'vim'
#	'alsa-utils',
#	'awesome',
#	'btrfs-progs',
#	'ca-certificates',
#	'go',
#	'iproute2',
#	'mesa',
#	'openssh',
#	'python',
#	'python2',
#	'ruby',
#	'rxvt-unicode',
#	'sudo',
#	'surf',
#	'tmux',
#	'ttf-dejavu',
#	'ttf-inconsolata',
#	'xf86-input-synaptics',
#	'xf86-video-intel',
#	'xorg-server',
#	'xorg-server-utils',
#	'xorg-xinit'
  }
  provides []
end
