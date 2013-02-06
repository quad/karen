dep 'stage1' do
  requires 'hostname'
  requires 'timezone'
  requires 'locale'
  requires 'console font'
  #requires 'initial ramdisk'
  #requires 'bootloader'
  #requires 'root password'
end

dep 'hostname', :failed_crush do
  failed_crush.default! 'karen'

  def content
    "#{failed_crush}\n"
  end

  met? { '/etc/hostname'.p.read == content }
  meet { '/etc/hostname'.p.write content }
end

dep 'timezone', :zone do
  zone.default! 'Asia/Singapore'

  def zoneinfo
    '/usr/share/zoneinfo/' / zone
  end

  met? { '/etc/localtime'.p.readlink == zoneinfo }
  meet { shell "ln -sf '#{zoneinfo}' /etc/localtime" }
end

dep 'console font', :template => 'render' do
  source 'vconsole.conf.erb'
  target '/etc/vconsole.conf'
end

dep 'stage1.managed' do
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
