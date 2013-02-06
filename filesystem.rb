meta 'fs' do
  accepts_value_for :mkfs
  accepts_value_for :device

  template {
    met? { "/dev/disk/by-label/#{basename}".p.exists? }
    meet {
      shell! "#{mkfs} --label=#{basename} #{device}"
      shell! 'udevadm trigger'
    }
  }
end

dep 'boot.fs', :disk do
  mkfs 'mkfs.btrfs'
  device '/dev/disk/by-partlabel/boot'

  requires 'boot.partition'.with(disk)
end

dep 'swap.fs', :disk do
  mkfs 'mkswap'
  device '/dev/lvm/swap'

  requires 'swap.lv'.with(disk)
end

dep 'root.fs', :disk do
  mkfs 'mkfs.btrfs'
  device '/dev/lvm/root'

  requires 'root.lv'.with(disk)
end

