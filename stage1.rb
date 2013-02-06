dep 'stage1' do
  #requires 'hostname'
  requires 'timezone'
  requires 'locale'
  #requires 'initial ramdisk'
  #requires 'bootloader'
  #requires 'root password'
end

dep 'timezone', :zone do
  zone.default! 'Asia/Singapore'

  def zoneinfo
    '/usr/share/zoneinfo/' / zone
  end

  met? { '/etc/localtime'.p.readlink == zoneinfo }
  meet { shell "ln -sf '#{zoneinfo}' /etc/localtime" }
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
