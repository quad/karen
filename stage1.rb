dep 'stage1' do
  requires 'hostname'
  requires 'timezone'
  requires 'locale'
  requires 'console font'
  requires 'time adjustment'
  requires 'wifi tools'
  requires 'initial ramdisk'
  requires 'bootloader'
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

dep 'wifi tools' do
  requires 'wifi tools.managed'

  met? { shell? 'systemctl is-enabled net-auto-wireless.service' }
  meet { shell 'systemctl enable net-auto-wireless.service' }
end

dep 'wifi tools.managed' do
  installs {
    via :pacman,
        'dialog',
	'wireless_tools',
	'wpa_actiond',
	'wpa_supplicant'
  }
  provides ['wifi-menu']
end
