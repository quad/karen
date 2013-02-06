dep 'initial ramdisk' do
  requires 'configuration.initrd'

  met? {
    log_shell 'Making the initial ramdisk...',
              'mkinitcpio -p linux'
  }
end

dep 'configuration.initrd', :template => 'render' do
  source 'mkinitcpio.conf.erb'
  target '/etc/mkinitcpio.conf'
end
