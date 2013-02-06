dep 'stage1' do
  requires 'hostname'
  requires 'timezone'
  requires 'locale'
  requires 'console font'
  requires 'time adjustment'
  requires 'initial ramdisk'
  requires 'bootloader'
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

dep 'time adjustment' do
  met? { '/etc/adjtime'.p.exists? }
  meet { shell 'hwclock --systohc --utc' }
end

dep 'bootloader' do
  requires 'bootloader.managed'
  requires 'configuration.bootloader'

  met? { shell 'syslinux-install_update -i -a -m' }
end

dep 'configuration.bootloader', :template => 'render' do
  source 'syslinux.cfg.erb'
  target '/boot/syslinux/syslinux.cfg'
end

dep 'bootloader.managed' do
  installs {
    via :pacman, 'gptfdisk', 'syslinux'
  }
  provides ['syslinux-install_update']
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
