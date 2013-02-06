dep 'volume group.lvm', :disk do
  requires 'format.luks'.with(disk)

  met? { shell? 'lvm vgs lvm' }
  meet { shell! "lvm vgcreate lvm /dev/mapper/luks" }
end

meta 'lv' do
  accepts_value_for :size
  accepts_value_for :extent

  template {
    setup { requires 'volume group.lvm'.with(disk) }
    met? { "/dev/lvm/#{basename}".p.exists? }
    meet {
      lparam = if size
                 "--size #{size}"
               elsif extent
                 "--extent #{extent}"
               else
                 raise 'No size or extent parameter'
               end
      shell "lvm lvcreate #{lparam} --name #{basename} lvm"
    }
  }
end

dep 'swap.lv', :disk do
  size '8G'
end

dep 'root.lv', :disk do
  extent '100%FREE'
end
