meta 'mnt' do
  accepts_value_for :point

  template {
    setup { requires "#{basename}.fs".with(disk) }
    met? { '/etc/mtab'.p.grep /#{point}\b/ }
    meet {
      point.p.mkdir
      shell! "mount /dev/disk/by-label/#{basename} #{point}"
    }
  }
end

dep 'root.mnt', :disk do
  point '/mnt'
end

dep 'boot.mnt', :disk do
  point '/mnt/boot'
end

dep 'swap.mnt', :disk do
  def device
    '/dev/disk/by-label/swap'.p.readlink
  end

  met? { `swapon --show --noheadings --raw` =~ /^#{device}\b/ }
  meet { shell! 'swapon LABEL=swap' }
end
