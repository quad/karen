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
