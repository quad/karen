dep 'stage2' do
  requires 'power management.stage2'
  requires 'time sync.stage2'
  requires dep('vim.managed')
  requires 'X.stage2'
  requires dep('sudo.managed')
end

dep 'power management.stage2' do
  requires dep('power management.managed') {
    installs {
      via :pacman,
      'powertop',
      'laptop-mode-tools',
      'hdparm'
    }
    provides ['powertop', 'laptop_mode']
  }

  met? { shell? 'systemctl is-enabled laptop-mode.service' }
  meet { shell 'systemctl enable laptop-mode.service' }
end

dep 'time sync.stage2' do
  requires 'chrony configuration'

  met? { shell? 'systemctl is-enabled chrony.service' }
  meet { shell 'systemctl enable chrony.service' }
end

dep 'chrony.managed' do
  provides ['chronyc']
end

dep 'chrony configuration', :template => 'render' do
  source 'chrony.conf.erb'
  target '/etc/chrony.conf'
end

dep 'X.stage2', :template => 'managed' do
  installs {
    via :pacman,
	'mesa',
	'ttf-dejavu',
	'ttf-inconsolata',
	'xf86-input-synaptics',
	'xf86-video-intel',
	'xorg-server',
	'xorg-server-utils',
	'xorg-xinit'
  }
  provides ['startx']
end
